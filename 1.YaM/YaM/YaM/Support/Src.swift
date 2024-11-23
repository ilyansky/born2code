import UIKit
import FirebaseFirestore
import UIKit

extension UIViewController {
    // Скрыть клавиатуру по тапу на пустое место
    func hideKeyboardByTapOnVoid() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.hideKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

class Src {
    enum Color {
        static let purple =  #colorLiteral(red: 0.6791635156, green: 0.260504663, blue: 0.8906775117, alpha: 1)
        static let green =  #colorLiteral(red: 0.1280630529, green: 0.9192457795, blue: 0.4505957961, alpha: 1)
        static let dark =  #colorLiteral(red: 0.1678080261, green: 0.2380830348, blue: 0.3642245829, alpha: 1)
    }
    
    enum Sizes {
        static let space085: CGFloat = 0.85
        static let space10: CGFloat = 10
        static let space15: CGFloat = 15
        static let space20: CGFloat = 20
        static let space30: CGFloat = 30
        static let space40: CGFloat = 40
        static let space50: CGFloat = 50
        static let space55: CGFloat = 55
        static let space70: CGFloat = 70
        static let space200: CGFloat = 200

    }
    
    // URLs
//    static let friendsListUrl = "https://yam-server-ad898-default-rtdb.europe-west1.firebasedatabase.app/users.json"    
    static var selfLogin = ""
   
    
    static func setHideKeyboard(view: UIView, hideKeyboard: UIButton) {
        view.addSubview(hideKeyboard)
        hideKeyboard.setImage(UIImage(named: "hidek"), for: .normal)
        hideKeyboard.layer.cornerRadius = 25
        hideKeyboard.isHidden = true
        hideKeyboard.backgroundColor = Src.Color.purple
    }
    
    static func setHideKeyboardPosition(view: UIView, hideKeyboard: UIButton) {
        hideKeyboard.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hideKeyboard.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -10),
            hideKeyboard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            hideKeyboard.widthAnchor.constraint(equalToConstant: 50),
            hideKeyboard.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    static var time1 = Date()
    static var time2 = Date()
    
    static func fetchCurrentTime() -> Date {
        let now = Date()
        /*
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: now)
        let nanosec = components.nanosecond ?? 0
        let form = DateFormatter()
        form.dateFormat = "dd-MM-yyyy' | 'HH:mm:ss"
        form.timeZone = TimeZone(secondsFromGMT: 0)
        
        let dateString = form.string(from: now)
        let nanosecString = String(format: "%06d", nanosec)
        
        print(dateString)
        print(nanosecString)
         */
        return Date()
    }
    
    static func printSubTime(time1: Date, time2: Date) {
        let timeInterval = time2.timeIntervalSince(time1)
        print("Время обслуживания = \(timeInterval)")
        Src.time1 = Date()
        Src.time2 = Date()
    }

    // MARK: - Alerts
    static func showAlert(vc: UIViewController, title: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default))
            vc.present(alert, animated: true)
        }
    }
}

class TableView {
    static let cellIdFriend = "friend"
    static let cellIdInvite = "invite"
    
        
    static func reloadTableView(tv: UITableView) {
        DispatchQueue.main.async {
            tv.reloadData()
        }
    }
}
