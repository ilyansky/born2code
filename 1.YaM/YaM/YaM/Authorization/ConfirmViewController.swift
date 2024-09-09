import UIKit
import FirebaseAuth

class ConfirmViewController: UIViewController {

    private let headerView = AuthHeaderView(title: "Подтверждение почты")
    
    private let infoLabel: UILabel = {
        let label = UILabel()
         label.font = .systemFont(ofSize: Src.Sizes.space20, weight: .semibold)
         label.text = "Письмо отправлено на Вашу почту. Перейдите по ссылке в письме.\nЕсли письмо не пришло - подождите некоторое время\nи проверьте папку 'Спам'."
        label.numberOfLines = 7
        label.textAlignment = .justified
         return label
     }()
    
    private let confirmed = AuthButton(title: "Подтверждено", hasBackground: true, fontSize: .big)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<- Назад", style: .plain, target: self, action: #selector(tapBack))
        navigationController?.navigationBar.isHidden = true
    }

}

// MARK: - Кнопки
extension ConfirmViewController {
    @objc func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tapConfirmed() {
        
        if let sd = self.view.window?.windowScene?.delegate as? SceneDelegate {
            sd.checkAuth(vc: self, scene: false)
        }
        
    }
}

// MARK: - Пользовательский интерфейс
extension ConfirmViewController {
    private func setUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(headerView)
        view.addSubview(infoLabel)
        view.addSubview(confirmed)
        confirmed.addTarget(self, action: #selector(tapConfirmed), for: .touchUpInside)
        
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            headerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerView.heightAnchor.constraint(equalToConstant: Src.Sizes.space200),
            
            infoLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: Src.Sizes.space15),
            infoLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Src.Sizes.space085),
            infoLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            
            confirmed.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: Src.Sizes.space15),
            confirmed.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            confirmed.heightAnchor.constraint(equalToConstant: Src.Sizes.space55),
            confirmed.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Src.Sizes.space085),
            ])
    }
}
