import UIKit

class GDTSignInViewController: BaseSignInViewController {
    
    private var rewardVideoAd:GDTRewardVideoAd!
    
    
    override func updateViewData() {
        super.updateViewData()
        
        UserDefaults.localData.keyRewardWatchTimes_GDT.store(value: curWatchTimes)
    }
    
    private func requestRewardedVideoAd() {
        rewardVideoAd = nil
        isAdLoaded = false
        
        if let gdtAppID = UserDefaults.localData.keyGDT_AppID.storedString,
           let rewardAdId = UserDefaults.localData.keyGDT_RewardSlotID.storedString {
            createAdId()
            labelAdTip.text = "广告初始化中..."
            GDTSDKConfig.registerAppId(gdtAppID)
            self.rewardVideoAd = GDTRewardVideoAd.init(placementId: rewardAdId)
            self.rewardVideoAd.videoMuted = false
            self.rewardVideoAd.delegate = self
            resetTimeData()
            curAdStartLoadTime = Date.getStamp()
            rAdStart(.gdt, .reward, adId: curAdId)
            self.rewardVideoAd.load()
        } else {
            labelAdTip.text = "初始化失败..."
        }
    }
    
    override func checkTodayTimes() {
        super.checkTodayTimes()
        
        curWatchTimes = UserDefaults.localData.keyRewardWatchTimes_GDT.storedInt
        curClickTimes = UserDefaults.localData.keyRewardClickTimes_GDT.storedInt
    }
    
    override func onTapAdButton(_ btn: YuanButton) {
        adErrTip = ""
        createAdId()
        if isAdLoaded {
            curAdOpenTime = Date.getStamp()
            rAdOpen(.gdt, .reward, adId: curAdId)
            rewardVideoAd.show(fromRootViewController: self)
        } else {
            if gotoWatchAd == false {
                gotoWatchAd = true
                curAdOpenTime = Date.getStamp()
                rAdOpen(.gdt, .reward, adId: curAdId)
                if rewardVideoAd != nil {
                    labelAdTip.text = "加载广告中..."
                    resetTimeData()
                    curAdStartLoadTime = Date.getStamp()
                    rAdStart(.gdt, .reward, adId: curAdId)
                    self.rewardVideoAd.load()
                } else {
                    labelAdTip.text = "开始初始化广告..."
                    requestRewardedVideoAd()
                }
            }
        }
    }

}

extension GDTSignInViewController: GDTRewardedVideoAdDelegate {
    func gdt_rewardVideoAdVideoDidLoad(_ rewardedVideoAd: GDTRewardVideoAd) {
        Log.debug("视频文件加载成功，激励视频数据下载成功回调，已经下载过的视频会直接回调")
        if (self.rewardVideoAd.expiredTimestamp <= Int(Date.init().timeIntervalSince1970)) {
            Log.debug("广告已过期，请重新拉取")
            labelAdTip.text = "广告已过期，请重新拉取"
            return
        }
        if (!self.rewardVideoAd.isAdValid) {
            Log.debug("广告失效，请重新拉取")
            labelAdTip.text = "广告失效，请重新拉取"
            return
        }
        
        labelAdTip.text = "广告加载成功"
        isAdLoaded = true
        curAdVideoLoadedTime = Date.getStamp()
        rAdLoaded(.gdt, .reward, adId: curAdId, loadedTime: curAdVideoLoadedTime)
        if gotoWatchAd {
            gotoWatchAd = false
            rewardedVideoAd.show(fromRootViewController: self)
        }
    }
    
    func gdt_rewardVideoAdDidLoad(_ rewardedVideoAd: GDTRewardVideoAd) {
        Log.debug("激励视频广告加载广告数据成功回调")
        curAdDataLoadedTime = Date.getStamp()
        labelAdTip.text = "即将加载视频..."
    }
    
    func gdt_rewardVideoAdWillVisible(_ rewardedVideoAd: GDTRewardVideoAd) {
        Log.debug("激励视频播放页即将展示回调")
    }
    
    func gdt_rewardVideoAdDidExposed(_ rewardedVideoAd: GDTRewardVideoAd) {
        Log.debug("激励视频广告曝光回调")
        rAdShow(.gdt, .reward, adId: curAdId, loadedTime: curAdVideoLoadedTime)
        curAdShowTime = Date.getStamp()
    }
    
    func gdt_rewardVideoAdDidClose(_ rewardedVideoAd: GDTRewardVideoAd) {
        Log.debug("激励视频广告播放页关闭回调")
        labelAdTip.text = ""
        updateViewData()
        startInterval()
        rAdClose(.gdt, .reward, adId: curAdId, openTime: curAdOpenTime, startLoadTime: curAdStartLoadTime, dataLoadedTime: curAdDataLoadedTime, videoLoadedTime: curAdVideoLoadedTime, showTime: curAdShowTime, clickTime: curAdClickTime, jumpTime: curAdJumpTime)
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
        curAdJumpTime = 1
//        curAdCloseTime = 0
    }
    
    func gdt_rewardVideoAdDidClicked(_ rewardedVideoAd: GDTRewardVideoAd) {
        Log.debug("激励视频广告信息点击回调")
        var isRepeat = 1
        if curAdIndex != curAdClick {
            curAdClick = curAdIndex
            curClickTimes += 1
            UserDefaults.localData.keyRewardClickTimes_GDT.store(value: curClickTimes)
            isRepeat = 0
            curAdClickTime = Date.getStamp()
        }
        rAdClick(.gdt, .reward, adId: curAdId, showTime: curAdShowTime, isRepeat: isRepeat)
    }
    
    func gdt_rewardVideoAd(_ rewardedVideoAd: GDTRewardVideoAd, didFailWithError error: Error) {
        Log.debug("激励视频广告各种错误信息回调, \(error.localizedDescription)")
        gotoWatchAd = false
        labelAdTip.text = "广告加载失败，\(error.localizedDescription)"
        
        let code = (error as NSError).code
        if (code == 4014) {
            Log.debug("请拉取到广告后再调用展示接口")
            labelAdTip.text = "请拉取到广告后再调用展示接口"
        } else if (code == 5012) {
            Log.debug("广告已过期")
            labelAdTip.text = "广告已过期"
        } else if (code == 4015) {
            Log.debug("广告已经播放过，请重新拉取")
            labelAdTip.text = "广告已经播放过，请重新拉取"
        } else if (code == 5002) {
            Log.debug("视频下载失败")
            labelAdTip.text = "视频下载失败"
        } else if (code == 5003) {
            Log.debug("视频播放失败")
            labelAdTip.text = "视频播放失败"
        } else if (code == 5004) {
            Log.debug("没有合适的广告");
            labelAdTip.text = "没有合适的广告"
        }
        adErrTip = "广告加载错误，"
        startInterval()
        rAdError(.gdt, .reward, error.localizedDescription, adId: curAdId)
    }
    
    func gdt_rewardVideoAdDidRewardEffective(_ rewardedVideoAd: GDTRewardVideoAd, info: [AnyHashable : Any]) {
        Log.debug("激励视频广告播放达到激励条件回调，以此回调作为奖励依据")
        curAdJumpTime = 0
    }
    
    func gdt_rewardVideoAdDidPlayFinish(_ rewardedVideoAd: GDTRewardVideoAd) {
        Log.debug("激励视频广告播放完成回调")
    }
}
