import UIKit

class SearchView: UIViewController {
    private let swipeCapsule = View(backColor: Src.Colors.swipeCapsule)
    
    // Text field part
    private let textFieldView = View(backColor: Src.Colors.textFieldView)
    private let zoom = Button(hasImage: true,
                              systemName: true,
                              imageNamed: "plus.magnifyingglass",
                              imageColor: Src.Colors.white)
    private let plane = ImageView(systemName: true,
                                  imageName: "paperplane",
                                  tintColor: Src.Colors.separator)
    private let delButton = Button(hasImage: true,
                                   systemName: true,
                                   imageNamed: "xmark",
                                   imageColor: Src.Colors.white)
    private let separator = View(backColor: Src.Colors.separator)
    private let from = TextField(backColor: Src.Colors.textFieldView,
                                 textColor: Src.Colors.white,
                                 placeholderColor: Src.Colors.separator,
                                 placeholder: "Откуда - Москва",
                                 font: UIFont.boldSystemFont(ofSize: 20))
    private let to = TextField(backColor: Src.Colors.textFieldView,
                               textColor: Src.Colors.white,
                               placeholderColor: Src.Colors.separator,
                               placeholder: "Куда - Турция",
                               font: UIFont.boldSystemFont(ofSize: 20))
    
    // Horizontal stack view part
    private let stackView = UIStackView()
    
    private let hardWayCell = View(backColor: .clear)
    private let hardWayButton = Button(
        backColor: .clear,
        hasImage: true,
        imageNamed: "hardWay",
        imageColor: .clear)
    private let hardWayLabel = Label(title: "Сложный\nмаршрут",
                                     size: 15)
    
    private let anywhereCell = View(backColor: .clear)
    private let anywhereButton = Button(
        backColor: .clear,
        hasImage: true,
        imageNamed: "anywhere",
        imageColor: .clear)
    private let anywhereLabel = Label(title: "Куда угодно",
                                      size: 15)
    
    private let weekendCell = View(backColor: .clear)
    private let weekendButton = Button(
        backColor: .clear,
        hasImage: true,
        imageNamed: "weekend",
        imageColor: .clear)
    private let weekendLabel = Label(title: "Выходные",
                                     size: 15)
    
    private let hotTicketsCell = View(backColor: .clear)
    private let hotTicketsButton = Button(
        backColor: .clear,
        hasImage: true,
        imageNamed: "hotTickets",
        imageColor: .clear)
    private let hotTicketsLabel = Label(title: "Горячие\nбилеты",
                                        size: 15)
    
    // Popular direction
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCore()
        setUI()
    }
    
    private func setCore() {
        from.delegate = self
        to.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        tableView.register(PopularPlacesCell.self, forCellReuseIdentifier: PopularPlacesCell.id)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - Actions
extension SearchView {
    @objc func tapDelButton() {
        to.text = ""
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func openModalPass() {
        Coordinator.openView(viewFrom: self, viewTo: ExtendedSearchView(), presentationStyle: .fullscreen, transitionStyle: .crossDisolve)
    }
    
    @objc func tapAnywhere() {
        let toTitle = AirTicketsViewModel.viewModel.getRandomElementFromAnywhereArray()
        to.text = toTitle
        
        if from.text != "" && to.text != "" {
            AirTicketsViewModel.viewModel.saveToFrom(to: to.text!, from: from.text!)
            Coordinator.openView(viewFrom: self, viewTo: ExtendedSearchView(), presentationStyle: .fullscreen, transitionStyle: .crossDisolve)
        }
    }
    
    @objc func tapZoom() {
        if from.text != "" && to.text != "" {
            AirTicketsViewModel.viewModel.saveToFrom(to: to.text!, from: from.text!)
            Coordinator.openView(viewFrom: self, viewTo: ExtendedSearchView(), presentationStyle: .fullscreen, transitionStyle: .crossDisolve)
        } else {
            Src.fillAllFieldsAlert(view: self)
        }
    }
    
}

// MARK: - Delegates
extension SearchView: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacterSet = CharacterSet(charactersIn: "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдеёжзийклмнопрстуфхцчшщъыьэюя -")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacterSet.isSuperset(of: characterSet)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if from.text != "" && to.text != "" {
            AirTicketsViewModel.viewModel.saveToFrom(to: to.text!, from: from.text!)
            Coordinator.openView(viewFrom: self, viewTo: ExtendedSearchView(), presentationStyle: .fullscreen, transitionStyle: .crossDisolve)
        }
    }
}

