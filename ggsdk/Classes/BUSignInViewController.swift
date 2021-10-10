import UIKit
import BUAdSDK

class BUSignInViewController: BaseSignInViewController {
    
    private var rewardedVideo: BURewardedVideoAd!
    
    override func updateViewData() {
        super.updateViewData()
        
        if curAdJumpTime <= 0 {
            UserDefaults.localData.keyRewardWatchTimes.store(value: curWatchTimes)
        }
    }
    
    private func requestRewardedVideoAd() {
        rewardedVideo = nil
        isAdLoaded = false
        
        if let rewardAdId = UserDefaults.localData.keyBU_RewardSlotID.storedString {
            
            createAdId()
            
            let appId = BUAdSDKManager.appID()
            
            let rewardModel = BURewardedVideoModel.init()
            
            Log.debug("BU AppId: \(appId ?? ""), reward slot id: \(rewardAdId)")
            labelAdTip.text = "广告初始化中..."
            
            resetTimeData()
            curAdStartLoadTime = Date.getStamp()
            
            rewardedVideo = BURewardedVideoAd.init(slotID: rewardAdId, rewardedVideoModel: rewardModel)
            rewardedVideo.delegate = self
            
            rAdStart(.bu, .reward, adId: curAdId)
            rewardedVideo.loadData()
        } else {
            labelAdTip.text = "初始化失败..."
        }
    }
    
    override func checkTodayTimes() {
        super.checkTodayTimes()
        
        curWatchTimes = UserDefaults.localData.keyRewardWatchTimes.storedInt
        curClickTimes = UserDefaults.localData.keyRewardClickTimes.storedInt
    }
    
    override func onTapAdButton(_ btn: YuanButton) {
        adErrTip = ""
        createAdId()
        if isAdLoaded {
            curAdOpenTime = Date.getStamp()
            rAdOpen(.bu, .reward, adId: curAdId)
            rewardedVideo.show(fromRootViewController: self)
        } else {
            if gotoWatchAd == false {
                gotoWatchAd = true
                curAdOpenTime = Date.getStamp()
                rAdOpen(.bu, .reward, adId: curAdId)
                if rewardedVideo != nil {
                    labelAdTip.text = "加载广告中..."
                    rAdStart(.bu, .reward, adId: curAdId)
                    curAdStartLoadTime = Date.getStamp()
                    rewardedVideo.loadData()
                } else {
                    labelAdTip.text = "开始初始化广告..."
                    requestRewardedVideoAd()
                }
            }
        }
    }

}

// MARK: - BURewardedVideoAdDelegate
extension BUSignInViewController: BURewardedVideoAdDelegate {
    func rewardedVideoAdDidLoad(_ rewardedVideoAd: BURewardedVideoAd) {
        Log.debug("广告素材物料加载成功")
        curAdDataLoadedTime = Date.getStamp()
    }
    
    func rewardedVideoAdVideoDidLoad(_ rewardedVideoAd: BURewardedVideoAd) {
        Log.debug("视频下载成功")
        labelAdTip.text = "广告加载成功"
        isAdLoaded = true
        curAdVideoLoadedTime = Date.getStamp()
        rAdLoaded(.bu, .reward, adId: curAdId, loadedTime: curAdVideoLoadedTime)
        if gotoWatchAd {
            gotoWatchAd = false
            rewardedVideoAd.show(fromRootViewController: self)
        }
    }
    
    func rewardedVideoAdWillVisible(_ rewardedVideoAd: BURewardedVideoAd) {
//        广告将要展示
    }
    
    func rewardedVideoAdDidVisible(_ rewardedVideoAd: BURewardedVideoAd) {
//        广告已展示
        rAdShow(.bu, .reward, adId: curAdId, loadedTime: curAdVideoLoadedTime)
        curAdShowTime = Date.getStamp()
    }
    
    func rewardedVideoAdWillClose(_ rewardedVideoAd: BURewardedVideoAd) {
//        广告将关闭
    }
    
    func rewardedVideoAdDidClose(_ rewardedVideoAd: BURewardedVideoAd) {
//        广告已关闭，广告展示后重新加载广告
        labelAdTip.text = ""
        updateViewData()
        startInterval()
        rAdClose(.bu, .reward, adId: curAdId, openTime: curAdOpenTime, startLoadTime: curAdStartLoadTime, dataLoadedTime: curAdDataLoadedTime, videoLoadedTime: curAdVideoLoadedTime, showTime: curAdShowTime, clickTime: curAdClickTime, jumpTime: curAdJumpTime)
        resetTimeRecords()
        requestRewardedVideoAd()
    }
    
    private func resetTimeRecords() {
        curAdId = ""
        curAdOpenTime = 0
        curAdStartLoadTime = 0
        curAdDataLoadedTime = 0
        curAdVideoLoadedTime = 0
        curAdShowTime = 0
        curAdClickTime = 0
        curAdJumpTime = 0
//        curAdCloseTime = 0
    }
    
    func rewardedVideoAdDidClick(_ rewardedVideoAd: BURewardedVideoAd) {
//        用户点击广告
        var isRepeat = 1
        if curAdIndex != curAdClick {
            curAdClick = curAdIndex
            curClickTimes += 1
            UserDefaults.localData.keyRewardClickTimes.store(value: curClickTimes)
            isRepeat = 0
            curAdClickTime = Date.getStamp()
        }
        rAdClick(.bu, .reward, adId: curAdId, showTime: curAdShowTime, isRepeat: isRepeat)
    }
    
    func rewardedVideoAdDidClickSkip(_ rewardedVideoAd: BURewardedVideoAd) {
//        用户点击跳过
        curAdJumpTime = Date.getStamp()
//        rAdJump(.bu, .reward)
    }
    
    func rewardedVideoAd(_ rewardedVideoAd: BURewardedVideoAd, didFailWithError error: Error?) {
        Log.debug("加载失败, failed with \(String(describing: error?.localizedDescription))")
        gotoWatchAd = false
        labelAdTip.text = "广告加载失败|\(error?.localizedDescription ?? "")"
        adErrTip = "广告加载错误，"
        startInterval()
        rAdError(.bu, .reward, error?.localizedDescription ?? "", adId: curAdId)
    }
}
