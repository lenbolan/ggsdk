import UIKit

public extension UIViewController {
    
    @objc func setupAdWinHelp() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(openAdPages),
                                               name: NSNotification.Name(NotiName.openAd.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(openLoginView),
                                               name: NSNotification.Name(NotiName.openLoginView.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(openRegistView),
                                               name: NSNotification.Name(NotiName.openRegistView.rawValue),
                                               object: nil)
    }
    
    @objc private func openAdPages() {
        openVC(TabBarViewController())
    }
    
    @objc private func openLoginView() {
        openVC(LoginViewController())
    }
    
    @objc private func openRegistView() {
        openVC(RegistViewController())
    }
    
    private func openVC(_ vc: UIViewController) {
        if let nav = navigationController {
            nav.pushViewController(vc, animated: true)
        } else {
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func setdownAdWinHelp() {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(NotiName.openAd.rawValue),
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(NotiName.openLoginView.rawValue),
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(NotiName.openRegistView.rawValue),
                                                  object: nil)
    }
    
}
