//
//  MYSClass.m
//  MYSIntrospection
//
//  Created by Adam Kirk on 11/2/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MYSClass.h"
#import <objc/runtime.h>
#import "MYSRuntime.h"


@implementation MYSClass

- (id)initWithClass:(Class)klass
{
    self = [super init];
    if (self) {
        _klass = klass;
    }
    return self;
}



#pragma mark - Public

- (BOOL)addMethod:(MYSMethod *)method
{
    sel_registerName([method.name UTF8String]);
    return class_addMethod(_klass,
                           NSSelectorFromString(method.name),
                           method.implemenation,
                           method.types);
}

#pragma mark (getters)

- (NSArray *)properties
{
    NSMutableArray *properties  = [NSMutableArray new];
    unsigned int count          = 0;
    objc_property_t *props      = class_copyPropertyList(self.klass, &count);
    for (int i = 0; i < count; ++i) {
        objc_property_t p       = props[i];
        MYSProperty *property   = [[MYSProperty alloc] initWithObjCProperty:p];
        [properties addObject:property];
    }
    free(props);
    return properties;
}

- (NSArray *)ivars
{
    NSMutableArray *ivars   = [NSMutableArray new];
    unsigned int count      = 0;
    Ivar *ivs               = class_copyIvarList(self.klass, &count);
    for (int i = 0; i < count; ++i) {
        Ivar iv         = ivs[i];
        MYSIvar *ivar   = [[MYSIvar alloc] initWithObjCIvar:iv];
        [ivars addObject:ivar];
    }
    return ivars;
}


@end
