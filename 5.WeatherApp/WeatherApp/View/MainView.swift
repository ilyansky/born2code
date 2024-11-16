import UIKit

class MainView: UIViewController {
    private let controller = Controller()
    private var weatherTypes = [Int: String]()
    
    private let weatherCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 20
        
        return view
    }()
    
    private var weatherView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private var seg: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["Русский", "Английский"])
        
        seg.translatesAutoresizingMaskIntoConstraints = false
        seg.selectedSegmentIndex = 0
        
        return seg
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherTypes = controller.getWeatherTypes()
        setCore()
        setRandomWeather()
        setUI()
    }
    
    private func setCore() {
        weatherCollectionView.delegate = self
        weatherCollectionView.dataSource = self
        weatherCollectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: WeatherCollectionViewCell.id)
    }
    
    private func setRandomWeather() {
        let weather = Int.random(in: 0..<weatherTypes.count)
        
        switch weather {
        case 0: setClear()
        case 1: setCloud()
        case 2: setRain()
        case 3: setSnow()
        case 4: setThunder()
        default: break
        }
    }
}

// Animations
extension MainView {
    private func makeWeatherCell(name: String, color: UIColor, birthRate: Float, lifetime: Float, velocity: CGFloat, velocityRange: CGFloat, yAcceleration: CGFloat, scale: CGFloat, scaleRange: CGFloat) -> CAEmitterCell {
        let cell = CAEmitterCell()
        
        cell.contents = UIImage(systemName: name)?.withTintColor(color)?.cgImage
        cell.birthRate = birthRate
        cell.lifetime = lifetime
        cell.velocity = velocity
        cell.velocityRange = velocityRange
        cell.yAcceleration = yAcceleration
        cell.scale = scale
        cell.scaleRange = scaleRange
        
        return cell
    }
    
    private func makeEmitter(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, shape: CAEmitterLayerEmitterShape) -> CAEmitterLayer {
        let emitter = CAEmitterLayer()
        
        emitter.emitterPosition = CGPoint(x: x, y: y)
        emitter.emitterSize = CGSize(width: width, height: height)
        emitter.emitterShape = shape
        
        return emitter
    }
    
    private func makeWeather(weather: CAEmitterLayer, cell: CAEmitterCell) {
        weather.emitterCells = [cell]
        weatherView.layer.addSublayer(weather)
    }
    
    private func setRain() {
        let rain = makeEmitter(x: view.bounds.width / 2.0, y: -50, width: view.bounds.width, height: 1, shape: .line)
    
        let rainCell = makeWeatherCell(name: "drop.fill", color: .systemBlue, birthRate: 40, lifetime: 5, velocity: 200, velocityRange: 100, yAcceleration: 300, scale: 0.2, scaleRange: 0.05)

        makeWeather(weather: rain, cell: rainCell)

    }
    
    private func setSnow() {
        let snow = makeEmitter(x: view.bounds.width / 2, y: -30, width: view.bounds.width, height: 1, shape: .line)
        
        let snowCell = makeWeatherCell(name: "snow", color: .systemGray3, birthRate: 14, lifetime: 30, velocity: 100, velocityRange: 10, yAcceleration: 10, scale: 0.5, scaleRange: 0.05)
    
        makeWeather(weather: snow, cell: snowCell)

    }
    
    private func setCloud() {
        let cloud = makeEmitter(x: -100, y: view.bounds.height / 2, width: 1, height: view.bounds.height, shape: .rectangle)
        
        let cloudCell = makeWeatherCell(name: "cloud.fill", color: .systemGray, birthRate: 2, lifetime: 20, velocity: 50, velocityRange: 10, yAcceleration: 0, scale: 0.8, scaleRange: 0.05)
        
        makeWeather(weather: cloud, cell: cloudCell)

    }
    
    private func setClear() {
        let sun = makeEmitter(x: -100, y: view.bounds.height / 2, width: 1, height: view.bounds.height, shape: .rectangle)
        
        let sunCell = makeWeatherCell(name: "sun.max.fill", color: .systemYellow, birthRate: 2, lifetime: 20, velocity: 50, velocityRange: 10, yAcceleration: 0, scale: 0.7, scaleRange: 0.1)
        
        makeWeather(weather: sun, cell: sunCell)

        
    }
    
