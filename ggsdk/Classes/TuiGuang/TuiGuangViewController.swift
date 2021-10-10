//
//  TuiGuangViewController.swift
//  ggsdk
//
//  Created by lenbo lan on 2021/9/27.
//

import UIKit

class TuiGuangViewController: UIViewController {
    
    
    
    private let table: UITableView = {
        let tb = UITableView()
        tb.showsVerticalScrollIndicator = false
        tb.showsHorizontalScrollIndicator = false
        tb.separatorStyle = .none
        tb.backgroundColor = UIColor(hexString: "#EEEDEA")
        tb.tableFooterView = UIView()
        tb.register(TuiGuangTableViewCell.self, forCellReuseIdentifier: TuiGuangTableViewCell.identifier)
        tb.register(FunctionTableViewCell.self, forCellReuseIdentifier: FunctionTableViewCell.identifier)
        tb.register(KefuTableViewCell.self, forCellReuseIdentifier: KefuTableViewCell.identifier)
        return tb
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hexString: "#EEEDEA")
        
        view.addSubview(table)
        table.anchor(top: view.guide.topAnchor, left: view.leftAnchor, bottom: view.guide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 80, paddingRight: 0, width: 0, height: 0)
        
        table.delegate = self
        table.dataSource = self
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onLogout),
                                               name: NSNotification.Name(NotiName.exitAdPages.rawValue),
                                               object: nil)
        
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
    
    @objc
    private func onLogout() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension TuiGuangViewController: TuiGuangCellTapDelegate {
    func onTuiGuangTap(plat: AdPlatform) {
        let vc = TopBarViewController()
        vc.plat = plat
        if plat == .bu {
            vc.title = "推广一区"
        } else {
            vc.title = "推广二区"
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    func onUploadTap() {
        let vc = UploadImageViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    func onLinkTap(url: String, title: String?) {
        let vc = UserReportViewController(strUrl: url)
        vc.title = title
        navigationController?.pushViewController(vc, animated: true)
    }
    func onTapSupport() {
        
    }
}

extension TuiGuangViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            return 1
        }
//        else if section == 2 {
//            return 1
//        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TuiGuangTableViewCell.identifier, for: indexPath) as! TuiGuangTableViewCell
            if indexPath.row == 0 {
                cell.setData(plat: .bu)
            } else {
                cell.setData(plat: .gdt)
            }
            cell.delegate = self
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: FunctionTableViewCell.identifier, for: indexPath) as! FunctionTableViewCell
            cell.delegate = self
            return cell
        }
//        else if indexPath.section == 2 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: KefuTableViewCell.identifier, for: indexPath) as! KefuTableViewCell
//            cell.delegate = self
//            return cell
//        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let vc = TopBarViewController()
            if indexPath.row == 0 {
                vc.plat = .bu
                vc.title = "推广一区"
            } else {
                vc.plat = .gdt
                vc.title = "推广二区"
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        } else if indexPath.section == 1 {
            var row:CGFloat = 1.0
            if let nav = UserDefaults.localData.keyFuncItem.storedValue as? [[String: String]] {
                row = ceil(CGFloat(nav.count + 1)/3.0)
            }
            return 100 * row + 20
        }
//        else if indexPath.section == 2 {
//            return 75
//        }
        return 0
    }
    
}
