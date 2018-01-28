//
//  ChatViewController.swift
//  MainProject
//
//  Created by George Drag on 1/25/18.
//  Copyright © 2018 Red Foundry. All rights reserved.
//

import UIKit
import BRYXBanner
import FBSDKLoginKit
import JSQMessagesViewController
import SendBirdSDK

class ChatViewController: JSQMessagesViewController {
    var currentUser: User?
    var openChannel: SBDOpenChannel?
    var messages: [JSQMessage] = []
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor(hexString: "e5e5ea"))
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor(hexString: "51bbf7"))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SBDMain.add(self as SBDChannelDelegate, identifier: Constants.chatChannelUrl)
        self.senderId = self.currentUser?.id
        self.senderDisplayName = self.currentUser?.fullname()
        connectUser()
    }
    
    
    private func connectUser() {
        guard let id = currentUser?.id else { return }
        SBDMain.connect(withUserId: String(describing: id)) { (user, error) in
            if error != nil {
                print("\(error!)")
            } else {
                SBDMain.updateCurrentUserInfo(withNickname: self.currentUser?.firstname ?? "", profileUrl: self.currentUser?.photoURL ?? "", completionHandler: { (error) in
                    if error != nil {
                        print("\(error!)")
                        return
                    }
                    self.enterChat()
                })
            }
        }
    }
    
    private func enterChat() {
        //fetch channel
        SBDOpenChannel.getWithUrl(Constants.chatChannelUrl) { (openChannel, error) in
            if error != nil {
                print("\(error!)")
                return
            }
            // enter channel
            openChannel?.enter(completionHandler: { (error) in
                if error != nil {
                    print("error: \(error!)")
                    return
                }
                self.openChannel = openChannel
            })
        }
    }
    
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
            self.reloadMessagesView()
        }
    }
    
    private func addMessage(message: SBDUserMessage) {
        if let message = JSQMessage(senderId: message.sender?.userId ?? "", senderDisplayName: message.sender?.nickname ?? "", date: Date(timeIntervalSince1970: TimeInterval(message.createdAt / 1000))
            , text: message.message) {
            messages.append(message)
            self.reloadMessagesView()
        }
    }
    
    func reloadMessagesView() {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
            self.finishReceivingMessage()
        }
    }
    
    func sendMessage(message: String, sender: String) {
        openChannel?.sendUserMessage(message, data: nil, completionHandler: { (userMessage, error) in
            if error != nil {
                NSLog("Error: %@", error!)
                //TODO: handle error
                return
            }
            else {
                if userMessage != nil {
                    self.addMessage(message: userMessage!)
                }
            }
        })
    }

    
    @IBAction func logoutFB() {
        FBSDKLoginManager().logOut()
        self.dismiss(animated: true, completion: nil)
    }
}

extension ChatViewController : SBDConnectionDelegate, SBDChannelDelegate {
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        if let userMessage = message as? SBDUserMessage {
            _ = userMessage.sender
            addMessage(message: userMessage)
        }
        if let adminMessage = message as? SBDAdminMessage {
            guard let displayMessage = adminMessage.message else { return }
            print ("\(displayMessage)")
            let banner = Banner(title: "Message from the Administrator", subtitle: displayMessage, image: UIImage(named: "Icon"), backgroundColor: .lightGray)
            banner.show()
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        let data = self.messages[indexPath.row]
        return data
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let data = messages[indexPath.row]
        if data.senderId == self.currentUser?.id {
            return outgoingBubble
        } else {
            return incomingBubble
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = self.messages[indexPath.item]
        var isOutgoing = false
        isOutgoing = message.senderId == self.currentUser?.id
        cell.textView.textColor = isOutgoing ? .white : .black
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = self.messages[indexPath.item]
        var isOutgoing = false
        isOutgoing = message.senderId == self.currentUser?.id
        let avatar = isOutgoing ? nil : JSQMessagesAvatarImageFactory.avatarImage(withUserInitials: message.senderDisplayName, backgroundColor: UIColor(hexString: "c0c0c0"), textColor: .white, font: UIFont.systemFont(ofSize: 14.0), diameter: 30)
        return avatar
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        guard let id = self.currentUser?.id else { return }
        self.sendMessage(message: text, sender: id)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        self.finishSendingMessage()
    }
}
