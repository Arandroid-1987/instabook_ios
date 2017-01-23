//
//  DatabaseRealtime.swift
//  Instabook
//
//  Created by Marco Ferraro on 17/01/17.
//  Copyright © 2016 instabook. All rights reserved.
//

import Foundation
import Firebase

public class RetriveBestSellers
{
    var refFirebase: FIRDatabaseReference!
    private var cache = CacheManager();
    
    public func RetriveNews()
    {
        
    }
    
    public func retriveBestSellers(country: String)-> Array<Any>
    {
        print("Ricerca Best Sellers", terminator: "")
        var bookArray = [Any]();
        refFirebase = FIRDatabase.database().reference()
        let table = Constants.FIREBASE_BEST_SELLERS
        
        refFirebase.child(table).observeSingleEventOfType(.Value)
        {
            (snap:FIRDataSnapshot) in
            if(snap.hasChild(country))
            {
                let children = snap.childSnapshotForPath(country).children;
                while let rowBestSeller = children.nextObject() as? FIRDataSnapshot
                {
                    let book = Book();
                    book.imgLink = rowBestSeller.childSnapshotForPath("imgLink").value as! String
                    book.title = rowBestSeller.childSnapshotForPath("title").value as! String
                    book.price = rowBestSeller.childSnapshotForPath("price").value as! String
                    book.authors = rowBestSeller.childSnapshotForPath("authors").value as! [String]
                    book.link = rowBestSeller.childSnapshotForPath("link").value as! String
                    book.source = rowBestSeller.childSnapshotForPath("source").value as! String
                    book.descriptionBook = rowBestSeller.childSnapshotForPath("description").value as! String
                    bookArray.append(book);
                    
                }
                self.cache.storeBookBestSeller(bookArray)
                let todaysDate:NSDate = NSDate()
                let dateFormatter:NSDateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                self.cache.storeLastUpdatedDateBestSellerMondadori(dateFormatter.stringFromDate(todaysDate))
                NSNotificationCenter.defaultCenter().postNotification(NSNotification.init(name: Constants.RELOAD_BESTSELLERS_NOTIFICATION_NAME, object: nil));
            }
            else
            {
                let children = snap.childSnapshotForPath("default").children;
                while let rowBestSeller = children.nextObject() as? FIRDataSnapshot
                {
                    let book = Book();
                    book.imgLink = rowBestSeller.childSnapshotForPath("imgLink").value as! String
                    book.title = rowBestSeller.childSnapshotForPath("title").value as! String
                    book.price = rowBestSeller.childSnapshotForPath("price").value as! String
                    book.authors = rowBestSeller.childSnapshotForPath("authors").value as! [String]
                    book.link = rowBestSeller.childSnapshotForPath("link").value as! String
                    book.source = rowBestSeller.childSnapshotForPath("source").value as! String
                    book.descriptionBook = rowBestSeller.childSnapshotForPath("description").value as! String
                    bookArray.append(book);
                    
                }
                self.cache.storeBookBestSeller(bookArray)
                let todaysDate:NSDate = NSDate()
                let dateFormatter:NSDateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                self.cache.storeLastUpdatedDateBestSellerMondadori(dateFormatter.stringFromDate(todaysDate))
                NSNotificationCenter.defaultCenter().postNotification(NSNotification.init(name: Constants.RELOAD_BESTSELLERS_NOTIFICATION_NAME, object: nil));
            }
        }
        
        return bookArray;
    }
}
