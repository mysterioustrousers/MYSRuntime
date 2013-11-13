//
//  MYSProperty.m
//  MYSIntrospection
//
//  Created by Adam Kirk on 11/2/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MYSRuntime.h"


@implementation MYSProperty

- (id)initWithObjCProperty:(objc_property_t)property
{
    self = [super init];
    if (self) {

        _propertyAttributesString       = [[NSString stringWithUTF8String:property_getAttributes(property)] copy];
        _name                           = [[NSString stringWithUTF8String:property_getName(property)] copy];

        // defaults
        _storageType                    = MYSPropertyStorageTypeAssign;
        _isReadOnly                     = NO;
        _isNonAtomic                    = NO;
        _isDynamic                      = NO;
        _isElegibleForGarbageCollection = NO;


        NSArray *flags = [_propertyAttributesString componentsSeparatedByString:@","];

        for (NSString *flag in flags) {

            // type
            if ([flag hasPrefix:@"T"]) {
                _type = [[MYSType alloc] initWithEncodingString:[flag substringFromIndex:1]];
            }

            // readonly
            if ([flag hasPrefix:@"R"]) {
                _isReadOnly = YES;
            }

            // copy
            if ([flag hasPrefix:@"C"]) {
                _storageType = MYSPropertyStorageTypeCopy;
            }

            // strong/retain
            if ([flag hasPrefix:@"&"]) {
                _storageType = MYSPropertyStorageTypeStrong;
            }

            // weak
            if ([flag hasPrefix:@"W"]) {
                _storageType = MYSPropertyStorageTypeWeak;
            }

            // atomicocity
            if ([flag hasPrefix:@"N"]) {
                _isNonAtomic = YES;;
            }

            // custom getter
            if ([flag hasPrefix:@"G"]) {
                _getter = [flag substringFromIndex:1];
            }

            // custom setter
            if ([flag hasPrefix:@"S"]) {
                _setter = [flag substringFromIndex:1];
            }

            // dynamic
            if ([flag hasPrefix:@"D"]) {
                _isDynamic = YES;
            }

            // gc
            if ([flag hasPrefix:@"P"]) {
                _isElegibleForGarbageCollection = YES;
            }
            
        }

        if ([_getter length] == 0) {
            _getter = _name;
        }

        if ([_setter length] == 0) {
            NSString *capitalized = [_name stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                     withString:[[_name substringToIndex:1] capitalizedString]];
            _setter = [NSString stringWithFormat:@"set%@:", capitalized];
        }
    }
    return self;
}

@end
