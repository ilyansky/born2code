import UIKit

class AllTicketsCell: UITableViewCell {
    static let id = "allTicketsCell"
    
    let cellView = View(backColor: Src.Colors.directFlightsTableView)
    let badge = Label(weight: .italic,
                      size: 15)
    let price = Label(weight: .semibold)
    let circle = View(backColor: .clear)
    let depTime = Label(weight: .italic,
                        size: 15)
    let depAir = Label(weight: .italic,
                       size: 15,
                       textColor: Src.Colors.separator)
    let hypen = Label(title: "-",
                      weight: .italic,
                      size: 15,
                      textColor: Src.Colors.separator)
    let arrTime = Label(weight: .italic,
                        size: 15)
    let arrAir = Label(weight: .italic,
                       size: 15,
                       textColor: Src.Colors.separator)
    let flyTime = Label(size: 15)
    let slash = Label(title: "/",
                      weight: .italic,
                      size: 15,
                      textColor: Src.Colors.separator)
    let hasTransfer = Label(size: 10)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(parameters: [String: Any]) {
        let hasBadge = parameters["hasBadge"] as? Bool ?? false
        if hasBadge {
            let badge = parameters["badge"] as? String ?? ""
            self.badge.text = badge
        } else {
            self.badge.isHidden = true
        }
        let price = parameters["price"] as? String ?? ""
        self.price.text = price
        self.depTime.text = parameters["departureTime"] as? String ?? ""
        self.depAir.text = parameters["departureAirport"] as? String ?? ""
        self.arrTime.text = parameters["arrivalTime"] as? String ?? ""
        self.arrAir.text = parameters["arrivalAirport"] as? String ?? ""
        let ft = parameters["flyTime"] as? String ?? ""
        self.flyTime.text = "\(ft)ч в пути"
        
        let hasTransferBool = parameters["hasTransfer"] as? Bool ?? false
        if hasTransferBool == false {
            hasTransfer.text = "Без пересадок"
        } else {
            slash.isHidden = true
            hasTransfer.isHidden = true
        }
        
    }
    
    private func setUI() {
        backgroundColor = .black
        addSubview(cellView)
        cellView.backgroundColor = Src.Colors.directFlightsTableView
        cellView.layer.cornerRadius = 16
        
        addSubview(badge)
        badge.layer.cornerRadius = 10
        badge.backgroundColor = Src.Colors.offersTicketsPrice
        
        cellView.addSubview(price)
        cellView.addSubview(circle)
        circle.layer.cornerRadius = 12
        circle.backgroundColor = Src.Colors.redCircle
        
        cellView.addSubview(depTime)
        cellView.addSubview(depAir)
        cellView.addSubview(hypen)
        cellView.addSubview(arrTime)
        cellView.addSubview(arrAir)
        cellView.addSubview(flyTime)
        cellView.addSubview(slash)
        cellView.addSubview(hasTransfer)
        
        hasTransfer.numberOfLines = 3
        hasTransfer.textAlignment = .left
        
        NSLayoutConstraint.activate([
            cellView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cellView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            cellView.heightAnchor.constraint(equalToConstant: 120),
            
            badge.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 5),
            badge.topAnchor.constraint(equalTo: cellView.topAnchor, constant: -10),
            badge.heightAnchor.constraint(equalToConstant: 20),
            badge.widthAnchor.constraint(equalToConstant: 150),
            
            price.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 16),
            price.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 20),
            
            circle.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -32),
            circle.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 16),
            circle.widthAnchor.constraint(equalToConstant: 24),
            circle.heightAnchor.constraint(equalToConstant: 24),
            
            depTime.centerYAnchor.constraint(equalTo: circle.centerYAnchor, constant: -12),
            depTime.leadingAnchor.constraint(equalTo: circle.trailingAnchor, constant: 8),
            depAir.centerYAnchor.constraint(equalTo: circle.centerYAnchor, constant: 12),
            depAir.leadingAnchor.constraint(equalTo: circle.trailingAnchor, constant: 8),
            
            hypen.centerYAnchor.constraint(equalTo: circle.centerYAnchor, constant: -12),
            hypen.leadingAnchor.constraint(equalTo: depTime.trailingAnchor, constant: 8),
            
            arrTime.centerYAnchor.constraint(equalTo: circle.centerYAnchor, constant: -12),
            arrTime.leadingAnchor.constraint(equalTo: hypen.trailingAnchor, constant: 8),
            arrAir.centerYAnchor.constraint(equalTo: circle.centerYAnchor, constant: 12),
            arrAir.leadingAnchor.constraint(equalTo: hypen.trailingAnchor, constant: 8),
            
            flyTime.centerYAnchor.constraint(equalTo: circle.centerYAnchor, constant: -12),
            flyTime.leadingAnchor.constraint(equalTo: arrTime.trailingAnchor, constant: 16),
            
            slash.centerYAnchor.constraint(equalTo: circle.centerYAnchor, constant: -12),
            slash.leadingAnchor.constraint(equalTo: flyTime.trailingAnchor, constant: 8),
            
            hasTransfer.centerYAnchor.constraint(equalTo: circle.centerYAnchor, constant: -12),
            hasTransfer.leadingAnchor.constraint(equalTo: slash.trailingAnchor, constant: 8),
            hasTransfer.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -16)
        ])
        
    }
}
