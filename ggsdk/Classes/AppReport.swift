import AdSupport
import CoreTelephony

import Alamofire
import Alamofire_SwiftyJSON
import SwiftyJSON

enum ReportType {
    case udInit
    case adOpen
    case adClick
    case adError
}

enum AdPlatform: String {
    case bu = "穿山甲"
    case gdt = "优量汇"
}

enum AdType: String {
    case splash = "开屏"
    case reward = "激励视频"
    case banner = "banner"
    case flow = "信息流"
}

enum AdAction: String {
    case open = "打开"
    case start = "开始加载"
    case loaded = "加载完成"
    case show = "展示"
    case jump = "跳过"
    case click = "点击"
    case close = "关闭"
    case jump_and_close = "跳过并关闭"
}

struct BaseAdInfo: CustomDebugStringConvertible {
//    user id
    var uid: Int?
//    手机号
    var phoneNum: String?
//    机型
    var phoneType: String {
        DeviceInfo.zz_getDeviceName()
    }
//    广告标识符
    var idfa: String {
        ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
//    应用开发商标识符
    var idfv: String {
        UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
//    设备标识符
    var udid: String?
//    运营商
    var netOperator: String {
        DeviceInfo.zz_getDeviceSupplier()
    }
//    网络连接状态
    var netState: String?
//    ip address
    var ipAddr: String {
        DeviceInfo.zz_getDeviceIP()
    }
//    iOS version
    var sysVersion: String {
        UIDevice.current.systemVersion
    }
    var appName: String {
        if let infoDic = Bundle.main.infoDictionary,
           let appName: String = infoDic["CFBundleDisplayName"] as? String {
            return appName
        } else {
            return ""
        }
    }
    var bundleId: String {
        if let infoDic = Bundle.main.infoDictionary,
           let bundleId: String = infoDic["CFBundleIdentifier"] as? String {
            return bundleId
        } else {
            return ""
        }
    }
    var appVersion: String {
        if let infoDic = Bundle.main.infoDictionary,
           let appVersion: String = infoDic["CFBundleVersion"] as? String {
            return appVersion
        } else {
            return "0"
        }
    }
    var token: String?
    var serverAppId: Int {
        UserDefaults.localData.keyAppID.storedInt
    }
    var clickableNum: Int {
        UserDefaults.localData.keyRewardLimitWatchTimes.storedInt
    }
    
    var debugDescription: String {
        var dict: [String: Any] = [:]
        Mirror(reflecting: self).children.forEach { (child) in
            guard let key = child.label else { return }
            dict[key] = child.value
        }
        return "\(Self.self): \(dict)"
    }
}
// 初始化
func rAdInit(uid: Int, phoneNum: String, token: String) {
    AppReport.shared.baseAdInfo.uid = uid
    AppReport.shared.baseAdInfo.phoneNum = phoneNum
    AppReport.shared.baseAdInfo.token = token
    
    UserDefaults.localData.keyUID.store(value: uid)
    UserDefaults.localData.keyPhoneNum.store(value: phoneNum)
    UserDefaults.localData.keyToken.store(value: token)
}

func getBaseInfo() -> [String: Any] {
    let bInfo = AppReport.shared.baseAdInfo
    return ["username": bInfo.phoneNum ?? "",
            "uid": bInfo.uid ?? "",
            "mobile_model":bInfo.phoneType,
            "idfa":bInfo.idfa,
            "idfv":bInfo.idfv,
            "operator":bInfo.netOperator,
            "net_state":bInfo.netState ?? "",
            "ip":bInfo.ipAddr,
            "sys_version":bInfo.sysVersion,
            "token":bInfo.token ?? "",
            "bundle_id":bInfo.bundleId,
            "app_name":bInfo.appName,
            "app_version":bInfo.appVersion,
            "app_mid":bInfo.serverAppId,
            "preload_time":0] as [String : Any]
}
// 上报基础信息
func rAdBaseInfo() {
    let parameters = getBaseInfo()
    
    baseReq(url: adRInfo, parameters: parameters)
}

// 打开广告
func rAdOpen(_ adPlat:AdPlatform, _ adType:AdType, adId: String) {
    var parameters = getBaseInfo()
    parameters["plat"] = adPlat.rawValue
    parameters["type"] = adType.rawValue
    parameters["ad_id"] = adId
    parameters["action"] = AdAction.open.rawValue
    parameters["action_time"] = Date.getStamp()
    parameters["open_time"] = Date.getStamp()
    
    baseReq(url: adROpen, parameters: parameters)
    
}

// 开始加载广告
func rAdStart(_ adPlat:AdPlatform, _ adType:AdType, adId: String) {
    var parameters = getBaseInfo()
    parameters["plat"] = adPlat.rawValue
    parameters["type"] = adType.rawValue
    parameters["ad_id"] = adId
    parameters["action"] = AdAction.start.rawValue
    parameters["action_time"] = Date.getStamp()
    parameters["start_load_time"] = Date.getStamp()
    
    baseReq(url: adROpen, parameters: parameters)
}

// 加载完成
func rAdLoaded(_ adPlat:AdPlatform, _ adType:AdType, adId: String, loadedTime: Int) {
    var parameters = getBaseInfo()
    parameters["plat"] = adPlat.rawValue
    parameters["type"] = adType.rawValue
    parameters["ad_id"] = adId
    parameters["action"] = AdAction.loaded.rawValue
    parameters["action_time"] = loadedTime
    parameters["data_loaded_time"] = loadedTime
    
    baseReq(url: adROpen, parameters: parameters)
}

// 展示
func rAdShow(_ adPlat:AdPlatform, _ adType:AdType, adId: String, loadedTime: Int) {
    let showTime = Date.getStamp()
    let intervalTime = showTime - loadedTime
    
    var parameters = getBaseInfo()
    parameters["plat"] = adPlat.rawValue
    parameters["type"] = adType.rawValue
    parameters["ad_id"] = adId
    parameters["action"] = AdAction.show.rawValue
    parameters["action_time"] = showTime
    parameters["show_time"] = showTime
    parameters["preload_time"] = loadedTime
    parameters["interval_time"] = intervalTime
    
    baseReq(url: adROpen, parameters: parameters)
}

// 点击广告
func rAdClick(_ adPlat:AdPlatform, _ adType:AdType, adId: String, showTime: Int, isRepeat: Int) {
    var parameters = getBaseInfo()
    parameters["plat"] = adPlat.rawValue
    parameters["type"] = adType.rawValue
    parameters["ad_id"] = adId
    parameters["action"] = AdAction.click.rawValue
    parameters["action_time"] = Date.getStamp()
    parameters["click_time"] = Date.getStamp()
    parameters["show_time"] = showTime
    parameters["is_repeat"] = isRepeat
    
    baseReq(url: adRClick, parameters: parameters)
}

// 跳过广告
func rAdJump(_ adPlat:AdPlatform, _ adType:AdType, adId: String) {
    var parameters = getBaseInfo()
    parameters["plat"] = adPlat.rawValue
    parameters["type"] = adType.rawValue
    parameters["ad_id"] = adId
    parameters["action"] = AdAction.jump.rawValue
    parameters["action_time"] = Date.getStamp()
    parameters["jump_time"] = Date.getStamp()
    
    baseReq(url: adROpen, parameters: parameters)
}

// 关闭广告
func rAdClose(_ adPlat:AdPlatform,
              _ adType:AdType,
              adId: String,
              openTime: Int,
              startLoadTime: Int,
              dataLoadedTime: Int,
              videoLoadedTime: Int,
              showTime: Int,
              clickTime: Int,
              jumpTime: Int) {
    
    let curTime = Date.getStamp()
    
    var parameters = getBaseInfo()
    parameters["plat"] = adPlat.rawValue
    parameters["type"] = adType.rawValue
    parameters["ad_id"] = adId
    parameters["action_time"] = curTime
    parameters["preload_time"] = videoLoadedTime
    
    parameters["open_time"] = openTime
    parameters["start_load_time"] = startLoadTime
    parameters["data_loaded_time"] = dataLoadedTime
    parameters["video_loaded_time"] = videoLoadedTime
    parameters["show_time"] = showTime
    parameters["click_time"] = clickTime
    parameters["jump_time"] = jumpTime
    parameters["close_time"] = curTime
    
    if jumpTime > 0 {
        parameters["action"] = AdAction.jump_and_close.rawValue
    } else {
        parameters["action"] = AdAction.close.rawValue
    }
    
    baseReq(url: adROpen, parameters: parameters)
}

// 广告出错
func rAdError(_ adPlat:AdPlatform, _ adType:AdType, _ err: String, adId: String) {
    var parameters = getBaseInfo()
    parameters["plat"] = adPlat.rawValue
    parameters["type"] = adType.rawValue
    parameters["ad_id"] = adId
    parameters["action_time"] = Date.getStamp()
    parameters["message"] = err
    
    baseReq(url: adRError, parameters: parameters)
}

func rRefreshToken(token: String) {
    AppReport.shared.baseAdInfo.token = token
    UserDefaults.localData.keyToken.store(value: token)
}

fileprivate func baseReq(url: String, parameters: [String: Any]) {
    Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
        Log.debug(response, 1)
        if let data = response.data {
            let json = JSON(data)
            if json["code"].int == 0 {
                Log.debug("report success...")
                
                if json["data"]["ad_random_time"] != nil {
                    let limitTimeMin = json["data"]["ad_random_time"][0]["min"].intValue
                    let limitTimeMax = json["data"]["ad_random_time"][0]["max"].intValue
                    
                    let rewardLimitWatchTimes = json["data"]["incentive_video_show"]["watch"].intValue
                    let rewardLimitClickTimes = json["data"]["incentive_video_show"]["click"].intValue
                    
                    let splashLimitWatchTimes = json["data"]["open_screen_show"]["watch"].intValue
                    let splashLimitClickTimes = json["data"]["open_screen_show"]["click"].intValue
                    
                    let bannerLimitWatchTimes = json["data"]["banner_show"]["watch"].intValue
                    let bannerLimitClickTimes = json["data"]["banner_show"]["click"].intValue
                    
                    let flowLimitWatchTimes = json["data"]["flow_show"]["watch"].intValue
                    let flowLimitClickTimes = json["data"]["flow_show"]["click"].intValue
                    
                    UserDefaults.localData.keyRandomTimeMin.store(value: limitTimeMin)
                    UserDefaults.localData.keyRandomTimeMax.store(value: limitTimeMax)
                    
                    UserDefaults.localData.keyRewardLimitWatchTimes.store(value: rewardLimitWatchTimes)
                    UserDefaults.localData.keyRewardLimitClickTimes.store(value: rewardLimitClickTimes)
                    
                    UserDefaults.localData.keyBannerLimitWatchTimes.store(value: bannerLimitWatchTimes)
                    UserDefaults.localData.keyBannerLimitClickTimes.store(value: bannerLimitClickTimes)
                    
                    UserDefaults.localData.keyFlowLimitWatchTimes.store(value: flowLimitWatchTimes)
                    UserDefaults.localData.keyFlowLimitClickTimes.store(value: flowLimitClickTimes)
                    
                    UserDefaults.localData.keySplashLimitWatchTimes.store(value: splashLimitWatchTimes)
                    UserDefaults.localData.keySplashLimitClickTimes.store(value: splashLimitClickTimes)
                }
                
            } else {
                setLocalTestConfig()
                Log.debug(json["msg"].string ?? "请求数据异常...")
            }
            
            if let token = json["data"]["token"].string {
                rRefreshToken(token: token)
            }
            
        } else {
            Log.debug("请求失败，请稍候重试...")
        }
    }
}

fileprivate func setLocalTestConfig() {
    UserDefaults.localData.keyRandomTimeMin.store(value: 5)
    UserDefaults.localData.keyRandomTimeMax.store(value: 10)
    
    UserDefaults.localData.keyRewardLimitWatchTimes.store(value: 5)
    UserDefaults.localData.keyRewardLimitClickTimes.store(value: 2)
    
    UserDefaults.localData.keyBannerLimitWatchTimes.store(value: 5)
    UserDefaults.localData.keyBannerLimitClickTimes.store(value: 2)
    
    UserDefaults.localData.keyFlowLimitWatchTimes.store(value: 5)
    UserDefaults.localData.keyFlowLimitClickTimes.store(value: 2)
    
    UserDefaults.localData.keySplashLimitWatchTimes.store(value: 5)
    UserDefaults.localData.keySplashLimitClickTimes.store(value: 2)
}

class AppReport {
    
