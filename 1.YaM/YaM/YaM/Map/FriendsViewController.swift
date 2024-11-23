import UIKit

class FriendsViewController: UIViewController {
    private let friendsLabel = Label(title: "Список друзей")
    private let friendsTable = UITableView()
    let model = YaMModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCoreTableView()
        setUI()
        fetchAndUpdateTableView()
    }
}

// MARK: - Delegates
extension FriendsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableView.cellIdFriend, for: indexPath) as! FriendCell
        cell.selectionStyle = .none
        cell.backgroundColor = .secondarySystemBackground
        cell.setCell(title: model.friendsList[indexPath.row])
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.friendsList.count
       }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Src.Sizes.space50
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { _, _, _ in
            self.model.removeFromArray(loginForSearch: self.model.friendsList[indexPath.row], array: "friends", valueToRemove: Src.selfLogin) {}
            self.model.removeFromArray(loginForSearch: Src.selfLogin, array: "friends", valueToRemove: self.model.friendsList[indexPath.row]) {
                self.fetchAndUpdateTableView()
            }
        }
        deleteAction.backgroundColor = Src.Color.purple
        let swipe = UISwipeActionsConfiguration(actions: [deleteAction])
        swipe.performsFirstActionWithFullSwipe = false
        return swipe
    }
    
}

// MARK: - Support functions
extension FriendsViewController {
    private func setCoreTableView() {
        friendsTable.register(FriendCell.self, forCellReuseIdentifier: TableView.cellIdFriend)
        friendsTable.delegate = self
        friendsTable.dataSource = self
    }
    
    private func fetchAndUpdateTableView() {
        model.getArray(loginForSearch: Src.selfLogin, arrayTitleForSearch: "friends", arrayType: .friend) {
            TableView.reloadTableView(tv: self.friendsTable)
        }
    }

}

// MARK: - UI
extension FriendsViewController {
    private func setUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(friendsLabel)
        view.addSubview(friendsTable)

        friendsTable.translatesAutoresizingMaskIntoConstraints = false
        friendsTable.backgroundColor = .systemBackground
        friendsTable.layer.cornerRadius = Src.Sizes.space15
        
        
        NSLayoutConstraint.activate([
            friendsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Src.Sizes.space30),
            friendsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            friendsTable.topAnchor.constraint(equalTo: friendsLabel.bottomAnchor, constant: Src.Sizes.space15),
            friendsTable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            friendsTable.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            friendsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Src.Sizes.space15)
        ])
    }
}

