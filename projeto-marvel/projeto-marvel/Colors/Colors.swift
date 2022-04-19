//
//  Colors.swift
//  projeto-marvel
//
//  Created by c94292a on 22/11/21.
//

import UIKit

enum Colors {
    
    case black
    case red
    
    var uicolor : UIColor {
        switch self {
        case .black:
            return UIColor.init(red: 32/255, green: 32/255, blue: 32/255, alpha: 1.0)
        case .red:
            return UIColor.init(red: 102/255, green: 0/255, blue: 0/255, alpha: 1.0)
        }
    }
}
