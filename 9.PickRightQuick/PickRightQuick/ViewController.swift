import UIKit

class ViewController: UIViewController {
    // MARK: Start variables
    @IBOutlet var slider: UISlider!
    @IBOutlet var conditionLabel: UILabel!
    @IBOutlet var hpLabel: UILabel!
    var pickedValue: Int = 0
    var game = Game()
    let x = 0
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultScene()
    }
    
    // MARK: @IBActions
    @IBAction func pick() {
        pickedValue = game.pickValue(slider: slider)
        updateHpAndLabels()
    }
    
    @IBAction func retry() {
        setDefaultScene()
    }
    
    // MARK: View updating
    private func updateHpAndLabels() {
        if game.hp > 0 {
            game.decrementHP()
            hpLabel.text = "HP = \(String(game.hp))"
            switch pickedValue {
            case game.randomSecretNumber:
                conditionLabel.text = "SUCCESS"
                conditionLabel.textColor = .systemGreen
            case ..<game.randomSecretNumber: conditionLabel.text = "YOUR PICK IS < "
            case (game.randomSecretNumber + 1)...: conditionLabel.text = "YOUR PICK IS >"
            default: break
            }
        } else {
            conditionLabel.text = "FAIL"
            conditionLabel.textColor = .systemPink
        }
    }
    
    private func setDefaultScene() {
        conditionLabel.text = "CONDITION"
        conditionLabel.layer.masksToBounds = true
        conditionLabel.layer.cornerRadius = 20
        conditionLabel.textColor = .systemYellow
        
        hpLabel.text = "FULL HP"
        hpLabel.layer.masksToBounds = true
        hpLabel.layer.cornerRadius = 20
        
        game.setDefaultValues()
    }
}

