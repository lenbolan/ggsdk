//
//  protocols.swift
//  ggsdk
//
//  Created by lenbo lan on 2021/9/28.
//

protocol TuiGuangCellTapDelegate {
    func onTuiGuangTap(plat: AdPlatform)
    func onUploadTap()
    func onLinkTap(url: String, title: String?)
    func onTapSupport()
}
