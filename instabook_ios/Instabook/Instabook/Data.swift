//
//  Data.swift
//  Instabook
//
//  Created by Marco Ferraro on 24/11/16.
//  Copyright © 2016 instabook. All rights reserved.
//

import Foundation



class Data {
   
    private static var instance: Data!
    //var dict2 = [String: Book[]]()
    var dict = NSMutableDictionary()
    // SHARED INSTANCE
    class func sharedInstance() -> Data {
        if(instance == nil){
            self.instance = (self.instance ?? Data())
        }
        return self.instance
    }
    
    // METHODS
    init() {
        
    }
    
   
}