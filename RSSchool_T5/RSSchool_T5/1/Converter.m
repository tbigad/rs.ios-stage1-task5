#import "Converter.h"

// Do not change
NSString *KeyPhoneNumber = @"phoneNumber";
NSString *KeyCountry = @"country";

@interface CountryInfo : NSObject
@property (nonatomic, strong) NSNumber *length;
@property (nonatomic, strong) NSString *countryCode;
@property (nonatomic, strong) NSString *country;

- (instancetype) initWithCountry: (NSString*)country countryCode:(NSString*)code andPhoneLenght:(NSNumber *)lenght;

@end
@implementation CountryInfo
- (instancetype) initWithCountry: (NSString*)country countryCode:(NSString*)code andPhoneLenght:(NSNumber *)phoneLenght {
    if (self = [super init]) {
        _length = phoneLenght;
        _countryCode = code;
        _country = country;
    }
    return self;
}

@end

@implementation PNConverter

- (NSDictionary*)converToPhoneNumberNextString:(NSString*)string; {
    NSArray *data = [[NSArray alloc] initWithObjects: [[CountryInfo alloc] initWithCountry:@"KZ" countryCode:@"77" andPhoneLenght:@10],
                     [[CountryInfo alloc] initWithCountry:@"RU" countryCode:@"7" andPhoneLenght:@10],
                     [[CountryInfo alloc] initWithCountry:@"MD" countryCode:@"373" andPhoneLenght:@8],
                     [[CountryInfo alloc] initWithCountry:@"AM" countryCode:@"374" andPhoneLenght:@8],
                     [[CountryInfo alloc] initWithCountry:@"BY" countryCode:@"375" andPhoneLenght:@9],
                     [[CountryInfo alloc] initWithCountry:@"UA" countryCode:@"380" andPhoneLenght:@9],
                     [[CountryInfo alloc] initWithCountry:@"TJ" countryCode:@"992" andPhoneLenght:@9],
                     [[CountryInfo alloc] initWithCountry:@"TM" countryCode:@"993" andPhoneLenght:@8],
                     [[CountryInfo alloc] initWithCountry:@"AZ" countryCode:@"994" andPhoneLenght:@9],
                     [[CountryInfo alloc] initWithCountry:@"KG" countryCode:@"996" andPhoneLenght:@9],
                     [[CountryInfo alloc] initWithCountry:@"UZ" countryCode:@"998" andPhoneLenght:@9], nil];
    
    NSString *codeResult = @"";
    NSString *result = [string stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    for (CountryInfo* d in data) {
        if ([result hasPrefix:d.countryCode]) {
            codeResult = d.country;
            NSDictionary *formats = @{
                @10 : @"x (xxx) xxx-xx-xx", //10
                @9 : @"xxx (xx) xxx-xx-xx", //9
                @8 : @"xxx (xx) xxx-xxx", //8
            };
            
            NSString *requiredFormat = [formats objectForKey:d.length];
            NSMutableString *replacedString = [[NSMutableString alloc] initWithString:requiredFormat];
            for (NSInteger i = 0; i < string.length; i++)
            {
                NSRange rangeFound = [replacedString rangeOfString:@"x"];
                if (NSNotFound != rangeFound.location) {
                    NSString* replace = [string substringWithRange:NSMakeRange(i, 1)];
                    [replacedString replaceCharactersInRange:rangeFound withString:replace];
                }
            }
            
            NSString *match = @"x";
            NSString *preMatch;

            NSScanner *scanner = [NSScanner scannerWithString:replacedString];
            [scanner scanUpToString:match intoString:&preMatch];
            
            NSCharacterSet *chset = [NSCharacterSet characterSetWithCharactersInString:@")(- "];
            
            result = [preMatch stringByTrimmingCharactersInSet:chset];
            break;
        }
    }
    
    if ([codeResult  isEqual: @""] && [result length] > 13) {
        result = [NSMutableString stringWithString:[result substringToIndex:12]];
    }
    NSString *ret = [[NSString alloc] initWithFormat:@"+%@", result];
    return @{KeyPhoneNumber: ret,
             KeyCountry: codeResult};
}
@end

