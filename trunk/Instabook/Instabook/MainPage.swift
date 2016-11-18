//
//  MainPage.swift
//  Instabook
//
//  Created by Leonardo Rania on 18/11/16.
//  Copyright (c) 2016 instabook. All rights reserved.
//

import Foundation
import UIKit

public class MainPage: UITableViewController
{

    
    @IBOutlet var Open: UIBarButtonItem!
    @IBOutlet var textFieldCitazione: UITextField!
    public override func viewDidLoad() {
        super.viewDidLoad();
        
        self.tableView.registerNib(UINib(nibName: "CellCustom", bundle: nil), forCellReuseIdentifier: "rowTable");
        self.tableView.rowHeight = 250;
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController?.navigationBar.barTintColor = Constants.myColor ;
        
        Open.target = self.revealViewController();
        Open.action = Selector("revealToggle:");
        //Open.action = Selector("rotateImage:");
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer());
    }
    
    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 5;
    }
    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("rowTable", forIndexPath: indexPath) as CellCustom
        
        //Configure CardViewLeft
        let tapCuoreLeft = UITapGestureRecognizer(target:self, action:Selector("connected:"))
        cell.cuoreCardViewLeft.addGestureRecognizer(tapCuoreLeft)
        cell.cuoreCardViewLeft.tag = indexPath.row
        
        var tapCardViewLeft = UITapGestureRecognizer(target: self, action: Selector("connected2:"))
        cell.cardViewLeft.addGestureRecognizer(tapCardViewLeft)
        cell.cardViewLeft.tag = indexPath.row
        
        let tapSharedLeft = UITapGestureRecognizer(target:self, action:Selector("connected1:"))
        cell.sharedCardViewLeft.addGestureRecognizer(tapSharedLeft)
        cell.sharedCardViewLeft.tag = indexPath.row
        
        //Configure CardViewRight
        let tapCuoreRight = UITapGestureRecognizer(target:self, action:Selector("connected:"))
        cell.cuoreCardViewRight.addGestureRecognizer(tapCuoreRight)
        cell.cuoreCardViewRight.tag = indexPath.row
        
        let tapCardViewRight = UITapGestureRecognizer(target: self, action: Selector("connected2:"))
        cell.cardViewRight.addGestureRecognizer(tapCardViewRight)
        cell.cardViewRight.tag = indexPath.row
        
        let tapSharedRight = UITapGestureRecognizer(target:self, action:Selector("connected1:"))
        cell.sharedCardViewRight.addGestureRecognizer(tapSharedRight)
        cell.sharedCardViewRight.tag = indexPath.row
        
        
        return cell;
    }
    
    func connected(sender: UITapGestureRecognizer!) {
        
        println(sender.description)
    }
    
    func connected1(sender: UITapGestureRecognizer!) {
        
        println(sender.description)
    }
    
    func connected2(sender: UITapGestureRecognizer!) {
        
        println("tap")
    }
    
    override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var alert = UIAlertView()
        alert.delegate = self
        alert.title = "Selected Row"
        alert.message = "You selected row \(indexPath.row)"
        alert.addButtonWithTitle("OK")
        alert.show()
    }

}