//
//  Extensions.swift
//  Repositories
//
//  Created by Roland Beke on 14/11/2017.
//  Copyright © 2017 Roland Beke. All rights reserved.
//

import UIKit

extension String {
    
    static func bindNilOrEmpty(_ text: Any?) -> String {
        
        switch text {
        case is String:
            
            guard let string = text as? String, !string.isEmpty else { return "-" }
            return string
        case is Int:
            
            guard let string = text as? Int else { return "-" }
            return String(string)
        default:
            
            return "-"
        }
    }
}
