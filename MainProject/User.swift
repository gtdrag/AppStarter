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
    var email: String?
    var photo: String?
    
    init(firstname: String, lastname: String, email: String?, photo: String?) {
        self.firstname = firstname
        self.lastname = lastname
        self.email = email
        self.photo = photo
    }
}

extension User {
    func fullname() -> String {
        return firstname + " " + lastname
    }
}
