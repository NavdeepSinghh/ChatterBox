//
//  ChatLogController.swift
//  ChatterBox
//
//  Created by Sonar on 8/8/17.
//  Copyright © 2017 Navdeep. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController : UICollectionViewController {
    
    var user : LocalUser? {
        didSet{
            navigationItem.title = user?.name
        }
    }
    
    let textField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message"
        textField.backgroundColor = UIColor.white
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.white
        setupInputContainers()
    }
    
    func setupInputContainers(){
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        // OS 9 constraint anchors
        // x, y, w, h constraints
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton  = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sendButton)
        
        // x, y, w, h contraints on send button
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        containerView.addSubview(textField)
        
        // x, y, w, h constraints
        textField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant : 8).isActive = true
        textField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        textField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        textField.heightAnchor.constraint(equalTo:containerView.heightAnchor).isActive = true
        
        let separator = UIView()
        separator.backgroundColor = UIColor.black
        separator.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separator)
        
        // x, y, w, h constraints
        separator.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separator.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separator.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func handleSend(){
        let ref = Database.database().reference().child("messages")
        // to separate messages by unique IDs
        let childRef = ref.childByAutoId()
        let toID = user!.id!
        let fromID = Auth.auth().currentUser!.uid
        let timeStamp : Int = Int(NSDate().timeIntervalSince1970)
        let values = ["text": textField.text!, "toID": toID, "fromID" :fromID, "timeStamp": timeStamp] as [String : Any]
        childRef.updateChildValues(values)
    }
}
