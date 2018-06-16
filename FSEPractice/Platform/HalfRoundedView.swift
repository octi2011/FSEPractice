//
//  HalfRoundedView.swift
//  Festival-App
//
//  Created by Duminica Octavian on 24/02/2018.
//  Copyright © 2018 Duminica Octavian. All rights reserved.
//

import UIKit
class HalfRoundedView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 10.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override func awakeFromNib() {
        self.setUpView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setUpView()
    }
    
    func setUpView() {
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
}

