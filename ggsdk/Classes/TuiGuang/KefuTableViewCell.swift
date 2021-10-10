//
//  KefuTableViewCell.swift
//  ggsdk
//
//  Created by lenbo lan on 2021/9/28.
//

import UIKit

class KefuTableViewCell: UITableViewCell {
    
    static let identifier = "KefuCell"
    
    var delegate: TuiGuangCellTapDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        contentView.backgroundColor = UIColor(hexString: "#EEEDEA")
        
        let btnKefu = createKefuBtn(img: "yky_kefu", title: "咨询客服")
        let btnDianhua = createKefuBtn(img: "yky_phone", title: "拨打电话")
        
        contentView.addSubview(btnKefu)
        contentView.addSubview(btnDianhua)
        
        let btn_weith = (Util.screenWidth - 60) / 2
        btnKefu.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: btn_weith, height: 55)
        btnDianhua.anchor(top: contentView.topAnchor, left: nil, bottom: nil, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 15, width: btn_weith, height: 55)
        
        btnKefu.addTarget(self, action: #selector(onTapKefu), for: .touchUpInside)
        btnDianhua.addTarget(self, action: #selector(onTapDianhua), for: .touchUpInside)
    }
    
    @objc
    private func onTapKefu() {
        delegate?.onTapSupport()
    }
    
    @objc
    private func onTapDianhua() {
        onTapPhoneCall()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
