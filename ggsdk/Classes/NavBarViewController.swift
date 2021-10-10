//
//  NavBarViewController.swift
//  ggsdk
//
//  Created by lenbo lan on 2021/9/28.
//

import UIKit

import BUAdSDK

class NavBarViewController: UINavigationController {
    
    private var splashAdView: BUSplashAdView?
    private var adState = ""
    
    private var curAdIndex = 0
    private var isRepeat = 0
    
    private var curAdId = "" // 当前广告id
    private var curAdOpenTime = 0 // 当前广告打开时间
    private var curAdStartLoadTime = 0 //当前广告开始加载时间
    private var curAdDataLoadedTime = 0 //当前广告数据加载完成时间
    private var curAdVideoLoadedTime = 0 // 当前广告视频加载完成时间
    private var curAdShowTime = 0 // 当前展示时间
    private var curAdClickTime = 0 // 用户第1次点击时间
    private var curAdJumpTime = 0 // 用户点击跳过时间
//    private var curAdCloseTime = 0 // 用户关闭时间

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    func setObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(openBUSplashAd),
                                               name: NSNotification.Name(NotiName.openBUSplashAd.rawValue),
                                               object: nil)
    }
    
    @objc
    private func openBUSplashAd() {
        view.makeToast("开始加载广告...")
        if let slotid = UserDefaults.localData.keyBU_SplashSlotID.storedString {
            if adState == "" {
                adState = "loading"
                
                createAdId()
                
                splashAdView = BUSplashAdView(slotID: slotid, frame: UIScreen.main.bounds)
                splashAdView?.delegate = self
                splashAdView?.loadAdData()
                self.view.addSubview(splashAdView!)
                splashAdView?.rootViewController = self
                
                curAdStartLoadTime = Date.getStamp()
                rAdStart(.bu, .splash, adId: curAdId)
                
            } else {
                view.makeToast("广告加载中...")
            }
        } else {
            view.makeToast("广告参数加载失败...")
        }
    }
    
    private func createAdId() {
        curAdIndex += 1
        let createTime = Date.getStamp()
        let uid = UserDefaults.localData.keyUID.storedInt
        let str = String.randomStr(len: 6)
        curAdId = "\(uid)_1_\(curAdIndex)_\(createTime)_\(str)"
    }

}

extension NavBarViewController: BUSplashAdDelegate {
    
    // MARK: - BUSplashAdDelegate
    
    func splashAdDidLoad(_ splashAd: BUSplashAdView) {
        Log.debug("广告加载成功回调")
        curAdVideoLoadedTime = Date.getStamp()
        rAdLoaded(.bu, .splash, adId: curAdId, loadedTime: curAdVideoLoadedTime)
    }
    
    func splashAd(_ splashAd: BUSplashAdView, didFailWithError error: Error?) {
        Log.debug("广告出错")
        if let err = error {
            view.makeToast("广告出错：\(err.localizedDescription)")
            // ad report
            rAdError(.bu, .splash, err.localizedDescription, adId: curAdId)
        }
        splashAdView?.removeFromSuperview()
        adState = ""
    }
    
    func splashAdWillVisible(_ splashAd: BUSplashAdView) {
        Log.debug("SDK渲染开屏广告即将展示")
        curAdShowTime = Date.getStamp()
        rAdShow(.bu, .splash, adId: curAdId, loadedTime: curAdVideoLoadedTime)
        NotificationCenter.default.post(name: NSNotification.Name(NotiName.BUSplashAdShow.rawValue), object: nil)
    }
    
    func splashAdDidClickSkip(_ splashAd: BUSplashAdView) {
        Log.debug("用户点击跳过按钮时会触发此回调")
        
        // ad report
//        rJumpAd(.bu, .splash)
        curAdJumpTime = Date.getStamp()
    }
    
    func splashAdDidCloseOtherController(_ splashAd: BUSplashAdView, interactionType: BUInteractionType) {
        Log.debug("此回调在广告跳转到其他控制器时")
        splashAdView?.removeFromSuperview()
        adState = ""
        
        // ad report
//        rCloseAd(.bu, .splash)
    }
    
    func splashAdWillClose(_ splashAd: BUSplashAdView) {
        Log.debug("SDK渲染开屏广告即将关闭回调")
    }
    
    func splashAdCountdown(toZero splashAd: BUSplashAdView) {
        Log.debug("倒计时为0时会触发此回调")
        splashAdView?.removeFromSuperview()
        adState = ""
    }
    
    func splashAdDidClick(_ splashAd: BUSplashAdView) {
        Log.debug("SDK渲染开屏广告点击回调")
        
        // ad report
        rAdClick(.bu, .splash, adId: curAdId, showTime: curAdShowTime, isRepeat: isRepeat)
        isRepeat = 1
        
        NotificationCenter.default.post(name: NSNotification.Name(NotiName.BUSplashAdClick.rawValue), object: nil)
    }
    
    func splashAdDidClose(_ splashAd: BUSplashAdView) {
        Log.debug("SDK渲染开屏广告关闭回调")
        splashAdView?.removeFromSuperview()
        adState = ""
        
        // ad report
        rAdClose(.bu, .splash, adId: curAdId, openTime: curAdStartLoadTime, startLoadTime: curAdStartLoadTime, dataLoadedTime: curAdVideoLoadedTime, videoLoadedTime: curAdVideoLoadedTime, showTime: curAdShowTime, clickTime: curAdClickTime, jumpTime: curAdJumpTime)
        
        NotificationCenter.default.post(name: NSNotification.Name(NotiName.BUSplashAdClose.rawValue), object: nil)
    }
    
}
