//
//  BaseSignInViewController.swift
//  ggsdk
//
//  Created by lenbo lan on 2021/10/5.
//

import UIKit

class BaseSignInViewController: BaseViewController, AdButtonDelegate {
    
    let numBtnWidth:CGFloat = 60
    let numSpace:CGFloat = 8
    let numColumn:CGFloat = 3
    let numRow:CGFloat = 5
    
    var gotoWatchAd = false
    var isAdLoaded = false
    
    var phaseOneNum = 0 // 分段，最后4个可点位放最后，用于机器操作
    
    // 去重
    var curAdClick = 0 // 当前点击的广告索引
    
    var curAdOpenTime = 0 // 当前广告打开时间
    var curAdStartLoadTime = 0 //当前广告开始加载时间
    var curAdDataLoadedTime = 0 //当前广告数据加载完成时间
    var curAdVideoLoadedTime = 0 // 当前广告视频加载完成时间
//    var curAdClickTime = 0 // 用户第1次点击时间
    var curAdJumpTime = 0 // 用户点击跳过时间
    var curAdCloseTime = 0 // 用户关闭时间
    
    var adErrTip = ""
    
    var btns = [YuanButton]()
    
    let container: UIView = {
        let uiview = UIView()
        uiview.layer.cornerRadius = 8
        uiview.backgroundColor = UIColor(hexString: "#ff6767")
        return uiview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = doCheck()
    }
    
    override func configUI() {
        var ui_width:CGFloat = 0
        var ui_height:CGFloat = 0
        var ui_padding:CGFloat = 0
        
        view.addSubview(container)
        ui_width = numColumn * numBtnWidth + (numColumn + 1) * numSpace
        ui_height = numRow * numBtnWidth + (numRow + 1) * numSpace
        ui_padding = (Util.screenWidth - ui_width) * 0.5
        container.anchor(top: view.guide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 85, paddingLeft: ui_padding, paddingBottom: 0, paddingRight: ui_padding, width: ui_width, height: ui_height)
        
        addBtns()
        
        super.configUI()
        adPlaceHolder.isHidden = true
    }
    
    func addBtns() {
        for child in container.subviews {
            child.removeFromSuperview()
        }
        btns.removeAll()
        
        var markNum = 0
        
        let numTotal = Int(numColumn * numRow)
        for i in 0..<numTotal {
            let column = i % Int(numColumn)
            let row = Int(i / Int(numColumn))
            let _x = numSpace + (CGFloat(column) * (numBtnWidth + numSpace))
            let _y = numSpace + (CGFloat(row) * (numBtnWidth + numSpace))
            let btn = YuanButton(frame: CGRect(x: _x,
                                             y: _y,
                                             width: 60,
                                             height: 60))
            btn.layer.cornerRadius = 5
            btn.backgroundColor = .white
            if i < curWatchTimes && i < phaseOneNum {
                btn.setImage(UIImage(named: btn.disableMark), for: .normal)
                btn.isEnabled = false
                markNum += 1
            } else if i < phaseOneNum {
                btn.setImage(UIImage(named: btn.defaultmark), for: .normal)
                btn.delegate = self
            } else if i >= numTotal - 4 {
                if markNum < curWatchTimes {
                    btn.setImage(UIImage(named: btn.disableMark), for: .normal)
                    btn.isEnabled = false
                    markNum += 1
                } else {
                    btn.setImage(UIImage(named: btn.defaultmark), for: .normal)
                    btn.delegate = self
                }
            } else {
                btn.setImage(UIImage(named: btn.unableMark), for: .normal)
                btn.isEnabled = false
            }
            btn.tag = i
            container.addSubview(btn)
        }
    }
    
    func onTapAdButton(_ btn: YuanButton) {
        
    }
    
    override func checkTodayTimes() {
        super.checkTodayTimes()
        
        limitWatchTimes = UserDefaults.localData.keyRewardLimitWatchTimes.storedInt
        limitClickTimes = UserDefaults.localData.keyRewardLimitClickTimes.storedInt
        
        if limitWatchTimes >= 4 {
            phaseOneNum = limitWatchTimes - 4
        }
    }
    
    func createAdId() {
        createAdId(adType: 4)
    }
    
    func updateViewData() {
        curWatchTimes += 1
        addBtns()
        updateText()
    }

}
