//
//  ViewController.swift
//  Chatik
//
//  Created by Лилия Левина on 11.11.2020.
//  Copyright © 2020 Лилия Левина. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var hamburgerViewLeadingConstraintt: NSLayoutConstraint!
    @IBOutlet weak var hamburgerBackgroundViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bgHamburgerViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var bottomViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gamburgerBackgroundView: UIView!
    @IBOutlet weak var hamburgerView: UIView!
    @IBOutlet weak var textView: UITextView!
    
    var requestedVC: HamburgerViewController?
    var activityIndicatorView: UIActivityIndicatorView!
    
    var messages:[(Bool,String)]? = [(false,"12334454546565656565433453454435344534534"),
                                     (true, "qwhqhduiehduehdiuhdiuhfiuehfireuhfireufhireufhierhfiurehhvuhreiuv"),
                                     (false, "qwhqhduiehduehdiuhdiuhfiuehfireuhfireufhireufhierhfiurehhvuhreiuv"),
    (false, "qwhqhduiehduehdiuhdiuhfiuehfireuhfireufhireufhierhfiurehhvuhreiuv")]
    
    var user: ChatUser = ChatUser(avatar: "chatUserAvatar",
                                  name: "Вася",
                                  email: "vasya@gmail.com",
                                  password: "123456")
    let ref = Database.database().reference(withPath: "chatMessage-items")
    var chatMessages = [ChatMessage]()
    
    @IBAction func sendMessage(_ sender: Any) {
        if !textView.text.isEmpty {
            let date = Date()
            let message = ChatMessage(sender_name: "Иван", text: textView.text, date: date)
            self.ref.childByAutoId().setValue(message.toAnyObject())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        addKeyboardObservers()
        addActivityIndicator()
        loadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self);
    }
    
    private func loadData() {
        // Listen for new messages in the Firebase database
        self.activityIndicatorView.startAnimating()
       ref.observe(.childAdded, with: { (snapshot) -> Void in
            if let message = ChatMessage(snapshot: snapshot) {
                self.chatMessages.append(message)
            }
            let indexPath = IndexPath(row: self.chatMessages.count - 1, section: 0)
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            self.tableView.endUpdates()
            self.textView.text = ""
            self.tableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.middle, animated: true)
            self.activityIndicatorView.stopAnimating()
        })
    }
    
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func addActivityIndicator() {
        activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.style = UIActivityIndicatorView.Style.medium
        let bounds: CGRect = UIScreen.main.bounds
        activityIndicatorView.center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        activityIndicatorView.hidesWhenStopped = true
        view.addSubview(activityIndicatorView)
    }
    
    
    @objc func notificationAction(_ notifucation: Notification?) {
         hideHamburgeView()
    }
    
    @IBAction func tapOnTheBaseTableView(_ sender: UITapGestureRecognizer) {
        textView.endEditing(true)
        
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
    
    @objc func keyboardWillShow(notification: Notification) {
        let keyboardSize = (notification.userInfo?  [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardHeight = keyboardSize?.height
        
        if #available(iOS 11.0, *) {
            self.bottomViewBottomConstraint.constant = keyboardHeight! - view.safeAreaInsets.bottom
        } else { self.bottomViewBottomConstraint.constant = view.safeAreaInsets.bottom }
        UIView.animate(withDuration: 0.5) { self.view.layoutIfNeeded()}
    }
    
    @objc func keyboardWillHide(notification: Notification){
        self.bottomViewBottomConstraint.constant =  0
        UIView.animate(withDuration: 0.5){ self.view.layoutIfNeeded() }
    }
    
    private func showHamburgerView() {
        if self.hamburgerViewLeadingConstraintt.constant != 0  {
            bgHamburgerViewTrailing.constant = 380
            self.hamburgerViewLeadingConstraintt.constant = 0
            UIView.animate(withDuration: 0.6, delay: 0.0, options: .layoutSubviews, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let hamburgerViewController = segue.destination as? HamburgerViewController
        hamburgerViewController?.user = user
        hamburgerViewController?.delegate = self
    }
    
    private func hideHamburgeView() {
        if self.hamburgerViewLeadingConstraintt.constant == 0 {
            bgHamburgerViewTrailing.constant = -380
            self.hamburgerViewLeadingConstraintt.constant = -380
            UIView.animate(withDuration: 0.6, delay: 0.0, options: .layoutSubviews, animations: {
                self.view.layoutIfNeeded()})
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let messages = messages {
//            return messages.count
//        }
//        return 0
        
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if let (isUserMessage,message) = messages?[indexPath.row] {
//            if isUserMessage {
//                let cell = tableView.dequeueReusableCell(
//                       withIdentifier: "CellUser",
//                       for: indexPath) as! UserMessageTableViewCell
//                       cell.messageLabel.text = message
//                       return cell
//            } else {
//                let cell = tableView.dequeueReusableCell(
//                   withIdentifier: "Cell",
//                   for: indexPath) as! ChatMessageTableViewCell
//                   cell.messageLabel.text = message
//                   return cell
//            }
//        }
        
        var message: ChatMessage?
        if chatMessages.count > 0 { message = chatMessages[indexPath.row]}
        if let message = message {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "CellUser",
                for: indexPath) as! UserMessageTableViewCell
            cell.messageLabel.text = message.text
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(
        withIdentifier: "Cell",
        for: indexPath) as UITableViewCell
        return cell
    }
    
    
}

extension ViewController: HamburgerViewControllerDelegate {
    func openSettingsVCButtonTapped() {
        hideHamburgeView()
    }
}

extension ViewController: UITableViewDelegate {
    
}

