//
//  MYSType.m
//  MYSRuntime
//
//  Created by Adam Kirk on 11/12/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MYSType.h"


static char pointerEncodingCharacter = '^';


@interface MYSTypePrimitiveMember ()
- (id)initWithName:(NSString *)name type:(MYSType *)type;
@end


@implementation MYSType

- (id)initWithEncodingString:(NSString *)encodingString
{
    self = [super init];
    if (self) {
        _encodingString = [encodingString copy];
        [self parseEncodingString:encodingString];
    }
    return self;
}



#pragma mark - Public

- (NSString *)typeName
{
    switch (_type) {

        case MYSTypeTypeChar:
            return @"char";

        case MYSTypeTypeBool:
            return @"BOOL";

        case MYSTypeTypeShort:
            return @"short";

        case MYSTypeTypeInt:
            return @"int";

        case MYSTypeTypeLong:
            return @"long";

        case MYSTypeTypeLongLong:
            return @"long long";

        case MYSTypeTypeUnsignedChar:
            return @"unsigned char";

        case MYSTypeTypeUnsignedShort:
            return @"unsigned short";

        case MYSTypeTypeUnsignedInt:
            return @"unsigned int";

        case MYSTypeTypeUnsignedLong:
            return @"unsigned long";

        case MYSTypeTypeUnsignedLongLong:
            return @"unsigned long long";

        case MYSTypeTypeFloat:
            return @"float";

        case MYSTypeTypeDouble:
            return @"double";

        case MYSTypeTypeObject:
            return @"object";

        case MYSTypeTypeStruct:
            return @"struct";

        case MYSTypeTypeUnion:
            return @"union";

        case MYSTypeTypeArray:
            return @"array";

        case MYSTypeTypeVoid:
            return @"void";

        case MYSTypeTypeCString:
            return @"char *";

        case MYSTypeTypeClass:
            return @"Class";

        case MYSTypeTypeSelector:
            return @"SEL";
            
        case MYSTypeTypeBitfield:
            return @"bitfield";
            
        case MYSTypeTypeUnkown:
            return @"unknown";
            
        default:
            return @"object";
    }
}

- (NSUInteger)size
{
    NSUInteger size;
    const char *encoding = [self.encodingString UTF8String];
    NSGetSizeAndAlignment(encoding, &size, NULL);
    return size;
}



#pragma mark - Private

- (void)parseEncodingString:(NSString *)encodingString
{
    if ([encodingString isEqualToString:@"@"]) {
        _type           = '@';
        _pointerCount   = 0;
        _tag            = @"id";
        return;
    }
    // record and strip pointer encoding
    _pointerCount = 0;
    while ([encodingString length] > 0 && [encodingString characterAtIndex:0] == pointerEncodingCharacter) {
        _pointerCount++;
        encodingString = [encodingString substringFromIndex:1];
    }

    if ([encodingString length] > 0) {
        _type = [encodingString characterAtIndex:0];

        if ([encodingString length] > 1) {
            if (_type == MYSTypeTypeObject) {
                [self parseObjectTypeString:encodingString];
            }
            else {
                [self parsePrimitiveTypeString:encodingString];
            }
        }
    }
}

- (void)parseObjectTypeString:(NSString *)objectType
{
    _tag = [objectType substringWithRange:NSMakeRange(2, [objectType length] - 3)];
}

- (void)parsePrimitiveTypeString:(NSString *)primitiveTypeString
{
    NSString *internalStructureString = [primitiveTypeString substringWithRange:NSMakeRange(1, [primitiveTypeString length] - 2)];

    NSMutableString *tagName    = [NSMutableString new];
    NSMutableString *arraySize  = [NSMutableString new];
    NSMutableString *memberName = [NSMutableString new];
    NSMutableString *memberType = [NSMutableString new];
    NSMutableArray *members     = [NSMutableArray new];

    NSString *pendingMemberName;

    BOOL startToken         = YES;
    NSUInteger openBraces   = 0;
    BOOL openQuotes         = NO;

    for (NSUInteger i = 0; i < [internalStructureString length]; i++) {
        unichar c = [internalStructureString characterAtIndex:i];

        // update state
        if (c == '{' || c == '[' || c == '(') {
            openBraces++;
            startToken = NO;
        }
        else if (c == '}' || c == ']' || c == ')') {
            openBraces--;
        }
        else if (c == '"' && openBraces == 0) {
            openQuotes = !openQuotes;
            startToken = NO;
        }
        else if (c == '=' && openBraces == 0) {
            startToken = NO;
        }

        // append to strings
        else {
            if (startToken) {
                if (self.type == MYSTypeTypeArray) {
                    if (c >= '0' && c <= '9') {
                        [arraySize appendFormat:@"%c", c];
                    }
                    else {
                        startToken = NO;
                        [memberType appendFormat:@"%c", c];
                        if (c == '^') continue;
                    }
                }
                else {
                    [tagName appendFormat:@"%c", c];
                }
            }
            else if (openQuotes) {
                [memberName appendFormat:@"%c", c];
            }
            else {
                [memberType appendFormat:@"%c", c];
                if (c == '^') continue;
            }
        }

        if (!startToken && [tagName length] > 0) {
            _tag = [tagName copy];
            tagName = nil;
        }

        if (!startToken && [arraySize length] > 0) {
            _arraySize = [arraySize integerValue];
            arraySize = nil;
        }

        if (!openQuotes && [memberName length] > 0) {
            pendingMemberName = [memberName copy];
            [memberName setString:@""];
        }

        if (openBraces == 0 && [memberType length] > 0) {
            if (self.type != MYSTypeTypeArray) {
                if ([memberType length] > 2) {
                    unichar openCharacter = '}' ? '{' : '(';
                    NSString *wrappedType = [NSString stringWithFormat:@"%c%@%c", openCharacter, memberType, c];
                    MYSType *nestedType = [[MYSType alloc] initWithEncodingString:wrappedType];
                    MYSTypePrimitiveMember *member = [[MYSTypePrimitiveMember alloc] initWithName:pendingMemberName
                                                                                             type:nestedType];
                    [members addObject:member];
                }
                else {
                    MYSType *nestedType = [[MYSType alloc] initWithEncodingString:[memberType copy]];
                    MYSTypePrimitiveMember *member = [[MYSTypePrimitiveMember alloc] initWithName:pendingMemberName
                                                                                             type:nestedType];
                    [members addObject:member];
                }
            }
            else {
                MYSType *nestedType = [[MYSType alloc] initWithEncodingString:[memberType copy]];
                _arrayType = nestedType;
            }
            [memberType setString:@""];
        }
    }

    _members = members;
}

@end




@implementation MYSTypePrimitiveMember

- (id)initWithName:(NSString *)name type:(MYSType *)type
{
    self = [super init];
    if (self) {
        _name = name;
        _type = type;
    }
    return self;
}
@end
