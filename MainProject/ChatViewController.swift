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
    
    private func addMessage(message: SBDUserMessage) {
        if let message = JSQMessage(senderId: message.sender?.userId ?? "", senderDisplayName: message.sender?.nickname ?? "", date: Date(timeIntervalSince1970: TimeInterval(message.createdAt / 1000))
            , text: message.message) {
            messages.append(message)
            //self.reloadMessagesView()
        }
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
}
