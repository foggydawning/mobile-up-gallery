//
//  VCExtension.swift
//  mobile-up-gallery
//
//  Created by Илья Чуб on 30.03.2022.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, action: @escaping () -> Void ) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"),
                                          style: .default, handler: { _ in
                action()
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
