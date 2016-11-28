//
//  CacheManager.swift
//  Instabook
//
//  Created by Leonardo Rania on 25/11/16.
//  Copyright (c) 2016 instabook. All rights reserved.
//

import Foundation

public class CacheManager
{
    public func CacheManger(){}
    
    public var imageDownload = false;
    
    var cache:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    
    public func storeMySearch(mySearch: MySearch)
    {
        
        if let myStoredSearchArray = self.cache.objectForKey(Constants.MY_SEARCH_STORED) as? NSData {
            var myStoredSearch = NSKeyedUnarchiver.unarchiveObjectWithData(myStoredSearchArray) as  Array<MySearch>
            var i = 0;
            for myStoredSearchItem in myStoredSearch
            {
                if (myStoredSearchItem.citazione == mySearch.citazione)
                {
                    if (myStoredSearchItem.autore == mySearch.autore)
                    {
                        myStoredSearch.removeAtIndex(i)
                        break;
                    }
                }
                i++;
            }
            
            myStoredSearch.append(mySearch)
            self.cache.removeObjectForKey(Constants.MY_SEARCH_STORED)
            self.cache.setObject(NSKeyedArchiver.archivedDataWithRootObject(myStoredSearch), forKey: Constants.MY_SEARCH_STORED)
            
        }
        else
        {
            var myStoredSearch: Array<MySearch> = Array<MySearch>()
            myStoredSearch.append(mySearch)
            self.cache.setObject(NSKeyedArchiver.archivedDataWithRootObject(myStoredSearch), forKey: Constants.MY_SEARCH_STORED)
        }
    }
    
    public func storeLikeBook(book: Book)
    {
        if let myBookStoredArray = self.cache.objectForKey(Constants.MY_BOOKS_LIKE_STORED) as? NSData {
           
            var myBookStored = NSKeyedUnarchiver.unarchiveObjectWithData(myBookStoredArray) as Array<Book>
            myBookStored.append(book)
            self.cache.removeObjectForKey(Constants.MY_BOOKS_LIKE_STORED)
            self.cache.setObject(NSKeyedArchiver.archivedDataWithRootObject(myBookStored), forKey: Constants.MY_BOOKS_LIKE_STORED)
        }
        else
        {
            var myBookStored: Array<Book> = Array<Book>()
            myBookStored.append(book)
            self.cache.setObject(NSKeyedArchiver.archivedDataWithRootObject(myBookStored), forKey: Constants.MY_BOOKS_LIKE_STORED)
        }
    }
    
    public func removeStoreLikeBook(book: Book)
    {
        if let mySearchStoredArray = self.cache.objectForKey(Constants.MY_BOOKS_LIKE_STORED) as? NSData {
            var i = 0
            var myBookStored = NSKeyedUnarchiver.unarchiveObjectWithData(mySearchStoredArray) as Array<Book>
            for myBookStoredItem in myBookStored
            {
                if (myBookStoredItem.link == book.link)
                {
                    myBookStored.removeAtIndex(i)
                    break;
                }
                i++;
            }
        
            self.cache.removeObjectForKey(Constants.MY_BOOKS_LIKE_STORED)
            self.cache.setObject(NSKeyedArchiver.archivedDataWithRootObject(myBookStored), forKey: Constants.MY_BOOKS_LIKE_STORED)
        }
        
    }
    
    public func storeLastUpdatedDateFromMondadori(dateTime: String)
    {
        self.cache.removeObjectForKey(Constants.BOOKS_MONDADORI_STORED_DATE)
        self.cache.setObject(dateTime, forKey: Constants.BOOKS_MONDADORI_STORED_DATE)
    }
    
    public func storeLastUpdatedDateBestSellerMondadori(dateTime: String)
    {
        self.cache.removeObjectForKey(Constants.BOOKS_MONDADORI_STORED_DATE_BEST_SELLER)
        self.cache.setObject(dateTime, forKey: Constants.BOOKS_MONDADORI_STORED_DATE_BEST_SELLER)
    }
    
    public func storeBookFromMondadoriBestSeller(books: Array<Any>)
    {
        var booksToStored: Array<Book> = Array<Book>()
        for book in books
        {
            booksToStored.append(book as Book)
        }
        self.cache.removeObjectForKey(Constants.BOOKS_MONDADORI_STORED_BEST_SELLER)
        self.cache.setObject(NSKeyedArchiver.archivedDataWithRootObject(booksToStored), forKey: Constants.BOOKS_MONDADORI_STORED_BEST_SELLER)
    }
    
