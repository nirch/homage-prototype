//
//  AVUtilsTests.m
//  HomagePrototype
//
//  Created by Tomer Harry on 9/29/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "HMGAVUtils.h"

@interface AVUtilsTests : SenTestCase

@property (strong, nonatomic) NSMutableArray *resourcesToDelete;

@property (strong, nonatomic) NSURL *video1;
@property (strong, nonatomic) NSURL *video2;

@end

static NSString * const video1Name = @"Red.mov";
static NSString * const video2Name = @"Tikim_Text.mp4";

@implementation AVUtilsTests

- (void)setUp
{
    [super setUp];

    NSString *video1Path = [[NSBundle bundleForClass:[self class]] pathForResource:video1Name ofType:nil];
    self.video1 = [NSURL fileURLWithPath:video1Path];
    
    NSString *video2Path = [[NSBundle bundleForClass:[self class]] pathForResource:video2Name ofType:nil];
    self.video2 = [NSURL fileURLWithPath:video2Path];
    
    self.resourcesToDelete = [[NSMutableArray alloc] init];
}

- (void)tearDown
{
    for (NSURL *resourceURL in self.resourcesToDelete)
    {
        [[NSFileManager defaultManager] removeItemAtURL:resourceURL error:nil];
    }
    
    [super tearDown];
}

// Testing that the setUp method successfully initialized the properties
- (void)testSetUp
{
    NSLog(@"Video 1 URL: %@", self.video1.description);
    
    // Checking that the URL of the video contains the name of the video
    STAssertTrue([self.video1.description rangeOfString:video1Name].location != NSNotFound, @"Video name:<%@> was not found in URL:<%@>", video1Name, self.video1.description);
    
    NSLog(@"Video 2 URL: %@", self.video2.description);
    
    // Checking that the URL of the video contains the name of the video
    STAssertTrue([self.video2.description rangeOfString:video2Name].location != NSNotFound, @"Video name:<%@> was not found in URL:<%@>", video2Name, self.video2.description);
    
}

- (void)testMergeVideosNoSoundtrack
{
    NSArray *videosToMerge = @[self.video1, self.video2];
    
    dispatch_group_t dispatchGroup = dispatch_group_create();
    dispatch_group_enter(dispatchGroup);
    
    [HMGAVUtils mergeVideos:videosToMerge withSoundtrack:nil completion:^(AVAssetExportSession *exporter) {
        
        NSLog(@"in the exporter completion block");
        
        STAssertTrue(exporter.status == AVAssetExportSessionStatusCompleted, @"The status is %d, but should have been %d", exporter.status, AVAssetExportSessionStatusCompleted);
        
        // Adding the URL to the array of resources that should be deleted in the tear-down method
        [self.resourcesToDelete addObject:exporter.outputURL];
        
        AVAsset *mergedVideo = [AVAsset assetWithURL:exporter.outputURL];
        AVAsset *video1Asset = [AVAsset assetWithURL:self.video1];
        AVAsset *video2Asset = [AVAsset assetWithURL:self.video2];
        
        STAssertNotNil(mergedVideo, @"mergedVideo should not be null");
        
        int mergedVideoDuration = lroundf(CMTimeGetSeconds(mergedVideo.duration));
        Float64 video1Duration = CMTimeGetSeconds(video1Asset.duration);
        Float64 video2Duration = CMTimeGetSeconds(video2Asset.duration);
        int video1AndVideo2Duration = lroundf(video1Duration + video2Duration);
        
        // Testing that the duration of the merged video equals the sum of the 2 videos
        STAssertTrue(mergedVideoDuration == video1AndVideo2Duration, @"merged video duration is %d while the sum of video 1 and video 2 duration is %d", mergedVideoDuration, video1AndVideo2Duration);
        
        NSLog(@"Exporter URL: %@", exporter.outputURL.description);
        
        dispatch_group_leave(dispatchGroup);
    }];
    
    dispatch_group_wait(dispatchGroup, DISPATCH_TIME_FOREVER);
}

@end
