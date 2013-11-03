//
//  MYSMethod.m
//  MYSRuntime
//
//  Created by Adam Kirk on 11/2/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MYSRuntime.h"
#import <objc/runtime.h>
#import "CTBlockDescription.h"


@interface MYSMethod ()
@property (nonatomic, strong, readonly) NSMethodSignature *signature;
@end


@implementation MYSMethod

- (id)initWithName:(NSString *)name implementationBlock:(id)implemenationBlock;
{
    self = [super init];
    if (self) {
        _name = name;
        [self populateFromBlock:implemenationBlock];
    }
    return self;
}




#pragma mark - Private

- (void)populateFromBlock:(id)block
{
    _implemenation                          = imp_implementationWithBlock(block);
    CTBlockDescription *blockDescription    = [[CTBlockDescription alloc] initWithBlock:block];
    NSMethodSignature *signature            = blockDescription.blockSignature;
    NSAssert(signature, @"The block you pass in must be capable of extracting a signature");

    // generate type character array
    NSInteger numberOfArguments             = [signature numberOfArguments];
    NSInteger numberOfChars                 = numberOfArguments + 3;
    char types[numberOfChars];
    types[0] = [signature methodReturnType][0];
    types[1] = '@';
    types[2] = ':';
    for (NSInteger i = 0; i < numberOfArguments; i++) {
        types[i + 3] = [signature getArgumentTypeAtIndex:i][0];
    }
    _types = types;
}

@end
