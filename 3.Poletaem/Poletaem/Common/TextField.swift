import UIKit

class TextField: UITextField {
    init(backColor: UIColor = .purple,
         textColor: UIColor = .white,
         placeholderColor: UIColor = .white,
         cornerRadius: CGFloat = 10,
         placeholder: String,
         font: UIFont) {
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = backColor
        self.layer.cornerRadius = cornerRadius
        self.returnKeyType = .done
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor,
                         NSAttributedString.Key.font: font]
        )
        self.leftViewMode = .always
        self.textColor = Src.Colors.white
        self.font = font
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
