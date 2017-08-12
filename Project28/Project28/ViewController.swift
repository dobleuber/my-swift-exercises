//
//  ViewController.swift
//  Project28
//
//  Created by Wbert Castro on 12/08/17.
//  Copyright © 2017 Wbert Castro. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    @IBOutlet weak var secret: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        
        title = "Nothing to see here"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] (success, authenticationError) in
                DispatchQueue.main.async {
                    if success {
                        self.unlockSecretMessage()
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "Your fingerprint could not verified; please try again", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Touch Id not available", message: "your device is not configured for Touch Id", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func unlockSecretMessage() {
        secret.isHidden = false
        title = "Secret stuff!"
        
        if let text = KeychainWrapper.standardKeychainAccess().string(forKey: "SecretMessage") {
            secret.text = text
        }
    }
    
    func saveSecretMessage() {
        if !secret.isHidden {
            _ = KeychainWrapper.standardKeychainAccess().setString(secret.text, forKey: "SecretMessage")
            secret.resignFirstResponder()
            secret.isHidden = true
            title = "Nothing to see here"
        }
    }

    func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            let top = secret.contentInset.top
            secret.contentInset = UIEdgeInsets.zero
            secret.contentInset.top = top
            
        } else {
            secret.contentInset = UIEdgeInsets(top: secret.contentInset.top, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
}

