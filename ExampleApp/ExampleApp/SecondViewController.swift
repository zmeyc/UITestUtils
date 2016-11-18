//
//  SecondViewController.swift
//  ExampleApp
//
//  Created by Andrey Fidrya on 04/07/15.
//  Copyright © 2015 Zabiyaka. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var alertButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func alertButtonTouchUpInside(_ sender: AnyObject) {
        textField.endEditing(false)
        
        let alert = UIAlertController(title: "Message", message: textField.text, preferredStyle: .actionSheet)
        if let popover = alert.popoverPresentationController {
            popover.sourceView = alertButton
            popover.sourceRect = alertButton.bounds
        }
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { action in
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }

}

