//
//  ViewController.swift
//  ChatterBox
//
//  Created by Navdeep  Singh on 6/3/17.
//  Copyright © 2017 Navdeep. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image : #imageLiteral(resourceName: "new_message_icon"), style : .plain, target: self, action : #selector(handleNewMessage))
        checkIfUserLoggedIn()
        }
    
    func handleNewMessage() {
        let newMessageController = NewMessageController()
        let navController = UINavigationController(rootViewController : newMessageController)
        present(navController, animated: true, completion: nil)
    }
    
    func checkIfUserLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    self.navigationItem.title = dictionary["name"] as? String
                }
                
            }, withCancel: nil)
        }
    }
    
    func handleLogout(){
        do {
            try Auth.auth().signOut()
        }catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
}

