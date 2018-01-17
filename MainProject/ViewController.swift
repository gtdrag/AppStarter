//
//  ViewController.swift
//  MainProject
//
//  Created by George Drag on 1/12/18.
//  Copyright © 2018 Red Foundry. All rights reserved.
//

import UIKit
import BWWalkthrough


class ViewController: UIViewController {
   
    @IBOutlet weak var signupView: UIView!
    @IBOutlet weak var loginView: UIView!
    
    var walkthrough = BWWalkthroughViewController()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let defaults = UserDefaults.standard
        let shown  = defaults.bool(forKey: "walkThroughHasBeenShown")
        
        if !shown {
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "walkThroughHasBeenShown")
            showWalkthrough()
        }
    }
   
    func showWalkthrough() {
        let stb = UIStoryboard(name: "Main", bundle: nil)
        self.walkthrough = stb.instantiateViewController(withIdentifier: "walkthrough") as! BWWalkthroughViewController
        let page_one = stb.instantiateViewController(withIdentifier: "page_1")
        let page_two = stb.instantiateViewController(withIdentifier: "page_2")
        let page_three = stb.instantiateViewController(withIdentifier: "page_3")
        let dummy_page = stb.instantiateViewController(withIdentifier: "signup")
        // Attach the pages to the master
        walkthrough.delegate = self
        walkthrough.add(viewController: page_one)
        walkthrough.add(viewController: page_two)
        walkthrough.add(viewController: page_three)
        walkthrough.add(viewController: dummy_page)
        present(walkthrough, animated: true, completion: nil)
    }
    

    func hideWalkThrough() {
        // switch root view controllers
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let nav = storyboard.instantiateViewController(withIdentifier: "signup")
        UIApplication.shared.keyWindow?.rootViewController = nav
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.signupSegue {
            let signupViewController = segue.destination as! SignupViewController
            signupViewController.delegate = self
        } else if
            segue.identifier == Constants.loginSegue {
            let loginViewController = segue.destination as! LoginViewController
            loginViewController.delegate = self
        }
    }
}

extension ViewController : BWWalkthroughViewControllerDelegate, signupViewControllerDelegate, loginViewControllerDelegate {
    func walkthroughCloseButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func walkthroughPageDidChange(_ pageNumber: Int) {
        if pageNumber + 1 == walkthrough.numberOfPages {
            hideWalkThrough()
        }
    }
    
    func loginViewControllerDidPressButton(loginViewController: LoginViewController) {
        UIView.animate(withDuration: 0.2) {
            self.signupView.alpha = 1
            self.loginView.alpha = 0
        }
        
    }
    
    func signupViewControllerDidPressButton(signupViewController:
        SignupViewController) {
        UIView.animate(withDuration: 0.2) {
            self.signupView.alpha = 0
            self.loginView.alpha = 1
        }
    }
}

