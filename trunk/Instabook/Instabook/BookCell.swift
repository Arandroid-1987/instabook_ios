//
//  BookCell.swift
//  Instabook
//
//  Created by Marco Ferraro on 19/11/16.
//  Copyright © 2016 instabook. All rights reserved.
//

import Foundation

import UIKit

public class BookCell: UITableViewCell
{
    
    @IBOutlet weak var titolo: UILabel!
    @IBOutlet weak var autore: UILabel!
    
    @IBOutlet weak var numero: UILabel!
    @IBOutlet weak var prezzo: UILabel!
   
    @IBOutlet weak var copertina: UIImageView!
    @IBOutlet weak var shared: UIImageView!
    @IBOutlet weak var cuore: UIImageView!
}