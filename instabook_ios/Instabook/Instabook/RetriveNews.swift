//
//  DatabaseRealtime.swift
//  Instabook
//
//  Created by Marco Ferraro on 17/01/17.
//  Copyright © 2016 instabook. All rights reserved.
//

import Foundation
import Firebase

public class RetriveNews
{
    var refFirebase: FIRDatabaseReference!
    private var cache = CacheManager();
    
    public func RetriveNews()
    {
        
    }
    
    public func retriveNews(country: String)-> Array<Any>
    {
        print("Ricerca Nuovi Libri", terminator: "")
        var bookArray = [Any]();
        refFirebase = FIRDatabase.database().reference()
        let table = Constants.FIREBASE_TABLE_NEWS
        
        refFirebase.child(table).observeSingleEventOfType(.Value)
        {
            (snap:FIRDataSnapshot) in
            if(snap.hasChild(country))
            {
                let children = snap.childSnapshotForPath(country).children;
                while let rowNews = children.nextObject() as? FIRDataSnapshot
                {
                    let book = Book();
                    book.imgLink = rowNews.childSnapshotForPath("imgLink").value as! String
                    book.title = rowNews.childSnapshotForPath("title").value as! String
                    book.price = rowNews.childSnapshotForPath("price").value as! String
                    book.authors = rowNews.childSnapshotForPath("authors").value as! [String]
                    book.link = rowNews.childSnapshotForPath("link").value as! String
                    book.source = rowNews.childSnapshotForPath("source").value as! String
                    book.descriptionBook = rowNews.childSnapshotForPath("description").value as! String
                    bookArray.append(book);
                        
                }
                self.cache.storeBook(bookArray)
                let todaysDate:NSDate = NSDate()
                let dateFormatter:NSDateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                self.cache.storeLastUpdatedDate(dateFormatter.stringFromDate(todaysDate))
                NSNotificationCenter.defaultCenter().postNotification(NSNotification.init(name: Constants.RELOAD_NEWS_NOTIFICATION_NAME, object: nil));
            }
            else
            {
                let children = snap.childSnapshotForPath("default").children;
                while let rowNews = children.nextObject() as? FIRDataSnapshot
                {
                    let book = Book();
                    book.imgLink = rowNews.childSnapshotForPath("imgLink").value as! String
                    book.title = rowNews.childSnapshotForPath("title").value as! String
                    book.price = rowNews.childSnapshotForPath("price").value as! String
                    book.authors = rowNews.childSnapshotForPath("authors").value as! [String]
                    book.link = rowNews.childSnapshotForPath("link").value as! String
                    book.source = rowNews.childSnapshotForPath("source").value as! String
                    book.descriptionBook = rowNews.childSnapshotForPath("description").value as! String
                    bookArray.append(book);
                    
                }
                self.cache.storeBook(bookArray)
                let todaysDate:NSDate = NSDate()
                let dateFormatter:NSDateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                self.cache.storeLastUpdatedDate(dateFormatter.stringFromDate(todaysDate))
                NSNotificationCenter.defaultCenter().postNotification(NSNotification.init(name: Constants.RELOAD_NEWS_NOTIFICATION_NAME, object: nil));
            }
        }
        
         return bookArray;
    }
}
