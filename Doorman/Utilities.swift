//
//  Utilities.swift
//  Doorman
//
//  Created by Matt Neuburg on 10/31/21.
//

import Foundation

extension String {
    func range(_ start:Int, _ count:Int) -> Range<String.Index> {
        let i = self.index(start >= 0 ?
            self.startIndex :
            self.endIndex, offsetBy: start)
        let j = self.index(i, offsetBy: count)
        return i..<j
    }
}
