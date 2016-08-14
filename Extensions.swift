//
//  extensions.swift
//  FinputTest
//
//  Created by Benjamin Lim on 30/07/2016.
//  Copyright © 2016 Benjamin Lim. All rights reserved.
//

import Foundation
import UIKit

//extension for UIView
extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerate() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

//extension for UIColor

extension UIColor {
    
    static func FinnBlue() -> UIColor {
        return UIColor(red: 176/255, green: 224/255, blue: 230/255, alpha: 1)
    }
    
    static func FinnMaroon() -> UIColor {
        return UIColor(red: 148/255, green: 67/255, blue: 67/255, alpha:1)
    }
    
    static func FinnMaroonBlur() -> UIColor {
        return UIColor(red: 148/255, green: 67/255, blue: 67/255, alpha:0.9)
    }

    
}

//extension for String-Split
extension String {
    func splitWords() -> [String] {
        
        let range = Range<String.Index>(self.startIndex..<self.endIndex)
        
        var words = [String]()
        
        self.enumerateSubstringsInRange(range, options: NSStringEnumerationOptions.ByWords) { (substring, _, _, _) -> () in
            words.append(substring!)
            
        }
        
        return words
        
    }
    
}

extension FinController {
    enum ChatErrors: ErrorType {
        case tooManyMessages 
    }
}