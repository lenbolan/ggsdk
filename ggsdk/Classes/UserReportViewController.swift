import UIKit
import WebKit

class UserReportViewController: UIViewController {
    
    private var strUrl = "https://app.niuit.cn/member.php/member/index/index.html"
    
    init(strUrl: String?) {
        super.init(nibName: nil, bundle: nil)
        if strUrl != nil && strUrl != "" {
            self.strUrl = strUrl!
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let webview = WKWebView()
        webview.frame = view.frame
        view.addSubview(webview)
        
        if let url = URL(string: strUrl) {
            webview.load(URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData))
        }
    }

}
