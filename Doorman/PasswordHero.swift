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

    /*
    -(NSString*) createPassword {
        NSString* password = [self createPasswordCandidate];
        for (NSInteger i = 0; i < 20; i++) {
            if (NO ==[self checkPasswordBeforeOut:password]){
                password = [self createPasswordCandidate];
            } else {
                break;
            }
        }
        return password;
    }

    -(NSString*) createSpeakablePassword {
        NSString* password = [self createSpeakablePasswordCandidate];
        for (NSInteger i = 0; i < 20; i++) {
            if (NO == [self checkPasswordBeforeOut:password]){
                password = [self createSpeakablePasswordCandidate];
            } else {
                break;
            }
        }
        return password;
    }
     */
    @objc
    func createPassword() -> String {
        var password = self.createPasswordCandidate()
        for _ in 0..<20 {
            if !self.checkPasswordBeforeOut(password) {
                password = self.createPasswordCandidate()
            } else {
                break
            }
        }
        return password
    }
    @objc
    func createSpeakablePassword() -> String {
        var password = self.createSpeakablePasswordCandidate()
        for _ in 0..<20 {
            if !self.checkPasswordBeforeOut(password) {
                password = self.createSpeakablePasswordCandidate()
            } else {
                break
            }
        }
        return password
    }

    /*!
     @abstract Ersetzt im übergeben String buchstaben durch zahlen gemäss leetspeak.
     @updated 2009-08-08 gaby & anna
     */
    /*
    -(NSString*) applyLeetSpeak:(NSString*) aString {
        NSMutableString* newPassword = [NSMutableString stringWithString:aString];
        for(NSInteger i = 0; i < [aString length]; i++){
            NSRange r = NSMakeRange(i, 1);
            NSString* leetChar = leetDict[[aString substringWithRange:r]];
            if (leetChar != nil) {
                [newPassword replaceCharactersInRange:r withString:leetChar];
            }
        }
        return [NSString stringWithString:newPassword];
    }
*/
    // unused, it appears
    @objc
    func applyLeetSpeak(_ aString: String) -> String {
        Array(aString).map(String.init).map { self.leetDict[$0] ?? $0 }.joined()
    }

    /*!
     @abstract erzeugt ein zufälliges passwort gemäss den optionen.
     @updated 2009-08-08 gaby & anna
     */
    /*
    -(NSString* _Nonnull) createPasswordCandidate{
        NSMutableArray* characters = [NSMutableArray arrayWithCapacity:80];
        if (hasLowerCase){
            [characters addObjectsFromArray:self.lowerCaseLetters];
        }
        if (hasNumbers){
            [characters addObjectsFromArray:self.numbers];
        }
        if (hasSpecialChars){
            [characters addObjectsFromArray:specialChars];
        }
        if (hasUpperCase){
            [characters addObjectsFromArray:self.upperCaseLetters];
        }
        NSMutableString* password = [NSMutableString stringWithString:@""];

        for (NSInteger i = 0; i < passwordLength; i++) {
            NSInteger r = [self.randomNumberGenerator randomIntBetween:0 and:[characters count]-1];
            [password appendString:characters[r]];
        }

        //NSLog(@"createPassword: %@", password);
        return [NSString stringWithString: password];
    }
     */
    @objc
    func createPasswordCandidate() -> String {
        var chars = [String]()
        if self.hasLowerCase {
            chars.append(contentsOf: self.lowerCaseLetters)
        }
        if self.hasNumbers {
            chars.append(contentsOf: self.numbers)
        }
        if self.hasSpecialChars {
            chars.append(contentsOf: self.specialChars)
        }
        if self.hasUpperCase {
            chars.append(contentsOf: self.upperCaseLetters)
        }
        var password = ""
        for _ in 0..<self.passwordLength {
            password.append(chars.randomElement() ?? "")
        }
        return password
    }

    /*!
     @abstract Erzeugt eine zufällige silbe zufälliger länge.
     @updated 2009-08-08 gaby & anna
     */
    /*
    -(NSString*) createSyllable{
        CGFloat firstConsonantProbability = [self.randomNumberGenerator randomFloatBetween:0 and:1];
        CGFloat lastConsonantProbability = [self.randomNumberGenerator randomFloatBetween:0 and:1];
        NSMutableString* syllable = [NSMutableString stringWithCapacity:7];
        if (firstConsonantProbability < 0.75 || !lastSyllableHasLastConsonant) {
            lastSyllableHasLastConsonant = YES;
            NSInteger randomFirstConsonant = [self.randomNumberGenerator randomIntBetween:0 and:[firstConsonants count]-1];
            [syllable appendString:firstConsonants[randomFirstConsonant]];
        } else {
            lastSyllableHasFirstConsonant = NO;
        }
        NSInteger randomVowel = [self.randomNumberGenerator randomIntBetween:0 and:[vowels count]-1];
        [syllable appendString:vowels[randomVowel]];
        if (lastConsonantProbability < 0.5) {
            lastSyllableHasLastConsonant = YES;
            NSInteger randomLastConsonant = [self.randomNumberGenerator randomIntBetween:0 and:[lastConsonants count]-1];
            [syllable appendString:lastConsonants[randomLastConsonant]];
        } else {
            lastSyllableHasLastConsonant = NO;
        }

        lastSyllableLength = [syllable length];
        return syllable;
    }
     */
    @objc func createSyllable() -> String {
        let firstConsonantProbability = CGFloat.random(in: 0..<1)
        let lastConsonantProbability = CGFloat.random(in: 0..<1)
        var syllable = ""
        if firstConsonantProbability < 0.75 || !self.lastSyllableHasLastConsonant {
            self.lastSyllableHasFirstConsonant = true // bug in the original?
            // actually the whole thing looks like a bug; this value is never tested, only set, pointlessly
            syllable += self.firstConsonants.randomElement() ?? ""
        } else {
            self.lastSyllableHasFirstConsonant = false
        }
        syllable += self.vowels.randomElement() ?? ""
        if lastConsonantProbability < 0.5 {
            self.lastSyllableHasLastConsonant = true
            syllable += self.lastConsonants.randomElement() ?? ""
        } else {
            self.lastSyllableHasLastConsonant = false
        }
        self.lastSyllableLength = syllable.count
        return syllable
    }


}
