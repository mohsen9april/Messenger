//
//  RegisterVC.swift
//  Messenger
//
//  Created by Mohsen Abdollahi on 7/1/19.
//  Copyright © 2019 Mohsen Abdollahi. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    @IBOutlet weak var loginBtn: RoundedBlueButton!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var activitiIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Login"
        
        loginBtn.isEnabled = false
        loginBtn.backgroundColor = UIColor(red: 64/255, green: 97/255, blue: 147/255, alpha: 0.5)
        
        emailTxt.addTarget(self, action: #selector(handleLoginBtn), for: UIControl.Event.editingChanged)
        passwordTxt.addTarget(self, action: #selector(handleLoginBtn), for: UIControl.Event.editingChanged)

    }
    
    
    @objc func handleLoginBtn(){
        guard let email = emailTxt.text else { return }
        guard let password = passwordTxt.text else { return }
        if !email.isEmpty && !password.isEmpty {
            loginBtn.isEnabled = true
            loginBtn.backgroundColor = UIColor(red: 64/255, green: 97/255, blue: 147/255, alpha: 1)
        } else {
            loginBtn.isEnabled = false
            loginBtn.backgroundColor = UIColor(red: 64/255, green: 97/255, blue: 147/255, alpha: 0.5)
        }
        
    }

    @IBAction func loginClicked(_ sender: Any) {
        activitiIndicator.startAnimating()
        guard let email = emailTxt.text, !email.isEmpty else { return }
        guard let password = passwordTxt.text, !password.isEmpty else { return }
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            print("Login Successfuly !")
            self.activitiIndicator.stopAnimating()
            self.performSegue(withIdentifier: "ToChatVC", sender: self)
        }
    }
}
