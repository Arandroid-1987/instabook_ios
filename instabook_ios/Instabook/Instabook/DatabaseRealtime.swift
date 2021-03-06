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
    
    
    private func writeNewAggregateVote(book: Book, query: String, score: Int, uuid: String, currentCountry: String )
    {
        refFirebase = FIRDatabase.database().reference()
        let primaryKey = generateFirebasePath(query);
        let bookPrimaryKey = getPrimaryKeyBook(book);
        let table = Constants.FIREBASE_TABLE_VOTES_AGG;
        
        refFirebase.child(table).child(currentCountry).child(primaryKey).observeSingleEventOfType(.Value)
        {
            (snap:FIRDataSnapshot) in
            if(snap.hasChild(bookPrimaryKey))
            {
                let ref = self.refFirebase.child(table).child(currentCountry).child(primaryKey).child(bookPrimaryKey)
                ref.child(Constants.SCORE_NAME).runTransactionBlock{ (currentData: FIRMutableData) -> FIRTransactionResult in
                    
                    var value = currentData.value as? Int
                    
                    if value == nil
                    {
                        value = score
                    }
                    
                    currentData.value = value! + score
                    return FIRTransactionResult.successWithValue(currentData)
                    
                }
                
                ref.child(Constants.BOOK_NAME).runTransactionBlock{ (currentData: FIRMutableData) -> FIRTransactionResult in
                    
                    currentData.value = book.encodeForFirebase();
                    return FIRTransactionResult.successWithValue(currentData)
                    
                }
                
            }
            else
            {
                var dati_firebase = NSDictionary();
                dati_firebase = ["book": book.encodeForFirebase(), "score": score]
                self.refFirebase.child(table).child(currentCountry).child(primaryKey).child(bookPrimaryKey).setValue(dati_firebase)
            }
        }

    }
    
    public func writeNewSingleAndAggregateVote(book: Book, query: String, score: Int, uuid: String, currentCountry: String )
    {
        refFirebase = FIRDatabase.database().reference()
        let primaryKey = generateFirebasePath(query);
        let bookPrimaryKey = getPrimaryKeyBook(book);
        let table = Constants.FIREBASE_TABLE_VOTES;
        
        refFirebase.child(table).child(currentCountry).child(primaryKey).child(uuid).observeSingleEventOfType(.Value)
        {
            (snap:FIRDataSnapshot) in
            if(snap.hasChild(bookPrimaryKey))
            {//Libro già votato non dobbiamo accettare altre votazioni TODO
                NSNotificationCenter.defaultCenter().postNotification(NSNotification.init(name: Constants.LOAD_SNACKBAR_KO_NOTIFICATION_NAME, object: nil));
            }
            else
            {//voto su nuovo libro e poi scrivo sull'aggregato
                
                NSNotificationCenter.defaultCenter().postNotification(NSNotification.init(name: Constants.LOAD_SNACKBAR_OK_NOTIFICATION_NAME, object: nil));
                
                let todaysDate:NSDate = NSDate()
                var dati_firebase = NSDictionary();
                
                dati_firebase = ["book": book.encodeForFirebase(), "date": DateHelper.encodeDateForFirebase(todaysDate), "score": score]
                
                self.refFirebase.child(table).child(currentCountry).child(primaryKey).child(uuid).child(bookPrimaryKey).setValue(dati_firebase)
                
                self.writeNewAggregateVote(book, query: query, score: score, uuid: uuid, currentCountry: currentCountry)
                
                
            }
        }
        
    }
    
    public func writeMissingResult(missingResult: MissingResult)
    {
        refFirebase = FIRDatabase.database().reference()
        let table = Constants.FIREBASE_TABLE_MISSING_RESULTS;
        let key = refFirebase.child(table).key;
        
        let dati_firebase = missingResult.encodeForFirebase();
        self.refFirebase.child(table).child(key).setValue(dati_firebase);
        
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
                    
                    self.refFirebase.child(table).child(CacheManager().getStoredLang().lowercaseString).child(primaryKey).setValue(dati_firebase)
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
        return primaryKeyReplacing.lowercaseString
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
