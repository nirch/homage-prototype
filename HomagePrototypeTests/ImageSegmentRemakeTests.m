//
//  ImageSegmentRemakeTests.m
//  HomagePrototype
//
//  Created by Tomer Harry on 10/10/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "HMGImageSegmentRemake.h"
#import "AGWaitForAsyncTestHelper.h"
#import "HMGImageSegment.h"

@interface ImageSegmentRemakeTests : SenTestCase

@property (strong, nonatomic) HMGImageSegmentRemake *imageSegmentRemake;

@property (strong, nonatomic) NSMutableArray *resourcesToDelete;

@property (strong, nonatomic) UIImage *image1;
@property (strong, nonatomic) UIImage *image2;
@property (strong, nonatomic) UIImage *image3;


@end

static NSString * const image1Name = @"Neta_juice.PNG";
static NSString * const image2Name = @"legs.png";
static NSString * const image3Name = @"falling.PNG";


@implementation ImageSegmentRemakeTests

- (void)setUp
{
    [super setUp];
    
    NSString *image1Path = [[NSBundle bundleForClass:[self class]] pathForResource:image1Name ofType:nil];
    self.image1 = [UIImage imageWithContentsOfFile:image1Path];
    
    NSString *image2Path = [[NSBundle bundleForClass:[self class]] pathForResource:image2Name ofType:nil];
    self.image2 = [UIImage imageWithContentsOfFile:image2Path];
    
    NSString *image3Path = [[NSBundle bundleForClass:[self class]] pathForResource:image3Name ofType:nil];
    self.image3 = [UIImage imageWithContentsOfFile:image3Path];
    
    HMGImageSegment *imageSegment = [[HMGImageSegment alloc] init];
    imageSegment.duration = CMTimeMake(5000, 1000);
    
    self.imageSegmentRemake = [[HMGImageSegmentRemake alloc] init];
    self.imageSegmentRemake.segment = imageSegment;
    
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


- (void)testProcessSingleImage
{
    self.imageSegmentRemake.images = @[self.image1];
    __block BOOL jobDone = NO;
    
    [self.imageSegmentRemake processVideoAsynchronouslyWithCompletionHandler:^(NSURL *videoURL, NSError *error) {
        STAssertNotNil(videoURL, @"video URL should not be nil");
        NSLog(@"video URL = %@", videoURL.description);
        
        STAssertNil(error, @"error should be nil, but is isn't. Error description = %@", error.description);

        // Adding the URL to the array of resources that should be deleted in the tear-down method
        [self.resourcesToDelete addObject:videoURL];
        
        AVAsset *outputVideoAsset = [AVAsset assetWithURL:videoURL];
        STAssertTrue(CMTIME_COMPARE_INLINE(outputVideoAsset.duration, ==, self.imageSegmentRemake.segment.duration), @"Output video duration and video segment duration should be equal but they are %.5f and %.5f", CMTimeGetSeconds(outputVideoAsset.duration), CMTimeGetSeconds(self.imageSegmentRemake.segment.duration));
        
        STAssertTrue(self.imageSegmentRemake.takes.count == 1, @"The count of takes should be 1, but it is %d", self.imageSegmentRemake.takes.count);
        
        STAssertTrue(self.imageSegmentRemake.selectedTakeIndex == 0, @"The selected takes index should be 0, but it is %d", self.imageSegmentRemake.selectedTakeIndex);
        
        jobDone = YES;
    }];
    
    WAIT_WHILE(!jobDone, 3);
}

- (void)testProcessMultipleImages
{
    self.imageSegmentRemake.images = @[self.image1, self.image2, self.image3];
    __block BOOL jobDone = NO;
    
    [self.imageSegmentRemake processVideoAsynchronouslyWithCompletionHandler:^(NSURL *videoURL, NSError *error) {
        STAssertNotNil(videoURL, @"video URL should not be nil");
        NSLog(@"video URL = %@", videoURL.description);
        
        STAssertNil(error, @"error should be nil, but is isn't. Error description = %@", error.description);
        
        // Adding the URL to the array of resources that should be deleted in the tear-down method
        [self.resourcesToDelete addObject:videoURL];
        
        AVAsset *outputVideoAsset = [AVAsset assetWithURL:videoURL];
        int outputVideoDuration = lroundf(CMTimeGetSeconds(outputVideoAsset.duration));
        int originalDuration = lroundf(CMTimeGetSeconds(self.imageSegmentRemake.segment.duration));
        STAssertTrue(outputVideoDuration == originalDuration, @"Output video duration and video segment duration should be equal but they are %d and %d", outputVideoDuration, originalDuration);
        
        STAssertTrue(self.imageSegmentRemake.takes.count == 1, @"The count of takes should be 1, but it is %d", self.imageSegmentRemake.takes.count);
        
        STAssertTrue(self.imageSegmentRemake.selectedTakeIndex == 0, @"The selected takes index should be 0, but it is %d", self.imageSegmentRemake.selectedTakeIndex);
        
        jobDone = YES;
    }];
    
    WAIT_WHILE(!jobDone, 3);
}

- (void)testProcessZeroImages
{
    self.imageSegmentRemake.images = @[];
    
    STAssertThrows([self.imageSegmentRemake processVideoAsynchronouslyWithCompletionHandler:^(NSURL *videoURL, NSError *error) {
        STFail(@"shouldn't reach this block");    }], @"should throw an InvalidArgumentException when passing a zero images array");

    STAssertTrue(self.imageSegmentRemake.takes.count == 0, @"The count of takes should be 0, but it is %d", self.imageSegmentRemake.takes.count);
    
    STAssertTrue(self.imageSegmentRemake.selectedTakeIndex == -1, @"The selected takes index should be -1, but it is %d", self.imageSegmentRemake.selectedTakeIndex);
}

- (void)testProcessNilImages
{
    self.imageSegmentRemake.images = nil;
    
    STAssertThrows([self.imageSegmentRemake processVideoAsynchronouslyWithCompletionHandler:^(NSURL *videoURL, NSError *error) {
        STFail(@"shouldn't reach this block");    }], @"should throw an InvalidArgumentException when passing a zero images array");
    
    STAssertTrue(self.imageSegmentRemake.takes.count == 0, @"The count of takes should be 0, but it is %d", self.imageSegmentRemake.takes.count);
    
    STAssertTrue(self.imageSegmentRemake.selectedTakeIndex == -1, @"The selected takes index should be -1, but it is %d", self.imageSegmentRemake.selectedTakeIndex);
}


@end
