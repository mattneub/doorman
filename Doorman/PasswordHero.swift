//
//  PasswordHero.swift
//  Doorman
//
//  Created by Matt Neuburg on 10/30/21.
//

import Foundation


final class PasswordHero : NSObject {

    var passwordLength: Int
    var hasLowerCase, hasNumbers, hasSpecialChars, hasUpperCase, isSpeakable : Bool
    var lastSyllableHasLastConsonant : Bool
    let passwordsPerSecond : CGFloat
    var specialChars: [String] {
        didSet {
            if self.specialChars.count == 0 {
                self.specialChars = self.allSpecialChars
            }
        }
    }
    let allSpecialChars, lowerCaseLetters, upperCaseLetters, numbers, firstConsonants, lastConsonants, vowels : [String]
    let leetDict : [String:String] = {
        var d = [String:String]()
        let vals : [String] = ["3","0","!","4","5"]
        let keys : [String] = ["e","o","i","a","s"]
        zip(vals,keys).forEach { d[$0.1] = $0.0 }
        return d
    }()
    lazy var upperForLowerCaseDict : [String:String] = {
        var d = [String:String]()
        zip(self.upperCaseLetters, self.lowerCaseLetters).forEach { d[$0.1] = $0.0 }
        return d
    }()
    var lastSyllableLength: Int

    override init() {
        self.passwordsPerSecond = 2.0 * pow(10, 9)
        print("passwordManager > init > pps:", self.passwordsPerSecond)
        self.lowerCaseLetters = ["a", "b","c", "d",
                                 "e", "f", "g", "h", "i", "j", "k", "l",
                                 "m", "n", "o", "p", "q", "r", "s", "t",
                                 "u", "v", "w", "x", "y", "z"]
        self.upperCaseLetters = ["A", "B", "C", "D",
                                 "E", "F", "G", "H", "I", "J", "K", "L", "M", "N",
                                 "O", "P", "Q", "R", "S", "T", "U", "V",
                                 "W", "X", "Y", "Z"]
        self.numbers = ["1", "2", "3", "4", "5", "6",
                        "7", "8", "9", "0"]
        self.allSpecialChars = ["!", "§", "$", "%",
                                "&", "/", "(", ")", "[", "]", "{", "}","<", ">",
                                "?", "#",
                                //"",
                                "=", "-", "_", ".", ",", "+", "*", ":"]
        self.specialChars = self.allSpecialChars
        self.passwordLength = 12
        self.hasLowerCase = true
        self.hasNumbers = true
        self.hasSpecialChars = false
        self.hasUpperCase = true
        self.isSpeakable = false
        self.lastSyllableHasLastConsonant = true
        self.lastSyllableLength = 0
        self.firstConsonants = ["b", "c", "d", "f",
                                "g", "h", "j", "k", "l", "m", "n", "o", "p",
                                "qu", "r", "s", "t", "v", "w", "x", "y", "z", "ch",
                                "b", "c", "d", "f",
                                "g", "h", "j", "k", "l", "m", "n", "o", "p",
                                "qu", "r", "s", "t", "v", "w", "x", "z", "ch",
                                "sh", "sc", "sp", "st", "ph", "squ",
                                // "bh","dh","gh","kh",
                                "th", "wh","h", "bl", "br",
                                "cl", "cr", "dr",
                                //"tl",
                                "tr", "gl", "gr", "kl",
                                //"kr",
                                "pr", "sl", "tr",
                                // "tl","vr","vl",
                                // "wr", "wl","xl", "chr","chl","shr", "shl","scl",
                                "scr", "spl", "spr", "str",
                                //"stl","phl","phr",
                                "thr",
                                //"thl",
        ]
        self.lastConsonants = ["b", "c", "d", "f",
                               "g",
                               // "h", "k",
                               "l", "m", "n",
                               //"o",
                               "p",
                               //"qu",
                               "r", "s", "t","v",
                               //"w", "x", "z",
                               "b", "c", "d", "f",
                               "g",
                               //"h","j", "k",
                               "l", "m", "n",
                               //"o",
                               "p",
                               //"qu",
                               "r", "s", "t", "v",
                               //"w", "x", "z","ch",
                               "ch","sh","th",
                               //"sp",
                               "st",
                               "ll",
                               //"rr",
                               //"mm", "nn", "tt", "ss", "gh",
                               "ck"]
        self.vowels = ["a", "e", "i", "o", "u",
                       "a", "e", "i", "o", "u",
                       // "y",
                       // "ay", "uy", "oy", "ei", "ie",
                       "au", "ou",
                       //"ai", "aa",
                       "ee", "oo",
                       //"eu","eo","ui","uo",
                       "a", "e", "i", "o", "u"]
    }

