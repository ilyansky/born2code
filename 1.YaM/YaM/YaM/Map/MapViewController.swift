import MapKit
import CoreLocation
import FirebaseAuth
import FirebaseFirestore

class MapViewController: UIViewController {
    private let map = MKMapView()
    private var friendsList: [String: [String: String]] = [:]
    private var selfLoc = GeoPoint(latitude: 0.0, longitude: 0.0)
    private var timer1: Timer?, timer2: Timer?, timer3: Timer?
    private let model = YaMModel()
    private var locationManager = LocationManager()
    private var requestTimeInterval: TimeInterval = 3
    private var firstRequest = true
    
    // Собственная локация
    private let selfLocationButton = CircleButton(
        buttonSize: Src.Sizes.space70,
        imageNamed: "me",
        imageColor: Src.Color.green)
    
    private let logout = CircleButton(
        buttonSize: Src.Sizes.space50,
        imageNamed: "logout",
        imageColor: .systemPurple)
    
    private let addFriend = CircleButton(
        buttonSize: Src.Sizes.space70,
        imageNamed: "addFriend",
        imageColor: Src.Color.green)
    
    private let friends = CircleButton(
        buttonSize: Src.Sizes.space70,
        imageNamed: "friends",
        imageColor: Src.Color.green)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Получаю собственный логин
        
