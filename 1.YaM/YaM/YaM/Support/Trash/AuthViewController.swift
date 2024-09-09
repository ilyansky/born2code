import UIKit
//import FirebaseAuth
//import FirebaseDatabase

enum Status {
    case signIn
    case signUp
}

class AuthViewController: UIViewController {
    // result.user.uid
    @IBOutlet weak var auth: UILabel!
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var passw: UITextField!
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var changeStatusButton: UIButton!
    private let hideKeyboard = UIButton()
    private var status = Status.signIn
    private let usersListUrl = "https://yam-server-ad898-default-rtdb.europe-west1.firebasedatabase.app/users.json"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        keyboardObserver()
    }
    
    @IBAction func changeStatus(_ sender: Any) {
        if status == .signIn {
            status = .signUp
            changeStatusButton.setTitle("У меня есть аккаунт", for: .normal)
            auth.text = "Регистрация"
            login.isHidden = false
        } else {
            status = .signIn
            changeStatusButton.setTitle("У меня нет аккаунта", for: .normal)
            auth.text = "Авторизация"
            login.isHidden = true
        }
    }
    
    @IBAction func tapDone(_ sender: Any) {
    /*
        let login = login.text!
        let mail = mail.text!
        let passw = passw.text!
        
        if status == .signIn {
            Auth.auth().signIn(withEmail: mail, password: passw) { result, error in
                if error == nil {
                    self.dismiss(animated: true)
                } else {
                    self.present(Src.showAlert(), animated: true)
                    print("Sign in failed\n")
                }
            }
        } else {
            getUsersList(login: login) { js in
                var dupliLogin = false
                var dupliMail = false
                
                guard let json = js else { 
//                    print("here")
                    return }
                
                for lgn in json {
//                    print(dupliMail, dupliLogin)

                    // Проверка на существующий логин
                    if lgn.key == login {
                        dupliLogin = true
                        break
                    }
                    
                    // Проверка на существующий маил
                    let dict = lgn.value as! [String: Any]
                    if dict["email"] as! String == mail {
                        dupliMail = true
                        break
                    }
                    
                }
                
                if !dupliLogin && !dupliMail {
                    Auth.auth().createUser(withEmail: mail, password: passw) { result, error in
                        if error == nil {
                            if result != nil {
                                DispatchQueue.main.async {
                                    self.dismiss(animated: true)
                                    let ref = Database.database().reference().child("users")
                                    ref.child("\(login)").updateChildValues(["email": mail, "password": passw/*, "uid": fixme*/])
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.present(Src.showAlert(), animated: true)
                                    print("result = nil")
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.present(Src.showAlert(), animated: true)
                                print("error = nil")
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.present(Src.showAlert(), animated: true)
                        print("Dupli mail/login")
                    }
                }
            }
            
        }
        */
    }
    
}

// MARK: - Серверная часть
extension AuthViewController {
    private func getUsersList(login: String, completion: @escaping ([String: Any]?) -> Void) {
        guard let url = URL(string: usersListUrl) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                completion(json)
            }
        }.resume()
    }
}

// MARK: - Keyboard show/hide
extension AuthViewController {
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
extension AuthViewController {
    private func setUI() {
        // hideKeyboard button
        Src.setHideKeyboard(view: view, hideKeyboard: hideKeyboard)
        Src.setHideKeyboardPosition(view: view, hideKeyboard: hideKeyboard)
        hideKeyboard.addTarget(self, action: #selector(hideKeySignIn), for: .touchUpInside)
        
        login.backgroundColor = Src.Color.purple
        login.isHidden = true
        mail.backgroundColor = Src.Color.purple
        passw.backgroundColor = Src.Color.purple
    }
    
    
}
