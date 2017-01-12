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
    let segueIdentifier = "ShowBooksView"

    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.DescrizioneMenuArray = [NSLocalizedString("bestSellers", comment: "bestSellers"),NSLocalizedString("mySearches", comment: "mySearches"),NSLocalizedString("my_books", comment: "my_books"), NSLocalizedString("action_settings", comment: "action_settings")];
        self.ImageMenuArray = ["dollar.png","search.png","book.png","setting.png"];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if  segue.identifier == segueIdentifier,
            let destination = segue.destinationViewController as? BooksView,
            index = tableView.indexPathForSelectedRow?.row
        {
           destination.titleName = DescrizioneMenuArray[index]
           self.revealViewController().revealToggle(nil)
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DescrizioneMenuArray.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell;
        let imageMenu = cell.contentView.viewWithTag(1) as! UIImageView
        let descrizioneMenu = cell.contentView.viewWithTag(2) as! UILabel
        descrizioneMenu.text = self.DescrizioneMenuArray[indexPath.row];
        imageMenu.image = UIImage(named:ImageMenuArray[indexPath.row]);
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        print(DescrizioneMenuArray[row], terminator: "")
        
        }

}