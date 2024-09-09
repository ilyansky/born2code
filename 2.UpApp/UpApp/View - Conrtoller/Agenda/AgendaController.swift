import UIKit
import CoreData

final class AgendaController: BaseController {
    
    private let tableView = UITableView()
    private let addAimButton = UIButton()
    private let doneButton = UIButton()
    private var aims: [Aim] = []
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setNotifObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Resources.Storage.refetchAims(aims: &aims, context: context)
        reloadTableView()
        ProgressPerPeriod.refreshStats()
    }
    
}

// MARK: - Support
extension AgendaController {
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func addRow() {
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: aims.count - 1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
    private func deleteRow(row: Int) {
        tableView.beginUpdates()
        tableView.deleteRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
    private func setNotifObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - UI
extension AgendaController {
    private func setUI() {
        setAddAimButton()
        setTableView()
        setDoneButton()
    }
    
    private func setTableView() {
        view.addSubview(tableView)
        setTableViewPosition()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AgendaCell.nib(), forCellReuseIdentifier: AgendaCell.id)
        tableView.backgroundColor = Resources.Common.Colors.backgroundCard
        tableView.layer.cornerRadius = Resources.Common.Sizes.cornerRadius25
    }
    
    private func setAddAimButton() {
        view.addSubview(addAimButton)
        
        Resources.Common.setButton(button: addAimButton, image: nil, backgroundColor: Resources.Common.Colors.greenLight, setPosition: setAddAimButtonPosition)
        Resources.Common.configButtonWithImage(button: addAimButton, title: "Aim ", position: 4, imageName: "aim")
        addAimButton.addTarget(self, action: #selector(tapAddAim), for: .touchUpInside)
        addAimButton.addTarget(self, action: #selector(tapAddAim), for: .touchUpInside)
    }
    
    private func setDoneButton() {
        view.addSubview(doneButton)
        
        Resources.Common.setButton(button: doneButton, image: nil, backgroundColor: Resources.Common.Colors.purple, setPosition: setDoneButtonPosition)
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(tapDone), for: .touchUpInside)
        doneButton.alpha = 0
        
    }
    
}

// MARK: - Delegates
extension AgendaController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        aims.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AgendaCell.id, for: indexPath) as! AgendaCell
        let aimItem = aims[indexPath.row]
        
        cell.setAimCell(aim: aimItem)
        cell.selectionStyle = .none
        cell.separatorInset = .zero
        cell.saveCellInfo = { text in
            self.aims[indexPath.row].aimTitle = text
            Aim.saveContext(context: self.context)
            Resources.Storage.refetchAims(aims: &self.aims, context: self.context)
            
        }
        
        cell.aimTextView.scrollsToTop = true
        
        return cell
    }
    
    
    // Delete
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            Aim.deleteAim(context: self.context, aimToRemove: self.aims[indexPath.row])
            Aim.saveContext(context: self.context)
            Resources.Storage.refetchAims(aims: &self.aims, context: self.context)
            self.deleteRow(row: indexPath.row)
        }
        deleteAction.backgroundColor = Resources.Common.Colors.red
        let swipe = UISwipeActionsConfiguration(actions: [deleteAction])
        swipe.performsFirstActionWithFullSwipe = false
        return swipe
    }
    
    // Complete
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completeAction = UIContextualAction(style: .destructive, title: "Complete") { _, _, _ in
            ProgressPerPeriod.incrementAims() // entry point
            Aim.deleteAim(context: self.context, aimToRemove: self.aims[indexPath.row])
            Aim.saveContext(context: self.context)
            Resources.Storage.refetchAims(aims: &self.aims, context: self.context)
            self.deleteRow(row: indexPath.row)
            
        }
        completeAction.backgroundColor = Resources.Common.Colors.green
        let swipe = UISwipeActionsConfiguration(actions: [completeAction])
        swipe.performsFirstActionWithFullSwipe = false
        return swipe
    }
    
}

extension AgendaController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
   
}

// MARK: - Actions
extension AgendaController {
    @objc func tapAddAim() {
        AgendaModel.createNewAim(context: self.context)
        Resources.Storage.refetchAims(aims: &self.aims, context: self.context)

        self.addRow()
        
        let indexPath = NSIndexPath(row: aims.count-1, section: 0)
        tableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        Resources.Common.Animations.changeElementVisibility(button: doneButton, willHidden: false)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        Resources.Common.Animations.changeElementVisibility(button: doneButton, willHidden: true)
    }
    
    @objc func tapDone() {
        view.endEditing(true)
    }
    
}

// MARK: - Position
extension AgendaController {
    private func setAddAimButtonPosition() {
        addAimButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addAimButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addAimButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Resources.Common.Sizes.space15),
            addAimButton.widthAnchor.constraint(equalToConstant: 90),
            addAimButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setTableViewPosition() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: addAimButton.bottomAnchor, constant: Resources.Common.Sizes.space15),
            tableView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -Resources.Common.Sizes.space15),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Resources.Common.Sizes.space15),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Resources.Common.Sizes.space15)
        ])
    }
    
    private func setDoneButtonPosition() {
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Resources.Common.Sizes.space15),
            doneButton.widthAnchor.constraint(equalToConstant: 90),
            doneButton.heightAnchor.constraint(equalToConstant: 50),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}

