//
//  Extensions.swift
//  Messenger
//
//  Created by Mohsen Abdollahi on 7/3/19.
//  Copyright © 2019 Mohsen Abdollahi. All rights reserved.
//

import UIKit

class RoundedBlueButton : UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 8
    }
}


class RoaundedUIView : UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
    }
}
