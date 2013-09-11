//
//  TemplateCSVLoaderTests.m
//  HomagePrototype
//
//  Created by Tomer Harry on 9/10/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "TemplateCSVLoaderTests.h"
#import "HMGTemplateCSVLoader.h"
#import "HMGTemplate.h"
#import "HMGRemake.h"

@implementation TemplateCSVLoaderTests

- (void)testLoadTemplate
{
    HMGTemplateCSVLoader *templateLoader = [[HMGTemplateCSVLoader alloc] init];
    
    HMGTemplate *template = [templateLoader templateAtIndex:0];
    
    STAssertTrue([template.templateID isEqualToString:@"1"], @"template ID not equal");
}

- (void)testNilTemplate
{
    HMGTemplateCSVLoader *templateLoader = [[HMGTemplateCSVLoader alloc] init];
    
    HMGTemplate *template = [templateLoader templateAtIndex:3];
    
    STAssertNil(template, @"Template Should be nil");
}

- (void)testTemplateRemakes
{
    HMGTemplateCSVLoader *templateLoader = [[HMGTemplateCSVLoader alloc] init];

    HMGTemplate *wrongMeetingtemplate = [templateLoader templateAtIndex:0];
    STAssertTrue([wrongMeetingtemplate.name isEqualToString:@"Wrong Meeting"], @"Template name should be Wrong Meeting, but it is %@", wrongMeetingtemplate.name);
    STAssertTrue([wrongMeetingtemplate.remakes count] == 2, @"Wrong Meeting template should have 2 remakes, but it has %d", [wrongMeetingtemplate.remakes count]);
  
    HMGTemplate *starWarsTemplate = [templateLoader templateAtIndex:1];
    STAssertTrue([starWarsTemplate.name isEqualToString:@"Star Wars (I am your father)"], @"Template name should be Star Wars, but it is %@", starWarsTemplate.name);
    STAssertTrue([starWarsTemplate.remakes count] == 1, @"Star Wars template should have 1 remakes, but it has %d", [starWarsTemplate.remakes count]);
    
    HMGTemplate *tikimTemplate = [templateLoader templateAtIndex:2];
    STAssertTrue([tikimTemplate.name isEqualToString:@"Tikim"], @"Template name should be Tikim, but it is %@", tikimTemplate.name);
    STAssertTrue([tikimTemplate.remakes count] == 0, @"Tikim template should have 0 remakes, but it has %d", [tikimTemplate.remakes count]);
}

@end
