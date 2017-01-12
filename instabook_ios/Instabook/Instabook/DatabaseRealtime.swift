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
                        let dateFormatter:NSDateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        currentData.value = dateFormatter.stringFromDate(todaysDate)
                        return FIRTransactionResult.successWithValue(currentData)
                        
                    }
                }
                else
                {
                    let todaysDate:NSDate = NSDate()
                    let dateFormatter:NSDateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let dateNow = dateFormatter.stringFromDate(todaysDate)
                    let dati_firebase = ["author": author, "query": queryText, "date_ios" : dateNow, "counter_ios" : "1" ]
                    
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
}
