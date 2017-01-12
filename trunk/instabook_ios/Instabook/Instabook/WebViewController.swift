//
//  WebViewController.swift
//  Instabook
//
//  Created by Marco Ferraro on 29/11/16.
//  Copyright © 2016 instabook. All rights reserved.
//

import Foundation
import GoogleMobileAds

class WebViewController: UIViewController, GADInterstitialDelegate{

    @IBOutlet weak var extButton: UIButton!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var link: UILabel!
    @IBOutlet weak var titolo: UILabel!
    
    var cacheManager = CacheManager()
    //ADMOB
    var interstitial: GADInterstitial!
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
        
        extButton.addTarget(self, action: #selector(WebViewController.open(_:)), forControlEvents: UIControlEvents.TouchUpInside)

        back.addTarget(self, action: #selector(WebViewController.action(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let tapBackView = UITapGestureRecognizer(target:self, action:#selector(WebViewController.action(_:)))
        backView.addGestureRecognizer(tapBackView)
        let book = Data.sharedInstance().dict.valueForKey("Book") as! Book
        if (book.title.containsString("www.instabook.it/privacypolicy"))
        {
            titolo.text = "Instabook"
        }
        else
        {
            titolo.text = book.title as String
        }
    
        link.text = book.link
    
        let url = NSURL (string: book.link);
        let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj);
    
    }
    
    func action(sender:UIButton!) {
        self.dismissViewControllerAnimated(false, completion: nil)
        
    }
    func open(sender:UIButton!) {
        let requestUrl = NSURL(string: link.text!);UIApplication.sharedApplication().openURL(requestUrl!)
        
    }

}