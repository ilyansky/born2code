import UIKit

class AgendaCell: UITableViewCell {

    static let id = "AgendaCell"
    var saveCellInfo: (_ text: String) -> Void = { text in }
    
    static func nib() -> UINib {
        return UINib(nibName: id, bundle: nil)
    }
    
    @IBOutlet weak var aimTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        aimTextView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setAimCell(aim: Aim) {
        aimTextView.text = aim.aimTitle
    }
}


// MARK: - TextView
extension AgendaCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
        
        if let tableView = superview as? UITableView {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        
        saveCellInfo(textView.text)
    }
}
