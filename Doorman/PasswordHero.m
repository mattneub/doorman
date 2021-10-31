//
//  PasswordHero.m
//  doorman
//
//  Created by mrFridge on 23.06.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PasswordHero.h"
#import "Doorman-Swift.h"
// #import "DMRandom.h"

@interface PasswordHero ()
@property (nonatomic, strong) DMRandom* randomNumberGenerator;
@end


@implementation PasswordHero

@synthesize passwordLength, hasUpperCase, hasLowerCase, hasNumbers, hasSpecialChars, isSpeakable, specialChars;

- (PasswordHero*) init {
	self = [super init];
    if (self) {
        
        self.passwordsPerSecond = 2.0 * pow(10, 9);
        NSLog(@"passwordManager > init > pps: %f", self.passwordsPerSecond);
        
        self.lowerCaseLetters = @[@"a", @"b",@"c", @"d",
                             @"e", @"f",@"g", @"h",@"i", @"j",@"k", @"l",
                             @"m", @"n",@"o", @"p",@"q", @"r",@"s", @"t",
                             @"u", @"v",@"w", @"x",@"y", @"z"];
        self.upperCaseLetters = @[@"A", @"B",@"C", @"D",
                             @"E", @"F",@"G", @"H",@"I", @"J",@"K", @"L",@"M", @"N",
                             @"O", @"P",@"Q", @"R",@"S", @"T",@"U", @"V",
                             @"W", @"X", @"Y",@"Z"];
        upperForLowerCaseDict = [NSDictionary dictionaryWithObjects:self.upperCaseLetters forKeys:self.lowerCaseLetters];
        self.numbers = @[@"1", @"2",@"3", @"4",@"5", @"6",
					@"7", @"8",@"9", @"0"];
		allSpecialChars = @[@"!", @"§", @"$", @"%",
                            @"&", @"/", @"(", @")", @"[", @"]", @"{", @"}",@"<", @">",
                            @"?", @"#", @"@",  @"=", @"-", @"_", @".", @",", @"+", @"*", @":"];
        self.leetDict = [NSDictionary dictionaryWithObjects:
                    @[@"3",@"0",@"!",@"4",@"5"] 
                                               forKeys:
                    @[@"e",@"o",@"i",@"a",@"s"]];
		self.specialChars = [NSMutableArray arrayWithArray:allSpecialChars];
        
        
        
        passwordLength = 12;
        hasLowerCase = YES;
        hasNumbers = YES;
        hasSpecialChars = NO;
        hasUpperCase = NO;
        isSpeakable = YES;
        self.lastSyllableHasLastConsonant = NO;
        self.lastSyllableHasFirstConsonant = NO;
        self.lastSyllableLength = 0;
        
        
        self.firstConsonants = @[@"b", @"c", @"d", @"f",
							@"g",@"h",@"j", @"k", @"l", @"m", @"n",@"o",@"p",
							@"qu", @"r",@"s", @"t",@"v", @"w", @"x",@"y", @"z",@"ch",
							@"b", @"c", @"d", @"f",
							@"g",@"h",@"j", @"k", @"l", @"m", @"n",@"o",@"p",
							@"qu", @"r",@"s", @"t",@"v", @"w", @"x", @"z",@"ch",
							@"sh", @"sc",@"sp", @"st",@"ph",@"squ", @"bh",@"dh",
							@"gh",@"kh",@"th", @"wh",@"h", @"bl",@"br",
							@"cl", @"cr",@"dr", @"tl",@"tr", @"gl", @"gr",@"kl",
							@"kr", @"pr",@"sl", @"tr",@"tl",@"vr",@"vl",
							@"wr", @"wl",@"xl", @"chr",@"chl",@"shr", @"shl",@"scl",
							@"scr", @"spl",@"spr", @"str",@"stl",@"phl",@"phr",
							@"thr", @"thl"];
        self.lastConsonants = @[@"b", @"c", @"d", @"f",
						   @"g",@"h", @"k", @"l", @"m", @"n",@"o",@"p",
						   @"qu", @"r",@"s", @"t",@"v", @"w", @"x", @"z",
						   @"b", @"c", @"d", @"f",
						   @"g",@"h",@"j", @"k", @"l", @"m", @"n",@"o",@"p",
						   @"qu", @"r",@"s", @"t",@"v", @"w", @"x", @"z",@"ch",
						   @"ch",@"sh",@"th", @"sp", @"st",
						   @"ll",@"rr",@"mm", @"nn", @"tt", @"ss", @"gh",@"ck"];
        self.vowels = @[@"a", @"e", @"i", @"o", @"u",
				   @"a", @"e", @"i", @"o", @"u", @"y",
				   @"ay", @"uy", @"oy", @"ei", @"ie", @"au", @"ou",@"ai", @"aa", @"ee", @"oo",
				   @"eu",@"eo",@"ui",@"uo",@"a", @"e", @"i", @"o", @"u"];
        
        
        
        self.randomNumberGenerator = [[DMRandom alloc] init];
    }
	return self;
}






