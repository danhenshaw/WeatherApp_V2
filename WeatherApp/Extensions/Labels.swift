//
//  Fonts.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 16/1/19.
//  Copyright © 2019 Dan Henshaw. All rights reserved.
//

import UIKit

enum FontSize {
    case huge, large, medium, small, tiny, weatherIcon, moonIcon
}

enum FontColour {
    case white, black, blue, lightGray, darkGray
}

enum Font {
    case moon, weather, system
}

extension UILabel {
    
    func customFont(size: FontSize, colour: FontColour, alignment: NSTextAlignment, weight: UIFont.Weight, fontName: Font, multiplier: Double) {
        
        var fontSize = 0.0
        var fontNameString: String?
        
        switch colour {
        case .white : textColor = .white
        case .black : textColor = .black
        case .blue : textColor =  UIColor(rgb: GlobalVariables.sharedInstance.precipBlue, a: 0.5)
        case .lightGray : textColor = .lightGray
        case .darkGray : textColor = .darkGray
        }
        
        switch size {
        case .huge : fontSize = 45
        case .large : fontSize = 26
        case .medium : fontSize = 14
        case .small : fontSize = 12
        case .tiny : fontSize = 8
        case .weatherIcon : fontSize = 15
        case .moonIcon : fontSize = 16
        }
        
        switch fontName {
        case .moon : fontNameString = "Flaticon"
        case .weather : fontNameString = "Climacons-Font"
        case .system : fontNameString = nil
        }

        textAlignment = alignment
    
        if let fontNameString = fontNameString {
            font = UIFont(name: fontNameString, size: CGFloat(fontSize * multiplier))
        } else {
            font = UIFont.systemFont(ofSize: CGFloat(fontSize * multiplier), weight: weight)
        }
    }
    
    
}
