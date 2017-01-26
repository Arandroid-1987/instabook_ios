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
        let databaseFirebase = DatabaseRealtime()
        databaseFirebase.writeNewQueryHit(citazioneFromMainPage, author: authorFromMainPage, currentCountry: "IT");
        var arrayBooksInAuthor = Array<Any>();
        var arrayBooksQuote = Array<Any>();
        var arrayBooks = Array<Any>();
        let citazione:NSString = citazioneFromMainPage.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        let autore:NSString = authorFromMainPage.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        
        var url:NSURL ;
        if(!autore.isEqualToString("") && !citazione.isEqualToString(""))
        {
            CacheManager().storeSearch(authorFromMainPage, id: Constants.ID_SEARCH_AUTORE)
            CacheManager().storeSearch(citazioneFromMainPage, id: Constants.ID_SEARCH_CITAZIONE)
            
            url = NSURL(string: "https://www.googleapis.com/books/v1/volumes?q=\(citazione)+inauthor:\(autore)&key=\(Constants.API_KEY)")!;
            arrayBooksInAuthor = self.callRESTGoogleBook(url, autore: authorFromMainPage, citazione: citazioneFromMainPage)
            
            return arrayBooksInAuthor;
            
        }
        else if(!autore.isEqualToString(""))
        {
            CacheManager().storeSearch(authorFromMainPage, id: Constants.ID_SEARCH_AUTORE)
        
            url = NSURL(string: "https://www.googleapis.com/books/v1/volumes?q=inauthor:\(autore)&key=\(Constants.API_KEY)")!;
            arrayBooksInAuthor = self.callRESTGoogleBook(url, autore: authorFromMainPage, citazione: "")
            return arrayBooksInAuthor;
        }
        else
        {
            CacheManager().storeSearch(citazioneFromMainPage, id: Constants.ID_SEARCH_CITAZIONE)
            
            url = NSURL(string: "https://www.googleapis.com/books/v1/volumes?q=%22\(citazione)%22&key=\(Constants.API_KEY)")!;
            arrayBooksQuote = self.callRESTGoogleBook(url, autore: "", citazione: citazioneFromMainPage)
            url = NSURL(string: "https://www.googleapis.com/books/v1/volumes?q=\(citazione)&key=\(Constants.API_KEY)")!;
            arrayBooks = self.callRESTGoogleBook(url, autore: "", citazione: citazioneFromMainPage)
        }
        
        var arrayBooksToReturn = Array<Any>();
        
        arrayBooksToReturn.appendContentsOf(arrayBooksQuote);
        arrayBooksToReturn.appendContentsOf(arrayBooks);
        
        return arrayBooksToReturn;
    }
    

    private class func callRESTGoogleBook(url: NSURL, autore: String, citazione: String) -> Array<Any>
    {
        var arrayBooks = Array<Any>();
        var jsonData: NSObject;
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url);
        request.HTTPMethod = "GET";
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type");
        request.setValue("application/json", forHTTPHeaderField: "Accept");
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
                if(jsonData.valueForKeyPath("items") == nil)
                {
                    return Array<Any>()
                }
                let items = jsonData.valueForKey("items") as! NSArray;
                for item in items
                {
                    let bookItem = Book();
                    bookItem.source = bookItem.GOOGLE_SOURCE;
                    if let title: AnyObject = item.valueForKey("volumeInfo")?.valueForKey("title")
                    {
                        bookItem.title = title as! String;
                    }
                    if let authors: AnyObject = item.valueForKey("volumeInfo")?.valueForKey("authors")
                    {
                        for author in authors as! NSArray
                        {
                            bookItem.authors.append(author as! String);
                        }
                    }
                    if let description: AnyObject = item.valueForKey("volumeInfo")?.valueForKey("description")
                    {
                        bookItem.descriptionBook = description as! NSString as String;
                    }
                    if let imgLink: AnyObject = item.valueForKey("volumeInfo")?.valueForKey("imageLinks")?.valueForKey("smallThumbnail")
                    {
                        bookItem.imgLink = imgLink as! NSString as String;
                    }
                    if let canonicalVolumeLink: AnyObject = item.valueForKey("volumeInfo")?.valueForKey("canonicalVolumeLink")
                    {
                        bookItem.link = canonicalVolumeLink as! NSString as String;
                    }
                    if let averageRating: AnyObject = item.valueForKey("volumeInfo")?.valueForKey("averageRating")
                    {
                        bookItem.rating = Double(averageRating as! NSNumber);
                    }
                    if let saleInfo: AnyObject = item.valueForKey("saleInfo")?.valueForKey("listPrice")?.valueForKey("amount")
                    {
                        bookItem.price = "\(saleInfo)"
                        if let currencyCode: AnyObject = item.valueForKey("saleInfo")?.valueForKey("listPrice")?.valueForKey("currencyCode")
                        {
                            bookItem.price += " \(currencyCode)"
                        }
                    }

                    
                    arrayBooks.append(bookItem);
                }
            }
        }
        
        let cacheManager = CacheManager()
        let mySearch = MySearch()
        mySearch.autore = autore
        mySearch.citazione = citazione
        let todaysDate:NSDate = NSDate()
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        mySearch.data = dateFormatter.stringFromDate(todaysDate)
        if(arrayBooks.count > 0)
        {
            mySearch.imgLink = (arrayBooks[0] as! Book).imgLink
        }
        cacheManager.storeMySearch(mySearch)
        return arrayBooks;
    }

}