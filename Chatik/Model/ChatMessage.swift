//
//  ChatMessage.swift
//  Chatik
//
//  Created by Лилия Левина on 19.11.2020.
//  Copyright © 2020 Лилия Левина. All rights reserved.
//

import Foundation
import Firebase

struct ChatMessage {
    var sender_id: String = ""
    var sender_name: String = ""
    var text: String = ""
    var date: Date!
    
    init?(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as? [String: Any]
        
        if let id = snapshotValue?["sender_id"] as? String {
            self.sender_id = id
        }
        
        if let name = snapshotValue?["sender_name"] as? String {
            self.sender_name = name
        }
        
        if let text = snapshotValue?["text"] as? String {
            self.text = text
        }
        
        if let date = snapshotValue?["date"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let dateFormatted = dateFormatter.date(from:date)
            self.date = dateFormatted!
        }
    }
    
    init(sender_name:String, sender_id: String, text: String, date: Date) {
        self.sender_name = sender_name
        self.sender_id = sender_id
        self.text = text
        self.date = date
    }
    
    func toAnyObject() -> [String:String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let resultDate = formatter.string(from: date)
        var resDictionary:[String:String] =
            ["sender_name" : sender_name,
             "sender_id": sender_id,
             "text" : text,
             "date": resultDate]
        return resDictionary
    }
}
