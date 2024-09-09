import UIKit

final class PerkController: BaseController {
    
    private let addPerkButton = UIButton()
    private let incorrectDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
    private let tableView = UITableView()
    private var perks: [Perk] = []
    private var cellMenu = UIMenu()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Resources.Storage.refetchPerks(perks: &perks, context: context)
        reloadTableView()
    }
}

// MARK: UI
extension PerkController {
    
    private func setAppearance() {
        setAddPerkButton()
        
        // Table View
        setTableView()
        
        // Warning
        setWarningLabel()
    }
    
    private func setAddPerkButton() {
        view.addSubview(addPerkButton)
        Resources.Common.setButton(button: addPerkButton, image: nil, backgroundColor: Resources.Common.Colors.green, setPosition: setAddPerkButtonPosition)
        addPerkButton.setTitle("Perk +", for: .normal)
        Resources.Common.configButtonWithImage(button: addPerkButton, title: "Perk ", position: 5, imageName: "perk")
        addPerkButton.addTarget(self, action: #selector(tapAddPerk), for: .touchUpInside)
    }
    
    private func setTableView() {
        // Required
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PerkCell.self, forCellReuseIdentifier: Resources.PerkController.PerkCell.cellIdentifier)
        setTableViewPosition()
        
        // Opt
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = Resources.Common.Sizes.cornerRadius25
        tableView.backgroundColor = Resources.Common.Colors.backgroundGray
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func setWarningLabel() {
        incorrectDataLabel.textAlignment = .center
        incorrectDataLabel.backgroundColor = Resources.Common.Colors.purple
        incorrectDataLabel.text = "Incorrect data or perk duplicate"
        incorrectDataLabel.layer.masksToBounds = true
        incorrectDataLabel.layer.cornerRadius = Resources.Common.Sizes.cornerRadius25
        incorrectDataLabel.numberOfLines = 2
        incorrectDataLabel.font = Resources.Common.futura(size: Resources.Common.Sizes.font16)
        incorrectDataLabel.textColor = Resources.Common.Colors.backgroundCard
        incorrectDataLabel.alpha = 0
        incorrectDataLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(incorrectDataLabel)

        NSLayoutConstraint.activate([
            incorrectDataLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            incorrectDataLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            incorrectDataLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            incorrectDataLabel.heightAnchor.constraint(equalToConstant: 50)])
    }
}

// MARK: Delegates
extension PerkController: UITableViewDelegate, UITableViewDataSource {
    
    // Core
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Cell configuration
        let cell = tableView.dequeueReusableCell(withIdentifier: Resources.PerkController.PerkCell.cellIdentifier, for: indexPath) as! PerkCell
        cell.backgroundColor = Resources.Common.Colors.backgroundCard
        cell.selectionStyle = .none
        cell.contentView.isUserInteractionEnabled = false
        cell.layer.cornerRadius = Resources.Common.Sizes.cornerRadius25
        
        cell.openSessionView = {
            let sessionView = SessionView()
            sessionView.delegate = self
            sessionView.modalPresentationStyle = .automatic
            self.present(sessionView, animated: true)
        }
            
        // Labels, progress
        let perk = perks[indexPath.section]
        cell.set(perkObj: perk) // entry point
        return cell
    }
     
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        setCellMenu(indexPath: indexPath)
        return UIContextMenuConfiguration(actionProvider: { _ in self.cellMenu })
    }
    
    // Sup
    func numberOfSections(in tableView: UITableView) -> Int {
        return perks.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Resources.PerkController.PerkCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Resources.Common.Sizes.space15
    }
}

extension PerkController: ModalViewControllerDelegate {
    // Method starts when modal view did dissapear
    func didDismissModalViewController() {
        Resources.Storage.refetchPerks(perks: &perks, context: context)
        reloadTableView()
    }
}

// TextField characters limit
extension PerkController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        
        let newText = textFieldText.replacingCharacters(in: rangeOfTextToReplace, with: string)
        return newText.count <= 15
    }
}

