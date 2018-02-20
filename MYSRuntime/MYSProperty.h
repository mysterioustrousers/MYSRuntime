//
//  MYSProperty.h
//  MYSIntrospection
//
//  Created by Adam Kirk on 11/2/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import <objc/runtime.h>


@class MYSType;
@class MYSIvar;


typedef NS_ENUM(NSUInteger, MYSPropertyStorageType) {
    MYSPropertyStorageTypeAssign,
    MYSPropertyStorageTypeCopy,
    MYSPropertyStorageTypeStrong,
    MYSPropertyStorageTypeWeak
};


@interface MYSProperty : NSObject

@property (nonatomic, assign, readonly) objc_property_t        property;
@property (nonatomic, copy,   readonly) NSString               *name;
@property (nonatomic, strong, readonly) MYSType                *type;
@property (nonatomic, strong, readonly) NSString               *ivarName;
@property (nonatomic, assign, readonly) BOOL                   isReadOnly;
@property (nonatomic, assign, readonly) MYSPropertyStorageType storageType;
@property (nonatomic, assign, readonly) BOOL                   isNonAtomic;
@property (nonatomic, copy,   readonly) NSString               *getter;
@property (nonatomic, copy,   readonly) NSString               *setter;
@property (nonatomic, assign, readonly) BOOL                   isDynamic;
@property (nonatomic, assign, readonly) BOOL                   isElegibleForGarbageCollection;
@property (nonatomic, copy,   readonly) NSString               *propertyAttributesString;

/**
 *  Once you create an MYSProperty with this designated initializer, it cannot be changed.
 *
 *  @return An MYSProperty populated with values from `initWithObjCProperty:`.
 */
- (instancetype)initWithObjCProperty:(objc_property_t)property;

/**
 * Create an MYSProperty from a class and property name.
 *
 * @param name  The name of the property.
 * @return An MYSProperty for `class` with `name`.
*/
- (instancetype)initWithClass:(Class)klass name:(NSString *)name;

@end
