import UIKit

class DirectFlightsCell: UITableViewCell {
    static let id = "directFlightsCell"
    let circle = View(backColor: .clear)
    let title = Label(title: "Title",
                      weight: .italic,
                      size: 15)
    let times = Label(title: "Times",
                      size: 15)
    let price = Label(title: "1 000 рублей >",
                      weight: .italic,
                      size: 15,
                      textColor: Src.Colors.offersTicketsPrice)
    
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
    
    func configureCell(title: String, times: String, price: String) {
        self.title.text = title
        self.times.text = times
        self.price.text = price
    }
    
    private func setUI() {
        backgroundColor = Src.Colors.directFlightsTableView
        
        addSubview(circle)
        addSubview(title)
        addSubview(times)
        addSubview(price)
        
        circle.layer.cornerRadius = 12
        times.numberOfLines = 1
        times.textAlignment = .left
        
        NSLayoutConstraint.activate([
            circle.centerYAnchor.constraint(equalTo: centerYAnchor),
            circle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            circle.widthAnchor.constraint(equalToConstant: 24),
            circle.heightAnchor.constraint(equalToConstant: 24),
            
            title.leadingAnchor.constraint(equalTo: circle.trailingAnchor, constant: 8),
            title.centerYAnchor.constraint(equalTo: circle.centerYAnchor, constant: -12),
            
            times.leadingAnchor.constraint(equalTo: circle.trailingAnchor, constant: 8),
            times.centerYAnchor.constraint(equalTo: circle.centerYAnchor, constant: 12),
            times.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            price.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            price.centerYAnchor.constraint(equalTo: circle.centerYAnchor, constant: -10),
        ])
    }
}
