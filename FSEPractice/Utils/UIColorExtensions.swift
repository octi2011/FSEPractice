//
//  UIColorExtensions.swift
//  FSEPractice
//
//  Created by Duminica Octavian on 16/06/2018.
//  Copyright © 2018 Duminica Octavian. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
    }
    
    static var appBlue: UIColor {
        get {
            return UIColor(r: 22, g: 149, b: 163)
        }
    }
    
    static var appBlack: UIColor {
        get {
            return UIColor(r: 30, g: 30, b: 30)
        }
    }
    
    static var appGray: UIColor {
        get {
            return UIColor(white: 30.0 / 255.0, alpha: 1.0)
        }
    }
}
