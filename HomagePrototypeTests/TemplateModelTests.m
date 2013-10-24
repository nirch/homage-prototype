//
//  TemplateModelTests.m
//  HomagePrototype
//
//  Created by Yoav Caspin on 10/24/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "HMGTemplate.h"
#import "HMGLog.h"

@interface TemplateModelTests : SenTestCase

@property (strong,nonatomic) HMGTemplate *template;

@end

@implementation TemplateModelTests

- (void)setUp
{
    [super setUp];
    self.template = [[HMGTemplate alloc] init];
}

- (void) testTemplateLevel
{
    self.template.level = Easy;
    NSString *easyLevelDescription = self.template.levelDescription;
    STAssertTrue([easyLevelDescription isEqualToString:@"Easy"] , @"level description translation does not work. easyLevelDescription is %@" , easyLevelDescription);
    
    self.template.level = Medium;
    NSString *mediumLevelDescription = self.template.levelDescription;
    STAssertTrue([mediumLevelDescription isEqualToString:@"Medium"] , @"level description translation does not work. mediumLevelDescription is %@" , mediumLevelDescription);
    
    self.template.level = Hard;
    NSString *hardLevelDescription = self.template.levelDescription;
    STAssertTrue([hardLevelDescription isEqualToString:@"Hard"] , @"level description translation does not work. hardLevelDescription is %@" , hardLevelDescription);
    
    self.template.level = 5;
    NSString *nilLevelDescription = self.template.levelDescription;
    STAssertNil(nilLevelDescription , @"level description translation does not work. nilLevelDescription is %@" , nilLevelDescription);
    
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

@end
