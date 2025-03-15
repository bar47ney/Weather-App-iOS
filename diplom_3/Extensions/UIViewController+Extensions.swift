//
//  UIViewController+Extensions.swift
//  diplom_3
//
//  Created by Сергей Недведский on 10.03.25.
//
import UIKit

extension UIViewController {
    func showAlert(
        title: String = "Warning",
        message: String = "Message",
        type: UIAlertController.Style = UIAlertController.Style.alert,
        handlerOK: @escaping (UIAlertAction) -> Void = { _ in },
        cancelBtn: Bool = false,
        handlerCancel: @escaping (UIAlertAction) -> Void = { _ in }
    ) {

        let alert = UIAlertController(
            title: title, message: message,
            preferredStyle: type)

        let okAction = UIAlertAction(
            title: "Ok", style: .default, handler: handlerOK)
        alert.addAction(okAction)

        if cancelBtn {
            let cancelAction = UIAlertAction(
                title: "Settings", style: .cancel, handler: handlerCancel)
            alert.addAction(cancelAction)
        }

        present(alert, animated: true)
    }
}
