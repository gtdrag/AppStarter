//
//  SignupViewController.swift
//  MainProject
//
//  Created by George Drag on 1/15/18.
//  Copyright © 2018 Red Foundry. All rights reserved.
//

import UIKit
import FBSDKLoginKit

protocol signupViewControllerDelegate {
    func signupViewControllerDidPressButton(signupViewController: SignupViewController)
}

class SignupViewController: UIViewController, FBSDKLoginButtonDelegate {
    var delegate: signupViewControllerDelegate?
    
    @IBOutlet weak var faceBookSignupButton: UIButton!
    @IBOutlet weak var showLoginButton: UIButton!
    
    @IBAction func buttonWasPressed(_ sender: UIButton) {
        self.delegate?.signupViewControllerDidPressButton(signupViewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = FBSDKLoginButton()
        faceBookSignupButton.addSubview(loginButton)
        loginButton.bindFrameToSuperviewBounds()
        loginButton.delegate = self
        
        if let token = FBSDKAccessToken.current() {
            fetchProfile()
        }
        
    }
    
    func fetchProfile() {
        
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "email, first_name, last_name, id, gender, picture.type(large)"])
            .start(completionHandler:  {
                (connection, result, error) in
                if error != nil {
                    print(error)
                    return
                }
                if let result = result as? NSDictionary {
                    let email = result["email"] as? String
                    let user_name = result["first_name"] as? String
                    let user_gender = result["gender"] as? String
                    let user_id_fb = result["id"]  as? String
                    
                     print(user_name!)
                }
    
            })
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("logged out of FB")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        print("success logging into FB")
    }
}
