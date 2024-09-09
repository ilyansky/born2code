import UIKit
import CoreData

final class ProgressController: BaseController {
   
    private let rankView = UIView()
    private let rank = UILabel()
    private let rankColor = UIColor()
    private let totalHours = UILabel()
    private let totalAims = UILabel()
    private let rankInfoButton = UIButton()

    private let progressView = UIView()
    private let progressInAPeriod = UILabel()
    private let periodItems = ["Day", "Week", "Month"]
    lazy var dayWeekMonth: UISegmentedControl = {
        let view = UISegmentedControl(items: periodItems)
        view.selectedSegmentIndex = 0
        return view
    }()
    private let aimsLabel = UILabel()
    private let spentHours = UILabel()

    private let clearButton = UIButton()
    
    private var stats: Stat?
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // perks
        ProgressModel.calculateRankView()
        changeRankView()
        
        // aims
        Stat.fetchStat(stats: &stats, context: context)
        updateStats()
    }
    
}

// MARK: - Actions
extension ProgressController {
    @objc func tapinfo() {
        let rankInfoView = RankInfoView()
        rankInfoView.modalPresentationStyle = .automatic
        self.present(rankInfoView, animated: true)
    }
    
    @objc func tapClearButton() {
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        alert.setValue(Resources.Common.returnStringWithAttributes(title: "Are you sure you want to delete all data?"), forKey: "attributedTitle")
        
        let submitButton = UIAlertAction(title: "Yep", style: .default) { _ in
            Resources.Storage.clearEntityStorage(title: "Perk")
            Resources.Storage.clearEntityStorage(title: "Aim")
            Resources.Storage.clearEntityStorage(title: "Stat")
            
            self.setUI()
            
            ProgressModel.calculateRankView()
            self.changeRankView()
            
            Stat.fetchStat(stats: &self.stats, context: self.context)
            self.updateStats()
            
          
        }
        let cancelButon = UIAlertAction(title: "Nope", style: .cancel)
        
        alert.addAction(submitButton)
        alert.addAction(cancelButon)

        self.present(alert, animated: true)
    }
}



// MARK: - Support
extension ProgressController {
    @objc private func dayWeekMonthValueChanged(_ sender: UISegmentedControl) {
        updateStats()
    }
    
    private func updateStats() {
        guard let stats = stats else { return }
        
        switch dayWeekMonth.selectedSegmentIndex {
        case 0:
            Resources.Common.configLabelWithImage(label: aimsLabel, title: " \(String(stats.aimDay))", position: 0, imageName: "aim36")
            Resources.Common.configLabelWithImage(label: spentHours, title: " \(String(format: "%.1f", stats.hourDay))", position: 0, imageName: "perk36")
        case 1:
            Resources.Common.configLabelWithImage(label: aimsLabel, title: " \(String(stats.aimWeek))", position: 0, imageName: "aim36")
            Resources.Common.configLabelWithImage(label: spentHours, title: " \(String(format: "%.1f", stats.hourWeek))", position: 0, imageName: "perk36")
        default:
            Resources.Common.configLabelWithImage(label: aimsLabel, title: " \(String(stats.aimMonth))", position: 0, imageName: "aim36")
            Resources.Common.configLabelWithImage(label: spentHours, title: " \(String(format: "%.1f", stats.hourMonth))", position: 0, imageName: "perk36")
        }
       
    }
    
    private func changeRankView() {
        // rank
        rank.text = ProgressModel.rankTitle
        rank.backgroundColor = ProgressModel.rankColor
        
        // totalHours
        Resources.Common.configLabelWithImage(label: totalHours, title: " \(String(ProgressModel.totalHours))", position: 0, imageName: "perk")
        totalHours.backgroundColor = ProgressModel.rankColor
        
        // totalAims
        Resources.Common.configLabelWithImage(label: totalAims, title: " \(ProgressModel.totalAims)", position: 0, imageName: "aim")
        totalAims.backgroundColor = ProgressModel.rankColor
    }
}

// MARK: - UI
extension ProgressController {
    private func setUI() {
        setRankView()
        setWeekStatView()
        setClearButton()
    }
    
