//
//  FunctionTableViewCell.swift
//  ggsdk
//
//  Created by lenbo lan on 2021/9/27.
//

import UIKit

import Kingfisher

class FunctionTableViewCell: UITableViewCell {
    
    static let identifier = "FunctionCell"
    
    var delegate: TuiGuangCellTapDelegate?
    
    private var cellData = [("yky_upload","上传凭证","")]

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        contentView.backgroundColor = UIColor(hexString: "#EEEDEA")
        
        if let nav = UserDefaults.localData.keyFuncItem.storedValue as? [[String: String]] {
            for item in nav {
                cellData.append((item["icon"]!, item["title"]!, item["url"]!))
            }
        }
        
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        let setTotal:CGFloat = CGFloat(cellData.count)
        
        let numColumn:CGFloat = 3
        let numRow:CGFloat = ceil(setTotal / numColumn)
        let numSpace:CGFloat = 1
        
        let numCellWidth: CGFloat = (Util.screenWidth - 22) / 3
        let numCellHeight: CGFloat = 100
        
        let numTotal = Int(numColumn * numRow)
        
        for i in 0..<numTotal {
            let column = i % Int(numColumn)
            let row = Int(i / Int(numColumn))
            let _x = 10 + numSpace + (CGFloat(column) * (numCellWidth + numSpace))
            let _y = 10 + numSpace + (CGFloat(row) * (numCellHeight + numSpace))
            let uicell = UIView(frame: CGRect(x: _x, y: _y, width: numCellWidth, height: numCellHeight))
            uicell.backgroundColor = .white
            uicell.tag = i
            // 处理圆角
            if numRow == 1 {
                if column == 0 {
                    uicell.roundLeft()
                } else if column == (Int(numColumn) - 1) {
                    uicell.roundRight()
                }
            } else if row == 0 {
                if column == 0 {
                    uicell.roundLT()
                } else if column == (Int(numColumn) - 1) {
                    uicell.roundRT()
                }
            } else if row == (Int(numRow) - 1) {
                if column == 0 {
                    uicell.roundLB()
                } else if column == (Int(numColumn) - 1) {
                    uicell.roundRB()
                }
            }
            if i < cellData.count {
                let img = UIImageView()
                if i == 0 {
                    img.image = UIImage(named: "\(cellData[i].0)")
                } else {
                    img.kf.setImage(with: URL(string: cellData[i].0))
                }
                uicell.addSubview(img)
                img.anchor(top: uicell.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 37, height: 37)
                img.centerXAnchor.constraint(equalTo: uicell.centerXAnchor).isActive = true
                let label = UILabel()
                label.textAlignment = .center
                label.text = cellData[i].1
                uicell.addSubview(label)
                label.anchor(top: img.bottomAnchor, left: uicell.leftAnchor, bottom: nil, right: uicell.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 30)
                
                uicell.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(onItemTap))
                uicell.addGestureRecognizer(tap)
            }
            
            contentView.addSubview(uicell)
        }
    }
    
    @objc
    private func onItemTap(_ gus: UITapGestureRecognizer) {
        if let _tag = gus.view?.tag {
            if _tag == 0 {
                delegate?.onUploadTap()
            } else {
                delegate?.onLinkTap(url: cellData[_tag].2, title: cellData[_tag].1)
            }
        }
    }
    
}
