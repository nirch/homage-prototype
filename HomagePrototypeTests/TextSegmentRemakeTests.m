//
//  TextSegmentRemakeTests.m
//  HomagePrototype
//
//  Created by Tomer Harry on 10/13/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "HMGTextSegmentRemake.h"
#import "HMGTextSegment.h"
#import "AGWaitForAsyncTestHelper.h"


@interface TextSegmentRemakeTests : SenTestCase

@property (strong, nonatomic) HMGTextSegment *textSegmentVideo;
@property (strong, nonatomic) HMGTextSegmentRemake *textSegmentRemake;
@property (strong, nonatomic) NSMutableArray *resourcesToDelete;
@property (strong, nonatomic) NSURL *videoBackground;

@end

static NSString * const videoBackgroundName = @"Red.mov";


@implementation TextSegmentRemakeTests

- (void)setUp
{
    [super setUp];
    
    NSString *videoBackgroundPath = [[NSBundle bundleForClass:[self class]] pathForResource:videoBackgroundName ofType:nil];
    self.videoBackground = [NSURL fileURLWithPath:videoBackgroundPath];
    
    self.textSegmentVideo = [[HMGTextSegment alloc] init];
    self.textSegmentVideo.font = @"Helvetica";
    self.textSegmentVideo.fontSize = 72;
    self.textSegmentVideo.video = self.videoBackground;
    
    self.textSegmentRemake = [[HMGTextSegmentRemake alloc] init];
    self.textSegmentRemake.segment = self.textSegmentVideo;
    
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

- (void)testProcessVideoEnglishText
{
    self.textSegmentRemake.text = @"Channes Family";
    __block BOOL jobDone = NO;
    
    [self.textSegmentRemake processVideoAsynchronouslyWithCompletionHandler:^(NSURL *videoURL, NSError *error) {
        STAssertNotNil(videoURL, @"video URL should not be nil");
        NSLog(@"video URL = %@", videoURL);
        
        STAssertNil(error, @"error should be nil, but is isn't. Error description = %@", error.description);
        
        // Adding the URL to the array of resources that should be deleted in the tear-down method
        [self.resourcesToDelete addObject:videoURL];
        
        AVAsset *outputVideoAsset = [AVAsset assetWithURL:videoURL];
        AVAsset *originalVideoAsset = [AVAsset assetWithURL:self.textSegmentRemake.segment.video];
        int outputVideoDuration = lroundf(CMTimeGetSeconds(outputVideoAsset.duration));
        int originalDuration = lroundf(CMTimeGetSeconds(originalVideoAsset.duration));
        STAssertTrue(outputVideoDuration == originalDuration, @"Output video duration and video segment duration should be equal but they are %d and %d", outputVideoDuration, originalDuration);
        
        STAssertTrue(self.textSegmentRemake.takes.count == 1, @"The count of takes should be 1, but it is %d", self.textSegmentRemake.takes.count);
        
        STAssertTrue(self.textSegmentRemake.selectedTakeIndex == 0, @"The selected takes index should be 0, but it is %d", self.textSegmentRemake.selectedTakeIndex);
        
        jobDone = YES;

    }];
    
    WAIT_WHILE(!jobDone, 3);
}

- (void)testProcessVideoHebrewText
{
    self.textSegmentRemake.text = @"משפחת הרי";
    __block BOOL jobDone = NO;
    
    [self.textSegmentRemake processVideoAsynchronouslyWithCompletionHandler:^(NSURL *videoURL, NSError *error) {
        STAssertNotNil(videoURL, @"video URL should not be nil");
        NSLog(@"video URL = %@", videoURL);
        
        STAssertNil(error, @"error should be nil, but is isn't. Error description = %@", error.description);
        
        // Adding the URL to the array of resources that should be deleted in the tear-down method
        [self.resourcesToDelete addObject:videoURL];
        
        AVAsset *outputVideoAsset = [AVAsset assetWithURL:videoURL];
        AVAsset *originalVideoAsset = [AVAsset assetWithURL:self.textSegmentRemake.segment.video];
        int outputVideoDuration = lroundf(CMTimeGetSeconds(outputVideoAsset.duration));
        int originalDuration = lroundf(CMTimeGetSeconds(originalVideoAsset.duration));
        STAssertTrue(outputVideoDuration == originalDuration, @"Output video duration and video segment duration should be equal but they are %d and %d", outputVideoDuration, originalDuration);
        
        STAssertTrue(self.textSegmentRemake.takes.count == 1, @"The count of takes should be 1, but it is %d", self.textSegmentRemake.takes.count);
        
        STAssertTrue(self.textSegmentRemake.selectedTakeIndex == 0, @"The selected takes index should be 0, but it is %d", self.textSegmentRemake.selectedTakeIndex);
        
        jobDone = YES;
        
    }];
    
    WAIT_WHILE(!jobDone, 3);
}


@end
