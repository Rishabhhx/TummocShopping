//
//  CoreDataManager.swift
//  TummocShopping
//
//  Created by Rishabh Sharma(Personal) on 28/01/24.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "TummocDataModel")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print(error)
            } else {
                print("Success")
            }
        }
        context = container.viewContext
    }
    
    func saveItem() {
        do {
            print("SAVED DATA")
            try context.save()
        } catch {
            print(error)
        }
    }
}
