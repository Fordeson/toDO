//
//  EditViewController.swift
//  ToDo
//
//  Created by 王荣荣 on 6/20/16.
//  Copyright © 2016 王荣荣. All rights reserved.
//

import UIKit
import CoreData

protocol EditViewControllerDelegate{
    func toDoListDidAddObject()
}

class EditViewController: UIViewController {
    
    var coreDataStack: CoreDataStack!
    var delegate: EditViewControllerDelegate!
    
    lazy var dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        
        return formatter
    }()
    
    private var selectedColor: UIColor!
    private var datePickerView: UIDatePicker!
    private var lastSelectDate: NSDate!
    
    @IBOutlet weak var themeField: UITextField!
    @IBOutlet weak var colorIndicatorView: UIView!
    
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet var colorBtn: [UIButton]!
    @IBOutlet weak var dueDateField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        let radius = ((self.colorBtn.first)?.frame.size.height)! / 2
        for btn in self.colorBtn {
            btn.layer.cornerRadius = radius
            btn.layer.masksToBounds = true
        }
        self.descTextView.layer.cornerRadius = 5
        self.descTextView.layer.masksToBounds = true
        self.colorIndicatorView.layer.cornerRadius = self.colorIndicatorView.frame.size.width / 2
        self.colorIndicatorView.layer.masksToBounds = true
        let redBtn = self.colorBtn.first!
        self.selectedColor = redBtn.backgroundColor
        initDatePickerView()
        self.descTextView.delegate = self
        self.themeField.delegate = self
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
    @IBAction func dueDateBeginEdit(sender: UITextField) {
        self.dueDateField.inputView = self.datePickerView
    }
    
    @objc private func datePickerValueChanged(datePicker: UIDatePicker) {
        self.lastSelectDate = self.datePickerView.date
        self.dueDateField.text = self.dateFormatter.stringFromDate(self.lastSelectDate)
    }
    
    @objc private func endSelectDate() {
        
        self.dueDateField.resignFirstResponder()
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func colorBtnClick(sender: UIButton) {
        self.selectedColor = sender.backgroundColor
        let newCenter = sender.center
        UIView.animateWithDuration(0.25) {
            self.colorIndicatorView.center = newCenter
        }
    }

    @IBAction func doneBtnClick(sender: UIBarButtonItem) {
        guard self.themeField.text != "" else { return }
        guard self.descTextView.text != "" else { return }
        guard self.dueDateField.text != "" else { return }
        guard self.selectedColor != nil else { return }
        let toDo = NSEntityDescription.insertNewObjectForEntityForName("ToDo", inManagedObjectContext: self.coreDataStack.managedObjectContext) as! ToDo
        toDo.createDate = NSDate()
        toDo.title = self.themeField.text
        toDo.desc = self.descTextView.text
        toDo.indicator = self.selectedColor
        toDo.dueDate = self.lastSelectDate
        toDo.isComplish = false
        self.delegate.toDoListDidAddObject()
        self.coreDataStack.saveContext()
        self.navigationController?.popViewControllerAnimated(true)

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension EditViewController: UITextViewDelegate , UITextFieldDelegate {
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.descTextView.resignFirstResponder()
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.themeField.resignFirstResponder()
        return true
    }
  
}
