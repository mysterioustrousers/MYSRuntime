//
//  MYSTestClass.h
//  MYSRuntime
//
//  Created by Adam Kirk on 11/2/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>

typedef union
{
    int     i;
    float   f;
    char    str[20];
    int     *j;
} TestUnion;


@interface MYSTestClass : NSObject {
    id              _publicidIvar;
    NSString        *_publicStringIvar;
    CGRect          _publicRectIvar;
    CGPoint         _publicPointIvar;
    CGRect          *_publicRectPointerIvar;
    __weak NSError  **_publicErrorPointerIvar;
    void            *_publicVoidStarIvar;
    NSUInteger      _publicCArrayIvar[20];
    CGRect          _publicCArrayOfRectsIvar[5];
    TestUnion       _publicUnionIvar;
    int             ***_publicTriplePoinerIvar;
}
@property (nonatomic, assign                                     ) char               charTest;
@property (nonatomic, assign                                     ) BOOL               boolTest;
@property (nonatomic, assign, readonly                           ) int                intTest;
@property (           assign                                     ) long               longTest;
@property (nonatomic, assign                                     ) long long          longLongTest;
@property (nonatomic, assign                                     ) unsigned char      unsignedCharTest;
@property (nonatomic, assign                                     ) unsigned short     unsignedShortTest;
@property (nonatomic, assign,           getter=getUnsignedIntTest) unsigned int       unsignedIntTest;
@property (nonatomic, assign                                     ) unsigned long      unsignedLongTest;
@property (nonatomic, assign                                     ) unsigned long long unsignedLongLongTest;
@property (nonatomic, assign,           setter=setFloatTest:     ) float              floatTest;
@property (nonatomic, assign                                     ) double             doubleTest;
@property (nonatomic, strong                                     ) id                 objectTest;
@property (nonatomic, assign                                     ) struct             structTest;
@property (nonatomic, assign                                     ) union              unionTest;
@property (nonatomic, assign                                     ) char               *cStringTest;
@property (nonatomic, assign                                     ) Class              classTest;
@property (nonatomic, assign                                     ) SEL                selectorTest;
@end