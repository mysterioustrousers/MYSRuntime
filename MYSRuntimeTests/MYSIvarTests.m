//
//  MYSIvarTests.m
//  MYSRuntime
//
//  Created by Adam Kirk on 11/12/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MYSRuntime.h"
#import "MYSTestClass.h"


@interface MYSIvarTests : XCTestCase
@property (nonatomic, strong) MYSClass *klass;
@end


@implementation MYSIvarTests

- (void)setUp
{
    [super setUp];
    self.klass = [[MYSClass alloc] initWithClass:[MYSTestClass class]];
}


- (void)testIvarAttributes
{
    MYSIvar *ivar = [self ivarWithName:@"_publicidIvar"];
    XCTAssertTrue(ivar.type.type == MYSTypeTypeObject);

    ivar = [self ivarWithName:@"_publicStringIvar"];
    XCTAssertTrue(ivar.type.type == MYSTypeTypeObject);

    ivar = [self ivarWithName:@"_publicRectIvar"];
    XCTAssertTrue(ivar.type.type == MYSTypeTypeStruct);

    ivar = [self ivarWithName:@"_publicPointIvar"];
    XCTAssertTrue(ivar.type.type == MYSTypeTypeStruct);

    ivar = [self ivarWithName:@"_privateIvar"];
    XCTAssertTrue(ivar.type.type == MYSTypeTypeObject);

    ivar = [self ivarWithName:@"_privateStringIvar"];
    XCTAssertTrue(ivar.type.type == MYSTypeTypeObject);

    ivar = [self ivarWithName:@"_privateRectIvar"];
    XCTAssertTrue(ivar.type.type == MYSTypeTypeStruct);

    ivar = [self ivarWithName:@"_privatePointIvar"];
    XCTAssertTrue(ivar.type.type == MYSTypeTypeStruct);

    ivar = [self ivarWithName:@"_charTest"];
    XCTAssertTrue(ivar.type.type == MYSTypeTypeChar);
}



#pragma mark - Private

- (MYSIvar *)ivarWithName:(NSString *)name
{
    NSArray *ivars = [self.klass ivars];
    for (MYSIvar *ivar in ivars) {
        if ([ivar.name isEqualToString:name]) {
            return ivar;
        }
    }
    return nil;
}

@end
