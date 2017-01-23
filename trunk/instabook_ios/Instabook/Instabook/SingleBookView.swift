//
//  SingleBookView.swift
//  Instabook
//
//  Created by Marco Ferraro on 20/11/16.
//  Copyright © 2016 instabook. All rights reserved.
//

import Foundation
import GoogleMobileAds

public class SingleBookView: UITableViewController,GADInterstitialDelegate
{
    var cacheManager = CacheManager()
    var positionFloatingButton: CGFloat = 190
    let floatingButtonleft : UIButton = UIButton(type: UIButtonType.Custom) as UIButton
    let floatingButtonright : UIButton = UIButton(type: UIButtonType.Custom) as UIButton
    var b = Book()
    @IBOutlet weak var bookView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var cuoreView: UIImageView!
    
    //ADMOB
    var interstitial: GADInterstitial!
    //ADMOB
    @IBOutlet weak var backView: UIView!
    func createAndLoadInterstitial() -> GADInterstitial {
        let createInterstitial = GADInterstitial(adUnitID: "ca-app-pub-2997805148414323/3221280091")
        createInterstitial.delegate = self;
        let request = GADRequest()
        request.testDevices = ["a737ae7d50e451deeaf23e979b871d29"]
        createInterstitial.loadRequest(request)
        return createInterstitial
    }
    
    //ADMOB
    public func interstitialDidReceiveAd(ad: GADInterstitial) {
        ad.presentFromRootViewController(self)
    }


