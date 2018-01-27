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
import SendBirdSDK


protocol signupViewControllerDelegate {
    func signupViewControllerDidPressButton(signupViewController: SignupViewController)
    func signupViewControllerGotoChat(user:User)
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
            fetchUserProfile()
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
    
    func fetchUserProfile()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, email, first_name, last_name, picture.width(480).height(480)"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if (error == nil){
                guard let data = result as? [String:Any] else { return }
                let id = data["id"] as! String
                let firstName = data["first_name"] as! String
                let lastName = data["last_name"] as! String
                let email = data["email"] as! String
                let profilePictureObj = data["picture"] as! NSDictionary
                let picData = profilePictureObj["data"] as! NSDictionary
                let pictureUrlString  = picData["url"] as! String
                self.currentUser = User(id: id, firstname: firstName, lastname: lastName, email: email, photoURL: pictureUrlString)
                self.gotoChat()
            }
        })
    }
    func gotoChat() {
        SBDMain.initWithApplicationId(Constants.sendBirdAppID)
        self.delegate?.signupViewControllerGotoChat(user: self.currentUser!)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("logged out of FB")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        if (FBSDKAccessToken.current()) != nil {
            fetchUserProfile()
        }
    }
}
