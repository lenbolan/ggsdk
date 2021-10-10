import Foundation
import UIKit
import CommonCrypto

public extension String {
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    func isEmail() -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let pattern = NSPredicate(format: "SELF MATCHES %@", regex)
        return pattern.evaluate(with: self)
    }
    
    func isPhone() -> Bool {
        let MOBIL = "^(1)\\d{10}$";
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@", MOBIL)
        if regextestmobile.evaluate(with: self) {
            return true
        }
        return false
    }
    
    func converToDate() -> Date? {
        let createDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let dateFromStringFormatter = DateFormatter()
        dateFromStringFormatter.dateFormat = createDateFormat
        return dateFromStringFormatter.date(from: self)
    }
    
    static let random_str_characters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    static func randomStr(len : Int) -> String{
        var ranStr = ""
        for _ in 0..<len {
            let index = Int(arc4random_uniform(UInt32(random_str_characters.count)))
            ranStr.append(random_str_characters[random_str_characters.index(random_str_characters.startIndex, offsetBy: index)])
        }
        return ranStr
    }
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                            attributes: [NSAttributedString.Key.font: font],
                                            context: nil)
        
        return boundingBox.height
    }
    
    func sizeWithFont(width: CGFloat, font: UIFont) -> CGSize {
        if self.count == 0 {
            return CGSize.zero
        }
        
        let boundingBox = self.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                                            options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                            attributes: [NSAttributedString.Key.font: font],
                                            context: nil)
        
        return CGSize(width: boundingBox.width, height: boundingBox.height)
    }
    
    static func getClassFromString(_ classString: String) -> AnyClass? {
        guard let bundleName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String else {
            return nil
        }
            
        var anyClass: AnyClass? = NSClassFromString(bundleName + "." + classString)
        if (anyClass == nil) {
            anyClass = NSClassFromString(classString)
        }
        
        return anyClass
    }
    
}
 
extension String {
    var MD5:String {
        let utf8 = cString(using: .utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(utf8, CC_LONG(utf8!.count - 1), &digest)
        return digest.reduce("") { $0 + String(format:"%02X", $1) }
    }
}

extension String {
    /// 根据下标获取某个下标字符
    subscript(of index: Int) -> String {
        if index < 0 || index >= self.count{
            return ""
        }
        for (i,item) in self.enumerated(){
            if index == i {
                return "\(item)"
            }
        }
        return ""
    }
    /// 根据range获取字符串 a[1...3]
    subscript(r: ClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(r.lowerBound, 0))
        let end = index(startIndex, offsetBy: min(r.upperBound, count - 1))
        return String(self[start...end])
    }
    /// 根据range获取字符串 a[0..<2]
    subscript(r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: max(r.lowerBound, 0))
        let end = index(startIndex, offsetBy: min(r.upperBound, count))
        return String(self[start..<end])
    }
    /// 根据range获取字符串 a[...2]
    subscript(r: PartialRangeThrough<Int>) -> String {
        let end = index(startIndex, offsetBy: min(r.upperBound, count - 1))
        return String(self[startIndex...end])
    }
    /// 根据range获取字符串 a[0...]
    subscript(r: PartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(r.lowerBound, 0))
        let end = index(startIndex, offsetBy: count - 1)
        return String(self[start...end])
    }
    /// 根据range获取字符串 a[..<3]
    subscript(r: PartialRangeUpTo<Int>) -> String {
        let end = index(startIndex, offsetBy: min(r.upperBound, count))
        return String(self[startIndex..<end])
    }
    /// 截取字符串: index 开始到结尾
    /// - Parameter index: 开始截取的index
    /// - Returns: string
    func subString(_ index: Int) -> String {
        guard index < count else {
            return ""
        }
        let start = self.index(endIndex, offsetBy: index - count)
        return String(self[start..<endIndex])
    }
    
    /// 截取字符串
    /// - Parameters:
    ///   - begin: 开始截取的索引
    ///   - count: 需要截取的个数
    /// - Returns: 字符串
    func substring(start: Int, _ count: Int) -> String {
        let begin = index(startIndex, offsetBy: max(0, start))
        let end = index(startIndex, offsetBy: min(count, start + count))
        return String(self[begin..<end])
    }
}
