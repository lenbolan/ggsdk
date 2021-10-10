import UIKit

class TopBarViewController: UIViewController {
    
    var plat: AdPlatform!
    
    private var oldIndex = 0
    private let btnSpace:CGFloat = 1.0
    
    private var pageViewController: UIPageViewController!
    private var pageControl:UIPageControl!
    
    private lazy var childVCs = [UIViewController]()
    private lazy var btns = [UIButton]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        childVCs.removeAll()
        btns.removeAll()
        
        if plat == .bu {
            childVCs.append(BUSplashViewController())
            childVCs.append(BUBannerViewController())
            childVCs.append(BUSignInViewController())
        } else {
            childVCs.append(GDTBannerViewController())
            childVCs.append(GDTSignInViewController())
            childVCs.append(GDTFlowViewController())
        }
        
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.setViewControllers([childVCs.first!], direction: .forward, animated: true, completion: nil)
        
        pageViewController.isPagingEnabled = false
        
        let y = UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height ?? 0) + 10
        let bg = UIView(frame: CGRect(x: 0, y: y, width: Util.screenWidth, height: 42))
        bg.backgroundColor = UIColor(hexString: "#DBDBDB")
        view.addSubview(bg)
        
        let titles = ["一档", "二档", "三档"]
        let btnWidth = (Util.screenWidth - (CGFloat(titles.count) - 1.0) * btnSpace) / CGFloat(titles.count)
        for i in 0..<titles.count {
            let btn = createBtn(title: titles[i], tag: i, wid: btnWidth)
            bg.addSubview(btn)
            btns.append(btn)
        }
        btns[0].isSelected = true
    }
    
    private func gotoPage(newIndex: Int) {
        if oldIndex == newIndex {
            
        } else {
            let vc = childVCs[newIndex]
            if oldIndex > newIndex {
                pageViewController.setViewControllers([vc], direction: .reverse, animated: true, completion: nil)
            } else {
                pageViewController.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
            }
            btns[oldIndex].isSelected = false
            oldIndex = newIndex
            btns[newIndex].isSelected = true
        }
    }
    
    private func createBtn(title: String, tag: Int, wid: CGFloat) -> UIButton {
        let x = CGFloat(tag) * (wid + btnSpace)
        let btn = UIButton(frame: CGRect(x: x, y: 1, width: wid, height: 40))
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.darkGray, for: .normal)
        btn.setTitleColor(.white, for: .selected)
        btn.setBackgroundColor(.white, for: .highlighted)
        btn.setBackgroundColor(.white, for: .normal)
        btn.setBackgroundColor(UIColor(hexString: "#FF3F3F")!, for: .selected)
        btn.tag = tag
        btn.addTarget(self, action: #selector(onTapBtn(_:)), for: .touchUpInside)
        return btn
    }
    
    @objc
    private func onTapBtn(_ sender: UIButton) {
        gotoPage(newIndex: sender.tag)
    }
    
}
