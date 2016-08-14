//
//  ViewController.swift
//  FinputTest
//
//  Created by Benjamin Lim on 14/07/2016.
//  Copyright © 2016 Benjamin Lim. All rights reserved.
//

import UIKit


class FinController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    

    private let cellId = "cellId"
    
    var messages: [Message]?
    
    //Finn Logo - NOT ADDED IN YET 
    let FinnLogo: UIImageView = {
       let finnLogo = UIImageView()
        finnLogo.image = UIImage(named: "FinnLogo4")
        finnLogo.tintColor = UIColor.FinnMaroon()
        return finnLogo
    }()
    
    //Input container
    let messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        return view
    }()
    
    //input text
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Ask Finn something..."
        return textField
    }()
    
    
    //send button
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .System)
        let sendButton = UIImage(named: "send")
        button.setImage(sendButton, forState: .Normal)
        let titleColor = UIColor.FinnMaroon()
        button.tintColor = titleColor
        // button.setTitleColor(titleColor, forState: .Normal)
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        button.addTarget(self, action: #selector(handleSend), forControlEvents: .TouchUpInside)
        return button
    }()
    
    
    //Typing Image
    var typingImage: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "chat")
        return image
    }()
    
    // Top Menubar
    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    // Notification if message is empty
    let msgIsEmpty: UIAlertController = {
        let title = "You can't send nothing!"
        let message = "Gotta write something in that text"
        let gotIt = UIAlertAction(title: "Got it!", style: .Cancel , handler: nil)
        let info = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        info.addAction(gotIt)
        return info
    }()
    
    // Setup Menubar
    private func setupMenuBar() {
        view.addSubview(menuBar)
        view.addConstraintsWithFormat("H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat("V:|[v0(50)]", views: menuBar)

    }
    
    //Enable Button
    func enableButton() {
        self.sendButton.enabled = true
    }
    
    // func for send button
    func handleSend() {
        
        if inputTextField.text!.isEmpty{
            presentViewController(msgIsEmpty, animated: true, completion: nil)
        } else {
            
            
        print (inputTextField.text)
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        
        let message = FinController.createMessageWithText(inputTextField.text!, minutesAgo: 0, context: context, isSender: true)
        
        
        do {
            try context.save()
            
            messages?.append(message)
            
            let item = messages!.count - 1
            let insertionIndexPath = NSIndexPath(forItem: item, inSection: 0)
            
            collectionView?.insertItemsAtIndexPaths([insertionIndexPath])
            collectionView?.scrollToItemAtIndexPath(insertionIndexPath, atScrollPosition: .Top, animated: true)
            
            // Button disables for 1 second
            self.sendButton.enabled = false
            NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(enableButton), userInfo: nil, repeats: false)
            
            simulate()
            inputTextField.text = nil
        } catch let err {
            print (err)
        }
        }
        
    }
    
    var bottomConstraint: NSLayoutConstraint?
    
    // Simulate Bot response - appends message, conducts typing animation, inserts message //
    func simulate() {
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        
        let message = FinController.createMessageWithText(check(), minutesAgo: 0, context: context)
        
        do {
            try context.save()
            
            messages?.append(message)
            
            messages = messages?.sort ({$0.date!.compare($1.date!) == .OrderedAscending})
            
            if let item = messages?.indexOf(message) {
                let receivingIndexPath = NSIndexPath(forItem: item , inSection: 0)
                
                // Typing animation
                UIView.animateWithDuration(0.4, delay: 0.6, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                    
                    self.typingImage.alpha = 1.0

                    }, completion: { (completed) in
                        UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {self.typingImage.alpha = 0.0}, completion: nil)
                    self.collectionView?.insertItemsAtIndexPaths([receivingIndexPath])
                self.collectionView?.scrollToItemAtIndexPath(receivingIndexPath, atScrollPosition: .Top, animated: true)
                })
                
            }

        } catch let err {
            print (err)
        }
    }

