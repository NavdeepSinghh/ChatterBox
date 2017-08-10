//
//  LoginController+handlers.swift
//  ChatterBox
//
//  Created by Navdeep  Singh on 6/12/17.
//  Copyright © 2017 Navdeep. All rights reserved.
//

import UIKit
import Firebase

extension LoginController {
    
    func chooseProfileIcon() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func handleSignUp() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let name = nameTextField.text else {
                print("Invalid!")
                return
        }
        
        FireBaseClient().createUserWithEmail(email: email, password: password){user , error in
            if let user = user {
                // Storing profile image in Firebase
                
                if let image = self.profileIcon.image{
                    let imageName = UUID().uuidString
                    let storageReference = Storage.storage().reference().child("profile_images").child("\(imageName)")
                    // Compressing the images before uploading the images
                    if let uploadProfileImage = UIImageJPEGRepresentation(image, 0.1){
                        storageReference.putData(uploadProfileImage, metadata: nil, completion: { (metaData, error) in
                            if let error = error {
                                print(error)
                                return
                            }
                            
                            if let profileImageURL = metaData?.downloadURL()?.absoluteString{
                                let values = ["name" : name, "email": email, "profileImageUrl" : profileImageURL]
                                self.registerUserInFirebaseDB(uid: user.uid, values: values as [String : AnyObject])
                            }
                            
                        })
                    }
                }
            }
        }
    }
    
    private func registerUserInFirebaseDB(uid : String, values : [String: AnyObject]) {
        let referenceToDatabase = Database.database().reference()
        let userReference = referenceToDatabase.child("users").child(uid)
        userReference.updateChildValues(values, withCompletionBlock: { (err, reference) in
            if err != nil {
                print(err!)
                return
            }
            
            let user = LocalUser()
            user.setValuesForKeys(values)
            self.messagesController?.setupNavBarWithUser(user: user)
            
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func loginOrSignUpButtonPressed () {
        if loginOrSignUpSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        }else {
            handleSignUp()
        }
    }
    
    func handleLogin() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {
                print("Invalid!")
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error)
                return
            }
            self.messagesController?.fetchuserAndSetupNavBar()
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension LoginController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImage : UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImage = editedImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImage = originalImage
        }
        
        if let selectedImage = selectedImage {
            DispatchQueue.main.async {
                self.profileIcon.image = selectedImage
            }
        }
        dismiss(animated: true, completion: nil)
    }
}
