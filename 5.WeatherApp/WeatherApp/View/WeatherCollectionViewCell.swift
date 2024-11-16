import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    static let id = "weatherTableViewCell"
    
    let weatherButton: UIButton = {
        let button = UIButton()
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [UIColor.systemMint.cgColor, UIColor.systemIndigo.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = 20
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.addSublayer(gradientLayer)
        
        return button
    }()
    
    var weatherImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var weatherName: UILabel = {
        let label = UILabel()

        label.font = .boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let gradientLayer = weatherButton.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = weatherButton.bounds
        }
    }
    
    private func setUI() {
        addSubview(weatherButton)
        weatherButton.addSubview(weatherImage)
        weatherButton.addSubview(weatherName)
        
        NSLayoutConstraint.activate([
            weatherButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            weatherButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            weatherButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1),
            weatherButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1),

            weatherImage.heightAnchor.constraint(equalTo: weatherButton.widthAnchor, multiplier: 0.4),
            weatherImage.widthAnchor.constraint(equalTo: weatherButton.widthAnchor, multiplier: 0.4),
            weatherImage.centerXAnchor.constraint(equalTo: weatherButton.centerXAnchor),
            weatherImage.topAnchor.constraint(equalTo: weatherButton.topAnchor, constant: 10),
            
            weatherName.heightAnchor.constraint(equalTo: weatherButton.widthAnchor, multiplier: 0.4),
            weatherName.widthAnchor.constraint(equalTo: weatherButton.widthAnchor, multiplier: 1),
            weatherName.centerXAnchor.constraint(equalTo: weatherButton.centerXAnchor),
            weatherName.bottomAnchor.constraint(equalTo: weatherButton.bottomAnchor, constant: -10),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
