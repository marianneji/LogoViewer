//
//  ViewController.swift
//  LogoViewer
//
//  Created by Ambroise COLLON on 24/04/2018.
//  Copyright © 2018 OpenClassrooms. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    fileprivate func toggleActivityIndicator(shown: Bool) {
        searchButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }

    @IBAction func didTapSearchButton() {
        searchLogo(domain: textField.text)
    }

    func searchLogo(domain: String?) {
        // TODO: Implement search
        guard let domain = domain, domain.contains(".") else {
            presentAlert("Enter a valid domain name")
            return
        }
        toggleActivityIndicator(shown: true)
        DomainService.shared.getLogo(domain: domain) { (success, logo) in
            self.toggleActivityIndicator(shown: false)
            if success, let logo = logo {
                self.updateLogo(logo: logo)
            } else {
                self.presentAlert("The domain name you're looking for doesn't exist")
            }
        }
    }
    
    private func updateLogo(logo: Logo) {
        imageView.image = UIImage(data: logo.imageData)
    }

    private func presentAlert(_ message: String) {
        let alertVC = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alertVC, animated: true)
    }
}


extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchLogo(domain: textField.text)
        return true
    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
}
