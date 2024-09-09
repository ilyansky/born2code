import UIKit

class RankInfoView: UIViewController {

    @IBOutlet weak var rankInfoView: UIView!

    @IBOutlet weak var intern: UIView!
    @IBOutlet weak var junior: UIView!
    @IBOutlet weak var middle: UIView!
    @IBOutlet weak var senior: UIView!
    @IBOutlet weak var architect: UIView!
    @IBOutlet weak var creator: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

}


// MARK: - UI
extension RankInfoView {
    private func setUI() {
        view.backgroundColor = Resources.Common.Colors.backgroundCard
        
        rankInfoView.backgroundColor = Resources.Common.Colors.backgroundCard
        rankInfoView.layer.cornerRadius = Resources.Common.Sizes.cornerRadius25
        
        // ranks
        [intern, junior, middle, senior, architect, creator].forEach { rank in
            rank.layer.masksToBounds = true
            rank.layer.cornerRadius = Resources.Common.Sizes.cornerRadius25
        }
        
        intern.backgroundColor = Resources.Common.Colors.blue
        junior.backgroundColor = Resources.Common.Colors.green
        middle.backgroundColor = Resources.Common.Colors.yellow
        senior.backgroundColor = Resources.Common.Colors.purple
        architect.backgroundColor = Resources.Common.Colors.red
        creator.backgroundColor = Resources.Common.Colors.creator
    }
}
