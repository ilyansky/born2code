import UIKit
/*
class AddFriendViewController3: UIViewController {

    @IBOutlet weak var addFriend: UILabel!
    @IBOutlet weak var friendEmail: UITextField!
    private let hideKeyboard = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        keyboardObserver()
    }
    
    
}

// MARK: - Keyboard show/hide
extension AddFriendViewController {
    private func keyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyWillShow(_ notification: Notification) {
        hideKeyboard.isHidden = false
    }
    
    @objc func keyWillHide(_ notification: Notification) {
        hideKeyboard.isHidden = true
    }
    
    @objc func hideKeySignIn() {
        view.endEditing(true)
    }
}


// MARK: - UI
extension AddFriendViewController {
    private func setUI() {
        // hideKeyboard button
        Src.setHideKeyboard(view: view, hideKeyboard: hideKeyboard)
        Src.setHideKeyboardPosition(view: view, hideKeyboard: hideKeyboard)
        hideKeyboard.addTarget(self, action: #selector(hideKeySignIn), for: .touchUpInside)
    }
    
}
*/
