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
        
        
        //Select Image for Profile
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleImagePicker))
        tap.numberOfTapsRequired = 1
        UserProfile.isUserInteractionEnabled = true
        UserProfile.addGestureRecognizer(tap)
        UserProfile.layer.cornerRadius = UserProfile.frame.width / 2
        
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
    
    @objc func handleImagePicker(){
        lunchImagePicker()
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
            
            //Upload userprofile Image to Database and retrive to use in chatVC
            
            //Make sure image is not Empty
            guard let image = self.UserProfile.image else { return }
            // Step 1 : Turn the image into Data
            guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
            // Step 2 : Create an Storage Image reference -> a location in firestorage for it to be stored.
            let fileName = NSUUID().uuidString
            let imageRef = Storage.storage().reference().child("UserProfileImage").child(fileName)
            // Step 3 : Set to the meta data
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            // Step 4 : Upload the data
            imageRef.putData(uploadData, metadata: metaData, completion: { (metaData, error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                    return
                }
                
                imageRef.downloadURL(completion: { (url, error) in
                    if let error = error {
                        debugPrint(error.localizedDescription)
                        return
                    }
                    
                    guard let url = url else { return }
                    print("successfuly upoad profile image in this is link :")
                    print(url)
                    
                    //Save usernname and userprofile Image to Database
                    let currentUser = Auth.auth().currentUser
                    guard let uid = currentUser?.uid else { return }
                    
                    let userValue = ["username" : username , "userProfileImage" : url.absoluteString]
                    let values = [uid : userValue ]
                    Database.database().reference().child("Users").updateChildValues(values, withCompletionBlock: { (Error , reference) in
                        if let error = Error {
                            print("Failed to save user info to database")
                            debugPrint(error.localizedDescription)
                            return
                        }
                        print("Save Username  in Database successfuly !")
                        self.activityIndicator.stopAnimating()
                        self.performSegue(withIdentifier: "ToChatVC", sender: self)
                        
                    })
                })
            })
        }
    }
}


extension RegisterVC : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    func lunchImagePicker(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let editingImage = info[.editedImage] as? UIImage else { return }
        UserProfile.contentMode = .scaleAspectFill
        UserProfile.image = editingImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
 
}
