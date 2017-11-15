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
        case is Date:
            
            guard let string = text as? Date else { return "-" }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.locale = Locale(identifier: "en_US")
            
            return dateFormatter.string(from: string)
        default:
            
            return "-"
        }
    }
}

extension UIImageView {
    
    func downloadImage(from url: Any?) {
        
        if let pictureUrl = url as? String {
            
            guard let url = URL(string: pictureUrl) else { return }
            
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url)
                
                guard let imgData = data else { return }
                
                DispatchQueue.main.async {
                    self.image = UIImage(data: imgData)
                }
            }
        }
    }
}
