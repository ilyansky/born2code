import UIKit
import CoreData

final class AgendaModel {
    static func createNewAim(context: NSManagedObjectContext) {
        _ = Aim(context: context)
        Aim.saveContext(context: context)
    }
}
