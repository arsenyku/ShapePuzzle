//
//  String+Helpers.swift
//  ShapePuzzle
//
//  Created by asu on 2016-01-23.
//  Copyright © 2016 Apportable. All rights reserved.
//

import UIKit

extension String {
    func beginsWith (str: String) -> Bool {
        if let range = self.rangeOfString(str) {
            return range.startIndex == self.startIndex
        }
        return false
    }
    
    func endsWith (str: String) -> Bool {
        if let range = self.rangeOfString(str, options:NSStringCompareOptions.BackwardsSearch) {
            return range.endIndex == self.endIndex
        }
        return false
    }
}
