//
//  RetriveFromVoteWS.swift
//  Instabook
//
//  Created by MacBook on 23/01/17.
//  Copyright © 2017 instabook. All rights reserved.
//

import Foundation
public class RetriveFromVoteWS
{
    public static func retriveBook(quote: String, country: String) -> Book?
    {
        let book = Book()
        
        
        let urlString:NSString = "\(Constants.VOTEWS_LINK)?query=\(quote)&language=\(country)"
        let urlStringEncode = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        let url =  NSURL(string: urlStringEncode)!;
        var jsonData: NSObject;
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url);
        request.HTTPMethod = "GET";
        //var reponseError: NSError?;
        var response: NSURLResponse?;
        let urlData: NSData?
        do
        {
            urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response);
        }
        catch
        {
            //let reponseError = error1
            urlData = nil
        }
        
        if(urlData != nil)
        {
            let responseData:NSString = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!;
            NSLog("Response ==> %@", responseData);
            var error : NSError?;
            jsonData = NSObject()
            do {
                jsonData = try NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers) as! NSObject;
            } catch let error1 as NSError {
                error = error1
                
            }
            
            if let error = error
            {
                print("Error : \(error)")
            }
            else
            {
                if(jsonData.valueForKeyPath("book") == nil)
                {
                    return nil;
                }
                let item = jsonData.valueForKey("book") as! NSObject;
                if let title: AnyObject = item.valueForKey("title")
                {
                    book.title = title as! String;
                }
                if let authors: AnyObject = item.valueForKey("authors")
                {
                    for author in authors as! NSArray
                    {
                        book.authors.append(author as! String);
                    }
                }
                if let description: AnyObject = item.valueForKey("description")
                {
                    book.descriptionBook = description as! NSString as String;
                }
                if let imgLink: AnyObject = item.valueForKey("imgLink")
                {
                    book.imgLink = imgLink as! NSString as String;
                }
                if let link: AnyObject = item.valueForKey("link")
                {
                    book.link = link as! NSString as String;
                }
                if let rating: Double = item.valueForKey("rating") as? Double
                {
                    book.rating = rating;
                }
                if let price: AnyObject = item.valueForKey("price")
                {
                    book.price = "\(price)"
                }
            }
        }
        
        return book;
    }
}