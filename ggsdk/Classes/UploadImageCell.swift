import UIKit
import Photos.PHAsset

class UploadImageCell: UICollectionViewCell {
    
    var imageView: UIImageView?
    var deleteBtn: UIButton?
    
    var row: Int? {
        didSet {
            deleteBtn?.tag = row!
        }
    }
    
    var asset: PHAsset?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configView() {
        imageView = UIImageView(frame: contentView.bounds)
        imageView?.backgroundColor = UIColor(white: 1, alpha: 0.5)
        imageView?.contentMode = .scaleAspectFit
        contentView.addSubview(imageView!)
        imageView?.clipsToBounds = false
        
        deleteBtn = UIButton(frame: CGRect(x: contentView.frame.width - 36, y: 0, width: 36, height: 36))
//        let imgName = "photo_delete"
        let imgName = "yky_photo_delete"
        deleteBtn?.setImage(UIImage(named: imgName), for: .normal)
        deleteBtn?.imageEdgeInsets = UIEdgeInsets(top: -10, left: 0, bottom: 0, right: -10)
        deleteBtn?.alpha = 0.6
        contentView.addSubview(deleteBtn!)
    }
    
    @objc func snapshotView() -> UIView {
        let snapshotView = UIView()

        var cellSnapshotView: UIView?

        if self.responds(to: #selector(snapshotView(afterScreenUpdates:))) {
            cellSnapshotView = self.snapshotView(afterScreenUpdates: false)
        } else {
            let size = CGSize(width: bounds.width + 20, height: bounds.height + 20)
            UIGraphicsBeginImageContextWithOptions(size, self.isOpaque, 0)
            self.layer.render(in: UIGraphicsGetCurrentContext()!)
            let cellSnapshotImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            cellSnapshotView = UIImageView(image: cellSnapshotImage)
        }

        snapshotView.frame = CGRect(x: 0, y: 0, width: (cellSnapshotView?.frame.width)!, height: (cellSnapshotView?.frame.height)!)
        cellSnapshotView?.frame = CGRect(x: 0, y: 0, width: (cellSnapshotView?.frame.width)!, height: (cellSnapshotView?.frame.height)!)
        snapshotView.addSubview(cellSnapshotView!)

        return snapshotView;
    }
    
}
