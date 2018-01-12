//
//  DummyViewController.swift
//  MainProject
//
//  Created by George Drag on 1/12/18.
//  Copyright © 2018 Red Foundry. All rights reserved.
//

import UIKit

class DummyViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "walkThroughHasBeenShown") == nil {
            defaults.set(false, forKey: "walkThroughHasBeenShown")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let nav = storyboard.instantiateViewController(withIdentifier: "signup")
        self.present(nav, animated: false, completion: nil)
    }
    
}
