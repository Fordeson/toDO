//
//  SortViewController.swift
//  ToDo
//
//  Created by 王荣荣 on 6/21/16.
//  Copyright © 2016 王荣荣. All rights reserved.
//

import UIKit

enum Sorter:Int {
    case Default = 0
    case CreateAscending
    case CreateDecending
    case DueAscending
    case DueDecending
    case CompleteAscending
    case CompleteDecending
}

protocol SortViewControllerDelegate: class {
    func reloadTableViewWithSorter(sorter: Sorter)
}

class SortViewController: UIViewController {
    private var lastSelectRow = 0
    var delegate: SortViewControllerDelegate!
    private lazy var cellInfo: NSArray = {
        let info = [
                    "Default",
                    "Create date ascending",
                    "Create date descending",
                    "Due date ascending",
                    "Due date descending",
                    "Complete ascending",
                    "Complete decending"
                    ]
        return info
    }()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = 54
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func comfirmBtnCilck(sender: UIButton) {
        var sorter = Sorter.Default
        switch self.lastSelectRow {
        case 0:
            sorter = .Default
        case 1:
            sorter = .CreateAscending
        case 2:
            sorter = .CreateDecending
        case 3:
            sorter = .DueAscending
        case 4:
            sorter = .DueDecending
        case 5:
            sorter = .CompleteAscending
        case 6:
            sorter = .CompleteDecending
        default:
            break
        }
        self.delegate.reloadTableViewWithSorter(sorter)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func dismissBtnClick(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension SortViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellInfo.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("sortCell")
        cell?.textLabel?.text = self.cellInfo[indexPath.row] as? String
        cell?.accessoryType
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
        self.lastSelectRow = indexPath.row
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .None
    }
}
