//
//  LicenzaView.swift
//  Instabook
//
//  Created by Marco Ferraro on 04/12/16.
//  Copyright © 2016 instabook. All rights reserved.
//

import Foundation
import StoreKit

class LicenzaView: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver
{
    @IBOutlet weak var pubButton: UIButton!
    @IBOutlet weak var licenzaLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backView: UIView!
    
    var cacheManager = CacheManager();
    var request: SKProductsRequest!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.addTarget(self, action: #selector(LicenzaView.back(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let tapBackView = UITapGestureRecognizer(target:self, action:#selector(LicenzaView.back(_:)))
        backView.addGestureRecognizer(tapBackView)
        //pubButton.frame = CGRectMake(20, 20, 200, 50)
        pubButton.setTitle(NSLocalizedString("upgradeAdv", comment: "upgradeAdv").uppercaseString, forState: .Normal)
        pubButton.layer.cornerRadius = 0.05 * pubButton.bounds.size.width
        
        pubButton.backgroundColor = UIColor(red: 255.0/255, green: 217.0/255, blue: 3.0/255, alpha: 1.0)
               pubButton.layer.shadowOffset = CGSizeMake(0.1, 1.0);
        pubButton.layer.shadowOpacity = 0.2;
        pubButton.layer.shadowRadius = 0.0;
        pubButton.addTarget(self, action: #selector(LicenzaView.removePub(_:)), forControlEvents: UIControlEvents.TouchUpInside)

        if(!cacheManager.getLicense())
        {
            licenzaLabel.text = NSLocalizedString("purchased_products", comment: "purchased_products") + "\n" + NSLocalizedString("product_ads", comment: "product_ads")
            licenzaLabel.text = NSLocalizedString("no_purchased_products", comment: "no_purchased_products")
        }
        else
        {
            licenzaLabel.text = NSLocalizedString("purchased_products", comment: "purchased_products") + "\n" + NSLocalizedString("product_ads", comment: "product_ads")
            pubButton.hidden = true;
        }
        
        
        //BUY PRODUCT
        // Set IAPS
        if(SKPaymentQueue.canMakePayments())
        {
            let productID:NSSet = NSSet(objects: "com.arandroid.instabook.removeads")
            request = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            request.delegate = self
            request.start()
        }
        else
        {
        }
        
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }


    
    func back(sender:UIButton!)
    {
        request.delegate = nil
        SKPaymentQueue.defaultQueue().removeTransactionObserver(self);
        self.dismissViewControllerAnimated(false, completion: nil)
        
    }
    
    func removePub(sender:UIButton!) {
        
        for product in list {
            let prodID = product.productIdentifier
            if(prodID == "com.arandroid.instabook.removeads")
            {
                p = product
                buyProduct()
                break;
            }
        }
        
    }
    
    var list = [SKProduct]()
    var p = SKProduct()
    
    func buyProduct()
    {
        let pay = SKPayment(product: p)
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().addPayment(pay as SKPayment)
    }
    
    
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        
        let myProduct = response.products
        
        for product in myProduct {
            list.append(product )
        }
        if(list.count == 0)
        {
            let snackbar = MKSnackbar(
                withTitle: NSLocalizedString("connection_unavailable", comment: "connection_unavailable"),
                withDuration: 1.5,
                withTitleColor: nil,
                withActionButtonTitle: "",
                withActionButtonColor: UIColor.lightGrayColor())
            snackbar.show()
        }
        
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
    
        for transaction in queue.transactions {
            let t: SKPaymentTransaction = transaction
            
            let prodID = t.payment.productIdentifier as String
            
            switch prodID {
            case "com.arandroid.instabook.removeads":
                removeAds()
            default: ""
                
            }
            
        }
    }

    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction:AnyObject in transactions {
            let trans = transaction as! SKPaymentTransaction
            
            switch trans.transactionState {
                
            case .Purchased:
                
                let prodID = p.productIdentifier as String
                switch prodID {
                case "com.arandroid.instabook.removeads":
                    removeAds()
                default: ""
                }
                
                queue.finishTransaction(trans)
                break;
            case .Failed:
                queue.finishTransaction(trans)
                break;
            default:
                break;
                
            }
        }
    }
    
    func finishTransaction(trans:SKPaymentTransaction)
    {
        SKPaymentQueue.defaultQueue().finishTransaction(trans)
    }
    
    func paymentQueue(queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction])
    {
    }
    
    
    func removeAds() {
        pubButton.hidden = true
        let snackbar = MKSnackbar(
            withTitle: NSLocalizedString("congratulations_premium_user", comment: "congratulations_premium_user"),
            withDuration: 1.5,
            withTitleColor: nil,
            withActionButtonTitle: "",
            withActionButtonColor: UIColor.lightGrayColor())
        snackbar.show()
        licenzaLabel.text = NSLocalizedString("purchased_products", comment: "purchased_products") + "\n" + NSLocalizedString("product_ads", comment: "product_ads")
        cacheManager.storeLicense(true);
    }
    
}