// MARK: Actions
extension PerkController {
    private func setCellMenu(indexPath: IndexPath) {
        // Edit
        let edit = UIAction(title: "", image: UIImage(named: "edit")) { _ in
            let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
            alert.setValue(Resources.Common.returnStringWithAttributes(title: "Edit"), forKey: "attributedTitle")
            
            alert.addTextField() { tf in
                tf.text = self.perks[indexPath.section].perkTitle
                tf.delegate = self
                tf.placeholder = "New perk title"
            }
            alert.addTextField() { tf in
                tf.text = String(Int64(self.perks[indexPath.section].totalHours))
                tf.delegate = self
                tf.placeholder = "Correct spent hours"
            }
            
            let submitButton = UIAlertAction(title: "Yep", style: .default) { (action) in
                let title = alert.textFields![0].text!
                let hours = Float(alert.textFields![1].text!)
                
                if hours == nil || hours! < 0 || title == "" {
                    self.showIncorrectDataLabel()
                } else {
                    self.perks[indexPath.section].perkTitle = title
                    PerkModel.recalculateData(context: self.context, perk: &self.perks[indexPath.section], correctHours: hours!)
                    Perk.saveContext(context: self.context)
                    
                    self.reloadTableView()
                }
            }
            
            alert.addAction(submitButton)
            self.present(alert, animated: true)
        }
        edit.setValue(Resources.Common.returnStringWithAttributes(title: "Edit"), forKey: "attributedTitle")

        
        // Delete
        let delete = UIAction(title: " ", image: UIImage(named: "bin")?.withTintColor(Resources.Common.Colors.black)) { _ in
            Perk.deletePerk(context: self.context, perkToRemove: self.perks[indexPath.section])
            Perk.saveContext(context: self.context)
            Resources.Storage.refetchPerks(perks: &self.perks, context: self.context)
            self.deleteSection(section: indexPath.section)
        }
        delete.setValue(Resources.Common.returnStringWithAttributes(title: "Delete", color: Resources.Common.Colors.black), forKey: "attributedTitle")
        
        cellMenu = UIMenu(title: "", children: [edit, delete])
    }

    @objc func tapAddPerk() {
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
            alert.addTextField { tf in
                tf.placeholder = "Perk title"
                tf.delegate = self
            }
            alert.addTextField { tf in
                tf.placeholder = "Spent hours (ex: 45.3)"
                tf.delegate = self
            }
            alert.setValue(Resources.Common.returnStringWithAttributes(title: "Customize your perk"), forKey: "attributedTitle")
        
        
        let submitButton = UIAlertAction(title: "Yep", style: .default) { _ in
            let perkTitleTextField = alert.textFields![0]
            let totalHoursTextField = alert.textFields![1]
            
            // Create new perk
            var incorrectDataFlag = false
            
            var checkPerk: [Perk] = []
            Perk.fetchPerkWith(title: perkTitleTextField.text!, perk: &checkPerk, context: self.context)
        
            if Float(totalHoursTextField.text!) == nil || Float(totalHoursTextField.text!)! < 0 ||
                perkTitleTextField.text == "" ||
                totalHoursTextField.text == "" ||
                checkPerk.count > 0 {
                incorrectDataFlag = true
                checkPerk.removeAll()
            } else {
                let totalSecondsFromTextField = Int64(Float(totalHoursTextField.text!)! * 3600)
                
                PerkModel.createNewPerk(context: self.context, perkTitle: perkTitleTextField.text!, time: totalSecondsFromTextField)
                Resources.Storage.refetchPerks(perks: &self.perks, context: self.context)

                self.addSection()
                
                let indexPath = NSIndexPath(row: 0, section: self.perks.count-1)
                self.tableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
                
                alert.dismiss(animated: true)
            }
            
            
            // insert here
            if incorrectDataFlag {
                self.showIncorrectDataLabel()
            }
             
        }
        
        // Add Done button
        alert.addAction(submitButton)
        
        // Show alert
        self.present(alert, animated: true)
    }
}

// MARK: Support
extension PerkController {
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func addSection() {
        tableView.beginUpdates()
        tableView.insertSections(IndexSet(integer: perks.count - 1), with: .automatic)
        tableView.endUpdates()
    }
    
    private func deleteSection(section: Int) {
        tableView.beginUpdates()
        tableView.deleteSections(IndexSet(integer: section), with: .automatic)
        tableView.endUpdates()
    }
    
    private func showIncorrectDataLabel() {
        UIView.animate(withDuration: 0.3, animations: {
            self.incorrectDataLabel.alpha = 1
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                UIView.animate(withDuration: 0.3) {
                    self.incorrectDataLabel.alpha = 0
                }
            }
        }
    }
}

// MARK: Position
extension PerkController {
    private func setAddPerkButtonPosition() {
        addPerkButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addPerkButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Resources.Common.Sizes.space15),
            addPerkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addPerkButton.widthAnchor.constraint(equalToConstant: 100),
            addPerkButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setTableViewPosition() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: addPerkButton.bottomAnchor, constant: Resources.Common.Sizes.space15),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Resources.Common.Sizes.space15),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Resources.Common.Sizes.space15),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Resources.Common.Sizes.space15)
        ])
    }
}
