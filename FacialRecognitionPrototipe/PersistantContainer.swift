//
//  PersistantContainer.swift
//  FacialRecognitionPrototipe
//
//  Created by Joao Vieira on 08/11/2023.
//

import Foundation
import CoreData

class PersistantContainer: NSPersistentContainer {


    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
            //TODO DONT JUST SAVE 
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
}
