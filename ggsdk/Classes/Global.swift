//
//  Global.swift
//  ggsdk
//
//  Created by lenbo lan on 2021/10/2.
//

import UIKit

var autoSplashShow = 0

func createKefuBtn(img: String, title: String) -> UIButton {
    let btn = UIButton()
    btn.setImage(UIImage(named: img), for: .normal)
    btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
    btn.setTitleColor(UIColor(hexString: "#101010"), for: .normal)
    btn.setTitle(title, for: .normal)
    btn.backgroundColor = .white
    btn.setCornerRadius(10)
    btn.setShadow()
    return btn
}

func onTapPhoneCall() {
    let strPhone = UserDefaults.localData.keyTelKefu.storedString ?? ""
    let phone = "telprompt://\(strPhone)"
    if UIApplication.shared.canOpenURL(URL(string: phone)!) {
        UIApplication.shared.openURL(URL(string: phone)!)
    }
}

func setAttributedText(txt: String, num1: Int, num2: Int) -> NSMutableAttributedString {
    let loc1 = 6
    let len1 = String(num1).count
    let range1 = NSRange(location: loc1, length: len1)
    let loc2 = loc1 + len1 + 6
    let len2 = String(num2).count
    let range2 = NSRange(location: loc2, length: len2)
    let mutableStr = NSMutableAttributedString(string: txt)
    mutableStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range1)
    mutableStr.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 22, weight: .bold), range: range1)
    mutableStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range2)
    mutableStr.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 22, weight: .bold), range: range2)
    
    return mutableStr
}
