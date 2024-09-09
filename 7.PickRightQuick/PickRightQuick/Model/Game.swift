import UIKit

protocol GameProtocol {
    var hp: Int { get }
    var randomSecretNumber: Int { get }
    
    func pickValue(slider: UISlider!) -> Int
    func setDefaultValues()
}

class Game: GameProtocol {
    var hp: Int
    var randomSecretNumber: Int
    
    init(hp: Int = 10, randomSecretNumber: Int = 0) {
        self.hp = hp
        self.randomSecretNumber = randomSecretNumber
    }
    
    func pickValue(slider: UISlider!) -> Int {
        return Int(slider.value.rounded())
    }
    
    func decrementHP() {
        hp -= 1
    }
    
    func setDefaultValues() {
        hp = 10
        randomSecretNumber = Int.random(in: 0...50)
    }
}