    func setSpecialCharsAsString(_ specialString: String?) {
        if specialString?.isEmpty ?? true {
            self.specialChars = []
        } else {
            self.specialChars = Array(specialString!).map {String($0)}
        }
    }

    func specialCharsAsString() -> String {
        return self.specialChars.joined()
    }

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

        do {
            let days = Int(secondsToCrack/(3600.0*24.0))
            let log1 = Int(log10(passwordsPerSecond))
            let log2 = Int(log10(possibleCombinations))
            print("Time to brute force: \(days) days @ \(log1) passwords/sec; possible combinations \(log2); strength \(passwordStrength)")
        }

        return Int(passwordStrength)
    }

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

    // unused, it appears
    func applyLeetSpeak(_ aString: String) -> String {
        Array(aString).map(String.init).map { self.leetDict[$0] ?? $0 }.joined()
    }

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
        // new rule: must start with letter
        if self.hasLowerCase {
            password.append(self.lowerCaseLetters.randomElement() ?? "")
        } else if self.hasUpperCase {
            password.append(self.upperCaseLetters.randomElement() ?? "")
        }
        for _ in 0..<self.passwordLength {
            password.append(chars.randomElement() ?? "")
        }
        print("create password", password)
        return password
    }

    func createSyllable() -> String {
        let firstConsonantProbability = CGFloat.random(in: 0..<1)
        let lastConsonantProbability = CGFloat.random(in: 0..<1)
        var syllable = ""
        if firstConsonantProbability < 0.75 || !self.lastSyllableHasLastConsonant {
            syllable += self.firstConsonants.randomElement() ?? ""
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

    func createSpeakablePasswordCandidate() -> String {
        self.lastSyllableHasLastConsonant = false
        var speakablePassword = ""
        func addNumberOrSpecial() {
            let numberOrSpecialProbability = CGFloat.random(in:0..<1)
            if self.hasNumbers && numberOrSpecialProbability > 0.6 {
                speakablePassword += self.numbers.randomElement() ?? ""
            } else if self.hasSpecialChars && numberOrSpecialProbability < 0.3 {
                speakablePassword += self.specialChars.randomElement() ?? ""
            }
        }

        // add syllables, each possibly followed by special character or digit
        while speakablePassword.count < self.passwordLength {
            speakablePassword += self.createSyllable()
            addNumberOrSpecial()
        }

        // if too long, recurse and try again
        if speakablePassword.count > self.passwordLength {
            speakablePassword = self.createSpeakablePasswordCandidate()
        }

        if self.hasLowerCase && self.hasUpperCase {
            for i in 0..<passwordLength {
                let range = speakablePassword.range(i,1)
                let charAtI = speakablePassword[range]
                if let caseReplacement = self.upperForLowerCaseDict[String(charAtI)] {
                    let replaceProbability = CGFloat.random(in:0..<1)
                    if replaceProbability > 0.8 {
                        speakablePassword.replaceSubrange(range, with: caseReplacement)
                    }
                }
            }
        } else if self.hasUpperCase && !self.hasLowerCase {
            speakablePassword = speakablePassword.uppercased()
        }

        return speakablePassword
    }

}
