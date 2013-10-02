//
//  VideoSegmentRemakeTests.m
//  HomagePrototype
//
//  Created by Tomer Harry on 10/1/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "HMGVideoSegmentRemake.h"
#import "HMGVideoSegment.h"
#import <AVFoundation/AVFoundation.h>
#import "AGWaitForAsyncTestHelper.h"

@interface VideoSegmentRemakeTests : SenTestCase

@property (strong, nonatomic) NSMutableArray *resourcesToDelete;

@property (strong, nonatomic) HMGVideoSegmentRemake *videoSegmentRemake;

@property (strong, nonatomic) HMGVideoSegment *tikimTextVideoSegmentFastDuration;
@property (strong, nonatomic) HMGVideoSegment *tikimTextVideoSegmentSlowDuration;
@property (strong, nonatomic) HMGVideoSegment *tikimTextVideoSegmentEqualDuration;

@property (strong, nonatomic) NSURL *redVideo;
@property (strong, nonatomic) NSURL *timikTextVideo;

@end

static NSString * const redVideoName = @"Red.mov";
static NSString * const tikimTextVideoName = @"Tikim_Text.mp4";

@implementation VideoSegmentRemakeTests

- (void)setUp
{
    [super setUp];
    
    NSString *redVideoPath = [[NSBundle bundleForClass:[self class]] pathForResource:redVideoName ofType:nil];
    self.redVideo = [NSURL fileURLWithPath:redVideoPath];
    
    NSString *tikimTextVideoPath = [[NSBundle bundleForClass:[self class]] pathForResource:tikimTextVideoName ofType:nil];
    self.timikTextVideo = [NSURL fileURLWithPath:tikimTextVideoPath];
    
    self.resourcesToDelete = [[NSMutableArray alloc] init];
    
    self.videoSegmentRemake = [[HMGVideoSegmentRemake alloc] init];
    
    self.tikimTextVideoSegmentFastDuration = [[HMGVideoSegment alloc] init];
    AVAsset *tikimTextAsset = [AVAsset assetWithURL:self.timikTextVideo];
    self.tikimTextVideoSegmentFastDuration.recordDuration = tikimTextAsset.duration;
    self.tikimTextVideoSegmentFastDuration.duration = CMTimeMake(1000, 1000);
    
    self.tikimTextVideoSegmentSlowDuration = [[HMGVideoSegment alloc] init];
    self.tikimTextVideoSegmentSlowDuration.recordDuration = tikimTextAsset.duration;
    self.tikimTextVideoSegmentSlowDuration.duration = CMTimeMake(10000, 1000);
    
    self.tikimTextVideoSegmentEqualDuration = [[HMGVideoSegment alloc] init];
    self.tikimTextVideoSegmentEqualDuration.recordDuration = tikimTextAsset.duration;
    self.tikimTextVideoSegmentEqualDuration.duration = tikimTextAsset.duration;
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

- (void)testProcessSingleVideoDurationFaster
{
    self.videoSegmentRemake.segment = self.tikimTextVideoSegmentFastDuration;
    self.videoSegmentRemake.video = self.timikTextVideo;
    
    // Creating a dispatch group so we can wait for the below async block to complete
    dispatch_group_t dispatchGroup = dispatch_group_create();
    dispatch_group_enter(dispatchGroup);
    
    [self.videoSegmentRemake processVideoAsynchronouslyWithCompletionHandler:^(NSURL *videoURL, NSError *error) {
        NSLog(@"inside the completion hamdler");

        STAssertNotNil(videoURL, @"video URL should not be nil");
        NSLog(@"video URL = %@", videoURL.description);
        
        // Adding the URL to the array of resources that should be deleted in the tear-down method
        [self.resourcesToDelete addObject:videoURL];
        
        AVAsset *outputVideoAsset = [AVAsset assetWithURL:videoURL];
        STAssertTrue(CMTIME_COMPARE_INLINE(outputVideoAsset.duration, ==, self.videoSegmentRemake.segment.duration), @"Output video duration and video segment duration should be equal but they are %.5f and %.5f", CMTimeGetSeconds(outputVideoAsset.duration), CMTimeGetSeconds(self.videoSegmentRemake.segment.duration));
        
        STAssertNil(error, @"error should be nil, but is isn't. Error description = %@", error.description);
        
        STAssertTrue(self.videoSegmentRemake.takes.count == 1, @"The count of takes should be 1, but it is %d", self.videoSegmentRemake.takes.count);
        
        STAssertTrue(self.videoSegmentRemake.selectedTakeIndex == 0, @"The selected takes index should be 0, but it is %d", self.videoSegmentRemake.selectedTakeIndex);
        
        // This will release the dispatch_group_wait
        dispatch_group_leave(dispatchGroup);
    }];
    
    
    int timeoutInSeconds = 3;
    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, timeoutInSeconds * NSEC_PER_SEC);
    long response = dispatch_group_wait(dispatchGroup, timeout);
    STAssertTrue(response == 0, @"timeout for waiting for async block to complete");
}