// -- viewDidLoad START -- //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Assigns inputTextField delegate to itself to help keyboard return
        self.inputTextField.delegate = self
        
        //TitleLabel
        let titleLabel = UILabel(frame: CGRectMake(0, 0, view.frame.width-32, view.frame.height))
        titleLabel.text = "FINN"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.systemFontOfSize(20)
        navigationItem.titleView = titleLabel
        
        navigationController?.navigationBar.translucent = false //Not Translucent
        
        setupData()
        
        //Adding in messageInputContainerView
        view.addSubview(messageInputContainerView)
        view.addConstraintsWithFormat("H:|[v0]|", views: messageInputContainerView)
        view.addConstraintsWithFormat("V:[v0(48)]", views: messageInputContainerView)
        
//        view.addSubview(FinnLogo)
//        view.addConstraintsWithFormat("H:|-120-[v0(95)]|", views: FinnLogo)
//        view.addConstraintsWithFormat("V:|[v0(95)]-100-|", views: FinnLogo)
        
        //typing image
        messageInputContainerView.addSubview(typingImage)
        messageInputContainerView.addConstraintsWithFormat("H:|-8-[v0(30)]", views: typingImage)
        messageInputContainerView.addConstraintsWithFormat("V:[v0(30)]-52-|", views: typingImage)
        typingImage.alpha = 0.0
        
        setupInputComponents()
        
        // Making the constraint of the messageContainerView variable, adjusting to the keyboard
        bottomConstraint = NSLayoutConstraint(item: messageInputContainerView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        
        

        collectionView?.alwaysBounceVertical = true 
        collectionView?.backgroundView = UIImageView(image: UIImage(named: "FinnSplash2"))
        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.registerClass(ChatLogMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50 + 8, 0, 60, 0)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleKeyboardNotification), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleKeyboardNotification), name: UIKeyboardWillHideNotification, object: nil)
        
        setupMenuBar()
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = messages?.count {
            return count
        }
        return 0
    }
    
    // assigns text to messages
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! ChatLogMessageCell
        cell.messageTextView.text = messages?[indexPath.item].text
        
        if let message = messages?[indexPath.item], messageText = message.text {
            
            cell.profileImageView.backgroundColor = UIColor.FinnBlue()
            cell.profileImageView.image = UIImage(named: "Finn" )
            
            let size = CGSizeMake(250, 1000)
            let options = NSStringDrawingOptions.UsesFontLeading.union(.UsesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRectWithSize(size, options: options, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(18)], context: nil)
            
            if !message.isSender!.boolValue {
                
                cell.messageTextView.frame = CGRectMake(48 + 8, 0, estimatedFrame.width + 16, estimatedFrame.height + 20)
                
                cell.textBubbleView.frame = CGRectMake(48 - 10, -4, estimatedFrame.width + 16 + 8 + 16, estimatedFrame.height + 20 + 6)
                
                cell.profileImageView.hidden = false
                
                cell.bubbleImageView.image = ChatLogMessageCell.grayBubbleImage
                cell.bubbleImageView.tintColor = UIColor(white: 0.95, alpha: 0.9)
                cell.messageTextView.textColor = UIColor.blackColor()
                
            } else {
                
                cell.messageTextView.frame = CGRectMake(view.frame.width - estimatedFrame.width - 16 - 16 - 8, 0, estimatedFrame.width + 16, estimatedFrame.height + 20)
                
                cell.textBubbleView.frame = CGRectMake(view.frame.width - estimatedFrame.width - 16 - 8 - 16 - 10, -4, estimatedFrame.width + 16 + 8 + 10, estimatedFrame.height + 20 + 6)
                
                cell.profileImageView.hidden = true
                
                cell.bubbleImageView.image = ChatLogMessageCell.blueBubbleImage
                cell.bubbleImageView.tintColor = UIColor.FinnMaroonBlur()
                cell.messageTextView.textColor = UIColor.whiteColor()
                
            }
        
    }
            return cell
    }
    
    // Make size edge to edge
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if let messageText = messages?[indexPath.item].text {
            let size = CGSizeMake(250, 1000)
            let options = NSStringDrawingOptions.UsesFontLeading.union(.UsesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRectWithSize(size, options: options, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(18)], context: nil)
            
            return CGSizeMake(view.frame.width, estimatedFrame.height + 20)
        }
        return CGSizeMake(view.frame.width, 100)
    }
    
    // gap between messages and top
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(58, 0, 60, 0)
    }
    
    private func setupInputComponents() {
        let topBorderView = UIView()
        topBorderView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        
        messageInputContainerView.addSubview(inputTextField)
        messageInputContainerView.addSubview(topBorderView)
        messageInputContainerView.addSubview(sendButton)
        
        messageInputContainerView.addConstraintsWithFormat("H:|-8-[v0][v1(60)]|", views: inputTextField,sendButton)
        
        messageInputContainerView.addConstraintsWithFormat("V:|[v0]|", views: inputTextField)
        messageInputContainerView.addConstraintsWithFormat("V:|[v0]|", views: sendButton)

        
        messageInputContainerView.addConstraintsWithFormat("H:|[v0]|", views: topBorderView)
        messageInputContainerView.addConstraintsWithFormat("V:|[v0(0.5)]", views: topBorderView)

    }
    
    
    func handleKeyboardNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            
            // height of the keyboard
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue()
            print(keyboardFrame)
            
            let isKeyboardShowing = notification.name == UIKeyboardWillShowNotification
            
            // constant of the messageContainer varies according to the height of the keyboard (ternary operator)
            bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame!.height: 0
            
            UIView.animateWithDuration(0, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                
                self.view.layoutIfNeeded()
                
                }, completion: { (completed) in
                    
                    if isKeyboardShowing {
                        let indexPath = NSIndexPath(forItem: self.messages!.count - 1, inSection: 0)
                        self.collectionView?.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
                    }
            })
        }
    }
    
    // Keyboard return 
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        inputTextField.resignFirstResponder()
        return true
    }
    
    //Don't allow rotation
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    //Portrait View only 
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }

}
// -- viewDidLoad END -- //

