//override func viewWillAppear(_ animated: Bool) {
//        auth = Auth.auth().addStateDidChangeListener { auth, user in
//            print(user?.displayName)
//        }

/*
override func viewWillDisappear(_ animated: Bool) {
    Auth.auth().removeStateDidChangeListener(auth!)
}
 */

//        print("print = \(Auth.auth().currentUser?.uid)")

///-------------

/*
// MARK: Прием / передача навигационной информации
extension MapViewController {
    
      MARK: - Отправка координат
     private func sendLocationToServer(withInterval: TimeInterval) {
      Каждые withInterval секунд происходит отправка данных на сервер
     Timer.scheduledTimer(withTimeInterval: withInterval, repeats: true) { _ in
     self.getCoordinates()
     
      Берем список пользователей с сервера
     self.getSelfFromUsers { userData in
     guard let userData = userData else {
     print("Failed to fetch user data")
     return
     }
     
      Обновляем свои координаты на сервере
     var updUserData = userData
     updUserData["latitude"] = self.currentUserLatitude
     updUserData["longitude"] = self.currentUserLongitude
     self.putNewSelfLocation(newUserData: updUserData)
     }
     }
     }
     
     private func getSelfFromUsers(completion: @escaping ([String: Any]?) -> Void) {
     guard let url = URL(string: myUsersUrl) else {
     print("Invalid URL")
     return
     }
     
     URLSession.shared.dataTask(with: url) { data, response, error in
     guard let data = data, error == nil else { return }
     if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
     completion(json)
     }
     }.resume()
     }
     
     private func putNewSelfLocation(newUserData: [String: Any]) {
     guard let url = URL(string: myUsersUrl) else {
     print("Invalid URL")
     return
     }
     
     var request = URLRequest(url: url)
     request.httpMethod = "PUT"
     request.addValue("application/json", forHTTPHeaderField: "Content-Type")
     request.httpBody = try? JSONSerialization.data(withJSONObject: newUserData)
     
     URLSession.shared.dataTask(with: request) { data, response, error in
     if let error = error {
     print("Error in putNewSelfLocation: \(error.localizedDescription)")
     } else {
     print("Data upd successfully")
     }
     }.resume()
     }
     
     
     // MARK: - Прием координат
     @objc private func showFriendLocation() {
     
     let urlString = "https://yam-server-ad898-default-rtdb.europe-west1.firebasedatabase.app/locations.json"
     
     guard let url = URL(string: urlString) else {
     print("Invalid URL")
     return
     }
     
     URLSession.shared.dataTask(with: url) { data, response, error in
     if let error = error {
     print("Error fetching location data: \(error.localizedDescription)")
     return
     }
     
     guard let data = data else {
     print("No data received")
     return
     }
     
     do {
     if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
     // Переменная для хранения последнего местоположения друга
     var lastFriendLocation: [String: Any]?
     // Перебираем все пары ключ-значение в словаре
     for (_, value) in json.reversed() {
     // Проверяем, является ли это местоположение друга (не мое)
     let position = value as! [String: Any]?
     if position?["id"] as! String != self.selfID {
     // Обновляем последнее местоположение друга
     lastFriendLocation = position
     print("Loc found successfully")
     break
     }
     }
     
     // Проверяем, удалось получить последнее местоположение друга
     if let lastLocation = lastFriendLocation,
     let latitude = lastLocation["latitude"],
     let longitude = lastLocation["longitude"] {
     print("Friend's latest location - Latitude: \(latitude), Longitude: \(longitude)")
     // Добавьте свою логику для обновления карты или других действий с полученными данными
     } else {
     print("No location data available for friend")
     }
     } else {
     print("Failed to parse JSON")
     }
     } catch {
     print("Error deserializing location data: \(error.localizedDescription)")
     }
     }.resume()
     
     
     }

 }
 */

///-------------

/*

public static let shared = AuthService()
private init() {}

/// Функция регистрации пользователя
/// - Parameters:
///   - userRequest: Информация о пользователе
///   - completion: Замыкание с двумя переменными
///   - Bool: Был ли зарегистрирован пользователь?
///   - Error?: Индикатор ошибки

public func registerUser(view: UIViewController, with userRequest: RegisterUserRequest,
                         completion: @escaping (Bool, Error?) -> Void) {
    let login = userRequest.login
    let email = userRequest.email
    let password = userRequest.password
    
    Auth.auth().createUser(withEmail: email, password: password) { result, error in
        if let error = error {
            completion(false, error)
            return
        }
        
        guard let resultUser = result?.user else {
            completion(false, nil)
            return
        }
        
        DispatchQueue.main.async {
            resultUser.sendEmailVerification { error in
                if let error = error {
                    Src.showUnknownErrorAlert(vc: view, error: error)
                } else {
                    Src.showAcceptEmailALert(vc: view)
                }
            }
        }

        // Обращение к базе данных на сервере
        let db = Firestore.firestore()
        db.collection("users")
            .document(resultUser.uid)
            .setData([
                "login": login,
                "email": email,
                "password": password
            ]) { error in
                if let error = error {
                    completion(false, error)
                    return
                }
                completion(true, nil)
            }
    }
}

public func signIn(userRequest: LoginUserRequest, completion: @escaping (Error?) -> Void) {
    Auth.auth().signIn(withEmail: userRequest.email, password: userRequest.password) { result, error in
        if let error = error {
            completion(error)
            return
        } else {
            completion(nil)
        }
    }
}

public func signOut(completion: @escaping (Error?) -> Void) {
    do {
        try Auth.auth().signOut()
        completion(nil)
    } catch {
        completion(error)
    }
}
 

public func forgotPassword(email: String, completion: @escaping (Error?) -> Void) {
    Auth.auth().sendPasswordReset(withEmail: email) { error in
        completion(error)
    }
}
 

static func setUserToRealtimeDatabase(userData: [String: Any], com: @escaping (Error?) -> Void) {
    guard let url = URL(string: Src.realtimeDatabaseUrl) else { return }
    var req = URLRequest(url: url)
    req.httpMethod = "POST"
    req.addValue("application/json", forHTTPHeaderField: "Content-Type")
    req.httpBody = try? JSONSerialization.data(withJSONObject: userData)
    
    URLSession.shared.dataTask(with: req) { data, response, err in
        if err != nil {
            print("Ошибка - данные о пользователе не загружены на сервер")
            com(err)
        } else {
            print("Данные о пользователе успешно загружены на сервер")
        }
    }.resume()
    
}
 */


/*
let rand = Int.random(in: 1...5)
if rand == 5 {
    print("Ошибка")
    self.incrementErrors()
    return
} else


if self.total == 100 {
    print("Общее количество запросов \(self.total)")
    print("Количество корректных запросов \(self.cnt)")
    print("Количество ошибочных запросов \(self.errs)")
}
*/
