//
//  MYSType.h
//  MYSRuntime
//
//  Created by Adam Kirk on 11/2/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//


typedef NS_ENUM(NSUInteger, MYSType) {
    MYSTypeChar             = 'c',
    MYSTypeBool             = 'B',
    MYSTypeShort            = 's',
    MYSTypeInt              = 'i',
    MYSTypeLong             = 'l',
    MYSTypeLongLong         = 'q',
    MYSTypeUnsignedChar     = 'C',
    MYSTypeUnsignedShort    = 'S',
    MYSTypeUnsignedInt      = 'I',
    MYSTypeUnsignedLong     = 'L',
    MYSTypeUnsignedLongLong = 'Q',
    MYSTypeFloat            = 'f',
    MYSTypeDouble           = 'd',
    MYSTypeObject           = '@',
    MYSTypeEnum             = '{',
    MYSTypeUnion            = '(',
    MYSTypeArray            = '[',
    MYSTypePointerToType    = '^',
    MYSTypeVoid             = 'v',
    MYSTypeCString          = '*',
    MYSTypeClass            = '#',
    MYSTypeSelector         = ':',
    MYSTypeBitfield         = 'b',
    MYSTypeUnkown           = '?'
};

typedef NS_ENUM(NSUInteger, MYSQualifier) {
    MYSQualifierConst       = 'r',
    MYSQualifierIn          = 'n',
    MYSQualifierInOut       = 'N',
    MYSQualifierOut         = 'o',
    MYSQualifierByCopy      = 'O',
    MYSQualifierByReference = 'R',
    MYSQualifierOneWay      = 'V'
};
