//
//  Location+CoreDataProperties.swift
//  FacialRecognitionPrototipe
//
//  Created by formando on 07/12/2023.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double

}

extension Location : Identifiable {

}