    public func storeBookFromMondadori(books: Array<Any>)
    {
        var booksToStored: Array<Book> = Array<Book>()
        for book in books
        {
            booksToStored.append(book as Book)
        }
        self.cache.removeObjectForKey(Constants.BOOKS_MONDADORI_STORED)
        self.cache.setObject(NSKeyedArchiver.archivedDataWithRootObject(booksToStored), forKey: Constants.BOOKS_MONDADORI_STORED)
    }
    
    public func deleteMySearch()
    {
        self.cache.removeObjectForKey(Constants.MY_SEARCH_STORED)
    }
    
    public func deleteMyBook()
    {
        self.cache.removeObjectForKey(Constants.MY_BOOKS_LIKE_STORED)
    }
    
    public func deleteBestSeller()
    {
        self.cache.removeObjectForKey(Constants.BOOKS_MONDADORI_STORED_BEST_SELLER)
        self.cache.removeObjectForKey(Constants.BOOKS_MONDADORI_STORED_DATE_BEST_SELLER)
    }
    
    public func deleteNews()
    {
        self.cache.removeObjectForKey(Constants.BOOKS_MONDADORI_STORED)
        self.cache.removeObjectForKey(Constants.BOOKS_MONDADORI_STORED_DATE)
    }
    
    public func deleteAll()
    {
        deleteMyBook();
        deleteMySearch();
        deleteNews();
        deleteBestSeller();
        for key in NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys {
            NSUserDefaults.standardUserDefaults().removeObjectForKey(key.description)
        }
    }
    
    public func getMySearchStored() -> Array<Any>
    {
        if let mySearchStoredArray = self.cache.objectForKey(Constants.MY_SEARCH_STORED) as? NSData {
            
            var arrayToReturn = Array<Any>()
            for mySearchStoredItem in NSKeyedUnarchiver.unarchiveObjectWithData(mySearchStoredArray) as Array<MySearch>
            {
                arrayToReturn.append(mySearchStoredItem)
            }
            
            return arrayToReturn;
        }
        else
        {
            return Array<Any>();
        }
    }
    
    public func getMyBooksLikeStored() -> Array<Any>
    {
        if let booksArray = self.cache.objectForKey(Constants.MY_BOOKS_LIKE_STORED) as? NSData {
            
            var arrayToReturn = Array<Any>()
            for book in NSKeyedUnarchiver.unarchiveObjectWithData(booksArray) as Array<Book>
            {
                arrayToReturn.append(book)
            }
            
            return arrayToReturn;
        }
        else
        {
            return Array<Any>();
        }
    }
    
    public func getMondadoriBooks() -> Array<Any>
    {
        if let booksArray = self.cache.objectForKey(Constants.BOOKS_MONDADORI_STORED) as? NSData {
            
            var arrayToReturn = Array<Any>()
            for book in NSKeyedUnarchiver.unarchiveObjectWithData(booksArray) as Array<Book>
            {
                arrayToReturn.append(book)
            }
            
            return arrayToReturn;
        }
        else
        {
            return Array<Any>();
        }
    }
    
    public func getMondadoriBooksBestSeller() -> Array<Any>
    {
        if let booksArray = self.cache.objectForKey(Constants.BOOKS_MONDADORI_STORED_BEST_SELLER) as? NSData {
            
            var arrayToReturn = Array<Any>()
            for book in NSKeyedUnarchiver.unarchiveObjectWithData(booksArray) as Array<Book>
            {
                arrayToReturn.append(book)
            }
            
            return arrayToReturn;
        }
        else
        {
            return Array<Any>();
        }
    }
    
    public func getMondadoriBestSellerLastDateUpdate() -> String
    {
        if(self.cache.objectForKey(Constants.BOOKS_MONDADORI_STORED_DATE_BEST_SELLER) != nil)
        {
            return self.cache.objectForKey(Constants.BOOKS_MONDADORI_STORED_DATE_BEST_SELLER) as String
        }
        else
        {
            return "";
        }
    }
    
    public func getMondadoriLastDateUpdate() -> String
    {
        if(self.cache.objectForKey(Constants.BOOKS_MONDADORI_STORED_DATE) != nil)
        {
            return self.cache.objectForKey(Constants.BOOKS_MONDADORI_STORED_DATE) as String
        }
        else
        {
            return "";
        }
    }
    
    public func getImageCached(imgUrl:String) -> UIImage
    {
        return UIImage(data: self.cache.objectForKey(imgUrl) as NSData)!
    }
    
    public func isImageCached(imgUrlBook:String) -> Bool
    {
        if(self.cache.objectForKey(imgUrlBook) != nil)
        {
            return true;
        }
        
        return false;
    }
    
    
    public func storeImage(imgUrlBook:String, data: NSData)
    {
        self.cache.setObject(data, forKey: imgUrlBook)
    }
    
}