- (void)testProcessSingleVideoDurationSlower
{
    self.videoSegmentRemake.segment = self.tikimTextVideoSegmentSlowDuration;
    self.videoSegmentRemake.video = self.timikTextVideo;
    
    // Creating a dispatch group so we can wait for the below async block to complete
    dispatch_group_t dispatchGroup = dispatch_group_create();
    dispatch_group_enter(dispatchGroup);
    
    [self.videoSegmentRemake processVideoAsynchronouslyWithCompletionHandler:^(NSURL *videoURL, NSError *error) {
        NSLog(@"inside the completion hamdler");
        
        STAssertNotNil(videoURL, @"video URL should not be nil");
        NSLog(@"video URL = %@", videoURL.description);
        
        // Adding the URL to the array of resources that should be deleted in the tear-down method
        [self.resourcesToDelete addObject:videoURL];
        
        AVAsset *outputVideoAsset = [AVAsset assetWithURL:videoURL];
        STAssertTrue(CMTIME_COMPARE_INLINE(outputVideoAsset.duration, ==, self.videoSegmentRemake.segment.duration), @"Output video duration and video segment duration should be equal but they are %.5f and %.5f", CMTimeGetSeconds(outputVideoAsset.duration), CMTimeGetSeconds(self.videoSegmentRemake.segment.duration));
        
        STAssertNil(error, @"error should be nil, but is isn't. Error description = %@", error.description);
        
        STAssertTrue(self.videoSegmentRemake.takes.count == 1, @"The count of takes should be 1, but it is %d", self.videoSegmentRemake.takes.count);
        
        STAssertTrue(self.videoSegmentRemake.selectedTakeIndex == 0, @"The selected takes index should be 0, but it is %d", self.videoSegmentRemake.selectedTakeIndex);
        
        // This will release the dispatch_group_wait
        dispatch_group_leave(dispatchGroup);
    }];
    
    
    int timeoutInSeconds = 3;
    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, timeoutInSeconds * NSEC_PER_SEC);
    long response = dispatch_group_wait(dispatchGroup, timeout);
    STAssertTrue(response == 0, @"timeout for waiting for async block to complete");
}

- (void)testProcessSingleVideoDurationEquals
{
    self.videoSegmentRemake.segment = self.tikimTextVideoSegmentEqualDuration;
    self.videoSegmentRemake.video = self.timikTextVideo;
    
    __block BOOL jobDone = NO;
    
    [self.videoSegmentRemake processVideoAsynchronouslyWithCompletionHandler:^(NSURL *videoURL, NSError *error) {
        NSLog(@"inside the completion hamdler");
        
        STAssertNotNil(videoURL, @"video URL should not be nil");
        NSLog(@"video URL = %@", videoURL.description);
        
        // Adding the URL to the array of resources that should be deleted in the tear-down method
        [self.resourcesToDelete addObject:videoURL];
        
        AVAsset *outputVideoAsset = [AVAsset assetWithURL:videoURL];
        STAssertTrue(CMTIME_COMPARE_INLINE(outputVideoAsset.duration, ==, self.videoSegmentRemake.segment.duration), @"Output video duration and video segment duration should be equal but they are %.5f and %.5f", CMTimeGetSeconds(outputVideoAsset.duration), CMTimeGetSeconds(self.videoSegmentRemake.segment.duration));
        
        STAssertNil(error, @"error should be nil, but is isn't. Error description = %@", error.description);
        
        STAssertTrue(self.videoSegmentRemake.takes.count == 1, @"The count of takes should be 1, but it is %d", self.videoSegmentRemake.takes.count);
        
        STAssertTrue(self.videoSegmentRemake.selectedTakeIndex == 0, @"The selected takes index should be 0, but it is %d", self.videoSegmentRemake.selectedTakeIndex);
        
        jobDone = YES;
    }];
    
    // Waiting 3 seconds for the above block to complete
    WAIT_WHILE(!jobDone, 3);
}

- (void)testProcessMultipleVideosDurationEquals
{
    //STFail(@"No implementation for \"%s\"", x__PRETTY_FUNCTION__);
}

- (void)testProcessMultipleVideosDurationFaster
{
    //STFail(@"No implementation for \"%s\"", x__PRETTY_FUNCTION__);
}


@end
