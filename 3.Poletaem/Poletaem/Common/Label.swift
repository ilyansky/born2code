import UIKit

class Label: UILabel {
    enum Weight {
        case regular
        case bold
        case semibold
        case italic
    }
    
    init(
        title: String = "Label",
        weight: Weight = Weight.regular,
        size: CGFloat = 20,
        textColor: UIColor = Src.Colors.white) {
            super.init(frame: .zero)
            self.translatesAutoresizingMaskIntoConstraints = false
            self.text = title
            self.textAlignment = .center
            self.layer.masksToBounds = true
            
            switch weight {
            case .regular:
                self.font = .systemFont(ofSize: size, weight: .regular)
            case .bold:
                self.font = .systemFont(ofSize: size, weight: .bold)
            case .semibold:
                self.font = .systemFont(ofSize: size, weight: .semibold)
            case .italic:
                self.font = UIFont.italicSystemFont(ofSize: size)
            }
            
            self.textColor = textColor
            self.numberOfLines = 10
            self.textAlignment = .center
            
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
