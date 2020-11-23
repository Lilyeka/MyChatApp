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
    //MARK: - Views
    var requestedVC: HamburgerViewController?
    var activityIndicatorView: UIActivityIndicatorView!
    //MARK: - Variables
    var user: ChatUser!
    var uid: String!
    var chatMessages = [ChatMessage]()
    //MARK: - Constants
    let ref = Database.database().reference(withPath: "chatMessage-items")
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        addKeyboardObservers()
        addActivityIndicator()
        loadUser()
        loadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self);
    }
    
    //MARK: - IBActions
    @IBAction func sendMessage(_ sender: Any) {
        if !textView.text.isEmpty {
            let date = Date()
            let message = ChatMessage(sender_name: user.name, sender_id: uid, text: textView.text, date: date)
            self.ref.childByAutoId().setValue(message.toAnyObject())
        }
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
    
    //MARK: - Actions
    @objc func notificationAction(_ notifucation: Notification?) {
        hideHamburgeView()
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
    
    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "hamburgerSegue" {
            let hamburgerViewController = segue.destination as? HamburgerViewController
            hamburgerViewController?.delegate = self
        }
    }
    
    //MARK: - Private methods
    private func loadUser() {
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            var avatar = ""
            if let photoURL = user.photoURL {
                avatar = photoURL.absoluteString
            }
            let name = user.displayName ?? "Пользователь № \(user.uid)"
            let email = user.email ?? ""
            self.uid = user.uid
            self.user = ChatUser(avatar: avatar, name: name, email: email, password: "")
        }
    }
    
    private func loadData() {
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
        self.activityIndicatorView.stopAnimating()
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
    
    private func showHamburgerView() {
        if self.hamburgerViewLeadingConstraintt.constant != 0  {
            bgHamburgerViewTrailing.constant = 380
            self.hamburgerViewLeadingConstraintt.constant = 0
            UIView.animate(withDuration: 0.6, delay: 0.0, options: .layoutSubviews, animations: {
                self.view.layoutIfNeeded()
            })
        }
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

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var message: ChatMessage?
        if chatMessages.count > 0 { message = chatMessages[indexPath.row]}
        if let message = message {
            if message.sender_id == uid {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CellUser", for: indexPath) as! UserMessageTableViewCell
                cell.messageLabel.text = message.text
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChatMessageTableViewCell
                cell.messageLabel.text = message.text
                return cell
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        return cell
    }
}
//MARK: - HamburgerViewControllerDelegate
extension ViewController: HamburgerViewControllerDelegate {
    func openSettingsVCButtonTapped() {
        hideHamburgeView()
    }
    func exitButtonTapped() {
        hideHamburgeView()
        self.dismiss(animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate {
    
}

