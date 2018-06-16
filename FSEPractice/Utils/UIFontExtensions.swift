//
//  UIFontExtensions.swift
//  FSEPractice
//
//  Created by Duminica Octavian on 16/06/2018.
//  Copyright © 2018 Duminica Octavian. All rights reserved.
//

import UIKit

extension UIFont {
    static var OpenSansRegularSmall: UIFont? {
        get {
            return UIFont(name: "OpenSans", size: 11.0)
        }
    }
    
    static var OpenSansRegularBig: UIFont? {
        get {
            return UIFont(name: "OpenSans", size: 18.0)
        }
    }
    
    static var OpenSansSemiboldSmall: UIFont? {
        get {
            return UIFont(name: "OpenSans-Semibold", size: 11.0)
        }
    }
    
    static var OpenSansSemiboldMedium: UIFont? {
        get {
            return UIFont(name: "OpenSans-Semibold", size: 15.0)
        }
    }
    
    static var OpenSansSemiboldBig: UIFont? {
        get {
            return UIFont(name: "OpenSans-Semibold", size: 18.0)
        }
    }
}
