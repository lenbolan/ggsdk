//
//  BaseViewController.swift
//  ggsdk
//
//  Created by lenbo lan on 2021/10/5.
//

import UIKit

class BaseViewController: UIViewController {
    
    var adPlaceHolder: UIView!
    
    var intervalTimer: Timer?
    
    var limitWatchTimes = 0
    var limitClickTimes = 0
    var curWatchTimes = 0
    var curClickTimes = 0
    
    var rndTimeMin = 0  // 下次可点间隔时间 min
    var rndTimeMax = 0  // 下次可点间隔时间 max
    var recordTime = 0  // 倒计时
    
    var curAdId = ""
    var curAdIndex = 0
    
    var curAdRequestTime = 0 // 广告请求时间
    var curAdLoadedTime = 0 // 广告加载完成时间
    var curAdShowTime = 0 // 广告展示时间
    var curAdClickTime = 0 // 广告点击时间
    
    var isRepeat = 0
    
    var labelWatchTip: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(hexString: "#464547")
        return label
    }()
    
    var labelDownTip: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(hexString: "#464547")
        return label
    }()
    
    var labelIntro: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    var labelAdTip: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(hexString: "#CC2233")
        return label
    }()
    
    let cover: UIView = {
        let uiview = UIView()
        uiview.backgroundColor = UIColor(r: 255, g: 103, b: 103, a: 0.77)
        uiview.isUserInteractionEnabled = true
        uiview.isHidden = true
        return uiview
    }()
    
    let cdbg:UIView = {
        let uiview = UIView()
        uiview.backgroundColor = .white
        uiview.setCornerRadius(8)
        return uiview
    }()
    
    let lbMainTip: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 64, weight: .bold)
        label.text = ""
        return label
    }()
    
    let lbSubTip: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = ""
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkTodayTimes()

        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if recordTime > 0 && intervalTimer == nil {
            intervalTimer = Timer.scheduledTimer(timeInterval: 1,
                                                 target: self,
                                                 selector: #selector(onIntervalTimer),
                                                 userInfo: nil,
                                                 repeats: true)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        intervalTimer?.invalidate()
//        intervalTimer = nil
    }
    
    func configUI() {
        view.backgroundColor = .white
        
        adPlaceHolder = UIView()
        
        view.addSubview(adPlaceHolder)
        view.addSubview(labelWatchTip)
        view.addSubview(labelDownTip)
        view.addSubview(labelIntro)
        view.addSubview(labelAdTip)
        view.addSubview(cover)
        cover.addSubview(cdbg)
        cdbg.addSubview(lbMainTip)
        cdbg.addSubview(lbSubTip)
        
        adPlaceHolder.backgroundColor = .clear
        adPlaceHolder.anchor(top: view.guide.topAnchor, left: view.leftAnchor, bottom: view.guide.bottomAnchor, right: view.rightAnchor, paddingTop: 65, paddingLeft: 0, paddingBottom: 162, paddingRight: 0, width: 0, height: 0)
        
        cover.anchor(top: adPlaceHolder.topAnchor, left: adPlaceHolder.leftAnchor, bottom: adPlaceHolder.bottomAnchor, right: adPlaceHolder.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        cdbg.anchor(top: nil, left: cover.leftAnchor, bottom: nil, right: cover.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, width: 0, height: 160)
        cdbg.centerYAnchor.constraint(equalTo: cover.centerYAnchor).isActive = true
        
        lbMainTip.anchor(top: nil, left: cdbg.leftAnchor, bottom: nil, right: cdbg.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 80)
        lbMainTip.centerYAnchor.constraint(equalTo: cover.centerYAnchor).isActive = true
        
        lbSubTip.anchor(top: nil, left: cdbg.leftAnchor, bottom: cdbg.bottomAnchor, right: cdbg.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 0, height: 20)
        
//        cover.isHidden = false
        
        labelAdTip.anchor(top: nil, left: view.leftAnchor, bottom: view.guide.bottomAnchor, right: view.rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 0, height: 20)
        
        labelIntro.anchor(top: nil, left: view.leftAnchor, bottom: labelAdTip.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 42)
        
        labelDownTip.anchor(top: nil, left: view.leftAnchor, bottom: labelIntro.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        
        labelWatchTip.anchor(top: nil, left: view.leftAnchor, bottom: labelDownTip.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        
        updateText()
        
        labelIntro.text = "说明：可观看和已观看，可下载和已下载的数字不对等的记为违规无效!"
    }
    
    func checkTodayTimes() {
        rndTimeMin = UserDefaults.localData.keyRandomTimeMin.storedInt
        rndTimeMax = UserDefaults.localData.keyRandomTimeMax.storedInt
    }
    
    func updateText() {
        let strTip1 = "今日需观看(\(limitWatchTimes))，已观看(\(curWatchTimes))"
        let strTip2 = "今日需下载(\(limitClickTimes))，已下载(\(curClickTimes))"
        
        labelWatchTip.attributedText = setAttributedText(txt: strTip1, num1: limitWatchTimes, num2: curWatchTimes)
        labelDownTip.attributedText = setAttributedText(txt: strTip2, num1: limitClickTimes, num2: curClickTimes)
    }
    
    func checkState() -> (Int, String, Bool) {
        var watchState = 0
        var watchStateStr = "未完成"
        if curWatchTimes > limitWatchTimes {
            watchState = 2
            watchStateStr = "已超过"
        } else if curWatchTimes == limitWatchTimes {
            watchState = 1
            watchStateStr = "完成"
        }
        var clickState = 0
        var clickStateStr = "未完成"
        if curClickTimes > limitClickTimes {
            clickState = 20
            clickStateStr = "已超过"
        } else if curClickTimes == limitClickTimes {
            clickState = 10
            clickStateStr = "完成"
        }
        let adState = watchState + clickState
        let strState = "观看\(watchStateStr)，下载\(clickStateStr)"
        
        return (adState, strState, adState == 0)
    }
    
    func doCheck() -> Bool {
        let adState = checkState()
        
        if adState.0 == 11 {
            cover.isHidden = false
            lbMainTip.text = "已完成"
            lbMainTip.textColor = .green
        } else if adState.0 > 0 {
            cover.isHidden = false
            lbMainTip.text = "未完成"
            lbMainTip.textColor = .red
            lbSubTip.text = adState.1
        }
        
        return adState.2
    }
    
    func startInterval() {
        intervalTimer?.invalidate()
        intervalTimer = nil
        
        guard doCheck() else {
            return
        }
        
        recordTime = randomNum(min: rndTimeMin, max: rndTimeMax)
        lbMainTip.text = "\(recordTime)"
        cover.isHidden = false
        intervalTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onIntervalTimer), userInfo: nil, repeats: true)
    }
    
    @objc
    func onIntervalTimer() {
        recordTime -= 1
        if (recordTime <= 0) {
            intervalTimer?.invalidate()
            intervalTimer = nil
            
            cover.isHidden = true
            
            checkIsLoadNext()
        }
        lbMainTip.text = "\(recordTime)"
    }
    
    func checkIsLoadNext() {
        
    }
    
    func createAdId(adType: Int) {
        curAdIndex += 1
        let createTime = Date.getStamp()
        let uid = UserDefaults.localData.keyUID.storedInt
        let str = String.randomStr(len: 6)
        curAdId = "\(uid)_\(adType)_\(curAdIndex)_\(createTime)_\(str)"
    }
    
    func resetTimeData() {
        curAdRequestTime = 0
        curAdLoadedTime = 0
        curAdShowTime = 0
        curAdClickTime = 0
    }

}
