//
//  ChatViewController.swift
//  MainProject
//
//  Created by George Drag on 1/25/18.
//  Copyright © 2018 Red Foundry. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ChatViewController: UIViewController {
    
    var currentUser: User?
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    @IBAction func logoutFB() {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        self.dismiss(animated: true, completion: nil)
    }
}
