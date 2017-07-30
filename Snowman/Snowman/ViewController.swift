//
//  ViewController.swift
//  Snowman
//
//  Created by Conrad Stoll on 7/26/17.
//  Copyright © 2017 Conrad Stoll. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTapShareButton() {
        let shareString = "Check out Snowman, the new game I'm playing on my Apple Watch\nhttps://itunes.apple.com/app/id1195676848"
        
        let activityViewController = UIActivityViewController(activityItems: [shareString], applicationActivities: [])
        present(activityViewController, animated: true, completion: nil)
    }
}

