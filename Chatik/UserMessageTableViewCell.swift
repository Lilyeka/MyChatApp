//
//  UserMessageTableViewCell.swift
//  Chatik
//
//  Created by Лилия Левина on 13.11.2020.
//  Copyright © 2020 Лилия Левина. All rights reserved.
//

import UIKit

class UserMessageTableViewCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!
    
    override func layoutSubviews() {
        self.messageLabel.backgroundColor = .green
    }
}
