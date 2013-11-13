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
#import "MYSPrivate.h"


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

+ (NSString *)descriptionOf:(id)object
{
    NSMutableSet *visited = [NSMutableSet new];
    return [[self descriptionOf:object visited:visited indent:0] copy];
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




#pragma mark - Private

+ (NSString *)descriptionOf:(id)object visited:(NSMutableSet *)visited indent:(NSUInteger)indent
{
    [visited addObject:object];

    MYSClass *klass         = [[MYSClass alloc] initWithClass:[object class]];
    NSMutableString *string = [NSMutableString new];

    [string appendString:[self newLineWithIndent:indent]];
    [string appendFormat:@"<%@ %p>", NSStringFromClass([object class]), (void *)object];

    for (MYSIvar *ivar in klass.ivars) {
//        if (ivar.type.type == MYSTypeTypeObject) {
            [string appendString:[self newLineWithIndent:indent]];
        [string appendFormat:@"%@ %@ : %p", ivar.type.typeName, ivar.name, (void *)ivar.offset];
//        }
    }

    return string;
}

+ (NSString *)newLineWithIndent:(NSUInteger)indent
{
    return [@"\n\n" stringByPaddingToLength:indent * 4 withString:@" " startingAtIndex:0];
}

@end
