//
//  Toast+Extension.swift
//  SeSAC_Friends
//
//  Created by 김진영 on 2022/01/20.
//

import Foundation

import Toast
import UIKit

var style = ToastStyle()

extension ToastStyle {
    
    static var defaultStyle: ToastStyle {
        
        // this is just one of many style options
        style.messageColor = UIColor().white
        style.backgroundColor = UIColor().black
        style.messageFont = UIFont().Body3_R14
        
        return style
    }
    
}
