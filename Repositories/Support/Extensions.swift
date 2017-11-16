//
//  Extensions.swift
//  Repositories
//
//  Created by Roland Beke on 14/11/2017.
//  Copyright © 2017 Roland Beke. All rights reserved.
//

import UIKit
import Swinject
import SwinjectStoryboard
import Sync

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

extension UIAlertController {

    static func simpleAlert(text: String, completion: (() -> Void)? = nil) -> UIAlertController {

        let alertController = UIAlertController(title: "Alert", message: text, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (_) in

            if let completion = completion {
                completion()
            }
        }))

        return alertController
    }
}

extension SwinjectStoryboard {

    @objc class func setup() {

        defaultContainer.storyboardInitCompleted(ReposViewController.self) { r, c in
            c.dataStack = r.resolve(DataStack.self)
        }
        defaultContainer.register(DataStack.self) { _ in
            DataStack(modelName: "Model")
        }

        Container.loggingFunction = nil
    }
}
