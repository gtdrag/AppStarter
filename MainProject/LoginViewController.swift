//
//  SignupViewController.swift
//  MainProject
//
//  Created by George Drag on 1/15/18.
//  Copyright © 2018 Red Foundry. All rights reserved.
//

import UIKit
import FBSDKLoginKit

protocol loginViewControllerDelegate {
    func loginViewControllerDidPressButton(loginViewController: LoginViewController)
}

class LoginViewController: UIViewController {
    var delegate: loginViewControllerDelegate?
    
    @IBOutlet weak var showSignupButton: UIButton!
    
    @IBAction func buttonWasPressed(_ sender: UIButton) {
        self.delegate?.loginViewControllerDidPressButton(loginViewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
}

