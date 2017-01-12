//
//  Utils.swift
//  Instabook
//
//  Created by Leonardo Rania on 22/11/16.
//  Copyright (c) 2016 instabook. All rights reserved.
//

import Foundation

public class Utils
{

    
    public class func createFloatingButton(floatingButton:UIButton, viewWidht: CGFloat ,position: CGFloat) -> UIButton
    {
        
        floatingButton.center = CGPoint(x: viewWidht - 60 , y: position - 40 )
        floatingButton.layer.shadowOffset = CGSizeMake(0.1, 1.0);
        floatingButton.layer.shadowOpacity = 0.2;
        floatingButton.layer.shadowRadius = 0.0;

        return floatingButton;
    }
    
}