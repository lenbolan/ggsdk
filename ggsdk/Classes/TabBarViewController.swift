//
//  TabBarViewController.swift
//  ggsdk
//
//  Created by lenbo lan on 2021/9/28.
//

import UIKit

import Kingfisher

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().tintColor = UIColor(hexString: "#FF6767")
        
        addChildVC(cc: TuiGuangViewController(), img: "home", title: "首页", hasSplash: 1)
        
        if let nav = UserDefaults.localData.keyMenu.storedValue as? [[String: String]] {
            Log.debug(nav)
            for i in 0..<nav.count {
                addChildDynamicVC(cc: UserReportViewController(strUrl: nav[i]["url"]),
                                  img: nav[i]["icon"],
                                  imgSel: nav[i]["icon_sel"],
                                  title: nav[i]["title"])
            }
        }
    }
    
    private func addChildVC(cc: UIViewController, img: String, title: String?, hasSplash: Int = 0) {
        cc.title = title
        
        cc.tabBarItem.image = UIImage(named: "yky_nav_\(img)")?.withRenderingMode(.alwaysOriginal)
        cc.tabBarItem.selectedImage = UIImage(named: "yky_nav_\(img)_sel")?.withRenderingMode(.alwaysOriginal)
//        cc.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        cc.tabBarItem.title = title
        
        let nav = NavBarViewController(rootViewController: cc)
        if hasSplash == 1 {
            nav.setObserver()
        }
        addChild(nav)
    }
    
    private func addChildDynamicVC(cc: UIViewController, img: String?, imgSel: String?, title: String?) {
        cc.title = title
        
        if let _img = img,
            let url = URL(string: _img) {
            do {
                let data = try Data(contentsOf: url)
                cc.tabBarItem.image = UIImage(data: data)?.withRenderingMode(.alwaysOriginal)
            } catch {
                print("nav image load failed.")
            }
        }
        if let _img = imgSel,
            let url = URL(string: _img) {
            do {
                let data = try Data(contentsOf: url)
                cc.tabBarItem.selectedImage = UIImage(data: data)?.withRenderingMode(.alwaysOriginal)
            } catch {
                print("nav image load failed.")
            }
        }
        cc.tabBarItem.title = title
        
        let nav = NavBarViewController(rootViewController: cc)
        addChild(nav)
    }

}
