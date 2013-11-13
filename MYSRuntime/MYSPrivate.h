//
//  MYSType.h
//  MYSRuntime
//
//  Created by Adam Kirk on 11/2/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MYSProperty.h"


@class MYSClass;


typedef NS_ENUM(NSUInteger, MYSMethodArgumentQualifier) {
    MYSMethodArgumentQualifierConst       = 'r',
    MYSMethodArgumentQualifierIn          = 'n',
    MYSMethodArgumentQualifierInOut       = 'N',
    MYSMethodArgumentQualifierOut         = 'o',
    MYSMethodArgumentQualifierByCopy      = 'O',
    MYSMethodArgumentQualifierByReference = 'R',
    MYSMethodArgumentQualifierOneWay      = 'V'
};


//@interface MYSProperty ()
//@property (nonatomic, weak) MYSClass *klass;
//@end
//
//@interface MYSIvar ()
//@property (nonatomic, weak) MYSClass *klass;
//@end
//
//@interface MYSMethod ()
//@property (nonatomic, weak) MYSClass *klass;
//@end
