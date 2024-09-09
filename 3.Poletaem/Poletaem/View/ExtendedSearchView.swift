import UIKit

class ExtendedSearchView: UIViewController {
    private var offersTickets: [[String: Any]] = []
    
    // Text field part
    private let textFieldView = View(backColor: Src.Colors.textFieldView)
    private let back = Button(hasImage: true,
                              systemName: true,
                              imageNamed: "arrow.backward",
                              imageColor: Src.Colors.white)
    private let delButton = Button(hasImage: true,
                                   systemName: true,
                                   imageNamed: "xmark",
                                   imageColor: Src.Colors.white)
    private let swap = Button(hasImage: true,
                              systemName: true,
                              imageNamed: "arrow.up.arrow.down",
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
    
    // Horizontal stack part
    private let stackView = UIStackView()
    
    private let returnDate = Button(backColor: Src.Colors.textFieldView,
                                    cornerRad: 16)
    private let departureDate = Button(backColor: Src.Colors.textFieldView,
                                       cornerRad: 16)
    private let ticketsCounter = Button(backColor: Src.Colors.textFieldView,
                                        cornerRad: 16,
                                        hasImage: true,
                                        systemName: true,
                                        imageNamed: "person.fill",
                                        imageColor: Src.Colors.separator)
    private let filters = Button(backColor: Src.Colors.textFieldView,
                                 cornerRad: 16,
                                 hasImage: true,
                                 systemName: true,
                                 imageNamed: "slider.horizontal.3",
                                 imageColor: Src.Colors.separator)
    
    // Direct flights part
    private let directFlightsView = View(backColor: Src.Colors.directFlightsTableView)
    private let directFlightsLabel = Label(title: "Прямые рейсы",
                                           weight: .bold,
                                           size: 20)
    private let tableView = UITableView()
    
    // Bottom part
    private let checkAllTickets = Button(backColor: Src.Colors.offersTicketsPrice,
                                         cornerRad: 8,
                                         hasImage: false)
    private let subscribeView = View(backColor: Src.Colors.directFlightsTableView)
    private let bell = ImageView(systemName: true,
                                 imageName: "bell.fill",
                                 tintColor: Src.Colors.offersTicketsPrice)
    private let subscribeLabel = Label(title: "Подписка на цену",
                                       weight: .regular,
                                       size: 17)
    private let subscribeSwitcher = UISwitch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        offersTickets = AirTicketsViewModel.viewModel.getOffersTickets()
        setUI()
        setCore()
    }
    
