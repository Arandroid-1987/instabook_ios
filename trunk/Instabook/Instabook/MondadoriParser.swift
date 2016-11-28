//
//  MondadoriParser.swift
//  Instabook
//
//  Created by Leonardo Rania on 19/11/16.
//  Copyright (c) 2016 instabook. All rights reserved.
//

import Foundation

public class MondadoriParser
{
    private var urlClassifica = "";
    private var urlNovita = "";
    private var cache = CacheManager();
    
    
    public func MondadoriParser(){}
    
    public func parse(tipoPaser:NSString) -> Array<Any>
    {
        var result = [String]();
        if(tipoPaser == Constants.CLASSIFICA)
        {
            return parseClassifica();
        }
        else
        {
            return parseNovita();
        }
    }
    
    private func parseNovita()-> Array<Any>
    {
        print("Ricerca Nuovi Libri")
        var bookArray = [Any]();
        if let URLMondadori = NSURL(string: self.urlNovita)
        {
            var error: NSError?
            let HTMLString = NSString(contentsOfURL: URLMondadori, encoding: NSUTF8StringEncoding, error: &error)
            if let error = error
            {
                println("Error : \(error)")
            }
            else
            {
                var parserMondadori = HTMLParser(html: HTMLString!, error: &error)
                if let error = error
                {
                    println("Error : \(error)")
                }
                else
                {
                    //var bodyNode = parserMondadori.body;
                    if let contentBox = parserMondadori.html?.xpath("//div[contains(@class,'content-box')]/div[@id='div_container']")
                    {
                        for node in contentBox
                        {
                            var parserNode = HTMLParser(html: node.rawContents, error: &error);
                            
                            if(parserNode.html?.getAttributeNamed("class") != "ranking_id")
                            {
                                if let elemOnSingleBox = parserNode.html?.xpath("//div[contains(@class,'single-box')]")
                                {
                                    for nodeSingleBox in elemOnSingleBox
                                    {
                                        var parserNodeSingleBox = HTMLParser(html: nodeSingleBox.rawContents, error: &error);
                                        var book = Book();
                                        if let bookImage = parserNodeSingleBox.html?.xpath("//div[contains(@class,'image-box-ranking')]")?.first
                                        {
                                            if let img = bookImage.findChildTag("img")
                                            {
                                                book.imgLink = img.getAttributeNamed("src")
                                                //println(book.imgLink)
                                            }
                                        }
                                        else if let bookImage = parserNodeSingleBox.html?.xpath("//div[contains(@class,'image-box')]")?.first
                                        {
                                            if let img = bookImage.findChildTag("img")
                                            {
                                                book.imgLink = img.getAttributeNamed("src")
                                                //println(book.imgLink)
                                            }
                                        }
                                        
                                        if let bookTitle = parserNodeSingleBox.html?.xpath("//div[contains(@class,'product-info')]/h3[contains(@class,'title')]")?.first
                                        {
                                            if let title = bookTitle.findChildTag("a")
                                            {
                                                book.title = title.contents;
                                            }
                                        }
                                        
                                        if let bookPrice = parserNodeSingleBox.html?.xpath("//div[contains(@class,'price-buy')]/div[contains(@class,'price-box')]/span[contains(@class,'old-price')]")?.first
                                        {
                                            book.price = bookPrice.contents;
                                            var parserBookPrice = HTMLParser(html: bookPrice.rawContents, error: &error);
                                            if let bookPriceDecimal = parserBookPrice.html?.xpath("//span[contains(@class,'decimal')]")?.first
                                            {
                                                book.price = book.price + bookPriceDecimal.contents
                                            }
                                            //println(book.price);
                                            
                                        }
                                        
                                        if let bookAuthors = parserNodeSingleBox.html?.xpath("//p[contains(@class,'secondary-data')]/a[contains(@class,'nti-author')]")
                                        {
                                            var authors = [String]();
                                            for bookAuthorItem in bookAuthors
                                            {
                                                //println(bookAuthorItem.contents);
                                                authors.append(bookAuthorItem.contents);
                                            }
                                            book.authors = authors;
                                        }
                                        
                                        if let bookLink = parserNodeSingleBox.html?.xpath("//div[contains(@class,'product-info')]/h3[contains(@class,'title')]/a")?.first
                                        {
                                            book.link = bookLink.getAttributeNamed("href");
                                            //println(book.link);
                                        }
                                        
                                        book.source = book.MONDADORI_SOURCE;
                                        
                                        bookArray.append(book);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        else
        {
            println("Error: \(self.urlNovita) doesn't seem to be a valid URL")
        }
        cache.storeBookFromMondadori(bookArray)
        var todaysDate:NSDate = NSDate()
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        cache.storeLastUpdatedDateFromMondadori(dateFormatter.stringFromDate(todaysDate))
        return bookArray;
    }
    
    
    private func parseClassifica()-> Array<Any>
    {
        print("Ricerca Best Seller Libri")
        var bookArray = [Any]();
        if let URLMondadori = NSURL(string: self.urlNovita)
        {
            var error: NSError?
            let HTMLString = NSString(contentsOfURL: URLMondadori, encoding: NSUTF8StringEncoding, error: &error)
            if let error = error
            {
                println("Error : \(error)")
            }
            else
            {
                var parserMondadori = HTMLParser(html: HTMLString!, error: &error)
                if let error = error
                {
                    println("Error : \(error)")
                }
                else
                {
                    //var bodyNode = parserMondadori.body;
                    if let contentBox = parserMondadori.html?.xpath("//div[contains(@class,'content-box')]/div[@id='div_container']")
                    {
                        for node in contentBox
                        {
                            var parserNode = HTMLParser(html: node.rawContents, error: &error);
                            
                            if(parserNode.html?.getAttributeNamed("class") != "ranking_id")
                            {
                                if let elemOnSingleBox = parserNode.html?.xpath("//div[contains(@class,'single-box')]")
                                {
                                    for nodeSingleBox in elemOnSingleBox
                                    {
                                        var parserNodeSingleBox = HTMLParser(html: nodeSingleBox.rawContents, error: &error);
                                        var book = Book();
                                        if let bookImage = parserNodeSingleBox.html?.xpath("//div[contains(@class,'image-box-ranking')]")?.first
                                        {
                                            if let img = bookImage.findChildTag("img")
                                            {
                                                book.imgLink = img.getAttributeNamed("src")
                                                //println(book.imgLink)
                                            }
                                        }
                                        else if let bookImage = parserNodeSingleBox.html?.xpath("//div[contains(@class,'image-box')]")?.first
                                        {
                                            if let img = bookImage.findChildTag("img")
                                            {
                                                book.imgLink = img.getAttributeNamed("src")
                                                //println(book.imgLink)
                                            }
                                        }
                                        
                                        if let bookPosition = parserNodeSingleBox.html?.xpath("//div[contains(@class,'position')]/span[contains(@class,'number')]")?.first
                                        {
                                            book.position = bookPosition.contents
                                            //println(book.position);

                                        }
                                        
                                        if let bookTitle = parserNodeSingleBox.html?.xpath("//div[contains(@class,'product-info')]/h3[contains(@class,'title')]")?.first
                                        {
                                            if let title = bookTitle.findChildTag("a")
                                            {
                                                book.title = title.contents;
                                            }
                                        }
                                        
                                        if let bookPrice = parserNodeSingleBox.html?.xpath("//div[contains(@class,'price-buy')]/div[contains(@class,'price-box')]/span[contains(@class,'old-price')]")?.first
                                        {
                                            book.price = bookPrice.contents;
                                            var parserBookPrice = HTMLParser(html: bookPrice.rawContents, error: &error);
                                            if let bookPriceDecimal = parserBookPrice.html?.xpath("//span[contains(@class,'decimal')]")?.first
                                            {
                                                book.price = book.price + bookPriceDecimal.contents
                                            }
                                            //println(book.price);
                                            
                                        }
                                        
                                        if let bookAuthors = parserNodeSingleBox.html?.xpath("//p[contains(@class,'secondary-data')]/a[contains(@class,'nti-author')]")
                                        {
                                            var authors = [String]();
                                            for bookAuthorItem in bookAuthors
                                            {
                                                //println(bookAuthorItem.contents);
                                                authors.append(bookAuthorItem.contents);
                                            }
                                            book.authors = authors;
                                        }
                                        
                                        if let bookLink = parserNodeSingleBox.html?.xpath("//div[contains(@class,'product-info')]/h3[contains(@class,'title')]/a")?.first
                                        {
                                            book.link = bookLink.getAttributeNamed("href");
                                            //println(book.link);
                                        }
                                        
                                        book.source = book.MONDADORI_SOURCE;
                                        
                                        bookArray.append(book);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        else
        {
            println("Error: \(self.urlNovita) doesn't seem to be a valid URL")
        }
        
        return bookArray;
    }

    
    private func getDescrizione(urlBook: String)-> String
    {
        print("Scarica dettagli libr")
        var details = "";
        if let URLBookMondadori = NSURL(string: urlBook)
        {
            var error: NSError?
            let HTMLString = NSString(contentsOfURL: URLBookMondadori, encoding: NSUTF8StringEncoding, error: &error)
            if let error = error
            {
                println("Error : \(error)")
            }
            else
            {
                var parserMondadori = HTMLParser(html: HTMLString!, error: &error)
                if let error = error
                {
                    println("Error : \(error)")
                }
                else
                {
                    //var bodyNode = parserMondadori.body;
                    if let contentBox = parserMondadori.html?.xpath("//div[contains(@class,'product-descriptions')]/p")?.first
                    {
                        details = contentBox.contents;
                    }
                }
            }
        }
        return details;
    }

    
    public func setUrlNovita(urlNovita:NSString)
    {
        self.urlNovita = urlNovita;
    }
    
    public func getUrlNovita() -> NSString
    {
        return self.urlNovita;
    }
    
    
}