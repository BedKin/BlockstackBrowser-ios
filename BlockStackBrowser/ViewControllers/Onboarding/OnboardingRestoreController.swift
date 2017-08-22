//
//  OnboardingRestoreController.swift
//  BlockStackBrowser
//
//  Created by lsease on 8/11/17.
//  Copyright © 2017 blockstack. All rights reserved.
//

import UIKit
import BlockstackCoreApi_iOS

class OnboardingRestoreController: UIViewController {
    
    @IBOutlet var passwordText : UITextField!
    @IBOutlet var confirmationText : UITextField!
    @IBOutlet var passphraseText : UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard)))
        passphraseText.text = ""
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func hideKeyboard()
    {
        passphraseText.resignFirstResponder()
    }
    

    @IBAction func backPressed()
    {
        navigationController!.popViewController(animated: true)
    }
    
    @IBAction func continuePressed()
    {
        if let pass = passwordText.text, pass.characters.count > 0, pass == confirmationText.text
        {
            //clear any old data before we save the new
            UserDataService.shared().logout()
            
            if let passphrase = passphraseText.text, CryptoUtils.shared().validatePassphrase(passphrase) == true,
                UserDataService.shared().savePrivateKeyPhrase(passphrase, with: pass) == true
            {
                accountRestored()
            }else{
                UIAlertController.showAlert(withTitle: "Invalid Entry", andMessage: "You must enter a valid passphrase", from: self)
            }
            
        }else
        {
            UIAlertController.showAlert(withTitle: "Invalid Entry", andMessage: "You must enter a valid password", from: self)
        }
        
    }
    
    func accountRestored()
    {
        dismiss(animated: true, completion: nil)
    }

}
