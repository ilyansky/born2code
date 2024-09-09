import UIKit

enum Tabs: Int {
    case airTickets = 1
    case pass = 0
}

enum Transitions {
    case crossDisolve
    case coverVertical
}

enum Presentations {
    case automatic
    case fullscreen
}

class Coordinator: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCoordinator()
    }
    
    //    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    //        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    //    }
    //
    //    required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    public func configureCoordinator() {
        tabBar.tintColor = Src.Colors.blue
        tabBar.barTintColor = Src.Colors.separator
        
        let topBorder = CALayer()
        topBorder.borderColor = Src.Colors.grey1.cgColor
        topBorder.borderWidth = 1.0
        topBorder.frame = CGRect(x: 0, y: 0, width: tabBar.frame.size.width, height: 1)
        tabBar.layer.addSublayer(topBorder)
        
        let airTickets = AirTicketsView()
        let hotels = PassView()
        let shorter = PassView()
        let subs = PassView()
        let profile = PassView()
        
        airTickets.tabBarItem = UITabBarItem(title: "Авиабилеты", image: UIImage(systemName: "paperplane"), tag: Tabs.airTickets.rawValue)
        hotels.tabBarItem = UITabBarItem(title: "Отели", image: UIImage(systemName: "bed.double"), tag: Tabs.pass.rawValue)
        shorter.tabBarItem = UITabBarItem(title: "Короче", image: UIImage(named: "shorter"), tag: Tabs.pass.rawValue)
        subs.tabBarItem = UITabBarItem(title: "Подписки", image: UIImage(named: "subs"), tag: Tabs.pass.rawValue)
        profile.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(named: "profile"), tag: Tabs.pass.rawValue)
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)
        ]
        
        airTickets.tabBarItem.setTitleTextAttributes(attributes, for: .normal)
        hotels.tabBarItem.setTitleTextAttributes(attributes, for: .normal)
        shorter.tabBarItem.setTitleTextAttributes(attributes, for: .normal)
        subs.tabBarItem.setTitleTextAttributes(attributes, for: .normal)
        profile.tabBarItem.setTitleTextAttributes(attributes, for: .normal)
        
        setViewControllers([airTickets, hotels, shorter, subs, profile], animated: false)
    }
    
}

// MARK: - Screen managment
extension Coordinator {
    static func openModalSearch(view: UIViewController, textField: UITextField) {
        openView(viewFrom: view, viewTo: SearchView(), presentationStyle: .automatic, transitionStyle: .coverVertical)
        textField.resignFirstResponder()
    }
    
    static func openView(viewFrom: UIViewController, viewTo: UIViewController, presentationStyle: Presentations, transitionStyle: Transitions) {
        switch presentationStyle {
        case .automatic:
            viewTo.modalPresentationStyle = .automatic
        case .fullscreen:
            viewTo.modalPresentationStyle = .fullScreen
        }
        
        switch transitionStyle {
        case .crossDisolve:
            viewTo.modalTransitionStyle = .crossDissolve
        case .coverVertical:
            viewTo.modalTransitionStyle = .coverVertical
        }
        
        viewFrom.present(viewTo, animated: true)
    }
    
    static func closeView(view: UIViewController) {
        view.dismiss(animated: true)
    }
}
