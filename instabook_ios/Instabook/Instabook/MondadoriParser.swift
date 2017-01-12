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
        //let result = [String]();
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
        print("Ricerca Nuovi Libri", terminator: "")
        var bookArray = [Any]();
        if let URLMondadori = NSURL(string: self.urlNovita)
        {
            var error: NSError?
            let HTMLString: NSString?
            do {
                HTMLString = try NSString(contentsOfURL: URLMondadori, encoding: NSUTF8StringEncoding)
            } catch let error1 as NSError {
                error = error1
                HTMLString = nil
            }
            if let error = error
            {
                print("Error : \(error)", terminator: "")
            }
            else
            {
                let parserMondadori = HTMLParser(html: HTMLString! as String, error: &error)
                if let error = error
                {
                    print("Error : \(error)", terminator: "")
                }
                else
                {
                    //var bodyNode = parserMondadori.body;
                    if let contentBox = parserMondadori.html?.xpath("//div[contains(@class,'content-box')]/div[@id='div_container']")
                    {
                        for node in contentBox
                        {
                            let parserNode = HTMLParser(html: node.rawContents, error: &error);
                            
                            if(parserNode.html?.getAttributeNamed("class") != "ranking_id")
                            {
                                if let elemOnSingleBox = parserNode.html?.xpath("//div[contains(@class,'single-box')]")
                                {
                                    for nodeSingleBox in elemOnSingleBox
                                    {
                                        let parserNodeSingleBox = HTMLParser(html: nodeSingleBox.rawContents, error: &error);
                                        let book = Book();
                                        if let bookImage = parserNodeSingleBox.html?.xpath("//div[contains(@class,'image-box-ranking')]")?.first
                                        {
                                            if let img = bookImage.findChildTag("img")
                                            {
                                                book.imgLink = img.getAttributeNamed("src")
                                                //println(book.imgLink)
                                            }
                                        }
                                        else if let bookImage = parserNodeSingleBox.html?.xpath("//div[contains(@class,'image-box')]")?.last
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
                                                book.title = formatString(title.contents);
                                            }
                                        }
                                        
                                        if let bookPrice = parserNodeSingleBox.html?.xpath("//div[contains(@class,'price-buy')]/div[contains(@class,'price-box')]/span[contains(@class,'old-price')]")?.first
                                        {
                                            book.price = bookPrice.contents;
                                            let parserBookPrice = HTMLParser(html: bookPrice.rawContents, error: &error);
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
                                                authors.append(formatString(bookAuthorItem.contents));
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
                    cache.storeBookFromMondadori(bookArray)
                    let todaysDate:NSDate = NSDate()
                    let dateFormatter:NSDateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    cache.storeLastUpdatedDateFromMondadori(dateFormatter.stringFromDate(todaysDate))
                }
            }
        }
        else
        {
            print("Error: \(self.urlNovita) doesn't seem to be a valid URL", terminator: "")
        }

        return bookArray;
    }
    
    
    private func parseClassifica()-> Array<Any>
    {
        print("Ricerca Best Seller Libri")
        var bookArray = [Any]();
        if let URLMondadori = NSURL(string: self.urlNovita)
        {
            var error: NSError?
            let HTMLString: NSString?
            do {
                HTMLString = try NSString(contentsOfURL: URLMondadori, encoding: NSUTF8StringEncoding)
            } catch let error1 as NSError {
                error = error1
                HTMLString = nil
            }

            if let error = error
            {
                print("Error : \(error)")
            }
            else
            {
                let parserMondadori = HTMLParser(html: HTMLString! as String, error: &error)
                print(parserMondadori)
                if let error = error
                {
                    print("Error : \(error)")
                }
                else
                {
                    //var bodyNode = parserMondadori.body;
                    if let contentBox = parserMondadori.html?.xpath("//div[contains(@class,'content-box')]/div[@id='div_container']")
                    {
                        for node in contentBox
                        {
                            let parserNode = HTMLParser(html: node.rawContents, error: &error);
                            
                            if(parserNode.html?.getAttributeNamed("class") != "ranking_id")
                            {
                                if let elemOnSingleBox = parserNode.html?.xpath("//div[contains(@class,'single-box')]")
                                {
                                    for nodeSingleBox in elemOnSingleBox
                                    {
                                        let parserNodeSingleBox = HTMLParser(html: nodeSingleBox.rawContents, error: &error);
                                        let book = Book();
                                        if let bookImage = parserNodeSingleBox.html?.xpath("//div[contains(@class,'image-box-ranking')]")?.first
                                        {
                                            if let img = bookImage.findChildTag("a")
                                            {
                                                if let imgSrc = img.findChildTag("img")
                                                {
                                                    book.imgLink = imgSrc.getAttributeNamed("src")
                                                }
                                                
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
                                                
                                                book.title = formatString(title.contents)
                                            }
                                        }
                                        
                                        if let bookPrice = parserNodeSingleBox.html?.xpath("//div[contains(@class,'price-buy')]/div[contains(@class,'price-box')]/span[contains(@class,'old-price')]")?.first
                                        {
                                            book.price = bookPrice.contents;
                                            let parserBookPrice = HTMLParser(html: bookPrice.rawContents, error: &error);
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
                                                authors.append(formatString(bookAuthorItem.contents))
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
                    cache.storeBookFromMondadoriBestSeller(bookArray)
                    let todaysDate:NSDate = NSDate()
                    let dateFormatter:NSDateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    cache.storeLastUpdatedDateBestSellerMondadori(dateFormatter.stringFromDate(todaysDate))
                }
            }
        }
        else
        {
            print("Error: \(self.urlNovita) doesn't seem to be a valid URL")
        }
        return bookArray;
    }

    
    public func getDescrizione(urlBook: String)-> String
    {
        print("Scarica dettagli libr")
        var details = "";
        if let URLBookMondadori = NSURL(string: urlBook)
        {
            var error: NSError?
            
            let HTMLString: NSString?
            do {
                HTMLString = try NSString(contentsOfURL: URLBookMondadori, encoding: NSUTF8StringEncoding)
            } catch let error1 as NSError {
                error = error1
                HTMLString = nil
            }
            if let error = error
            {
                print("Error : \(error)")
            }
            else
            {
                let parserMondadori = HTMLParser(html: HTMLString! as String, error: &error)
                if let error = error
                {
                    print("Error : \(error)")
                }
                else
                {
                    //var bodyNode = parserMondadori.body;
                    if let contentBox = parserMondadori.html?.xpath("//div[contains(@class,'product-descriptions')]/p")
                    {
                        var descriptionString = "";
                        for descriptionItem in contentBox
                        {
                            if(descriptionItem.contents == "")
                            {
                                descriptionString += descriptionItem.rawContents.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
                            }
                            else
                            {
                                descriptionString +=  descriptionItem.contents ;
                            }
                        }
                        
                        details = descriptionString;
                    }
                }
            }
        }
        return formatString(details);
    }

    
    public func setUrlNovita(urlNovita:NSString)
    {
        self.urlNovita = urlNovita as String;
    }
    
    public func getUrlNovita() -> NSString
    {
        return self.urlNovita;
    }
    
    
    func formatString(string : String) -> String{
        
        var newString = string
        
        if(newString.containsString("aIIIAAIA")){
            newString = newString.stringByReplacingOccurrencesOfString("aIIIAAIA", withString: "à")
        }
        if(newString.containsString("eIIIAAIA")){
            newString = newString.stringByReplacingOccurrencesOfString("eIIIAAIA", withString: "è")
        }
        if(newString.containsString("iIIIAAIA")){
            newString = newString.stringByReplacingOccurrencesOfString("iIIIAAIA", withString: "ì")
        }
        if(newString.containsString("oIIIAAIA")){
            newString = newString.stringByReplacingOccurrencesOfString("oIIIAAIA", withString: "ò")
        }
        if(newString.containsString("uIIIAAIA")){
            newString = newString.stringByReplacingOccurrencesOfString("uIIIAAIA", withString: "ù")
        }
        if(newString.containsString("aIIÌÂAÌÂ")){
            newString = newString.stringByReplacingOccurrencesOfString("aIIÌÂAÌÂ", withString: "à")
        }
        if(newString.containsString("eIIÌÂAÌÂ")){
            newString = newString.stringByReplacingOccurrencesOfString("eIIÌÂAÌÂ", withString: "è")
        }
        if(newString.containsString("iIIÌÂAÌÂ")){
            newString = newString.stringByReplacingOccurrencesOfString("iIIÌÂAÌÂ", withString: "ì")
        }
        if(newString.containsString("oIIÌÂAÌÂ")){
            newString = newString.stringByReplacingOccurrencesOfString("oIIÌÂAÌÂ", withString: "ò")
        }
        if(newString.containsString("uIIÌÂAÌÂ")){
            newString = newString.stringByReplacingOccurrencesOfString("uIIÌÂAÌÂ", withString: "ù")
        }
        if(newString.containsString("aÌ")){
            newString = newString.stringByReplacingOccurrencesOfString("aÌ", withString: "à")
        }
        if(newString.containsString("eÌ")){
            newString = newString.stringByReplacingOccurrencesOfString("eÌ", withString: "è")
        }
        if(newString.containsString("iÌ")){
            newString = newString.stringByReplacingOccurrencesOfString("iÌ", withString: "ì")
        }
        if(newString.containsString("oÌ")){
            newString = newString.stringByReplacingOccurrencesOfString("oÌ", withString: "ò")
        }
        if(newString.containsString("uÌ")){
            newString = newString.stringByReplacingOccurrencesOfString("uÌ", withString: "ù")
        }

        
        
        return newString
    }

    
}