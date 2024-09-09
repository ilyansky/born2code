import UIKit

class ImageView: UIImageView {
    init(systemName: Bool = true, 
         imageName: String,
         tintColor: UIColor = .cyan,
         cornerRad: CGFloat = 0) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.tintColor = tintColor
        self.clipsToBounds = true // To round
        self.layer.cornerRadius = cornerRad
        
        
        if systemName {
            self.image = UIImage(systemName: imageName)
        } else {
            self.image = UIImage(named: imageName)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