//BaseCell
class BaseCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ChatLogMessageCell: BaseCell {
    
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFontOfSize(18)
        textView.text = "Sample Message"
        textView.backgroundColor = UIColor.clearColor()
        textView.editable = false
        return textView
    }()
    
    let textBubbleView: UIView = {
        let view = UIView()
//        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    //resizing bubbleImages
    static let grayBubbleImage = UIImage(named: "bubble_gray")!.resizableImageWithCapInsets(UIEdgeInsetsMake(22, 26, 22, 26)).imageWithRenderingMode(.AlwaysTemplate)
    static let blueBubbleImage = UIImage(named: "bubble_blue")!.resizableImageWithCapInsets(UIEdgeInsetsMake(22, 26, 22, 26)).imageWithRenderingMode(.AlwaysTemplate)

    
    let bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ChatLogMessageCell.grayBubbleImage
        imageView.tintColor = UIColor(white: 0.95, alpha: 0.9)
        return imageView
    }()
    
    
    
    // Seting up views of each container
    override func setupViews() {
        backgroundColor = UIColor.clearColor()
        addSubview(textBubbleView)
        addSubview(messageTextView)
        addSubview(profileImageView)
        addConstraintsWithFormat("H:|-8-[v0(30)]", views: profileImageView)
        addConstraintsWithFormat("V:[v0(30)]|", views: profileImageView)
        profileImageView.backgroundColor = UIColor.redColor()
        
        textBubbleView.addSubview(bubbleImageView)
        textBubbleView.addConstraintsWithFormat("H:|[v0]|", views: bubbleImageView)
        textBubbleView.addConstraintsWithFormat("V:|[v0]|", views: bubbleImageView)


    }
    
    

}





















