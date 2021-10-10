import UIKit

import Alamofire
import SwiftyJSON
import TZImagePickerController

class UploadImageViewController: UIViewController,
                                 UICollectionViewDelegate,
                                 UICollectionViewDataSource,
                                 URLSessionDelegate,
                                 URLSessionTaskDelegate,
                                 TZImagePickerControllerDelegate {
    
    private enum UploadState {
        case unselect
        case selected
        case uploading
        case uploadFailed
        case uploaded
        case submitting
        case submitFailed
        case success
    }
    
    private struct UPData {
        var selectedPhotos = [UIImage]()
        var selectedAssets = [PHAsset]()
        var uploadedAddress = [String]()
        var uploadFailed = [Int]()
        
        var totalNum: Int = 0
        var curIndex: Int = 0
        
//        0 unselect image
//        1 image selected
//        2 uploading
//        3 some images upload failed
//        4 uploaded
//        5 submitting
//        6 submit failed
//        7 success
        var uploadState: UploadState = .unselect
        
        var btnUpload: UIButton?
        var lbTip: UILabel?
    }
    
    private var arrUPData = Array(repeating: UPData(), count: 2)
    
    private var curSection = 0
    
    private let boundry = "----------V2ymHFg03ehbqgZCaKO6jy"
    
    private var lbSubmitTip: UILabel?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5);
        layout.minimumLineSpacing = 5
        let itemWH = CGFloat(Util.screenWidth)/4 - 10.0
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        layout.headerReferenceSize = CGSize(width: Util.screenWidth, height: 40)
        layout.footerReferenceSize = CGSize(width: Util.screenWidth, height: 80)
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UploadImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer")
        collectionView.backgroundColor = .white
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "上传凭证"
        
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
    }
    
//    MARK: - UICollectionViewDelegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section > 1 {
            return 0
        }
        return arrUPData[section].selectedPhotos.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! UploadImageCell
        if indexPath.row == arrUPData[indexPath.section].selectedPhotos.count {
            let imgName = "yky_AlbumAddBtn"
            let image = UIImage(named: imgName)
            cell.imageView?.image = image
            cell.deleteBtn?.isHidden = true
        } else {
            cell.imageView?.image = arrUPData[indexPath.section].selectedPhotos[indexPath.row]
            cell.asset = arrUPData[indexPath.section].selectedAssets[indexPath.row]
            cell.deleteBtn?.isHidden = false
        }
        if indexPath.section == 0 {
            cell.deleteBtn?.tag = indexPath.row + 1000
        } else {
            cell.deleteBtn?.tag = indexPath.row + 2000
        }
        cell.deleteBtn?.addTarget(self, action: #selector(deleteBtnClick(_:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reuseableView = UICollectionReusableView()
        
        if kind == UICollectionView.elementKindSectionHeader {
            reuseableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath)
            
            for child in reuseableView.subviews {
                child.removeFromSuperview()
            }
            reuseableView.backgroundColor = .clear
            
            if indexPath.section < 2 {
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: reuseableView.frame.width, height: 40))
                label.textAlignment = .center
                if indexPath.section == 0 {
                    label.text = "下载App截图上传"
                } else {
                    label.text = "其它上传"
                }
                reuseableView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
                reuseableView.addSubview(label)
            }
        } else if kind == UICollectionView.elementKindSectionFooter {
            reuseableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer", for: indexPath)
            let _frame = CGRect(x: (reuseableView.frame.width - 100)/2, y: 0, width: 100, height: 40)
            
            for child in reuseableView.subviews {
                child.removeFromSuperview()
            }
            
            if indexPath.section == 2 {
                let btnSubmit = UIButton(frame: _frame)
                btnSubmit.setTitle("提交数据", for: .normal)
                btnSubmit.setTitleColor(UIColor(r: 33, g: 33, b: 33), for: .normal)
                btnSubmit.borderWith = 1
                btnSubmit.cornerRadius = 8
                btnSubmit.borderColor = UIColor(r: 200, g: 200, b: 200)
                btnSubmit.addTarget(self, action: #selector(submit), for: .touchUpInside)
                reuseableView.addSubview(btnSubmit)
                
                let label = UILabel(frame: CGRect(x: 0, y: 50, width: reuseableView.frame.width, height: 20))
                label.textAlignment = .center
                label.textColor = UIColor(hexString: "#FF6767")
                label.text = ""
                lbSubmitTip = label
                reuseableView.addSubview(label)
            } else {
                let btnUpload = createUploadBtn(frame: _frame, section: indexPath.section)
                btnUpload.addTarget(self, action: #selector(onBtnTap(_:)), for: .touchUpInside)
                arrUPData[indexPath.section].btnUpload = btnUpload
                reuseableView.addSubview(btnUpload)
                
                let label = UILabel(frame: CGRect(x: 0, y: 40, width: reuseableView.frame.width, height: 20))
                label.textAlignment = .center
                label.text = ""
                arrUPData[indexPath.section].lbTip = label
                reuseableView.addSubview(label)
            }
        }
        
        return reuseableView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard arrUPData[indexPath.section].uploadState != .uploading &&
                arrUPData[indexPath.section].uploadState != .submitting else {
            Log.debug("sel, image state error - \(arrUPData[indexPath.section].uploadState)")
            view.makeToast("图片处理中")
            return
        }
        if indexPath.row == arrUPData[indexPath.section].selectedPhotos.count {
            self.pushTZImagePickerController(section: indexPath.section)
        }
    }
    
//    MARK: - URLSessionDelegate
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let _t = Double(totalBytesSent)
        let _p = Double(totalBytesExpectedToSend)
        let process = (_t / _p) * 100
//        Log.debug("===== \(_t) / \(_p) / \(process)")
        
        DispatchQueue.main.async { [self] in
            let curIndex = arrUPData[curSection].curIndex
            let totalNum = arrUPData[curSection].totalNum
            arrUPData[curSection].lbTip?.text = "上传图片中[\(curIndex+1)/\(totalNum)] - \(Int(process))%"
        }
    }
    
