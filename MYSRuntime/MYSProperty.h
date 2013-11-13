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
 *  The MYSClass this property belongs to.
 */
@property (nonatomic, weak, readonly) MYSClass *klass;

/**
 *  Once you create an MYSProperty with this designated initializer, it cannot be changed.
 *
 *  @param ivar  The primitive opaque type to create the property from.
 *  @param klass can be either a Class or an MYSClass object.
 *
 *  @return An MYSProperty populated with values from `initWithObjCProperty:`.
 */
- (id)initWithObjCProperty:(objc_property_t)property;


@end
