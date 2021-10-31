//
//  AppController.swift
//  Doorman
//
//  Created by Matt Neuburg on 10/31/21.
//

import AppKit

enum Default {
    static let specialChars = "specialCharacters"
    static let hasLowerCase = "hasLowerCase"
    static let hasNumbers = "hasNumbers"
    static let hasSpecialChars = "hasSpecialChars"
    static let hasUpperCase = "hasUpperCase"
    static let isSpeakable = "isSpeakable"
    static let passwordLength = "passwordLength"
}

@main
final class AppController : NSObject, NSApplicationDelegate, NSWindowDelegate {

    private var passwordHero = PasswordHero()

    @IBOutlet private var doormanWindow: NSWindow!
    @IBOutlet private weak var hasLowerCaseCheck : NSButton!
    @IBOutlet private weak var hasNumbersCheck : NSButton!
    @IBOutlet private weak var hasSpecialCharsCheck : NSButton!
    @IBOutlet private weak var hasUpperCaseCheck : NSButton!
    @IBOutlet private weak var isSpeakableCheck : NSButton!

    @IBOutlet private weak var copyButton : NSButton!

    @IBOutlet private weak var passwordLengthTextField : NSTextField!
    @IBOutlet private weak var specialCharsTextField : NSTextField!
    @IBOutlet private weak var passwordTextField : NSTextField!
    @IBOutlet private weak var strengthDescription : NSTextField!

    @IBOutlet private weak var passwordLengthStepper : NSStepper!

    @IBOutlet private weak var passwordStrengthLevelIndicator : NSLevelIndicator!

    @IBAction private func createPasswordClicked(_ sender: AnyObject) {
        let specials = self.specialCharsTextField.stringValue
        self.passwordHero.setSpecialCharsAsString(specials)
        if specials.count == 0 {
            self.specialCharsTextField.stringValue = self.passwordHero.specialCharsAsString()
            self.hasSpecialCharsCheck.state = .off
            self.optionCheckBoxClicked(self)
        }
        UserDefaults.standard.set(self.passwordHero.specialChars, forKey:Default.specialChars)

        if self.passwordHero.isSpeakable {
            self.passwordTextField.stringValue = self.passwordHero.createSpeakablePassword()
        } else {
            self.passwordTextField.stringValue = self.passwordHero.createPassword()
        }

        let strength = self.passwordHero.calculatePasswordStrength()
        self.passwordStrengthLevelIndicator.integerValue = strength
        self.strengthDescription.stringValue = {
            switch strength {
            case Int.min..<4:
                return NSLocalizedString("Unsecure", comment:"Unsecure")
            case 4..<6:
                return NSLocalizedString("OK for web accounts", comment:"OK for web accounts")
            case 6..<9:
                return NSLocalizedString("Save for private data", comment:"Save for private data")
            default:
                return NSLocalizedString("Save for confidential data", comment:"Save for confidential data")
            }
        }()
    }

