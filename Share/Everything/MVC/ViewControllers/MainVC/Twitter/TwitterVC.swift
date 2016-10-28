//
//  TwitterVC.swift
//  Share
//
//  Created by Aseem 7 on 19/10/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

import UIKit
import TwitterKit
class TwitterVC: TWTRTimelineViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTwitterData()
        
    }

    func loadTwitterData(){
        if let session = Twitter.sharedInstance().sessionStore.session() {
            let client = TWTRAPIClient()
            client.loadUser(withID: session.userID) { (user, error) -> Void in
                if let user = user {
                    let client = TWTRAPIClient()
                    self.dataSource = TWTRUserTimelineDataSource(screenName: user.screenName, apiClient: client)
                    self.showTweetActions = true
                }
                else
                {
                    print("error: \(error?.localizedDescription)")
                }
            }
        }
        else
        {
            twitterLogin()
        }
    }
    
    func twitterLogin() {
        Twitter.sharedInstance().logIn { session, error in
            if (session != nil) {
                print("signed in as \(session?.userName)")
                self.loadTwitterData()
            } else {
                print("error: \(error?.localizedDescription)")
            }
        }
    }

}
