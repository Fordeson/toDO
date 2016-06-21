//
//  ListViewController.swift
//  ToDo
//
//  Created by 王荣荣 on 6/20/16.
//  Copyright © 2016 王荣荣. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UITableViewController {
    private var sorter: Sorter!
    var coreDataStack: CoreDataStack!
    private let editIdentifier = "editIdentifier"
    private let detailIdentifier = "detailIdentifier"
    private let sortIdentifier = "sortIdentifier"
    private var list: [ToDo]! = []
    private var selectIndex: NSIndexPath!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 64
        fetchList(withSorter: .Default)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func fetchList(withSorter sorter: Sorter) {
        let fetchRequest = NSFetchRequest(entityName: "ToDo")
        switch sorter {
        case .CreateAscending:
                let fetchSorter = NSSortDescriptor(key: "createDate", ascending: true)
                fetchRequest.sortDescriptors = [fetchSorter]
        case .CreateDecending:
              let fetchSorter = NSSortDescriptor(key: "createDate", ascending: false)
              fetchRequest.sortDescriptors = [fetchSorter]
            
        case .DueAscending:
            let fetchSorter = NSSortDescriptor(key: "dueDate", ascending: true)
            fetchRequest.sortDescriptors = [fetchSorter]
        case .DueDecending:
            let fetchSorter = NSSortDescriptor(key: "dueDate", ascending: false)
            fetchRequest.sortDescriptors = [fetchSorter]
        case .CompleteAscending:
            let fetchSorter = NSSortDescriptor(key: "isComplish", ascending: true)
            fetchRequest.sortDescriptors = [fetchSorter]
        case .CompleteDecending:
            let fetchSorter = NSSortDescriptor(key: "isComplish", ascending: false)
            fetchRequest.sortDescriptors = [fetchSorter]
        default:
            break
        }
        
        do {
            self.list = try self.coreDataStack.managedObjectContext.executeFetchRequest(fetchRequest) as! [ToDo]
            self.tableView.reloadData()
        } catch let error as NSError {
            print(error)
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.list.count
    }

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("toDo", forIndexPath: indexPath) as! ToDoCell
        let toDo = self.list[indexPath.row]
        cell.toDo = toDo
        return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        self.selectIndex = indexPath
        return self.selectIndex
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == editIdentifier {
            let editVC = segue.destinationViewController as! EditViewController
            editVC.coreDataStack = self.coreDataStack
            editVC.delegate = self
        } else if segue.identifier == self.detailIdentifier {
            let detailVC = segue.destinationViewController as! DetailViewController
            detailVC.toDo = self.list[self.selectIndex.row]
            detailVC.delegate = self
        } else if segue.identifier == self.sortIdentifier {
            let sortVC = segue.destinationViewController as! SortViewController
            sortVC.delegate = self
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let toDo = self.list[indexPath.row]
        var moreTitle = "Complete"
        if toDo.isComplish == false {
            moreTitle = "Complete"
        } else {
            moreTitle = "To do"
        }
        let moreRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: moreTitle, handler:{action, indexpath in
            self.tableView.setEditing(false, animated: true)
            toDo.isComplish = NSNumber(bool: !((toDo.isComplish?.boolValue)!))
            self.coreDataStack.saveContext()
           self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Middle)

        });
        moreRowAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler:{action, indexpath in
            self.deleteToDoItem(toDo, indexPath: indexPath)
        });
        
        return [deleteRowAction, moreRowAction];
    }
    
    private func deleteToDoItem(toDo: ToDo, indexPath: NSIndexPath) {
        let alertVC = UIAlertController(title: "Delete", message: "Delete current row?", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .Destructive) { (action) in
            self.coreDataStack.managedObjectContext.deleteObject(toDo)
            self.list.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
            
        }
        
        alertVC.addAction(cancelAction)
        alertVC.addAction(deleteAction)
        
        self.presentViewController(alertVC, animated: true, completion: nil)
    }
}

extension ListViewController: EditViewControllerDelegate, DetailViewControllerDegate {
    func toDoListDidAddObject() {
        if self.sorter == nil {
            self.fetchList(withSorter: Sorter.Default)
        } else {
            self.fetchList(withSorter: sorter)
        }
    }
    
    func toDoItemDidChange(toDo: ToDo) {
        self.coreDataStack.saveContext()
        if self.sorter == nil {
            self.fetchList(withSorter: Sorter.Default)
        } else {
            self.fetchList(withSorter: sorter)
        }
    }
}

extension ListViewController: SortViewControllerDelegate {
    func reloadTableViewWithSorter(sorter: Sorter) {
        self.sorter = sorter
        switch sorter {
        case .CreateAscending:
            self.fetchList(withSorter: .CreateAscending)
        case .CreateDecending:
            self.fetchList(withSorter: .CreateDecending)
        case .DueAscending:
            self.fetchList(withSorter: .DueAscending)
        case .DueDecending:
            self.fetchList(withSorter: .DueDecending)
        case .CompleteAscending:
            self.fetchList(withSorter: .CompleteAscending)
        case .CompleteDecending:
            self.fetchList(withSorter: .CompleteDecending)
        default:
            break
        }
    }
}
