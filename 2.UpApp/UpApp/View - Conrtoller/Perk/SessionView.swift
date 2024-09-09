import UIKit
import CoreData

protocol ModalViewControllerDelegate: AnyObject {
    func didDismissModalViewController()
}

// MARK: Core
class SessionView: UIViewController {
    weak var delegate: ModalViewControllerDelegate?
    let pauseButton = UIButton()
    var perk = UILabel()
    let timerLabel = UILabel()
    let timerButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        timerProcess()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Stop timer
        PerkTimer.stopTimer()
        let hours = Float(PerkModel.calculateAndSaveDataFromSession()) / 3600.0
        ProgressPerPeriod.incrementHours(hours: hours) // entry point progress

        if isBeingDismissed {
            delegate?.didDismissModalViewController()
        }
    }

}

// MARK: UI
extension SessionView {
    private func setUI() {
        view.backgroundColor = Resources.Common.Colors.backgroundCard
        view.addSubview(perk)
        view.addSubview(timerButton)
        
        Resources.Common.setLabel(label: perk, size: Resources.PerkController.SessionView.perkTitleFont, text: PerkModel.perkTitle, setPosition: setPerkPosition)
        
        Resources.Common.setButton(button: timerButton, 
                                   size: Resources.PerkController.SessionView.timerButtonFont,
                                   title: "00:00:00",
                                   image: nil,
                                   backgroundColor: Resources.Common.Colors.green,
                                   cornerRadius: Resources.PerkController.SessionView.timerCornerRadius,
                                   setPosition: setTimerButtonPosition)
        timerButton.addTarget(self, action: #selector(tapTimer), for: .touchUpInside)
    }
}

// MARK: Actions
extension SessionView {    
    
    private func timerProcess() {
        // Start timer
        PerkTimer.startTimer() { [weak self] timeString in
            self?.timerButton.setTitle(timeString, for: .normal)
            PerkModel.time = timeString
        }
    }
    
    @objc func tapTimer() {
        if PerkTimer.timerIsActive == true {
            PerkTimer.pauseTimer()
            timerButton.setImage(UIImage(named: "pause"), for: .normal)
        } else {
            PerkTimer.startTimer() { [weak self] timeString in
                self?.timerButton.setTitle(timeString, for: .normal)
                PerkModel.time = timeString
            }
            timerButton.setImage(nil, for: .normal)
        }
    }
    
}

// MARK: Position
extension SessionView {
    private func setPerkPosition() {
        perk.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            perk.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            perk.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            perk.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            perk.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    private func setTimerButtonPosition() {
        timerButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            timerButton.widthAnchor.constraint(equalToConstant: Resources.PerkController.SessionView.timerSide),
            timerButton.heightAnchor.constraint(equalToConstant: Resources.PerkController.SessionView.timerSide)
        ])
    }
}


