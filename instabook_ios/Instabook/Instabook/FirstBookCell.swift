//
//  FirstBook.swift
//  Instabook
//
//  Created by Marco Ferraro on 24/01/17.
//  Copyright © 2017 instabook. All rights reserved.
//

import Foundation


public class FirstBookCell: UITableViewCell
{
    
    @IBOutlet weak var titolo: UILabel!
    @IBOutlet weak var autore: UILabel!
    
    @IBOutlet weak var numero: UILabel!
    @IBOutlet weak var prezzo: UILabel!
    
    @IBOutlet weak var copertina: UIImageView!
    @IBOutlet weak var shared: UIButton!
    @IBOutlet weak var cuore: UIButton!
}