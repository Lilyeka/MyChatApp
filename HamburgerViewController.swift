//
//  HamburgerViewController.swift
//  Chatik
//
//  Created by Лилия Левина on 11.11.2020.
//  Copyright © 2020 Лилия Левина. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userFirstNameLettersLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    var user: ChatUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        userImageView.layer.cornerRadius = 45.0
        userImageView.clipsToBounds = true
        userFirstNameLettersLabel.text = ""
        if user.avatar != "" {
            userImageView.image = UIImage(named: "chatUserAvatar")
        } else {
            userImageView.image = UIImage(named: "defaultUser")
            if user.name != "", user.name.count > 0 {
                userFirstNameLettersLabel.text = String(user.name.prefix(1))
            }
        }
        userNameLabel.text = user.name
    }


    @IBAction func swipeGestureRecogniserAction(_ sender: UISwipeGestureRecognizer) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func settingsBtnAction(_ sender: UIButton) {
        
    }
    
    @IBAction func exitBtnAction(_ sender: UIButton) {
    }
   


}
