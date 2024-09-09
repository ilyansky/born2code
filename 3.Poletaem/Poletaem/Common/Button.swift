
import UIKit

class Button: UIButton {
    init(title: String = "",
         backColor: UIColor = .clear,
         cornerRad: CGFloat = 0,
         hasImage: Bool = false,
         systemName: Bool = false,
         imageNamed: String = "",
         imageColor: UIColor = .cyan) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if hasImage {
            if systemName {
                self.setImage(UIImage(systemName: imageNamed)?.withRenderingMode(.alwaysTemplate), for: .normal)
                self.tintColor = imageColor
            } else {
                self.setImage(UIImage(named: imageNamed)?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        self.titleLabel?.numberOfLines = 2
        self.titleLabel?.textAlignment = .center
        self.setTitle(title, for: .normal)
        self.backgroundColor = backColor
        self.layer.cornerRadius = cornerRad
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

