import UIKit

class AirTicketsModel {
    // MARK: - Main screen
    var offers: [[String: Any]] = [
        ["id": 1, "title": "Die Antwoord", "town": "Будапешт", "price": ["value": 5000]],
        ["id": 2, "title": "Socrat&Lera", "town": "Санкт-Петербург", "price": ["value": 1999]],
        ["id": 3, "title": "Лампабикт", "town": "Москва", "price": ["value": 2390]]]
    
    func modelSaveLastFrom(string: String) {
        UserDefaults.standard.set(string, forKey: "savedString")
    }
    
    func modelGetLastFrom() -> String {
        if let savedString = UserDefaults.standard.string(forKey: "savedString") {
            return savedString
        }
        return ""
    }
    
    // MARK: - Search screen
    var anywhereArray = ["Турция", "Греция", "Египет", "Франция", "Япония", "Китай", "США", "Италия", "Испания", "Германия"]
    
    var popularDirections: [[String: String]] = [
        ["id": "stambul", "title": "Стамбул"],
        ["id": "sochi", "title": "Сочи"],
        ["id": "phuket", "title": "Пхукет"]
    ]
    
    var to = ""
    var from = ""
    
    // MARK: - Extended search screen
    var offersTickets: [[String: Any]] = [
        ["id": 1, "title": "Уральские авиалинии", "time_range": ["07:00", "09:10", "10:00", "11:30", "14:15", "19:10", "21:00", "23:30"], "price": ["value": 3999]],
        ["id": 10, "title": "Победа", "time_range": [ "09:10", "21:00" ], "price": [ "value": 4999 ]],
        ["id": 30, "title": "NordStar", "time_range": [ "07:00" ], "price": [ "value": 2390]]
    ]
    
    // MARK: - All tickets screen
    var tripInfo = ""
    
    let ticketsJsonString = """
    {
      "tickets": [
        {
          "id": 100,
          "badge": "Самый удобный",
          "price": {
            "value": 1999
          },
          "provider_name": "На сайте Купибилет",
          "company": "Якутия",
          "departure": {
            "town": "Москва",
            "date": "2024-02-23T03:15:00",
            "airport": "VKO"
          },
          "arrival": {
            "town": "Сочи",
            "date": "2024-02-23T07:10:00",
            "airport": "AER"
          },
          "has_transfer": false,
          "has_visa_transfer": false,
          "luggage": {
            "has_luggage": false,
            "price": {
              "value": 1082
            }
          },
          "hand_luggage": {
            "has_hand_luggage": true,
            "size": "55x20x40"
          },
          "is_returnable": false,
          "is_exchangable": true
        },
        {
          "id": 101,
          "price": {
            "value": 9999
          },
          "provider_name": "На сайте Победа",
          "company": "Победа",
          "departure": {
            "town": "Москва",
            "date": "2024-02-23T04:00:00",
            "airport": "VKO"
          },
          "arrival": {
            "town": "Сочи",
            "date": "2024-02-23T08:30:00",
            "airport": "AER"
          },
          "has_transfer": false,
          "has_visa_transfer": false,
          "luggage": {
            "has_luggage": false,
            "price": {
              "value": 1602
            }
          },
          "hand_luggage": {
            "has_hand_luggage": true,
            "size": "36x30x27"
          },
          "is_returnable": false,
          "is_exchangable": true
        },
        {
          "id": 102,
          "price": {
            "value": 8500
          },
          "provider_name": "На сайте Turkish Airlines",
          "company": "Турецкие авиалинии",
          "departure": {
            "town": "Москва",
            "date": "2024-02-23T15:00:00",
            "airport": "VKO"
          },
          "arrival": {
            "town": "Сочи",
            "date": "2024-02-23T18:40:00",
            "airport": "AER"
          },
          "has_transfer": false,
          "has_visa_transfer": false,
          "luggage": {
            "has_luggage": true
          },
          "hand_luggage": {
            "has_hand_luggage": true,
            "size": "55x20x40"
          },
          "is_returnable": false,
          "is_exchangable": false
        },
        {
          "id": 103,
          "badge": "Рекомендуемый",
          "price": {
            "value": 8086
          },
          "provider_name": "На сайте Уральские авиалинии",
          "company": "Уральские авиалинии",
          "departure": {
            "town": "Москва",
            "date": "2024-02-23T11:30:00",
            "airport": "VKO"
          },
          "arrival": {
            "town": "Сочи",
            "date": "2024-02-23T15:00:00",
            "airport": "AER"
          },
          "has_transfer": false,
          "has_visa_transfer": false,
          "luggage": {
            "has_luggage": false,
            "price": {
              "value": 1570
            }
          },
          "hand_luggage": {
            "has_hand_luggage": true,
            "size": "55x20x40"
          },
          "is_returnable": true,
          "is_exchangable": true
        },
        {
          "id": 104,
          "price": {
            "value": 11560
          },
          "provider_name": "На сайте Aeroflot",
          "company": "Аэрофлот",
          "departure": {
            "town": "Москва",
            "date": "2024-02-23T11:50:00",
            "airport": "VKO"
          },
          "arrival": {
            "town": "Сочи",
            "date": "2024-02-23T15:20:00",
            "airport": "AER"
          },
          "has_transfer": true,
          "has_visa_transfer": false,
          "luggage": {
            "has_luggage": false,
            "price": {
              "value": 999
            }
          },
          "hand_luggage": {
            "has_hand_luggage": true,
            "size": "55x20x40"
          },
          "is_returnable": false,
          "is_exchangable": true
        },
        {
          "id": 105,
          "price": {
            "value": 15600
          },
          "provider_name": "На сайте Aeroflot",
          "company": "Аэрофлот",
          "departure": {
            "town": "Москва",
            "date": "2024-02-23T13:50:00",
            "airport": "VKO"
          },
          "arrival": {
            "town": "Сочи",
            "date": "2024-02-23T17:20:00",
            "airport": "AER"
          },
          "has_transfer": true,
          "has_visa_transfer": true,
          "luggage": {
            "has_luggage": false,
            "price": {
              "value": 1999
            }
          },
          "hand_luggage": {
            "has_hand_luggage": true,
            "size": "55x20x40"
          },
          "is_returnable": true,
          "is_exchangable": true
        },
        {
          "id": 106,
          "price": {
            "value": 9500
          },
          "provider_name": "На сайте Aeroflot",
          "company": "Аэрофлот",
          "departure": {
            "town": "Москва",
            "date": "2024-02-23T21:00:00",
            "airport": "VKO"
          },
          "arrival": {
            "town": "Сочи",
            "date": "2024-02-24T00:20:00",
            "airport": "AER"
          },
          "has_transfer": false,
          "has_visa_transfer": false,
          "luggage": {
            "has_luggage": false,
            "price": {
              "value": 5999
            }
          },
          "hand_luggage": {
            "has_hand_luggage": false
          },
          "is_returnable": false,
          "is_exchangable": false
        }
      ]
    }
    """
    
    func getTickets(jsonString: String) -> [[String: Any]]? {
        let data = jsonString.data(using: .utf8)!
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let tickets = json["tickets"] as? [[String: Any]] {
            return tickets
        }
        return nil
    }
    
}
