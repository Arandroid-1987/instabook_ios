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
            var myStoredSearch = NSKeyedUnarchiver.unarchiveObjectWithData(myStoredSearchArray) as!  Array<MySearch>
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
                i += 1;
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
    
    public func storeSearch(search: String, id: Int)
    {
        
        if(id == Constants.ID_SEARCH_CITAZIONE)
        {
            if let myStoredSearchArray = self.cache.objectForKey(Constants.ALL_SEARCH_STORED) as? NSData {
                var myStoredSearch = NSKeyedUnarchiver.unarchiveObjectWithData(myStoredSearchArray) as!  Array<String>
                var i = 0;
                for myStoredSearchItem in myStoredSearch
                {
                    if (myStoredSearchItem == search)
                    {
                        myStoredSearch.removeAtIndex(i)
                        break;
                        
                    }
                    i += 1;
                }
                
                myStoredSearch.append(search)
                self.cache.removeObjectForKey(Constants.ALL_SEARCH_STORED)
                self.cache.setObject(NSKeyedArchiver.archivedDataWithRootObject(myStoredSearch), forKey: Constants.ALL_SEARCH_STORED)
                
            }
            else
            {
                var myStoredSearch: Array<String> = Array<String>()
                myStoredSearch.append(search)
                self.cache.setObject(NSKeyedArchiver.archivedDataWithRootObject(myStoredSearch), forKey: Constants.ALL_SEARCH_STORED)
            }
        }
        else if(id == Constants.ID_SEARCH_AUTORE)
        {
            if let myStoredSearchArray = self.cache.objectForKey(Constants.ALL_AUTHOR_STORED) as? NSData {
                var myStoredSearch = NSKeyedUnarchiver.unarchiveObjectWithData(myStoredSearchArray) as!  Array<String>
                var i = 0;
                for myStoredSearchItem in myStoredSearch
                {
                    if (myStoredSearchItem == search)
                    {
                        myStoredSearch.removeAtIndex(i)
                        break;
                        
                    }
                    i += 1;
                }
                
                myStoredSearch.append(search)
                self.cache.removeObjectForKey(Constants.ALL_AUTHOR_STORED)
                self.cache.setObject(NSKeyedArchiver.archivedDataWithRootObject(myStoredSearch), forKey: Constants.ALL_AUTHOR_STORED)
                
            }
            else
            {
                var myStoredSearch: Array<String> = Array<String>()
                myStoredSearch.append(search)
                self.cache.setObject(NSKeyedArchiver.archivedDataWithRootObject(myStoredSearch), forKey: Constants.ALL_AUTHOR_STORED)
            }
        }
    }
    
    public func storeLikeBook(book: Book)
    {
        if let booksStored = NSKeyedUnarchiver.unarchiveObjectWithData((self.cache.objectForKey(Constants.BOOKS_STORED) as? NSData)!) as? Array<Book>
        {
            var bookToStored: Array<Book> = Array<Book>()
            for bookItem in booksStored
            {
                if(bookItem.link == book.link)
                {
                    bookItem.favorite = true;
                }
                bookToStored.append(bookItem)
            }
            self.cache.removeObjectForKey(Constants.BOOKS_STORED)
            self.cache.setObject(NSKeyedArchiver.archivedDataWithRootObject(bookToStored), forKey: Constants.BOOKS_STORED)
        }
        if self.cache.objectForKey(Constants.BOOKS_STORED_BEST_SELLER) != nil
        {
            let booksStoredBestSeller = NSKeyedUnarchiver.unarchiveObjectWithData((self.cache.objectForKey(Constants.BOOKS_STORED_BEST_SELLER) as! NSData)) as! Array<Book>
            var bookToStored2: Array<Book> = Array<Book>()
            for bookItem in booksStoredBestSeller
            {
                if(bookItem.link == book.link)
                {
                    bookItem.favorite = true;
                }
                bookToStored2.append(bookItem)
            }
            self.cache.removeObjectForKey(Constants.BOOKS_STORED_BEST_SELLER)
            
            self.cache.setObject(NSKeyedArchiver.archivedDataWithRootObject(bookToStored2), forKey: Constants.BOOKS_STORED_BEST_SELLER)
            
        }
        
        if let myBookStoredArray = self.cache.objectForKey(Constants.MY_BOOKS_LIKE_STORED) as? NSData {
           
            var myBookStored = NSKeyedUnarchiver.unarchiveObjectWithData(myBookStoredArray) as! Array<Book>
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
        if let booksStored = NSKeyedUnarchiver.unarchiveObjectWithData((self.cache.objectForKey(Constants.BOOKS_STORED) as? NSData)!) as? Array<Book>
        {
            var bookToStored: Array<Book> = Array<Book>()
            for bookItem in booksStored
            {
                if(bookItem.link == book.link)
                {
                    bookItem.favorite = false;
                }
                bookToStored.append(bookItem)
            }
            self.cache.removeObjectForKey(Constants.BOOKS_STORED)
            self.cache.setObject(NSKeyedArchiver.archivedDataWithRootObject(bookToStored), forKey: Constants.BOOKS_STORED)
            
        }
        
        if self.cache.objectForKey(Constants.BOOKS_STORED_BEST_SELLER) != nil
        {
            let booksStoredBestSeller = NSKeyedUnarchiver.unarchiveObjectWithData((self.cache.objectForKey(Constants.BOOKS_STORED_BEST_SELLER) as! NSData)) as! Array<Book>
            var bookToStored2: Array<Book> = Array<Book>()
            for bookItem in booksStoredBestSeller
            {
                if(bookItem.link == book.link)
                {
                    bookItem.favorite = false;
                }
                bookToStored2.append(bookItem)
            }
            self.cache.removeObjectForKey(Constants.BOOKS_STORED_BEST_SELLER)
            
            self.cache.setObject(NSKeyedArchiver.archivedDataWithRootObject(bookToStored2), forKey: Constants.BOOKS_STORED_BEST_SELLER)
        }
        //let booksStored2 = NSKeyedUnarchiver.unarchiveObjectWithData((self.cache.objectForKey(Constants.BOOKS_MONDADORI_STORED_BEST_SELLER) as? NSData)!) as! Array<Book>
        
        if let mySearchStoredArray = self.cache.objectForKey(Constants.MY_BOOKS_LIKE_STORED) as? NSData {
            var i = 0
            var myBookStored = NSKeyedUnarchiver.unarchiveObjectWithData(mySearchStoredArray) as! Array<Book>
            for myBookStoredItem in myBookStored
            {
                if (myBookStoredItem.link == book.link)
                {
                    myBookStored.removeAtIndex(i)
                    break;
                }
                i += 1;
            }
        
            self.cache.removeObjectForKey(Constants.MY_BOOKS_LIKE_STORED)
            self.cache.setObject(NSKeyedArchiver.archivedDataWithRootObject(myBookStored), forKey: Constants.MY_BOOKS_LIKE_STORED)
        }
        
    }
    
    public func removeStoreMySearch(mySearch: MySearch)
    {
        if let mySearchStoredArray = self.cache.objectForKey(Constants.MY_SEARCH_STORED) as? NSData {
            var i = 0
            var myBookStored = NSKeyedUnarchiver.unarchiveObjectWithData(mySearchStoredArray) as! Array<MySearch>
            for myBookStoredItem in myBookStored
            {
                if (myBookStoredItem.citazione == mySearch.citazione &&
                    myBookStoredItem.autore == mySearch.autore &&
                    myBookStoredItem.data == mySearch.data &&
                    myBookStoredItem.imgLink == mySearch.imgLink)
                {
                    myBookStored.removeAtIndex(i)
                    break;
                }
                i += 1;
            }
            
            self.cache.removeObjectForKey(Constants.MY_SEARCH_STORED)
            self.cache.setObject(NSKeyedArchiver.archivedDataWithRootObject(myBookStored), forKey: Constants.MY_SEARCH_STORED)
        }
        
    }

    
    public func storeLastUpdatedDate(dateTime: String)
    {
        self.cache.removeObjectForKey(Constants.BOOKS_STORED_DATE)
        self.cache.setObject(dateTime, forKey: Constants.BOOKS_STORED_DATE)
    }
    
    public func storeLastUpdatedDateBestSellerMondadori(dateTime: String)
    {
        self.cache.removeObjectForKey(Constants.BOOKS_STORED_DATE_BEST_SELLER)
        self.cache.setObject(dateTime, forKey: Constants.BOOKS_STORED_DATE_BEST_SELLER)
    }
    
    public func storeUUID(uuid: String)
    {
        self.cache.setObject(uuid, forKey: Constants.UUID);
    }
    
    public func storeSelectedLang(lang: String)
    {
        self.cache.setObject(lang, forKey: Constants.LAUNGUAGE_SELECETED)
    }
    
    public func getUUID() -> String
    {
        if(self.cache.stringForKey(Constants.UUID) == nil)
        {
            return "";
        }
        
        return self.cache.stringForKey(Constants.UUID)!;
    }
    
    public func getStoredLang() -> String
    {
        if(self.cache.stringForKey(Constants.LAUNGUAGE_SELECETED) == nil)
        {
            return "";
        }
        return self.cache.stringForKey(Constants.LAUNGUAGE_SELECETED)!;
    }
    
    public func storeBookBestSeller(books: Array<Any>)
    {
        
        if let myBookStoredArray = self.cache.objectForKey(Constants.BOOKS_STORED_BEST_SELLER) as? NSData {
            
            var myBookStored = NSKeyedUnarchiver.unarchiveObjectWithData(myBookStoredArray) as! Array<Book>
            for book in books
            {
                myBookStored.append(book as! Book)
            }
            self.cache.removeObjectForKey(Constants.BOOKS_STORED_BEST_SELLER)
            self.cache.setObject(NSKeyedArchiver.archivedDataWithRootObject(myBookStored), forKey: Constants.BOOKS_STORED_BEST_SELLER)
        }
        else
        {
            var myBookStored: Array<Book> = Array<Book>()
            for book in books
            {
                myBookStored.append(book as! Book)
            }
            self.cache.removeObjectForKey(Constants.BOOKS_STORED_BEST_SELLER)
            self.cache.setObject(NSKeyedArchiver.archivedDataWithRootObject(myBookStored), forKey: Constants.BOOKS_STORED_BEST_SELLER)
        }
    }
    
    public func storeBook(books: Array<Any>)
    {
        if let myBookStoredArray = self.cache.objectForKey(Constants.BOOKS_STORED) as? NSData {
            
            var myBookStored = NSKeyedUnarchiver.unarchiveObjectWithData(myBookStoredArray) as! Array<Book>
            for book in books
            {
                myBookStored.append(book as! Book)
            }
            self.cache.removeObjectForKey(Constants.BOOKS_STORED)
            self.cache.setObject(NSKeyedArchiver.archivedDataWithRootObject(myBookStored), forKey: Constants.BOOKS_STORED)
        }
        else
        {
            var myBookStored: Array<Book> = Array<Book>()
            for book in books
            {
                myBookStored.append(book as! Book)
            }
            self.cache.removeObjectForKey(Constants.BOOKS_STORED)
            self.cache.setObject(NSKeyedArchiver.archivedDataWithRootObject(myBookStored), forKey: Constants.BOOKS_STORED)
        }
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
        self.cache.removeObjectForKey(Constants.BOOKS_STORED_BEST_SELLER)
        self.cache.removeObjectForKey(Constants.BOOKS_STORED_DATE_BEST_SELLER)
    }
    
    public func deleteNews()
    {
        self.cache.removeObjectForKey(Constants.BOOKS_STORED)
        self.cache.removeObjectForKey(Constants.BOOKS_STORED_DATE)
    }
    
    public func deleteLanguageSelected()
    {
        self.cache.removeObjectForKey(Constants.LAUNGUAGE_SELECETED);
    }
    
    public func deleteAll()
    {
        deleteMyBook();
        deleteMySearch();
        deleteNews();
        deleteBestSeller();
        deleteLanguageSelected();
        for key in NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys {
            NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
        }
    }
    
    public func getMySearchStored() -> Array<Any>
    {
        if let mySearchStoredArray = self.cache.objectForKey(Constants.MY_SEARCH_STORED) as? NSData {
            
            var arrayToReturn = Array<Any>()
            var mySearchArray = NSKeyedUnarchiver.unarchiveObjectWithData(mySearchStoredArray) as! Array<MySearch>;
            if(mySearchArray.count == 0)
            {
                return Array<Any>();
            }
            for index in (0...(mySearchArray.count-1)).reverse()
            {
                arrayToReturn.append(mySearchArray[index]);
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
            for book in NSKeyedUnarchiver.unarchiveObjectWithData(booksArray) as! Array<Book>
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
    
    public func getBooks() -> Array<Any>
    {
        if let booksArray = self.cache.objectForKey(Constants.BOOKS_STORED) as? NSData {
            
            var arrayToReturn = Array<Any>()
            for book in NSKeyedUnarchiver.unarchiveObjectWithData(booksArray) as! Array<Book>
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
    
    public func getBooksBestSeller() -> Array<Any>
    {
        if let booksArray = self.cache.objectForKey(Constants.BOOKS_STORED_BEST_SELLER) as? NSData {
            
            var arrayToReturn = Array<Any>()
            for book in NSKeyedUnarchiver.unarchiveObjectWithData(booksArray) as! Array<Book>
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
    
    public func getAllSerach(id: Int) -> Array<String>
    {
        if(id == Constants.ID_SEARCH_CITAZIONE)
        {
            if let mySearchs = self.cache.objectForKey(Constants.ALL_SEARCH_STORED) as? NSData {
                
                var arrayToReturn = Array<String>()
                for mySearch in NSKeyedUnarchiver.unarchiveObjectWithData(mySearchs) as! Array<String>
                {
                    arrayToReturn.append(mySearch)
                }
                
                return arrayToReturn;
            }
            else
            {
                return Array<String>();
            }
        }
        else if(id == Constants.ID_SEARCH_AUTORE)
        {
            if let mySearchs = self.cache.objectForKey(Constants.ALL_AUTHOR_STORED) as? NSData {
                
                var arrayToReturn = Array<String>()
                for mySearch in NSKeyedUnarchiver.unarchiveObjectWithData(mySearchs) as! Array<String>
                {
                    arrayToReturn.append(mySearch)
                }
                
                return arrayToReturn;
            }
            else
            {
                return Array<String>();
            }
        }
        
        return Array<String>();
    }
    
    public func getBestSellerLastDateUpdate() -> String
    {
        if(self.cache.objectForKey(Constants.BOOKS_STORED_DATE_BEST_SELLER) != nil)
        {
            return self.cache.objectForKey(Constants.BOOKS_STORED_DATE_BEST_SELLER) as! String
        }
        else
        {
            return "";
        }
    }
    
    public func getLastDateUpdate() -> String
    {
        if(self.cache.objectForKey(Constants.BOOKS_STORED_DATE) != nil)
        {
            return self.cache.objectForKey(Constants.BOOKS_STORED_DATE) as! String
        }
        else
        {
            return "";
        }
    }
    
    public func getImageCached(imgUrl:String) -> UIImage
    {
        return UIImage(data: self.cache.objectForKey(imgUrl) as! NSData)!
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
    
    
    public func isFavoriteBook(url: String) -> Bool
    {
        if let booksArray = self.cache.objectForKey(Constants.MY_BOOKS_LIKE_STORED) as? NSData {
            
            for book in NSKeyedUnarchiver.unarchiveObjectWithData(booksArray) as! Array<Book>
            {
                if(book.link == url)
                {
                    return true;
                }
            }
            
        }
        else
        {
            return false;
        }
        return false;
    }
    
    public func storeLicense(buyRemoveAds: Bool)
    {
        self.cache.setObject(buyRemoveAds, forKey: Constants.BUYED_REMOVE_ADS);
    }
    
    public func getLicense() -> Bool
    {
        if(self.cache.objectForKey(Constants.BUYED_REMOVE_ADS) != nil)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    
    
}


