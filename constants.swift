//
//  constants.swift
//  IdealGasLawApp
//
//  Created by Maliha Islam on 2017-05-17.
//  Copyright © 2017 Maliha Islam. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

let screenSize = UIScreen.main.bounds
let iphone7plusW: CGFloat = 414
let iphone7plusH: CGFloat = 736
let screenWidth = UIScreen.main.bounds.width
var screenHeight = UIScreen.main.bounds.height


extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}


struct GlobalConstants {
    //  Colour constants
    
    static let darkpurple: UIColor = UIColor(hex:"272838")
    static let yellow: UIColor = UIColor(hex:"f3de8a")
    static let lightpurple: UIColor = UIColor(hex:"7e7f9a")
    static let offwhite: UIColor = UIColor(hex:"f9f8f8")
    static let pink: UIColor = UIColor(hex:"eb9486")
    static let lightpink: UIColor = UIColor(hex:"FFAEA0")
    
    static let cornerR: CGFloat = 2*(screenWidth/iphone7plusW)
    static let borderW: CGFloat = 1*(screenWidth/iphone7plusW)
    static let isFree = true
}
