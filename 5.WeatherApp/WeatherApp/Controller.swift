import Foundation

class Controller {
    private let model = Model()
    
    func getWeatherTypes(russian: Bool = true) -> [Int: String] {
        return russian ? model.rusWeatherTypes : model.enWeatherTypes
    }
}
