import UIKit

// MARK: Core
class PerkCell: UITableViewCell {
    let perk = UILabel()
    let lvl = UILabel()
    let toNextLvl = UILabel()
    let totalHours = UILabel()
    let progress = UIProgressView()
    let startButton = UIButton()
    var openSessionView: (() -> Void)?
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(perkObj: Perk) {
        perk.text = perkObj.perkTitle
        lvl.text = "lvl \(perkObj.lvl)"
        progress.progress = perkObj.progress
        Resources.Common.configLabelWithImage(label: toNextLvl, title: "To next lvl  \(perkObj.toNextLvl)", position: 12, imageName: "perk")
        Resources.Common.configLabelWithImage(label: totalHours, title: " \(perkObj.totalHours)", position: 0, imageName: "perk")
    } // entry point
}

// MARK: UI
extension PerkCell {
    private func setAppearance() {
        addSubview(perk)
        addSubview(progress)
        addSubview(lvl)
        addSubview(toNextLvl)
        addSubview(startButton)
        addSubview(totalHours)

        // progressLine
        setProgressLine()

        // perkTitle
        Resources.Common.setLabel(label: perk, size: Resources.PerkController.PerkCell.perkTitleFont, setPosition: setPerkPosition)
        
        // lvlLabel
        Resources.Common.setLabel(label: lvl, size: Resources.Common.Sizes.font16,  setPosition: setLvlPosition)
        
        // toNextLvlLable
        Resources.Common.setLabel(label: toNextLvl, size: Resources.Common.Sizes.font16, setPosition: setToNextLvlPosition)
        
        // totalHours
        Resources.Common.setLabel(label: totalHours, size: Resources.Common.Sizes.font20, setPosition: setTotalHoursPosition)
 
        
        // startButton
        Resources.Common.setButton(button: startButton, image: UIImage(named: "start"), backgroundColor: Resources.Common.Colors.green, setPosition: setStartButtonPosition)
        startButton.addTarget(self, action: #selector(tapStart), for: .touchUpInside)
    }
    
    private func setProgressLine() {
        setProgressPosition()
        progress.layer.cornerRadius = Resources.Common.Sizes.cornerRadius10
        progress.layer.masksToBounds = true
        progress.progressTintColor = Resources.Common.Colors.green
    }
    
//    private func configLabelWithImage(label: UILabel, title: String, position: Int) {
//        let imageAttach =  NSTextAttachment()
//        imageAttach.image = UIImage(named: "perk")
//        imageAttach.bounds = CGRect(x: 0, y: -5, width: imageAttach.image!.size.width, height: imageAttach.image!.size.height)
//        let stringAttach = NSAttributedString(attachment: imageAttach)
//        let completeTitle = NSMutableAttributedString(string: title)
//        completeTitle.insert(stringAttach, at: position)
//        label.attributedText = completeTitle
//    }
}

// MARK: Actions
extension PerkCell {
    @objc func tapStart() {
        PerkModel.perkTitle = perk.text!
        openSessionView?()
    }
}

// MARK: Position
extension PerkCell {
    private func setTotalHoursPosition() {
        totalHours.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            totalHours.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -20),
            totalHours.centerXAnchor.constraint(equalTo: centerXAnchor),
            totalHours.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            totalHours.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }

    private func setPerkPosition() {
        perk.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            perk.topAnchor.constraint(equalTo: topAnchor, constant: Resources.Common.Sizes.space10),
            perk.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func setProgressPosition() {
        progress.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progress.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            progress.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            progress.centerXAnchor.constraint(equalTo: centerXAnchor),
            progress.heightAnchor.constraint(equalToConstant: 20),
            progress.topAnchor.constraint(equalTo: lvl.bottomAnchor, constant: Resources.Common.Sizes.space10)
        ])
    }

    private func setLvlPosition() {
        lvl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            lvl.centerXAnchor.constraint(equalTo: centerXAnchor),
            lvl.topAnchor.constraint(equalTo: perk.bottomAnchor, constant: 30)
        ])
    }

    private func setToNextLvlPosition() {
        toNextLvl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            toNextLvl.centerXAnchor.constraint(equalTo: centerXAnchor),
            toNextLvl.topAnchor.constraint(equalTo: progress.bottomAnchor, constant: Resources.Common.Sizes.space10),
            toNextLvl.bottomAnchor.constraint(equalTo: totalHours.topAnchor, constant: -30)
        ])
    }
    
    private func setStartButtonPosition() {
        startButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Resources.Common.Sizes.space10),
            startButton.heightAnchor.constraint(equalToConstant: 50),
            startButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
}







