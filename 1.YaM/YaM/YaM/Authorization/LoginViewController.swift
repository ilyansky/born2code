import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    private let headerView = AuthHeaderView(title: "Авторизация")
    private let emailTextField = AuthTextField(fieldType: .email)
    private let passwordTextField = AuthTextField(fieldType: .password)
    
    private let iHaveNoAccount = AuthButton(title: "У меня нет аккаунта", hasBackground: false, fontSize: .med)
    private let signInButton = AuthButton(title: "Войти", hasBackground: true, fontSize: .big)
    
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
extension LoginViewController {
    private func setActions() {
        signInButton.addTarget(self, action: #selector(tapSignIn), for: .touchUpInside)
        iHaveNoAccount.addTarget(self, action: #selector(tapIHaveNoAccount), for: .touchUpInside)
    }
    
    @objc func tapSignIn() {
        signInButton.turnOffButtonIf(true, title: "")
        let email = self.emailTextField.text ?? ""
        let password = self.passwordTextField.text ?? ""
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            defer {
                self.signInButton.turnOffButtonIf(false, title: "Войти")
            }
            
            if error != nil {
                Src.showAlert(vc: self, title: "Введённые данные неверны")
                return
            }
            
            if let sd = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sd.checkAuth(vc: self, scene: false)
            }
            
        }
    }
    
    @objc func tapIHaveNoAccount() {
        let vc = RegisterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UI
extension LoginViewController {
    private func setUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(headerView)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(iHaveNoAccount)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: Src.Sizes.space200),
            
            emailTextField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: Src.Sizes.space15),
            emailTextField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: Src.Sizes.space55),
            emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Src.Sizes.space085),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: Src.Sizes.space15),
            passwordTextField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: Src.Sizes.space55),
            passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Src.Sizes.space085),
            
            signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: Src.Sizes.space15),
            signInButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: Src.Sizes.space55),
            signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Src.Sizes.space085),
            
            iHaveNoAccount.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: Src.Sizes.space10),
            iHaveNoAccount.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
        ])
    }
}
