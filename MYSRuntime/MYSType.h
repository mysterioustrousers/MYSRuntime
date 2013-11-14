//
//  MYSType.h
//  MYSRuntime
//
//  Created by Adam Kirk on 11/12/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MYSType;


typedef NS_ENUM(NSUInteger, MYSTypeType) {
    MYSTypeTypeChar             = 'c',
    MYSTypeTypeBool             = 'B',
    MYSTypeTypeShort            = 's',
    MYSTypeTypeInt              = 'i',
    MYSTypeTypeLong             = 'l',
    MYSTypeTypeLongLong         = 'q',
    MYSTypeTypeUnsignedChar     = 'C',
    MYSTypeTypeUnsignedShort    = 'S',
    MYSTypeTypeUnsignedInt      = 'I',
    MYSTypeTypeUnsignedLong     = 'L',
    MYSTypeTypeUnsignedLongLong = 'Q',
    MYSTypeTypeFloat            = 'f',
    MYSTypeTypeDouble           = 'd',
    MYSTypeTypeObject           = '@',
    MYSTypeTypeStruct           = '{',
    MYSTypeTypeUnion            = '(',
    MYSTypeTypeArray            = '[',
    MYSTypeTypeVoid             = 'v',
    MYSTypeTypeCString          = '*',
    MYSTypeTypeClass            = '#',
    MYSTypeTypeSelector         = ':',
    MYSTypeTypeBitfield         = 'b',
    MYSTypeTypeUnkown           = '?'
};




@interface MYSTypePrimitiveMember : NSObject

/**
 *  The name of the member. If you have a CGPoint struct, the names of the members would be 'x' and 'y'.
 *  May be nil if the type is a pointer to a struct, in which case members only have types.
 */
@property (nonatomic, strong, readonly) NSString *name;

/**
 *  The type of the member. If you have a CGPoint struct, the types for 'x' and 'y' would both be float.
 */
@property (nonatomic, strong, readonly) MYSType  *type;

/**
 *  The memory offest in bytes within the enclosing type.
 */
@property (nonatomic, assign, readonly) ptrdiff_t offset;

@end




@interface MYSType : NSObject

- (id)initWithEncodingString:(NSString *)encodingString;

/**
 *  The general type.
 */
@property (nonatomic, assign, readonly) MYSTypeType type;

/**
 *  Returns the actual size in bytes of the type.
 */
@property (nonatomic, assign, readonly) NSUInteger size;

/**
 *  How many pointers this has. Objects types are implicit pointers, so they have a count of 0.
 *  (e.g. (NSInteger *) = 1, (NSError **) = 1, (CGRect **) = 2;
 */
@property (nonatomic, assign, readonly) NSUInteger pointerCount;

/**
 *  The printable name of the this type. (e.g. char, int, object)
 */
@property (nonatomic, copy, readonly) NSString *typeName;

/**
 *  If this is a struct or union, this will contain the tag. 
 *  If this is a foundation object, it will contain the name of the foundation object.
 *  If the object is of type `id` this will contain "id".
 */
@property (nonatomic, copy, readonly) NSString *tag;

/**
 *  If the type is an array, this contains the size of the array.
 *  Any other type this property is 0.
 */
@property (nonatomic, assign, readonly) NSUInteger arraySize;

/**
 *  If the type is array, this will contain the type of the objects in the array. (meaning C arrays)
 *  Any other type this property is nil.
 */
@property (nonatomic, strong, readonly) MYSType *arrayType;

/**
 *  If the type is a struct or union, this will contain all the members of the struct or union, with their names
 *  and types (as MYSTypePrimitiveMember objects).
 */
@property (nonatomic, copy, readonly) NSArray *members;

/**
 *  The original encoding string provided by the runtime.
 */
@property (nonatomic, copy, readonly) NSString *encodingString;

@end

