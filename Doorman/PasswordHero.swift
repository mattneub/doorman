//
//  PasswordHero.swift
//  Doorman
//
//  Created by Matt Neuburg on 10/30/21.
//

import Foundation

extension PasswordHero {

    @objc
    func setSpecialCharsAsString(_ specialString: String?) {
        if specialString?.isEmpty ?? true {
            self.specialChars = nil
        } else {
            self.specialChars = Array(specialString!).map {String($0)}
        }
    }

    @objc
    func specialCharsAsString() -> String {
        return self.specialChars.joined()
    }
}
