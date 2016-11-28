//
//  MySearch.swift
//  Instabook
//
//  Created by Leonardo Rania on 25/11/16.
//  Copyright (c) 2016 instabook. All rights reserved.
//

import Foundation

public class MySearch:NSObject, NSCoding
{
    var citazione: String!
    var autore:String!
    var data:String!
    
    public func MySearch(){}
    
    override init() {}
    
    required public init(coder aDecoder: NSCoder) {
        if let citazione = aDecoder.decodeObjectForKey("citazione") as? String {
            self.citazione = citazione
        }
        if let autore = aDecoder.decodeObjectForKey("autore") as? String {
            self.autore = autore
        }
        if let data = aDecoder.decodeObjectForKey("data") as? String {
            self.data = data
        }

    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(citazione, forKey: "citazione")
        aCoder.encodeObject(autore, forKey: "autore")
        aCoder.encodeObject(data, forKey: "data")
    }
}