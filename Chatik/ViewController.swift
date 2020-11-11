//
//  ViewController.swift
//  Chatik
//
//  Created by Лилия Левина on 11.11.2020.
//  Copyright © 2020 Лилия Левина. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var hamburgerViewLeadingConstraintt: NSLayoutConstraint!
    @IBOutlet weak var hamburgerBackgroundViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var hamburgerLeading: NSLayoutConstraint!
    @IBOutlet weak var gamburgerBackgroundView: UIView!
    @IBOutlet weak var hamburgerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gamburgerBackgroundView.isHidden = true
        // Do any additional setup after loading the view.
    }

    @IBAction func showHamburger(_ sender: UIButton) {
        if self.hamburgerViewLeadingConstraintt.constant == 0 {
             gamburgerBackgroundView.isHidden = true
            self.hamburgerViewLeadingConstraintt.constant = -380
             UIView.animate(withDuration: 0.6, delay: 0.0, options: .layoutSubviews, animations: {
                self.view.layoutIfNeeded()})
             } else {
                gamburgerBackgroundView.isHidden = false
                self.hamburgerViewLeadingConstraintt.constant = 0
                      UIView.animate(withDuration: 0.6, delay: 0.0, options: .layoutSubviews, animations: {
                          self.view.layoutIfNeeded()
                      })
                }
      
        print("qwqw")
        
//        if leadingTabelViewLayoutConstraint.constant == 0 {
//            leadingTabelViewLayoutConstraint.constant = UIScreen.main.bounds.size.width / 2
//            trailingTableViewLayoutConstraint.constant = UIScreen.main.bounds.size.width * -0.5
//            UIView.animate(withDuration: 0.3, delay: 0.0, options: .layoutSubviews, animations: {
//                self.view.layoutIfNeeded()
//            })
//        } else {
//            leadingTabelViewLayoutConstraint.constant = 0
//            trailingTableViewLayoutConstraint.constant = 0
//            UIView.animate(withDuration: 0.3, delay: 0.0, options: .layoutSubviews, animations: {
//                self.view.layoutIfNeeded()
//            })
//        }
        
    }
    
}

