//
//  MainPage.swift
//  Instabook
//
//  Created by Leonardo Rania on 18/11/16.
//  Copyright (c) 2016 instabook. All rights reserved.
//

import Foundation
import UIKit



public class MainPage: UITableViewController, UITextViewDelegate, UITextFieldDelegate

{
    var positionFloatingButton: CGFloat = 0.0
    var bookArray = [Any]();
    var cacheManager = CacheManager()
    var pastUrls = Array<String>()
    var autocompleteUrls = Array<String>()
    
    var pastUrls2 = Array<String>()
    var autocompleteUrls2 = Array<String>()
    var databaseFirebase = DatabaseRealtime()
   

    @IBOutlet weak var citazioneTextView: UITextView!
    @IBOutlet weak var microphoneButton: UIButton!
    
    
    var keyboardOpened = false;
    var keyboardHeight: CGFloat = 0.0;
    let floatingButton : UIButton = UIButton(type: UIButtonType.Custom) as UIButton
    

    @IBOutlet var Open: UIBarButtonItem!
    @IBOutlet weak var autoreTextField: UITextField!
    
    var autocompleteTableView = UITableView()
    var autocompleteTableView2 = UITableView()
    

    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadNews()
        self.tableView.reloadData()
        if(cacheManager.getUUID() == "")
        {
            cacheManager.storeUUID(UIDevice.currentDevice().identifierForVendor!.UUIDString);
        }
    }
    
    
    
    public override func viewDidLoad() {
        super.viewDidLoad();
        
        pastUrls = self.cacheManager.getAllSerach(Constants.ID_SEARCH_AUTORE)
        pastUrls2 = self.cacheManager.getAllSerach(Constants.ID_SEARCH_CITAZIONE)
        
        autocompleteTableView = UITableView(frame: CGRectMake(8,autoreTextField.frame.origin.y + autoreTextField.frame.height,self.view.frame.width-24,40), style: UITableViewStyle.Plain)
        
        autocompleteTableView.delegate = self
        
        autocompleteTableView.dataSource = self
        
        autocompleteTableView.scrollEnabled = true
        
        autocompleteTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        autocompleteTableView.hidden = true
        
        autocompleteTableView.dequeueReusableCellWithIdentifier("AutoCompleteRowIdentifier")
        
        self.tableView.addSubview(autocompleteTableView)
        
        autocompleteTableView2 = UITableView(frame: CGRectMake(8,citazioneTextView.frame.origin.y + citazioneTextView.frame.height,self.view.frame.width-24,40), style: UITableViewStyle.Plain)
        
        autocompleteTableView2.delegate = self
        
        autocompleteTableView2.dataSource = self
        
        autocompleteTableView2.scrollEnabled = true
        
        autocompleteTableView2.separatorStyle = UITableViewCellSeparatorStyle.None
        
        autocompleteTableView2.hidden = true
        
        autocompleteTableView2.dequeueReusableCellWithIdentifier("AutoCompleteRowIdentifier2")
        
        self.tableView.addSubview(autocompleteTableView2)
        
        self.citazioneTextView.delegate = self;
        self.citazioneTextView.scrollRangeToVisible(NSMakeRange(0, 0))
        self.citazioneTextView.text = Constants.placeHolderTextView;
        self.citazioneTextView.textColor = UIColor.lightGrayColor();

        floatingButton.frame = CGRectMake(40, 40, 60, 60)
        floatingButton.layer.cornerRadius = 0.5 * floatingButton.bounds.size.width
        floatingButton.setImage(UIImage(named:"fulmine.png"), forState: .Normal)
        floatingButton.clipsToBounds = true;
        floatingButton.backgroundColor = UIColor(red: 255.0/255, green: 217.0/255, blue: 3.0/255, alpha: 1.0)
        floatingButton.addTarget(self, action: #selector(MainPage.buttonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        floatingButton.layer.shadowOffset = CGSizeMake(0.1, 1.0);
        floatingButton.layer.shadowOpacity = 0.2;
        floatingButton.layer.shadowRadius = 0.0;
        
        microphoneButton.addTarget(self, action: #selector(MainPage.microphoneClicked), forControlEvents: UIControlEvents.TouchUpInside)
        microphoneButton.hidden = true
       
       
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainPage.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainPage.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainPage.reloadNews(_:)), name: Constants.RELOAD_NEWS_NOTIFICATION_NAME, object: nil);

        
        self.citazioneTextView.layer.borderColor = Constants.myColor.CGColor
        self.citazioneTextView.layer.borderWidth = 1.0
        //self.citazioneTextView.layer.cornerRadius = 5
        self.citazioneTextView.tintColor = UIColor.yellowColor()
        //self.textView.contentInset = UIEdgeInsetsMake(-30.0,0.0,0,0.0);
        self.autoreTextField.delegate = self
        self.autoreTextField.layer.borderColor = Constants.myColor.CGColor
        self.autoreTextField.layer.borderWidth = 1.0
        //self.autoreTextField.layer.cornerRadius = 5
        self.autoreTextField.tintColor = UIColor.yellowColor()

        
        var placeHolder = NSMutableAttributedString()
        let Name  = NSLocalizedString("optional_input_author_to_search", comment: "optional_input_author_to_search")
        placeHolder = NSMutableAttributedString(string:Name, attributes: [NSFontAttributeName:citazioneTextView.font!])
        placeHolder.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range:NSRange(location:0,length:Name.characters.count))
        autoreTextField.attributedPlaceholder = placeHolder
        

        self.tableView.registerNib(UINib(nibName: "CellCustom", bundle: nil), forCellReuseIdentifier: "rowTable");
        //self.tableView.rowHeight = 250;
        self.tableView.estimatedRowHeight = 300.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController?.navigationBar.barTintColor = Constants.myColor ;
        
        
        Open.target = self.revealViewController();
        Open.action = #selector(SWRevealViewController.revealToggle(_:));
        
        //Open.action = Selector("rotateImage:");
        
        //let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
        //self.view.addGestureRecognizer(gesture)
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer());
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer());
        let border1 = CALayer()
        let width1 = CGFloat(2.0)
        
        border1.borderColor = UIColor.whiteColor().CGColor
        border1.frame = CGRect(x: 0, y: citazioneTextView.frame.size.height - width1, width:  citazioneTextView.frame.size.width, height: citazioneTextView.frame.size.height)
        
        border1.borderWidth = width1
        citazioneTextView.layer.addSublayer(border1)
        citazioneTextView.layer.masksToBounds = true
        
        let border2 = CALayer()
        let width2 = CGFloat(2.0)
        border2.borderColor = UIColor.whiteColor().CGColor
        border2.frame = CGRect(x: 0, y: autoreTextField.frame.size.height - width2, width:  autoreTextField.frame.size.width, height: autoreTextField.frame.size.height)
        
        border2.borderWidth = width2
        autoreTextField.layer.addSublayer(border2)
        autoreTextField.layer.masksToBounds = true

        
        //loadNews();
    
        
    }

    public func textViewDidBeginEditing(textView: UITextView) {
        self.autocompleteTableView.hidden = true
        self.revealViewController().rightRevealToggle(nil)
        let border2 = CALayer()
        let width2 = CGFloat(2.0)
        border2.borderColor = UIColor.yellowColor().CGColor
        border2.frame = CGRect(x: 0, y: textView.frame.size.height - width2, width:  textView.frame.size.width, height: textView.frame.size.height)
        
        
        border2.borderWidth = width2
        textView.layer.addSublayer(border2)
        textView.layer.masksToBounds = true
    }
    
    public func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        
        if(textView.textColor != UIColor.whiteColor()){
            textView.text = "";
            textView.textColor = UIColor.whiteColor();
        }

    
       return true;
    }
    
    public func textViewDidChange(textView: UITextView) {
    
        if(textView.text.length == 0){
                textView.textColor = UIColor.lightGrayColor();
                textView.text = NSLocalizedString("input_text_to_search", comment: "input_text_to_search");
                textView.resignFirstResponder()
    
        }
    }
    
    public func textViewDidEndEditing(textView: UITextView) {
        autocompleteTableView2.hidden = true
        let border2 = CALayer()
        let width2 = CGFloat(2.0)
        border2.borderColor = UIColor.whiteColor().CGColor
        border2.frame = CGRect(x: 0, y: textView.frame.size.height - width2, width:  textView.frame.size.width, height: textView.frame.size.height)
        
        
        border2.borderWidth = width2
        textView.layer.addSublayer(border2)
        textView.layer.masksToBounds = true
    
        if(textView.text.length == 0){
                textView.textColor = UIColor.lightGrayColor();
                textView.text = NSLocalizedString("input_text_to_search", comment: "input_text_to_search");
            
        }
    }
    
    public func textFieldDidBeginEditing(textField: UITextField) {
        self.autocompleteTableView2.hidden = true
        self.revealViewController().rightRevealToggle(nil)
        let border2 = CALayer()
        let width2 = CGFloat(2.0)
        border2.borderColor = UIColor.yellowColor().CGColor
        border2.frame = CGRect(x: 0, y: textField.frame.size.height - width2, width:  textField.frame.size.width, height: textField.frame.size.height)
        
        border2.borderWidth = width2
        autoreTextField.layer.addSublayer(border2)
        autoreTextField.layer.masksToBounds = true
    }

    public func textFieldDidEndEditing(textField: UITextField) {
        autocompleteTableView.hidden = true
        let border2 = CALayer()
        let width2 = CGFloat(2.0)
        border2.borderColor = UIColor.whiteColor().CGColor
        border2.frame = CGRect(x: 0, y: textField.frame.size.height - width2, width:  textField.frame.size.width, height: textField.frame.size.height)
        
        border2.borderWidth = width2
        textField.layer.addSublayer(border2)
        textField.layer.masksToBounds = true
    }
    
    


    public override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        positionFloatingButton = size.height - 60;
        if(keyboardOpened)
        {
            positionFloatingButton -= keyboardHeight
        }
       
        floatingButton.layer.shadowOffset = CGSizeMake(0.1, 1.0);
        floatingButton.layer.shadowOpacity = 0.2;
        floatingButton.layer.shadowRadius = 0.0;
        self.tableView.addSubview(Utils.createFloatingButton(floatingButton, viewWidht: size.width, position: positionFloatingButton))
        

        
    }
        

    public override func scrollViewDidScroll(scrollView: UIScrollView) {

        if(scrollView != autocompleteTableView && scrollView != autocompleteTableView2){
        autocompleteTableView.hidden = true
        autocompleteTableView2.hidden = true

        positionFloatingButton = view.bounds.height + scrollView.contentOffset.y;
        if(keyboardOpened)
        {
            positionFloatingButton -= keyboardHeight
        }
        floatingButton.layer.shadowOffset = CGSizeMake(0.1, 1.0);
        floatingButton.layer.shadowOpacity = 0.2;
        floatingButton.layer.shadowRadius = 0.0;
        self.tableView.addSubview(Utils.createFloatingButton(floatingButton, viewWidht: view.bounds.width, position: positionFloatingButton))
        }

    }
    
    //ACTION WHEN CLICK THE FLOATING BUTTON
    func buttonClicked()
    {
        autocompleteTableView.hidden = true
        autocompleteTableView2.hidden = true
        if Reachability.isConnectedToNetwork() == true
        {
            var citazione:NSString = self.citazioneTextView.text!
            let autore:NSString = self.autoreTextField.text!;
        
            //self.textView.textColor != UIColor.whiteColor() ||
            if((citazioneTextView.textColor?.isEqual(UIColor.lightGrayColor()))!)
            {
                citazione = ""
            }
        
            //self.textView.textColor != UIColor.whiteColor() ||
            if((citazione.isEqualToString("") || (citazioneTextView.textColor?.isEqual(UIColor.lightGrayColor()))!) && autore.isEqualToString(""))
            {
            
                self.autoreTextField.resignFirstResponder()
                self.citazioneTextView.resignFirstResponder()
                let snackbar = MKSnackbar(
                    withTitle: NSLocalizedString("fill_at_least_one", comment: "fill_at_least_one"),
                    withDuration: 1.5,
                    withTitleColor: nil,
                    withActionButtonTitle: "",
                    withActionButtonColor: UIColor.lightGrayColor())
                snackbar.show()
            
            }
            else
            {
                self.tableView.reloadData();
                self.autoreTextField.text = ""
                if(self.citazioneTextView.textColor == UIColor.whiteColor()){
                    self.citazioneTextView.textColor = UIColor.lightGrayColor();
                    self.citazioneTextView.text =  NSLocalizedString("input_text_to_search", comment: "input_text_to_search");
                }
                self.citazioneTextView.resignFirstResponder()
                self.autoreTextField.resignFirstResponder()
                self.floatingButton.layer.shadowOffset = CGSizeMake(0.1, 1.0);
                self.floatingButton.layer.shadowOpacity = 0.2;
                self.floatingButton.layer.shadowRadius = 0.0;
                //self.citazioneTextView.becomeFirstResponder()
                self.tableView.addSubview(Utils.createFloatingButton(self.floatingButton, viewWidht: self.view.frame.width, position: self.view.frame.height-64))
            
                let activitiyViewController = LoadingView(message: NSLocalizedString("searching", comment: "searching"))
                self.presentViewController(activitiyViewController, animated: true, completion: nil)
            
            
                let qualityOfServiceClass = QOS_CLASS_BACKGROUND
            
                let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
                
            
                dispatch_async(backgroundQueue, {
                
                    let bookArray = GoogleBook.searchCitanzione(citazione as String, authorFromMainPage: autore as String);
                    if(bookArray.count > 0){
                        let b = Books()
                        b.array = bookArray
                        Data.sharedInstance().dict.setValue( b, forKey: "GoogleBooks")
                        Data.sharedInstance().dict.setValue(citazione, forKey: "Titolo")
                    }
                
                
                    dispatch_async(backgroundQueue, { () -> Void in
                    
                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("BooksView") as UIViewController
                        activitiyViewController.dismissViewControllerAnimated(true, completion: {() -> Void in
                                self.presentViewController(viewController, animated: true, completion: nil)
                        });
                    
                    })
                
                })
            
            }
        }
        else
        {
            self.autoreTextField.resignFirstResponder()
            self.citazioneTextView.resignFirstResponder()
            let snackbar = MKSnackbar(
                withTitle: NSLocalizedString("connection_unavailable", comment: "connection_unavailable"),
                withDuration: nil,
                withTitleColor: nil,
                withActionButtonTitle: "",
                withActionButtonColor: UIColor.lightGrayColor())
            snackbar.show()
        }
    }
    
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if(keyboardOpened)
        {
            return;
        }
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        {
            keyboardHeight = keyboardSize.height
            keyboardOpened = true

            positionFloatingButton = positionFloatingButton - keyboardSize.height

            
            floatingButton.layer.shadowOffset = CGSizeMake(0.1, 1.0);
            floatingButton.layer.shadowOpacity = 0.2;
            floatingButton.layer.shadowRadius = 0.0;
            self.tableView.addSubview(Utils.createFloatingButton(floatingButton, viewWidht: view.bounds.width, position: positionFloatingButton))
            

        }
    }
    
    func keyboardWillHide(notification: NSNotification) {

        if(!keyboardOpened)
        {
            return;
        }
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        {
            keyboardHeight = 0.0
            keyboardOpened = false;

            positionFloatingButton = positionFloatingButton + keyboardSize.height
            
            floatingButton.layer.shadowOffset = CGSizeMake(0.1, 1.0);
            floatingButton.layer.shadowOpacity = 0.2;
            floatingButton.layer.shadowRadius = 0.0;
            self.tableView.addSubview(Utils.createFloatingButton(floatingButton, viewWidht: view.bounds.width, position: positionFloatingButton))
            

        }
    }
    
    private func loadNews()
    {
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        
        
        dispatch_async(backgroundQueue, {
            
            let todaysDate:NSDate = NSDate()
            let dateFormatter:NSDateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"

            if(self.cacheManager.getLastDateUpdate() == "" || self.cacheManager.getLastDateUpdate() != dateFormatter.stringFromDate(todaysDate))
            {
                self.cacheManager.deleteNews();
                let firebaseParse = RetriveNews()
                self.bookArray = firebaseParse.retriveNews("IT");
                
                
            }
            else
            {
                self.bookArray = self.cacheManager.getBooks()
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.tableView.reloadData();
                
            })
            
        })
    }

    func reloadNews(notification: NSNotification)
    {
        bookArray = self.cacheManager.getBooks();
        self.tableView.reloadData();
    }

    override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView == autocompleteTableView){
        
        let selectedCell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        autoreTextField.text = selectedCell.textLabel!.text
        
        autocompleteTableView.hidden = true
        }
        
        if(tableView == autocompleteTableView2){
            
            let selectedCell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
            
            citazioneTextView.text = selectedCell.textLabel!.text
            
            autocompleteTableView2.hidden = true
        }
    }
    

    
    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(tableView == autocompleteTableView){
            return autocompleteUrls.count
        }else
        if(tableView == autocompleteTableView2){
        return autocompleteUrls2.count
        }else{
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
    }
    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if (tableView == autocompleteTableView2 ){
            
            let autoCompleteRowIdentifier = "AutoCompleteRowIdentifier2"
            
            let cell = UITableViewCell(style: UITableViewCellStyle.Default , reuseIdentifier: autoCompleteRowIdentifier)
            
            
            let index = indexPath.row as Int
            
            
            
            cell.textLabel!.text = autocompleteUrls2[index]
            
            return cell
            
        }else if (tableView == autocompleteTableView ){
            
            let autoCompleteRowIdentifier = "AutoCompleteRowIdentifier"
            
            let cell = UITableViewCell(style: UITableViewCellStyle.Default , reuseIdentifier: autoCompleteRowIdentifier)

            
                        let index = indexPath.row as Int
            
            
            
            cell.textLabel!.text = autocompleteUrls[index]
            
            return cell
        
        }else{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("rowTable", forIndexPath: indexPath) as! CellCustom
        
        //Configure CardViewLeft
        cell.cuoreCardViewLeft.image = UIImage(named:"instant_book_icon.png")
        let tapCuoreLeft = UITapGestureRecognizer(target:self, action:#selector(MainPage.heartLeftCardView(_:)))
        cell.cuoreCardViewLeft.addGestureRecognizer(tapCuoreLeft)
        cell.cuoreCardViewLeft.tag = indexPath.row*2
        if((bookArray[(indexPath.row*2)] as! Book).favorite)
        {
            cell.cuoreCardViewLeft.image = UIImage(named:"heart-full.png")
        }
        else
        {
            cell.cuoreCardViewLeft.image = UIImage(named:"heart.png")
        }
        

        let tapCardViewLeft = UITapGestureRecognizer(target: self, action: #selector(MainPage.goToDetailsLeft(_:)))

        cell.cardViewLeft.addGestureRecognizer(tapCardViewLeft)
        cell.cardViewLeft.tag = indexPath.row*2
        

        let tapSharedLeft = UITapGestureRecognizer(target:self, action:#selector(MainPage.sharedLeftCardView(_:)))

        cell.sharedCardViewLeft.addGestureRecognizer(tapSharedLeft)
        cell.sharedCardViewLeft.tag = indexPath.row*2
        
        //Configure CardViewRight
        cell.cuoreCardViewRight.image = UIImage(named:"instant_book_icon.png")
        let tapCuoreRight = UITapGestureRecognizer(target:self, action:#selector(MainPage.heartRightCardView(_:)))

        cell.cuoreCardViewRight.addGestureRecognizer(tapCuoreRight)
        cell.cuoreCardViewRight.tag = (indexPath.row*2)+1
        if((bookArray[(indexPath.row*2)+1] as! Book).favorite)
        {
            cell.cuoreCardViewRight.image = UIImage(named:"heart-full.png")
        }
        else
        {
            cell.cuoreCardViewRight.image = UIImage(named:"heart.png")
        }
        
        let tapCardViewRight = UITapGestureRecognizer(target: self, action: #selector(MainPage.goToDetailsRight(_:)))

        cell.cardViewRight.addGestureRecognizer(tapCardViewRight)
        cell.cardViewRight.tag = (indexPath.row*2)+1
        

        let tapSharedRight = UITapGestureRecognizer(target:self, action:#selector(MainPage.sharedRightCardView(_:)))
        cell.sharedCardViewRight.addGestureRecognizer(tapSharedRight)
        cell.sharedCardViewRight.tag = (indexPath.row*2)+1
        
        //DRAW INFORMATION ON CARD VIEW
        if (bookArray.count % 2 == 0  )
        {
           
            //TITLE LEFT AND RIGHT
            //cell.titoloCardViewLeft.sizeToFit();
            cell.titoloCardViewLeft.text = (bookArray[(indexPath.row*2)] as! Book).title as String
            //cell.titoloCardViewRight.sizeToFit();
            cell.titoloCardViewRight.text = (bookArray[(indexPath.row*2)+1] as! Book).title as String
            
            //PRICE LEFT AND RIGHT
            cell.prezzoCardViewLeft.text = (bookArray[(indexPath.row*2)] as! Book).price
            cell.prezzoCardViewRight.text = (bookArray[(indexPath.row*2)+1] as! Book).price
            
           
        }
        else
        {
            if (self.tableView.numberOfRowsInSection(self.tableView.numberOfSections - 1) == indexPath.row)
            {
                //TITLE LEFT AND RIGHT
                cell.titoloCardViewLeft.text = (bookArray[indexPath.row*2] as! Book).title as String
                cell.titoloCardViewRight.text = (bookArray[(indexPath.row*2)+1] as! Book).title as String
                
            }
            else
            {
                //TITLE LEFT AND RIGHT
                cell.titoloCardViewLeft.text = (bookArray[indexPath.row*2] as! Book).title as String
                cell.titoloCardViewRight.text = (bookArray[(indexPath.row*2)+1] as! Book).title as String
                
                //PRICE LEFT AND RIGHT
                cell.prezzoCardViewLeft.text = (bookArray[indexPath.row*2] as! Book).price + " €"
                cell.prezzoCardViewRight.text = (bookArray[(indexPath.row*2)+1] as! Book).price + " €"
            }
        }
        
        
        //DOWNLOAD IMAGE
        let urlStringLeft:String? = ((bookArray[indexPath.row*2] as! Book).imgLink) as String
        if(urlStringLeft != nil)
        {
            if(self.cacheManager.isImageCached(urlStringLeft!))
            {
                cell.copertinaCardViewLeft.image = self.cacheManager.getImageCached(urlStringLeft!)
            }
            else
            {
                let imgURL: NSURL = NSURL(string: urlStringLeft!)!
                let request: NSURLRequest = NSURLRequest(URL: imgURL)
                NSURLConnection.sendAsynchronousRequest(
                    request, queue: NSOperationQueue.mainQueue(),
                    completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
                        if error == nil {
                            cell.copertinaCardViewLeft.image = UIImage(data: data!)
                            self.cacheManager.storeImage(urlStringLeft!, data: data!)
                        }
                })
            }
            
        }
        
        let urlStringRight:String? = ((bookArray[(indexPath.row*2)+1] as! Book).imgLink) as String
        if(urlStringRight != nil)
        {
            if(self.cacheManager.isImageCached(urlStringRight!))
            {
                cell.copertinaCardViewRight.image = self.cacheManager.getImageCached(urlStringRight!)
            }
            else
            {
                let imgURL: NSURL = NSURL(string: urlStringRight!)!
                let request: NSURLRequest = NSURLRequest(URL: imgURL)
                NSURLConnection.sendAsynchronousRequest(
                    request, queue: NSOperationQueue.mainQueue(),
                    completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
                        if error == nil {
                            cell.copertinaCardViewRight.image = UIImage(data: data!)
                            self.cacheManager.storeImage(urlStringRight!, data: data!)
                        }
                })
            }
            
        }
        
        
        cell.layoutIfNeeded();
            
            return cell;
    }
        
    }
    

    //PRESS BUTTON SHARED LEFT CARD
    func sharedLeftCardView(sender: UITapGestureRecognizer)
    {
        autocompleteTableView.hidden = true
        autocompleteTableView2.hidden = true
        self.revealViewController().rightRevealToggle(nil)
        if let button = sender.view as? UIImageView {
            let bookPressed: Book = self.bookArray[button.tag] as! Book
            let strinShared = Constants.SHARED + (bookPressed.title as String) + " - " + bookPressed.link
            let vc = UIActivityViewController(activityItems: [strinShared], applicationActivities: [])
            vc.popoverPresentationController?.sourceView = self.tableView;
            self.presentViewController(vc, animated: true, completion: nil)
        }


    }
    
    
    //PRESS BUTTON SHARED RIGHT CARD
    
    func sharedRightCardView(sender: UITapGestureRecognizer)
    {
        autocompleteTableView.hidden = true
        autocompleteTableView2.hidden = true
        self.revealViewController().rightRevealToggle(nil)
        if let button = sender.view as? UIImageView {
            let bookPressed: Book = self.bookArray[button.tag] as! Book
            let stringShared = Constants.SHARED + (bookPressed.title as String) + " - " + bookPressed.link
            let vc = UIActivityViewController(activityItems: [stringShared], applicationActivities: [])
            vc.popoverPresentationController?.sourceView = self.tableView;
            self.presentViewController(vc, animated: true, completion: nil)
        }

    }
    
    //PRESS HEART RIGHT
    func heartRightCardView(sender: UITapGestureRecognizer!) {
        autocompleteTableView.hidden = true
        autocompleteTableView2.hidden = true
        self.revealViewController().rightRevealToggle(nil)
        if let button = sender.view as? UIImageView {
             if(button.image!.isEqual(UIImage(named: "heart.png")))
             {
                let bookLike = bookArray[button.tag] as! Book
                bookLike.favorite = true
                self.cacheManager.storeLikeBook(bookLike)
                button.image = UIImage(named:"heart-full.png")
             }
             else
             {
                let bookDisLike = bookArray[button.tag] as! Book
                bookDisLike.favorite = false
                self.cacheManager.removeStoreLikeBook(bookDisLike)
                button.image = UIImage(named:"heart.png")
            }
        }
    }
    
    //PRESS HEART LEFT
    func heartLeftCardView(sender: UITapGestureRecognizer!) {
       autocompleteTableView.hidden = true
       autocompleteTableView2.hidden = true
        self.revealViewController().rightRevealToggle(nil)
        if let button = sender.view as? UIImageView {
                if(button.image!.isEqual(UIImage(named: "heart.png")))
                {
                    let bookLike = bookArray[button.tag] as! Book
                    bookLike.favorite = true
                    self.cacheManager.storeLikeBook(bookLike)
                    button.image = UIImage(named:"heart-full.png")
                    
                }
                else
                {
                    let bookDisLike = bookArray[button.tag] as! Book
                    bookDisLike.favorite = false
                    self.cacheManager.removeStoreLikeBook(bookDisLike)
                    button.image = UIImage(named:"heart.png")
                }
            
        }
    }
    
    //PRESS CARDVIEW RIGHT
    func goToDetailsRight(sender: UITapGestureRecognizer!)
    {
        
        autocompleteTableView.hidden = true
        autocompleteTableView2.hidden = true
        self.revealViewController().rightRevealToggle(nil)
        if let button = sender.view as? CardView {
            let bookPressed: Book = self.bookArray[button.tag] as! Book
            databaseFirebase.writeBookClicked(bookPressed, currentCountry: "IT", complexQuery: "")
            Data.sharedInstance().dict.setValue(bookPressed, forKey: "BestSellerBook")
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Book") as UIViewController
            self.presentViewController(viewController, animated: false, completion: nil)
        }

        
        
    }
    
    //PRESS CARDVIEW LEFT
    func goToDetailsLeft(sender: UITapGestureRecognizer!) {
       autocompleteTableView.hidden = true
       autocompleteTableView2.hidden = true
        self.revealViewController().rightRevealToggle(nil)
        /*let vc = UIActivityViewController(activityItems: [], applicationActivities: [])
        self.navigationController?.pushViewController(vc, animated: true)
        */
        if let button = sender.view as?  CardView {
            let bookPressed: Book = self.bookArray[button.tag] as! Book
            databaseFirebase.writeBookClicked(bookPressed, currentCountry: "IT", complexQuery: "")
            Data.sharedInstance().dict.setValue(bookPressed, forKey: "BestSellerBook")
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Book") as UIViewController
            self.presentViewController(viewController, animated: false, completion: nil)

        }

    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("TODO")
    }
    
    /*public override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            print("Ultima Riga")
                
            let snackbar = MKSnackbar(
                withTitle: NSLocalizedString("searching", comment: "searching"),
                withDuration: nil,
                withTitleColor: nil,
                withActionButtonTitle: "",
                withActionButtonColor: UIColor.lightGrayColor())
            snackbar.show()
            
            loadOtherNews(snackbar)
        }
    }*/
    
    //ACTION WHEN CLICK THE MICROPHONE BUTTON
    func microphoneClicked()
    {
        let snackbar = MKSnackbar(
            withTitle: "Che cazzo c'è scritto",
            withDuration: 1.5,
            withTitleColor:nil,
            withActionButtonTitle: "ACQUISTA",
            withActionButtonColor: UIColor.yellowColor())
        snackbar.show()
    }
    
    private func loadOtherNews(snackBar: MKSnackbar)
    {
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        
        
        dispatch_async(backgroundQueue, {
            
            //CHANGE NEXTPAGE VALUE TO SEE SNACKBAR
            let nextPage = "";
            if(nextPage == "")
            {
                snackBar.hidden = true;
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    //let position = self.bookArray.count
                    self.tableView.reloadData();
                    snackBar.hidden = true;
                    
                })
            }
        
            

            
            
        })
    }
    
    public func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }else{
        
            
            autocompleteTableView2.hidden = false
            
            let substring = (citazioneTextView.text! as NSString).stringByReplacingCharactersInRange(range, withString: text)
            
            
            
            searchAutocompleteEntriesWithSubstring2(substring)
        
        }
        return true
    }
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
        
    {
        
        autocompleteTableView.hidden = false
        
        let substring = (autoreTextField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        
        
        searchAutocompleteEntriesWithSubstring(substring)
        
        return true     // not sure about this - could be false
        
    }
    
    
    
    func searchAutocompleteEntriesWithSubstring(substring: String)
        
    {
        
        
        
        autocompleteUrls.removeAll(keepCapacity: false)
        
        for curString in pastUrls
        {
            var myString:NSString! = curString as NSString
            
            if(substring.length > 1){
            
            if(myString.uppercaseString.hasPrefix(substring.uppercaseString))
            
            
            {
                autocompleteUrls.append(curString)
                
            }
            }
        }
        
        if(autocompleteUrls.count == 0)
        {
        autocompleteTableView.hidden = true
        }
        
        var y = CGFloat(autocompleteUrls.count)
        if(y > 3){y = 3}

        autocompleteTableView.frame = CGRectMake(8,autoreTextField.frame.origin.y + autoreTextField.frame.height,self.view.frame.width-24,y*45)
        
        self.autocompleteTableView.reloadData()
        

    }
    
    func searchAutocompleteEntriesWithSubstring2(substring: String)
        
    {
        
        
        
        autocompleteUrls2.removeAll(keepCapacity: false)
        
        for curString in pastUrls2
        {
            var myString:NSString! = curString as NSString
            
            if(substring.length > 1){
                
                if(myString.uppercaseString.hasPrefix(substring.uppercaseString))
                    
                    
                {
                    autocompleteUrls2.append(curString)
                    
                }
            }
        }
        
        if(autocompleteUrls2.count == 0)
        {
            autocompleteTableView2.hidden = true
        }
        
        var y = CGFloat(autocompleteUrls2.count)
        if(y > 3){y = 3}
        autocompleteTableView2.frame = CGRectMake(8,citazioneTextView.frame.origin.y + citazioneTextView.frame.height,self.citazioneTextView.frame.width,y*45)
        
        self.autocompleteTableView2.reloadData()
        
        
    }

   // func someAction(sender:UITapGestureRecognizer){
   //     self.revealViewController().revealToggle(nil)
   // }

}
