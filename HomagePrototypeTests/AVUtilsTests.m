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
@property (strong, nonatomic) NSURL *soundtrack;

@end

static NSString * const video1Name = @"Red.mov";
static NSString * const video2Name = @"Tikim_Text.mp4";
static NSString * const soundtrackName = @"Homage_Tikim.mp3";


@implementation AVUtilsTests

- (void)setUp
{
    [super setUp];

    NSString *video1Path = [[NSBundle bundleForClass:[self class]] pathForResource:video1Name ofType:nil];
    self.video1 = [NSURL fileURLWithPath:video1Path];
    
    NSString *video2Path = [[NSBundle bundleForClass:[self class]] pathForResource:video2Name ofType:nil];
    self.video2 = [NSURL fileURLWithPath:video2Path];

    NSString *soundtrackPath = [[NSBundle bundleForClass:[self class]] pathForResource:soundtrackName ofType:nil];
    self.soundtrack = [NSURL fileURLWithPath:soundtrackPath];

    self.resourcesToDelete = [[NSMutableArray alloc] init];
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
    
    // Creating a dispatch group so we can wait for the below async block to complete
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
        
        // Testing that the exported video (merged video) doesn't have an audio track
        STAssertTrue([[mergedVideo tracksWithMediaType:AVMediaTypeAudio] count] == 0, @"The exported video has an audio track while it shouldn't have");
        
        NSLog(@"Exporter URL: %@", exporter.outputURL.description);
        
        // This will release the dispatch_group_wait
        dispatch_group_leave(dispatchGroup);
    }];
    
    int timeoutInSeconds = 3;
    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, timeoutInSeconds * NSEC_PER_SEC);
    long response = dispatch_group_wait(dispatchGroup, timeout);
    STAssertTrue(response == 0, @"timeout for waiting for async block to complete");
}

- (void)testMergeVideosWithSoundtrack
{
    NSArray *videosToMerge = @[self.video1, self.video2];
    
    // Creating a dispatch group so we can wait for the below async block to complete
    dispatch_group_t dispatchGroup = dispatch_group_create();
    dispatch_group_enter(dispatchGroup);
    
    [HMGAVUtils mergeVideos:videosToMerge withSoundtrack:self.soundtrack completion:^(AVAssetExportSession *exporter) {
        
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
        
        // Testing that the exported video (merged video) has an audio track
        STAssertTrue([[mergedVideo tracksWithMediaType:AVMediaTypeAudio] count] == 1, @"The exported video doesn't have a single audio track, it has %d audio track", [[mergedVideo tracksWithMediaType:AVMediaTypeAudio] count]);
        
        NSLog(@"Exporter URL: %@", exporter.outputURL.description);
        
        // This will release the dispatch_group_wait
        dispatch_group_leave(dispatchGroup);
    }];
    
    int timeoutInSeconds = 3;
    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, timeoutInSeconds * NSEC_PER_SEC);
    long response = dispatch_group_wait(dispatchGroup, timeout);
    STAssertTrue(response == 0, @"timeout for waiting for async block to complete");
}


@end
