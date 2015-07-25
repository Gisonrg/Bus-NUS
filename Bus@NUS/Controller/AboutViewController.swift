//
//  AboutViewController.swift
//  Bus@NUS
//
//  Created by Jiang Sheng on 23/7/15.
//  Copyright (c) 2015 Gisonrg. All rights reserved.
//

import UIKit
import MessageUI

class AboutViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    static let storyboardId = "Main"
    static let viewControllerId = "AboutViewController"
    
    class func getInstance() -> AboutViewController {
        let storyboard = UIStoryboard(name: storyboardId, bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier(viewControllerId) as! AboutViewController
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "About"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "homeButton"), style: UIBarButtonItemStyle.Plain, target: self, action: "openHome:")
    }
    
    func openHome(sender:AnyObject) {
        UIView.beginAnimations("flipBack", context: nil)
        UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromRight, forView: self.navigationController!.view, cache: false)
        self.navigationController!.popViewControllerAnimated(false)
        UIView.setAnimationDuration(0.8)
        UIView.commitAnimations()
    }
    
    @IBAction func sendFeedback(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["gisonrg@gmail.com"])
        mailComposerVC.setSubject("Bus@NUS Feedback")
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
