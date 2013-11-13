//
//  MYSTypeTests.m
//  MYSRuntime
//
//  Created by Adam Kirk on 11/12/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MYSRuntime.h"
#import "MYSTestClass.h"


@interface MYSTypeTests : XCTestCase
@property (nonatomic, strong) MYSClass *klass;
@end


@implementation MYSTypeTests

- (void)setUp
{
    [super setUp];
    self.klass = [[MYSClass alloc] initWithClass:[MYSTestClass class]];
}

- (void)testTypeAttributes
{
    MYSIvar *ivar = [self ivarWithName:@"_publicidIvar"];
    XCTAssertTrue(ivar.type.type == MYSTypeTypeObject);
    XCTAssertTrue(ivar.type.pointerCount == 0);
    XCTAssertEqualObjects(@"object", ivar.type.typeName);
    XCTAssertEqualObjects(@"id", ivar.type.tag);
    XCTAssertTrue(ivar.type.arraySize == 0);
    XCTAssertTrue(ivar.type.members == nil);

    ivar = [self ivarWithName:@"_publicStringIvar"];
    XCTAssertTrue(ivar.type.type == MYSTypeTypeObject);

    ivar = [self ivarWithName:@"_publicRectIvar"];
    XCTAssertTrue(ivar.type.type == MYSTypeTypeStruct);
    XCTAssertTrue(ivar.type.pointerCount == 0);
    XCTAssertEqualObjects(@"struct", ivar.type.typeName);
    XCTAssertEqualObjects(@"CGRect", ivar.type.tag);
    XCTAssertTrue(ivar.type.arraySize == 0);
    XCTAssertTrue([ivar.type.members count] == 2);
    MYSTypePrimitiveMember *point = ivar.type.members[0];
    XCTAssertEqualObjects(@"origin", point.name);
    XCTAssertTrue(point.type.type == MYSTypeTypeStruct);

    ivar = [self ivarWithName:@"_publicCArrayIvar"];
    XCTAssertTrue(ivar.type.type == MYSTypeTypeArray);
    XCTAssertTrue(ivar.type.arraySize == 20);
    XCTAssertTrue(ivar.type.arrayType.type == MYSTypeTypeUnsignedLongLong);

    ivar = [self ivarWithName:@"_publicUnionIvar"];
    XCTAssertTrue(ivar.type.type == MYSTypeTypeUnion);
    XCTAssertTrue(ivar.type.pointerCount == 0);
    XCTAssertEqualObjects(@"union", ivar.type.typeName);
    XCTAssertEqualObjects(@"?", ivar.type.tag);
    XCTAssertTrue(ivar.type.arraySize == 0);
    XCTAssertTrue([ivar.type.members count] == 4);
    MYSTypePrimitiveMember *integer = ivar.type.members[3];
    XCTAssertEqualObjects(@"j", integer.name);
    XCTAssertTrue(integer.type.type == MYSTypeTypeInt);
    XCTAssertTrue(integer.type.pointerCount == 1);
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
