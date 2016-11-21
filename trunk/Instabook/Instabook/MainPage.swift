//
//  MainPage.swift
//  Instabook
//
//  Created by Leonardo Rania on 18/11/16.
//  Copyright (c) 2016 instabook. All rights reserved.
//

import Foundation
import UIKit

public class MainPage: UITableViewController
{

    var floatingButton : UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
    var positionFloatingButton: CGFloat = 0.0
    var bookArray = [Any]();
    @IBOutlet var Open: UIBarButtonItem!
    @IBOutlet var textFieldCitazione: UITextField!
    public override func viewDidLoad() {
        super.viewDidLoad();
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        self.tableView.registerNib(UINib(nibName: "CellCustom", bundle: nil), forCellReuseIdentifier: "rowTable");
        //self.tableView.rowHeight = 250;
        self.tableView.estimatedRowHeight = 300.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController?.navigationBar.barTintColor = Constants.myColor ;
        
        Open.target = self.revealViewController();
        Open.action = Selector("revealToggle:");
        //Open.action = Selector("rotateImage:");
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer());
        
        loadNews();
    
        
    }
    
    public override func scrollViewDidScroll(scrollView: UIScrollView) {
        floatingButton.frame = CGRectMake(40, 60, 100, 24)
        let cellHeight: CGFloat = 44.0
        positionFloatingButton = tableView.bounds.height + scrollView.contentOffset.y - 50;
        floatingButton.center = CGPoint(x: view.bounds.width - 100, y: positionFloatingButton)
        floatingButton.backgroundColor = UIColor.redColor()
        floatingButton.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        floatingButton.setTitle("Click Me !", forState: UIControlState.Normal)
        self.tableView.addSubview(floatingButton)
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            floatingButton.frame = CGRectMake(40, 60, 100, 24)
            let cellHeight: CGFloat = 44.0
            positionFloatingButton = positionFloatingButton - keyboardSize.height
            floatingButton.center = CGPoint(x: view.bounds.width - 100 , y: positionFloatingButton )
            floatingButton.backgroundColor = UIColor.redColor()
            floatingButton.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            floatingButton.setTitle("Click Me !", forState: UIControlState.Normal)
            self.tableView.addSubview(floatingButton)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            floatingButton.frame = CGRectMake(40, 60, 100, 24)
            let cellHeight: CGFloat = 44.0
            positionFloatingButton = positionFloatingButton + keyboardSize.height
            floatingButton.center = CGPoint(x: view.bounds.width - 100 , y: positionFloatingButton )
            floatingButton.backgroundColor = UIColor.redColor()
            floatingButton.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            floatingButton.setTitle("Click Me !", forState: UIControlState.Normal)
            self.tableView.addSubview(floatingButton)
        }
    }
    
    private func loadNews()
    {
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        
        
        dispatch_async(backgroundQueue, {
            
            var mondadoriParserNews = MondadoriParser();
            mondadoriParserNews.setUrlNovita(Constants.URL_NOVITA_BASE);
            self.bookArray = mondadoriParserNews.parse(Constants.NEWS);
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.tableView.reloadData();
                
            })
            
        })
    }

    
    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if (bookArray.count % 2 == 0  )
        {
            return self.bookArray.count / 2;
        }
        else
        {
            return (self.bookArray.count / 2) + 1;
        }
    }
    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("rowTable", forIndexPath: indexPath) as CellCustom
        
        //Configure CardViewLeft
        let tapCuoreLeft = UITapGestureRecognizer(target:self, action:Selector("connected:"))
        cell.cuoreCardViewLeft.addGestureRecognizer(tapCuoreLeft)
        cell.cuoreCardViewLeft.tag = indexPath.row
        
        var tapCardViewLeft = UITapGestureRecognizer(target: self, action: Selector("connected2:"))
        cell.cardViewLeft.addGestureRecognizer(tapCardViewLeft)
        cell.cardViewLeft.tag = indexPath.row
        
        let tapSharedLeft = UITapGestureRecognizer(target:self, action:Selector("connected1:"))
        cell.sharedCardViewLeft.addGestureRecognizer(tapSharedLeft)
        cell.sharedCardViewLeft.tag = indexPath.row
        
        //Configure CardViewRight
        let tapCuoreRight = UITapGestureRecognizer(target:self, action:Selector("connected:"))
        cell.cuoreCardViewRight.addGestureRecognizer(tapCuoreRight)
        cell.cuoreCardViewRight.tag = indexPath.row
        
        let tapCardViewRight = UITapGestureRecognizer(target: self, action: Selector("connected2:"))
        cell.cardViewRight.addGestureRecognizer(tapCardViewRight)
        cell.cardViewRight.tag = indexPath.row
        
        let tapSharedRight = UITapGestureRecognizer(target:self, action:Selector("connected1:"))
        cell.sharedCardViewRight.addGestureRecognizer(tapSharedRight)
        cell.sharedCardViewRight.tag = indexPath.row
        
        //DRAW INFORMATION ON CARD VIEW
        if (bookArray.count % 2 == 0  )
        {
           
            //TITLE LEFT AND RIGHT
            //cell.titoloCardViewLeft.sizeToFit();
            cell.titoloCardViewLeft.text = (bookArray[(indexPath.row*2)] as Book).title
            //cell.titoloCardViewRight.sizeToFit();
            cell.titoloCardViewRight.text = (bookArray[(indexPath.row*2)+1] as Book).title
            
            //PRICE LEFT AND RIGHT
            cell.prezzoCardViewLeft.text = (bookArray[(indexPath.row*2)] as Book).price + " €"
            cell.prezzoCardViewRight.text = (bookArray[(indexPath.row*2)+1] as Book).price + " €"
            
           
        }
        else
        {
            if (self.tableView.numberOfRowsInSection(self.tableView.numberOfSections() - 1) == indexPath.row)
            {
                //TITLE LEFT AND RIGHT
                cell.titoloCardViewLeft.text = (bookArray[indexPath.row*2] as Book).title
                cell.titoloCardViewRight.text = (bookArray[(indexPath.row*2)+1] as Book).title
                
            }
            else
            {
                //TITLE LEFT AND RIGHT
                cell.titoloCardViewLeft.text = (bookArray[indexPath.row*2] as Book).title
                cell.titoloCardViewRight.text = (bookArray[(indexPath.row*2)+1] as Book).title
                
                //PRICE LEFT AND RIGHT
                cell.prezzoCardViewLeft.text = (bookArray[indexPath.row*2] as Book).price + " €"
                cell.prezzoCardViewRight.text = (bookArray[(indexPath.row*2)+1] as Book).price + " €"
            }
        }
        
        
        //DOWNLOAD IMAGE
        var urlStringLeft:String? = Constants.MONDADORI_BASE_URL + ((bookArray[indexPath.row*2] as Book).imgLink) as String
        if(urlStringLeft != nil)
        {
            var imgURL: NSURL = NSURL(string: urlStringLeft!)!
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(
                request, queue: NSOperationQueue.mainQueue(),
                completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                    if error == nil {
                        cell.copertinaCardViewLeft.image = UIImage(data: data)
                    }
            })
        }
        
        var urlStringRight:String? = Constants.MONDADORI_BASE_URL + ((bookArray[(indexPath.row*2)+1] as Book).imgLink) as String
        if(urlStringRight != nil)
        {
            var imgURL: NSURL = NSURL(string: urlStringRight!)!
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(
                request, queue: NSOperationQueue.mainQueue(),
                completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                    if error == nil {
                        cell.copertinaCardViewRight.image = UIImage(data: data)
                    }
            })
        }
        
        
        cell.layoutIfNeeded();
        
        return cell;
    }
    
    func connected(sender: UITapGestureRecognizer!) {
        
        println(sender.description)
    }
    
    func connected1(sender: UITapGestureRecognizer!) {
        
        println(sender.description)
    }
    
    func connected2(sender: UITapGestureRecognizer!) {
        
        println("tap")
    }
    

}