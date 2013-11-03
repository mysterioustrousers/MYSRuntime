MYSRuntime
==========

Obj-C Library that makes runtime self-inspection and class modification dead easy.

Using objective-c objects to wrap classes methods and properties, it is much easier and
straight-forward to get information about a classes properties.

Creating methods from blocks and adding them to classes is also dead easy.

### Example

Easily get information about properties:

    NSArray *properties = [self.klass properties];
    for (MYSProperty *property in properties) {
        property.type           // e.g. MYSTypeLongLong
        property.name           // e.g. propertyName
        property.isReadOnly;  
        property.storageType;   // e.g. MYSPropertyStorageTypeStrong
        property.isNonAtomic;
        property.getter;        // the name of the getter method.
        property.setter;        // the name of the setter method.
        property.isDynamic;
        property.isElegibleForGarbageCollection; 
        property.propertyAttributesString; // the original attributes string.
    }

Easily create methods from blocks and add them as methods to classes.

    MYSMethod *testMethod = [[MYSMethod alloc] initWithName:@"setName:age:"
                                        implementationBlock:^(id self, NSString *name, NSNumber *age)
    {
        [(MYSTestClass *)self setObjectTest:name];
        [(MYSTestClass *)self setLongTest:[age longValue]];
    }];
    
    MYSClass *testClass   = [[MYSClass alloc] initWithClass:[MYSTestClass class]];
    [testClass addMethod:testMethod];

### Author

Adam Kirk [@atomkirk](https://twitter.com/atomkirk)

### Credits

Uses [CTBlockDescription](https://github.com/ebf/CTObjectiveCRuntimeAdditions).
