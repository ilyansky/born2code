import UIKit

struct Src {
    struct Colors {
        static let black = UIColor(red: 0.471, green: 0.471, blue: 0.471, alpha: 1.0)
        static let white = UIColor(red: 1, green: 1, blue: 1, alpha: 1.00)
        static let grey1 = UIColor(red: 0.11, green: 0.12, blue: 0.13, alpha: 1.00)
        static let grey3 = UIColor(red: 0.18, green: 0.19, blue: 0.21, alpha: 1.00)
        static let grey4 = UIColor(red: 0.24, green: 0.25, blue: 0.26, alpha: 1.00)
        
        static let searchBack = UIColor(red: 36/255, green: 37/255, blue: 41/255, alpha: 1)
        static let swipeCapsule = UIColor(red: 94/255, green: 95/255, blue: 97/255, alpha: 1)
        static let textFieldView = UIColor(red: 47/255, green: 48/255, blue: 53/255, alpha: 1)
        static let separator = UIColor(red: 0.62, green: 0.62, blue: 0.62, alpha: 1.00)
        static let blue = UIColor(red: 0.30, green: 0.58, blue: 1.00, alpha: 1.00)
        static let subtitle = UIColor(red: 94/255, green: 95/255, blue: 97/255, alpha: 1)
        static let tableView = UIColor(red: 62/255, green: 63/255, blue: 67/255, alpha: 1)
        static let directFlightsTableView = UIColor(red: 29/255, green: 30/255, blue: 32/255, alpha: 1)
        static let offersTicketsPrice = UIColor(red: 34/255, green: 97/255, blue: 188/255, alpha: 1)
        static let redCircle = UIColor(red: 255/255, green: 94/255, blue: 94/255, alpha: 1)
        static let tripInfo = UIColor(red: 159/255, green: 159/255, blue: 159/255, alpha: 1)
    }

    static func fillAllFieldsAlert(view: UIViewController) {
        let alert = UIAlertController(title: "Заполните все поля", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        view.present(alert, animated: true)
    }
}

extension String {
    subscript(index: Int) -> Character {
        guard index >= 0 && index < self.count else {
            fatalError("Index \(index) is out of bounds for string with \(count) characters.")
        }
        return self[self.index(self.startIndex, offsetBy: index)]
    }
}
