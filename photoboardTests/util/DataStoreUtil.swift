//
//  DataStoreUtil.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/27.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import CoreData
@testable import photoboard

struct DataStoreUtil {
    
    /**
     BoardInfoEntity作成
     
     - returns: Info
     */
    func createBoardInfoEntity() -> BoardInfoEntity {
        var entity: BoardInfoEntity? = nil
        do {
            entity = try CoreDataManager.sharedInstance.create() as BoardInfoEntity
        } catch {
        }
        return entity!
    }
    
    /**
     BoardBodyEntity作成
     
     - returns: Body
     */
    func createBoardBodyEntity() -> BoardBodyEntity {
        var entity: BoardBodyEntity? = nil
        do {
            entity = try CoreDataManager.sharedInstance.create() as BoardBodyEntity
        } catch {
        }
        return entity!
    }
    
    /**
     セーブ
     */
    func save() {
        do {
            try CoreDataManager.sharedInstance.saveContext()
        } catch {
            
        }
    }
    
    /**
     BoardPhotoEntity作成
     
     - returns: Photo
     */
    func createBoardPhotoEntity() -> BoardPhotoEntity {
        var entity: BoardPhotoEntity? = nil
        do {
            entity = try CoreDataManager.sharedInstance.create() as BoardPhotoEntity
        } catch {
        }
        return entity!
    }
    
    /**
     すべてのEntityを削除
     */
    func deleteAllEntities() {
        let infoFetchRequest = NSFetchRequest(entityName: "BoardInfoEntity")
        do {
            let entities = try CoreDataManager.sharedInstance
                .read(infoFetchRequest) as [BoardInfoEntity]
            for entity in entities {
                CoreDataManager.sharedInstance.delete(entity)
            }
        } catch {
            
        }
        let bodyFetchRequest = NSFetchRequest(entityName: "BoardBodyEntity")
        do {
            let entities = try CoreDataManager.sharedInstance
                .read(bodyFetchRequest) as [BoardBodyEntity]
            for entity in entities {
                CoreDataManager.sharedInstance.delete(entity)
            }
        } catch {
            
        }
        let photoFetchRequest = NSFetchRequest(entityName: "BoardPhotoEntity")
        do {
            let entities = try CoreDataManager.sharedInstance
                .read(photoFetchRequest) as [BoardPhotoEntity]
            for entity in entities {
                CoreDataManager.sharedInstance.delete(entity)
            }
        } catch {
            
        }
    }
}
