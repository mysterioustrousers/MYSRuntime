//
//  MYSMethod.h
//  MYSRuntime
//
//  Created by Adam Kirk on 11/2/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MYSTypes.h"


@interface MYSMethod : NSObject

/**
 *  The name of the method used when creating the method.
 */
@property (nonatomic, strong, readonly) NSString *name;

/**
 *  The implementation of the method. This will be created from the block passed in on init if that initializer is used.
 */
@property (nonatomic, assign, readonly) IMP implemenation;

/**
 *  The encoded types of the method. The format is [<return type>, '@', ':', <first argument type>, ...]
 *  e.g. `v@:@@`: this is a void return type with two arguments of type object.
 */
@property (nonatomic, assign, readonly) const char *types;

/**
 *  Create a new MYSMethod object with `name` and the implementation of the passed in block.
 *
 *  @param name               The name of the method (format: `name:of:method:with:params:`
 *  @param implemenationBlock The first parameter of `implementationBlock` must be `id self`. All other arguments 
 *                            after that must correspond to each colon in the method name. So if you had a method 
 *                            name of "setName:age:", the arguments would be (id self, NSString *name, NSInteger age). 
 *                            Take a look in `MYSClassTests` for examples. The return type and arguments will all
 *                            be inferred from the block.
 *
 *  @return A new MYSMethod object.
 */
- (id)initWithName:(NSString *)name implementationBlock:(id)implemenationBlock;

@end
