//
//  CoreDataManager.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/01.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    init() {
    }
    
    class var sharedInstance: CoreDataManager {
        struct Static {
            static let instance: CoreDataManager = CoreDataManager()
        }
        return Static.instance
    }
    
    func create<DataType: CoreDataEntity>() -> DataType {
        let managedObject: AnyObject = NSEntityDescription.insertNewObjectForEntityForName(
            NSStringFromClass(DataType).componentsSeparatedByString(".").last!as String,
            inManagedObjectContext: managedObjectContext)
        
        let entity = managedObject as! DataType
        entity.updatePrevioudId()
        return entity
    }
    
    func read<DataType: CoreDataEntity>(fetchRequest: NSFetchRequest) -> [DataType]? {
        do {
            let data = try managedObjectContext.executeFetchRequest(fetchRequest) as? [DataType]
            for entity in data! {
                entity.updatePrevioudId()
            }
            return data
        } catch {
            //例外
            return nil
        }
    }
    
    func dispose( object: CoreDataEntity, mergeChanges: Bool ) {
        managedObjectContext.refreshObject(object, mergeChanges: mergeChanges)
    }
    
    func delete( entity: CoreDataEntity ) -> Void {
        managedObjectContext.deleteObject(entity)
    }
    
    // MARK: - Core Data Saving support
    func saveContext () -> Void {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                //TODO 例外
            }
        }
    }
    
    // MARK: - Core Data stack
    private lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager()
            .URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("photoboard", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory
            .URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
#if TESTING
            try coordinator.addPersistentStoreWithType(
                NSInMemoryStoreType, configuration: nil, URL: url, options: nil)
            NSLog("CoreData InMemoryMode")
#else
            try coordinator.addPersistentStoreWithType(
                NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
            NSLog("CoreData SQLiteMode")
#endif
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    private lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext
            = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
}
