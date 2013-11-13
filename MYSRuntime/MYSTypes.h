//
//  MYSType.h
//  MYSRuntime
//
//  Created by Adam Kirk on 11/2/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//



typedef NS_ENUM(NSUInteger, MYSMethodArgumentQualifier) {
    MYSMethodArgumentQualifierConst       = 'r',
    MYSMethodArgumentQualifierIn          = 'n',
    MYSMethodArgumentQualifierInOut       = 'N',
    MYSMethodArgumentQualifierOut         = 'o',
    MYSMethodArgumentQualifierByCopy      = 'O',
    MYSMethodArgumentQualifierByReference = 'R',
    MYSMethodArgumentQualifierOneWay      = 'V'
};
