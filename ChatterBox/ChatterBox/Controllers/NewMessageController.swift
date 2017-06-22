//
//  NewMessageController.swift
//  ChatterBox
//
//  Created by Navdeep  Singh on 6/11/17.
//  Copyright © 2017 Navdeep. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {

    let cellID = "cellID"
    var users = [LocalUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelCalled))
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        fetchUser()
    }
    
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                // not the right place to initialize user
                let user = LocalUser()
                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String
                user.profileImageUrl = dictionary["profileImageUrl"] as? String
                self.users.append(user)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        })
    }
    
    func cancelCalled() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        if let imageUrl = user.profileImageUrl {
            // Calling the method from ViewHelper extension now
            cell.profileImageView.loadImageusingCacheWithURLString(urlString: imageUrl)
        }
        return cell
    }
}
