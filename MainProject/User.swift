//
//  User.swift
//  MainProject
//
//  Created by George Drag on 1/16/18.
//  Copyright © 2018 Red Foundry. All rights reserved.
//

import UIKit

class User {
    var firstname: String
    var lastname: String
    var email: String
    var photoURL: String
    var id: String
    
    
    init(id: String, firstname: String, lastname: String, email: String, photoURL: String) {
        self.firstname = firstname
        self.lastname = lastname
        self.email = email
        self.photoURL = photoURL
        self.id = id
    }
}

extension User {
    func fullname() -> String {
        return firstname + " " + lastname
    }
    
    func initials() -> String {
        var initials = String(describing: firstname.first)
        initials += String(describing: lastname.first)
        return initials.uppercased()
    }
}
