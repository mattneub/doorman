//
//  AppController.swift
//  Doorman
//
//  Created by Matt Neuburg on 10/31/21.
//

import AppKit

@objc class AppController : NSObject, NSApplicationDelegate, NSWindowDelegate {
    @IBOutlet var doormanWindow: NSWindow!
    // @IBOutlet var NSDrawer* favoritePasswordsDrawer;
    // @IBOutlet var NSTableView* favoritesTableView;

    @IBOutlet weak var hasLowerCaseCheck : NSButton!
    @IBOutlet weak var hasNumbersCheck : NSButton!
    @IBOutlet weak var hasSpecialCharsCheck : NSButton!
    @IBOutlet weak var hasUpperCaseCheck : NSButton!
    @IBOutlet weak var isSpeakableCheck : NSButton!
    @IBOutlet weak var favoriteButton : NSButton!

    @IBOutlet weak var copyButton : NSButton!

    @IBOutlet weak var passwordLengthTextField : NSTextField!
    @IBOutlet weak var specialCharsTextField : NSTextField!
    @IBOutlet weak var passwordTextField : NSTextField!
    @IBOutlet weak var strengthDescription : NSTextField!

    @IBOutlet weak var passwordLengthStepper : NSStepper!

    @IBOutlet weak var passwordStrengthLevelIndicator : NSLevelIndicator!

    @IBOutlet weak var favoritesOverlayImage : NSImageView!
    @IBOutlet weak var doormanMenu : NSMenu!
    @IBOutlet weak var updateMenuItem : NSMenuItem!

    @IBAction func createPasswordClicked(_ sender: AnyObject) {
        self.copyButton.isEnabled = true

        let specials = self.specialCharsTextField.stringValue
        self.passwordHero.setSpecialCharsAsString(specials)
        if specials.count == 0 {
            self.specialCharsTextField.stringValue = self.passwordHero.specialCharsAsString()
            self.hasSpecialCharsCheck.state = .off
            self.optionCheckBoxClicked(self)
        }

        UserDefaults.standard.set(self.passwordHero.specialChars, forKey:"specialCharacters")

        if self.passwordHero.isSpeakable {
            self.passwordTextField.stringValue = self.passwordHero.createSpeakablePassword()
        } else {
            self.passwordTextField.stringValue = self.passwordHero.createPassword()
        }

        let strength = self.passwordHero.calculatePasswordStrength()
        self.passwordStrengthLevelIndicator.integerValue = strength

        if (strength < 4) {
            self.strengthDescription.stringValue = NSLocalizedString("Unsecure", comment:"Unsecure")
        } else if (strength < 6) {
            self.strengthDescription.stringValue = NSLocalizedString("OK for web accounts", comment:"OK for web accounts")
        }  else  if (strength < 9) {
            self.strengthDescription.stringValue = NSLocalizedString("Safe for private data", comment:"Safe for private data")
        }  else {
            self.strengthDescription.stringValue = NSLocalizedString("Safe for confidential data", comment:"Safe for confidential data")
        }

//        self.favoriteButton.image = NSImage(named:"star_white")
//        self.favoritesTableView.deselectAll(self)

    }
    @IBAction func optionCheckBoxClicked(_ sender: AnyObject) {
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

        if numberOfCheckedOptions < 2 {
            self.hasLowerCaseCheck.isEnabled = self.passwordHero.hasLowerCase
            self.hasUpperCaseCheck.isEnabled = self.passwordHero.hasUpperCase
            self.hasSpecialCharsCheck.isEnabled = self.passwordHero.hasSpecialChars
            self.hasNumbersCheck.isEnabled = self.passwordHero.hasNumbers
        } else {
            self.hasLowerCaseCheck.isEnabled = true
            self.hasUpperCaseCheck.isEnabled = true
            if self.passwordHero.isSpeakable {
                self.hasLowerCaseCheck.isEnabled = self.passwordHero.hasUpperCase
                self.hasUpperCaseCheck.isEnabled = self.passwordHero.hasLowerCase
            }
            self.hasNumbersCheck.isEnabled = true
            self.hasSpecialCharsCheck.isEnabled = true
        }

        self.specialCharsTextField.isEnabled = self.passwordHero.hasSpecialChars

        //in preferences speichern
        let defaults = UserDefaults.standard
        defaults.set(self.passwordHero.hasLowerCase, forKey:"hasLowerCase")
        defaults.set(self.passwordHero.hasNumbers, forKey:"hasNumbers")
        defaults.set(self.passwordHero.hasSpecialChars, forKey:"hasSpecialChars")
        defaults.set(self.passwordHero.hasUpperCase, forKey:"hasUpperCase")
        defaults.set(self.passwordHero.isSpeakable, forKey:"isSpeakable")

    }
    @IBAction func checkForUpdate(_ sender: AnyObject) {}
    @IBAction func setLength(_ sender: AnyObject) {
        self.passwordHero.passwordLength = self.passwordLengthStepper.integerValue
        self.passwordLengthTextField.integerValue = self.passwordHero.passwordLength
        UserDefaults.standard.set(self.passwordHero.passwordLength, forKey:"passwordLength")
    }
    @IBAction func addToFavorites(_ sender: AnyObject) {}
    @IBAction func copyPasswordToClipboard(_ sender: AnyObject) {
        let password = passwordTextField.stringValue
        let pb = NSPasteboard.general
        pb.clearContents()
        pb.setString(password, forType: .string)
    }

    let passwordHero = PasswordHero()

    override func awakeFromNib() {
        self.doormanWindow.center()
        self.doormanMenu.removeItem(self.updateMenuItem)
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        let defaults = UserDefaults.standard
        var isFirstStart = !defaults.bool(forKey: "isNotFirstStart")
        if isFirstStart {
            isFirstStart = false
            defaults.set(!isFirstStart, forKey: "isNotFirstStart")
        } else {
            self.passwordHero.hasLowerCase = defaults.bool(forKey:"hasLowerCase")
            self.passwordHero.hasNumbers = defaults.bool(forKey:"hasNumbers")
            self.passwordHero.hasSpecialChars = defaults.bool(forKey:"hasSpecialChars")
            self.passwordHero.hasUpperCase = defaults.bool(forKey:"hasUpperCase")
            self.passwordHero.specialChars = defaults.array(forKey:"specialCharacters") as! [String]
            self.passwordHero.isSpeakable = defaults.bool(forKey:"isSpeakable")
        }
        let passwordLength = defaults.integer(forKey:"passwordLength")
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
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    func state(for b:Bool) -> NSButton.StateValue {
        if b {
            return .on
        }
        return .off
    }

}
