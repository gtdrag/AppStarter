//
//  SignupViewController.swift
//  MainProject
//
//  Created by George Drag on 1/15/18.
//  Copyright © 2018 Red Foundry. All rights reserved.
//

import UIKit

protocol signupViewControllerDelegate {
    func signupViewControllerDidPressButton(signupViewController: SignupViewController)
}

class SignupViewController: UIViewController {
    var delegate: signupViewControllerDelegate?
    
    @IBOutlet weak var showLoginButton: UIButton!
    
    @IBAction func buttonWasPressed(_ sender: UIButton) {
        self.delegate?.signupViewControllerDidPressButton(signupViewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