        timer3 = Timer.scheduledTimer(withTimeInterval: 5, repeats: true)
        { _ in
            self.fetchSelfLogin() {
                self.fetchFriendsList()
                
                self.requestTimeInterval = TimeInterval(Int.random(in: 3...5))
                if self.timer1 == nil {
                    self.sendSelfCoordinates(withInterval: self.requestTimeInterval)
                }
                
                self.requestTimeInterval = TimeInterval(Int.random(in: 3...5))
                if self.timer2 == nil {
                    self.setFriendsPins(withInterval: self.requestTimeInterval)
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        stopAllTimers()
        Src.selfLogin = ""
        model.clearModel()
    }
}

// MARK: - Navigation module
extension MapViewController {
    // Получение собственных координат
    private func getSelfCoordinates() {
        let latitude = locationManager.lastLocation?.coordinate.latitude ?? 0.0
        let longitude = locationManager.lastLocation?.coordinate.longitude ?? 0.0
        selfLoc = GeoPoint(latitude: latitude, longitude: longitude)
    }

    // Отправка собственных координат в базу данных
    private func sendSelfCoordinates(withInterval: TimeInterval) {
        // Каждые withInterval секунд происходит отправка данных на сервер
        timer1 = Timer.scheduledTimer(withTimeInterval: withInterval, repeats: true) { _ in
            self.getSelfCoordinates()
            self.model.updateSelfCoordinates(loginForSearch: Src.selfLogin, location: self.selfLoc)
            self.stopTimer(num: .first)
        }
    }
    
    // Установка координат друзей на карте
    private func setFriendsPins(withInterval: TimeInterval) {
        timer2 = Timer.scheduledTimer(withTimeInterval: withInterval, repeats: true) { _ in
            for friend in self.model.friendsList {
                self.model.getGeopoint(loginForSearch: friend) {
                    self.updateFriendPins(friend: self.model.friendLoc)
                    self.stopTimer(num: .second)
                }
            }
        }
    }
    
    private func updateFriendPins(friend: GeoPoint) {
        DispatchQueue.main.async {
            // Удаляем устаревшие аннотации
            for annotation in self.map.annotations {
                if let pin = annotation as? MKPointAnnotation {
                    self.map.removeAnnotation(pin)
                }
            }
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(
                latitude: friend.latitude,
                longitude: friend.longitude)
            self.map.addAnnotation(annotation)
//            print("Маркеры друзей обновлены")
        }
    }
    
}

// MARK: - Actions
extension MapViewController {
    private func setActions() {
        logout.addTarget(self, action: #selector(tapLogout), for: .touchUpInside)
        friends.addTarget(self, action: #selector(tapFriends), for: .touchUpInside)
        addFriend.addTarget(self, action: #selector(tapAddFriend), for: .touchUpInside)
        selfLocationButton.addTarget(self, action: #selector(tapCurrentLocation), for: .touchUpInside)
    }
    
    // Демнострация собственной геопозиции
    @objc private func tapCurrentLocation() {
        getSelfCoordinates()
        let center = CLLocationCoordinate2D(latitude: selfLoc.latitude, longitude: selfLoc.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: center, span: span)
        map.setRegion(region, animated: true)
    }
    
    // Кнопка выхода (разлогин)
    @objc func tapLogout() {
        do {
            try Auth.auth().signOut()
        } catch {
            Src.showSignOutFailedAlert(vc: self)
        }
        
        if let sd = self.view.window?.windowScene?.delegate as? SceneDelegate {
            sd.checkAuth(vc: LoginViewController(), scene: false)
        }
    }
    
    // Переход на экран добавления друзей
    @objc func tapAddFriend() {
        let addFriendView = AddFriendViewController()
        addFriendView.modalPresentationStyle = .automatic
        self.present(addFriendView, animated: true)
    }
    
    // Переход на экран списка друзей
    @objc func tapFriends() {
        let addFriendView = FriendsViewController()
        addFriendView.modalPresentationStyle = .automatic
        self.present(addFriendView, animated: true)
    }
}

// MARK: - Support functions
extension MapViewController {
    private func stopAllTimers() {
        timer1?.invalidate()
        timer1 = nil
        
        timer2?.invalidate()
        timer2 = nil
        
        timer3?.invalidate()
        timer3 = nil
    }
    
    enum TimerNumber {
        case first
        case second
        case third
    }
    
    private func stopTimer(num: TimerNumber) {
        switch num {
        case .first:
            timer1?.invalidate()
            timer1 = nil
        case .second:
            timer2?.invalidate()
            timer2 = nil
        case .third:
            timer3?.invalidate()
            timer3 = nil
        }
    }
    
    private func fetchSelfLogin(com: (() -> Void)? = nil) {
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser!.uid
        db.collection("users")
            .document(uid)
            .getDocument { [weak self] ds, err in
                guard let self = self else { return }
                
                if err != nil {
                    Src.showSecondUnknownErrorAlert(vc: self)
                    return
                }
                
                guard let ds = ds, ds.exists else {
                    Src.showSecondUnknownErrorAlert(vc: self)
                    return
                }
                
                Src.selfLogin = ds.data()!["login"] as! String
                com?()
        }
        
        
    }
    
    private func fetchFriendsList() {
        model.getArray(loginForSearch: Src.selfLogin, arrayTitleForSearch: "friends", arrayType: .friend) {}
    }
}

// MARK: - UI
extension MapViewController {
    private func setUI() {
        setMap()
        setSelfLocationButton()
        setAddFriendButton()
        setFriendsButton()
        setLogoutButton()
        setActions()
    }
    
    private func setMap() {
        view.addSubview(map)
        map.showsUserLocation = true
        map.tintColor = Src.Color.purple
        map.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            map.topAnchor.constraint(equalTo: view.topAnchor),
            map.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            map.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            map.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setSelfLocationButton() {
        view.addSubview(selfLocationButton)
        
        NSLayoutConstraint.activate([
            selfLocationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Src.Sizes.space20),
            selfLocationButton.widthAnchor.constraint(equalToConstant: Src.Sizes.space70),
            selfLocationButton.heightAnchor.constraint(equalToConstant: Src.Sizes.space70),
            selfLocationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setAddFriendButton() {
        view.addSubview(addFriend)
        
        NSLayoutConstraint.activate([
            addFriend.widthAnchor.constraint(equalToConstant: Src.Sizes.space70),
            addFriend.heightAnchor.constraint(equalToConstant: Src.Sizes.space70),
            addFriend.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Src.Sizes.space20),
            addFriend.leadingAnchor.constraint(equalTo: selfLocationButton.trailingAnchor, constant: Src.Sizes.space30)
        ])
        
    }
    
    private func setFriendsButton() {
        view.addSubview(friends)
        
        NSLayoutConstraint.activate([
            friends.widthAnchor.constraint(equalToConstant: Src.Sizes.space70),
            friends.heightAnchor.constraint(equalToConstant: Src.Sizes.space70),
            friends.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Src.Sizes.space20),
            friends.trailingAnchor.constraint(equalTo: selfLocationButton.leadingAnchor, constant: -Src.Sizes.space30)
        ])
        
    }
    
    private func setLogoutButton() {
        view.addSubview(logout)
        
        NSLayoutConstraint.activate([
            logout.widthAnchor.constraint(equalToConstant: Src.Sizes.space50),
            logout.heightAnchor.constraint(equalToConstant: Src.Sizes.space50),
            logout.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Src.Sizes.space10),
            logout.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Src.Sizes.space15)
        ])
    }
}
