//
//  ToDo+CoreDataProperties.swift
//  ToDo
//
//  Created by 王荣荣 on 6/20/16.
//  Copyright © 2016 王荣荣. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ToDo {

    @NSManaged var title: String?
    @NSManaged var createDate: NSDate?
    @NSManaged var indicator: NSObject?
    @NSManaged var desc: String?
    @NSManaged var dueDate: NSDate?
    @NSManaged var isComplish: NSNumber?

}
