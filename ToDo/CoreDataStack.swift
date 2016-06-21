//
//  CoreDataStack.swift
//  ToDo
//
//  Created by 王荣荣 on 6/20/16.
//  Copyright © 2016 王荣荣. All rights reserved.
//

import Foundation
import CoreData

//class CoreDataStack{
//    
//    let modelName = "toDo"
//    lazy var managedObjectContext: NSManagedObjectContext = {
//        var context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
//        context.persistentStoreCoordinator = self.psc
//        return context
//    }()
//    
//    private lazy var applicationDocumentsDirectory: NSURL = {
//        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
//        return urls.last!
//    }()
//    
//    private lazy var psc: NSPersistentStoreCoordinator = {
//        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedModel)
//        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(self.modelName)
//        do {
//            let options = [NSMigratePersistentStoresAutomaticallyOption : true]
//            try coordinator.addPersistentStoreWithType( NSSQLiteStoreType, configuration: nil, URL: url, options: options)
//        } catch {
//            print("error")
//        }
//        return coordinator
//    }()
//    
//    private lazy var managedModel: NSManagedObjectModel = {
//        let modelURL = NSBundle.mainBundle()
//            .URLForResource(self.modelName,
//                            withExtension: "momd")!
//        return NSManagedObjectModel(contentsOfURL: modelURL)!
//      
//    }()
//}

class CoreDataStack {
    
    let modelName = "ToDo"
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        
        var context = NSManagedObjectContext(
            concurrencyType: .MainQueueConcurrencyType)
        
        context.persistentStoreCoordinator = self.psc
        return context
    }()
    
    private lazy var psc: NSPersistentStoreCoordinator = {
        
        let coordinator = NSPersistentStoreCoordinator(
            managedObjectModel: self.managedObjectModel)
        
        let url = self.applicationDocumentsDirectory
            .URLByAppendingPathComponent(self.modelName)
        
        do {
            let options =
                [NSMigratePersistentStoresAutomaticallyOption : true]
            
            try coordinator.addPersistentStoreWithType(
                NSSQLiteStoreType, configuration: nil, URL: url,
                options: options)
        } catch  {
            print("Error adding persistent store.")
        }
        
        return coordinator
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        
        let modelURL = NSBundle.mainBundle()
            .URLForResource(self.modelName,
                            withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    private lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(
            .DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
                abort()
            }
        }
    }
}
