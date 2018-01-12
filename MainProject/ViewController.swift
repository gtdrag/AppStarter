//
//  ViewController.swift
//  MainProject
//
//  Created by George Drag on 1/12/18.
//  Copyright © 2018 Red Foundry. All rights reserved.
//

import UIKit
import BWWalkthrough


class ViewController: UIViewController, BWWalkthroughViewControllerDelegate {

    var walkthrough = BWWalkthroughViewController()
    
    @IBAction func showWalkthrough() {
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
    
    // delegate methods
    func walkthroughCloseButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }

    func walkthroughPageDidChange(_ pageNumber: Int) {
        if pageNumber + 1 == walkthrough.numberOfPages {
            switchViewControllers()
        }
    }
    
    func switchViewControllers() {
        // switch root view controllers
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let nav = storyboard.instantiateViewController(withIdentifier: "signup")
        UIApplication.shared.keyWindow?.rootViewController = nav
 }
}


