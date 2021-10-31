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

    @IBAction func createPasswordClicked(_ sender: AnyObject) {}
    @IBAction func optionCheckBoxClicked(_ sender: AnyObject) {}
    @IBAction func checkForUpdate(_ sender: AnyObject) {}
    @IBAction func setLength(_ sender: AnyObject) {
        self.passwordHero.passwordLength = self.passwordLengthStepper.integerValue
        self.passwordLengthTextField.integerValue = self.passwordHero.passwordLength
        UserDefaults.standard.set(self.passwordHero.passwordLength, forKey:"passwordLength")
    }
    @IBAction func addToFavorites(_ sender: AnyObject) {}
    @IBAction func copyPasswordToClipboard(_ sender: AnyObject) {}

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

        createPasswordClicked(self)

        
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
//    - (NSCellStateValue) stateFor:(bool) b {
//        if (b) {
//            return NSOnState;
//        }
//        return NSOffState;
//    }


}
