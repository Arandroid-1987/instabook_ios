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
        if self.cache.objectForKey(Constants.BOOKS_MONDADORI_STORED_BEST_SELLER) != nil
        {
            let booksStoredBestSeller = NSKeyedUnarchiver.unarchiveObjectWithData((self.cache.objectForKey(Constants.BOOKS_MONDADORI_STORED_BEST_SELLER) as! NSData)) as! Array<Book>
            var bookToStored2: Array<Book> = Array<Book>()
            for bookItem in booksStoredBestSeller
            {
                if(bookItem.link == book.link)
                {
                    bookItem.favorite = true;
                }
                bookToStored2.append(bookItem)
            }
            self.cache.removeObjectForKey(Constants.BOOKS_MONDADORI_STORED_BEST_SELLER)
            
            self.cache.setObject(NSKeyedArchiver.archivedDataWithRootObject(bookToStored2), forKey: Constants.BOOKS_MONDADORI_STORED_BEST_SELLER)
            
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
        
        if self.cache.objectForKey(Constants.BOOKS_MONDADORI_STORED_BEST_SELLER) != nil
        {
            let booksStoredBestSeller = NSKeyedUnarchiver.unarchiveObjectWithData((self.cache.objectForKey(Constants.BOOKS_MONDADORI_STORED_BEST_SELLER) as! NSData)) as! Array<Book>
            var bookToStored2: Array<Book> = Array<Book>()
            for bookItem in booksStoredBestSeller
            {
                if(bookItem.link == book.link)
                {
                    bookItem.favorite = false;
                }
                bookToStored2.append(bookItem)
            }
            self.cache.removeObjectForKey(Constants.BOOKS_MONDADORI_STORED_BEST_SELLER)
            
            self.cache.setObject(NSKeyedArchiver.archivedDataWithRootObject(bookToStored2), forKey: Constants.BOOKS_MONDADORI_STORED_BEST_SELLER)
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
        self.cache.removeObjectForKey(Constants.BOOKS_MONDADORI_STORED_DATE_BEST_SELLER)
        self.cache.setObject(dateTime, forKey: Constants.BOOKS_MONDADORI_STORED_DATE_BEST_SELLER)
    }
    
    public func storeBookFromMondadoriBestSeller(books: Array<Any>)
    {
        
        if let myBookStoredArray = self.cache.objectForKey(Constants.BOOKS_MONDADORI_STORED_BEST_SELLER) as? NSData {
            
            var myBookStored = NSKeyedUnarchiver.unarchiveObjectWithData(myBookStoredArray) as! Array<Book>
            for book in books
            {
                myBookStored.append(book as! Book)
            }
            self.cache.removeObjectForKey(Constants.BOOKS_MONDADORI_STORED_BEST_SELLER)
            self.cache.setObject(NSKeyedArchiver.archivedDataWithRootObject(myBookStored), forKey: Constants.BOOKS_MONDADORI_STORED_BEST_SELLER)
        }
        else
        {
            var myBookStored: Array<Book> = Array<Book>()
            for book in books
            {
                myBookStored.append(book as! Book)
            }
            self.cache.removeObjectForKey(Constants.BOOKS_MONDADORI_STORED_BEST_SELLER)
            self.cache.setObject(NSKeyedArchiver.archivedDataWithRootObject(myBookStored), forKey: Constants.BOOKS_MONDADORI_STORED_BEST_SELLER)
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
        self.cache.removeObjectForKey(Constants.BOOKS_MONDADORI_STORED_BEST_SELLER)
        self.cache.removeObjectForKey(Constants.BOOKS_MONDADORI_STORED_DATE_BEST_SELLER)
    }
    
    public func deleteNews()
    {
        self.cache.removeObjectForKey(Constants.BOOKS_STORED)
        self.cache.removeObjectForKey(Constants.BOOKS_STORED_DATE)
    }
    
    public func deleteAll()
    {
        deleteMyBook();
        deleteMySearch();
        deleteNews();
        deleteBestSeller();
        for key in NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys {
            NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
        }
    }
    
    public func getMySearchStored() -> Array<Any>
    {
        if let mySearchStoredArray = self.cache.objectForKey(Constants.MY_SEARCH_STORED) as? NSData {
            
            var arrayToReturn = Array<Any>()
            for mySearchStoredItem in NSKeyedUnarchiver.unarchiveObjectWithData(mySearchStoredArray) as! Array<MySearch>
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
    
    public func getMondadoriBooks() -> Array<Any>
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
    
    public func getMondadoriBooksBestSeller() -> Array<Any>
    {
        if let booksArray = self.cache.objectForKey(Constants.BOOKS_MONDADORI_STORED_BEST_SELLER) as? NSData {
            
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
    
    public func getMondadoriBestSellerLastDateUpdate() -> String
    {
        if(self.cache.objectForKey(Constants.BOOKS_MONDADORI_STORED_DATE_BEST_SELLER) != nil)
        {
            return self.cache.objectForKey(Constants.BOOKS_MONDADORI_STORED_DATE_BEST_SELLER) as! String
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
    
    public func storeTheNextPageCachedMondadoriBestSeller(currentPage: String)
    {
        var nextPage = ""
        switch currentPage
        {
            case Constants.CLASSIFICA:
                nextPage = Constants.CLASSIFICA_PAGE_2
                break;
            case Constants.CLASSIFICA_PAGE_2:
                nextPage = Constants.CLASSIFICA_PAGE_3
                break;
            case Constants.CLASSIFICA_PAGE_3:
                nextPage = Constants.CLASSIFICA_PAGE_4
                break;
            case Constants.CLASSIFICA_PAGE_4:
                nextPage = Constants.CLASSIFICA_PAGE_5
                break;
            default:
                nextPage = Constants.CLASSIFICA_STOP
                break;
        }
        self.cache.removeObjectForKey(Constants.NEXT_PAGE_BEST_SELLER_MONDADORI)
        self.cache.setObject(nextPage, forKey: Constants.NEXT_PAGE_BEST_SELLER_MONDADORI)
    }
    
    public func storeTheNextPageCachedMondadori(currentPage: String)
    {
        var nextPage = ""
        switch currentPage
        {
        case Constants.NEWS:
            nextPage = Constants.NEWS_PAGE_2
            break;
        case Constants.NEWS_PAGE_2:
            nextPage = Constants.NEWS_PAGE_3
            break;
        case Constants.NEWS_PAGE_3:
            nextPage = Constants.NEWS_PAGE_4
            break;
        case Constants.NEWS_PAGE_4:
            nextPage = Constants.NEWS_PAGE_5
            break;
        default:
            nextPage = Constants.NEWS_STOP;
            break;
        }
        self.cache.removeObjectForKey(Constants.NEXT_PAGE_MONDADORI)
        self.cache.setObject(nextPage, forKey: Constants.NEXT_PAGE_MONDADORI)
    }
    
    public func getMondadoriNextPageBestSeller() -> String
    {
        if(self.cache.objectForKey(Constants.NEXT_PAGE_BEST_SELLER_MONDADORI) != nil)
        {
            return self.cache.objectForKey(Constants.NEXT_PAGE_BEST_SELLER_MONDADORI) as! String
        }
        else
        {
            storeTheNextPageCachedMondadoriBestSeller(Constants.CLASSIFICA)
            return self.cache.objectForKey(Constants.NEXT_PAGE_BEST_SELLER_MONDADORI) as! String;
        }
    }
    
    public func getMondadoriNextPage() -> String
    {
        if(self.cache.objectForKey(Constants.NEXT_PAGE_MONDADORI) != nil)
        {
            return self.cache.objectForKey(Constants.NEXT_PAGE_MONDADORI) as! String
        }
        else
        {
            storeTheNextPageCachedMondadori(Constants.NEWS)
            return self.cache.objectForKey(Constants.NEXT_PAGE_MONDADORI) as! String;
        }
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


