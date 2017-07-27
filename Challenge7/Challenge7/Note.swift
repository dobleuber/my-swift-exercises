//
//  Note.swift
//  Challenge7
//
//  Created by Wbert Castro on 26/07/17.
//  Copyright © 2017 Wbert Castro. All rights reserved.
//

import UIKit

class Note: NSObject, NSCoding {
    var title: String {
        let value: String
        if text.characters.count > 50 {
            value = text.substring(to: text.index(text.startIndex, offsetBy: 50))
        } else {
            value = text
        }
        
        return value
    }
    
    
    var text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    required init(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "text") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "text")
    }
}
