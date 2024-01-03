import Foundation
import CoreData


extension SavedListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedListItem> {
        return NSFetchRequest<SavedListItem>(entityName: "SavedListItem")
    }

    @NSManaged public var listName: String?
    @NSManaged public var locationNumber: Int32

}

extension SavedListItem : Identifiable {

}
