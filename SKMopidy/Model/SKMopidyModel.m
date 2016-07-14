//
//  SKMopidyModel.m
//  SKMopidy
//
//  Created by Shin-Kai Chen on 2016/4/24.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKMopidyModel.h"

static NSString const * kKeyModel = @"__model__";
static NSString const * kModelPrefix = @"SKMopidy";

static NSString const * kKeyRefName = @"name";
static NSString const * kKeyRefUri = @"uri";

@implementation SKMopidyModel

+ (nullable instancetype)modelWithDictionary:(nonnull NSDictionary *)dictionary {
    
    NSLog(@"Dictionary: %@", dictionary);
    
    NSString *model = [dictionary objectForKey:kKeyModel];
    if(model) {
        NSString *className = [NSString stringWithFormat:@"%@%@", kModelPrefix, model];
        Class class = NSClassFromString(className);
        return [[class alloc] initWithDictionary:dictionary];
    }
    
    return nil;
}

+ (nullable id)format:(nonnull id)original {
    if([original isKindOfClass:[NSDictionary class]]) {
        id formated = [SKMopidyModel modelWithDictionary:original];
        return formated;
    } else if([original isKindOfClass:[NSArray class]]) {
        NSMutableArray *formatedArray = [[NSMutableArray alloc] init];
        for(id element in original) {
            id formated = [SKMopidyModel format:element];
            if(formated) {
                [formatedArray addObject:formated];
            }
        }
        return formatedArray;
    } else if([original isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    return original;
}

- (nonnull instancetype)initWithDictionary:(nonnull NSDictionary *)dictionary {
    self = [super init];
    
    _name = [dictionary objectForKey:kKeyRefName];
    _uri = [dictionary objectForKey:kKeyRefUri];
    
    return self;
}

- (NSDictionary *)dict {
    return @{kKeyRefName:_name, kKeyRefUri:_uri};
}

- (NSString *)description {
    return [[self dict] description];
}

@end
