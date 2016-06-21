//
//  SortCell.swift
//  ToDo
//
//  Created by 王荣荣 on 6/21/16.
//  Copyright © 2016 王荣荣. All rights reserved.
//

import UIKit

class SortCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let X:CGFloat = 20
        let H:CGFloat = 1
        let Y = CGRectGetMaxY(self.contentView.frame) - H
        let W = self.contentView.frame.size.width - X
        let seperator = UIView(frame: CGRectMake(X, Y, W, H))
        seperator.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.2)
        self.addSubview(seperator)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
