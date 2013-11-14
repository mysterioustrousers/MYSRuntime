//
//  MYSIvar.h
//  MYSRuntime
//
//  Created by Adam Kirk on 11/12/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>


@class MYSType;


@interface MYSIvar : NSObject

/**
 *  The name of this ivar.
 */
@property (nonatomic, strong, readonly) NSString *name;

/**
 *  The type of this ivar.
 */
@property (nonatomic, strong, readonly) MYSType *type;

/**
 *  The objc runtime Ivar type that was used to create this ivar.
 */
@property (nonatomic, assign, readonly) Ivar ivar;

/**
 *  Returns the offset in the class (and thus instances of that class) of the 
 *  data of this instance variable in memory.
 */
@property (nonatomic, assign, readonly) ptrdiff_t offset;

/**
 *  Used to create an MYSIvar from an objc Ivar type.
 *
 *  @param ivar  an objc Ivar
 *
 *  @return an MYSIvar object.
 */
- (id)initWithObjCIvar:(Ivar)ivar;


@end
