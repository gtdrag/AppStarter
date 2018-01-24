//
//  SignupViewController.swift
//  MainProject
//
//  Created by George Drag on 1/15/18.
//  Copyright © 2018 Red Foundry. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import FancyTextField



protocol signupViewControllerDelegate {
    func signupViewControllerDidPressButton(signupViewController: SignupViewController)
}

class SignupViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate, FancyTextFieldDelegate {
    var delegate: signupViewControllerDelegate?
    var currentUser: User?
    
    
    @IBOutlet weak var googleSignupButton: UIView!
    @IBOutlet weak var faceBookSignupButton: UIButton!
    @IBOutlet weak var showLoginButton: UIButton!
    
    @IBAction func buttonWasPressed(_ sender: UIButton) {
        self.delegate?.signupViewControllerDidPressButton(signupViewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFacebookButton()
        setupGoogleButton()
        
        if (FBSDKAccessToken.current()) != nil {
            fetchProfile()
        }
        
    }
    
    fileprivate func setupFacebookButton(){
        let loginButton = FBSDKLoginButton()
        faceBookSignupButton.addSubview(loginButton)
        loginButton.bindFrameToSuperviewBounds()
        loginButton.delegate = self
    }
    
    fileprivate func setupGoogleButton(){
        let googleButton = GIDSignInButton()
        googleButton.style = .wide
        googleSignupButton.addSubview(googleButton)
        googleButton.bindFrameToSuperviewBounds()
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // TODO: customize button to match design better
    }
    
    func fetchProfile() {
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "email, first_name, last_name, picture.type(large)"])
            .start(completionHandler:  {
                (connection, result, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let result = result as? NSDictionary {
                    if let first_name = result["first_name"] as? String,
                        let last_name = result["last_name"] as? String,
                        let photo = result["picture"] as? UIImage,
                        let email = result["email"] as? String {
                        self.currentUser = User(firstname: first_name, lastname: last_name, email: email, photo: photo)
                        self.gotoProfile()
                    }
                }
            })
    }
    
    func gotoProfile() {
        // show profile page
        
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
