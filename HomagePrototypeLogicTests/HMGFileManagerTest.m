//
//  HMGFileManagerTest.m
//  HomagePrototype
//
//  Created by Tomer Harry on 10/6/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGFileManagerTest.h"
#import "HMGFileManager.h"

@implementation HMGFileManagerTest

- (void)testUniqueUrlWithPrefixWhenFileNameIsNill
{
    NSString *fileName = Nil;
    NSURL *outptVideoUrl = [HMGFileManager uniqueUrlWithPrefix:fileName ofType:@"mov"];
    STAssertTrue(outptVideoUrl!=nil,@"UniqueUrlWithPrefix returned nill");
}
- (void)testUniqueUrlWithPrefixWhenTypeNameIsNill
{
    NSString *typeName = Nil;
    NSURL *outptVideoUrl = [HMGFileManager uniqueUrlWithPrefix:@"test" ofType:typeName];
    STAssertTrue(outptVideoUrl!=nil,@"UniqueUrlWithPrefix returned nill");
}

@end
