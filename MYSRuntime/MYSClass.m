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

+ (NSString *)describe:(id)object
{
    NSMutableSet *visited = [NSMutableSet new];
    return [[self describe:object visited:visited indent:0] copy];
}


#pragma mark (getters)

- (NSArray *)properties
{
    NSMutableArray *properties  = [NSMutableArray new];
    unsigned int count          = 0;
    Class thisClass             = self.klass;
    while (thisClass) {
        objc_property_t *props = class_copyPropertyList(thisClass, &count);
        for (int i = 0; i < count; ++i) {
            objc_property_t p       = props[i];
            MYSProperty *property   = [[MYSProperty alloc] initWithObjCProperty:p];
            [properties addObject:property];
        }
        thisClass = [thisClass superclass];
    }
    return properties;
}

- (NSArray *)ivars
{
    NSMutableArray *ivars   = [NSMutableArray new];
    unsigned int count      = 0;
    Class thisClass         = self.klass;
    while (thisClass) {
        Ivar *ivs = class_copyIvarList(thisClass, &count);
        for (int i = 0; i < count; ++i) {
            Ivar iv         = ivs[i];
            MYSIvar *ivar   = [[MYSIvar alloc] initWithObjCIvar:iv];
            [ivars addObject:ivar];
        }
        thisClass = [thisClass superclass];
    }
    return ivars;
}




#pragma mark - Private

+ (NSString *)describe:(id)object visited:(NSMutableSet *)visited indent:(NSUInteger)indent
{
    if (indent > 2) return @"";
    if ([visited containsObject:object]) return @"🔙";
    [visited addObject:object];

    MYSClass *klass         = [[MYSClass alloc] initWithClass:[object class]];
    NSMutableString *string = [NSMutableString new];

    [string appendFormat:@"<%@ %p>", NSStringFromClass([object class]), (void *)object];
    [string appendString:[self newLineWithIndent:indent]];
    [string appendString:@"{"];

    NSArray *ivars              = klass.ivars;
    NSUInteger maxTypeLength    = [[ivars valueForKeyPath:@"@max.type.typeName.length"] intValue] + 1;
    NSUInteger maxNameLength    = [[ivars valueForKeyPath:@"@max.name.length"] intValue] + 1;
    for (MYSIvar *ivar in klass.ivars) {
        // leave out bitfields
        if (ivar.type.type == MYSTypeTypeBitfield) continue;

        [string appendString:[self newLineWithIndent:indent + 1]];
        [string appendFormat:@"%@", [ivar.type.typeName stringByPaddingToLength:maxTypeLength withString:@" " startingAtIndex:0]];
        [string appendFormat:@"%@", [ivar.name stringByPaddingToLength:maxNameLength withString:@" " startingAtIndex:0]];
        if (ivar.type.type == MYSTypeTypeObject) {
            id obj = object_getIvar(object, ivar.ivar);
            if (obj) {
                [string appendFormat:@": %@", [self describe:obj visited:visited indent:indent + 1]];
            }
            else {
                [string appendString:@": nil"];
            }
        }
        else {
            [string appendFormat:@"%@", [self stringForPrimitiveType:ivar.type object:object offset:ivar.offset indent:indent + 1]];
        }
    }

    [string appendString:[self newLineWithIndent:indent]];
    [string appendString:@"}"];

    return string;
}

+ (NSString *)newLineWithIndent:(NSUInteger)indent
{
    return [@"\n" stringByPaddingToLength:MAX(1, indent * 4) withString:@" " startingAtIndex:0];
}

+ (NSString *)stringForPrimitiveType:(MYSType *)type object:(id)object offset:(NSUInteger)offset indent:(NSUInteger)indent
{
    NSMutableString *string = [NSMutableString new];
    if (type.type == MYSTypeTypeStruct) {
        [string appendString:[self newLineWithIndent:indent]];
        [string appendFormat:@"{"];
        [string appendString:[self newLineWithIndent:indent + 1]];
        NSMutableArray *pairs = [NSMutableArray new];
        for (MYSTypePrimitiveMember *member in type.members) {
            if (member.type.type == MYSTypeTypeBitfield) continue;
            NSString *valueString = @"0";
            if (member.type.type == MYSTypeTypeStruct || member.type.type == MYSTypeTypeUnion) {
                valueString = [self stringForPrimitiveType:member.type object:object offset:offset + member.offset indent:indent + 1];
            }
            else {
                double *ptr = (void *)((NSUInteger)object + (char)offset);
                valueString = [NSString stringWithFormat:@"%f", *ptr];
            }
            [pairs addObject:[NSString stringWithFormat:@"(%@) %@ : %@", member.type.typeName, member.name, valueString]];
        }
        NSString *joinString = [NSString stringWithFormat:@", %@", [self newLineWithIndent:indent + 1]];
        [string appendString:[pairs componentsJoinedByString:joinString]];
        [string appendString:[self newLineWithIndent:indent]];
        [string appendFormat:@"}"];
    }
    return string;
}



@end
