import UIKit

class FriendCell: UITableViewCell {
    private let friendNameLabel = Label(title: "", fontSize: Src.Sizes.space30)
 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(title: String) {
        friendNameLabel.text = title
    }
    
    private func setUI() {
        addSubview(friendNameLabel)
        friendNameLabel.frame = CGRect(x: Src.Sizes.space10, y: 0, width: frame.width, height: frame.height)
    }
}

