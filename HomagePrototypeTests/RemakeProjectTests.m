//
//  RemakeProjectTests.m
//  HomagePrototype
//
//  Created by Tomer Harry on 10/2/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "HMGRemakeProject.h"
#import "HMGTemplate.h"
#import "HMGTemplateCSVLoader.h"
#import "HMGSegmentRemake.h"
#import "HMGSegmentRemakeProtectedMethods.h"
#import "AGWaitForAsyncTestHelper.h"


@interface RemakeProjectTests : SenTestCase

@property (strong, nonatomic) NSMutableArray *resourcesToDelete;

@property (strong, nonatomic) HMGRemakeProject *tikimRemakeProject;

@end

const int TIKIM_INDEX = 2;
const int TIKIM_FINAL_DURATION = 58;

static NSString * const tikim1VideoName = @"Tikim_Text.mp4";
static NSString * const tikim2VideoName = @"Tikim_Images.mp4";
static NSString * const tikim3VideoName = @"Tikim_Pre_Race_Export.mp4";
static NSString * const tikim4VideoName = @"Tikim_Legs_Export.mov";
static NSString * const tikim5VideoName = @"Tikim_Race_Export.mp4";
static NSString * const tikim6VideoName = @"Tikim_Hero_Export.mp4";
static NSString * const tikim7VideoName = @"Tikim_FinishLine_Export.mp4";
static NSString * const tikim8VideoName = @"Tikim_Sigh_Export.mp4";


@implementation RemakeProjectTests

- (void)setUp
{
    [super setUp];
    
    HMGTemplateCSVLoader *templateLoader = [[HMGTemplateCSVLoader alloc] init];
    HMGTemplate *tikimTemplate = [templateLoader templateAtIndex:TIKIM_INDEX];
    
    self.tikimRemakeProject = [[HMGRemakeProject alloc] initWithTemplate:tikimTemplate];
    
    // Defining all the video takes for tikim's segments
    NSArray *tikimSegmentVideoNames = @[tikim1VideoName, tikim2VideoName, tikim3VideoName, tikim4VideoName, tikim5VideoName, tikim6VideoName, tikim7VideoName, tikim8VideoName];
    NSUInteger index = 0;
    for (HMGSegmentRemake *segmentRemake in self.tikimRemakeProject.segmentRemakes)
    {
        NSString *videoFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:tikimSegmentVideoNames[index] ofType:nil];
        [segmentRemake addVideoTake:[NSURL fileURLWithPath:videoFilePath]];
        ++index;
    }
}

- (void)tearDown
{
    for (NSURL *resourceURL in self.resourcesToDelete)
    {
        NSLog(@"Deleting resource: %@", resourceURL.description);
        [[NSFileManager defaultManager] removeItemAtURL:resourceURL error:nil];
    }
    [super tearDown];
}

- (void)testRenderVideoTikimShinyDay
{
    __block BOOL jobDone = NO;
    
    [self.tikimRemakeProject renderVideoAsynchronouslyWithCompletionHandler:^(NSURL *videoURL, NSError *error) {
        NSLog(@"inside the completion hamdler");
        
        STAssertNotNil(videoURL, @"video URL should not be nil");
        NSLog(@"video URL = %@", videoURL.description);
        
        // Adding the URL to the array of resources that should be deleted in the tear-down method
        [self.resourcesToDelete addObject:videoURL];
        
        AVAsset *outputVideoAsset = [AVAsset assetWithURL:videoURL];
        int outputVideoDuration = lroundf(CMTimeGetSeconds(outputVideoAsset.duration));
        STAssertTrue(outputVideoDuration == TIKIM_FINAL_DURATION, @"Output video duration and tikim final duration should be equal but they are %d and %d", outputVideoDuration, TIKIM_FINAL_DURATION);
        
        STAssertNil(error, @"error should be nil, but is isn't. Error description = %@", error.description);
        
        jobDone = YES;
    }];
    
    // Waiting 30 seconds for the above block to complete
    WAIT_WHILE(!jobDone, 30);
}

@end
