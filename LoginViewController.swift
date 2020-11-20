//
//  LoginViewController.swift
//  Chatik
//
//  Created by Лилия Левина on 16.11.2020.
//  Copyright © 2020 Лилия Левина. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var regView: UIView!

    @IBOutlet weak var logView: UIView!
    
    @IBOutlet weak var loginTabBarItem: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.delegate = self
        tabBar.selectedItem = loginTabBarItem
    }
}

extension LoginViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 1:          //регистрация
            logView.isHidden = true
             regView.isHidden = false
        case 0:   //вход
           logView.isHidden = false
            regView.isHidden = true
        default:
            break
        }
    }
}
