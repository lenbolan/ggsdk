import UIKit

import BUAdSDK

class BUBannerViewController: BaseViewController {
    
    private var bannerView: BUNativeExpressBannerView?
    
//    MARK: - UIKIT

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkIsLoadNext()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        bannerView?.removeFromSuperview()
        bannerView = nil
        
        if curAdShowTime > 0 {
            rAdClose(.bu, .banner, adId: curAdId, openTime: curAdRequestTime, startLoadTime: curAdRequestTime, dataLoadedTime: curAdLoadedTime, videoLoadedTime: curAdLoadedTime, showTime: curAdShowTime, clickTime: curAdClickTime, jumpTime: 0)
        }
    }
    
//    MARK: - LOGIC
    
    override func checkIsLoadNext() {
        super.checkIsLoadNext()
        
        if bannerView == nil && recordTime <= 0 {
            addBannerAd()
        }
    }
    
    override func checkTodayTimes() {
        super.checkTodayTimes()
        
        limitWatchTimes = UserDefaults.localData.keyBannerLimitWatchTimes.storedInt
        limitClickTimes = UserDefaults.localData.keyBannerLimitClickTimes.storedInt
        curWatchTimes = UserDefaults.localData.keyBannerWatchTimes.storedInt
        curClickTimes = UserDefaults.localData.keyBannerClickTimes.storedInt
    }
    
    
    private func createAdId() {
        createAdId(adType: 2)
    }
    
    private func addBannerAd() {
        guard doCheck() else {
            if bannerView != nil {
                bannerView?.removeFromSuperview()
                bannerView = nil
            }
            return
        }
        
        if let bannerSlotID = UserDefaults.localData.keyBU_BannerSlotID.storedString {
            createAdId()
            
            let wei = Util.screenWidth
            let hei = wei / 2
            
            labelAdTip.text = "广告加载中..."
            
            resetTimeData()
            
            curAdRequestTime = Date.getStamp()
            
            bannerView = BUNativeExpressBannerView(slotID: bannerSlotID,
                                                   rootViewController: self,
                                                   adSize: CGSize(width: wei,
                                                                  height: hei))
            
            bannerView?.frame = CGRect(x: 0, y: 0, width: wei, height: hei)
            bannerView?.delegate = self
            bannerView?.loadAdData()
            
            rAdStart(.bu, .banner, adId: curAdId)
        } else {
            labelAdTip.text = "获取参数失败..."
        }
    }

}

// MARK: - BUNativeExpressBannerViewDelegate
extension BUBannerViewController: BUNativeExpressBannerViewDelegate {
    func nativeExpressBannerAdViewDidLoad(_ bannerAdView: BUNativeExpressBannerView) {
        Log.debug("加载成功回调")
        isRepeat = 0
        labelAdTip.text = "数据加载成功"
        createAdId()
        curAdLoadedTime = Date.getStamp()
        rAdLoaded(.bu, .banner, adId: curAdId, loadedTime: curAdLoadedTime)
    }
    
    func nativeExpressBannerAdView(_ bannerAdView: BUNativeExpressBannerView, didLoadFailWithError error: Error?) {
        Log.debug("failed with \(String(describing: error?.localizedDescription))")
        labelAdTip.text = "广告加载失败：\(error?.localizedDescription ?? "")"
        rAdError(.bu, .banner, error?.localizedDescription ?? "", adId: curAdId)
    }
    
    func nativeExpressBannerAdViewRenderSuccess(_ bannerAdView: BUNativeExpressBannerView) {
        Log.debug("渲染成功回调")
        labelAdTip.text = "广告渲染成功"
        // 展示Banner广告
        adPlaceHolder.addSubview(bannerView!)
    }
    
    func nativeExpressBannerAdViewRenderFail(_ bannerAdView: BUNativeExpressBannerView, error: Error?) {
        Log.debug("渲染失败")
        labelAdTip.text = "渲染失败"
    }
    
    func nativeExpressBannerAdViewWillBecomVisible(_ bannerAdView: BUNativeExpressBannerView) {
        Log.debug("当显示新的广告时调用此方法")
        curAdShowTime = Date.getStamp()
        curWatchTimes += 1
        updateText()
        UserDefaults.localData.keyBannerWatchTimes.store(value: curWatchTimes)
        rAdShow(.bu, .banner, adId: curAdId, loadedTime: curAdLoadedTime)
    }
    
    func nativeExpressBannerAdViewDidClick(_ bannerAdView: BUNativeExpressBannerView) {
        Log.debug("点击回调")
        curAdClickTime = Date.getStamp()
        rAdClick(.bu, .banner, adId: curAdId, showTime: curAdShowTime, isRepeat: isRepeat)
        if isRepeat == 0 {
            curClickTimes += 1
            UserDefaults.localData.keyBannerClickTimes.store(value: curClickTimes)
        }
        isRepeat = 1
        updateText()
    }
    
    func nativeExpressBannerAdView(_ bannerAdView: BUNativeExpressBannerView, dislikeWithReason filterwords: [BUDislikeWords]?) {
        Log.debug("dislike回调方法")
        // 移除广告
        bannerView?.removeFromSuperview()
        bannerView = nil
    }
    
    func nativeExpressBannerAdViewDidCloseOtherController(_ bannerAdView: BUNativeExpressBannerView, interactionType: BUInteractionType) {
        Log.debug("此回调在广告跳转到其他控制器时")
        startInterval()
    }
}
