//
//  Utils.swift
//  Instabook
//
//  Created by Leonardo Rania on 17/11/16.
//  Copyright (c) 2016 instabook. All rights reserved.
//

import Foundation

public struct Constants
{
    
    public static let API_KEY = "AIzaSyALiWCYPKj3UipkXOggNuiQw2vGRkc3eX8"
    
    public static let FIREBASE_TABLE_QUERY_HIT = "query-hit-new2"
    public static let FIREBASE_TABLE_NEWS = "news"
    public static let COUNTER = "counter_ios"
    public static let DATE_NAME = "date_ios"
    
    public static let RELOAD_NEWS_NOTIFICATION_NAME = "RELOAD_NEWS_NOTIFICATION_NAME"
    
    public static let MY_SEARCH_STORED = "mySearch";
    public static let MY_BOOKS_LIKE_STORED = "myBooksLike";
    public static let BOOKS_STORED = "BOOKS_STORED";
    public static let BOOKS_STORED_DATE = "BOOKS_STORED_DATE";
    public static let BOOKS_MONDADORI_STORED_BEST_SELLER = "mondadoriBooksBestSeller";
    public static let BOOKS_MONDADORI_STORED_DATE_BEST_SELLER = "mondadoriBooksDateBestSeller";
    public static let NEXT_PAGE_BEST_SELLER_MONDADORI = "nextPageBestSellerMondadori";
    public static let NEXT_PAGE_MONDADORI = "nextPageMondadori";
    public static let BUYED_REMOVE_ADS = "BUYED_REMOVE_ADS";
    
    public static let SHARED = "Condiviso usando InstaBook. Ti potrebbe interessare ";
    public static let myColor = UIColor(red: 48.0/255.0, green: 63.0/255.0, blue: 159.0/255.0, alpha: 0.9);
    public static let placeHolderTextView = NSLocalizedString("input_text_to_search", comment: "input_text_to_search");
    
    public static let POLICY_PRIVACY_LINK = "http://www.instabook.it/privacypolicy.htm"
    public static let BIRRA_LINK = "https://www.paypal.me/arandroid"
    public static let FACEBOOK_LINK = "https://www.facebook.com/instabookapp/"
    public static let TWITTER_LINK = "https://www.twitter.com/instabook_app/"
    public static let INSTAGRAM_LINK = "https://www.instagram.com/instabook.app/"
    
    
    public static let MONDADORI_BASE_URL = "http://www.mondadoristore.it/"
    
    public static let CLASSIFICA = "CLASSIFICA";
    public static let URL_CLASSIFICA_BASE = "http://www.mondadoristore.it/Best-Seller-libri/gr-308/";
    public static let CLASSIFICA_PAGE_2 = "2";
    public static let CLASSIFICA_PAGE_3 = "3";
    public static let CLASSIFICA_PAGE_4 = "4";
    public static let CLASSIFICA_PAGE_5 = "5";
    public static let CLASSIFICA_STOP = "STOP_CLASSIFICA";
    
    public static let NEWS = "NEWS";
    public static let URL_NOVITA_BASE = "http://www.mondadoristore.it/Libri-novita-e-ultime-uscite/gr-3920/?viewmode=medium&opnedBoxes=amtp%2Catpp%2Cagen%2Capzf%2Cascf%2Caaut%2Caedt";
    public static let NEWS_PAGE_2 = "2/";
    public static let NEWS_PAGE_3 = "3/";
    public static let NEWS_PAGE_4 = "4/";
    public static let NEWS_PAGE_5 = "5/";
    public static let NEWS_STOP = "STOP_NEWS";
    public static let SUFFIX_NEWS_URL = "?viewmode=medium&opnedBoxes=amtp%2Catpp%2Cagen%2Capzf%2Cascf%2Caaut%2Caedt";
    public static let PREFIX_NEWS_URL = "http://www.mondadoristore.it/Libri-novita-e-ultime-uscite/gr-3920/";
}