    @IBAction private func optionCheckBoxClicked(_ sender: AnyObject) {
        self.passwordHero.hasNumbers = self.hasNumbersCheck.state == .on
        self.passwordHero.hasSpecialChars = self.hasSpecialCharsCheck.state == .on
        self.passwordHero.hasUpperCase = self.hasUpperCaseCheck.state == .on
        self.passwordHero.hasLowerCase = self.hasLowerCaseCheck.state == .on
        self.passwordHero.isSpeakable = self.isSpeakableCheck.state == .on

        if self.passwordHero.isSpeakable && !self.passwordHero.hasLowerCase && !self.passwordHero.hasUpperCase {
            self.hasLowerCaseCheck.state = .on
            self.passwordHero.hasLowerCase = true
        }

        var numberOfCheckedOptions = 0
        if self.passwordHero.hasLowerCase {numberOfCheckedOptions += 1}
        if self.passwordHero.hasUpperCase {numberOfCheckedOptions += 1}
        if self.passwordHero.hasSpecialChars {numberOfCheckedOptions += 1}
        if self.passwordHero.hasNumbers {numberOfCheckedOptions += 1}

        // enablement: prevent unchecking all
        if numberOfCheckedOptions < 2 {
            self.hasLowerCaseCheck.isEnabled = !self.passwordHero.hasLowerCase
            self.hasUpperCaseCheck.isEnabled = !self.passwordHero.hasUpperCase
            self.hasSpecialCharsCheck.isEnabled = !self.passwordHero.hasSpecialChars
            self.hasNumbersCheck.isEnabled = !self.passwordHero.hasNumbers
        } else {
            self.hasLowerCaseCheck.isEnabled = true
            self.hasUpperCaseCheck.isEnabled = true
            // me: either lower or upper case letter must always be checked, so disable the one if the other is unchecked
            self.hasLowerCaseCheck.isEnabled = self.passwordHero.hasUpperCase
            self.hasUpperCaseCheck.isEnabled = self.passwordHero.hasLowerCase
            self.hasNumbersCheck.isEnabled = true
            self.hasSpecialCharsCheck.isEnabled = true
        }
        self.specialCharsTextField.isEnabled = self.passwordHero.hasSpecialChars

        let defaults = UserDefaults.standard
        defaults.set(self.passwordHero.hasLowerCase, forKey:Default.hasLowerCase)
        defaults.set(self.passwordHero.hasNumbers, forKey:Default.hasNumbers)
        defaults.set(self.passwordHero.hasSpecialChars, forKey:Default.hasSpecialChars)
        defaults.set(self.passwordHero.hasUpperCase, forKey:Default.hasUpperCase)
        defaults.set(self.passwordHero.isSpeakable, forKey:Default.isSpeakable)
    }
    @IBAction private func setLength(_ sender: AnyObject) {
        self.passwordHero.passwordLength = self.passwordLengthStepper.integerValue
        self.passwordLengthTextField.integerValue = self.passwordHero.passwordLength
        UserDefaults.standard.set(self.passwordHero.passwordLength, forKey:Default.passwordLength)
    }
    @IBAction private func copyPasswordToClipboard(_ sender: AnyObject) {
        let password = passwordTextField.stringValue
        let pb = NSPasteboard.general
        pb.clearContents()
        pb.setString(password, forType: .string)
    }

    override func awakeFromNib() {
        self.doormanWindow.center()
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        let defaults = UserDefaults.standard
        defaults.register(defaults: [
            Default.hasLowerCase:true,
            Default.hasNumbers:true,
            Default.hasUpperCase:true,
            Default.hasSpecialChars:true,
            Default.specialChars:[String](),
            Default.isSpeakable:false,
            Default.passwordLength:12,
        ])

        self.passwordHero.hasLowerCase = defaults.bool(forKey:Default.hasLowerCase)
        self.passwordHero.hasNumbers = defaults.bool(forKey:Default.hasNumbers)
        self.passwordHero.hasSpecialChars = defaults.bool(forKey:Default.hasSpecialChars)
        self.passwordHero.hasUpperCase = defaults.bool(forKey:Default.hasUpperCase)
        self.passwordHero.specialChars = defaults.array(forKey:Default.specialChars) as! [String]
        self.passwordHero.isSpeakable = defaults.bool(forKey:Default.isSpeakable)
        let passwordLength = defaults.integer(forKey:Default.passwordLength)
        if passwordLength < 5 {
            self.passwordHero.passwordLength = 12
        } else {
            self.passwordHero.passwordLength = passwordLength
        }

        self.hasLowerCaseCheck.state = self.state(for:self.passwordHero.hasLowerCase)
        self.hasNumbersCheck.state = self.state(for:self.passwordHero.hasNumbers)
        self.hasSpecialCharsCheck.state =  self.state(for:self.passwordHero.hasSpecialChars)
        self.hasUpperCaseCheck.state = self.state(for:self.passwordHero.hasUpperCase)
        self.isSpeakableCheck.state = self.state(for:self.passwordHero.isSpeakable)

        self.specialCharsTextField.isEnabled = self.passwordHero.hasSpecialChars
        self.specialCharsTextField.stringValue = self.passwordHero.specialCharsAsString()

        self.passwordLengthStepper.intValue = Int32(passwordHero.passwordLength)
        self.passwordLengthTextField.intValue = Int32(passwordHero.passwordLength)

        self.optionCheckBoxClicked(self)
        self.createPasswordClicked(self)

        self.doormanWindow.endEditing(for: nil)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    private func state(for b:Bool) -> NSButton.StateValue {
        if b {
            return .on
        }
        return .off
    }

}
