//
//  Menu.swift
//  Instabook
//
//  Created by Leonardo Rania on 17/11/16.
//  Copyright (c) 2016 instabook. All rights reserved.
//

import Foundation

class Menu: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var DescrizioneMenuArray = [String]();
    var ImageMenuArray = [String]();

    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.DescrizioneMenuArray = ["Best Seller","Le Mie Ricerche","I Miei Libri", "Impostazioni"];
        self.ImageMenuArray = ["dollar.png","search.png","book.png","setting.png"];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DescrizioneMenuArray.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell;
        var imageMenu = cell.contentView.viewWithTag(1) as UIImageView
        let descrizioneMenu = cell.contentView.viewWithTag(2) as UILabel
        descrizioneMenu.text = self.DescrizioneMenuArray[indexPath.row];
        imageMenu.image = UIImage(named:ImageMenuArray[indexPath.row]);
        return cell;
    }
}