#import "Converter.h"

// Do not change
NSString *KeyPhoneNumber = @"phoneNumber";
NSString *KeyCountry = @"country";

@interface CountryInfo : NSObject
@property (nonatomic, assign) int length;
@property (nonatomic, strong) NSString *countryCode;
@property (nonatomic, strong) NSString *country;

- (instancetype) initWithCountry: (NSString*)country countryCode:(NSString*)code andPhoneLenght:(int)lenght;

@end
@implementation CountryInfo
- (instancetype) initWithCountry: (NSString*)country countryCode:(NSString*)code andPhoneLenght:(int)phoneLenght {
    if (self = [super init]) {
        self.length = phoneLenght;
        self.countryCode = code;
        self.country = country;
    }
    return self;
}

@end

@implementation PNConverter

- (NSDictionary*)converToPhoneNumberNextString:(NSString*)string; {
    if ([string hasPrefix:@"+"]) {
        string = [string substringFromIndex:1];
    }
    NSArray *data = [[NSArray alloc] initWithObjects: [[CountryInfo alloc] initWithCountry:@"KZ" countryCode:@"77" andPhoneLenght:10],
                     [[CountryInfo alloc] initWithCountry:@"RU" countryCode:@"7" andPhoneLenght:10],
                     [[CountryInfo alloc] initWithCountry:@"MD" countryCode:@"373" andPhoneLenght:8],
                     [[CountryInfo alloc] initWithCountry:@"AM" countryCode:@"374" andPhoneLenght:8],
                     [[CountryInfo alloc] initWithCountry:@"BY" countryCode:@"375" andPhoneLenght:9],
                     [[CountryInfo alloc] initWithCountry:@"UA" countryCode:@"380" andPhoneLenght:9],
                     [[CountryInfo alloc] initWithCountry:@"TJ" countryCode:@"992" andPhoneLenght:9],
                     [[CountryInfo alloc] initWithCountry:@"TM" countryCode:@"993" andPhoneLenght:8],
                     [[CountryInfo alloc] initWithCountry:@"AZ" countryCode:@"994" andPhoneLenght:9],
                     [[CountryInfo alloc] initWithCountry:@"KG" countryCode:@"996" andPhoneLenght:9],
                     [[CountryInfo alloc] initWithCountry:@"UZ" countryCode:@"998" andPhoneLenght:9], nil];
    
    NSString *codeResult = @"";
    NSMutableString *result = [[NSMutableString alloc] initWithString:string];
    
    for (CountryInfo* d in data) {
        if ([string hasPrefix:d.countryCode]) {
            codeResult = d.country;
            if (d.length == 8 || d.length == 9) {
                if ([result length] > 3) {
                    [result insertString:@" (" atIndex:3];
                }
                if ([result length] > 7) {
                    [result insertString:@") " atIndex:7];
                }
                if ([result length] > 12) {
                    [result insertString:@"-" atIndex:12];
                }
                if (d.length == 8 && [result length] > 15) {
                    [result substringToIndex:15];
                }
                if (d.length == 8 && [result length] > 17) {
                    NSString *ab = [result substringToIndex:16];
                    result = [NSMutableString stringWithString:ab];
                    break;
                }
                if (d.length == 9 && [result length] > 15) {
                    [result insertString:@"-" atIndex:15];
                }
                if (d.length == 9 && [result length] > 18) {
                    NSString *ab = [result substringToIndex:18];
                    result = [NSMutableString stringWithString:ab];
                    break;
                }
                
            } else if (d.length == 10) {
                if ([result length] > 1) {
                    [result insertString:@" (" atIndex:1];
                }
                if ([result length] > 6) {
                    [result insertString:@") " atIndex:6];
                }
                if ([result length] > 11) {
                    [result insertString:@"-" atIndex:11];
                }
                if ([result length] > 14) {
                    [result insertString:@"-" atIndex:14];
                }
                if  ([result length] > 18) {
                    NSString *ab = [result substringToIndex:17];
                    result = [NSMutableString stringWithString:ab];
                    break;
                } else {
                    break;
                }
            }
        }
    }
    
    if ([codeResult  isEqual: @""] && [result length] > 13) {
        NSString *ab = [result substringToIndex:12];
        result = [NSMutableString stringWithString:ab];
    }
    [result insertString:@"+" atIndex:0];
    return @{KeyPhoneNumber: result,
             KeyCountry: codeResult};
}
@end

