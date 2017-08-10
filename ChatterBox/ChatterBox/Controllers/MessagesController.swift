
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

    let cellID = "userCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image : #imageLiteral(resourceName: "new_message_icon"), style : .plain, target: self, action : #selector(handleNewMessage))
        checkIfUserLoggedIn()
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        observeMessages()
    }
    
    func handleNewMessage() {
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        let navController = UINavigationController(rootViewController : newMessageController)
        present(navController, animated: true, completion: nil)
    }
    
    var messages = [Message]()
    
    func observeMessages(){
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let message = Message()
                message.setValuesForKeys(dictionary)
                self.messages.append(message)
                // call table reload on the main queue
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UserCell
        cell.message = messages[indexPath.row]
        
        return cell
    }
    
    func checkIfUserLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            fetchuserAndSetupNavBar()
        }
    }
    
    func fetchuserAndSetupNavBar() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{                
                let user = LocalUser()
                user.setValuesForKeys(dictionary)
                self.setupNavBarWithUser(user : user)
            }
            
        }, withCancel: nil)
    }
    
    func setupNavBarWithUser(user : LocalUser){
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let currentUserprofileImageView = UIImageView()
        currentUserprofileImageView.translatesAutoresizingMaskIntoConstraints = false
        currentUserprofileImageView.contentMode = .scaleAspectFill
        currentUserprofileImageView.layer.cornerRadius = 20
        currentUserprofileImageView.clipsToBounds = true
        if let profileImageURL = user.profileImageUrl {
            currentUserprofileImageView.loadImageusingCacheWithURLString(urlString: profileImageURL)
        }
        
        containerView.addSubview(currentUserprofileImageView)
        // ios 9 constraints
        currentUserprofileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        currentUserprofileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        currentUserprofileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        currentUserprofileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        containerView.addSubview(nameLabel)
        
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Adding constraints top nameLabel
        nameLabel.leftAnchor.constraint(equalTo: currentUserprofileImageView.rightAnchor,constant : 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: currentUserprofileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: currentUserprofileImageView.heightAnchor).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
        
        //titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))
    }
    
    func showChatControllerFortUser(user : LocalUser) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func handleLogout(){
        do {
            try Auth.auth().signOut()
        }catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginController()
        loginController.messagesController = self
        present(loginController, animated: true, completion: nil)
    }
}

