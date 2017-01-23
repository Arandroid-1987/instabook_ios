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
    public let FIREBASE = "Firebase";
    
    public var title:String = "";
    public var price = "";
    public var authors = [String]();
    public var link = "";
    public var imgLink = "";
    public var category = "";
    public var descriptionBook = "";
    public var rating = Double();
    public var position = "";
    public var favorite = false;
    public var source = "";
    public var primaryKey = "";
    public var userHasVoted = false;
    public var snippet = "";
    public var isEbook = false;
    public var isbn10 = "";
    public var isbn13 = "";
    public var printableAuthors = "";
    
    
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
        if let rating = aDecoder.decodeObjectForKey("rating") as? Double {
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
        if let printableAuthors = aDecoder.decodeObjectForKey("printableAuthors") as? String {
            self.printableAuthors = printableAuthors
        }
        if let ebook = aDecoder.decodeObjectForKey("ebook") as? Bool {
            self.isEbook = ebook
        }
        if let isbn10 = aDecoder.decodeObjectForKey("isbn10") as? String {
            self.isbn10 = isbn10
        }
        if let isbn13 = aDecoder.decodeObjectForKey("isbn13") as? String {
            self.isbn13 = isbn13
        }
        if let primaryKey = aDecoder.decodeObjectForKey("primaryKey") as? String {
            self.primaryKey = primaryKey
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
        aCoder.encodeObject(printableAuthors, forKey: "printableAuthors")
        aCoder.encodeObject(isEbook, forKey: "ebook")
        aCoder.encodeObject(isbn10, forKey: "isbn10")
        aCoder.encodeObject(isbn13, forKey: "isbn13")
        aCoder.encodeObject(primaryKey, forKey: "primaryKey")
        
        
    }
    
    
    public func encodeForFirebase() -> NSDictionary
    {
        let dictionary: NSDictionary = [
            "title" : title,
            "price" : price,
            "authors" : authors,
            "link" : link,
            "imgLink" : imgLink,
            "category" : category,
            "description" : descriptionBook,
            "rating" : rating,
            "position" : position,
            "favorite" : favorite,
            "source" : source,
            "ebook" : isEbook,
            "isbn10": isbn10,
            "isbn13": isbn13,
            "primaryKey": primaryKey,
            "printableAuthors": printableAuthors,
            "snippet": snippet
            
        ]
        
        return dictionary;
    }

    
    
    
}