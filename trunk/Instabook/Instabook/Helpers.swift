//
//  Helpers.swift
//  Instabook
//
//  Created by Leonardo Rania on 17/11/16.
//  Copyright (c) 2016 instabook. All rights reserved.
//

import Foundation
extension UITextView {
    
    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGrayColor().CGColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
extension String {
    var length: Int { return countElements(self) }
}