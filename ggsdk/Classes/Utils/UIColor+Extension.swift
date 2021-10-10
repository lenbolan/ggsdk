import Foundation
import UIKit

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
    }
    
    /// 生成一个随机色
    static func RandomColor() -> UIColor {
        let red     = CGFloat(arc4random_uniform(255))
        let green   = CGFloat(arc4random_uniform(255))
        let blue    = CGFloat(arc4random_uniform(255))
        
        return UIColor(r: red, g: green, b: blue)
    }
    
    /// 获取 rgb
    static func colorRGB(_ color: UIColor) -> (r: CGFloat, g: CGFloat, b: CGFloat, a:CGFloat) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r,g,b,a)
    }
    
}

public extension UIColor {
    /// 获取渐变色
    /// - Warning: 未考虑透明度问题。
    /// - Parameters:
    ///   - startColor: 开始颜色
    ///   - endColor: 结束颜色
    ///   - count: 均分次数,返回颜色值数量，建议>=2
    /// - Returns: 渐变色数组， 数量始终会加上首位两种颜色
    static func gradientColors(start startColor:UIColor, end endColor: UIColor, count: Int) -> [UIColor] {
        /// 获取 rgb
        func colorRGB(_ color: UIColor) -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
            var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
            color.getRed(&r, green: &g, blue: &b, alpha: &a)
            return (r,g,b,a)
        }
        
        let startRGB = colorRGB(startColor)
        let endRGB = colorRGB(endColor)
        
        // 2. 计算均分颜色值
        guard count >= 2 else {
            return [startColor, endColor]
        }
        let stepR = (endRGB.r - startRGB.r)
        let stepG = (endRGB.g - startRGB.g)
        let stepB = (endRGB.b - startRGB.b)
        
        let red: CGFloat = startRGB.r
        let green: CGFloat = startRGB.g
        let blue: CGFloat = startRGB.b
        
        let colors = (0..<count).map() {
            index -> UIColor in
            let progress = CGFloat(index)/CGFloat(count-1)
            let color = UIColor(red: red + stepR * progress, green: green + stepG * progress , blue: blue + stepB * progress, alpha: 1)
            return color
        }
        return colors
    }
}

