import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {
    private let headerView = AuthHeaderView(title: "Регистрация")
    private let loginTextField = AuthTextField(fieldType: .login)
    private let emailTextField = AuthTextField(fieldType: .email)
    private let passwordTextField = AuthTextField(fieldType: .password)
    private let signUpButton = AuthButton(title: "Создать аккаунт", hasBackground: true, fontSize: .big)
    private let iHaveAnAccount = AuthButton(title: "У меня есть аккаунт", hasBackground: false, fontSize: .med)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setActions()

        hideKeyboardByTapOnVoid()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - Actions
extension RegisterViewController {
    private func setActions() {
        signUpButton.addTarget(self, action: #selector(tapSignUp), for: .touchUpInside)
        iHaveAnAccount.addTarget(self, action: #selector(tapIHaveNoAccount), for: .touchUpInside)
    }
    
    @objc func tapSignUp() { // fixme Все проверки выполняются асинк - nextVC не успевает принять значение false
        signUpButton.turnOffButtonIf(true, title: "")
        
        let login = loginTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        // Валидация введенных полей
        let db = Firestore.firestore()
        let usersCollection = db.collection("users")

        validateUsersList(userCollection: usersCollection, login: login, email: email) {
            [weak self] loginValid, emailValid, error in // нужен ли здесь weak self?
            
            defer {
                self?.signUpButton.turnOffButtonIf(false, title: "Создать аккаунт")
            }
            
            guard let self = self else { return }
            var nextVc = true
            
            if let error = error {
                print("Ошибка получения документов: \(error)")
                signUpButton.turnOffButtonIf(false, title: "")
                return
            }
            
            if !loginValid! || !isValidLogin(login: login) {
                Src.showInvalidLoginAlert(vc: self)
            } else if !emailValid! || !isValidEmail(email: email) {
                Src.showInvalidEmailAlert(vc: self)
            } else if !isValidPassword(password: password) {
                Src.showInvalidPasswordAlert(vc: self)
            } else {
                Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
                    guard let self = self else { return }
                    if let _ = error {
                        print("createUser error")
                        nextVc = false
                        Src.showInvalidEmailAlert(vc: self)
                        return
                    }
                    
                    guard let resultUser = result?.user else {
                        print("resultUser error")
                        nextVc = false
                        Src.showSecondUnknownErrorAlert(vc: self)
                        return
                    }
                    
                    resultUser.sendEmailVerification() { error in
                        if let _ = error {
                            print("sendEmail error")
                            nextVc = false
                            Src.showSecondUnknownErrorAlert(vc: self)
                            return
                        }
                    }
                    
                    // Добавление пользователя в базу данных
                    let db = Firestore.firestore()
                    let loc = GeoPoint(latitude: 0.0, longitude: 0.0)
                    
                    db.collection("users")
                        .document(resultUser.uid)
                        .setData([
                            "login": login,
                            "email": email,
                            "password": password,
                            "friends": [String](),
                            "invites": [String](),
                            "location": loc
                        ]) { error in
                            if error != nil {
                                print("db error")
                                nextVc = false
                                Src.showSecondUnknownErrorAlert(vc: self)
                                return
                            }
                        }
                    
                    if nextVc {
                        let vc = ConfirmViewController()
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                }
            }
        }

    }
        
    @objc func tapIHaveNoAccount() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - Support functions
extension RegisterViewController {
    private func validateUsersList(userCollection: CollectionReference,
                              login: String,
                              email: String,
                              completion: @escaping (Bool?, Bool?, Error?) -> Void) {
        userCollection.getDocuments { (querySnapshot, error) in
            var loginValid = true
            var emailValid = true
            
            if let error = error {
                completion(nil, nil, error)
            }
            
            guard let documents = querySnapshot?.documents else {
                print("Документы отсутствуют")
                return
            }
            
            for document in documents {
                let documentData = document.data()
                
                for (key, value) in documentData {
                    if key == "login" && value as! String == login {
                        print(key, value)
                        loginValid = false
                    }
                    
                    if key == "email" && value as! String == email {
                        print(key, value)
                        emailValid = false
                    }
                }
            }
        
            completion(loginValid, emailValid, nil)
        }
    }
    
    private func isValidEmail(email: String) -> Bool {
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.{1}[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func isValidLogin(login: String) -> Bool {
        if login != "" {
            return true
        } else {
            return false
        }
    }
    
    private func isValidPassword(password: String) -> Bool {
        let password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[$@$#!%*?&]).{6,32}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
}

// MARK: - UI
extension RegisterViewController {
    private func setUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(headerView)
        view.addSubview(loginTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signUpButton)
        view.addSubview(iHaveAnAccount)
  
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: Src.Sizes.space200),
            
            loginTextField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: Src.Sizes.space15),
            loginTextField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            loginTextField.heightAnchor.constraint(equalToConstant: Src.Sizes.space55),
            loginTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Src.Sizes.space085),
            
            emailTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: Src.Sizes.space15),
            emailTextField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: Src.Sizes.space55),
            emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Src.Sizes.space085),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: Src.Sizes.space15),
            passwordTextField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: Src.Sizes.space55),
            passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Src.Sizes.space085),
            
            signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: Src.Sizes.space15),
            signUpButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: Src.Sizes.space55),
            signUpButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Src.Sizes.space085),
            
            iHaveAnAccount.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: Src.Sizes.space10),
            iHaveAnAccount.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
        ])
    }
}
