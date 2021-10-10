import UIKit

protocol AdButtonDelegate {
    func onTapAdButton(_ btn: YuanButton)
}

class YuanButton: UIButton {
    
    let defaultColor: String = "#d9d6c3"
    let disableColor: String = "#ea66a6"
    
    let defaultmark: String = "yky_jia"
    let disableMark: String = "yky_dui"
    let unableMark: String = "yky_jinzhi"
//    let imgName = "ggres.bundle/AlbumAddBtn@2x.png"
    
    var delegate: AdButtonDelegate?
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isTouchInside {
            Log.debug("btn tag: \(self.tag)")
            self.delegate?.onTapAdButton(self)
        }
    }

}