    private func setCore() {
        from.delegate = self
        to.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        tableView.register(DirectFlightsCell.self, forCellReuseIdentifier: DirectFlightsCell.id)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - Actions
extension ExtendedSearchView {
    @objc func tapDelButton() {
        to.text = ""
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func openModalPass() {
        Coordinator.openView(viewFrom: self, viewTo: PassView(), presentationStyle: .automatic, transitionStyle: .coverVertical)
    }
    
    @objc func tapBack() {
        Coordinator.closeView(view: self)
    }
    
    @objc func tapSwap() {
        let from = self.to.text!
        let to = self.from.text!
        self.to.text = to
        self.from.text = from
    }
    
    @objc func tapDepartureDate() {
        present(makeDatePickerAlert(title: "Выберите дату отправления", button: departureDate), animated: true)
    }
    
    @objc func tapReturnDate() {
        present(makeDatePickerAlert(title: "Выберите дату возвращения", button: returnDate), animated: true)
    }
    
    
    @objc func tapCheckAllTickets() {
        if from.text != "" && to.text != "" {
            AirTicketsViewModel.viewModel.saveToFrom(to: to.text!, from: from.text!)
            AirTicketsViewModel.viewModel.saveTripInfo(departureDate: departureDate.titleLabel?.text ?? "", ticketsCounter: ticketsCounter.titleLabel?.text ?? "")
            Coordinator.openView(viewFrom: self, viewTo: AllTicketsView(), presentationStyle: .fullscreen, transitionStyle: .coverVertical)
        } else {
            Src.fillAllFieldsAlert(view: self)
        }
    }
}

// MARK: - Delegates
extension ExtendedSearchView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacterSet = CharacterSet(charactersIn: "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдеёжзийклмнопрстуфхцчшщъыьэюя -")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacterSet.isSuperset(of: characterSet)
    }
}

extension ExtendedSearchView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        offersTickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DirectFlightsCell.id, for: indexPath) as? DirectFlightsCell else {
            fatalError("Failed to dequeue")
        }
        
        let (title, times, price) = AirTicketsViewModel.viewModel.decomposeOffersTickets(offersTickets: offersTickets, indexPath: indexPath)
        cell.configureCell(title: title, times: times, price: price)
        
        switch indexPath.row {
        case 0: cell.circle.backgroundColor = Src.Colors.redCircle
        case 1: cell.circle.backgroundColor = Src.Colors.offersTicketsPrice
        case 2: cell.circle.backgroundColor = .white
        default: break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - UI
extension ExtendedSearchView {
    private func setUI() {
        view.backgroundColor = .black
        
        view.addSubview(textFieldView)
        textFieldView.layer.cornerRadius = 16
        textFieldView.addSubview(back)
        textFieldView.addSubview(delButton)
        textFieldView.addSubview(from)
        textFieldView.addSubview(to)
        textFieldView.addSubview(separator)
        textFieldView.addSubview(swap)
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(departureDate)
        stackView.addArrangedSubview(returnDate)
        stackView.addArrangedSubview(ticketsCounter)
        stackView.addArrangedSubview(filters)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(directFlightsView)
        directFlightsView.addSubview(directFlightsLabel)
        directFlightsView.addSubview(tableView)
        directFlightsView.layer.cornerRadius = 16
        
        view.addSubview(checkAllTickets)
        checkAllTickets.setAttributedTitle(setAttributedTitle(title: "Посмотреть все билеты", size: 17), for: .normal)
        checkAllTickets.titleLabel?.textColor = .white
        checkAllTickets.addTarget(self, action: #selector(tapCheckAllTickets), for: .touchUpInside)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.backgroundColor = Src.Colors.directFlightsTableView
        tableView.separatorColor = Src.Colors.separator
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        
        (to.text, from.text) = AirTicketsViewModel.viewModel.getToFrom()
        
        delButton.addTarget(self, action: #selector(tapDelButton), for: .touchUpInside)
        back.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
        swap.addTarget(self, action: #selector(tapSwap), for: .touchUpInside)
        returnDate.addTarget(self, action: #selector(tapReturnDate), for: .touchUpInside)
        departureDate.addTarget(self, action: #selector(tapDepartureDate), for: .touchUpInside)
        
        returnDate.setAttributedTitle(setAttributedTitle(title: "+ обратно"), for: .normal)
        returnDate.titleLabel?.textColor = .white
        departureDate.setAttributedTitle(setAttributedTitle(title: formatDate(date: Date())), for: .normal)
        departureDate.titleLabel?.textColor = .white
        ticketsCounter.setAttributedTitle(setAttributedTitle(title: "1, эконом"), for: .normal)
        ticketsCounter.titleLabel?.textColor = .white
        filters.setAttributedTitle(setAttributedTitle(title: "Фильтры"), for: .normal)
        filters.titleLabel?.textColor = .white
        
        
        view.addSubview(subscribeView)
        subscribeView.layer.cornerRadius = 8
        subscribeView.addSubview(bell)
        subscribeView.addSubview(subscribeLabel)
        subscribeView.addSubview(subscribeSwitcher)
        subscribeSwitcher.translatesAutoresizingMaskIntoConstraints = false
        subscribeSwitcher.onTintColor = Src.Colors.offersTicketsPrice
        
        NSLayoutConstraint.activate([
            textFieldView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            textFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textFieldView.heightAnchor.constraint(equalToConstant: 122),
            
            back.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor, constant: 8),
            back.centerYAnchor.constraint(equalTo: textFieldView.centerYAnchor),
            back.widthAnchor.constraint(equalToConstant: 24),
            back.heightAnchor.constraint(equalToConstant: 24),
            
            from.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor, constant: 40),
            from.topAnchor.constraint(equalTo: textFieldView.topAnchor),
            from.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -50),
            from.heightAnchor.constraint(equalTo: textFieldView.heightAnchor, multiplier: 0.5),
            
            to.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor, constant: 40),
            to.bottomAnchor.constraint(equalTo: textFieldView.bottomAnchor),
            to.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -50),
            to.heightAnchor.constraint(equalTo: textFieldView.heightAnchor, multiplier: 0.5),
            
            separator.centerYAnchor.constraint(equalTo: textFieldView.centerYAnchor),
            separator.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor, constant: 40),
            separator.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -16),
            separator.heightAnchor.constraint(equalToConstant: 1),
            
            
            delButton.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -16),
            delButton.centerYAnchor.constraint(equalTo: to.centerYAnchor),
            delButton.widthAnchor.constraint(equalToConstant: 24),
            delButton.heightAnchor.constraint(equalToConstant: 24),
            
            swap.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -16),
            swap.centerYAnchor.constraint(equalTo: from.centerYAnchor),
            swap.widthAnchor.constraint(equalToConstant: 24),
            swap.heightAnchor.constraint(equalToConstant: 24),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: 16),
            stackView.heightAnchor.constraint(equalToConstant: 33),
            
            directFlightsView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            directFlightsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            directFlightsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            directFlightsView.heightAnchor.constraint(equalToConstant: 300),
            
            directFlightsLabel.leadingAnchor.constraint(equalTo: directFlightsView.leadingAnchor, constant: 16),
            directFlightsLabel.topAnchor.constraint(equalTo: directFlightsView.topAnchor, constant: 16),
            
            tableView.topAnchor.constraint(equalTo: directFlightsLabel.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: directFlightsView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: directFlightsView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: directFlightsView.bottomAnchor, constant: -16),
            
            checkAllTickets.topAnchor.constraint(equalTo: directFlightsView.bottomAnchor, constant: 16),
            checkAllTickets.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            checkAllTickets.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            checkAllTickets.heightAnchor.constraint(equalToConstant: 45),
            
            subscribeView.topAnchor.constraint(equalTo: checkAllTickets.bottomAnchor, constant: 16),
            subscribeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            subscribeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            subscribeView.heightAnchor.constraint(equalToConstant: 45),
            
            bell.leadingAnchor.constraint(equalTo: subscribeView.leadingAnchor, constant: 16),
            bell.centerYAnchor.constraint(equalTo: subscribeView.centerYAnchor),
            bell.widthAnchor.constraint(equalToConstant: 24),
            bell.heightAnchor.constraint(equalToConstant: 24),
            
            
            subscribeLabel.leadingAnchor.constraint(equalTo: bell.trailingAnchor, constant: 16),
            subscribeLabel.centerYAnchor.constraint(equalTo: subscribeView.centerYAnchor),
            
            subscribeSwitcher.trailingAnchor.constraint(equalTo: subscribeView.trailingAnchor, constant: -16),
            subscribeSwitcher.centerYAnchor.constraint(equalTo: subscribeView.centerYAnchor),
        ])
    }
}

// MARK: - Support
extension ExtendedSearchView {
    private func setAttributedTitle(title: String, size: CGFloat = 10) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.italicSystemFont(ofSize: size)
        ]
        let attributedString = NSAttributedString(string: title, attributes: attributes)
        return attributedString
    }
    
    private func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd MMM, EEE"
        return dateFormatter.string(from: date)
    }
    
    private func makeDatePickerAlert(title: String, button: UIButton) -> UIAlertController {
        let pickerViewController = UIViewController()
        pickerViewController.preferredContentSize = CGSize(width: view.frame.width, height: 200)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.frame = CGRect(x: 0, y: 0, width: pickerViewController.view.frame.width, height: 200)
        
        pickerViewController.view.addSubview(datePicker)
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        alert.setValue(pickerViewController, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Выбрать", style: .default) { _ in
            self.handleDateSelection(date: datePicker.date, button: button)
        })
        
        return alert
    }
    
    private func handleDateSelection(date: Date, button: UIButton) {
        let formattedDate = formatDate(date: date)
        button.setAttributedTitle(setAttributedTitle(title: formattedDate), for: .normal)
    }
}
