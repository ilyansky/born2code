import UIKit

class AirTicketsViewModel: NSObject {
    private var model = AirTicketsModel()
    static var viewModel = AirTicketsViewModel()
    
    override init() {
        super.init()
    }
    
    // MARK: - Main screen
    func getOffers() -> [[String: Any]] {
        return model.offers
    }
    
    func decomposeOffers(offers: [[String: Any]], indexPath: IndexPath) -> (String, String, String, String) {
        let id = offers[indexPath.row]["id"] as? Int ?? 0
        let title = offers[indexPath.row]["title"] as? String ?? "empty"
        let town = offers[indexPath.row]["town"] as? String ?? "empty"
        let priceDict = offers[indexPath.row]["price"] as? [String: Int] ?? [:]
        let price = priceDict["value"] ?? 0
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "ru_RU")
        let formattedPrice = formatter.string(from: NSNumber(value: price)) as String? ?? "empty"
        return (String(id), title, town, "от \(formattedPrice) \u{20BD}")
    }
    
    func saveLastFrom(string: String) {
        model.modelSaveLastFrom(string: string)
    }
    
    func getLastFrom() -> String {
        return model.modelGetLastFrom()
    }
    
    // MARK: - Search screen
    func getRandomElementFromAnywhereArray() -> String {
        model.anywhereArray[Int.random(in: 0...model.anywhereArray.count - 1)]
    }
    
    func getPopularDirectionsArray() -> [[String: String]] {
        return model.popularDirections
    }
    
    func saveToFrom(to: String, from: String) {
        model.to = to
        model.from = from
    }
    
    // MARK: - Extended search screen
    func getToFrom() -> (String, String) {
        return (model.to, model.from)
    }
    
    func getOffersTickets() -> [[String: Any]] {
        return model.offersTickets
    }
    
    func decomposeOffersTickets(offersTickets: [[String: Any]], indexPath: IndexPath) -> (String, String, String) {
        let title = offersTickets[indexPath.row]["title"] as? String ?? ""
        let timesArray = offersTickets[indexPath.row]["time_range"] as? [String] ?? []
        var times = ""
        for i in 0..<timesArray.count {
            if i != timesArray.count - 1 {
                times += "\(timesArray[i])  "
            } else {
                times += "\(timesArray[i])"
            }
        }
        let priceDict = offersTickets[indexPath.row]["price"] as? [String: Int] ?? [:]
        let price = priceDict["value"] ?? 0
        let formattedPrice = "\(makeFormattedPrice(price: price)) >"
        return (title, times, formattedPrice)
    }
    
    func saveTripInfo(departureDate: String, ticketsCounter: String) {
        model.tripInfo = "\(departureDate), \(ticketsCounter)"
    }
    
    // MARK: - All tickets screen
    func getTripInfo() -> String {
        return model.tripInfo
    }
    
    func getTickets() -> [[String: Any]] {
        if let res = model.getTickets(jsonString: model.ticketsJsonString) {
            return res
        }
        return [[:]]
    }
    
    func decomposeTickets(tickets: [[String: Any]], indexPath: IndexPath) -> [String: Any] {
        var res: [String: Any] = [:]
        
        if let badge = tickets[indexPath.row]["badge"] {
            res["hasBadge"] = true
            res["badge"] = badge
        } else {
            res["hasBadge"] = false
            res["badge"] = ""
        }
        
        let priceDict = tickets[indexPath.row]["price"] as? [String: Int] ?? [:]
        let price = priceDict["value"] as Int? ?? 0
        res["price"] = makeFormattedPrice(price: price)
        
        let departureDict = tickets[indexPath.row]["departure"] as? [String: String] ?? [:]
        let departureDate = departureDict["date"] ?? ""
        let departureTime = makeTimeFromDate(date: departureDate)
        let departureAirport = departureDict["airport"] ?? ""
        res["departureTime"] = departureTime
        res["departureAirport"] = departureAirport
        
        let arrivalDict = tickets[indexPath.row]["arrival"] as? [String: String] ?? [:]
        let arrivalDate = arrivalDict["date"] ?? ""
        let arrivalTime = makeTimeFromDate(date: arrivalDate)
        let arrivalAirport = arrivalDict["airport"] ?? ""
        res["arrivalTime"] = arrivalTime
        res["arrivalAirport"] = arrivalAirport
        
        let flyTime = calculateFlyTime(departureDateString: departureDate, arrivalDateString: arrivalDate)
        let flyTimeAtHours = flyTime / 3600
        let flyTimeAtHoursString = String(format: "%.1f", flyTimeAtHours)
        res["flyTime"] = flyTimeAtHoursString
        
        let hasTransfer = tickets[indexPath.row]["has_transfer"] as? Bool ?? false
        if hasTransfer == false {
            res["hasTransfer"] = false
        } else {
            res["hasTransfer"] = true
        }
        
        return res
    }
    
    private func makeTimeFromDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = dateFormatter.date(from: date) {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            let timeString = timeFormatter.string(from: date)
            return timeString
        }
        return ""
    }
    
    private func makeFormattedPrice(price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.numberStyle = .decimal
        let formattedPrice = "\(formatter.string(from: NSNumber(value: price)) ?? "") \u{20BD}"
        return formattedPrice
    }
    
    private func calculateFlyTime(departureDateString: String, arrivalDateString: String) -> TimeInterval {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH-mm-ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let departureDate = dateFormatter.date(from: departureDateString)
        let arrivalDate = dateFormatter.date(from: arrivalDateString)
        let flyTime = arrivalDate?.timeIntervalSince(departureDate ?? Date())
        
        return flyTime ?? TimeInterval()
    }
}



