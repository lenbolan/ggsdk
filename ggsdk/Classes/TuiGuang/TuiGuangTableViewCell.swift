//
//  TuiGuangTableViewCell.swift
//  ggsdk
//
//  Created by lenbo lan on 2021/9/27.
//

import UIKit

class TuiGuangTableViewCell: UITableViewCell {
    
    static let identifier = "TuiGuangCell"
    
    var relPlat: AdPlatform!
    var delegate: TuiGuangCellTapDelegate?
    
    private let bg: UIView = {
        let bg = UIView()
        bg.backgroundColor = .white
        bg.setCornerRadius(8)
        bg.setShadow()
        return bg
    }()
    
    private let icon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "yky_cell_icon_1")
        return img
    }()
    
    private let txt1: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        lb.text = "推广一区"
        lb.textColor = UIColor(hexString: "#828282")
        return lb
    }()
    
    private let txt2: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 16)
        lb.text = "手指点一点，轻松把钱赚。"
        lb.textColor = UIColor(hexString: "#999999")
        return lb
    }()
    
    private let btn: UIButton = {
        let btn = UIButton()
        btn.setTitle("立即赚", for: .normal)
        btn.setTitleColor(UIColor(hexString: "#828282"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.backgroundColor = .white
        btn.isUserInteractionEnabled = false
        btn.setCornerRadius(15)
        btn.setShadow()
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        contentView.backgroundColor = UIColor(hexString: "#EEEDEA")
        
        contentView.addSubview(bg)
        bg.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 0, height: 0)
        
        bg.addSubview(icon)
        icon.anchor(top: nil, left: bg.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 37, height: 37)
        icon.centerYAnchor.constraint(equalTo: bg.centerYAnchor).isActive = true
        
        bg.addSubview(txt1)
        txt1.anchor(top: bg.topAnchor, left: icon.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 200, height: 30)
        
        bg.addSubview(txt2)
        txt2.anchor(top: txt1.bottomAnchor, left: txt1.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 30)
        
        bg.addSubview(btn)
        btn.anchor(top: nil, left: nil, bottom: nil, right: bg.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 60, height: 30)
        btn.centerYAnchor.constraint(equalTo: bg.centerYAnchor).isActive = true
//        btn.addTarget(self, action: #selector(onBtnTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(plat: AdPlatform) {
        relPlat = plat
        if relPlat == .bu {
            txt1.text = "推广一区"
        } else {
            txt1.text = "推广二区"
        }
    }
    
    @objc
    private func onBtnTap() {
        delegate?.onTuiGuangTap(plat: relPlat)
    }

}
