import UIKit

class ForgotPasswordViewController: UIViewController {
    
    private let headerView = AuthHeaderView(title: "Восстановление пароля")
    private let emailTextField = AuthTextField(fieldType: .email)
    private let recoverButton = AuthButton(title: "Восстановить", hasBackground: true, fontSize: .big)

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<- Назад", style: .plain, target: self, action: #selector(tapBack))
        navigationController?.navigationBar.isHidden = false
    }
}

// MARK: - Кнопки
extension ForgotPasswordViewController {
    @objc func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func tapRecover() {
        /*
        let email = self.emailTextField.text ?? ""
        
        if !Validator.isValidEmail(email: email) {
            Src.showInvalidEmailAlert(vc: self)
            return
        }
        
        AuthService.shared.forgotPassword(email: email) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                Src.showUnknownErrorAlert(vc: self, error: error)
                return
            }
            Src.showPasswordResendAlert(vc: self)
        }
         */
    }
}

// MARK: - Делегаты
extension ForgotPasswordViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - Пользовательский интерфейс
extension ForgotPasswordViewController {
    private func setUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(headerView)
        view.addSubview(emailTextField)
        view.addSubview(recoverButton)
        recoverButton.addTarget(self, action: #selector(tapRecover), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: Src.Sizes.space200),
            
            emailTextField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: Src.Sizes.space15),
            emailTextField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: Src.Sizes.space55),
            emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Src.Sizes.space085),
            
            recoverButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: Src.Sizes.space15),
            recoverButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            recoverButton.heightAnchor.constraint(equalToConstant: Src.Sizes.space55),
            recoverButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Src.Sizes.space085)
            
            
        ])
    }
    
}
