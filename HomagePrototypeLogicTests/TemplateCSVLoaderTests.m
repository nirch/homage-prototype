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
#import "HMGSegment.h"
#import "HMGVideoSegment.h"
#import "HMGTextSegment.h"
#import "HMGImageSegment.h"

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
    
    HMGTemplate *template = [templateLoader templateAtIndex:5];
    
    STAssertNil(template, @"Template Should be nil");
}

- (void)testTemplateRemakes
{
    HMGTemplateCSVLoader *templateLoader = [[HMGTemplateCSVLoader alloc] init];

    HMGTemplate *wrongMeetingtemplate = [templateLoader templateAtIndex:0];
    STAssertTrue([wrongMeetingtemplate.name isEqualToString:@"Wrong Meeting"], @"Template name should be Wrong Meeting, but it is %@", wrongMeetingtemplate.name);
    STAssertTrue([wrongMeetingtemplate.remakes count] == 2, @"Wrong Meeting template should have 2 remakes, but it has %d", [wrongMeetingtemplate.remakes count]);
  
    HMGTemplate *starWarsTemplate = [templateLoader templateAtIndex:1];
    STAssertTrue([starWarsTemplate.name isEqualToString:@"I am your father"], @"Template name should be Star Wars, but it is %@", starWarsTemplate.name);
    STAssertTrue([starWarsTemplate.remakes count] == 1, @"Star Wars template should have 1 remakes, but it has %d", [starWarsTemplate.remakes count]);
    
    HMGTemplate *tikimTemplate = [templateLoader templateAtIndex:2];
    STAssertTrue([tikimTemplate.name isEqualToString:@"Tikim"], @"Template name should be Tikim, but it is %@", tikimTemplate.name);
    STAssertTrue([tikimTemplate.remakes count] == 1, @"Tikim template should have 0 remakes, but it has %d", [tikimTemplate.remakes count]);
}

- (void)testTemplateSegments
{
    HMGTemplateCSVLoader *templateLoader = [[HMGTemplateCSVLoader alloc] init];
    
    HMGTemplate *wrongMeetingtemplate = [templateLoader templateAtIndex:0];
    STAssertTrue([wrongMeetingtemplate.segments count] == 0, @"Wrong Meeting template should have 0 segments, but it has %d", [wrongMeetingtemplate.segments count]);
    
    HMGTemplate *starWarsTemplate = [templateLoader templateAtIndex:1];
    STAssertTrue([starWarsTemplate.segments count] == 3, @"Star Wars template should have 3 segments, but it has %d", [starWarsTemplate.segments count]);
    
    HMGTemplate *tikimTemplate = [templateLoader templateAtIndex:2];
    STAssertTrue([tikimTemplate.segments count] == 8, @"Tikim template should have 0 segments, but it has %d", [tikimTemplate.segments count]);
}

- (void)testTikimSegments
{
    HMGTemplateCSVLoader *templateLoader = [[HMGTemplateCSVLoader alloc] init];

    HMGTemplate *tikimTemplate = [templateLoader templateAtIndex:2];
    STAssertTrue([tikimTemplate.segments count] == 8, @"Tikim template should have 0 segments, but it has %d", [tikimTemplate.segments count]);
    
    STAssertTrue([tikimTemplate.segments[0] isKindOfClass:[HMGTextSegment class]], @"Tikim template first segment should be a text segment, but it is %@", [[tikimTemplate.segments[0] class] description]);
    HMGTextSegment *textSegment = tikimTemplate.segments[0];
    STAssertTrue([textSegment.font isEqualToString:@"Helvetica"], @"Tikim template font should be Helvetica but it is %@", textSegment.font);
    
    STAssertTrue([tikimTemplate.segments[1] isKindOfClass:[HMGImageSegment class]], @"Tikim template second segment should be an image segment, but it is %@", [[tikimTemplate.segments[1] class] description]);
    HMGImageSegment *imageSegment = tikimTemplate.segments[1];
    STAssertTrue(imageSegment.minNumOfImages == 8, @"Tikim template min num of images in the image slide should be 8, but it is %d", imageSegment.minNumOfImages);
    
    STAssertTrue([tikimTemplate.segments[2] isKindOfClass:[HMGVideoSegment class]], @"Tikim template third segment should be a video segment, but it is %@", [[tikimTemplate.segments[2] class] description]);
    HMGVideoSegment *videoSegment = tikimTemplate.segments[2];
    STAssertTrue(videoSegment.recordDuration.value == 16000, @"Tikim template record duration for the first video segment should be 16000, but it is %d", videoSegment.recordDuration);
    
}

@end
