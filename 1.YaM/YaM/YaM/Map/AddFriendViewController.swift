import UIKit
import FirebaseFirestore

class AddFriendViewController: UIViewController {
    private let addFriendLabel = Label(title: "Добавить друга")
    private let invitesButton = AuthButton(title: "Отправить запрос", hasBackground: true, fontSize: .big)
    private let friendLoginTextField = AuthTextField(fieldType: .login)
    private let inviteListLabel = Label(title: "Список приглашений")
    public let invitesTable = UITableView()
    let model = YaMModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setCoreTableView()
        fetchAndUpdateTableView()
//        fetchFriendsList() // Получаю список друзей для проверки в tapInvite
    }

    @objc func tapInvite() {
        invitesButton.turnOffButtonIf(true, title: "")
        
        defer {
            invitesButton.turnOffButtonIf(false, title: "Отправить запрос")
        }
        
        let login = friendLoginTextField.text ?? ""
         
        if login.isEmpty {
            Src.showInvalidLoginAlert(vc: self)
            return
        } else if login == Src.selfLogin {
            Src.showItsYourLoginAlert(vc: self)
            return
        } else if model.invitesList.contains(login) {
            Src.showYouHaveInviteFromThisUserAlert(vc: self)
            return
        } else if model.friendsList.contains(login) {
            Src.showThisIsYourFriendAlert(vc: self)
            return
        }
        
        model.checkUserExists(login: login) { res in
            if res {
                self.model.addToArray(loginForSearch: login, arrayTitleForSearch: "invites", newValue: Src.selfLogin) {
                    Src.showInviteSentlert(vc: self)
                }
            } else {
                Src.showUserDoesntExistAlert(vc: self)
                return
            }
        }
        
       
    }

}

// MARK: - Delegates
extension AddFriendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.invitesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = invitesTable.dequeueReusableCell(withIdentifier: TableView.cellIdInvite, for: indexPath) as! InviteCell
        cell.selectionStyle = .none
        cell.backgroundColor = .secondarySystemBackground
        cell.contentView.isUserInteractionEnabled = false
        cell.setCell(title: model.invitesList[indexPath.row])
        cell.com = {
            self.fetchAndUpdateTableView()
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Src.Sizes.space70
    }
}

// MARK: - Вспомогательные функции
extension AddFriendViewController {
    private func setCoreTableView() {
        invitesTable.register(InviteCell.self, forCellReuseIdentifier: TableView.cellIdInvite)
        invitesTable.delegate = self
        invitesTable.dataSource = self
    }

    private func fetchAndUpdateTableView() {
        model.getArray(loginForSearch: Src.selfLogin, arrayTitleForSearch: "invites", arrayType: .invite) {
            TableView.reloadTableView(tv: self.invitesTable)
        }
    }
    
    private func fetchFriendsList() {
        model.getArray(loginForSearch: Src.selfLogin, arrayTitleForSearch: "friends", arrayType: .friend) {}
    }
}

// MARK: - UI
extension AddFriendViewController {
    private func setUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(addFriendLabel)
        view.addSubview(friendLoginTextField)
        view.addSubview(invitesButton)
        view.addSubview(inviteListLabel)
        view.addSubview(invitesTable)
        
        friendLoginTextField.translatesAutoresizingMaskIntoConstraints = false
        friendLoginTextField.placeholder = "Имя друга"
        
        invitesButton.translatesAutoresizingMaskIntoConstraints = false
        invitesButton.addTarget(self, action: #selector(tapInvite), for: .touchUpInside)
        
        invitesTable.translatesAutoresizingMaskIntoConstraints = false
        invitesTable.backgroundColor = .systemBackground
        invitesTable.layer.cornerRadius = Src.Sizes.space15
        
        
        NSLayoutConstraint.activate([
            addFriendLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Src.Sizes.space30),
            addFriendLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            friendLoginTextField.topAnchor.constraint(equalTo: addFriendLabel.bottomAnchor, constant: Src.Sizes.space15),
            friendLoginTextField.centerXAnchor.constraint(equalTo: addFriendLabel.centerXAnchor),
            friendLoginTextField.heightAnchor.constraint(equalToConstant: Src.Sizes.space55),
            friendLoginTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Src.Sizes.space085),
            
            invitesButton.topAnchor.constraint(equalTo: friendLoginTextField.bottomAnchor, constant: Src.Sizes.space15),
            invitesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            invitesButton.heightAnchor.constraint(equalToConstant: Src.Sizes.space55),
            invitesButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Src.Sizes.space085),
            
            inviteListLabel.topAnchor.constraint(equalTo: invitesButton.bottomAnchor, constant: Src.Sizes.space30),
            inviteListLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            invitesTable.topAnchor.constraint(equalTo: inviteListLabel.bottomAnchor, constant: Src.Sizes.space15),
            invitesTable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            invitesTable.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            invitesTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Src.Sizes.space15)
        ])
    }
}

