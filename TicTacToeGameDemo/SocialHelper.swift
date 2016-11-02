//
//  SocialHelper.swift
//  TicTacToeGameDemo
//
//  Created by Monica Peters on 11/2/16.
//  Copyright © 2016 monigarr. All rights reserved.
//

import SpriteKit
import Social

//urls
private struct URL{
    static let twitterApp = NSURL(string: "http://www.twitter.com/")
}
//text
private struct TextString{
    static let shareSheetText = "Share your Awesomeness"
    static let error = "Error"
    static let enableSocial = "Sign into your Social Network first"
    static let settings = "Settings"
    static let ok = "OK"
}

//social
protocol Social{}
extension Social where Self: SKScene{
    
//open twitter
    func openTwitter(){
        guard let twitterApp = URL.twitterApp else { return }
        
        if UIApplication.sharedApplication.canOpenURL(twitterApp){
            UIApplication.sharedApplication.openURL(twitterApp)
        } else {
            UIApplication.sharedApplication().openURL("http://www.twitter.com")
        }
    }
//share to twitter
    func shareToTwitter(){
        guard SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) else {
            showAlert()
            return
        }
        
        let twitterSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        twitterSheet?.completionHandler = { result in
            switch result {
            case .Cancelled:
                print("tweet cancelled")
                break
            case .Done:
                print("tweet done")
                break
            }
        }
        let text = TextString.shareSheetText
        twitterSheet?.setInitialText(String.localizedStringWithFormat(text, "I am Awesome"))
        self.view?.window?.rootViewController?.presentViewController(twitterSheet, animated:true, completion:nil)
    }
    
    private func showAlert(){
        let alertController = UIAlertController(title:TextString.error, message:TextString.enableSocial, preferredStyle: .Alert)
        let okAction = UIAlertAction(title:TextString.ok, style:.Cancel){ _in }
        alertController.addAction(okAction)
        
        let settingsAction = UIAlertAction(title:TextString.settings, style:.Default){ _in
            
            if let url = NSURL(string:UIApplicationOpenSettingsURLString){
                UIApplication.sharedApplication().openURL(url)
            }
        }
        alertController.addAction(settingsAction)
        self.view?.window?.rootViewController?.presentViewController(alertController, animated:true, completion:nil)
    }
}

