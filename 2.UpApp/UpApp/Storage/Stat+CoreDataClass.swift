import CoreData


public class Stat: NSManagedObject {    
    // MARK: Fetch
    static func fetchStat(stats: inout Stat?, context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Stat> = Stat.fetchRequest()
           do {
               let res = try context.fetch(fetchRequest)
               if let firstStat = res.first {
                   stats = firstStat
               } else {
                   stats = Stat(context: context)
               }
           } catch { }
    }
    
    // MARK: Save
    static func saveContext(context: NSManagedObjectContext) {
        do { try context.save() } catch { }
    }
}
