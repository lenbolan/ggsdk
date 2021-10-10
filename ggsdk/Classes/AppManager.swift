import Foundation

import BUAdSDK
import Alamofire
import Alamofire_SwiftyJSON
import SwiftyJSON
import Toast_Swift

struct FuncItem: Codable {
    var id: Int!
    var title: String!
    var icon: String!
    var icon_sel: String!
    var url: String!
}

enum NotiName: String {
    case openAd = "OpenAd"
    case openLoginView = "OpenLoginView"
    case openRegistView = "OpenRegistView"
    case openBUSplashAd = "OpenBUSplashAd"
    case BUSplashAdShow = "BUSplashAdShow"
    case BUSplashAdClick = "BUSplashAdClick"
    case BUSplashAdClose = "BUSplashAdClose"
    case exitAdPages = "ExitAdPages"
}

@objcMembers
public class AppManager: NSObject {
    
    public static let shared = AppManager()
    
    private static var isInitBU = false
    private static var isInitGDT = false
    private static var isInitAppId = false
    
    public static func setupParams(_ data: JSON) {
        parseData(json: data)
    }
    
    public static func setupParams(_ data: NSArray) {
        let json = JSON(data)
        parseData(json: json)
    }
    
    private static func parseData(json: JSON) {
        let today = Date.dateToString(formatStr: "yyyyMMdd")
        if let keyDate = UserDefaults.localData.keyAdDate.storedString, keyDate == today {
        } else {
            Util.clearAllUserDefaultsData()
        }
        UserDefaults.localData.keyAdDate.store(value: today)
        
        let _ = AppReport.shared
        let _data = json.arrayValue
        for i in 0..<_data.count {
            let adData = AppParams(fromJSON: _data[i])
            if adData.platform == "穿山甲" {
                if isInitBU == false {
                    isInitBU = true
                    UserDefaults.localData.keyBU_AppID.store(value: adData.app_id)
                    BUAdSDKManager.setAppID(adData.app_id)
                }
                switch adData.ad_type {
                case 1:
                    UserDefaults.localData.keyBU_SplashSlotID.store(value: adData.ad_id)
                case 2:
                    UserDefaults.localData.keyBU_BannerSlotID.store(value: adData.ad_id)
                case 3:
                    UserDefaults.localData.keyBU_FlowSlotID.store(value: adData.ad_id)
                case 4:
                    UserDefaults.localData.keyBU_RewardSlotID.store(value: adData.ad_id)
                default:
                    Log.debug("adData.adType err")
                }
            } else if adData.platform == "优量汇" {
                if isInitGDT == false {
                    isInitGDT = true
                    UserDefaults.localData.keyGDT_AppID.store(value: adData.app_id)
                    GDTSDKConfig.registerAppId(adData.app_id)
                }
                switch adData.ad_type {
                case 1:
                    UserDefaults.localData.keyGDT_SplashSlotID.store(value: adData.ad_id)
                case 2:
                    UserDefaults.localData.keyGDT_BannerSlotID.store(value: adData.ad_id)
                case 3:
                    UserDefaults.localData.keyGDT_FlowSlotID.store(value: adData.ad_id)
                case 4:
                    UserDefaults.localData.keyGDT_RewardSlotID.store(value: adData.ad_id)
                default:
                    Log.debug("adData.adType err")
                }
            }
            if isInitAppId == false {
                isInitAppId = true
                UserDefaults.localData.keyAppID.store(value: adData.pid)
            }
        }
        
        getAppConfig()
    }
    
    private static func getAppConfig() {
        Alamofire.request(adMenu, method: .get).responseJSON { response in
            Log.debug(response, 1)
            if let data = response.data {
                let json = JSON(data)
                if json["code"].int == 0 {
                    var nav = [[String: String]]()
                    for (key, subjson):(String, JSON) in json["data"]["nav"] {
                        let navDict = subjson.dictionaryObject as! [String: String]
                        var navItem = [String:String]()
                        navItem["title"] = navDict["title"]!
                        navItem["icon_sel"] = navDict["h_icon"]!
                        navItem["icon"] = navDict["d_icon"]!
                        navItem["url"] = navDict["url"]!
                        navItem["id"] = key
                        nav.append(navItem)
                    }
                    nav.sort { Int($0["id"]!)! < Int($1["id"]!)! }
                    UserDefaults.localData.keyMenu.store(value: nav)
                    Log.debug(nav)
                    
                    nav = [[String: String]]()
                    for (index, subjson):(String, JSON) in json["data"]["column"] {
                        let navDict = subjson.dictionaryObject as! [String: String]
                        var navItem = [String:String]()
                        navItem["title"] = navDict["title"]!
                        navItem["icon"] = navDict["icon"]!
                        navItem["url"] = navDict["url"]!
                        navItem["id"] = index
                        nav.append(navItem)
                    }
                    UserDefaults.localData.keyFuncItem.store(value: nav)
                    Log.debug(nav)
                    
                    UserDefaults.localData.keyWeixinKefu.store(value: json["data"]["ad_icon_url"].stringValue)
                    UserDefaults.localData.keyTelKefu.store(value: json["data"]["ad_tel"].stringValue)
                } else {
                    Log.debug("客服信息请求失败,"+(json["msg"].string ?? "请求数据异常..."))
                }
            } else {
                Log.debug("客服信息请求失败")
            }
        }
    }
    
    public static func popup(from_vc viewController: UIViewController) {
        viewController.setupAdWinHelp()
        
        var vc = UIViewController()
        
        if let acc = UserDefaults.localData.keyAccount.storedString,
           acc != "" {
            rAdBaseInfo()
            vc = TabBarViewController()
        } else {
            vc = LoginViewController()
        }
        
        #if DEBUG
//        vc = RegistViewController()
        #else
        
        #endif
        
        vc.modalPresentationStyle = .fullScreen
        viewController.present(vc, animated: false, completion: nil)
    }
    
}
