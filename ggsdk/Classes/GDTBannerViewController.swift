import UIKit

import GDT

class GDTBannerViewController: BaseViewController {
    
    private var bannerView: GDTUnifiedBannerView?
    
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
            rAdClose(.gdt, .banner, adId: curAdId, openTime: curAdRequestTime, startLoadTime: curAdRequestTime, dataLoadedTime: curAdLoadedTime, videoLoadedTime: curAdLoadedTime, showTime: curAdShowTime, clickTime: curAdClickTime, jumpTime: 0)
        }
    }
    
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
        curWatchTimes = UserDefaults.localData.keyBannerWatchTimes_GDT.storedInt
        curClickTimes = UserDefaults.localData.keyBannerClickTimes_GDT.storedInt
    }
    
    
    private func createAdId() {
        createAdId(adType: 2)
    }
    
    private func addBannerAd() {
        guard doCheck() else {
            bannerView?.removeFromSuperview()
            bannerView = nil
            return
        }
        
        if let gdtAppID = UserDefaults.localData.keyGDT_AppID.storedString,
           let bannerSlotID = UserDefaults.localData.keyGDT_BannerSlotID.storedString {
            
            createAdId()
            
            GDTSDKConfig.registerAppId(gdtAppID)
            
            labelAdTip.text = "广告加载中..."
            
            if bannerView == nil {
                resetTimeData()
                curAdRequestTime = Date.getStamp()
                
                let rect = CGRect(origin: CGPoint(x: 0, y: 80), size: CGSize(width: 375, height: 60))
                bannerView = GDTUnifiedBannerView(frame: rect, placementId: bannerSlotID, viewController: self)
                bannerView?.autoSwitchInterval = 0
                bannerView?.delegate = self
                
                adPlaceHolder.addSubview(bannerView!)
                bannerView?.loadAdAndShow()
                
                rAdStart(.gdt, .banner, adId: curAdId)
            }
            
        } else {
            labelAdTip.text = "获取参数失败..."
        }
    }
    
}

extension GDTBannerViewController: GDTUnifiedBannerViewDelegate {
    func unifiedBannerViewDidLoad(_ unifiedBannerView: GDTUnifiedBannerView) {
        Log.debug("请求广告条数据成功后调用")
        isRepeat = 0
        labelAdTip.text = "数据加载成功"
        createAdId()
        curAdLoadedTime = Date.getStamp()
        rAdLoaded(.gdt, .banner, adId: curAdId, loadedTime: curAdLoadedTime)
    }
    func unifiedBannerViewFailed(toLoad unifiedBannerView: GDTUnifiedBannerView, error: Error) {
        Log.debug("请求广告条数据失败后调用, "+error.localizedDescription)
        labelAdTip.text = "广告加载失败：\(error.localizedDescription)"
        rAdError(.gdt, .banner, error.localizedDescription, adId: curAdId)
    }
    func unifiedBannerViewWillExpose(_ unifiedBannerView: GDTUnifiedBannerView) {
        Log.debug("banner曝光回调")
        labelAdTip.text = "广告渲染成功"
        curAdShowTime = Date.getStamp()
        curWatchTimes += 1
        updateText()
        UserDefaults.localData.keyBannerWatchTimes_GDT.store(value: curWatchTimes)
        rAdShow(.gdt, .banner, adId: curAdId, loadedTime: curAdLoadedTime)
    }
    func unifiedBannerViewClicked(_ unifiedBannerView: GDTUnifiedBannerView) {
        Log.debug("banner点击回调")
        curAdClickTime = Date.getStamp()
        rAdClick(.gdt, .banner, adId: curAdId, showTime: curAdShowTime, isRepeat: isRepeat)
        if isRepeat == 0 {
            curClickTimes += 1
            UserDefaults.localData.keyBannerClickTimes_GDT.store(value: curClickTimes)
        }
        isRepeat = 1
        updateText()
    }
    func unifiedBannerViewWillPresentFullScreenModal(_ unifiedBannerView: GDTUnifiedBannerView) {
        Log.debug("banner广告点击以后即将弹出全屏广告页")
    }
    func unifiedBannerViewDidPresentFullScreenModal(_ unifiedBannerView: GDTUnifiedBannerView) {
        Log.debug("banner广告点击以后弹出全屏广告页完毕")
    }
    func unifiedBannerViewWillDismissFullScreenModal(_ unifiedBannerView: GDTUnifiedBannerView) {
        Log.debug("全屏广告页即将被关闭")
    }
    func unifiedBannerViewDidDismissFullScreenModal(_ unifiedBannerView: GDTUnifiedBannerView) {
        Log.debug("全屏广告页已经被关闭")
        startInterval()
    }
    func unifiedBannerViewWillLeaveApplication(_ unifiedBannerView: GDTUnifiedBannerView) {
        Log.debug("当点击应用下载或者广告调用系统程序打开")
    }
    func unifiedBannerViewWillClose(_ unifiedBannerView: GDTUnifiedBannerView) {
        Log.debug("banner被用户关闭时调用")
    }
}
