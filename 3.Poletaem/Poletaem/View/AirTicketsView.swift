import UIKit

class AirTicketsView: UIViewController {
    private var offers: [[String: Any]] = []
    
    private let topLabel = Label(title: "Поиск дешевых\nавиабилетов",
                                 weight: .semibold,
                                 size: 22)
    private let searchView = View(backColor: Src.Colors.grey3)
    private let viewInside = View(backColor: Src.Colors.grey4)
    private let zoom = ImageView(imageName: "plus.magnifyingglass",
                                 tintColor: Src.Colors.separator)
    private let separator = View(backColor: Src.Colors.separator)
    private let from = TextField(backColor: Src.Colors.grey4,
                                 textColor: Src.Colors.white,
                                 placeholderColor: Src.Colors.separator,
                                 placeholder: "Откуда - Москва",
                                 font: UIFont.boldSystemFont(ofSize: 20))
    private let to = TextField(backColor: Src.Colors.grey4,
                               textColor: Src.Colors.white,
                               placeholderColor: Src.Colors.separator,
                               placeholder: "Куда - Турция",
                               font: UIFont.boldSystemFont(ofSize: 20))
    private let midLabel = Label(title: "Музыкально отлететь",
                                 weight: .semibold,
                                 size: 22)
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let colView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        colView.translatesAutoresizingMaskIntoConstraints = false
        colView.backgroundColor = .clear
        colView.showsHorizontalScrollIndicator = false
        return colView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        offers = AirTicketsViewModel.viewModel.getOffers()
        setCore()
        setUI()
    }
    
    private func setCore() {
        from.delegate = self
        to.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.id)
    }
}

// MARK: - Actions
extension AirTicketsView {
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Delegates
extension AirTicketsView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == from {
            let allowedCharacterSet = CharacterSet(charactersIn: "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдеёжзийклмнопрстуфхцчшщъыьэюя -")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacterSet.isSuperset(of: characterSet)
        }
        return true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == to {
            AirTicketsViewModel.viewModel.saveLastFrom(string: from.text ?? "")
            Coordinator.openModalSearch(view: self, textField: to)
        }
    }
}

extension AirTicketsView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        offers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.id, for: indexPath) as? CollectionViewCell else {
            fatalError("Failed to dequeue")
        }
        let (id, title, town, price) = AirTicketsViewModel.viewModel.decomposeOffers(offers: offers, indexPath: indexPath)
        cell.configureCell(id: id, title: title, town: town, price: price)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 230, height: 230)
    }
}

// MARK: - UI
extension AirTicketsView {
    private func setUI() {
        view.addSubview(topLabel)
        topLabel.numberOfLines = 2
        
        view.addSubview(searchView)
        searchView.layer.cornerRadius = 16
        searchView.addSubview(viewInside)
        
        view.addSubview(midLabel)
        view.addSubview(collectionView)
        
        viewInside.addSubview(zoom)
        viewInside.addSubview(from)
        viewInside.addSubview(to)
        viewInside.addSubview(separator)
        viewInside.layer.cornerRadius = 16
        
        from.text = AirTicketsViewModel.viewModel.getLastFrom()
        
        NSLayoutConstraint.activate([
            topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 58),
            
            searchView.topAnchor.constraint(equalTo: view.topAnchor, constant: 148),
            searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchView.heightAnchor.constraint(equalToConstant: 122),
            
            viewInside.topAnchor.constraint(equalTo: searchView.topAnchor, constant: 16),
            viewInside.leadingAnchor.constraint(equalTo: searchView.leadingAnchor, constant: 16),
            viewInside.trailingAnchor.constraint(equalTo: searchView.trailingAnchor, constant: -16),
            viewInside.bottomAnchor.constraint(equalTo: searchView.bottomAnchor, constant: -16),
            
            zoom.leadingAnchor.constraint(equalTo: viewInside.leadingAnchor, constant: 8),
            zoom.centerYAnchor.constraint(equalTo: viewInside.centerYAnchor),
            zoom.widthAnchor.constraint(equalToConstant: 24),
            zoom.heightAnchor.constraint(equalToConstant: 24),
            
            from.leadingAnchor.constraint(equalTo: viewInside.leadingAnchor, constant: 40),
            from.topAnchor.constraint(equalTo: viewInside.topAnchor),
            from.trailingAnchor.constraint(equalTo: viewInside.trailingAnchor, constant: -8),
            from.heightAnchor.constraint(equalTo: viewInside.heightAnchor, multiplier: 0.5),
            
            separator.centerYAnchor.constraint(equalTo: viewInside.centerYAnchor),
            separator.leadingAnchor.constraint(equalTo: viewInside.leadingAnchor, constant: 40),
            separator.trailingAnchor.constraint(equalTo: viewInside.trailingAnchor, constant: -8),
            separator.heightAnchor.constraint(equalToConstant: 1),
            
            to.leadingAnchor.constraint(equalTo: viewInside.leadingAnchor, constant: 40),
            to.bottomAnchor.constraint(equalTo: viewInside.bottomAnchor),
            to.trailingAnchor.constraint(equalTo: viewInside.trailingAnchor, constant: -8),
            to.heightAnchor.constraint(equalTo: viewInside.heightAnchor, multiplier: 0.5),
            
            midLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 302),
            midLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 354),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 230)
        ])
        
    }
}
