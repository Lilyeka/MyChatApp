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
 
    @IBOutlet weak var gamburgerBackgroundView: UIView!
    @IBOutlet weak var hamburgerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gamburgerBackgroundView.alpha = 0.0
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapBgViewAction(_ sender: UITapGestureRecognizer) {
        hideHamburgeView()
    }
    
    @IBAction func swipeToTheLeftAction(_ sender: Any) {
        hideHamburgeView()
    }
    
    @IBAction func swipeToTheRightAction(_ sender: Any) {
        showHamburgerView()
    }
    
    private func showHamburgerView() {
        if self.hamburgerViewLeadingConstraintt.constant != 0  {
            gamburgerBackgroundView.alpha = 0.7
            self.hamburgerViewLeadingConstraintt.constant = 0
            UIView.animate(withDuration: 0.6, delay: 0.0, options: .layoutSubviews, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    private func hideHamburgeView() {
        if self.hamburgerViewLeadingConstraintt.constant == 0 {
            gamburgerBackgroundView.alpha = 0.0
            self.hamburgerViewLeadingConstraintt.constant = -380
            UIView.animate(withDuration: 0.6, delay: 0.0, options: .layoutSubviews, animations: {
                self.view.layoutIfNeeded()})
        }
    }
    
}