extension SearchView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        AirTicketsViewModel.viewModel.getPopularDirectionsArray().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PopularPlacesCell.id, for: indexPath) as? PopularPlacesCell else {
            fatalError("Failed to dequeue")
        }
        
        let popularDirections = AirTicketsViewModel.viewModel.getPopularDirectionsArray()
        cell.configureCell(id: popularDirections[indexPath.row]["id"] ?? "", title: popularDirections[indexPath.row]["title"] ?? "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let popularDirections = AirTicketsViewModel.viewModel.getPopularDirectionsArray()
        to.text = popularDirections[indexPath.row]["title"]
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - UI
extension SearchView {
    private func setUI() {
        view.backgroundColor = Src.Colors.searchBack
        
        view.addSubview(swipeCapsule)
        swipeCapsule.layer.cornerRadius = 2.5
        
        view.addSubview(textFieldView)
        textFieldView.addSubview(zoom)
        textFieldView.addSubview(plane)
        textFieldView.addSubview(delButton)
        textFieldView.addSubview(from)
        textFieldView.addSubview(to)
        textFieldView.addSubview(separator)
        textFieldView.layer.cornerRadius = 16
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(hardWayCell)
        stackView.addArrangedSubview(anywhereCell)
        stackView.addArrangedSubview(weekendCell)
        stackView.addArrangedSubview(hotTicketsCell)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.backgroundColor = Src.Colors.textFieldView
        tableView.separatorColor = Src.Colors.separator
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.showsVerticalScrollIndicator = false
        tableView.isUserInteractionEnabled = true
        
        hardWayCell.addSubview(hardWayButton)
        hardWayCell.addSubview(hardWayLabel)
        
        anywhereCell.addSubview(anywhereButton)
        anywhereCell.addSubview(anywhereLabel)
        
        weekendCell.addSubview(weekendButton)
        weekendCell.addSubview(weekendLabel)
        
        hotTicketsCell.addSubview(hotTicketsButton)
        hotTicketsCell.addSubview(hotTicketsLabel)
        
        from.text = AirTicketsViewModel.viewModel.getLastFrom()
        
        
        delButton.addTarget(self, action: #selector(tapDelButton), for: .touchUpInside)
        zoom.addTarget(self, action: #selector(tapZoom), for: .touchUpInside)
        hardWayButton.addTarget(self, action: #selector(openModalPass), for: .touchUpInside)
        anywhereButton.addTarget(self, action: #selector(tapAnywhere), for: .touchUpInside)
        weekendButton.addTarget(self, action: #selector(openModalPass), for: .touchUpInside)
        hotTicketsButton.addTarget(self, action: #selector(openModalPass), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            swipeCapsule.heightAnchor.constraint(equalToConstant: 5),
            swipeCapsule.widthAnchor.constraint(equalToConstant: 38),
            swipeCapsule.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            swipeCapsule.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            textFieldView.topAnchor.constraint(equalTo: swipeCapsule.bottomAnchor, constant: 32),
            textFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textFieldView.heightAnchor.constraint(equalToConstant: 122),
            
            plane.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor, constant: 16),
            plane.centerYAnchor.constraint(equalTo: from.centerYAnchor),
            plane.widthAnchor.constraint(equalToConstant: 24),
            plane.heightAnchor.constraint(equalToConstant: 24),
            
            zoom.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor, constant: 16),
            zoom.centerYAnchor.constraint(equalTo: to.centerYAnchor),
            zoom.widthAnchor.constraint(equalToConstant: 24),
            zoom.heightAnchor.constraint(equalToConstant: 24),
            
            from.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor, constant: 48),
            from.topAnchor.constraint(equalTo: textFieldView.topAnchor),
            from.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -50),
            from.heightAnchor.constraint(equalTo: textFieldView.heightAnchor, multiplier: 0.5),
            
            separator.centerYAnchor.constraint(equalTo: textFieldView.centerYAnchor),
            separator.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -16),
            separator.heightAnchor.constraint(equalToConstant: 1),
            
            to.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor, constant: 48),
            to.bottomAnchor.constraint(equalTo: textFieldView.bottomAnchor),
            to.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -50),
            to.heightAnchor.constraint(equalTo: textFieldView.heightAnchor, multiplier: 0.5),
            
            delButton.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -16),
            delButton.centerYAnchor.constraint(equalTo: to.centerYAnchor),
            delButton.widthAnchor.constraint(equalToConstant: 24),
            delButton.heightAnchor.constraint(equalToConstant: 24),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: 32),
            stackView.heightAnchor.constraint(equalToConstant: 94),
            
            hardWayButton.topAnchor.constraint(equalTo: hardWayCell.topAnchor),
            hardWayButton.centerXAnchor.constraint(equalTo: hardWayCell.centerXAnchor),
            hardWayLabel.topAnchor.constraint(equalTo: hardWayButton.bottomAnchor, constant: 10),
            hardWayLabel.centerXAnchor.constraint(equalTo: hardWayCell.centerXAnchor),
            
            anywhereButton.topAnchor.constraint(equalTo: anywhereCell.topAnchor),
            anywhereButton.centerXAnchor.constraint(equalTo: anywhereCell.centerXAnchor),
            anywhereLabel.topAnchor.constraint(equalTo: anywhereButton.bottomAnchor, constant: 10),
            anywhereLabel.centerXAnchor.constraint(equalTo: anywhereCell.centerXAnchor),
            
            weekendButton.topAnchor.constraint(equalTo: weekendCell.topAnchor),
            weekendButton.centerXAnchor.constraint(equalTo: weekendCell.centerXAnchor),
            weekendLabel.topAnchor.constraint(equalTo: weekendButton.bottomAnchor, constant: 10),
            weekendLabel.centerXAnchor.constraint(equalTo: weekendCell.centerXAnchor),
            
            hotTicketsButton.topAnchor.constraint(equalTo: hotTicketsCell.topAnchor),
            hotTicketsButton.centerXAnchor.constraint(equalTo: hotTicketsCell.centerXAnchor),
            hotTicketsLabel.topAnchor.constraint(equalTo: hotTicketsButton.bottomAnchor, constant: 10),
            hotTicketsLabel.centerXAnchor.constraint(equalTo: hotTicketsCell.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 32),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 260)
            
        ])
    }
}
