import UIKit

class AllTicketsView: UIViewController {
    var tickets: [[String: Any]] = [[:]]
    
    // Top view
    private let topView = View(backColor: Src.Colors.textFieldView)
    private let back = Button(hasImage: true,
                              systemName: true,
                              imageNamed: "arrow.backward",
                              imageColor: Src.Colors.offersTicketsPrice)
    private let way = Label(weight: .semibold)
    private let tripInfo = Label(size: 17,
                                 textColor: Src.Colors.tripInfo)
    
    // Table view
    private let tableView = UITableView()
    
    // Bottom part
    private let capsuleView = View(backColor: Src.Colors.offersTicketsPrice)
    private let filters = Button(title: "Фильтры",
                                 backColor: .clear,
                                 hasImage: true,
                                 systemName: true,
                                 imageNamed: "slider.horizontal.3",
                                 imageColor: Src.Colors.white)
    private let pricesGraph = Button(title: "График цен",
                                     backColor: .clear,
                                     hasImage: true,
                                     systemName: true,
                                     imageNamed: "chart.bar.xaxis",
                                     imageColor: Src.Colors.white)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tickets = AirTicketsViewModel.viewModel.getTickets()
        setCore()
        setUI()
    }
    
    private func setCore() {
        tableView.register(AllTicketsCell.self, forCellReuseIdentifier: AllTicketsCell.id)
        tableView.dataSource = self
        tableView.delegate = self
    }
}


// MARK: - Actions
extension AllTicketsView {
    @objc func tapBack() {
        Coordinator.closeView(view: self)
    }
}

// MARK: - Delegates
extension AllTicketsView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AllTicketsCell.id, for: indexPath) as? AllTicketsCell else {
            fatalError("Failed to dequeue")
        }
        
        cell.configureCell(parameters: AirTicketsViewModel.viewModel.decomposeTickets(tickets: tickets, indexPath: indexPath))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}


// MARK: - UI
extension AllTicketsView {
    private func setUI() {
        view.backgroundColor = .black
        
        view.addSubview(topView)
        topView.layer.cornerRadius = 16
        topView.addSubview(back)
        topView.addSubview(way)
        topView.addSubview(tripInfo)
        
        let (to, from) = AirTicketsViewModel.viewModel.getToFrom()
        let wayTitle = "\(from) - \(to)"
        way.text = wayTitle
        let tripInfoTitle = AirTicketsViewModel.viewModel.getTripInfo()
        tripInfo.text = tripInfoTitle
        
        back.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.backgroundColor = .black
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        view.addSubview(capsuleView)
        capsuleView.layer.cornerRadius = 20
        capsuleView.addSubview(filters)
        capsuleView.addSubview(pricesGraph)
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            topView.heightAnchor.constraint(equalToConstant: 70),
            
            back.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 8),
            back.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            back.widthAnchor.constraint(equalToConstant: 24),
            back.heightAnchor.constraint(equalToConstant: 24),
            
            way.leadingAnchor.constraint(equalTo: back.trailingAnchor, constant: 8),
            way.centerYAnchor.constraint(equalTo: topView.centerYAnchor, constant: -12),
            
            tripInfo.leadingAnchor.constraint(equalTo: back.trailingAnchor, constant: 8),
            tripInfo.centerYAnchor.constraint(equalTo: topView.centerYAnchor, constant: 12),
            
            tableView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 32),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
            
            capsuleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            capsuleView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            capsuleView.heightAnchor.constraint(equalToConstant: 50),
            capsuleView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            
            filters.leadingAnchor.constraint(equalTo: capsuleView.leadingAnchor),
            filters.topAnchor.constraint(equalTo: capsuleView.topAnchor),
            filters.heightAnchor.constraint(equalTo: capsuleView.heightAnchor, multiplier: 1),
            filters.widthAnchor.constraint(equalTo: capsuleView.widthAnchor, multiplier: 0.5),
            
            pricesGraph.trailingAnchor.constraint(equalTo: capsuleView.trailingAnchor),
            pricesGraph.topAnchor.constraint(equalTo: capsuleView.topAnchor),
            pricesGraph.heightAnchor.constraint(equalTo: capsuleView.heightAnchor, multiplier: 1),
            pricesGraph.widthAnchor.constraint(equalTo: capsuleView.widthAnchor, multiplier: 0.5),
        ])
    }
}
