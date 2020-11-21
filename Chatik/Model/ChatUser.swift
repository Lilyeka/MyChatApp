//
//  User.swift
//  Chatik
//
//  Created by Лилия Левина on 15.11.2020.
//  Copyright © 2020 Лилия Левина. All rights reserved.
//

import Foundation

public class ChatUser  {
    static var id = UUID().uuidString
    let email: String
    var avatar: String
    var name: String
    var password: String
    
    init(avatar: String, name: String, email: String, password: String) {
        self.avatar = avatar
        self.name = name
        self.email = email
        self.password = password
    }
    
    func toAnyObject() -> [String:String] {
        let resDictionary:[String:String] =
            ["email" : email,
             "avatar" : avatar,
             "name": name,
             "password": password]
        return resDictionary
    }
}

