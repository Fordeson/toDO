//
//  ToDoCell.swift
//  ToDo
//
//  Created by 王荣荣 on 6/20/16.
//  Copyright © 2016 王荣荣. All rights reserved.
//

import UIKit

class ToDoCell: UITableViewCell {
 
    lazy var dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        return formatter
    }()
    
    lazy var timeFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        return formatter
    }()
    let calendar = NSCalendar.currentCalendar()
    @IBOutlet weak var indicatorImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createDateLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    @IBOutlet weak var completeView: UIView!
    var toDo: ToDo! {
        didSet{
           self.titleLabel.text = toDo.title
            self.indicatorImage.backgroundColor = toDo.indicator as? UIColor
            
            populateCreateDateLabel(self.toDo.createDate!)
            populateDueDateLabel(self.toDo.dueDate!)
           let result = (toDo.dueDate?.compare(NSDate()))! as NSComparisonResult
            if result == NSComparisonResult.OrderedAscending  {
                self.dueDateLabel.textColor = UIColor.redColor()
            } else {
                self.dueDateLabel.textColor = UIColor(red: 105/255.0, green: 137/255.0, blue: 227/255.0, alpha: 1.0)
            }
            
            if toDo.isComplish == true {
                self.completeView.hidden = false
                self.completeView.backgroundColor = self.indicatorImage.backgroundColor
            } else {
                self.completeView.hidden = true
            }
        }
    }
    
    func populateCreateDateLabel(date: NSDate) {
       
        let isToday = calendar.isDateInToday(date)
        let isYestoday = calendar.isDateInYesterday(date)
        let differDay = NSDate.numberOfDaysFromTodayToDate(date)
        let absDifferDay = abs(differDay)
        
        
        if isToday {
        if  NSDate.hoursAndMinutesBefore(date).hours == 0 {
            self.createDateLabel.text = "\(NSDate.hoursAndMinutesBefore(date).minutes)min before"
        } else if NSDate.hoursAndMinutesBefore(date).hours > 0{
            self.createDateLabel.text = "\(abs(NSDate.hoursAndMinutesBefore(date).hours))h \(NSDate.hoursAndMinutesBefore(date).minutes)min before"
            }
            
        } else if isYestoday {
            self.createDateLabel.text = "Yestoday \(self.timeFormatter.stringFromDate(date))"
        } else if differDay < 0 {
            self.createDateLabel.text = " \(absDifferDay) days before"
        } else {
            self.createDateLabel.text = "\(self.dateFormatter.stringFromDate(date))"
        }
    }
    
    func populateDueDateLabel(date: NSDate) {
//        if NSDate.numberOfDaysFromTodayToDate(date) == 0 {
//            print(NSDate.hoursAndMinutesBefore(date))
//        }
        
        let isToday = calendar.isDateInToday(date)
        let isYestoday = calendar.isDateInYesterday(date)
        let isTomorrow = calendar.isDateInTomorrow(date)
        let differDay = NSDate.numberOfDaysFromTodayToDate(date)
        let absDifferDay = abs(differDay)
        if isToday {
            if  NSDate.hoursAndMinutesBefore(date).hours == 0 {
                self.dueDateLabel.text = "\(NSDate.hoursAndMinutesBefore(date).minutes)min left"
            } else if  NSDate.hoursAndMinutesBefore(date).hours > 0 {
                self.dueDateLabel.text = "\(abs(NSDate.hoursAndMinutesBefore(date).hours))h \(NSDate.hoursAndMinutesBefore(date).minutes)min left"
            } else {
                self.dueDateLabel.text = "\(abs(NSDate.hoursAndMinutesBefore(date).hours))h \(NSDate.hoursAndMinutesBefore(date).minutes)min before"
            }
            
        } else if isTomorrow {
            self.dueDateLabel.text = "Tomorrow \(self.timeFormatter.stringFromDate(date))"
        } else if isYestoday {
            self.dueDateLabel.text = "Yestoday \(self.timeFormatter.stringFromDate(date))"
        } else if differDay > 0 {
            self.dueDateLabel.text = " \(absDifferDay) days left"
        } else if differDay < 0 {
            self.dueDateLabel.text = " \(absDifferDay) days before"
        }
        else {
            self.dueDateLabel.text = "\(self.dateFormatter.stringFromDate(date))"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.completeView.hidden = true
    }

    override func setSelected(selected: Bool, animated: Bool) {

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }

}
