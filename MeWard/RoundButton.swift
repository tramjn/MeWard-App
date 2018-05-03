//
//  RoundButton.swift
//  MeWard
//
//  Created by Tram Nguyen on 4/28/18.
//  Copyright © 2018 Tram Nguyen. All rights reserved.
//

import UIKit

// make sure button height and width are the same size to make a circular button
@IBDesignable class RoundButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.masksToBounds = true
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
    }

}