    private func setThunder() {
        setRain()
        
        let thunderCloud = makeEmitter(x: -100, y: view.bounds.height / 2, width: 1, height: view.bounds.height, shape: .rectangle)
        
        let thunderCell = makeWeatherCell(name: "cloud.bolt.fill", color: .systemGray2, birthRate: 2, lifetime: 20, velocity: 50, velocityRange: 10, yAcceleration: 0, scale: 0.8, scaleRange: 0.05)
        
        makeWeather(weather: thunderCloud, cell: thunderCell)
    }
}

// Targets
extension MainView {
    @objc func sun() {
        animateTransition {
            self.setClear()
        }
    }

    @objc func rain() {
        animateTransition {
            self.setRain()
        }
    }
    
    @objc func snow() {
        animateTransition {
            self.setSnow()
        }
    }
    
    @objc func cloud() {
        animateTransition {
            self.setCloud()
        }
    }
    
    @objc func thunder() {
        animateTransition {
            self.setThunder()
        }
    }
    
    private func animateTransition(_ setWeather: @escaping () -> ()) {
        UIView.animate(withDuration: 0.3, animations: {
            self.weatherView.alpha = 0.0
        }) { _ in
            self.weatherView.layer.sublayers = []
            setWeather()
            UIView.animate(withDuration: 0.3) {
                self.weatherView.alpha = 1.0
            }
        }
    }
    
    @objc func handleSegControl() {
        switch seg.selectedSegmentIndex {
        case 0:
            seg.setTitle("Русский", forSegmentAt: 0)
            seg.setTitle("Английский", forSegmentAt: 1)
            weatherTypes = controller.getWeatherTypes()
        case 1:
            seg.setTitle("Russian", forSegmentAt: 0)
            seg.setTitle("English", forSegmentAt: 1)
            weatherTypes = controller.getWeatherTypes(russian: false)
        default: break
        }
        weatherCollectionView.reloadData()
    }

}

// TableView
extension MainView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        weatherTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 20, height: 0)
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.id, for: indexPath) as? WeatherCollectionViewCell else { fatalError() }
        
        cell.weatherImage.image = UIImage(named: String(indexPath.section))
        cell.weatherName.text = weatherTypes[indexPath.section]

        cell.weatherButton.removeTarget(nil, action: nil, for: .allEvents)
        switch indexPath.section {
        case 0: cell.weatherButton.addTarget(self, action: #selector(sun), for: .touchUpInside)
        case 1: cell.weatherButton.addTarget(self, action: #selector(cloud), for: .touchUpInside)
        case 2: cell.weatherButton.addTarget(self, action: #selector(rain), for: .touchUpInside)
        case 3: cell.weatherButton.addTarget(self, action: #selector(snow), for: .touchUpInside)
        case 4: cell.weatherButton.addTarget(self, action: #selector(thunder), for: .touchUpInside)
        default: break
        }

        
        
        return cell
    }

}

// UI
extension MainView {
    private func setUI() {
        view.backgroundColor = .white
        view.addSubview(weatherCollectionView)
        view.addSubview(weatherView)
        view.sendSubviewToBack(weatherView)
        view.addSubview(seg)
        
        seg.addTarget(self, action: #selector(handleSegControl), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            weatherCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            weatherCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            weatherCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12),
            
            weatherView.topAnchor.constraint(equalTo: view.topAnchor),
            weatherView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            weatherView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            seg.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            seg.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            seg.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08),
            seg.centerXAnchor.constraint(equalTo: view.centerXAnchor)

        ])
        
        
        
    }
}

extension UIImage {
    func withTintColor(_ color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        withRenderingMode(.alwaysOriginal).draw(in: CGRect(origin: .zero, size: size))
        
        context.setFillColor(color.cgColor)
        context.setBlendMode(.sourceAtop)
        context.fill(CGRect(origin: .zero, size: size))
        
        let coloredImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return coloredImage
    }
}
