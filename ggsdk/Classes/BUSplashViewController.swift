import UIKit

import Alamofire
import Alamofire_SwiftyJSON
import SwiftyJSON

class BUSplashViewController: BaseViewController, UITextViewDelegate {
    
    private var txtIntro: UITextView = {
        let txt = UITextView()
        txt.isEditable = false
        txt.isScrollEnabled = false
        txt.isUserInteractionEnabled = true
        return txt
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onSplashShow),
                                               name: NSNotification.Name(NotiName.BUSplashAdShow.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onSplashClick),
                                               name: NSNotification.Name(NotiName.BUSplashAdClick.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onSplashClose),
                                               name: NSNotification.Name(NotiName.BUSplashAdClose.rawValue),
                                               object: nil)
    }
    
    override func configUI() {
        let btnSplash = createBtn(title: "必点+下载", tag: 0)
        let btnLogout = createBtn(title: "退出登录", tag: 1)
        
        view.addSubview(btnSplash)
        view.addSubview(btnLogout)
        
        btnSplash.anchor(top: view.guide.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 120, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 35)
        btnSplash.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        super.configUI()
        adPlaceHolder.isHidden = true
        
        view.addSubview(txtIntro)
        txtIntro.anchor(top: nil, left: view.leftAnchor, bottom: labelAdTip.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        btnLogout.anchor(top: nil, left: nil, bottom: labelWatchTip.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 100, height: 35)
        btnLogout.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setClearAndLogout()
    }
    
    private func setClearAndLogout() {
        let strTip = "说明：点击进入后未下载的记为违规无效"
        
        let hRange = NSRange(location: 0, length: strTip.count)
        let range = NSRange(location: 9, length: 2)
        let mutableStr = NSMutableAttributedString(string: strTip)
        mutableStr.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 17), range: hRange)
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        mutableStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: hRange)
        mutableStr.addAttribute(NSAttributedString.Key.link, value: "myapp://", range: range)
        
        txtIntro.linkTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.darkGray]
        txtIntro.textColor = UIColor.darkGray
        txtIntro.delegate = self
        txtIntro.attributedText = mutableStr
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard doCheck() else {
            return
        }
        
        if autoSplashShow == 0 {
            autoSplashShow = 1
            NotificationCenter.default.post(name: NSNotification.Name(NotiName.openBUSplashAd.rawValue), object: nil)
        }
    }
    
    @objc
    private func onSplashShow() {
        if Thread.isMainThread {
            onShow()
        } else {
            DispatchQueue.main.async {
                self.onShow()
            }
        }
    }
    
    private func onShow() {
        curWatchTimes += 1
        updateText()
        UserDefaults.localData.keySplashWatchTimes.store(value: curWatchTimes)
    }
    
    @objc
    private func onSplashClick() {
        if Thread.isMainThread {
            onClick()
        } else {
            DispatchQueue.main.async {
                self.onClick()
            }
        }
    }
    
    private func onClick() {
        curClickTimes += 1
        updateText()
        UserDefaults.localData.keySplashClickTimes.store(value: curClickTimes)
    }
    
    @objc
    private func onSplashClose() {
        if Thread.isMainThread {
            onClose()
        } else {
            DispatchQueue.main.async {
                self.onClose()
            }
        }
    }
    
    private func onClose() {
        startInterval()
    }
    
    override func checkTodayTimes() {
        super.checkTodayTimes()
        
        limitWatchTimes = UserDefaults.localData.keySplashLimitWatchTimes.storedInt
        limitClickTimes = UserDefaults.localData.keySplashLimitClickTimes.storedInt
        curWatchTimes = UserDefaults.localData.keySplashWatchTimes.storedInt
        curClickTimes = UserDefaults.localData.keySplashClickTimes.storedInt
    }
    
    private func createBtn(title: String, tag: Int) -> UIButton {
        let btn = UIButton()
        btn.cornerRadius = 8
        btn.borderWith = 1
        btn.borderColor = .gray
        btn.tag = tag
        btn.setTitleColor(.gray, for: .normal)
        btn.setTitle(title, for: .normal)
        btn.addTarget(self, action: #selector(onBtnTap(_:)), for: .touchUpInside)
        return btn
    }
    
    @objc private func onBtnTap(_ sender: UIButton) {
        if sender.tag == 0 {
            onBtnTap1()
        } else if sender.tag == 1 {
            onBtnTap2()
        }
    }
    
    private func onBtnTap1() {
        NotificationCenter.default.post(name: NSNotification.Name(NotiName.openBUSplashAd.rawValue), object: nil)
    }
    
    private func onBtnTap2() {
        let token = UserDefaults.localData.keyToken.storedString
        let parameters = ["token": token]
        Alamofire.request(adLogout, method: .post, parameters: parameters).responseJSON { response in
            Log.debug(response)
            if let data = response.data {
                let json = JSON(data)
                if json["code"].int == 0 {
                    
                }
            }
        }
        UserDefaults.localData.keyAccount.store(value: "")
        NotificationCenter.default.post(name: NSNotification.Name(NotiName.exitAdPages.rawValue), object: nil)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if URL.scheme == "myapp" {
            Util.clearAllUserDefaultsData()
            if Thread.isMainThread {
                abort()
            } else {
                DispatchQueue.main.async {
                    abort()
                }
            }
        }
        return true
    }

}