    public override func viewDidLoad() {
        super.viewDidLoad();
        
        //ADMOB
        if(!cacheManager.getLicense())
        {
            interstitial = createAndLoadInterstitial()
        }
        
        let tapCuore = UITapGestureRecognizer(target:self, action:#selector(SingleBookView.heartCardView(_:)))
        cuoreView.addGestureRecognizer(tapCuore)
        cuoreView.userInteractionEnabled = true

        
    
        floatingButtonleft.frame = CGRectMake(20, 20, 60, 60)
        floatingButtonleft.layer.cornerRadius = 0.5 * floatingButtonleft.bounds.size.width
        floatingButtonleft.setImage(UIImage(named:"ic_book_white.png"), forState: .Normal)
        floatingButtonleft.backgroundColor = UIColor(red: 255.0/255, green: 217.0/255, blue: 3.0/255, alpha: 1.0)
        floatingButtonleft.addTarget(self, action: #selector(SingleBookView.goToMondadoriView), forControlEvents: UIControlEvents.TouchUpInside)
        //floatingButtonleft.layer.shadowOffset = CGSizeMake(0.1, 1.0);
        //floatingButtonleft.layer.shadowOpacity = 0.2;
        //floatingButtonleft.layer.shadowRadius = 0.0;

        
        floatingButtonright.frame = CGRectMake(20, 20, 60, 60)
        floatingButtonright.layer.cornerRadius = 0.5 * floatingButtonright.bounds.size.width
        floatingButtonright.setImage(UIImage(named:"share.png"), forState: .Normal)
        floatingButtonright.backgroundColor = UIColor(red: 255.0/255, green: 217.0/255, blue: 3.0/255, alpha: 1.0)
        floatingButtonright.addTarget(self, action: #selector(SingleBookView.share), forControlEvents: UIControlEvents.TouchUpInside)
        //floatingButtonright.layer.shadowOffset = CGSizeMake(0.1, 1.0);
        //floatingButtonright.layer.shadowOpacity = 0.2;
        //floatingButtonright.layer.shadowRadius = 0.0;
        
        
        self.tableView.addSubview(Utils.createFloatingButton(floatingButtonleft, viewWidht: 100, position: positionFloatingButton))
        self.tableView.addSubview(Utils.createFloatingButton(floatingButtonright, viewWidht: self.tableView.frame.size.width+20 , position: positionFloatingButton))
        
        if(Data.sharedInstance().dict.valueForKey("BestSellerBook") != nil)
        {
            b = Data.sharedInstance().dict.valueForKey("BestSellerBook") as! Book
        }
        
        if(b.favorite == false)
        {
            cuoreView.image = UIImage(named:"heart.png")
        }else
        {
            cuoreView.image = UIImage(named:"heart-full.png")
        }
        
        self.tableView.registerNib(UINib(nibName: "DescriptionCell", bundle: nil), forCellReuseIdentifier: "rowTable");
        self.tableView.estimatedRowHeight = 1000.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        //self.tableView.setNeedsLayout()
        //self.tableView.layoutIfNeeded()
        backButton.addTarget(self, action: #selector(SingleBookView.action(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let tapBackView = UITapGestureRecognizer(target:self, action:#selector(SingleBookView.action(_:)))
        backView.addGestureRecognizer(tapBackView)

        
        if(b.imgLink != "")
        {
        
            let urlString = b.imgLink
            
            if(urlString != "")
            {
                let imgURL: NSURL = NSURL(string: urlString)!
                let request: NSURLRequest = NSURLRequest(URL: imgURL)
                NSURLConnection.sendAsynchronousRequest(
                    request, queue: NSOperationQueue.mainQueue(),
                    completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
                        if error == nil {
                            self.bookView.image = UIImage(data: data!)
                        }
                })
            }
        }
    }
    
    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let b = Data.sharedInstance().dict.valueForKey("BestSellerBook") as! Book
        let cell = tableView.dequeueReusableCellWithIdentifier("rowTable", forIndexPath: indexPath) as! DescriptionCell
        print(b.title)
        cell.titolo.text = b.title as String
        cell.titolo.sizeToFit();
        if(b.price != "")
        {
            cell.prezzo.text = b.price
        }
        else
        {
            cell.prezzo.hidden = true
        }
        

        
        var auth = ""
        var ind = 0
        
        for i in b.authors {
            
            auth.appendContentsOf(i)
            ind += 1
            if(ind < b.authors.count){
                auth.appendContentsOf(", ")
            }
            
        }
                cell.autore.text = auth
        
        if(b.imgLink.containsString("http://books.google.com/"))
        {
            cell.descrizione.text = b.descriptionBook
            if(b.rating == 0)
            {
                cell.star1.hidden = true;
                cell.star2.hidden = true;
                cell.star3.hidden = true;
                cell.star4.hidden = true;
                cell.star5.hidden = true;
            }
            else
            {
                switch b.rating
                {
                    case 5:
                        cell.star5.image = UIImage(named:"star-full.png")
                        cell.star4.image = UIImage(named:"star-full.png")
                        cell.star3.image = UIImage(named:"star-full.png")
                        cell.star2.image = UIImage(named:"star-full.png")
                        cell.star1.image = UIImage(named:"star-full.png")
                    case 4:
                        cell.star4.image = UIImage(named:"star-full.png")
                        cell.star3.image = UIImage(named:"star-full.png")
                        cell.star2.image = UIImage(named:"star-full.png")
                        cell.star1.image = UIImage(named:"star-full.png")
                    case 3:
                        cell.star3.image = UIImage(named:"star-full.png")
                        cell.star2.image = UIImage(named:"star-full.png")
                        cell.star1.image = UIImage(named:"star-full.png")
                    case 2:
                        cell.star2.image = UIImage(named:"star-full.png")
                        cell.star1.image = UIImage(named:"star-full.png")
                    case 1:
                        cell.star1.image = UIImage(named:"star-full.png")
                    default:
                        break
                }
            }
        }
        else
        {
            cell.star1.hidden = true;
            cell.star2.hidden = true;
            cell.star3.hidden = true;
            cell.star4.hidden = true;
            cell.star5.hidden = true;
            cell.poweredByGoogle.hidden = true;
        
            cell.descrizione.text = b.descriptionBook;
        }
        
        cell.descrizione.sizeToFit();
        cell.layoutIfNeeded();
        
        
        return cell
    }
    
    func action(sender:UIButton!) {
        self.dismissViewControllerAnimated(false, completion: nil)
        
    }
    
    public override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.y > 105){
        let positionFloatingButton2 = view.bounds.origin.x + 85 + scrollView.contentOffset.y
        self.tableView.addSubview(Utils.createFloatingButton(floatingButtonleft, viewWidht: 100, position: positionFloatingButton2))
        self.tableView.addSubview(Utils.createFloatingButton(floatingButtonright, viewWidht: self.tableView.frame.size.width+20, position: positionFloatingButton2))
        
        }else{
            self.tableView.addSubview(Utils.createFloatingButton(floatingButtonleft, viewWidht: 100, position: positionFloatingButton))
            self.tableView.addSubview(Utils.createFloatingButton(floatingButtonright, viewWidht: self.tableView.frame.size.width+20 , position: positionFloatingButton))
        }
    }
    
