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

@property (nonatomic, strong, readonly) NSString *name;

@property (nonatomic, strong, readonly) MYSType *type;

- (id)initWithObjCIvar:(Ivar)ivar;

@end
