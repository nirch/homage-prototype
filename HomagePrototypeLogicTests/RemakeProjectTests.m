//
//  RemakeProjectTests.m
//  HomagePrototype
//
//  Created by Tomer Harry on 9/22/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "RemakeProjectTests.h"
#import "HMGTemplate.h"
#import "HMGRemakeProject.h"
#import "HMGSegment.h"
#import "HMGVideoSegment.h"
#import "HMGImageSegment.h"
#import "HMGTextSegment.h"
#import "HMGSegmentRemake.h"
#import "HMGVideoSegmentRemake.h"
#import "HMGImageSegmentRemake.h"
#import "HMGTextSegmentRemake.h"
#import "HMGTemplateCSVLoader.h"

@interface RemakeProjectTests()

@property (strong, nonatomic) HMGRemakeProject *tikimRemakeProject;

@end

@implementation RemakeProjectTests


- (void)setUp
{
    [super setUp];
    
    HMGTemplateCSVLoader *templateLoader = [[HMGTemplateCSVLoader alloc] init];
    
    
    // Loading tikim template
    HMGTemplate *tikimTemplate = [templateLoader templateAtIndex:2];
    
    STAssertTrue([tikimTemplate.name isEqualToString:@"Tikim"], @"The remake project tests are needs to use Tikim template for the testing, the loaded template is %@", tikimTemplate.name);
    
    self.tikimRemakeProject = [[HMGRemakeProject alloc] initWithTemplate:tikimTemplate];    
}

- (void)testInitialization
{
    // Testing that the object is initialized
    STAssertNotNil(self.tikimRemakeProject, @"tikimRemakeProject is nil");
}

- (void)testNumberOfSegmentRemakes
{
    STAssertTrue(self.tikimRemakeProject.segmentRemakes.count == 8, @"The number of segment remakes for the tikim template should be 8, but it is %d", self.tikimRemakeProject.segmentRemakes.count);
}

- (void)testTypesOfSegmentRemake
{
    STAssertTrue([self.tikimRemakeProject.segmentRemakes[0] isKindOfClass:[HMGTextSegmentRemake class]], @"Tikim template first segment should be a text segment, but it is %@", [[self.tikimRemakeProject.segmentRemakes[0] class] description]);
    
    STAssertTrue([self.tikimRemakeProject.segmentRemakes[1] isKindOfClass:[HMGImageSegmentRemake class]], @"Tikim template second segment should be an image segment, but it is %@", [[self.tikimRemakeProject.segmentRemakes[1] class] description]);
    
    STAssertTrue([self.tikimRemakeProject.segmentRemakes[2] isKindOfClass:[HMGVideoSegmentRemake class]], @"Tikim template third segment should be a video segment, but it is %@", [[self.tikimRemakeProject.segmentRemakes[2] class] description]);

}



@end
