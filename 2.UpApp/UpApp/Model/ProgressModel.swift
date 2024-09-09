import UIKit
import CoreData

final class ProgressModel {
    static var rankTitle: String = "Intern"
    static var rankColor: UIColor = Resources.Common.Colors.green
    static var totalHours: Float = 0
    static var totalAims: Int64 = 0
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    static func calculateRankView() {
        // totalhours
        totalHours = 0
        var perks: [Perk] = []
        var stats: Stat?
        Resources.Storage.refetchPerks(perks: &perks, context: ProgressModel.context)
        Stat.fetchStat(stats: &stats, context: context)
        
        for perk in perks {
            totalHours += perk.totalHours
        }
        
        if let aimsTotal = stats?.aimTotal {
            totalAims = aimsTotal
        }
        
        // rank
        switch totalHours {
        case 0...99:
            rankTitle = "Intern"
            rankColor = Resources.Common.Colors.blue
        case 100...999:
            rankTitle = "Junior"
            rankColor = Resources.Common.Colors.green
        case 1000...2999:
            rankTitle = "Middle"
            rankColor = Resources.Common.Colors.yellow
        case 3000...5999:
            rankTitle = "Senior"
            rankColor = Resources.Common.Colors.purple
        case 6000...9999:
            rankTitle = "Architect"
            rankColor = Resources.Common.Colors.red
        default:
            rankTitle = "The Creator"
            rankColor = Resources.Common.Colors.creator
        }
    }
}

final class ProgressPerPeriod {
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static var stats: Stat?
    
    static func refreshStats() {
        Stat.fetchStat(stats: &stats, context: ProgressPerPeriod.context)

        let currentDate = Date()
        let calendar = Calendar.current
        
        if !calendar.isDate((stats?.date)!, inSameDayAs: currentDate) {
            stats?.aimDay = 0
            stats?.hourDay = 0
        }
        
        if !calendar.isDate((stats?.date)!, equalTo: currentDate, toGranularity: .weekOfYear) {
            stats?.aimWeek = 0
            stats?.hourWeek = 0
        }
        
        if !calendar.isDate((stats?.date)!, equalTo: currentDate, toGranularity: .month) {
            stats?.aimMonth = 0
            stats?.hourMonth = 0
        }
        
        stats?.date = currentDate
        Stat.saveContext(context: ProgressPerPeriod.context)
    }
    
    static func incrementAims() {
        Stat.fetchStat(stats: &stats, context: ProgressPerPeriod.context)
        
        stats?.aimTotal += 1
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        if !calendar.isDate((stats?.date)!, inSameDayAs: currentDate) {
            stats?.aimDay = 1
        } else {
            stats?.aimDay += 1
        }
        
        if !calendar.isDate((stats?.date)!, equalTo: currentDate, toGranularity: .weekOfYear) {
            stats?.aimWeek = 1
        } else {
            stats?.aimWeek += 1
        }
        
        if !calendar.isDate((stats?.date)!, equalTo: currentDate, toGranularity: .month) {
            stats?.aimMonth = 1
        } else {
            stats?.aimMonth += 1
        }
        
        stats?.date = currentDate
        Stat.saveContext(context: ProgressPerPeriod.context)
    }
    
    static func incrementHours(hours: Float) {
        Stat.fetchStat(stats: &stats, context: ProgressPerPeriod.context)
                
        let currentDate = Date()
        let calendar = Calendar.current

        if !calendar.isDate((stats?.date)!, inSameDayAs: currentDate) {
            stats?.hourDay = hours
        } else {
            stats?.hourDay += hours
        }
        
        if !calendar.isDate((stats?.date)!, equalTo: currentDate, toGranularity: .weekOfYear) {
            stats?.hourWeek = hours
        } else {
            stats?.hourWeek += hours
        }
        
        if !calendar.isDate((stats?.date)!, equalTo: currentDate, toGranularity: .month) {
            stats?.hourMonth = hours
        } else {
            stats?.hourMonth += hours
        }
        
        stats?.date = currentDate
        Stat.saveContext(context: ProgressPerPeriod.context)
    }
}
