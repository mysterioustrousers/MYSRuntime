//
//  MYSIvar.m
//  MYSRuntime
//
//  Created by Adam Kirk on 11/12/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MYSRuntime.h"


@implementation MYSIvar

- (id)initWithObjCIvar:(Ivar)ivar
{
    self = [super init];
    if (self) {
        _ivar   = ivar;
        _name   = [[NSString stringWithUTF8String:ivar_getName(ivar)] copy];
        _type   = [[MYSType alloc] initWithEncodingString:[NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)]];
        _offset = ivar_getOffset(ivar);
    }
    return self;
}

@end
