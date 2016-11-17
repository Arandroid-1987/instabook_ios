//
//  ViewController.swift
//  Instabook
//
//  Created by Leonardo Rania on 16/11/16.
//  Copyright (c) 2016 instabook. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var Open: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController?.navigationBar.barTintColor=UIColor.blueColor();
        self.navigationController?.hidesBarsOnSwipe = true;
        
        Open.target = self.revealViewController();
        Open.action = Selector("revealToggle:");
        //Open.action = Selector("rotateImage:");
        
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer());
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func rotateImage(sender: AnyObject) {
        Open.image = Open.image?.imageRotatedByDegrees(90, flip: false);
    }

}

