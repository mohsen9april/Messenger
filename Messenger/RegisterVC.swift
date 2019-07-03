//
//  ViewController.swift
//  Messenger
//
//  Created by Mohsen Abdollahi on 7/1/19.
//  Copyright © 2019 Mohsen Abdollahi. All rights reserved.
//

import UIKit
import Firebase

class RegisterVC: UIViewController {
    
    @IBOutlet weak var UserProfile: UIImageView!
    @IBOutlet weak var passCheckImage: UIImageView!
    @IBOutlet weak var confirmPassCheckImage: UIImageView!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTtx: UITextField!
    @IBOutlet weak var confirmPassTxt: UITextField!
    @IBOutlet weak var registerBtn: RoundedBlueButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Register"
        
        passCheckImage.isHidden = true
        confirmPassCheckImage.isHidden = true
        registerBtn.isEnabled = false
        registerBtn.backgroundColor = UIColor.init(red: 255/255, green: 38/255, blue: 0/255, alpha: 0.5)
        
        passwordTtx.addTarget(self, action: #selector(textFieldDidChang) , for: UIControl.Event.editingChanged)
        confirmPassTxt.addTarget(self, action: #selector(textFieldDidChang), for: UIControl.Event.editingChanged)
        
        userNameTxt.addTarget(self, action: #selector(handleRegisterBtn) , for: UIControl.Event.editingChanged)
        emailTxt.addTarget(self, action: #selector(handleRegisterBtn), for: UIControl.Event.editingChanged)
        passwordTtx.addTarget(self, action: #selector(handleRegisterBtn) , for: UIControl.Event.editingChanged)
        confirmPassTxt.addTarget(self, action: #selector(handleRegisterBtn), for: UIControl.Event.editingChanged)
    }
    
    @objc func handleRegisterBtn(){
        guard let username = userNameTxt.text  else { return }
        guard let email = emailTxt.text else { return }
        guard let password = passwordTtx.text else { return }
        guard let confirmPass = confirmPassTxt.text  else { return }
        
        if !username.isEmpty && !email.isEmpty && !password.isEmpty && !confirmPass.isEmpty {
            registerBtn.isEnabled = true
            registerBtn.backgroundColor = UIColor.init(red: 255/255, green: 38/255, blue: 0/255, alpha: 1)
        } else {
            registerBtn.isEnabled = false
            registerBtn.backgroundColor = UIColor.init(red: 255/255, green: 38/255, blue: 0/255, alpha: 0.5)
        }
    }
    
    @objc func textFieldDidChang( _ inputTextFiled : UITextField){
        guard let passText = passwordTtx.text else { return }
        if inputTextFiled == confirmPassTxt {
            passCheckImage.isHidden = false
            confirmPassCheckImage.isHidden = false
        } else {
            if passText.isEmpty {
                passCheckImage.isHidden = true
                confirmPassCheckImage.isHidden = true
                confirmPassTxt.text = ""
            }
        }
        if passwordTtx.text == confirmPassTxt.text {
            passCheckImage.image = UIImage(named: "green_check")
            confirmPassCheckImage.image = UIImage(named: "green_check")
        } else {
            passCheckImage.image = UIImage(named: "red_check")
            confirmPassCheckImage.image = UIImage(named: "red_check")
        }
    }
    
    @IBAction func registerClicked(_ sender: Any) {
        activityIndicator.startAnimating()
        guard let username = userNameTxt.text , !username.isEmpty else { return }
        guard let email = emailTxt.text , !email.isEmpty else { return }
        guard let password = passwordTtx.text , !password.isEmpty else { return }
        guard let confirmPassword = confirmPassTxt.text, !confirmPassword.isEmpty else { return }
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            print("Register Successfuly !")
            self.activityIndicator.stopAnimating()
            self.performSegue(withIdentifier: "ToChatVC", sender: self)
        }
    }
}
