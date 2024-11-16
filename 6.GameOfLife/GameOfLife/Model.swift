import SwiftUI

enum PushType {
    case newLife
    case newDeath
    case common
}

class Model {
    let backgroundColor: [Color] = [.customPurple, .lightBlue]
    var pushType = PushType.common
    
    func nextCell() -> Bool {
        return Bool.random()
    }
    
     func checkStreak(cells: [Bool]) -> (Bool, [Bool]) {
        let lastInd = cells.count - 1
        var cellsCopy = cells
        pushType = .common
        
        if lastInd >= 2 &&
            cellsCopy[lastInd - 2] == true &&
            cellsCopy[lastInd - 1] == true &&
            cellsCopy[lastInd] == true {
            cellsCopy.append(true)
            pushType = .newLife
        } else if lastInd >= 3 &&
                    cellsCopy[lastInd - 3] == false &&
                    cellsCopy[lastInd - 2] == false &&
                    cellsCopy[lastInd - 1] == false &&
                    cellsCopy[lastInd] == true {
            _ = cellsCopy.popLast()
            pushType = .newDeath
        }
        
        return pushType != .common ? (true, cellsCopy) : (false, cellsCopy)
    }
}
