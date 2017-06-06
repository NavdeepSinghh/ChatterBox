//
//  LoginController.swift
//  ChatterBox
//
//  Created by Navdeep  Singh on 6/6/17.
//  Copyright © 2017 Navdeep. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    // Creating view components 
    
    let userInputGatherView : UIView! = {
    let viewToGatherinputs = UIView()
    viewToGatherinputs.backgroundColor = UIColor.white
    viewToGatherinputs.translatesAutoresizingMaskIntoConstraints = false
    return viewToGatherinputs
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 61, green: 91, blue: 151)
        setupViewToGatherUserCredentials()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupViewToGatherUserCredentials(){
      view.addSubview(userInputGatherView)
      userInputGatherView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
      userInputGatherView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
      userInputGatherView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
      userInputGatherView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
}
