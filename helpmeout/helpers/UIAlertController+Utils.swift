//
//  UIAlertController+Utils.swift
//

import Foundation
import UIKit

extension UIAlertController {
    static func showNoAction(on viewController: UIViewController, title: String?, message: String?, actionTitle: String? = "OK" ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: actionTitle, style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func showConfirm(on viewController: UIViewController, title: String?, message: String?, actionTitle: String? = "OK", actionStyle: UIAlertActionStyle = .default, cancelActionTitle: String? = NSLocalizedString("Cancel", comment: ""), action: @escaping () -> Void ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: actionStyle, handler: { _ in
            action()
        }))
        alert.addAction(UIAlertAction(title: cancelActionTitle, style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func showWithTextField(on viewController: UIViewController, title: String?, message: String?, actionTitle: String? = "OK", cancelActionTitle: String? = NSLocalizedString("Cancel", comment: ""), placeHolderText: String? = nil, action: @escaping (String?) -> Void ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { [unowned alert] _ in
            let textField = alert.textFields![0] as UITextField
            action(textField.text?.trim)
        }))
        alert.addAction(UIAlertAction(title: cancelActionTitle, style: .default, handler: nil))
        alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = placeHolderText
        })
        viewController.present(alert, animated: true, completion: nil)
    }
    
}
