import UIKit

import Alamofire
import SwiftyJSON

class RegistViewController: UIViewController {
    
    private let lbTitle: UILabel = {
        let lb = UILabel()
        lb.text = "注册"
        lb.textColor = .white
        lb.font = UIFont.systemFont(ofSize: 42, weight: .bold)
        return lb
    }()
    
    private let lbSubtitle: UILabel = {
        let lb = UILabel()
        lb.text = "Welcome"
        lb.textColor = .white
        lb.font = UIFont.systemFont(ofSize: 36)
        return lb
    }()
    
    private let lbPhone: UILabel = {
        let lb = UILabel()
        lb.text = "手机号"
        lb.textColor = .darkGray
        lb.font = UIFont.systemFont(ofSize: 17)
        return lb
    }()
    
    private let txtPhone: UITextField = {
        let txt = UITextField()
        txt.placeholder = "请输入手机号"
        txt.keyboardType = .phonePad
        return txt
    }()
    
    private let lbPwd: UILabel = {
        let lb = UILabel()
        lb.text = "密码"
        return lb
    }()
    
    private let txtPwd: UITextField = {
        let txt = UITextField()
        txt.placeholder = "请输入密码"
        txt.isSecureTextEntry = true
        return txt
    }()
    
    private let lbPwd2: UILabel = {
        let lb = UILabel()
        lb.text = "确认密码"
        return lb
    }()
    
    private let txtPwd2: UITextField = {
        let txt = UITextField()
        txt.placeholder = "请再次输入密码"
        txt.isSecureTextEntry = true
        return txt
    }()
    
    private let btnRegist: UIButton = {
        let btn = UIButton()
        btn.setTitle("注  册", for: .normal)
        btn.backgroundColor = UIColor(hexString: "#FF6767")
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        btn.setCornerRadius(20)
        return btn
    }()
    
    private let btnToLogin: UIButton = {
        let btn = UIButton()
        
        var attributedString = NSMutableAttributedString(string: "已有账号？前往登录")
        var range = NSRange()
        range.location = 7
        range.length = 2
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.gray], range: NSRange(location: 0, length: 7))
        attributedString.addAttributes([NSAttributedString.Key.link : "account://"], range: range)
        
        btn.setAttributedTitle(attributedString, for: .normal)
        
        return btn
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let bg = UIImageView()
        bg.frame = view.frame
        bg.image = UIImage(named: "yky_bg")
        bg.contentMode = .scaleAspectFit
        
        view.addSubview(bg)
        
        view.addSubview(lbTitle)
        view.addSubview(lbSubtitle)
        view.addSubview(lbPhone)
        view.addSubview(txtPhone)
        view.addSubview(lbPwd)
        view.addSubview(txtPwd)
        view.addSubview(lbPwd2)
        view.addSubview(txtPwd2)
        view.addSubview(btnRegist)
        view.addSubview(btnToLogin)
        
        lbTitle.anchor(top: view.guide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 70, paddingLeft: 40, paddingBottom: 0, paddingRight: 0, width: Util.screenWidth-80, height: 44)
        lbSubtitle.anchor(top: lbTitle.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 40, paddingBottom: 0, paddingRight: 0, width: Util.screenWidth-80, height: 44)
        lbPhone.anchor(top: lbSubtitle.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 85, paddingLeft: 40, paddingBottom: 0, paddingRight: 0, width: Util.screenWidth-80, height: 20)
        txtPhone.anchor(top: lbPhone.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 40, paddingBottom: 0, paddingRight: 0, width: Util.screenWidth-80, height: 24)
        lbPwd.anchor(top: txtPhone.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 25, paddingLeft: 40, paddingBottom: 0, paddingRight: 0, width: Util.screenWidth-80, height: 20)
        txtPwd.anchor(top: lbPwd.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 40, paddingBottom: 0, paddingRight: 0, width: Util.screenWidth-80, height: 24)
        lbPwd2.anchor(top: txtPwd.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 25, paddingLeft: 40, paddingBottom: 0, paddingRight: 0, width: Util.screenWidth-80, height: 20)
        txtPwd2.anchor(top: lbPwd2.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 40, paddingBottom: 0, paddingRight: 0, width: Util.screenWidth-80, height: 24)
        btnRegist.anchor(top: txtPwd2.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 40, paddingBottom: 0, paddingRight: 0, width: Util.screenWidth-80, height: 40)
        btnToLogin.anchor(top: btnRegist.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 20)
        btnToLogin.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(tapG:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        btnRegist.addTarget(self, action: #selector(onTapRegist), for: .touchUpInside)
        btnToLogin.addTarget(self, action: #selector(onTapToLogin), for: .touchUpInside)
        
        setKefuUI()
    }
    
    private func setKefuUI() {
        let btnKefu = createKefuBtn(img: "yky_kefu", title: "咨询客服")
        let btnDianhua = createKefuBtn(img: "yky_phone", title: "拨打电话")
        
        view.addSubview(btnKefu)
        view.addSubview(btnDianhua)
        
        let btn_weith = (Util.screenWidth - 60) / 2
        btnKefu.anchor(top: nil, left: view.leftAnchor, bottom: view.guide.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 15, paddingBottom: 15, paddingRight: 0, width: btn_weith, height: 55)
        btnDianhua.anchor(top: nil, left: nil, bottom: view.guide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 15, paddingRight: 15, width: btn_weith, height: 55)
        
        btnKefu.addTarget(self, action: #selector(onTapKefu), for: .touchUpInside)
        btnDianhua.addTarget(self, action: #selector(onTapDianhua), for: .touchUpInside)
    }
    
    @objc
    private func onTapKefu() {
        
    }
    
    @objc
    private func onTapDianhua() {
        onTapPhoneCall()
    }
    
    override func viewDidLayoutSubviews() {
        addBottomBorder(txtPhone)
        addBottomBorder(txtPwd)
        addBottomBorder(txtPwd2)
    }
    
    private func addBottomBorder(_ txt: UITextField) {
        let btmBorder = CALayer()
        btmBorder.backgroundColor = UIColor.gray.cgColor
        btmBorder.frame = CGRect(x: 0, y: txt.frame.size.height-1, width: txt.frame.size.width, height: 1)
        txt.layer.addSublayer(btmBorder)
    }
    
    @objc
    private func hideKeyboard(tapG: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc
    private func onTapRegist() {
        guard let phone = txtPhone.text, phone.isPhone() else {
            view.makeToast("请输入有效的手机号码")
            return
        }
        guard let pwd = txtPwd.text, pwd.count > 5 && pwd.count < 21 else {
            view.makeToast("密码长度为6至20之间")
            return
        }
        guard let pwd2 = txtPwd2.text, pwd == pwd2 else {
            view.makeToast("两次密码不一致")
            return
        }
        let parameters = ["username": phone, "password": pwd]
        Alamofire.request(adReg, method: .post, parameters: parameters).responseJSON { [self] response in
            Log.debug(response)
            if let data = response.data {
                let json = JSON(data)
                if json["code"].int == 0 {
                    view.makeToast("注册成功")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.dismiss(animated: false, completion: nil)
                        NotificationCenter.default.post(name: NSNotification.Name(NotiName.openLoginView.rawValue), object: nil)
                    }
                } else {
                    view.makeToast(json["msg"].string ?? "请求数据异常...")
                }
            } else {
                view.makeToast("请求失败，请稍候重试...")
            }
        }
    }
    
    @objc
    private func onTapToLogin() {
        self.dismiss(animated: false, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(NotiName.openLoginView.rawValue), object: nil)
    }

}
