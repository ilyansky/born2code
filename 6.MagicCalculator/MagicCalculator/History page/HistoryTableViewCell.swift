import UIKit

class HistoryTableViewCell: UITableViewCell {
    @IBOutlet private weak var expression: UILabel!
    
    func setCellTitle(with exp: String) {
        expression?.text = exp
        expression?.font = UIFont.systemFont(ofSize: 20.0)
        expression?.adjustsFontSizeToFitWidth = true
        expression?.minimumScaleFactor = 0.5
    }
    
}
