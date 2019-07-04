//
//  TableViewCell.swift
//  Messenger
//
//  Created by Mohsen Abdollahi on 7/1/19.
//  Copyright © 2019 Mohsen Abdollahi. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var senderUsername: UILabel!
    @IBOutlet weak var messageBackground: UIView!
    @IBOutlet weak var messageBody: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
