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
        
        floatingButton.center = CGPoint(x: viewWidht - 80 , y: position - 80 )

        return floatingButton;
    }
    
}