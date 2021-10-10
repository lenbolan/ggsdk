import UIKit

public extension UIImage {
    /**
     *  重设图片大小
     */
    func resizeImage(resize:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(resize,false,UIScreen.main.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: resize.width, height: resize.height))
        let resizeImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizeImage
    }
     
    /**
     *  等比率缩放
     */
    func scaleImage(scaleSize:CGFloat) -> UIImage {
        let resize = CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
        return resizeImage(resize: resize)
    }
    
}