    func share(){
        
        let stringShared = Constants.SHARED + (b.title as String) + " - " + b.link
        let vc = UIActivityViewController(activityItems: [stringShared], applicationActivities: [])
        vc.popoverPresentationController?.sourceView = self.tableView;
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    func goToMondadoriView(){
        
        Data.sharedInstance().dict.setValue( b, forKey: "Book")
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("WebView") as UIViewController
        self.presentViewController(viewController, animated: false, completion: nil)
        
    }
    
    func heartCardView(sender: UITapGestureRecognizer!) {
        if let button = sender.view as? UIImageView {
            if(button.image!.isEqual(UIImage(named: "heart.png")))
            {
                
                b.favorite = true
                self.cacheManager.storeLikeBook(b)
                button.image = UIImage(named:"heart-full.png")
            }
            else
            {
                b.favorite = false
                self.cacheManager.removeStoreLikeBook(b)
                button.image = UIImage(named:"heart.png")
            }

            
            
            //if(button.image!.isEqual(UIImage(named: "heart.png"))){
           //     button.image = UIImage(named:"heart-full.png")
            //}else{
             //   button.image = UIImage(named:"heart.png")
            //}
            
        }
    }
    
    func formatString(string : String) -> String{
    
        var newString = ""
        
        if(string.containsString("aIIIAAIA")){
            newString = string.stringByReplacingOccurrencesOfString("aIIIAAIA", withString: "à")
            
        }else if(string.containsString("eIIIAAIA")){
            newString = string.stringByReplacingOccurrencesOfString("eIIIAAIA", withString: "è")
        }else if(string.containsString("iIIIAAIA")){
            newString = string.stringByReplacingOccurrencesOfString("iIIIAAIA", withString: "ì")
        }else if(string.containsString("oIIIAAIA")){
            newString = string.stringByReplacingOccurrencesOfString("oIIIAAIA", withString: "ò")
        }else if(string.containsString("uIIIAAIA")){
            newString = string.stringByReplacingOccurrencesOfString("uIIIAAIA", withString: "ù")
        }else if(string.containsString("aIIÌÂAÌÂ")){
            newString = string.stringByReplacingOccurrencesOfString("aIIÌÂAÌÂ", withString: "à")
        }else if(string.containsString("eIIÌÂAÌÂ")){
            newString = string.stringByReplacingOccurrencesOfString("eIIÌÂAÌÂ", withString: "è")
        }else if(string.containsString("iIIÌÂAÌÂ")){
            newString = string.stringByReplacingOccurrencesOfString("iIIÌÂAÌÂ", withString: "ì")
        }else if(string.containsString("oIIÌÂAÌÂ")){
            newString = string.stringByReplacingOccurrencesOfString("oIIÌÂAÌÂ", withString: "ò")
        }else if(string.containsString("uIIÌÂAÌÂ")){
            newString = string.stringByReplacingOccurrencesOfString("uIIÌÂAÌÂ", withString: "ù")
        }

        
        return newString
    }

}