//    MARK: - TZImagePickerControllerDelegate
    
    func imagePickerController(_ picker: TZImagePickerController!,
                               didFinishPickingPhotos photos: [UIImage]!,
                               sourceAssets assets: [Any]!,
                               isSelectOriginalPhoto: Bool) {
        
        resetUploadState(section: curSection)
        
        arrUPData[curSection].selectedPhotos = photos
        arrUPData[curSection].selectedAssets = assets as! [PHAsset]
        collectionView.reloadData()
        
        arrUPData[curSection].uploadState = .selected
    }
    
//    MARK: - Logic
    
    private func pushTZImagePickerController(section: Int) {
        curSection = section
        guard let picker = TZImagePickerController(maxImagesCount: 9, delegate: self) else {
            return
        }
        picker.selectedAssets = array2NSMutableArray(arrUPData[section].selectedAssets)
        picker.allowTakeVideo = false
        picker.allowTakePicture = false
        picker.allowPickingOriginalPhoto = false
        self.present(picker, animated: true, completion: nil)
    }
    
    @objc
    private func deleteBtnClick(_ sender: UIButton) {
        let section = sender.tag >= 2000 ? 1 : 0
        var index = sender.tag - 1000
        index = index >= 1000 ? index - 1000 : index
        guard arrUPData[section].uploadState != .uploading &&
                arrUPData[section].uploadState != .submitting else {
            Log.debug("del, image state error - \(arrUPData[section].uploadState)")
            view.makeToast("图片处理中")
            return
        }

        arrUPData[section].selectedAssets.remove(at: index)
        arrUPData[section].selectedPhotos.remove(at: index)

        collectionView.performBatchUpdates({
            let indexPath = IndexPath(item: index, section: section)
            self.collectionView.deleteItems(at: [indexPath])
        }) { (finished) in
            self.collectionView.reloadData()
        }
    }
    
    private func createUploadBtn(frame: CGRect, section: Int) -> UIButton {
        let btn = UIButton(frame: frame)
        btn.setTitle("上传图片", for: .normal)
        btn.setTitleColor(UIColor(r: 33, g: 33, b: 33), for: .normal)
        btn.borderWith = 1
        btn.cornerRadius = 8
        btn.borderColor = UIColor(r: 200, g: 200, b: 200)
        btn.tag = section
        return btn
    }
    
    @objc
    private func onBtnTap(_ sender: UIButton) {
        curSection = sender.tag
        
        guard arrUPData[curSection].selectedPhotos.count > 0 else {
            view.makeToast("请先选择图片")
            return
        }
        guard arrUPData[curSection].uploadState != .uploading &&
                arrUPData[curSection].uploadState != .submitting else {
            view.makeToast("图片上传中")
            return
        }
        
        let isRetry = arrUPData[curSection].uploadState == .uploadFailed ? true : false
        
        arrUPData[curSection].uploadState = .uploading
        
        let dispatchQueue = DispatchQueue(label: "uploadImage")
        let semaphore = DispatchSemaphore(value: 0)
        var firstUp = -1
        
        arrUPData[curSection].totalNum = arrUPData[curSection].selectedPhotos.count
        for i in 0..<arrUPData[curSection].totalNum {
            if isRetry {
                if getFailIndex(section:curSection, i: i) {
                    
                } else {
                    continue
                }
            }
            dispatchQueue.async { [self] in
                if firstUp >= 0 {
                    semaphore.wait()
                }
                if firstUp == -1 {
                    firstUp = i
                }
                arrUPData[curSection].curIndex = i
                let pickedImage: UIImage = arrUPData[curSection].selectedPhotos[i]
                let originData = pickedImage.jpegData(compressionQuality: 1.0)
                var imageData:Data?
                if ((originData?.count ?? 0) / 1024) > 5000 {
                    imageData = pickedImage.jpegData(compressionQuality: 0.1)
                } else {
                    imageData = pickedImage.jpegData(compressionQuality: 0.3)
                }
                
                let url = URL(string: adRUpImg)
                let urlRequest = NSMutableURLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
                urlRequest.httpMethod = "POST"
                urlRequest.setValue("multipart/form-data; charset=utf-8;boundary=\(boundry)", forHTTPHeaderField: "Content-Type")
                let config = URLSessionConfiguration.default
                let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
                let uploadTask = session.uploadTask(with: urlRequest as URLRequest, from: getBodydataWithImage(fileData: imageData!)) { [self] data, response, error in
                    let json = JSON(data as Any)
                    Log.debug(json)
                    if json["code"] == 0 {
                        Log.debug("upload image \(i) success...")
                        if let imgAddr = json["data"]["url"].string {
                            arrUPData[curSection].uploadedAddress.append(imgAddr)
                        }
                    } else {
                        Log.debug("upload image \(i) failed...")
                        arrUPData[curSection].uploadFailed.append(i)
                    }
                    semaphore.signal()
                }
                uploadTask.resume()
                
//                #if DEBUG
//                模拟失败情况
//                if randomNum(min: 0, max: 99) > 50 {
//                    Log.debug("success \(i)")
//                    uploadedAddress.append("aaa \(i)")
//                } else {
//                    Log.debug("failed \(i)")
//                    uploadFailed.append(i)
//                }
//                semaphore.signal()
//                #endif
            }
        }
        dispatchQueue.async {
            semaphore.wait()
            DispatchQueue.main.async { [self] in
                checkUpState(section: curSection)
                semaphore.signal()
            }
        }
    }
    
    private func checkUpState(section: Int) {
        Log.debug("upload image finished...")
        if arrUPData[section].uploadedAddress.count > 0 {
            if arrUPData[section].uploadedAddress.count == arrUPData[section].selectedPhotos.count {
                Log.debug("upload image success - \(arrUPData[section].uploadedAddress.count)")
                
                arrUPData[curSection].lbTip?.text = "上传成功"
                arrUPData[section].uploadState = .uploaded
            } else if arrUPData[section].uploadFailed.count > 0 {
                Log.debug("some image upload failed...")
                Log.debug(arrUPData[section].uploadFailed)
                
                arrUPData[curSection].lbTip?.text = "部分图片上传失败，请重试"
                arrUPData[section].uploadState = .uploadFailed
            } else {
                Log.debug("upload image completed - \(arrUPData[section].uploadedAddress.count)")
                
                arrUPData[curSection].lbTip?.text = "上传成功"
                arrUPData[section].uploadState = .uploaded
            }
        }
    }
    
    private func getFailIndex(section: Int, i: Int) -> Bool {
        if let index = arrUPData[section].uploadFailed.firstIndex(of: i) {
            Log.debug("find failed \(i), at \(index)")
            Log.debug(arrUPData[section].uploadFailed)
            arrUPData[section].uploadFailed.remove(at: index)
            Log.debug("find failed \(i), at \(index) and removed")
            Log.debug(arrUPData[section].uploadFailed)
            return true
        }
        return false
    }
    
    private func getBodydataWithImage(fileData: Data) -> Data {
        let fileName = "screenshot"
        let bodyString = NSMutableString()
        bodyString.append("--\(boundry)\r\n")
        bodyString.append("Content-Disposition: form-data; name=\"FileName\"\r\n")
        bodyString.append("Content-Type: text/plain; charset=\"utf-8\"\r\n\r\n")
        bodyString.append("a\(fileName).jpg\r\n")
        
        bodyString.append("--\(boundry)\r\n")
        bodyString.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName).jpg\"\r\n")
        bodyString.append("Content-Type: image/jpeg\r\n\r\n")
        
        let bodyData = NSMutableData()
        bodyData.append(bodyString.data(using: String.Encoding.utf8.rawValue)!)
        bodyData.append(fileData)
        
        let endStr = NSString(string: "\r\n--\(boundry)--\r\n")
        bodyData.append(endStr.data(using: String.Encoding.utf8.rawValue)!)
        return bodyData as Data
    }
    
    @objc
    private func submit() {
        guard arrUPData[0].uploadState == .uploaded ||
                arrUPData[1].uploadState == .uploaded else {
            view.makeToast("请先上传图片")
            return
        }
        guard arrUPData[0].uploadState != .submitting &&
                arrUPData[1].uploadState != .submitting else {
            view.makeToast("数据提交中")
            return
        }
        lbSubmitTip?.text = "提交数据中..."
        arrUPData[0].uploadState = .submitting
        arrUPData[1].uploadState = .submitting
        let parameters = ["uid":AppReport.shared.baseAdInfo.uid ?? "1",
                          "app_mid": AppReport.shared.baseAdInfo.serverAppId,
                          "picurls":arrUPData[0].uploadedAddress,
                          "picurls2":arrUPData[1].uploadedAddress] as [String : Any]
        Alamofire.request(adRUpload, method: .post, parameters: parameters).responseJSON { [self] response in
            Log.debug(response)
            if let data = response.data {
                let json = JSON(data)
                if json["code"].int == 0 {
                    resetUploadStateAll()
                    collectionView.reloadData()
                    view.makeToast("上传凭证成功")
                    arrUPData[0].uploadState = .success
                    arrUPData[1].uploadState = .success
                } else {
                    view.makeToast(json["msg"].string ?? "请求数据异常...")
                    arrUPData[0].uploadState = .submitFailed
                    arrUPData[1].uploadState = .submitFailed
                }
            } else {
                view.makeToast("请求失败，请稍候重试...")
                arrUPData[0].uploadState = .submitFailed
                arrUPData[1].uploadState = .submitFailed
            }
        }
    }
    
    private func resetUploadState(section: Int) {
        arrUPData[section].selectedPhotos.removeAll()
        arrUPData[section].selectedAssets.removeAll()
        arrUPData[section].uploadedAddress.removeAll()
        arrUPData[section].uploadFailed.removeAll()
    }
    
    private func resetUploadStateAll() {
        for i in 0..<arrUPData.count {
            arrUPData[i].selectedPhotos.removeAll()
            arrUPData[i].selectedAssets.removeAll()
            arrUPData[i].uploadedAddress.removeAll()
            arrUPData[i].uploadFailed.removeAll()
        }
    }

}
