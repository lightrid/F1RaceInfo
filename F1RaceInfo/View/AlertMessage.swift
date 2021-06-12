//
//  AlertMessage.swift
//  F1RaceInfo
//
//  Created by Mykhailo Kviatkovskyi on 12.06.2021.
//

import UIKit

struct AlertMessage {
    static func showAlert(title: String, message: String, controller: UIViewController?) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            if let controller = controller {
                controller.present(alertVC, animated: true)
            }
//            else {
//                let viewController = UIApplication.shared.windows.first!.rootViewController!
//                viewController.present(alertVC, animated: true)
//            }
        }
    }
}
