import UIKit

class PopularPlacesCell: UITableViewCell {
    static let id = "popularPlacesCell"
    
    let iv = ImageView(imageName: "questionmark",
                       cornerRad: 10)
    let title = Label(weight: .bold)
    let subtitle = Label(weight: .regular,
                         size: 15,
                         textColor: Src.Colors.subtitle)
    
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
    
    func configureCell(id: String, title: String) {
        self.iv.image = UIImage(named: id)
        self.title.text = title
        self.subtitle.text = "Популярное направление"
    }
    
    private func setUI() {
        addSubview(iv)
        addSubview(title)
        addSubview(subtitle)
        backgroundColor = Src.Colors.textFieldView
        
        NSLayoutConstraint.activate([
            iv.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iv.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            iv.centerYAnchor.constraint(equalTo: centerYAnchor),
            iv.widthAnchor.constraint(equalToConstant: 40),
            iv.heightAnchor.constraint(equalToConstant: 40),
            
            title.leadingAnchor.constraint(equalTo: iv.trailingAnchor, constant: 8),
            title.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            
            subtitle.leadingAnchor.constraint(equalTo: iv.trailingAnchor, constant: 8),
            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 2),
        ])
    }
    
}
