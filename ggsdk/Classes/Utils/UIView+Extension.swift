import UIKit

extension UIView {

    var width: CGFloat {
        return frame.size.width
    }

    var height: CGFloat {
        return frame.size.height
    }

    var top: CGFloat {
        return frame.origin.y
    }

    var bottom: CGFloat {
        get { return frame.size.height + frame.origin.y }
        set {
            var _frame = frame
            _frame.origin.y = newValue - frame.size.height
            frame = _frame
        }
    }

    var left: CGFloat {
        return frame.origin.x
    }

    var right: CGFloat {
        return frame.size.width + frame.origin.x
    }
    
    var centre: CGPoint {
        let cx = left + width * 0.5
        let cy = top + height * 0.5
        return CGPoint(x: cx, y: cy)
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    var guide: UILayoutGuide {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide
        } else {
            return self.layoutMarginsGuide
        }
    }

}


// MARK: - Corner & Border

@IBDesignable
public extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.masksToBounds = newValue > 0
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderWith: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            if let CGColor = layer.borderColor {
                return UIColor(cgColor: CGColor)
            } else {
                return nil
            }
        }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    func setCornerRadius(_ r: CGFloat) {
        layer.cornerRadius = r
    }
    
    func setShadow() {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    /// Setup border width & color.
    func setBorder(
        width: CGFloat = 0.5,
        color: UIColor = UIColor.gray)
    {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
    func roundTop(radius:CGFloat = 5){
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
    }

    func roundBottom(radius:CGFloat = 5){
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
    
    func roundLeft(radius:CGFloat = 5) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [
                .layerMinXMaxYCorner,
                .layerMinXMinYCorner
            ]
        } else {
            // Fallback on earlier versions
        }
    }
    
    func roundRight(radius:CGFloat = 5) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [
                .layerMaxXMaxYCorner,
                .layerMaxXMinYCorner
            ]
        } else {
            // Fallback on earlier versions
        }
    }
    
    func roundLT(radius:CGFloat = 5) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [
                .layerMinXMinYCorner
            ]
        } else {
            // Fallback on earlier versions
        }
    }
    
    func roundRT(radius:CGFloat = 5) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [
                .layerMaxXMinYCorner
            ]
        } else {
            // Fallback on earlier versions
        }
    }
    
    func roundLB(radius:CGFloat = 5) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [
                .layerMinXMaxYCorner
            ]
        } else {
            // Fallback on earlier versions
        }
    }
    
    func roundRB(radius:CGFloat = 5) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [
                .layerMaxXMaxYCorner
            ]
        } else {
            // Fallback on earlier versions
        }
    }
    
}

// MARK: - Background

extension UIView {
    
    func setDefaultBackground() {
        let topColor = UIColor(red: 125/255, green: 191/255, blue: 211/255, alpha: 1)
        let bottomColor = UIColor.white
        self.setBackgroundGradientColor(topColor: topColor, buttomColor: bottomColor, topPos: 0, bottomPos: 0.3)
    }
    
    func setBackgroundGradientColor(topColor: UIColor, buttomColor: UIColor, topPos: NSNumber, bottomPos: NSNumber) {
        //???????????????????????????????????????????????????
//        let topColor = UIColor(red: 199/255, green: 36/255, blue: 111/255, alpha: 1)
//        let buttomColor = UIColor(red: 38/255, green: 30/255, blue: 41/255, alpha: 1)
        let gradientColors = [topColor.cgColor, buttomColor.cgColor]

        //?????????????????????????????????
        let gradientLocations:[NSNumber] = [topPos, bottomPos]

        //??????CAGradientLayer?????????????????????
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations

        //?????????CAGradientLayer?????????frame????????????view???layer
        gradientLayer.frame = UIScreen.main.bounds // self.frame
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

// MARK: - Blur

extension UIView {
    func blur() {
        backgroundColor = UIColor.clear
        let backend = UIToolbar(frame: bounds)
        backend.barStyle = .default
        backend.clipsToBounds = true
        insertSubview(backend, at: 0)
    }
}


//??????????????????
public enum ShakeDirection: Int {
    case horizontal  //????????????
    case vertical  //????????????
}

extension UIView {
    
    /**
     ??????UIView??????????????????
     
     @param direction??????????????????????????????????????????
     @param times????????????????????????5??????
     @param interval??????????????????????????????0.1??????
     @param delta???????????????????????????2???
     @param completion?????????????????????????????????
     
     */
    public func shake(direction: ShakeDirection = .horizontal, times: Int = 5,
                      interval: TimeInterval = 0.1, delta: CGFloat = 2,
                      completion: (() -> Void)? = nil) {
        //????????????
        UIView.animate(withDuration: interval, animations: { () -> Void in
            switch direction {
            case .horizontal:
                self.layer.setAffineTransform( CGAffineTransform(translationX: delta, y: 0))
                break
            case .vertical:
                self.layer.setAffineTransform( CGAffineTransform(translationX: 0, y: delta))
                break
            }
        }) { (complete) -> Void in
            //????????????????????????????????????????????????????????????????????????????????????
            if (times == 0) {
                UIView.animate(withDuration: interval, animations: { () -> Void in
                    self.layer.setAffineTransform(CGAffineTransform.identity)
                }, completion: { (complete) -> Void in
                    completion?()
                })
            }
            //???????????????????????????????????????????????????????????????????????????1?????????????????????????????????
            else {
                self.shake(direction: direction, times: times - 1,  interval: interval,
                           delta: delta * -1, completion:completion)
            }
        }
    }
}

// MARK: - Nib

// ??????
protocol NibLoadable {
    // ??????????????????extension???
}

// ??????nib
extension NibLoadable where Self : UIView {
    static func loadFromNib(_ nibname : String? = nil) -> Self {
        let loadName = nibname == nil ? "\(self)" : nibname!
        return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
    }
}
