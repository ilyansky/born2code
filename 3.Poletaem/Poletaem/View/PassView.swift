import UIKit

class PassView: UIViewController {
    private let inDev = Label(title: "В разработке", weight: .bold)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        view.backgroundColor = Src.Colors.grey1
        
        view.addSubview(inDev)
        NSLayoutConstraint.activate([
            inDev.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inDev.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
