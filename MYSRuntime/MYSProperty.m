//
//  MYSProperty.m
//  MYSIntrospection
//
//  Created by Adam Kirk on 11/2/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MYSProperty.h"


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
                NSString *typeFlag = [flag substringWithRange:NSMakeRange(1, 1)];
                unichar c = [typeFlag characterAtIndex:0];
                _type = (MYSType)c;
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
            _setter = [NSString stringWithFormat:@"set%@:", [_name capitalizedString]];
        }
    }
    return self;
}

@end
