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

    
    var positionFloatingButton: CGFloat = 0.0
    var bookArray = [Any]();
    var keyboardOpened = false;
    var keyboardHeight: CGFloat = 0.0;
    let floatingButton : UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
    
    @IBOutlet var Open: UIBarButtonItem!
    @IBOutlet var textFieldCitazione: UITextField!
    public override func viewDidLoad() {
        super.viewDidLoad();
        
        floatingButton.frame = CGRectMake(40, 40, 80, 80)
        floatingButton.layer.cornerRadius = 0.5 * floatingButton.bounds.size.width
        floatingButton.setImage(UIImage(named:"fulmine.png"), forState: .Normal)
        floatingButton.backgroundColor = UIColor.yellowColor()
        floatingButton.addTarget(self, action: "buttonClicked", forControlEvents: UIControlEvents.TouchUpInside)
        
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
    
    public override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        positionFloatingButton = size.height - 60;
        if(keyboardOpened)
        {
            positionFloatingButton -= keyboardHeight
        }
        self.tableView.addSubview(Utils.createFloatingButton(floatingButton, viewWidht: size.width, position: positionFloatingButton))
    }
        
    public override func scrollViewDidScroll(scrollView: UIScrollView) {

        positionFloatingButton = view.bounds.height + scrollView.contentOffset.y;
        if(keyboardOpened)
        {
            positionFloatingButton -= keyboardHeight
        }
        self.tableView.addSubview(Utils.createFloatingButton(floatingButton, viewWidht: view.bounds.width, position: positionFloatingButton))
        
    }
    
    //ACTION WHEN CLICK THE FLOATING BUTTON
    func buttonClicked()
    {
        var citazione:NSString = self.textFieldCitazione.text!
        var autore:NSString = self.textFieldCitazione.text!;
        //self.textView.textColor != UIColor.whiteColor() ||
        if(citazione.isEqualToString(""))
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
            let qualityOfServiceClass = QOS_CLASS_BACKGROUND
            
            let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
            
            
            dispatch_async(backgroundQueue, {
                
                GoogleBook.searchCitanzione(citazione, authorFromMainPage: autore);
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.tableView.reloadData();
                    
                })
                
            })
            
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        {
            keyboardHeight = keyboardSize.height
            keyboardOpened = true
            positionFloatingButton = positionFloatingButton - keyboardSize.height
            self.tableView.addSubview(Utils.createFloatingButton(floatingButton, viewWidht: view.bounds.width, position: positionFloatingButton))
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        {
            keyboardHeight = 0.0
            keyboardOpened = false;
            positionFloatingButton = positionFloatingButton + keyboardSize.height
            self.tableView.addSubview(Utils.createFloatingButton(floatingButton, viewWidht: view.bounds.width, position: positionFloatingButton))
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
        let tapCuoreLeft = UITapGestureRecognizer(target:self, action:Selector("heartLeftCardView:"))
        cell.cuoreCardViewLeft.addGestureRecognizer(tapCuoreLeft)
        cell.cuoreCardViewLeft.tag = indexPath.row
        
        var tapCardViewLeft = UITapGestureRecognizer(target: self, action: Selector("goToDetailsLeft:"))
        cell.cardViewLeft.addGestureRecognizer(tapCardViewLeft)
        cell.cardViewLeft.tag = indexPath.row
        
        let tapSharedLeft = UITapGestureRecognizer(target:self, action:Selector("sharedLeftCardView:"))
        cell.sharedCardViewLeft.addGestureRecognizer(tapSharedLeft)
        cell.sharedCardViewLeft.tag = indexPath.row
        
        //Configure CardViewRight
        let tapCuoreRight = UITapGestureRecognizer(target:self, action:Selector("heartRightCardView:"))
        cell.cuoreCardViewRight.addGestureRecognizer(tapCuoreRight)
        cell.cuoreCardViewRight.tag = indexPath.row
        
        let tapCardViewRight = UITapGestureRecognizer(target: self, action: Selector("goToDetailsRight:"))
        cell.cardViewRight.addGestureRecognizer(tapCardViewRight)
        cell.cardViewRight.tag = indexPath.row
        
        let tapSharedRight = UITapGestureRecognizer(target:self, action:Selector("sharedRightCardView:"))
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
    
    //PRESS BUTTON SHARED LEFT CARD
    func sharedLeftCardView(sender: UITapGestureRecognizer)
    {
        if let button = sender.view as? UIImageView {
            var bookPressed: Book = self.bookArray[2*button.tag] as Book
            var strinShared = Constants.SHARED + bookPressed.title + " - " + bookPressed.link
            let vc = UIActivityViewController(activityItems: [strinShared], applicationActivities: [])
            vc.popoverPresentationController?.sourceView = self.view;
            self.presentViewController(vc, animated: true, completion: nil)
        }

    }
    
    
    //PRESS BUTTON SHARED RIGHT CARD
    func sharedRightCardView(sender: UITapGestureRecognizer)
    {
        if let button = sender.view as? UIImageView {
            var bookPressed: Book = self.bookArray[(2*button.tag)+1] as Book
            var stringShared = Constants.SHARED + bookPressed.title + " - " + bookPressed.link
            let vc = UIActivityViewController(activityItems: [stringShared], applicationActivities: [])
            vc.popoverPresentationController?.sourceView = self.view;
            self.presentViewController(vc, animated: true, completion: nil)
        }

    }
    
    //PRESS HEART RIGHT
    func heartRightCardView(sender: UITapGestureRecognizer!) {
        if let button = sender.view as? UIImageView {
                button.image = UIImage(named:"heart-full.png")
        }
    }
    
    //PRESS HEART LEFT
    func heartLeftCardView(sender: UITapGestureRecognizer!) {
        if let button = sender.view as? UIImageView {

                button.image = UIImage(named:"heart-full.png")
            
            
        }
    }
    
    //PRESS CARDVIEW RIGHT
    func goToDetailsRight(sender: UITapGestureRecognizer!) {
        /*TODO
        
        self.navigationController?.pushViewController(vc, animated: true)
        */
    }
    
    //PRESS CARDVIEW LEFT
    func goToDetailsLeft(sender: UITapGestureRecognizer!) {
        /*let vc = UIActivityViewController(activityItems: [], applicationActivities: [])
        self.navigationController?.pushViewController(vc, animated: true)
        */
        
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("TODO")
    }
    

}