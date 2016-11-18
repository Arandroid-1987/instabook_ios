//
//  ViewController.swift
//  Instabook
//
//  Created by Leonardo Rania on 16/11/16.
//  Copyright (c) 2016 instabook. All rights reserved.
//

import UIKit


/*class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var Open: UIBarButtonItem!
    var precSearch = "";
    var fromBegin = true;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController?.navigationBar.barTintColor = Constants.myColor ;
        //self.navigationController?.hidesBarsOnSwipe = true;
        
        Open.target = self.revealViewController();
        Open.action = Selector("revealToggle:");
        //Open.action = Selector("rotateImage:");
        
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer());
        
        self.textView.delegate = self;
        self.textView.scrollRangeToVisible(NSMakeRange(0, 0))
        self.textView.text = Constants.placeHolderTextView;
        self.textView.textColor = UIColor.lightGrayColor();
        
        self.textView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
        self.textView.layer.borderWidth = 1.0
        self.textView.layer.cornerRadius = 5
        self.textView.tintColor = UIColor.yellowColor()
        //self.textView.contentInset = UIEdgeInsetsMake(-30.0,0.0,0,0.0);
        
        self.textFieldAutore.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
        self.textFieldAutore.layer.borderWidth = 1.0
        self.textFieldAutore.layer.cornerRadius = 5
        self.textFieldAutore.tintColor = UIColor.yellowColor()
        
        self.precSearch = Constants.placeHolderTextView;
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.textView.setContentOffset(CGPointZero, animated: false)
    }
    
    let players = ["Player1","Player2"] //players added till now
    let numberOfCells = 5
    
    //Here you set the number of cell in your collectionView
       
    func textViewDidEndEditing(textView: UITextView) {
        if(textView.text.isEmpty)
        {
            self.fromBegin = true;
            self.textView.text = Constants.placeHolderTextView;
            self.textView.textColor = UIColor.lightGrayColor();
            self.fromBegin = false;
        }
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if(self.textView.textColor == UIColor.lightGrayColor() && !self.textView.text.isEmpty)
        {
            self.fromBegin = true;
            self.textView.text = "";
            self.textView.textColor = UIColor.whiteColor();
            self.textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
            self.fromBegin = false;
        }
        return true;
    }
    
    func textViewDidChangeSelection(_textView: UITextView) {
        
        if(!fromBegin)
        {
            if(textView.text.isEmpty)
            {
                self.fromBegin = true;
                self.textView.text = Constants.placeHolderTextView;
                self.textView.textColor = UIColor.lightGrayColor();
                self.textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
                self.fromBegin = false;

                
            }
            else if(textView.textColor == UIColor.lightGrayColor() && self.precSearch == Constants.placeHolderTextView && self.textView.text.length < Constants.placeHolderTextView.length )
            {
                self.fromBegin = true;
                self.textView.text = Constants.placeHolderTextView;
                self.precSearch = Constants.placeHolderTextView;
                self.textView.textColor = UIColor.lightGrayColor();
                self.textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
                self.fromBegin = false;
                
            }
            else if(textView.textColor == UIColor.lightGrayColor())
            {
                self.fromBegin = true;
                self.textView.text = self.textView.text.stringByReplacingOccurrencesOfString(Constants.placeHolderTextView, withString: "");
                self.precSearch = Constants.placeHolderTextView;
                self.textView.textColor = UIColor.whiteColor();
                self.fromBegin = false;
            }
        }
        
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5;
    }
    
    override func tableV
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func rotateImage(sender: AnyObject) {
        Open.image = Open.image?.imageRotatedByDegrees(90, flip: false);
    }

    @IBOutlet var searchCitazione: UIButton!
    @IBAction func searchCitazione(sender: AnyObject)
    {
        var citazione:NSString = self.textView.text.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        var autore:NSString = self.textFieldAutore.text.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        if(self.textView.textColor != UIColor.whiteColor() || citazione.isEqualToString(""))
        {
            var alertView:UIAlertView = UIAlertView();
            alertView.title = "Dati Mancanti!";
            alertView.message = "Inserisci la citazione che vuoi cercare";
            alertView.delegate = self;
            alertView.addButtonWithTitle("OK");
            alertView.show();
        }
        else
        {
            var url:NSURL ;
            if(!autore.isEqualToString(""))
            {
                url = NSURL(string: "https://www.googleapis.com/books/v1/volumes?q=\(citazione)+inauthor:\(autore)")!;
            }
            else
            {
                url = NSURL(string: "https://www.googleapis.com/books/v1/volumes?q=\(citazione)+inauthor:")!;
            }
            var request:NSMutableURLRequest = NSMutableURLRequest(URL: url);
            request.HTTPMethod = "GET";
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type");
            request.setValue("application/json", forHTTPHeaderField: "Accept");
            var reponseError: NSError?;
            var response: NSURLResponse?;
            var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError);
            if(urlData != nil)
            {
                var responseData:NSString = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!;
                NSLog("Response ==> %@", responseData);
            }
        }
    }
}
*/
