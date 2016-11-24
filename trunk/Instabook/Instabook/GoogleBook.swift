//
//  GoogleBook.swift
//  Instabook
//
//  Created by Leonardo Rania on 23/11/16.
//  Copyright (c) 2016 instabook. All rights reserved.
//

import Foundation

public class GoogleBook
{
    
    public func GoogleBook(){}
    
    public class func searchCitanzione(citazioneFromMainPage: String, authorFromMainPage: String) -> Array<Any>
    {
        
        var arrayBooksInAuthor = Array<Any>();
        var arrayBooks = Array<Any>();
        var citazione:NSString = citazioneFromMainPage.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        var autore:NSString = authorFromMainPage.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        var url:NSURL ;
        if(!autore.isEqualToString(""))
        {
            url = NSURL(string: "https://www.googleapis.com/books/v1/volumes?q=\(citazione)+inauthor:\(autore)")!;
            arrayBooksInAuthor = self.callRESTGoogleBook(url)
            
            
        }
        else
        {
            url = NSURL(string: "https://www.googleapis.com/books/v1/volumes?q=\(citazione)+inauthor:")!;
            arrayBooksInAuthor = self.callRESTGoogleBook(url)
            url = NSURL(string: "https://www.googleapis.com/books/v1/volumes?q=\(citazione)")!;
            arrayBooks = self.callRESTGoogleBook(url)
        }
        
        var arrayBooksToReturn = Array<Any>();
        
        for(var i = 0 ; i < arrayBooksInAuthor.count + arrayBooks.count ; i++)
        {
            if( i >= arrayBooksInAuthor.count && i >= arrayBooks.count )
            {
                break;
            }
            if(i < arrayBooksInAuthor.count)
            {
                arrayBooksToReturn.append(arrayBooksInAuthor[i])
            }
            
            if(i < arrayBooks.count)
            {
                arrayBooksToReturn.append(arrayBooks[i]);
            }
            
        }
    
        return arrayBooksToReturn;
    }
    

    private class func callRESTGoogleBook(url: NSURL) -> Array<Any>
    {
        var arrayBooks = Array<Any>();
        var jsonData: NSObject;
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url);
        request.HTTPMethod = "GET";
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type");
        request.setValue("application/json", forHTTPHeaderField: "Accept");
        var reponseError: NSError?;
        var response: NSURLResponse?;
        var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError);
        if(urlData != nil)
        {
            var responseData:NSString = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!;
            NSLog("Response ==> %@", responseData);
            var error : NSError?;
            jsonData = NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSObject;
            if let error = error
            {
                println("Error : \(error)")
            }
            else
            {
                var items = jsonData.valueForKey("items") as NSArray;
                for item in items
                {
                    var bookItem = Book();
                    if let title: AnyObject = item.valueForKey("volumeInfo")?.valueForKey("title")
                    {
                        bookItem.title = title as NSString;
                    }
                    if let authors: AnyObject = item.valueForKey("volumeInfo")?.valueForKey("authors")
                    {
                        for author in authors as NSArray
                        {
                            bookItem.authors.append(author as NSString);
                        }
                    }
                    if let imgLink: AnyObject = item.valueForKey("volumeInfo")?.valueForKey("imageLinks")?.valueForKey("smallThumbnail")
                    {
                        bookItem.imgLink = imgLink as NSString;
                    }
                    
                    arrayBooks.append(bookItem);
                }
            }
        }
        return arrayBooks;
    }

}