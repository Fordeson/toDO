//
//  DetailViewController.swift
//  ToDo
//
//  Created by 王荣荣 on 6/20/16.
//  Copyright © 2016 王荣荣. All rights reserved.
//

import UIKit

protocol DetailViewControllerDegate: class {
    func toDoItemDidChange(toDo: ToDo)
}

class DetailViewController: UIViewController {
    var toDo: ToDo!
    private var isRightBarBttuonItmEditState = true
    private var tapGesture: UITapGestureRecognizer!
    private var editBtnTitle: String!
    private var datePickerView: UIDatePicker!
    var delegate: DetailViewControllerDegate!
    private var lastSelectDate: NSDate!
    lazy var dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        return formatter
    }()
    
    @IBOutlet weak var themeField: UITextField!
    @IBOutlet weak var createDateLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var dueDateField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.descTextView.layer.cornerRadius = 5
        self.descTextView.layer.masksToBounds = true
        self.themeField.text = self.toDo.title
        self.createDateLabel.text = "Create date:\(self.dateFormatter.stringFromDate(self.toDo.createDate!))"
        self.dueDateLabel.text = "Due date:\(self.dateFormatter.stringFromDate(self.toDo.dueDate!))"
        self.descTextView.text = self.toDo.desc
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dueDateLabelTapped))
        self.dueDateLabel.addGestureRecognizer(self.tapGesture)
         initDatePickerView()
        
    }
    
    @objc private func dueDateLabelTapped() {
        self.dueDateField.hidden = false
        self.dueDateField.becomeFirstResponder()
    }
    
    @IBAction func editBtnClick(sender: UIBarButtonItem) {
        if self.isRightBarBttuonItmEditState {
            self.isRightBarBttuonItmEditState = false
            
            self.themeField.enabled = true
            self.themeField.becomeFirstResponder()
            self.descTextView.editable = true
            self.dueDateLabel.userInteractionEnabled = true
            sender.title = "Save"
        } else {
            self.isRightBarBttuonItmEditState = true
            
            self.themeField.enabled = false
            self.themeField.resignFirstResponder()
            self.descTextView.editable = false
            self.dueDateLabel.userInteractionEnabled = false
            sender.title = "Edit"
            self.toDo.title = self.themeField.text
            self.toDo.desc = self.descTextView.text
            self.toDo.dueDate = self.lastSelectDate
            self.delegate.toDoItemDidChange(self.toDo)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    private func initDatePickerView() {
        
        let pickerH:CGFloat = 180
        let pickerX: CGFloat = 0
        let pickerY = self.view.frame.size.height - pickerH
        let pickerW = self.view.frame.size.width
        self.dueDateField.inputView = self.datePickerView
        self.datePickerView = UIDatePicker(frame: CGRectMake(pickerX, pickerY, pickerW, pickerH))
        self.datePickerView.datePickerMode = .DateAndTime
        self.datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), forControlEvents: .ValueChanged)
        
        let doneToolBar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.size.width, 35))
        doneToolBar.barStyle = .Default
        let flexibleSpaceItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(self.endSelectDate))
        doneToolBar.items = [flexibleSpaceItem, doneItem]
        self.dueDateField.inputAccessoryView = doneToolBar
        
    }
    
    @objc private func endSelectDate() {
        self.dueDateLabel.text =  "Due date:\(self.dateFormatter.stringFromDate(self.lastSelectDate))"
        self.dueDateField.resignFirstResponder()
        self.dueDateField.hidden = true
    }
    
    @IBAction func dateFieldClick(sender: AnyObject) {
        self.dueDateField.inputView = self.datePickerView
        self.lastSelectDate = self.datePickerView.date
        self.dueDateField.text = self.dateFormatter.stringFromDate(self.lastSelectDate)
    }
    
    @objc private func datePickerValueChanged(datePicker: UIDatePicker) {
        self.lastSelectDate = self.datePickerView.date
        self.dueDateField.text = self.dateFormatter.stringFromDate(self.lastSelectDate)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if self.dueDateField.text != "" {
             self.lastSelectDate = self.datePickerView.date
            self.dueDateLabel.text = "Due date:\(self.dateFormatter.stringFromDate(self.lastSelectDate))"
        }
        self.dueDateField.hidden = true
        self.view.endEditing(true)
    }

}
