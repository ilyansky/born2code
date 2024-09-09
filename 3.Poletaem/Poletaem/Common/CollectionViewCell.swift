import UIKit

class CollectionViewCell: UICollectionViewCell {
    static let id = "collectionViewCell"
    
    let iv = ImageView(imageName: "questionmark", cornerRad: 16)
    var title = Label(weight: .bold)
    var town = Label(weight: .regular, size: 15)
    let plane = ImageView(systemName: true,
                          imageName: "paperplane",
                          tintColor: Src.Colors.separator)
    var price = Label(weight: .regular,
                      size: 17)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(id: String, title: String, town: String, price: String) {
        self.iv.image = UIImage(named: id)
        self.title.text = title
        self.town.text = town
        self.price.text = price
    }
    
    private func setUI() {
        addSubview(iv)
        addSubview(title)
        addSubview(town)
        addSubview(plane)
        addSubview(price)
        
        NSLayoutConstraint.activate([
            iv.topAnchor.constraint(equalTo: topAnchor),
            iv.leadingAnchor.constraint(equalTo: leadingAnchor),
            iv.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.65),
            iv.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.65),
            
            title.topAnchor.constraint(equalTo: iv.bottomAnchor, constant: 5),
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            town.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            town.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            plane.topAnchor.constraint(equalTo: town.bottomAnchor, constant: 5),
            plane.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            price.topAnchor.constraint(equalTo: town.bottomAnchor, constant: 5),
            price.leadingAnchor.constraint(equalTo: plane.trailingAnchor, constant: 5),
            
        ])
    }
}
