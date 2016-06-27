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
    
    private var isColorMarkedBefore = false
    private var selectColor: UIColor!
    @IBOutlet weak var colorMarkerView: UIView!
    @IBOutlet var colorBtns: [UIButton]!
    @IBOutlet weak var themeField: UITextField!
    @IBOutlet weak var createDateLabel: UILabel!
    @IBOutlet weak var dueDateField: UITextField!
    @IBOutlet weak var descTextView: UITextView!
   
    @IBOutlet weak var colorContentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDatePickerView()
        self.descTextView.layer.cornerRadius = 5
        self.descTextView.layer.masksToBounds = true
        self.themeField.text = self.toDo.title
        self.createDateLabel.text = "Create date:\(self.dateFormatter.stringFromDate(self.toDo.createDate!))"
        self.dueDateField.text = "Due date:\(self.dateFormatter.stringFromDate(self.toDo.dueDate!))"
        self.descTextView.text = self.toDo.desc
        self.descTextView.delegate = self
        self.colorMarkerView.layer.cornerRadius = self.colorMarkerView.frame.size.width / 2
        self.colorMarkerView.layer.masksToBounds = true
        
        let colorBtnRadius = self.colorBtns.first!.frame.size.width / 2
        for colorBtn in self.colorBtns {
            colorBtn.layer.masksToBounds = true
            colorBtn.layer.cornerRadius = colorBtnRadius
        }
        
        self.colorContentView.userInteractionEnabled = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard !self.isColorMarkedBefore else { return }
        let toDoColor = toDo.indicator as! UIColor
        self.selectColor = toDoColor
        for colorBtn in self.colorBtns {
            if toDoColor == colorBtn.backgroundColor {
                self.colorMarkerView.center = colorBtn.center
                break
            }
        }
    }
    
    @IBAction func editBtnClick(sender: UIBarButtonItem) {
        if self.isRightBarBttuonItmEditState {
            self.isRightBarBttuonItmEditState = false
            
            self.themeField.enabled = true
            self.dueDateField.enabled = true
            self.themeField.becomeFirstResponder()
            self.descTextView.editable = true
             self.colorContentView.userInteractionEnabled = true
            sender.title = "Save"
        } else {
            self.isRightBarBttuonItmEditState = true
            self.themeField.enabled = false
            self.themeField.resignFirstResponder()
            self.descTextView.editable = false
             self.dueDateField.enabled = false
            sender.title = "Edit"
            self.toDo.title = self.themeField.text
            self.toDo.desc = self.descTextView.text
            if self.lastSelectDate != nil {
                self.toDo.dueDate = self.lastSelectDate
            }
            self.colorContentView.userInteractionEnabled = false
            self.toDo.indicator = self.selectColor
            self.delegate.toDoItemDidChange(self.toDo)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    private func initDatePickerView() {
        
        let pickerH:CGFloat = 180
        let pickerX: CGFloat = 0
        let pickerY = self.view.frame.size.height - pickerH
        let pickerW = self.view.frame.size.width
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
        self.dueDateField.resignFirstResponder()
    }
    
    @IBAction func colorBtnClick(sender: UIButton) {
        self.isColorMarkedBefore = true
        UIView.animateWithDuration(0.25) { 
           self.colorMarkerView.center = sender.center 
        }
        
        self.selectColor = sender.backgroundColor
    }
    
    @IBAction func dueDateFieldBeginEidt(sender: AnyObject) {
        self.lastSelectDate = self.datePickerView.date
        self.dueDateField.text = "Due date:\(self.dateFormatter.stringFromDate(self.lastSelectDate!))"
        self.dueDateField.inputView = self.datePickerView
    }
    
    @objc private func datePickerValueChanged(datePicker: UIDatePicker) {
        self.lastSelectDate = datePicker.date
        self.dueDateField.text = "Due date:\(self.dateFormatter.stringFromDate(self.lastSelectDate!))"
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.lastSelectDate = self.datePickerView.date
        self.view.endEditing(true)
    }

}

extension DetailViewController: UITextViewDelegate {
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.descTextView.resignFirstResponder()
        }
        return true
    }
}