/*!
 @abstract Gibt ein aussprechbares Passwort zurück.
 @discussion erzeugt so lange silben bis die länge stimmt. zwischen den silben werden sonderzeichen eingefügt
 @updated 2009-08-08 gaby & anna
 */
-(NSString* _Nonnull) createSpeakablePasswordCandidate{
    NSMutableString* speakablePassword = [NSMutableString stringWithCapacity:passwordLength];
    
    //am anfang kann auch sonderzeichen oder zahl stehen
    CGFloat numberOrSpecialProbability = [self.randomNumberGenerator randomFloatBetween:0 and:1];
    if (hasNumbers && (numberOrSpecialProbability > 0.6)) {
        NSString* randomNumber = self.numbers[[self.randomNumberGenerator randomIntBetween:0 and:[self.numbers count]-1]];
        [speakablePassword appendString: randomNumber];
    } else if (hasSpecialChars && (numberOrSpecialProbability < 0.3)) {
        NSString* randomSpecial = specialChars[[self.randomNumberGenerator randomIntBetween:0 and:[specialChars count]-1]];
        [speakablePassword appendString: randomSpecial];
    }
    
    //silben erzeugen mit evtl zahl oder sonderzeichen am ende
    while ([speakablePassword length] < passwordLength) {
        [speakablePassword appendString:[self createSyllable]];
        
        CGFloat numberOrSpecialProbability = [self.randomNumberGenerator randomFloatBetween:0 and:1];
        if (hasNumbers && (numberOrSpecialProbability > 0.6)) {
            NSString* randomNumber = self.numbers[[self.randomNumberGenerator randomIntBetween:0 and:[self.numbers count]-1]];
            [speakablePassword appendString: randomNumber];
        } else if (hasSpecialChars && (numberOrSpecialProbability < 0.3)) {
            NSString* randomSpecial = specialChars[[self.randomNumberGenerator randomIntBetween:0 and:[specialChars count]-1]];
            [speakablePassword appendString: randomSpecial];
        }
    }
    
    //wenn zu lang rekursiv selbst aufrufen
    if([speakablePassword length] > passwordLength){
        speakablePassword = [NSMutableString stringWithString:[self createSpeakablePasswordCandidate]];
    }
    
    if (self.hasLowerCase && self.hasUpperCase) {
        
        for (NSInteger i = 0; i < passwordLength; i++) {
            NSString* charAtI = [speakablePassword substringWithRange:NSMakeRange(i, 1)];
            NSString* caseReplacement = upperForLowerCaseDict[charAtI];
            if (caseReplacement) {
                CGFloat replaceProbability = [self.randomNumberGenerator randomFloatBetween:0 and:1];
                if (replaceProbability > 0.8) {
                    [speakablePassword replaceCharactersInRange:NSMakeRange(i, 1) withString: caseReplacement];
                }
            }
        }
    } else if (self.hasUpperCase && NO == self.hasLowerCase) {
        speakablePassword = [NSMutableString stringWithString:[speakablePassword uppercaseString]];
    }
    
    
    return speakablePassword;
}

-(void) setSpecialChars:(NSArray *)theCharsArray {
    if (theCharsArray == nil || [theCharsArray count] == 0) {
        specialChars = [NSMutableArray arrayWithArray:allSpecialChars];
    } else {
        specialChars = theCharsArray;
    }
}


@end
