import UIKit
import CoreLocation
import FirebaseFirestore

class YaMModel {
    // MARK: - Соц-модель
    var invitesList: [String] = []
    var friendsList: [String] = []
     
    func clearModel() {
        invitesList = []
        friendsList = []
        loc = GeoPoint(latitude: 0.0, longitude: 0.0)
        friendLoc = GeoPoint(latitude: 0.0, longitude: 0.0)
    }
    
    enum ArrayType {
        case invite
        case friend
    }
    
    func checkUserExists(login: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("users")
            .whereField("login", isEqualTo: login)
            .getDocuments { (qs, err) in
                if let err = err {
                    print("Ошибка получения документов: \(err)")
                    completion(false)
                    return
                }
                
                if let doc = qs?.documents, !doc.isEmpty {
                    // Пользователь с ником login найден
                    completion(true)
                } else {
                    // Пользователь с ником login не найден
                    completion(false)
                }
            }
    }
    
    func getArray(loginForSearch: String, arrayTitleForSearch: String, arrayType: ArrayType, com: @escaping () -> Void) {
        let db = Firestore.firestore()
        db.collection("users")
            .whereField("login", isEqualTo: loginForSearch)
            .getDocuments { qs, err in
                if let err = err {
                    print("Ошибка получения документов: \(err)")
                    return
                }
                guard let doc = qs?.documents, !doc.isEmpty else {
                    print("Документы отсутствуют")
                    return
                }
                if let doc = doc[0]["\(arrayTitleForSearch)"] as? [String] {
                    switch arrayType {
                    case .invite:
                        self.invitesList = doc
                    case .friend:
                        self.friendsList = doc
                    }
                    com()
                } else {
                    print("Ошибка приведения типов not loc")
                    return
                }
            }
    }
    
    func addToArray(loginForSearch: String, arrayTitleForSearch: String, newValue: String, com: @escaping () -> Void) {
        let db = Firestore.firestore()
        db.collection("users").whereField("login", isEqualTo: loginForSearch).getDocuments { qs, err in
            if let err = err {
                print("Ошибка получения документов: \(err)")
                return
            }
            
            guard let doc = qs?.documents else {
                print("Документы отсутствуют")
                return
            }
            
            let docRef = db.collection("users").document(doc[0].documentID)
            docRef.updateData(["\(arrayTitleForSearch)": FieldValue.arrayUnion([newValue])]) { err in
                if err != nil {
                    print("db err")
                    return
                }
                else {
                    com()
                    return
                }
            }
        }
    }
    
    func removeFromArray(loginForSearch: String, array: String, valueToRemove: String, com: @escaping () -> Void) {
        let db = Firestore.firestore()
        Src.time1 = Src.fetchCurrentTime()
        db.collection("users")
            .whereField("login", isEqualTo: loginForSearch)
            .getDocuments { qs, err in
                if let err = err {
                    print("Ошибка получения документов: \(err)")
                    return
                }
                guard let doc = qs?.documents else {
                    print("Документы отсутствуют")
                    return
                }
                let docRef = db.collection("users").document(doc[0].documentID)
                docRef.updateData(["\(array)": FieldValue.arrayRemove([valueToRemove])]) { err in
                    if err != nil {
                        print("db err")
                        return
                    } else {
                        Src.time2 = Src.fetchCurrentTime()
                        Src.printSubTime(time1: Src.time1, time2: Src.time2)
                        com()
                        return
                    }
                }
            }
    }
    
    
    // MARK: - Гео-модель
    var loc: GeoPoint = GeoPoint(latitude: 0.0, longitude: 0.0)
    var friendLoc: GeoPoint = GeoPoint(latitude: 0.0, longitude: 0.0)
    var errs = 0, cnt = 0, total = 0
   
    func getGeopoint(loginForSearch: String, com: @escaping () -> Void) {
        let db = Firestore.firestore()
        db.collection("users")
            .whereField("login", isEqualTo: loginForSearch)
            .getDocuments { qs, err in
                if let err = err {
                    print("Ошибка получения документов: \(err)")
                    return
                }
                guard let doc = qs?.documents else {
                    print("Документы отсутствуют")
                    return
                }
                if let geo = doc[0]["location"] as? GeoPoint {
                    self.friendLoc = geo
                    com()
                } else {
                    print("Ошибка приведения типов для геоточки")
                }
            }
    }
    func updateSelfCoordinates(loginForSearch: String, location: GeoPoint) {
        let db = Firestore.firestore()
        db.collection("users").whereField("login", isEqualTo: loginForSearch).getDocuments { qs, err in
            if let err = err {
                print("Ошибка получения документов: \(err)")
                return
            }
            guard let doc = qs?.documents else {
                print("Документы отсутствуют")
                return
            }
            let _: Void = db.collection("users").document(doc[0].documentID).updateData(["location": location]) { err in
                if let err = err {
                    print("Ошибка при обновлении данных: \(err)")
                    return
                }
                print("Данные о местоположении пользователя успешно обновлены")
//                print("Ваши координаты: широта = \(location.latitude), долгота = \(location.longitude)")
            }
        }
    }
    
    private func incrementErrors() {
        errs += 1
        total += 1
        print("Errors = \(errs)")
    }
    private func incrementGoodSend() {
        cnt += 1
        total += 1
        print("Cnt = \(cnt)")
    }
    
    
}


    
