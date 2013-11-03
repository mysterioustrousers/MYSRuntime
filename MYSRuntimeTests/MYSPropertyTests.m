//
//  MYSClassTests.m
//  MYSRuntime
//
//  Created by Adam Kirk on 11/2/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MYSRuntime.h"
#import "MYSTestClass.h"


#define BIT64 (sizeof(int*) == 8)


@interface MYSPropertyTests : XCTestCase
@property (nonatomic, strong) MYSClass *klass;
@end


@implementation MYSPropertyTests

- (void)setUp
{
    [super setUp];
    self.klass = [[MYSClass alloc] initWithClass:[MYSTestClass class]];
}


- (void)testPropertyAttributes
{
    NSArray *properties = [self.klass properties];
    for (MYSProperty *property in properties) {
        switch (property.type) {

            case MYSTypeChar:
                if (BIT64) {
                    XCTAssertEqualObjects(@"charTest", property.name);
                }
                else {
                    BOOL valid = ([property.name isEqualToString:@"charTest"] ||
                                  [property.name isEqualToString:@"boolTest"]);
                    XCTAssertTrue(valid);
                }
                break;

            case MYSTypeBool:
                XCTAssertEqualObjects(@"boolTest", property.name);
                break;

            case MYSTypeInt:
            {
                if (BIT64) {
                    XCTAssertEqualObjects(@"intTest", property.name);
                }
                else {
                    BOOL valid = ([property.name isEqualToString:@"intTest"] ||
                                  [property.name isEqualToString:@"longLongTest"] ||
                                  [property.name isEqualToString:@"longTest"]);
                    XCTAssertTrue(valid);
                }
                XCTAssertTrue(property.isReadOnly);
                XCTAssertTrue(property.storageType == MYSPropertyStorageTypeAssign);
            }
                break;

            case MYSTypeLong:
            {
                XCTAssertEqualObjects(@"longTest", property.name);
                XCTAssertTrue(!property.isNonAtomic);
            }
                break;

            case MYSTypeLongLong:
                if (BIT64) {
                    BOOL valid = ([property.name isEqualToString:@"longLongTest"] ||
                                  [property.name isEqualToString:@"longTest"]);
                    XCTAssertTrue(valid);
                }
                else {
                    XCTAssertEqualObjects(@"longLongTest", property.name);
                }
                break;

            case MYSTypeUnsignedChar:
                XCTAssertEqualObjects(@"unsignedCharTest", property.name);
                break;

            case MYSTypeUnsignedShort:
                if (YES) {
                    BOOL valid = ([property.name isEqualToString:@"unsignedCharTest"] ||
                                  [property.name isEqualToString:@"unsignedShortTest"]);
                    XCTAssertTrue(valid);
                }
                break;

            case MYSTypeUnsignedInt:
            {
                if (BIT64) {
                    XCTAssertEqualObjects(@"unsignedIntTest", property.name);
                }
                else {
                    BOOL valid = ([property.name isEqualToString:@"unsignedIntTest"] ||
                                  [property.name isEqualToString:@"unsignedLongTest"]);
                    XCTAssertTrue(valid);
                }
                XCTAssertEqualObjects(@"getUnsignedIntTest", property.getter);
            }
                break;

            case MYSTypeUnsignedLong:
                XCTAssertEqualObjects(@"unsignedLongTest", property.name);
                break;

            case MYSTypeUnsignedLongLong:
                if (BIT64) {
                    BOOL valid = ([property.name isEqualToString:@"unsignedLongLongTest"] ||
                                  [property.name isEqualToString:@"unsignedLongTest"]);
                    XCTAssertTrue(valid);
                }
                else {
                    XCTAssertEqualObjects(@"unsignedLongLongTest", property.name);
                }
                break;

            case MYSTypeFloat:
            {
                XCTAssertEqualObjects(@"floatTest", property.name);
                XCTAssertEqualObjects(@"setFloatTest:", property.setter);
                XCTAssertTrue(property.isDynamic);
            }
                break;

            case MYSTypeDouble:
                XCTAssertEqualObjects(@"doubleTest", property.name);
                break;

            case MYSTypeObject:
            {
                XCTAssertEqualObjects(@"objectTest", property.name);
                XCTAssertTrue(property.storageType == MYSPropertyStorageTypeStrong);
            }
                break;

            case MYSTypeEnum:
                XCTAssertEqualObjects(@"enumTest", property.name);
                break;

            case MYSTypeUnion:
                XCTAssertEqualObjects(@"unionTest", property.name);
                break;

            case MYSTypeCString:
                XCTAssertEqualObjects(@"cStringTest", property.name);
                break;

            case MYSTypeClass:
                XCTAssertEqualObjects(@"classTest", property.name);
                break;

            case MYSTypeSelector:
                XCTAssertEqualObjects(@"selectorTest", property.name);
                break;

            default:
                XCTFail(@"Didn't match any type: %@", property.name);
        }
    }
}

@end
