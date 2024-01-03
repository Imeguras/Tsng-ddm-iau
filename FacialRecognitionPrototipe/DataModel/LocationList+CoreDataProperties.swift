import Foundation
import CoreData


extension LocationList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationList> {
        return NSFetchRequest<LocationList>(entityName: "LocationList")
    }

    @NSManaged public var locationName: String?

}

extension LocationList : Identifiable {

}
