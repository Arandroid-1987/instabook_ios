//
//  BooksView.swift
//  Instabook
//
//  Created by Marco Ferraro on 19/11/16.
//  Copyright © 2016 instabook. All rights reserved.
//

import Foundation
import GoogleMobileAds

class BooksView: UIViewController,  UITableViewDelegate, UITableViewDataSource, GADInterstitialDelegate
{
    var nRow = 0
    var titleName = String()
    var bookArray = [Any]();
    
    //ADMOB
    var interstitial: GADInterstitial!
    
    var cacheManager = CacheManager()
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var Back: UIButton!
    @IBOutlet weak var googleView: UIView!
    @IBOutlet weak var backView: UIView!
   
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        if(label.text == NSLocalizedString("my_books", comment: "my_books"))
        {
            bookArray = cacheManager.getMyBooksLikeStored()
        }
        if (titleName != "")
        {
            label.text = titleName
        }
        else
        {
            let tit = Data.sharedInstance().dict.valueForKey("Titolo") as? String
            label.text = tit
        }
    }
    
    //ADMOB
    func createAndLoadInterstitial() -> GADInterstitial {
        let createInterstitial = GADInterstitial(adUnitID: "ca-app-pub-2997805148414323/3221280091")
        createInterstitial.delegate = self;
        let request = GADRequest()
        request.testDevices = ["a737ae7d50e451deeaf23e979b871d29"]
        createInterstitial.loadRequest(request)
        return createInterstitial
    }
    
    //ADMOB
    internal func interstitialDidReceiveAd(ad: GADInterstitial) {
        ad.presentFromRootViewController(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //ADMOB
        if(!cacheManager.getLicense())
        {
            interstitial = createAndLoadInterstitial()
        }
       
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;

        Back.addTarget(self, action: #selector(BooksView.action(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        let tapBackView = UITapGestureRecognizer(target:self, action:#selector(BooksView.action(_:)))
        backView.addGestureRecognizer(tapBackView)
        
        
        self.tableView.registerNib(UINib(nibName: "BookCell", bundle: nil), forCellReuseIdentifier: "rowTable");
        self.tableView.registerNib(UINib(nibName: "SearchBookCell", bundle: nil), forCellReuseIdentifier: "rowTable2");
        self.tableView.registerNib(UINib(nibName: "BookCell", bundle: nil), forCellReuseIdentifier: "rowTable3");
        self.tableView.registerNib(UINib(nibName: "BookCell", bundle: nil), forCellReuseIdentifier: "rowTable4");
        self.tableView.registerNib(UINib(nibName: "SettingsCell", bundle: nil), forCellReuseIdentifier: "rowTable5");
        //self.tableView.rowHeight = 250;
        self.tableView.estimatedRowHeight = 300.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController?.navigationBar.barTintColor = Constants.myColor ;
        self.navigationController?.title = titleName
        
        if(titleName == NSLocalizedString("bestSellers", comment: "bestSellers"))
        {
            googleView.hidden = true
            loadBestSellers()
            
        }
        else if (titleName == NSLocalizedString("my_books", comment: "my_books"))
        {
            googleView.hidden = true
            bookArray = self.cacheManager.getMyBooksLikeStored();
            nRow = bookArray.count
        }
        else if (titleName == NSLocalizedString("mySearches", comment: "mySearches"))
        {
            bookArray = self.cacheManager.getMySearchStored();
            nRow = bookArray.count
        }
        else if (titleName == NSLocalizedString("action_settings", comment: "action_settings"))
        {
            googleView.hidden = true
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            nRow = 8
            //MEMORIA MENU: NSLocalizedString("settings_memory", comment: "settings_memory"), "M2",
            bookArray = [NSLocalizedString("settings_license", comment: "settings_license"),"L2", NSLocalizedString("settings_privacy", comment: "settings_privacy"),NSLocalizedString("settings_support_us", comment: "settings_support_us"),"S2","Insta...Social","I2","I3"]
        }
        else
        {
        
            if(Data.sharedInstance().dict.valueForKey("GoogleBooks") == nil)
            {
                nRow = 0
            }
            else
            {
                let books = Data.sharedInstance().dict.valueForKey("GoogleBooks") as! Books
                bookArray = books.array
                nRow = bookArray.count
            }
        
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nRow
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellDefault = UITableViewCell()
        
        if(titleName == NSLocalizedString("bestSellers", comment: "bestSellers") && bookArray.count != 0){
            
            let b = (bookArray[(indexPath.row)] as! Book)
            let cell = tableView.dequeueReusableCellWithIdentifier("rowTable", forIndexPath: indexPath) as! BookCell
            
            cell.cuore.layer.cornerRadius = 0.5 * cell.cuore.bounds.size.width
            cell.cuore.layer.shadowOffset = CGSizeMake(0.1, 1.0);
            cell.cuore.layer.shadowOpacity = 0.2;
            cell.cuore.layer.shadowRadius = 0.0;
            if(b.favorite == true){
                cell.cuore.setImage(UIImage(named:"heart-full.png"), forState: .Normal)
            }
            else{
              cell.cuore.setImage(UIImage(named:"heart.png"), forState: .Normal)
            
            }
            cell.cuore.backgroundColor = UIColor(red: 255.0/255, green: 217.0/255, blue: 3.0/255, alpha: 1.0)
            cell.cuore.addTarget(self, action: #selector(BooksView.addToPreferred(_:)), forControlEvents: .TouchUpInside)
            cell.cuore.tag = indexPath.row
            
            cell.shared.layer.cornerRadius = 0.5 * cell.shared.bounds.size.width
            cell.shared.layer.shadowOffset = CGSizeMake(0.1, 1.0);
            cell.shared.layer.shadowOpacity = 0.2;
            cell.shared.layer.shadowRadius = 0.0;
            cell.shared.setImage(UIImage(named:"share.png"), forState: .Normal)
            cell.shared.backgroundColor = UIColor(red: 255.0/255, green: 217.0/255, blue: 3.0/255, alpha: 1.0)
            cell.shared.addTarget(self, action: #selector(BooksView.share(_:)), forControlEvents: .TouchUpInside)
            cell.shared.tag = indexPath.row
            
            
            cell.titolo.text = b.title as String
            cell.titolo.sizeToFit();
            if(b.price.containsString("EUR"))
            {
                cell.prezzo.text = b.price
            }
            else
            {
                cell.prezzo.text = b.price + " €"
            }

            let num = indexPath.row+1 as NSNumber
            cell.numero.text = num.stringValue
            
            var auth = ""
            var ind = 0
            for i in b.authors
            {
                
                auth.appendContentsOf(i)
                ind += 1
                if(ind < b.authors.count)
                {
                    auth.appendContentsOf(", ")
                }
                
            }
            
            cell.autore.text = auth
            cell.layoutIfNeeded();
            
            //DOWNLOAD IMAGE
            let urlString:String? = Constants.MONDADORI_BASE_URL + ((bookArray[indexPath.row] as! Book).imgLink) as String
            if(urlString != nil)
            {
                let imgURL: NSURL = NSURL(string: urlString!)!
                let request: NSURLRequest = NSURLRequest(URL: imgURL)
                NSURLConnection.sendAsynchronousRequest(
                    request, queue: NSOperationQueue.mainQueue(),
                    completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
                        if error == nil {
                            cell.copertina.image = UIImage(data: data!)
                        }
                })
            }
            
            
            return cell;
        
        }else if (titleName == NSLocalizedString("mySearches", comment: "mySearches")){
            
            let cell = tableView.dequeueReusableCellWithIdentifier("rowTable2", forIndexPath: indexPath) as! SearchBookCell
            cell.deleteButton.tag = indexPath.row;
            cell.deleteButton.layer.cornerRadius = 0.5 * cell.deleteButton.bounds.size.width
            cell.deleteButton.layer.shadowOffset = CGSizeMake(0.1, 1.0);
            cell.deleteButton.layer.shadowOpacity = 0.2;
            cell.deleteButton.layer.shadowRadius = 0.0;
            cell.deleteButton.setImage(UIImage(named:"delete.png"), forState: .Normal)
            cell.deleteButton.backgroundColor = UIColor(red: 255.0/255, green: 217.0/255, blue: 3.0/255, alpha: 1.0)
            cell.deleteButton.addTarget(self, action: #selector(BooksView.deleteSearch(_:)), forControlEvents: .TouchUpInside)
            
            cell.titoloRicerca.text = (bookArray[indexPath.row] as! MySearch).citazione
            if((bookArray[indexPath.row] as! MySearch).autore != "")
            {
                if(cell.titoloRicerca.text != "")
                {
                    cell.titoloRicerca.text = cell.titoloRicerca.text! + "+" + NSLocalizedString("author_full_stop", comment: "author_full_stop") + (bookArray[indexPath.row] as! MySearch).autore
                }
                else
                {
                    cell.titoloRicerca.text = NSLocalizedString("author_full_stop", comment: "author_full_stop") + (bookArray[indexPath.row] as! MySearch).autore
                }
            }
            cell.data.text = NSLocalizedString("last_searched", comment: "last_searched") + (bookArray[indexPath.row] as! MySearch).data
            
            let urlString:String? = ((bookArray[indexPath.row] as! MySearch).imgLink) as String
            if(urlString != nil)
            {
                if(self.cacheManager.isImageCached(urlString!))
                {
                    cell.imageBook.image = self.cacheManager.getImageCached(urlString!)
                }
                else
                {
                    let imgURL: NSURL = NSURL(string: urlString!)!
                    let request: NSURLRequest = NSURLRequest(URL: imgURL)
                    NSURLConnection.sendAsynchronousRequest(
                        request, queue: NSOperationQueue.mainQueue(),
                        completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
                            if error == nil {
                                cell.imageBook.image = UIImage(data: data!)
                                self.cacheManager.storeImage(urlString!, data: data!)
                            }
                    })
                }
                
            }

            
            return cell;
        }else if (titleName == NSLocalizedString("my_books", comment: "my_books") && bookArray.count > indexPath.row){
            print(bookArray.count)
            let cell = tableView.dequeueReusableCellWithIdentifier("rowTable3", forIndexPath: indexPath) as! BookCell
            cell.numero.hidden = true
            
            cell.titolo.text = (bookArray[indexPath.row] as! Book).title as String
            
            cell.autore.text = ""
            var auth = ""
            var ind = 0
            let b = bookArray[indexPath.row] as! Book
            
            
            for i in b.authors
            {
                
                auth.appendContentsOf(i)
                ind += 1
                if(ind < b.authors.count)
                {
                    auth.appendContentsOf(", ")
                }
                
            }
            cell.autore.text = auth
            cell.layoutIfNeeded();
            
            
            //for i in (bookArray[indexPath.row] as! Book).authors {
                
                //auth.appendContentsOf(i)
                //ind += 1
                //if(ind < (bookArray[indexPath.row] as! Book).authors.count  ){
                  //  auth.appendContentsOf(", ")
               // }
                
            //}
            
            if((bookArray[indexPath.row] as! Book).price != "")
            {
                let b = (bookArray[indexPath.row] as! Book)
                if(b.price.containsString("EUR"))
                {
                    cell.prezzo.text = b.price
                }
                else
                {
                    cell.prezzo.text = b.price + " €"
                }

                //cell.prezzo.text = (bookArray[indexPath.row] as! Book).price + "€"
            }
            
            var urlString = ""
            if((bookArray[indexPath.row] as! Book).imgLink.containsString("http://books.google.com/"))
            {
                urlString = (bookArray[indexPath.row] as! Book).imgLink
            }
            else
            {
                urlString = Constants.MONDADORI_BASE_URL + ((bookArray[indexPath.row] as! Book).imgLink) as String
            }
            if(urlString != "")
            {
                if(self.cacheManager.isImageCached(urlString))
                {
                    cell.copertina.image = self.cacheManager.getImageCached(urlString)
                }
                else
                {
                    let imgURL: NSURL = NSURL(string: urlString)!
                    let request: NSURLRequest = NSURLRequest(URL: imgURL)
                    NSURLConnection.sendAsynchronousRequest(
                        request, queue: NSOperationQueue.mainQueue(),
                        completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
                            if error == nil
                            {
                                cell.copertina.image = UIImage(data: data!)
                                self.cacheManager.storeImage(urlString, data: data!)
                            }
                    })
                }
                
            }
            
            cell.cuore.layer.cornerRadius = 0.5 * cell.cuore.bounds.size.width
            cell.cuore.layer.shadowOffset = CGSizeMake(0.1, 1.0);
            cell.cuore.layer.shadowOpacity = 0.2;
            cell.cuore.layer.shadowRadius = 0.0;
            if(b.favorite == true)
            {
                cell.cuore.setImage(UIImage(named:"heart-full.png"), forState: .Normal)
            }
            else
            {
                cell.cuore.setImage(UIImage(named:"heart.png"), forState: .Normal)
            }

            cell.cuore.backgroundColor = UIColor(red: 255.0/255, green: 217.0/255, blue: 3.0/255, alpha: 1.0)
            cell.cuore.addTarget(self, action: #selector(BooksView.removeFromPreferred(_:)), forControlEvents: .TouchUpInside)
            cell.shared.layer.cornerRadius = 0.5 * cell.shared.bounds.size.width
            cell.shared.layer.shadowOffset = CGSizeMake(0.1, 1.0);
            cell.shared.layer.shadowOpacity = 0.2;
            cell.shared.layer.shadowRadius = 0.0;
            cell.shared.setImage(UIImage(named:"share.png"), forState: .Normal)
            cell.shared.backgroundColor = UIColor(red: 255.0/255, green: 217.0/255, blue: 3.0/255, alpha: 1.0)
            cell.shared.addTarget(self, action: #selector(BooksView.share(_:)), forControlEvents: .TouchUpInside)
            cell.shared.tag = indexPath.row;
            cell.cuore.tag = indexPath.row;
            
            return cell;
        }
        //Configure BookCell
       //let tapCuoreLeft = UITapGestureRecognizer(target:self, action:Selector("@connected:"))
       //cell.cuore.addGestureRecognizer(tapCuoreLeft)
       //cell.cuore.tag = indexPath.row
        
      //let tapSharedLeft = UITapGestureRecognizer(target:self, action:Selector("@connected1:"))
       //cell.shared.addGestureRecognizer(tapSharedLeft)
       //cell.shared.tag = indexPath.row
        else if (titleName == NSLocalizedString("action_settings", comment: "action_settings")){
            
            let cell = tableView.dequeueReusableCellWithIdentifier("rowTable5", forIndexPath: indexPath) as! SettingsCell
           
            let tipologia = bookArray[(indexPath.row)] as! String
            
            if(NSLocalizedString("settings_memory", comment: "settings_memory") == tipologia)
            {
                cell.tipologia.text = tipologia
                cell.titolo.text = NSLocalizedString("settings_manage_space", comment: "settings_manage_space")
                cell.descrizione.text = NSLocalizedString("settings_manage_space_description", comment: "settings_manage_space_description")
                cell.switchButton.hidden = true
                cell.socialButton.hidden = true
            
            }
            else if("M2" == tipologia)
            {
                
                cell.tipologia.text = ""
                cell.titolo.text = NSLocalizedString("settings_clear_data", comment: "settings_clear_data")
                cell.descrizione.text = NSLocalizedString("settings_clear_data_description", comment: "settings_clear_data_description")
                cell.switchButton.hidden = true
                cell.socialButton.hidden = true
                
            }
            else if(NSLocalizedString("settings_license", comment: "settings_license") == tipologia){
                
                cell.tipologia.text = tipologia
                cell.titolo.text = NSLocalizedString("settings_license", comment: "settings_license")
                cell.descrizione.text = NSLocalizedString("settings_manage_license_description", comment: "settings_manage_license_description")
                cell.switchButton.hidden = true
                cell.socialButton.hidden = true
                
            }
            else if("L2" == tipologia)
            {
                
                cell.tipologia.text = ""
                cell.titolo.text = NSLocalizedString("settings_advertisements", comment: "settings_advertisements")
                cell.descrizione.text = NSLocalizedString("settings_advertisements_description", comment: "settings_advertisements_description")
                cell.switchButton.hidden = false
                cell.switchButton.on = false
                cell.socialButton.hidden = true
                
            }
            else if(NSLocalizedString("settings_privacy", comment: "settings_privacy") == tipologia)
            {
                
                cell.tipologia.text = tipologia
                cell.titolo.text = NSLocalizedString("settings_read_privacy", comment: "settings_read_privacy")
                cell.descrizione.text = NSLocalizedString("settings_read_privacy_description", comment: "settings_read_privacy_description")
                cell.switchButton.hidden = true
                cell.socialButton.hidden = true
                
            }
            else if(NSLocalizedString("settings_support_us", comment: "settings_support_us") == tipologia)
            {
                
                cell.tipologia.text = tipologia
                cell.titolo.text = NSLocalizedString("settings_rate_on_app_store", comment: "settings_rate_on_app_store")
                cell.descrizione.text = NSLocalizedString("settings_rate_on_app_store_description", comment: "settings_rate_on_app_store_description")
                cell.switchButton.hidden = true
                cell.socialButton.hidden = true
                
            }
            else if("S2" == tipologia)
            {
                
                cell.tipologia.text = ""
                cell.titolo.text = NSLocalizedString("settings_buy_a_beer", comment: "settings_buy_a_beer")
                cell.descrizione.text = NSLocalizedString("settings_buy_a_beer_description", comment: "settings_buy_a_beer_description")
                cell.switchButton.hidden = true
                cell.socialButton.hidden = false
                cell.socialButton.image = UIImage(named:"birra.png")
                
            }
            else if("Insta...Social" == tipologia)
            {
                
                cell.tipologia.text = tipologia
                cell.titolo.text = NSLocalizedString("settings_follow_on_facebook", comment: "settings_follow_on_facebook")
                cell.descrizione.text = NSLocalizedString("settings_follow_on_facebook_description", comment: "settings_follow_on_facebook_description")
                cell.switchButton.hidden = true
                cell.socialButton.hidden = false
                cell.socialButton.image = UIImage(named:"facebook.png")
                
            }
            else if("I2" == tipologia)
            {
                
                cell.tipologia.text = ""
                cell.titolo.text = NSLocalizedString("settings_follow_on_twitter", comment: "settings_follow_on_twitter")
                cell.descrizione.text = NSLocalizedString("settings_follow_on_twitter_description", comment: "settings_follow_on_twitter_description")
                cell.switchButton.hidden = true
                cell.socialButton.hidden = false
                cell.socialButton.image = UIImage(named:"twitter.png")
                
            }
            else if("I3" == tipologia)
            {
                
                cell.tipologia.text = ""
                cell.titolo.text = NSLocalizedString("settings_follow_on_instagram", comment: "settings_follow_on_instagram")
                cell.descrizione.text = NSLocalizedString("settings_follow_on_instagram_description", comment: "settings_follow_on_instagram_description")
                cell.switchButton.hidden = true
                cell.socialButton.hidden = false
                cell.socialButton.image = UIImage(named:"instagram.png")
            }
            
             return cell
            
        }else if (bookArray.count > 0 && label.text != NSLocalizedString("my_books", comment: "my_books")){
        
            let b = (bookArray[(indexPath.row)] as! Book)
            
            if(self.cacheManager.isFavoriteBook(b.link))
            {
                b.favorite = true;
            }
            
            let cell = tableView.dequeueReusableCellWithIdentifier("rowTable4", forIndexPath: indexPath) as! BookCell
            
            cell.cuore.layer.cornerRadius = 0.5 * cell.cuore.bounds.size.width
            cell.cuore.layer.shadowOffset = CGSizeMake(0.1, 1.0);
            cell.cuore.layer.shadowOpacity = 0.2;
            cell.cuore.layer.shadowRadius = 0.0;
            if(b.favorite == true)
            {
                cell.cuore.setImage(UIImage(named:"heart-full.png"), forState: .Normal)
            }
            else
            {
                cell.cuore.setImage(UIImage(named:"heart.png"), forState: .Normal)
            }

            cell.cuore.backgroundColor = UIColor(red: 255.0/255, green: 217.0/255, blue: 3.0/255, alpha: 1.0)
            cell.cuore.addTarget(self, action: #selector(BooksView.addToPreferred(_:)), forControlEvents: .TouchUpInside)
            cell.cuore.tag = indexPath.row

            cell.shared.layer.cornerRadius = 0.5 * cell.shared.bounds.size.width
            cell.shared.layer.shadowOffset = CGSizeMake(0.1, 1.0);
            cell.shared.layer.shadowOpacity = 0.2;
            cell.shared.layer.shadowRadius = 0.0;
            cell.shared.setImage(UIImage(named:"share.png"), forState: .Normal)
            cell.shared.backgroundColor = UIColor(red: 255.0/255, green: 217.0/255, blue: 3.0/255, alpha: 1.0)
            cell.shared.tag = indexPath.row
            cell.shared.addTarget(self, action: #selector(BooksView.share(_:)), forControlEvents: .TouchUpInside)

            
           
            cell.titolo.text = b.title as String
            cell.titolo.sizeToFit();
            if (b.price != "")
            {
                cell.prezzo.hidden = false;
                if(b.price.containsString("EUR"))
                {
                    cell.prezzo.text = b.price
                }
                else
                {
                    cell.prezzo.text = b.price + " €"
                }
            }
            else
            {
                cell.prezzo.hidden = true
            }
            
            cell.numero.hidden = true
            var auth = ""
            var ind = 0
            for i in b.authors
            {
                auth.appendContentsOf(i)
                ind += 1
                if(ind < b.authors.count){
                    auth.appendContentsOf(", ")
                }
                
            }
            cell.autore.text = auth
            cell.layoutIfNeeded();
            
            //DOWNLOAD IMAGE
            let urlString:String? = b.imgLink
            if(urlString != nil)
            {
                let imgURL: NSURL = NSURL(string: urlString!)!
                let request: NSURLRequest = NSURLRequest(URL: imgURL)
                NSURLConnection.sendAsynchronousRequest(
                    request, queue: NSOperationQueue.mainQueue(),
                    completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
                        if error == nil {
                            cell.copertina.image = UIImage(data: data!)
                        }
                })
            }
            
            
            return cell;
 
        }
        
        return cellDefault
    }
    
    func connected(sender: UITapGestureRecognizer!) {
        
        print(sender.description, terminator: "")
    }
    
    func connected1(sender: UITapGestureRecognizer!) {
        
        print(sender.description, terminator: "")
    }
    
    func connected2(sender: UITapGestureRecognizer!) {
        
        print("tap", terminator: "")
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if(titleName == NSLocalizedString("action_settings", comment: "action_settings"))
        {
            let tipologia = bookArray[indexPath.row] as! String
            /*if(NSLocalizedString("settings_memory", comment: "settings_memory") == tipologia)
            {
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MemoriaView") as UIViewController
                self.presentViewController(viewController, animated: false, completion: nil)
            }
            else if("M2" == tipologia)
            {
                let alert = UIAlertController(title: "Attenzione", message: NSLocalizedString("are_you_sure_clear_data", comment: "are_you_sure_clear_data"), preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "SI", style: .Default, handler: { action in
                        self.cacheManager.deleteAll()
                }))
                alert.addAction(UIAlertAction(title: "NO", style: .Default, handler: { action in
                }))
                
                self.presentViewController(alert, animated: true, completion: nil)
                
                
            } else*/
            if(NSLocalizedString("settings_license", comment: "settings_license") == tipologia)
            {
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Licenza") as UIViewController
                self.presentViewController(viewController, animated: false, completion: nil)
                
            }
            else if("L2" == tipologia)
            {
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! SettingsCell
                cell.switchButton.setOn(true, animated: true)
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Licenza") as UIViewController
                self.presentViewController(viewController, animated: false, completion: nil)
                
            }
            else if(NSLocalizedString("settings_privacy", comment: "settings_privacy") == tipologia)
            {
                let privacy = Book()
                privacy.link = Constants.POLICY_PRIVACY_LINK
                privacy.title = Constants.POLICY_PRIVACY_LINK
                Data.sharedInstance().dict.setValue( privacy, forKey: "Book")
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("WebView") as UIViewController
                self.presentViewController(viewController, animated: false, completion: nil)
                
            }
            else if(NSLocalizedString("settings_support_us", comment: "settings_support_us") == tipologia)
            {
                let url  = NSURL(string: "itms-apps://itunes.apple.com/it/app/instabook/id1181854719") //itms-apps
                if UIApplication.sharedApplication().canOpenURL(url!) == true
                {
                    UIApplication.sharedApplication().openURL(url!)
                }
                
            }
            else if("S2" == tipologia)
            {
                print(tipologia+" 7")
                let requestUrl = NSURL(string: Constants.BIRRA_LINK);UIApplication.sharedApplication().openURL(requestUrl!)
                
            }
            else if("Insta...Social" == tipologia)
            {
                let requestUrl = NSURL(string: Constants.FACEBOOK_LINK);UIApplication.sharedApplication().openURL(requestUrl!)
                
            }
            else if("I2" == tipologia)
            {
                let requestUrl = NSURL(string: Constants.TWITTER_LINK);UIApplication.sharedApplication().openURL(requestUrl!)
                
            }
            else if("I3" == tipologia)
            {
                let requestUrl = NSURL(string: Constants.INSTAGRAM_LINK);UIApplication.sharedApplication().openURL(requestUrl!)
            }
        }
        else if(titleName == NSLocalizedString("mySearches", comment: "mySearches"))
        {
            if Reachability.isConnectedToNetwork() == true
            {
                let citazione:String = (bookArray[indexPath.row] as! MySearch).citazione
                let autore:String = (bookArray[indexPath.row] as! MySearch).autore
            
            
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
                
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("BooksView") as UIViewController
                    activitiyViewController.dismissViewControllerAnimated(true, completion: {});
                    self.presentViewController(viewController, animated: true, completion: nil)
                    
                    })
                })
            }
            else
            {
            
                let snackbar = MKSnackbar(
                    withTitle: NSLocalizedString("connection_unavailable", comment: "connection_unavailable"),
                    withDuration: nil,
                    withTitleColor: nil,
                    withActionButtonTitle: "",
                    withActionButtonColor: UIColor.lightGrayColor())
                    snackbar.show()
            }

        }
        else
        {
            if(bookArray.count > 0)
            {
                Data.sharedInstance().dict.setValue(bookArray[(indexPath.row)] as! Book, forKey: "BestSellerBook")
            }
            tableView.cellForRowAtIndexPath(indexPath)?.selected = false
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Book") as UIViewController
            self.presentViewController(viewController, animated: false, completion: nil)
        }
    
    }
    
    func action(sender:UIButton!) {
       self.dismissViewControllerAnimated(false, completion: nil)
        
    }
    
    private func loadBestSellers()
    {
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        
        
        dispatch_async(backgroundQueue, {
            
            let todaysDate:NSDate = NSDate()
            let dateFormatter:NSDateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            if(self.cacheManager.getMondadoriBestSellerLastDateUpdate() == "" || self.cacheManager.getMondadoriBestSellerLastDateUpdate() != dateFormatter.stringFromDate(todaysDate))
            {
                self.cacheManager.deleteBestSeller();
                self.cacheManager.storeTheNextPageCachedMondadoriBestSeller(Constants.CLASSIFICA)
                let mondadoriParserNews = MondadoriParser();
                mondadoriParserNews.setUrlNovita(Constants.URL_CLASSIFICA_BASE);
                self.bookArray = mondadoriParserNews.parse(Constants.CLASSIFICA);
                
            }
            else
            {
                self.bookArray = self.cacheManager.getMondadoriBooksBestSeller()
            }
            
            
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.nRow = self.bookArray.count
                self.tableView.reloadData();
                
            })
            
        })
    }
    
    private func loadOtherBestSeller(snackBar: MKSnackbar)
    {
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        
        
        dispatch_async(backgroundQueue, {


            let nextPage = self.cacheManager.getMondadoriNextPageBestSeller();
            if(nextPage == Constants.CLASSIFICA_STOP)
            {
                snackBar.hidden = true;
            }
            else
            {
                self.cacheManager.storeTheNextPageCachedMondadoriBestSeller(nextPage);
                let mondadoriParserNews = MondadoriParser();
                mondadoriParserNews.setUrlNovita(Constants.URL_CLASSIFICA_BASE + nextPage);
                var newBookArray = [Any]();
                newBookArray = mondadoriParserNews.parse(Constants.CLASSIFICA)
                self.bookArray += newBookArray
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    //let position = self.bookArray.count
                    self.nRow = self.bookArray.count
                    self.tableView.reloadData();
                    snackBar.hidden = true;
                    
                })
            }
        })
    }


    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if (titleName == NSLocalizedString("bestSellers", comment: "bestSellers"))
        {
            // UITableView only moves in one direction, y axis
            let currentOffset = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
            // Change 10.0 to adjust the distance from bottom
            if maximumOffset - currentOffset <= 10.0
            {
                
                let snackbar = MKSnackbar(
                    withTitle: NSLocalizedString("searching", comment: "searching"),
                    withDuration: nil,
                    withTitleColor: nil,
                    withActionButtonTitle: "",
                    withActionButtonColor: UIColor.lightGrayColor())
                snackbar.show()
            
                loadOtherBestSeller(snackbar)
            }

        }
    }
    
    func addToPreferred(sender: UIButton)
    {
        if(sender.currentImage!.isEqual(UIImage(named: "heart.png")))
        {
            let bookLike = bookArray[sender.tag] as! Book
            bookLike.favorite = true
            self.cacheManager.storeLikeBook(bookLike)
            sender.setImage(UIImage(named:"heart-full.png"), forState: .Normal)
        }
        else
        {
            let bookDisLike = bookArray[sender.tag] as! Book
            bookDisLike.favorite = false
            self.cacheManager.removeStoreLikeBook(bookDisLike)
            sender.setImage(UIImage(named:"heart.png"), forState: .Normal)
        }

        
    }

    func removeFromPreferred(sender: UIButton)
    {
        let buttonTag = sender.tag
        self.cacheManager.removeStoreLikeBook(bookArray[buttonTag] as! Book)
        bookArray = self.cacheManager.getMyBooksLikeStored()
        nRow = bookArray.count
        self.tableView.reloadData()
    }
    
    func share(sender: UIButton)
    {
        let buttonTag = sender.tag
        if(self.bookArray.count > 0){
            let bookPressed: Book = self.bookArray[buttonTag] as! Book
            let stringShared = Constants.SHARED + (bookPressed.title as String) + " - " + bookPressed.link
            let vc = UIActivityViewController(activityItems: [stringShared], applicationActivities: [])
            vc.popoverPresentationController?.sourceView = self.tableView;
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    func deleteSearch(sender: UIButton)
    {
        let buttonTag = sender.tag
        self.cacheManager.removeStoreMySearch((bookArray[buttonTag] as! MySearch))
        bookArray = self.cacheManager.getMySearchStored()
        nRow = bookArray.count
        self.tableView.reloadData()
    }
    
}