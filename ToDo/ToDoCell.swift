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

    @IBOutlet weak var indicatorImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createDateLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    @IBOutlet weak var completeView: UIView!
    var toDo: ToDo! {
        didSet{
           self.titleLabel.text = toDo.title
            self.createDateLabel.text = self.dateFormatter.stringFromDate(toDo.createDate!)
            self.indicatorImage.backgroundColor = toDo.indicator as? UIColor
            self.dueDateLabel.text = self.dateFormatter.stringFromDate(toDo.dueDate!)
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
       self.completeView.hidden = true
        let radius = (self.indicatorImage?.frame.size.height)! / 2
        self.indicatorImage?.layer.cornerRadius = radius
        self.indicatorImage?.layer.masksToBounds = true
        
    }

    override func setSelected(selected: Bool, animated: Bool) {

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }

}