    static let shared = AppReport()
    
    var baseAdInfo: BaseAdInfo
    
    lazy var reachability: NetworkReachabilityManager? = {
        return NetworkReachabilityManager(host: "https://www.baidu.com")
    }()
    
    required init() {
        baseAdInfo = BaseAdInfo()
        
        baseAdInfo.uid = UserDefaults.localData.keyUID.storedInt
        baseAdInfo.phoneNum = UserDefaults.localData.keyPhoneNum.storedString
        baseAdInfo.token = UserDefaults.localData.keyToken.storedString
        
        reachability?.listener = { status in
            switch status {
            case .reachable(.ethernetOrWiFi):
                Log.debug("current net - wifi")
                AppReport.shared.baseAdInfo.netState = "WIFI"
                break
            case .reachable(.wwan):
                var netConnType = ""
                
                let netInfo = CTTelephonyNetworkInfo()
                let currentStatus = netInfo.currentRadioAccessTechnology
                if currentStatus == "CTRadioAccessTechnologyGPRS" {
                    netConnType = "GPRS"
                } else if (currentStatus == "CTRadioAccessTechnologyEdge") {
                    netConnType = "2.75G EDGE"
                } else if (currentStatus == "CTRadioAccessTechnologyWCDMA") {
                    netConnType = "3G"
                } else if (currentStatus == "CTRadioAccessTechnologyHSDPA") {
                    netConnType = "3.5G HSDPA"
                } else if (currentStatus == "CTRadioAccessTechnologyHSUPA") {
                    netConnType = "3.5G HSUPA"
                } else if (currentStatus == "CTRadioAccessTechnologyCDMA1x") {
                    netConnType = "2G"
                } else if (currentStatus == "CTRadioAccessTechnologyCDMAEVDORev0") {
                    netConnType = "3G"
                } else if (currentStatus == "CTRadioAccessTechnologyCDMAEVDORevA") {
                    netConnType = "3G"
                } else if (currentStatus == "CTRadioAccessTechnologyCDMAEVDORevB") {
                    netConnType = "3G"
                } else if (currentStatus == "CTRadioAccessTechnologyeHRPD") {
                    netConnType = "HRPD"
                } else if (currentStatus == "CTRadioAccessTechnologyLTE") {
                    netConnType = "4G"
                }
                
                AppReport.shared.baseAdInfo.netState = netConnType
                
                Log.debug("current net - \(netConnType)")
                
                break
            default: break
            }
        }
        reachability?.startListening()
    }
    
}
