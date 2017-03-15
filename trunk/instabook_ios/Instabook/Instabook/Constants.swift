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
    
    public static let ID_SEARCH_AUTORE = 0;
    public static let ID_SEARCH_CITAZIONE = 1;
    
    public static let FIREBASE_TABLE_QUERY_HIT = "query-hit-new2"
    public static let FIREBASE_TABLE_NEWS = "news"
    public static let FIREBASE_BEST_SELLERS = "chart"
    public static let FIREBASE_TABLE_BOOK_CLICK = "book-click-new"
    public static let FIREBASE_TABLE_VOTES = "votes"
    public static let FIREBASE_TABLE_VOTES_AGG = "votes-agg"
    public static let FIREBASE_TABLE_MISSING_RESULTS = "missing-results"
    
    public static let COUNTER = "counter"
    public static let DATE_NAME = "date"
    public static let BOOK_NAME = "book"
    public static let QUERY_NAME = "query"
    public static let SCORE_NAME = "score"
    
    public static let RELOAD_NEWS_NOTIFICATION_NAME = "RELOAD_NEWS_NOTIFICATION_NAME"
    public static let RELOAD_BESTSELLERS_NOTIFICATION_NAME = "RELOAD_BESTSELLERS_NOTIFICATION_NAME"
    
    public static let MY_SEARCH_STORED = "MY_SEARCH_STORED";
    public static let MY_BOOKS_LIKE_STORED = "MY_BOOKS_LIKE_STORED";
    public static let BOOKS_STORED = "BOOKS_STORED";
    public static let BOOKS_STORED_DATE = "BOOKS_STORED_DATE";
    public static let BOOKS_STORED_BEST_SELLER = "BOOKS_STORED_BEST_SELLER";
    public static let BOOKS_STORED_DATE_BEST_SELLER = "BOOKS_STORED_DATE_BEST_SELLER";
    public static let ALL_SEARCH_STORED = "ALL_SEARCH_STORED";
    public static let ALL_AUTHOR_STORED = "ALL_AUTHOR_STORED";
    public static let LAUNGUAGE_SELECETED = "LAUNGUAGE_SELECETED";
    public static let UUID = "UUID";
    public static let BUYED_REMOVE_ADS = "BUYED_REMOVE_ADS";
    public static let TUTORIAL_SEARCH = "TUTORIAL_SEARCH";
    public static let TUTORIAL_MY_BOOKS = "TUTORIAL_MY_BOOKS";
    
    public static let SHARED = "Condiviso usando InstaBook. Ti potrebbe interessare ";
    public static let myColor = UIColor(red: 48.0/255.0, green: 63.0/255.0, blue: 159.0/255.0, alpha: 0.9);
    public static let placeHolderTextView = NSLocalizedString("input_text_to_search", comment: "input_text_to_search");
    
    public static let POLICY_PRIVACY_LINK = "http://www.instabook.it/privacypolicy.htm"
    public static let BIRRA_LINK = "https://www.paypal.me/arandroid"
    public static let FACEBOOK_LINK = "https://www.facebook.com/instabookapp/"
    public static let TWITTER_LINK = "https://www.twitter.com/instabook_app/"
    public static let INSTAGRAM_LINK = "https://www.instagram.com/instabook.app/"
    public static let VOTEWS_LINK = "http://52.17.141.7:50505/votews"

    public static let CLASSIFICA = "CLASSIFICA";
    public static let NEWS = "NEWS";
    
}