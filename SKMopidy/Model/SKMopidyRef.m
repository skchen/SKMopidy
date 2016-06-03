//
//  SKMopidyRef.m
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/4/24.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKMopidyRef.h"

#import "SKMopidyModel_Protected.h"

static NSString * const kKeyRefType = @"type";
static NSString * const kValueRefTypeDirectory = @"directory";
static NSString * const kValueRefTypeAlbum = @"album";

@implementation SKMopidyRef

- (nonnull instancetype)initWithDictionary:(nonnull NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    
    NSString *typeString = [dictionary objectForKey:kKeyRefType];
    _type = [SKMopidyRef typeForString:typeString];
    
    return self;
}

+ (SKMopidyRefType)typeForString:(NSString *)typeString {
    if([typeString isEqualToString:kValueRefTypeDirectory]) {
        return SKMopidyRefDirectory;
    } else if([typeString isEqualToString:kValueRefTypeAlbum]) {
        return SKMopidyRefAlbum;
    }
    
    return SKMopidyRefUnknown;
}

- (NSDictionary *)dict {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[super dict]];
    
    [dict setObject:@(_type) forKey:kKeyRefType];
    
    return dict;
}

@end
