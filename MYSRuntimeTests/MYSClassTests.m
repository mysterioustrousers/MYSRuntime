//
//  MYSMethodTests.m
//  MYSRuntime
//
//  Created by Adam Kirk on 11/2/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MYSTestClass.h"
#import "MYSRuntime.h"


@interface MYSClassTests : XCTestCase
@end


@implementation MYSClassTests

- (void)setUp
{
    [super setUp];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (void)testAddSetterMethodToClass
{
    MYSClass *testClass = [[MYSClass alloc] initWithClass:[MYSTestClass class]];
    MYSMethod *testMethod = [[MYSMethod alloc] initWithName:@"setName:age:"
                                        implementationBlock:^(id self, NSString *name, NSNumber *age)
    {
        [(MYSTestClass *)self setObjectTest:name];
        [(MYSTestClass *)self setLongTest:[age longValue]];
    }];
    BOOL wasAdded = [testClass addMethod:testMethod];
    XCTAssertTrue(wasAdded);

    MYSTestClass *testObject = [MYSTestClass new];
    XCTAssertNoThrow([testObject performSelector:NSSelectorFromString(@"setName:age:") withObject:@"adam" withObject:@(27)]);
    XCTAssertEqualObjects(@"adam", testObject.objectTest);
    XCTAssertTrue(27 == testObject.longTest);
}

- (void)testAddGetterMethodToClass
{
    MYSClass *testClass = [[MYSClass alloc] initWithClass:[MYSTestClass class]];
    MYSMethod *testMethod = [[MYSMethod alloc] initWithName:@"colorOfBananas"
                                        implementationBlock:^NSString *(id self)
    {
        return @"yellow";
    }];
    BOOL wasAdded = [testClass addMethod:testMethod];
    XCTAssertTrue(wasAdded);

    MYSTestClass *testObject = [MYSTestClass new];
    NSString *bananas;
    XCTAssertNoThrow(bananas = [testObject performSelector:NSSelectorFromString(@"colorOfBananas")]);
    XCTAssertEqualObjects(@"yellow", bananas);
}

#pragma clang diagnostic pop

@end
