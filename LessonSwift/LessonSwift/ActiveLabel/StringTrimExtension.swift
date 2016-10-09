//
//  StringTrimExtension.swift
//  ActiveLabel
//
//  Created by Pol Quintana on 04/09/16.
//  Copyright © 2016 Optonaut. All rights reserved.
//

import Foundation

extension String {

    func trim(to maximumCharacters: Int) -> String {
//        return substring(to: startIndex.advancedBy(maximumCharacters)) + "..."
        return substring(to:index(startIndex, offsetBy: maximumCharacters)) + "..."
    }
}