    private func setRankView() {
        view.addSubview(rankView)
        view.addSubview(rankInfoButton)
        rankView.addSubview(rank)
        rankView.addSubview(totalHours)
        rankView.addSubview(totalAims)
        
        // rankView
        rankView.backgroundColor = Resources.Common.Colors.backgroundCard
        rankView.layer.cornerRadius = Resources.Common.Sizes.cornerRadius25
        setRankViewPosition()
        
        // rank
        Resources.Common.setLabel(label: rank,
                                  size: Resources.Common.Sizes.font30,
                                  text: ProgressModel.rankTitle,
                                  cornerRadius: Resources.Common.Sizes.cornerRadius15,
                                  setPosition: setRankPosition,
                                  masksToBounds: true)
        
        // totalHours
        Resources.Common.setLabel(label: totalHours,
                                  size: Resources.Common.Sizes.font20,
                                  cornerRadius: Resources.Common.Sizes.cornerRadius15,
                                  setPosition: setTotalHoursPosition,
                                  masksToBounds: true)
        
        // totalAims
        Resources.Common.setLabel(label: totalAims,
                                  size: Resources.Common.Sizes.font20,
                                  cornerRadius: Resources.Common.Sizes.cornerRadius15,
                                  setPosition: setTotalAimsPosition,
                                  masksToBounds: true)
        
        // rankInfo
        Resources.Common.setButton(
            button: rankInfoButton,
            image: UIImage(named: "info"),
            backgroundColor: Resources.Common.Colors.creator,
            cornerRadius: Resources.Common.Sizes.cornerRadius25,
            setPosition: setInfoPosition
        )
        rankInfoButton.addTarget(self, action: #selector(tapinfo), for: .touchUpInside)
        
    }

    private func setWeekStatView() {
        view.addSubview(progressView)
        progressView.addSubview(progressInAPeriod)
        progressView.addSubview(aimsLabel)
        progressView.addSubview(dayWeekMonth)
        progressView.addSubview(spentHours)
        
        // view
        progressView.backgroundColor = Resources.Common.Colors.backgroundCard
        progressView.layer.cornerRadius = Resources.Common.Sizes.cornerRadius25
        setProgressViewPosition()

        // progressInAPeriod
        Resources.Common.setLabel(label: progressInAPeriod,
                                  size: 20,
                                  text: "Progress per",
                                  setPosition: setProgressInAPeriodPosition)

        // dayWeekMonth
        dayWeekMonth.addTarget(self, action: #selector(dayWeekMonthValueChanged(_:)), for: .valueChanged)
        let attrs: [NSAttributedString.Key: Any] = [
            .font: Resources.Common.futura(size: 13)
            
        ]
        dayWeekMonth.setTitleTextAttributes(attrs, for: .normal)
        dayWeekMonth.backgroundColor = Resources.Common.Colors.backgroundGray
        
        setDayWeekMonthPosition()
        
        // aimsLabel
        Resources.Common.setLabel(label: aimsLabel,
                                  size: 36,
                                  backgroundColor: Resources.Common.Colors.greenLight,
                                  cornerRadius: 30,
                                  setPosition: setCompletedAimsLabelPosition,
                                  masksToBounds: true)
        aimsLabel.numberOfLines = 2
        
        // spentHours
        Resources.Common.setLabel(label: spentHours,
                                  size: 36,
                                  backgroundColor: Resources.Common.Colors.green,
                                  cornerRadius: 30,
                                  setPosition: setSpentHoursLabelPosition,
                                  masksToBounds: true)
        
        spentHours.numberOfLines = 2         
    }
    
    private func setClearButton() {
        view.addSubview(clearButton)
        Resources.Common.setButton(button: clearButton,
                                   image: UIImage(named: "bin"),
                                   backgroundColor: Resources.Common.Colors.red,
                                   setPosition: setClearButtonPosition)
        clearButton.addTarget(self, action: #selector(tapClearButton), for: .touchUpInside)
    }

    
}

// MARK: - Position
extension ProgressController {
    // rank view
    private func setRankViewPosition() {
        rankView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            rankView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Resources.Common.Sizes.space15),
            rankView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            rankView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rankView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.25)
        ])
    }
    
    private func setRankPosition() {
        rank.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            rank.topAnchor.constraint(equalTo: rankView.safeAreaLayoutGuide.topAnchor, constant: Resources.Common.Sizes.space10),
            rank.leadingAnchor.constraint(equalTo: rankView.leadingAnchor, constant: Resources.Common.Sizes.space10),
            rank.trailingAnchor.constraint(equalTo: rankView.trailingAnchor, constant: -Resources.Common.Sizes.space10),
            rank.bottomAnchor.constraint(equalTo: totalHours.topAnchor, constant: -Resources.Common.Sizes.space10)
        ])
    }

    private func setTotalHoursPosition() {
        totalHours.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            totalHours.bottomAnchor.constraint(equalTo: totalAims.topAnchor, constant: -Resources.Common.Sizes.space10),
            totalHours.leadingAnchor.constraint(equalTo: rankView.leadingAnchor, constant: Resources.Common.Sizes.space10),
            totalHours.trailingAnchor.constraint(equalTo: rankView.trailingAnchor, constant: -Resources.Common.Sizes.space10),
            totalHours.heightAnchor.constraint(equalTo: rankView.heightAnchor, multiplier: 0.2)

        ])
    }
    
    private func setTotalAimsPosition() {
        totalAims.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            totalAims.topAnchor.constraint(equalTo: totalHours.bottomAnchor, constant: Resources.Common.Sizes.space10),
            totalAims.leadingAnchor.constraint(equalTo: rankView.leadingAnchor, constant: Resources.Common.Sizes.space10),
            totalAims.trailingAnchor.constraint(equalTo: rankView.trailingAnchor, constant: -Resources.Common.Sizes.space10),
            totalAims.heightAnchor.constraint(equalTo: rankView.heightAnchor, multiplier: 0.2),
            totalAims.bottomAnchor.constraint(equalTo: rankView.bottomAnchor, constant: -Resources.Common.Sizes.space10)
        ])
    }


    private func setInfoPosition() {
        rankInfoButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            rankInfoButton.widthAnchor.constraint(equalToConstant: 50),
            rankInfoButton.heightAnchor.constraint(equalToConstant: 50),
            rankInfoButton.leadingAnchor.constraint(equalTo: rankView.trailingAnchor, constant: Resources.Common.Sizes.space15),
            rankInfoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Resources.Common.Sizes.space15)
        ])
    }
    
    
    // stats view
    private func setProgressViewPosition() {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: rankView.bottomAnchor, constant: Resources.Common.Sizes.space15),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Resources.Common.Sizes.space15),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Resources.Common.Sizes.space15),
            progressView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.3)

        ])
    }
    
    private func setProgressInAPeriodPosition() {
        progressInAPeriod.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            progressInAPeriod.topAnchor.constraint(equalTo: progressView.topAnchor, constant: Resources.Common.Sizes.space10),
            progressInAPeriod.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            progressInAPeriod.heightAnchor.constraint(equalTo: progressView.heightAnchor, multiplier: 0.2)
        ])
    }
    
    private func setDayWeekMonthPosition() {
        dayWeekMonth.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dayWeekMonth.topAnchor.constraint(equalTo: progressInAPeriod.bottomAnchor, constant: Resources.Common.Sizes.space10),
            dayWeekMonth.leadingAnchor.constraint(equalTo: progressView.leadingAnchor, constant: Resources.Common.Sizes.space15),
            dayWeekMonth.trailingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: -Resources.Common.Sizes.space15),
            dayWeekMonth.heightAnchor.constraint(equalTo: progressView.heightAnchor, multiplier: 0.2)
        ])
    }

    private func setCompletedAimsLabelPosition() {
        aimsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            aimsLabel.trailingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: -Resources.Common.Sizes.space10),
            aimsLabel.topAnchor.constraint(equalTo: dayWeekMonth.bottomAnchor, constant: Resources.Common.Sizes.space10),
            aimsLabel.bottomAnchor.constraint(equalTo: progressView.bottomAnchor, constant: -Resources.Common.Sizes.space10),
            aimsLabel.widthAnchor.constraint(equalTo: progressView.widthAnchor, multiplier: 0.45),
        ])
    }
    
    private func setSpentHoursLabelPosition() {
        spentHours.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            spentHours.leadingAnchor.constraint(equalTo: progressView.leadingAnchor, constant: Resources.Common.Sizes.space10),
            spentHours.topAnchor.constraint(equalTo: dayWeekMonth.bottomAnchor, constant: Resources.Common.Sizes.space10),
            spentHours.bottomAnchor.constraint(equalTo: progressView.bottomAnchor, constant: -Resources.Common.Sizes.space10),
            spentHours.widthAnchor.constraint(equalTo: progressView.widthAnchor, multiplier: 0.45)
        ])
    }
    
    // clear
    private func setClearButtonPosition() {
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            clearButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Resources.Common.Sizes.space15),
            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clearButton.widthAnchor.constraint(equalToConstant: 50),
            clearButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
