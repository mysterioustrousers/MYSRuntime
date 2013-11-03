//
//  MYSClass.h
//  MYSIntrospection
//
//  Created by Adam Kirk on 11/2/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

@class MYSMethod;


@interface MYSClass : NSObject

/**
 *  The primitive Class used to create this class wrapper.
 */
@property (nonatomic, assign, readonly) Class klass;

/**
 *  An on-demand list of current properties of the class. (array of MYSProperty objects).
 */
@property (nonatomic, strong, readonly) NSArray *properties;

/**
 *  Create an MYSClass object.
 *
 *  @param klass The `Class` opaque type you want to represent with this object.
 *
 *  @return An MYSClass object ready to be messed with.
 */
- (id)initWithClass:(Class)klass;

/**
 *  Adds a method to the class.
 *
 *  @param method An MYSMethod you're created with it's constructor methods.
 *
 *  @return YES if it was successfully added, NO if not (like if a method with that same name already exists.)
 */
- (BOOL)addMethod:(MYSMethod *)method;

@end
