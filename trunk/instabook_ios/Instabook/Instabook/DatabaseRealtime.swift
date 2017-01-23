//
//  DatabaseRealtime.swift
//  Instabook
//
//  Created by Marco Ferraro on 29/11/16.
//  Copyright © 2016 instabook. All rights reserved.
//

import Foundation
import Firebase

public class DatabaseRealtime
{
    var refFirebase: FIRDatabaseReference!
    
    public func DatabaseRealtime()
    {
        
    }
    
    public func writeBookClicked(book : Book, currentCountry: String, complexQuery: String)
    {
        refFirebase = FIRDatabase.database().reference()
        let primaryKey = self.getPrimaryKeyBook(book);
        let table = Constants.FIREBASE_TABLE_BOOK_CLICK
       
        refFirebase.child(table).child(currentCountry).observeSingleEventOfType(.Value)
        {
            (snap:FIRDataSnapshot) in
            if(snap.hasChild(primaryKey))
            {
                let ref = self.refFirebase.child(table).child(currentCountry).child(primaryKey)
                ref.child(Constants.COUNTER).runTransactionBlock{ (currentData: FIRMutableData) -> FIRTransactionResult in
                        
                    var value = currentData.value as? Int
                    
                    if value == nil {
                        value = 0
                    }
                    
                    currentData.value = value! + 1
                    return FIRTransactionResult.successWithValue(currentData)
                        
                }
                
                ref.child(Constants.DATE_NAME).runTransactionBlock{ (currentData: FIRMutableData) -> FIRTransactionResult in
                        
                    let todaysDate:NSDate = NSDate()
                    currentData.value = DateHelper.encodeDateForFirebase(todaysDate)
                    return FIRTransactionResult.successWithValue(currentData)
                    
                }
                
                ref.child(Constants.BOOK_NAME).runTransactionBlock{ (currentData: FIRMutableData) -> FIRTransactionResult in
                    
                    currentData.value = book.encodeForFirebase()
                    return FIRTransactionResult.successWithValue(currentData)
                    
                }
                
                if(book.source == book.GOOGLE_SOURCE)
                {
                    ref.child(Constants.QUERY_NAME).runTransactionBlock{ (currentData: FIRMutableData) -> FIRTransactionResult in
                        
                        let children = snap.childSnapshotForPath(primaryKey).childSnapshotForPath(Constants.QUERY_NAME).children;
                        var found = false
                        var count = 0
                        while let child = children.nextObject() as? FIRDataSnapshot
                        {
                            if(child.value as! String == complexQuery)
                            {
                                found = true
                            }
                            count += 1
                            
                        }
                        
                        if(!found)
                        {
                            currentData.childDataByAppendingPath("\(count)").value = complexQuery
                        }
                        
                       
                        return FIRTransactionResult.successWithValue(currentData)
                        
                    }
                }
                

            }
            else
            {
                let todaysDate:NSDate = NSDate()
                var dati_firebase = NSDictionary();
                if(book.source == book.GOOGLE_SOURCE)
                {
                    dati_firebase = ["book": book.encodeForFirebase(), "date": DateHelper.encodeDateForFirebase(todaysDate), "counter": 1, "primaryKey": primaryKey, "query": complexQuery ]
                }
                else
                {
                     dati_firebase = ["book": book.encodeForFirebase(), "date": DateHelper.encodeDateForFirebase(todaysDate), "counter": 1, "primaryKey": primaryKey ]
                    
                }
                
                self.refFirebase.child(table).child(currentCountry).child(primaryKey).setValue(dati_firebase)
            }
        }
        
    }
    
    
    public func writeNewAggregateVote()
    {
        
    }
    
    public func writeNewQueryHit(queryText: String, author: String, currentCountry: String)
    {
        refFirebase = FIRDatabase.database().reference()
        let primaryKey = self.calculateQueryPrimaryKey(queryText, author: author)
        let table = Constants.FIREBASE_TABLE_QUERY_HIT
        if(queryText != "" || author != "")
        {
            refFirebase.child(table).child(currentCountry).observeSingleEventOfType(.Value)
            {
                (snap:FIRDataSnapshot) in
                if(snap.hasChild(primaryKey))
                {
                    let ref = self.refFirebase.child(table).child(currentCountry).child(primaryKey)
                    ref.child(Constants.COUNTER).runTransactionBlock{ (currentData: FIRMutableData) -> FIRTransactionResult in
                        
                        var value = currentData.value as? Int
                        
                        if value == nil {
                            value = 0
                        }
                        
                        currentData.value = value! + 1
                        return FIRTransactionResult.successWithValue(currentData)
                
                    }
                    
                    ref.child(Constants.DATE_NAME).runTransactionBlock{ (currentData: FIRMutableData) -> FIRTransactionResult in
                        
                        let todaysDate:NSDate = NSDate()
                        currentData.value = DateHelper.encodeDateForFirebase(todaysDate)
                        return FIRTransactionResult.successWithValue(currentData)
                        
                    }
                }
                else
                {
                    let todaysDate:NSDate = NSDate()
                    let dati_firebase = ["author": author, "query": queryText, "date" : DateHelper.encodeDateForFirebase(todaysDate), "counter" : 1 ]
                    
                    self.refFirebase.child(table).child("IT").child(primaryKey).setValue(dati_firebase)
                }
            }
        }
    }
    
    private func calculateQueryPrimaryKey(queryText:String, author:String) -> String
    {
        var primaryKey = ""
        if(queryText != "" && author != "")
        {
            primaryKey = queryText.lowercaseString + "-" + author.lowercaseString
        }
        else if(author != "")
        {
            primaryKey = author.lowercaseString
        }
        else
        {
            primaryKey = queryText.lowercaseString
        }
        
        return generateFirebasePath(primaryKey)
    }
    
    public func generateFirebasePath(primaryKey: String) -> String
    {
        let primaryKeyReplacing = primaryKey.stringByReplacingOccurrencesOfString(".", withString: "").stringByReplacingOccurrencesOfString("#", withString: " ").stringByReplacingOccurrencesOfString("$", withString: " ").stringByReplacingOccurrencesOfString("[", withString: " ").stringByReplacingOccurrencesOfString("]", withString: " ").stringByReplacingOccurrencesOfString("\"", withString: "")
        return primaryKeyReplacing
    }
    
    public func getPrimaryKeyBook(book: Book) -> String
    {
        var authorPrintable = ""
        var ind = 0
        for i in book.authors
        {
            authorPrintable.appendContentsOf(i)
            ind += 1
            if(ind < book.authors.count){
                authorPrintable.appendContentsOf(", ")
            }
            
        }
        return generateFirebasePath(authorPrintable + " - " + book.title).lowercaseString;
    }
}
