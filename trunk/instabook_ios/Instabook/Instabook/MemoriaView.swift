//
//  CustomDialogViewController.swift
//  Instabook
//
//  Created by Marco Ferraro on 04/12/16.
//  Copyright © 2016 instabook. All rights reserved.
//

import Foundation

public class MemoriaView: UIViewController
{
    var cacheManager = CacheManager()
    @IBOutlet weak var btnRemBestSeller: UIButton!
    @IBOutlet weak var bckButton: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var btnRemovePreferred: UIButton!
    @IBOutlet weak var btnRemoveRecents: UIButton!
    @IBOutlet weak var btnRemoveNews: UIButton!

    public override func viewDidLoad() {
        super.viewDidLoad()
        bckButton.addTarget(self, action: #selector(MemoriaView.back(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let tapBackView = UITapGestureRecognizer(target:self, action:#selector(MemoriaView.back(_:)))
        backView.addGestureRecognizer(tapBackView)
        btnRemovePreferred.layer.cornerRadius = 0.5 * btnRemovePreferred.bounds.size.width
        btnRemovePreferred.layer.shadowOffset = CGSizeMake(0.1, 1.0);
        btnRemovePreferred.layer.shadowOpacity = 0.2;
        btnRemovePreferred.layer.shadowRadius = 0.0;
        btnRemovePreferred.setImage(UIImage(named:"delete.png"), forState: .Normal)
        btnRemovePreferred.backgroundColor = UIColor(red: 255.0/255, green: 217.0/255, blue: 3.0/255, alpha: 1.0)
        btnRemovePreferred.addTarget(self, action: #selector(MemoriaView.removePreferred(_:)), forControlEvents: .TouchUpInside)
        
        btnRemBestSeller.layer.cornerRadius = 0.5 * btnRemBestSeller.bounds.size.width
        btnRemBestSeller.layer.shadowOffset = CGSizeMake(0.1, 1.0);
        btnRemBestSeller.layer.shadowOpacity = 0.2;
        btnRemBestSeller.layer.shadowRadius = 0.0;
        btnRemBestSeller.setImage(UIImage(named:"delete.png"), forState: .Normal)
        btnRemBestSeller.backgroundColor = UIColor(red: 255.0/255, green: 217.0/255, blue: 3.0/255, alpha: 1.0)
        btnRemBestSeller.addTarget(self, action: #selector(MemoriaView.removeBestSeller(_:)), forControlEvents: .TouchUpInside)
        
        btnRemoveRecents.layer.cornerRadius = 0.5 * btnRemoveRecents.bounds.size.width
        btnRemoveRecents.layer.shadowOffset = CGSizeMake(0.1, 1.0);
        btnRemoveRecents.layer.shadowOpacity = 0.2;
        btnRemoveRecents.layer.shadowRadius = 0.0;
        btnRemoveRecents.setImage(UIImage(named:"delete.png"), forState: .Normal)
        btnRemoveRecents.backgroundColor = UIColor(red: 255.0/255, green: 217.0/255, blue: 3.0/255, alpha: 1.0)
        btnRemoveRecents.addTarget(self, action: #selector(MemoriaView.removeRecents(_:)), forControlEvents: .TouchUpInside)
        
        btnRemoveNews.layer.cornerRadius = 0.5 * btnRemoveNews.bounds.size.width
        btnRemoveNews.layer.shadowOffset = CGSizeMake(0.1, 1.0);
        btnRemoveNews.layer.shadowOpacity = 0.2;
        btnRemoveNews.layer.shadowRadius = 0.0;
        btnRemoveNews.setImage(UIImage(named:"delete.png"), forState: .Normal)
        btnRemoveNews.backgroundColor = UIColor(red: 255.0/255, green: 217.0/255, blue: 3.0/255, alpha: 1.0)
        btnRemoveNews.addTarget(self, action: #selector(MemoriaView.removeNews(_:)), forControlEvents: .TouchUpInside)
        
    }

    func back(sender:UIButton!) {
        self.dismissViewControllerAnimated(false, completion: nil)
        
    }
    
    func removeBestSeller(sender:UIButton!) {
        cacheManager.deleteBestSeller()
        let snackbar = MKSnackbar(
            withTitle: "Attività eseguita",
            withDuration: nil,
            withTitleColor: nil,
            withActionButtonTitle: "",
            withActionButtonColor: UIColor.lightGrayColor())
        snackbar.show()
    }
    
    func removePreferred(sender:UIButton!) {
        cacheManager.deleteMyBook()
        let snackbar = MKSnackbar(
            withTitle: "Attività eseguita",
            withDuration: nil,
            withTitleColor: nil,
            withActionButtonTitle: "",
            withActionButtonColor: UIColor.lightGrayColor())
        snackbar.show()
    }
    
    func removeRecents(sender:UIButton!) {
        cacheManager.deleteMySearch()
        let snackbar = MKSnackbar(
            withTitle: "Attività eseguita",
            withDuration: nil,
            withTitleColor: nil,
            withActionButtonTitle: "",
            withActionButtonColor: UIColor.lightGrayColor())
        snackbar.show()
    }
    
    func removeNews(sender:UIButton!) {
        cacheManager.deleteNews()
        let snackbar = MKSnackbar(
            withTitle: "Attività eseguita",
            withDuration: nil,
            withTitleColor: nil,
            withActionButtonTitle: "",
            withActionButtonColor: UIColor.lightGrayColor())
        snackbar.show()
    }
}