//
//  ChatVC.swift
//  Messenger
//
//  Created by Mohsen Abdollahi on 7/1/19.
//  Copyright © 2019 Mohsen Abdollahi. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class ChatVC: UIViewController, UITableViewDelegate , UITableViewDataSource, UITextFieldDelegate {
    
   //let MessageArray = ["FirstMassage", "SecondMassage","ThirdMassageThirdMassageThirdMassageThirdMassageThirdMassageThirdMassageThirdMassageThirdMassageThirdMassageThirdMassageThirdMassageThirdMassageThirdMassageThirdMassageThirdMassage"]

    var messageArray : [Message] = [Message]()
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageSendButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        messageTextField.delegate = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)

        messageTableView.separatorStyle = .none
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
    
        configureTableview()
        retriveMessages()
        
        //Set a Logout BarButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handlelogout))
    }
    @objc func handlelogout(){

        do {
            try Auth.auth().signOut()
            print("Logout !")
            navigationController?.popToRootViewController(animated: true)
        } catch  {
            print("there is a problem !")
        }
    }
    
    @objc func tableViewTapped(){
        messageTextField.endEditing(true)
    }
    
    func retriveMessages() {
        let MessageDB = Database.database().reference().child("Messages")
        MessageDB.observe(.childAdded) { (snapshot) in
            let snapshot = snapshot.value as! Dictionary<String,String>
            let text = snapshot["MessageBody"]!
            let sender = snapshot["Sender"]!
            
            let message = Message()
            message.sender = sender
            message.messageBody = text
            
            self.messageArray.append(message)
            self.configureTableview()
            self.messageTableView.reloadData()
            
            

        }
    }

    @IBAction func messageSendButton(_ sender: Any) {
        messageTextField.endEditing(true )
        
        messageTextField.isEnabled = false
        messageSendButton.isEnabled = false
        
        let messageDB = Database.database().reference().child("Messages")
        let sender = Auth.auth().currentUser?.email
        guard let messageBody = messageTextField.text else { return }
        let messageDictionary = ["Sender": sender,"MessageBody" : messageBody ]
        messageDB.childByAutoId().setValue(messageDictionary) { (Error, reference) in
            if let error = Error {
                debugPrint(error.localizedDescription)
                return
            }
            print("Messages Save Successfuly !")
            self.messageTextField.isEnabled = true
            self.messageSendButton.isEnabled = true
            self.messageTextField.text = ""
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! TableViewCell
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg.png")
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email {
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
        } else {
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
        }
        
        return cell
    }
    
    func configureTableview(){
//        messageTableView.rowHeight = UITableView.automaticDimension
//        messageTableView.estimatedRowHeight = 120.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        messageTableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 328
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 5
            self.view.layoutIfNeeded()
        }
    }
}
