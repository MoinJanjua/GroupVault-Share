//
//  SettingsViewController.swift
//  LinguaLens
//
//  Created by Unique Consulting Firm on 01/07/2024.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var versionLb:UILabel!
    
    let NotificationIdentifier = "WeeklyReminder"
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"]!
        let build = Bundle.main.infoDictionary!["CFBundleVersion"]!
        versionLb.text = "Version \(version) (\(build))"
        // Do any additional setup after loading the view.
    }
    
     

    @IBAction func homebtnPressed(_ sender:UIButton)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true)
    }
    
    @IBAction func PrivscyPolicy(_ sender:UIButton)
    {
        let appStoreURL = URL(string: "https://jtechapps.pages.dev/privacy")!
                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
    }
    
    
    @IBAction func learnMorebtnPressed(_ sender:UIButton)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "AboutusViewController") as! AboutusViewController
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true)
    }
    
    @IBAction func feedbackbtnPressed(_ sender:UIButton)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "FeedbackViewController") as! FeedbackViewController
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true)
    }

    
    
    @IBAction func sharebtnPressed(_ sender:UIButton)
    {
        let appID = "GroupVaultShare"
           let appStoreURL = URL(string: "https://apps.apple.com/app/id\(appID)")!
           
           let activityViewController = UIActivityViewController(activityItems: [appStoreURL], applicationActivities: nil)
           
           // For iPads
           if let popoverController = activityViewController.popoverPresentationController {
               popoverController.barButtonItem = sender as? UIBarButtonItem
           }
           
           present(activityViewController, animated: true, completion: nil)
    }

    @IBAction func backbtnPressed(_ sender:UIButton)
    {
        self.dismiss(animated: true)
    }
    
    

}
