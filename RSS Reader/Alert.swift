//
//  Alert.swift
//  RSS Reader
//
//  Created by Dmitry Kulakov on 05.03.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

import UIKit

typealias RSSSourceCreateHandler = (String) -> Void

final class Alert {
    
    static func addRSSAlert(createHandler: @escaping RSSSourceCreateHandler) -> UIAlertController {
        
        let alert = UIAlertController(title: "Add New RSS", message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Enter RSS URL"
        }
        let confirmAction = UIAlertAction(title: "OK", style: .default) { action in
            if let text = alert.textFields?.first?.text {
                if !(text.isEmpty) {
                    print("Creating")
                    createHandler(text)
                }
            }
        }
        alert.addAction(confirmAction)
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { action in
            print("Canceled")
        }
        alert.addAction(cancelAction)
        return alert
    }
    
    static func errorAlert(title: String) -> UIAlertController {
        
        let alert = UIAlertController(title: "Error", message: title, preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: "OK", style: .default) { action in

        }
        alert.addAction(confirmAction)

        return alert
    }
    
}
