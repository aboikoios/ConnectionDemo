//
//  ViewController.swift
//  ConnectionDemo
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var message: UILabel!
    
    @IBAction func signIn(_ sender: Any) {
        let api = APISignIn(phone: "phone number", pin: "pin code")
        api.connect {
            if api.isSuccessfull {
                self.message.text = "token: \(api.token!)"
            } else {
                self.message.text = "error: \(api.statusDescription!)"
            }
        }
    }
    
}

