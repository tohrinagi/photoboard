//
//  CoreDataManager.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/01.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation
import CoreData


enum CoreDataManagerError: ErrorType {
    case NotRead    //読み込めず存在しない
    case NotFound   //検索して見つからなかった
    case UnExpected //予期せぬ
}

class CoreDataManager {
    
    init() {
    }
    
    class var sharedInstance: CoreDataManager {
        struct Static {
            static let instance: CoreDataManager = CoreDataManager()
        }
        return Static.instance
    }
    
    /**
     DataType を新規作成する
     
     - throws: DataTypeに変換できない場合 CoreDataManagerError.UnExpected
     
     - returns:新規作成した DataType
     */
    func create<DataType: CoreDataEntity>() throws -> DataType {
        let managedObject: AnyObject = NSEntityDescription.insertNewObjectForEntityForName(
            NSStringFromClass(DataType).componentsSeparatedByString(".").last!as String,
            inManagedObjectContext: managedObjectContext)
        
        if let entity = managedObject as? DataType {
            entity.updatePrevioudId()
            return entity
        }
        throw CoreDataManagerError.UnExpected
    }
    
    /**
     DataType を読み込む
     
     - parameter fetchRequest: 検索情報
     
     - throws: DataTypeに変換できない場合 CoreDataManagerError.UnExpected
     
     - returns: 読み込んだ DataType
     */
    func read<DataType: CoreDataEntity>(fetchRequest: NSFetchRequest) throws -> [DataType] {
        do {
            if let data = try managedObjectContext
                .executeFetchRequest(fetchRequest) as? [DataType] {
                for entity in data {
                    entity.updatePrevioudId()
                }
                return data
            }
            throw CoreDataManagerError.UnExpected
        } catch {
            throw CoreDataManagerError.UnExpected
        }
    }
    
    /**
     読み込んだアイテムをメモリから消す
     
     - parameter object:       処分対象の Entity
     - parameter mergeChanges: 変更をマージするか
     */
    func dispose( object: CoreDataEntity, mergeChanges: Bool ) {
        managedObjectContext.refreshObject(object, mergeChanges: mergeChanges)
    }
    
    /**
     Entity を消去する
     
     - parameter entity: 消去するEntity
     */
    func delete( entity: CoreDataEntity ) {
        managedObjectContext.deleteObject(entity)
    }
    
    // MARK: - Core Data Saving support
    func saveContext () throws {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                throw CoreDataManagerError.UnExpected
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
