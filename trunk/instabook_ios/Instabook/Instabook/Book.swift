//
//  Book.swift
//  Instabook
//
//  Created by Leonardo Rania on 19/11/16.
//  Copyright (c) 2016 instabook. All rights reserved.
//

import Foundation

@objc(Book)
public class Book:NSObject, NSCoding
{
    public let GOOGLE_SOURCE = "Google";
    public let MONDADORI_SOURCE = "Mondadori";
    
    public var title:String = "";
    public var price = "";
    public var authors = [String]();
    public var link = "";
    public var imgLink = "";
    public var category = "";
    public var descriptionBook = "";
    public var rating = "";
    public var position = "";
    public var favorite = false;
    public var source = "";
    
    
    public func Book()
    {
        
    }
    
    override init() {}
    
    required public init(coder aDecoder: NSCoder) {
        if let title = aDecoder.decodeObjectForKey("title") as? String {
            self.title = title
        }
        if let price = aDecoder.decodeObjectForKey("price") as? String {
            self.price = price
        }
        if let authors = aDecoder.decodeObjectForKey("authors") as? [String] {
            self.authors = authors
        }
        if let link = aDecoder.decodeObjectForKey("link") as? String {
            self.link = link
        }
        if let imgLink = aDecoder.decodeObjectForKey("imgLink") as? String {
            self.imgLink = imgLink
        }
        if let category = aDecoder.decodeObjectForKey("category") as? String {
            self.category = category
        }
        if let descriptionBook = aDecoder.decodeObjectForKey("descriptionBook") as? String {
            self.descriptionBook = descriptionBook
        }
        if let rating = aDecoder.decodeObjectForKey("rating") as? String {
            self.rating = rating
        }
        if let position = aDecoder.decodeObjectForKey("position") as? String {
            self.position = position
        }
        if let favorite = aDecoder.decodeObjectForKey("favorite") as? Bool {
            self.favorite = favorite
        }
        if let source = aDecoder.decodeObjectForKey("source") as? String {
            self.source = source
        }
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(price, forKey: "price")
        aCoder.encodeObject(authors, forKey: "authors")
        aCoder.encodeObject(link, forKey: "link")
        aCoder.encodeObject(imgLink, forKey: "imgLink")
        aCoder.encodeObject(category, forKey: "category")
        aCoder.encodeObject(descriptionBook, forKey: "descriptionBook")
        aCoder.encodeObject(rating, forKey: "rating")
        aCoder.encodeObject(position, forKey: "position")
        aCoder.encodeObject(favorite, forKey: "favorite")
        aCoder.encodeObject(source, forKey: "source")
        
        
    }

    
    
    
}