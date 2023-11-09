//
//  AlertPresenter.swift
//  Moments
//
//  Created by Alexey Ponomarev on 19.10.2023.
//

import UIKit

final class AlertPresenter {
    weak var view: UIViewController?
    
    init(view: UIViewController? = nil) {
        self.view = view
    }

    func show(_ data: AlertModel) {
        let alert = UIAlertController(
            title: data.title,
            message: data.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: data.buttonText, style: .default) { _ in
            if let completion = data.completion {
                completion()
            }
            
        }
        
        if let secondButtonText = data.secondButtonText {
            let secondAction = UIAlertAction(title: secondButtonText, style: .default) { _ in
                data.secondCompletion()
            }

            alert.addAction(secondAction)
        }
        
        
        alert.view.accessibilityIdentifier = "Alert"
    
        alert.addAction(action)

        view?.present(alert, animated: true, completion: nil)
    }
}
