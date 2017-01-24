//
//  MissingResult.swift
//  Instabook
//
//  Created by MacBook on 24/01/17.
//  Copyright © 2017 instabook. All rights reserved.
//

import Foundation
public class MissingResult
{
    let quote = "";
    let title = "";
    let author = "";
    let date = NSDate();
    let system = "";
    
    public func encodeForFirebase() -> NSDictionary
    {
        let dictionary: NSDictionary = [
            "quote" : quote,
            "title" : title,
            "author" : author,
            "system" : system,
            "date" : DateHelper.encodeDateForFirebase(date)
        ]
    
    return dictionary;
    }
    
}