//
//  PasswordHero.h
//  doorman
//
//  Created by mrFridge on 23.06.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
// #import "Doorman-Swift.h"
// @class DMRandom;

@interface PasswordHero : NSObject {


	NSInteger passwordLength;
	BOOL hasLowerCase;
	BOOL hasNumbers;
	BOOL hasSpecialChars;
	BOOL hasUpperCase;
	BOOL isSpeakable;
    
    BOOL lastSyllableHasFirstConsonant;
    BOOL lastSyllableHasLastConsonant;
    NSInteger lastSyllableLength;

	
	NSArray* allSpecialChars;
	NSDictionary* leetDict;
	NSDictionary* upperForLowerCaseDict;
    
    NSArray* firstConsonants;
    NSArray* vowels;
    NSArray* lastConsonants;    
	NSArray* specialChars;
    // DMRandom* random;
    
	
}

@property (assign) NSInteger passwordLength;
@property (assign) BOOL hasLowerCase;
@property (assign) BOOL hasNumbers;
@property (assign) BOOL hasSpecialChars;
@property (assign) BOOL hasUpperCase;
@property (assign) BOOL isSpeakable;
@property (assign) CGFloat passwordsPerSecond;
@property (strong, nonatomic) NSArray<NSString*>* specialChars;
@property (nonatomic, strong) NSArray<NSString*>* lowerCaseLetters;
@property (nonatomic, strong) NSArray<NSString*>* upperCaseLetters;
@property (nonatomic, strong) NSArray<NSString*>* numbers;

-(NSString*) createPassword;
-(NSString*) createPasswordCandidate;

-(NSString*) createSpeakablePassword;
-(NSString*) createSpeakablePasswordCandidate;

-(NSString*) createSyllable;
-(NSString*) applyLeetSpeak:(NSString*) aString;

@end

