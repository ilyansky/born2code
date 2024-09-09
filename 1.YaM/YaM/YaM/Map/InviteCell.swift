import UIKit

class InviteCell: UITableViewCell {

    private let inviteLabel = Label(title: "", fontSize: Src.Sizes.space30, alignment: .left)
    private let accept = CircleButton(buttonSize: Src.Sizes.space50, imageNamed: "accept", imageColor: Src.Color.green)
    private let reject = CircleButton(buttonSize: Src.Sizes.space50, imageNamed: "reject", imageColor: Src.Color.purple)
    let model = YaMModel()
    var com: (() -> Void)?
 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    func setCell(title: String) {
        inviteLabel.text = title
    }
    
    @objc func tapAccept() {
        // Удаляю приглашение из invite листа
        tapReject()
        
        // Добавляю приглашающего в свой список друзей
        model.addToArray(loginForSearch: Src.selfLogin, arrayTitleForSearch: "friends", newValue: inviteLabel.text!) {}
        
        // Добавляю себя в список друзей приглашающего
        model.addToArray(loginForSearch: inviteLabel.text!, arrayTitleForSearch: "friends", newValue: Src.selfLogin) {}
    }
    
    @objc func tapReject() {
        model.removeFromArray(loginForSearch: Src.selfLogin, array: "invites", valueToRemove: inviteLabel.text!) {
            self.com?()
        }
    }
    
    private func setUI() {
        addSubview(inviteLabel)
        addSubview(accept)
        addSubview(reject)
        
        accept.addTarget(self, action: #selector(tapAccept), for: .touchUpInside)
        reject.addTarget(self, action: #selector(tapReject), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            inviteLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            inviteLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Src.Sizes.space10),
            
            accept.centerYAnchor.constraint(equalTo: centerYAnchor),
            accept.trailingAnchor.constraint(equalTo: reject.leadingAnchor, constant: -Src.Sizes.space10),
            accept.widthAnchor.constraint(equalToConstant: Src.Sizes.space50),
            accept.heightAnchor.constraint(equalToConstant: Src.Sizes.space50),
            
            reject.centerYAnchor.constraint(equalTo: centerYAnchor),
            reject.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Src.Sizes.space10),
            reject.widthAnchor.constraint(equalToConstant: Src.Sizes.space50),
            reject.heightAnchor.constraint(equalToConstant: Src.Sizes.space50),
        ])
    }

}
