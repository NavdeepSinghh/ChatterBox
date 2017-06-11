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
    
    lazy var loginOrSignUpSegmentedControl : UISegmentedControl = {
        let segControl = UISegmentedControl(items: ["Login", "Sign Up"])
        segControl.translatesAutoresizingMaskIntoConstraints = false
        segControl.tintColor = UIColor.white
        segControl.selectedSegmentIndex = 1
        segControl.addTarget(self, action: #selector(handleLoginOrSignUpChange), for: .valueChanged)
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
    
    lazy var loginOrSignUpButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 80, green: 101, blue: 161)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginOrSignUpButtonPressed), for: .touchUpInside)
        return button
    }()
    
    func handleSignUp() {
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
                    self.dismiss(animated: true, completion: nil)
                })
            }
        }
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
            self.dismiss(animated: true, completion: nil)
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
        setupProfileIcon()
        setupLoginOrSignupSegmentedControl()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var nameText : String?
    
    func handleLoginOrSignUpChange() {
        let title = loginOrSignUpSegmentedControl.titleForSegment(at: loginOrSignUpSegmentedControl.selectedSegmentIndex)
        loginOrSignUpButton.setTitle(title, for: .normal)
        
        // change height of the userInputGatherView
        userInputGatherViewHeightConstraint?.constant = loginOrSignUpSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        // change heigh of the name text field
        nameTextFieldHeightConstraint?.isActive = false
        nameTextFieldHeightConstraint = nameTextField.heightAnchor.constraint(equalTo: userInputGatherView.heightAnchor, multiplier: loginOrSignUpSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextField.placeholder = loginOrSignUpSegmentedControl.selectedSegmentIndex == 0 ? "" : "Name"
        
        // Maintaining text value in case the user switches from signup to login and vice versa
        if nameTextField.text != "" {
            nameText = nameTextField.text
        }
        
        nameTextField.text = loginOrSignUpSegmentedControl.selectedSegmentIndex == 0 ? "" : nameText
        nameTextFieldHeightConstraint?.isActive = true
        
        emailTextFieldHeightConstraint?.isActive = false
        emailTextFieldHeightConstraint = emailTextField.heightAnchor.constraint(equalTo: userInputGatherView.heightAnchor, multiplier: loginOrSignUpSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightConstraint?.isActive = true
        
        passwordTextFieldHeightConstraint?.isActive = false
        passwordTextFieldHeightConstraint = passwordTextField.heightAnchor.constraint(equalTo: userInputGatherView.heightAnchor, multiplier: loginOrSignUpSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightConstraint?.isActive = true
    }
    
    func setupLoginOrSignupSegmentedControl() {
        loginOrSignUpSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginOrSignUpSegmentedControl.bottomAnchor.constraint(equalTo: userInputGatherView.topAnchor, constant: -12).isActive = true
        loginOrSignUpSegmentedControl.widthAnchor.constraint(equalTo: userInputGatherView.widthAnchor).isActive = true
        loginOrSignUpSegmentedControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupProfileIcon(){
        profileIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileIcon.bottomAnchor.constraint(equalTo: loginOrSignUpSegmentedControl.topAnchor, constant: -12).isActive = true
        profileIcon.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileIcon.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    var userInputGatherViewHeightConstraint : NSLayoutConstraint?
    var nameTextFieldHeightConstraint : NSLayoutConstraint?
    var emailTextFieldHeightConstraint : NSLayoutConstraint?
    var passwordTextFieldHeightConstraint : NSLayoutConstraint?
    
    func setupViewToGatherUserCredentials(){
        userInputGatherView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userInputGatherView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        userInputGatherView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        userInputGatherViewHeightConstraint = userInputGatherView.heightAnchor.constraint(equalToConstant: 150)
        userInputGatherViewHeightConstraint?.isActive = true
        
        userInputGatherView.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: userInputGatherView.leftAnchor, constant : 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: userInputGatherView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: userInputGatherView.widthAnchor).isActive = true
        nameTextFieldHeightConstraint = nameTextField.heightAnchor.constraint(equalTo: userInputGatherView.heightAnchor, multiplier : 1/3)
        nameTextFieldHeightConstraint?.isActive = true
        
        userInputGatherView.addSubview(textFieldSeparator)
        textFieldSeparator.leftAnchor.constraint(equalTo: userInputGatherView.leftAnchor).isActive = true
        textFieldSeparator.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        textFieldSeparator.widthAnchor.constraint(equalTo: userInputGatherView.widthAnchor).isActive = true
        textFieldSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        userInputGatherView.addSubview(emailTextField)
        emailTextField.leftAnchor.constraint(equalTo: userInputGatherView.leftAnchor, constant : 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: userInputGatherView.widthAnchor).isActive = true
        emailTextFieldHeightConstraint =  emailTextField.heightAnchor.constraint(equalTo: userInputGatherView.heightAnchor, multiplier : 1/3)
        emailTextFieldHeightConstraint?.isActive = true
        
        userInputGatherView.addSubview(emailTextFieldSeparator)
        emailTextFieldSeparator.leftAnchor.constraint(equalTo: userInputGatherView.leftAnchor).isActive = true
        emailTextFieldSeparator.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailTextFieldSeparator.widthAnchor.constraint(equalTo: userInputGatherView.widthAnchor).isActive = true
        emailTextFieldSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        userInputGatherView.addSubview(passwordTextField)
        passwordTextField.leftAnchor.constraint(equalTo: userInputGatherView.leftAnchor, constant : 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: userInputGatherView.widthAnchor).isActive = true
        passwordTextFieldHeightConstraint = passwordTextField.heightAnchor.constraint(equalTo: userInputGatherView.heightAnchor, multiplier : 1/3)
        passwordTextFieldHeightConstraint?.isActive = true
        
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







































