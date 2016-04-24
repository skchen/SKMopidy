//
//  SKMopidyRef.m
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/4/24.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKMopidyRef.h"

static NSString const * kKeyRefType = @"type";
static NSString const * kValueRefTypeDirectory = @"directory";
static NSString const * kKeyRefName = @"name";
static NSString const * kKeyRefUri = @"uri";

@implementation SKMopidyRef

- (nonnull instancetype)initWithDictionary:(nonnull NSDictionary *)dictionary {
    self = [super init];
    
    _name = [dictionary objectForKey:kKeyRefName];
    
    NSString *typeString = [dictionary objectForKey:kKeyRefType];
    _type = [SKMopidyRef typeForString:typeString];
    
    _uri = [dictionary objectForKey:kKeyRefUri];
    
    return self;
}

+ (SKMopidyRefType)typeForString:(NSString *)typeString {
    if([typeString isEqualToString:kValueRefTypeDirectory]) {
        return SKMopidyRefDirectory;
    }
    
    return SKMopidyRefUnknown;
}

- (NSDictionary *)dict {
    return @{kKeyRefName:_name, kKeyRefType:@(_type), kKeyRefUri:_uri};
}

- (NSString *)description {
    return [[self dict] description];
}

@end
