import UIKit

import SwiftHEXColors

class GDTFlowViewController: BaseViewController {
    
    private var expressAdView: GDTNativeExpressAdView!
    private var nativeExpressAd: GDTNativeExpressAd!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkIsLoadNext()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        expressAdView?.removeFromSuperview()
        expressAdView = nil
        
        nativeExpressAd = nil
        
        if curAdShowTime > 0 {
            rAdClose(.gdt, .flow, adId: curAdId, openTime: curAdRequestTime, startLoadTime: curAdRequestTime, dataLoadedTime: curAdLoadedTime, videoLoadedTime: curAdLoadedTime, showTime: curAdShowTime, clickTime: curAdClickTime, jumpTime: 0)
        }
    }
    
    override func checkIsLoadNext() {
        super.checkIsLoadNext()
        
        if expressAdView == nil && recordTime <= 0 {
            loadAd()
        }
    }
    
    override func checkTodayTimes() {
        super.checkTodayTimes()
        
        limitWatchTimes = UserDefaults.localData.keyFlowLimitWatchTimes.storedInt
        limitClickTimes = UserDefaults.localData.keyFlowLimitClickTimes.storedInt
        curWatchTimes = UserDefaults.localData.keyFlowWatchTimes_GDT.storedInt
        curClickTimes = UserDefaults.localData.keyFlowClickTimes_GDT.storedInt
    }
    
    private func createAdId() {
        createAdId(adType: 3)
    }
    
    private func loadAd() {
        guard doCheck() else {
            return
        }
        
        if let gdtAppID = UserDefaults.localData.keyGDT_AppID.storedString,
           let flowSlotID = UserDefaults.localData.keyGDT_FlowSlotID.storedString {
            
            createAdId()
            
            labelAdTip.text = "广告加载中..."
            
            resetTimeData()
            curAdRequestTime = Date.getStamp()
            
            GDTSDKConfig.registerAppId(gdtAppID)
            
            nativeExpressAd = GDTNativeExpressAd(placementId: flowSlotID, adSize: CGSize(width: Util.screenWidth, height: 50))
            nativeExpressAd.delegate = self
            nativeExpressAd.load(1)
            
            rAdStart(.gdt, .flow, adId: curAdId)
        } else {
            labelAdTip.text = "获取参数失败..."
        }
    }

}

extension GDTFlowViewController: GDTNativeExpressAdDelegete {
    func nativeExpressAdSuccess(toLoad nativeExpressAd: GDTNativeExpressAd!, views: [GDTNativeExpressAdView]!) {
        Log.debug("nativeExpressAdSuccess, \(views.count)")
        labelAdTip.text = "广告加载成功"
        if views.count > 0 {
            expressAdView = views[0]
            adPlaceHolder.addSubview(expressAdView)
            expressAdView.controller = self
            expressAdView.render()
            
            curAdLoadedTime = Date.getStamp()
            rAdLoaded(.gdt, .flow, adId: curAdId, loadedTime: curAdLoadedTime)
        }
    }
    
    func nativeExpressAdViewRenderSuccess(_ nativeExpressAdView: GDTNativeExpressAdView!) {
        Log.debug("nativeExpressAdViewRenderSuccess")
    }
    
    func nativeExpressAdViewExposure(_ nativeExpressAdView: GDTNativeExpressAdView!) {
        labelAdTip.text = "广告渲染成功"
        curAdShowTime = Date.getStamp()
        curWatchTimes += 1
        updateText()
        UserDefaults.localData.keyFlowWatchTimes_GDT.store(value: curWatchTimes)
        rAdShow(.gdt, .flow, adId: curAdId, loadedTime: curAdLoadedTime)
    }
    
    func nativeExpressAdFail(toLoad nativeExpressAd: GDTNativeExpressAd!, error: Error!) {
        Log.debug("nativeExpressAdFail, " + error.debugDescription)
        labelAdTip.text = "广告加载失败：\(error.localizedDescription)"
        rAdError(.gdt, .flow, error.localizedDescription, adId: curAdId)
    }
    
    func nativeExpressAdViewRenderFail(_ nativeExpressAdView: GDTNativeExpressAdView!) {
        Log.debug("nativeExpressAdViewRenderFail")
    }
    
    func nativeExpressAdViewClicked(_ nativeExpressAdView: GDTNativeExpressAdView!) {
        curAdClickTime = Date.getStamp()
        rAdClick(.gdt, .flow, adId: curAdId, showTime: curAdShowTime, isRepeat: isRepeat)
        if isRepeat == 0 {
            curClickTimes += 1
            UserDefaults.localData.keyFlowClickTimes_GDT.store(value: curClickTimes)
        }
        isRepeat = 1
        updateText()
    }
}
