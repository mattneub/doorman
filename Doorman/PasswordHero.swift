//
//  PasswordHero.swift
//  Doorman
//
//  Created by Matt Neuburg on 10/30/21.
//

import Foundation

extension PasswordHero {
    @objc
    func specialCharsAsString() -> String {
        let specialString = NSMutableString()
        for c in self.specialChars {
            specialString.append(c)
        }
        return specialString as String
    }
}
