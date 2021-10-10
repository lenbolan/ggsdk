import Foundation
import UIKit

func randomNum(min: Int, max: Int) -> Int {
    return Int(arc4random_uniform(UInt32(max)) + UInt32(min))
}

class Util: NSObject {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let screenCenter = CGPoint(x: Util.screenWidth/2, y: Util.screenHeight/2)
    static let ratioWidth = UIScreen.main.bounds.width / 414.0
    static let minPixel = 1 / UIScreen.main.scale
    
    static let isIphoneX: Bool = {
        var safeAreaBottom: CGFloat = 0
        if #available(iOS 11.0, *) {
            safeAreaBottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        } else {
            // Fallback on earlier versions
        }
        return safeAreaBottom != 0
    }()
    
    static let isSmallIphone: Bool = {
        return UIScreen.main.bounds.size.height == 480 ? true : false
    }()
    
    static let statusBarHei: CGFloat = {
        return isIphoneX ? 44 : 20
    }()
    
    static let navigationBarHei: CGFloat = {
        return 44
    }()
    
    static let topHei: CGFloat = {
        return statusBarHei + navigationBarHei
    }()
    
    public class func tarBarHei() -> CGFloat {
        return isIphoneX ? 83 : 49
    }
    
    
    
    static let numWords = ["一","二","三","四","五","六","七","八","九","十"]
    
    //MARK: 数字前补0
    static func add0BeforeNumber(_ number:Int) -> String {
        if number >= 10 {
            return String(number)
        }else{
            return "0" + String(number)
        }
    }
    
    static func clearAllUserDefaultsData() {
        let userDefaults = UserDefaults.standard
        let dics = userDefaults.dictionaryRepresentation()
        for key in dics {
            userDefaults.removeObject(forKey: key.key)
        }
        userDefaults.synchronize()
    }
}

public protocol UserDefaultSettable {
    var uniqueKey: String { get }
}

public extension UserDefaultSettable where Self: RawRepresentable, Self.RawValue == String {
    
    func store(value: Any?){
        UserDefaults.standard.set(value, forKey: uniqueKey)
    }
    var storedValue: Any? {
        return UserDefaults.standard.value(forKey: uniqueKey)
    }
    var storedString: String? {
        return storedValue as? String
    }
    
    func store(url: URL?) {
        UserDefaults.standard.set(url, forKey: uniqueKey)
    }
    var storedURL: URL? {
        return UserDefaults.standard.url(forKey: uniqueKey)
    }
    
    func store(value: Bool) {
        UserDefaults.standard.set(value, forKey: uniqueKey)
    }
    var storedBool: Bool {
        return UserDefaults.standard.bool(forKey: uniqueKey)
    }
    
    func store(value: Int) {
        UserDefaults.standard.set(value, forKey: uniqueKey)
    }
    var storedInt: Int {
        return UserDefaults.standard.integer(forKey: uniqueKey)
    }
    
    func store(value: Double) {
        UserDefaults.standard.set(value, forKey: uniqueKey)
    }
    var storedDouble: Double {
        return UserDefaults.standard.double(forKey: uniqueKey)
    }
    
    func store(value: Float) {
        UserDefaults.standard.set(value, forKey: uniqueKey)
    }
    var storedFloat: Float {
        return UserDefaults.standard.float(forKey: uniqueKey)
    }
    
    var uniqueKey: String {
        return "\(Self.self).\(rawValue)"
    }
    
    /// removed object from standard userdefaults
    func removed() {
        UserDefaults.standard.removeObject(forKey: uniqueKey)
    }

}

extension UserDefaults {
    enum localData: String, UserDefaultSettable {
        
        // 广告参数
        case keyBU_AppID
        case keyBU_SplashSlotID
        case keyBU_RewardSlotID
        case keyBU_BannerSlotID
        case keyBU_FlowSlotID
        
        case keyGDT_AppID
        case keyGDT_SplashSlotID
        case keyGDT_RewardSlotID
        case keyGDT_BannerSlotID
        case keyGDT_FlowSlotID
        
        // 账号
        case keyAccount
        case keyUID
        case keyPhoneNum
        case keyToken
        
        case keyAdDate
        
        // 激励
        case keyRandomTimeMin
        case keyRandomTimeMax
        
        case keyRewardLimitWatchTimes
        case keyRewardLimitClickTimes
        
        case keyRewardWatchTimes
        case keyRewardClickTimes
        
        case keyRewardWatchTimes_GDT
        case keyRewardClickTimes_GDT
        
        // Banner
        case keyBannerLimitWatchTimes
        case keyBannerLimitClickTimes
        case keyBannerWatchTimes
        case keyBannerClickTimes
        
        case keyBannerWatchTimes_GDT
        case keyBannerClickTimes_GDT
        
        // Flow
        case keyFlowLimitWatchTimes
        case keyFlowLimitClickTimes
        
        case keyFlowWatchTimes_GDT
        case keyFlowClickTimes_GDT
        
        // Splash
        case keySplashLimitWatchTimes
        case keySplashLimitClickTimes
        case keySplashWatchTimes
        case keySplashClickTimes
        
        // 其他
        case keyAppID
        
        // Menu
        case keyMenu
        case keyFuncItem
        case keyWeixinKefu
        case keyTelKefu
        
    }
    
    //UserDefaults.localData.keyDate.store(value: "xxxxx")
    //let keyDateValue = UserDefaults.localData.keyDate.storedString
}

/// GCD定时器倒计时
///
/// - Parameters:
///   - timeInterval: 间隔时间
///   - repeatCount: 重复次数
///   - handler: 循环事件,闭包参数: 1.timer 2.剩余执行次数
func dispatchTimer(timeInterval: Double, repeatCount: Int, handler: @escaping (DispatchSourceTimer?, Int) -> Void) {
    
    if repeatCount <= 0 {
        return
    }
    let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
    var count = repeatCount
    timer.schedule(deadline: .now(), repeating: timeInterval)
    timer.setEventHandler {
        count -= 1
        DispatchQueue.main.async {
            handler(timer, count)
        }
        if count == 0 {
            timer.cancel()
        }
    }
    timer.resume()
    
}

struct Log {
    static func debug<T>(_ message: T, _ dp: Int = 0, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
            //获取文件名
            let fileName = (file as NSString).lastPathComponent
            //打印日志内容
            print("=====> Debug: \(fileName):\(line) \(function)")
            if dp == 0 {
                print(message)
            } else {
                debugPrint(message)
            }
        #endif
    }
}
