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

    /*!
     @abstract prüft ob das passwort die geforderten optionen erfüllt.
     @discussion jed der gesetzten optionen muss im passwort mit midestens einem zeichen erfüllt sein.
     @updated 2009-08-08 gaby & anna
     */
    /*
    - (BOOL) checkPasswordBeforeOut:(NSString*) password{
        BOOL existsLetter = !hasLowerCase;
        BOOL existsUpperLetter = !hasUpperCase;
        BOOL existsNumber = !hasNumbers;
        BOOL existsSpecialChar = !hasSpecialChars;

        for (NSInteger i = 0; i< passwordLength; i++){
            NSString* singleChar = [password substringWithRange:NSMakeRange(i, 1)];
            if (NO == existsLetter && [lowerCaseLetters containsObject:singleChar]){
                existsLetter = YES;
                continue;
            }
            if (NO == existsUpperLetter && [upperCaseLetters containsObject:singleChar]){
                existsUpperLetter = YES;
                continue;
            }
            if (NO == existsNumber && [numbers containsObject:singleChar]){
                existsNumber = YES;
                continue;
            }
            if (NO == existsSpecialChar && [specialChars containsObject:singleChar]){
                existsSpecialChar = YES;
                continue;
            }
        }

        BOOL isOK = existsLetter && existsUpperLetter && existsNumber && existsSpecialChar;

        if (NO == isOK) {
            NSLog(@"PH > check > is not ok %@", password);
        }
        return isOK;
    }
    */

    @objc
    func checkPasswordBeforeOut(_ password: String) -> Bool {
        var existsLetter = !self.hasLowerCase
        var existsUpperLetter = !self.hasUpperCase
        var existsNumber = !self.hasNumbers
        var existsSpecialChar = !self.hasSpecialChars
        for singleChar in Array(password).map(String.init) {
            if !existsLetter && self.lowerCaseLetters.contains(singleChar) {
                existsLetter = true
                continue
            }
            if !existsUpperLetter && self.upperCaseLetters.contains(singleChar) {
                existsUpperLetter = true
                continue
            }
            if !existsNumber && self.numbers.contains(singleChar) {
                existsNumber = true
                continue
            }
            if !existsSpecialChar && self.specialChars.contains(singleChar) {
                existsSpecialChar = true
                continue
            }
        }
        let isOK = existsLetter && existsUpperLetter && existsNumber && existsSpecialChar
        if !isOK {
            print("PH > check > is not ok", password)
        }
        return isOK
    }
    /*
    -(NSInteger) passwordStrength {
        CGFloat possibleSymbols = 0;
        if (hasNumbers) {
            possibleSymbols += 10;
        }
        if (hasSpecialChars) {
            possibleSymbols += [specialChars count];
        }
        if (hasUpperCase) {
            possibleSymbols += [self.upperCaseLetters count];
        }
        if (hasLowerCase) {
            possibleSymbols += [self.lowerCaseLetters count];
        }

        CGFloat possibleCombinations = pow(possibleSymbols, (CGFloat)passwordLength);
        CGFloat secondsToCrack = (possibleCombinations / passwordsPerSecond)/(2);
        NSInteger passwordStrength = (NSInteger)log10(secondsToCrack);

        if (isSpeakable && passwordStrength > 0) {
            passwordStrength -= 2;
        }

        NSLog(@"Time to brute force: %.1f days @ 10^%ld passwords/sec; possible combinations 10^%ld; strength %ld", secondsToCrack/(3600*24), (NSInteger)(log10(passwordsPerSecond)), (NSInteger)log10(possibleCombinations), passwordStrength);

        return passwordStrength;
    }
     */

    @objc
    func calculatePasswordStrength() -> Int {
        var possibleSymbols : CGFloat = 0
        if self.hasNumbers {
            possibleSymbols += 10
        }
        if self.hasSpecialChars {
            possibleSymbols += CGFloat(self.specialChars.count)
        }
        if self.hasUpperCase {
            possibleSymbols += CGFloat(self.upperCaseLetters.count)
        }
        if self.hasLowerCase {
            possibleSymbols += CGFloat(self.lowerCaseLetters.count)
        }
        let possibleCombinations = pow(possibleSymbols, CGFloat(passwordLength))
        let secondsToCrack = (possibleCombinations / self.passwordsPerSecond) / 2
        var passwordStrength = log10(secondsToCrack)

        if isSpeakable && passwordStrength > 0 {
            passwordStrength -= 2
        }

        // NSLog("Time to brute force: %.1f days @ 10^%ld passwords/sec; possible combinations 10^%ld; strength %ld", secondsToCrack/(3600*24), (NSInteger)(log10(passwordsPerSecond)), (NSInteger)log10(possibleCombinations), passwordStrength)

        return Int(passwordStrength)
    }

}
