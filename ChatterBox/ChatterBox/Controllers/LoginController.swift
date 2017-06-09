//
//  LoginController.swift
//  ChatterBox
//
//  Created by Navdeep  Singh on 6/6/17.
//  Copyright © 2017 Navdeep. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    // Creating view components 
    
    let userInputGatherView : UIView = {
        let viewToGatherinputs = UIView()
        viewToGatherinputs.backgroundColor = UIColor.white
        viewToGatherinputs.layer.cornerRadius = 5
        viewToGatherinputs.layer.masksToBounds = true
        viewToGatherinputs.translatesAutoresizingMaskIntoConstraints = false
        return viewToGatherinputs
    }()
    
    let profileIcon : UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "chatteroo")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let loginOrSignUpSegmentedControl : UISegmentedControl = {
        let segControl = UISegmentedControl(items: ["Login", "Sign Up"])
        segControl.translatesAutoresizingMaskIntoConstraints = false
        return segControl
    }()
    
    let nameTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let textFieldSeparator : UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        return separatorView
    }()
    
    let emailTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let emailTextFieldSeparator : UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        return separatorView
    }()
    
    let passwordTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordTextFieldSeparator : UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        return separatorView
    }()
    
    let loginOrSignUpButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 80, green: 101, blue: 161)
        button.setTitle("LOGIN", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(loginOrSignUpButtonPressed), for: .touchUpInside)
        return button
    }()
    
    func loginOrSignUpButtonPressed() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let name = nameTextField.text else {
                print("Invalid!")
                return
        }
        
        FireBaseClient().createUserWithEmail(email: email, password: password){user , error in
            if let user = user {
                let referenceToDatabase = Database.database().reference(fromURL:"https://chatterbox-c4236.firebaseio.com/")
                let userReference = referenceToDatabase.child("users").child(user.uid)
                let values = ["name" : name, "email": email]
                userReference.updateChildValues(values, withCompletionBlock: { (err, reference) in
                    if err != nil {
                        print(err!)
                        return
                    }
                    print("Saved user in FB DB")
                })
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 61, green: 91, blue: 151)
        
        view.addSubview(userInputGatherView)
        view.addSubview(loginOrSignUpButton)
        view.addSubview(profileIcon)
        view.addSubview(loginOrSignUpSegmentedControl)
        setupViewToGatherUserCredentials()
        setupLoginOrSignUpButton()
        setupChatterAppIcon()
        setupLoginOrSignupSegmentedControl()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupLoginOrSignupSegmentedControl() {
        loginOrSignUpSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginOrSignUpSegmentedControl.bottomAnchor.constraint(equalTo: userInputGatherView.topAnchor, constant: -12).isActive = true
        loginOrSignUpSegmentedControl.widthAnchor.constraint(equalTo: userInputGatherView.widthAnchor).isActive = true
        loginOrSignUpSegmentedControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupChatterAppIcon(){
        profileIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileIcon.bottomAnchor.constraint(equalTo: userInputGatherView.topAnchor, constant: -12).isActive = true
        profileIcon.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileIcon.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
    }
    
    func setupViewToGatherUserCredentials(){
        userInputGatherView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userInputGatherView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        userInputGatherView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        userInputGatherView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        userInputGatherView.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: userInputGatherView.leftAnchor, constant : 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: userInputGatherView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: userInputGatherView.widthAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: userInputGatherView.heightAnchor, multiplier : 1/3).isActive = true
        
        userInputGatherView.addSubview(textFieldSeparator)
        textFieldSeparator.leftAnchor.constraint(equalTo: userInputGatherView.leftAnchor).isActive = true
        textFieldSeparator.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        textFieldSeparator.widthAnchor.constraint(equalTo: userInputGatherView.widthAnchor).isActive = true
        textFieldSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        userInputGatherView.addSubview(emailTextField)
        emailTextField.leftAnchor.constraint(equalTo: userInputGatherView.leftAnchor, constant : 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: userInputGatherView.widthAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: userInputGatherView.heightAnchor, multiplier : 1/3).isActive = true
        
        userInputGatherView.addSubview(emailTextFieldSeparator)
        emailTextFieldSeparator.leftAnchor.constraint(equalTo: userInputGatherView.leftAnchor).isActive = true
        emailTextFieldSeparator.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailTextFieldSeparator.widthAnchor.constraint(equalTo: userInputGatherView.widthAnchor).isActive = true
        emailTextFieldSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        userInputGatherView.addSubview(passwordTextField)
        passwordTextField.leftAnchor.constraint(equalTo: userInputGatherView.leftAnchor, constant : 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: userInputGatherView.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: userInputGatherView.heightAnchor, multiplier : 1/3).isActive = true
        
        userInputGatherView.addSubview(passwordTextFieldSeparator)
        passwordTextFieldSeparator.leftAnchor.constraint(equalTo: userInputGatherView.leftAnchor).isActive = true
        passwordTextFieldSeparator.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        passwordTextFieldSeparator.widthAnchor.constraint(equalTo: userInputGatherView.widthAnchor).isActive = true
        passwordTextFieldSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    func setupLoginOrSignUpButton(){
        loginOrSignUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginOrSignUpButton.topAnchor.constraint(equalTo: userInputGatherView.bottomAnchor, constant: 12).isActive = true
        loginOrSignUpButton.widthAnchor.constraint(equalTo:view.widthAnchor, constant : -24).isActive = true
        loginOrSignUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}







































