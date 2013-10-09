//
//  AVUtilsTests.m
//  HomagePrototype
//
//  Created by Tomer Harry on 9/29/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "HMGAVUtils.h"
#import "AGWaitForAsyncTestHelper.h"

@interface AVUtilsTests : SenTestCase

@property (strong, nonatomic) NSMutableArray *resourcesToDelete;

@property (strong, nonatomic) NSURL *video1;
@property (strong, nonatomic) NSURL *video2;
@property (strong, nonatomic) NSURL *soundtrack;
@property (strong, nonatomic) UIImage *image1;
@property (strong, nonatomic) UIImage *image2;
@property (strong, nonatomic) UIImage *image3;
@property (strong, nonatomic) NSURL *videoForText;
@property (strong, nonatomic) UIImage *backgroundImage;



@end

static NSString * const video1Name = @"Red.mov";
static NSString * const video2Name = @"Tikim_Text.mp4";
static NSString * const soundtrackName = @"Homage_Tikim.mp3";

static NSString * const image1Name = @"Neta_juice.PNG";
static NSString * const image2Name = @"legs.png";
static NSString * const image3Name = @"falling.PNG";

static NSString * const videoForTextName = @"Red.mov";

static NSString * const backgroundImageName = @"wood.jpg";





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

    NSString *image1Path = [[NSBundle bundleForClass:[self class]] pathForResource:image1Name ofType:nil];
    self.image1 = [UIImage imageWithContentsOfFile:image1Path];
    
    NSString *image2Path = [[NSBundle bundleForClass:[self class]] pathForResource:image2Name ofType:nil];
    self.image2 = [UIImage imageWithContentsOfFile:image2Path];

    NSString *image3Path = [[NSBundle bundleForClass:[self class]] pathForResource:image3Name ofType:nil];
    self.image3 = [UIImage imageWithContentsOfFile:image3Path];

    NSString *videoForTextPath = [[NSBundle bundleForClass:[self class]] pathForResource:videoForTextName ofType:nil];
    self.videoForText = [NSURL fileURLWithPath:videoForTextPath];

    NSString *backgroundImagePath = [[NSBundle bundleForClass:[self class]] pathForResource:backgroundImageName ofType:nil];
    self.backgroundImage = [UIImage imageWithContentsOfFile:backgroundImagePath];

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


- (void)testMergeSingleVideoWithSoundtrack
{
    NSArray *videosToMerge = @[self.video1];
    
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
        
        STAssertNotNil(mergedVideo, @"mergedVideo should not be null");
        
        int mergedVideoDuration = lroundf(CMTimeGetSeconds(mergedVideo.duration));
        int video1Duration = lroundf(CMTimeGetSeconds(video1Asset.duration));
        
        // Testing that the duration of the merged video equals the duration of the first video
        STAssertTrue(mergedVideoDuration == video1Duration, @"merged video duration is %d while the duration of video 1 is %d", mergedVideoDuration, video1Duration);
        
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


- (void)testMergeZeroVideos
{
    NSArray *videosToMerge = [[NSArray alloc] init];
    
    STAssertThrows([HMGAVUtils mergeVideos:videosToMerge withSoundtrack:nil completion:^(AVAssetExportSession *exporter) {
        NSLog(@"in the exporter completion block");
        STFail(@"Shouldn't reach this completion block");
        // Adding the URL to the array of resources that should be deleted in the tear-down method
        [self.resourcesToDelete addObject:exporter.outputURL];
        NSLog(@"Exporter URL: %@", exporter.outputURL.description);
    }], @"This expression should thrown an exception, check the file system for damaged video leftover");
}

- (void)testScaleSlower
{
    CMTime tenSeconds = CMTimeMake(10000, 1000);
    
    // Creating a dispatch group so we can wait for the below async block to complete
    dispatch_group_t dispatchGroup = dispatch_group_create();
    dispatch_group_enter(dispatchGroup);
    
    [HMGAVUtils scaleVideo:self.video2 toDuration:tenSeconds completion:^(AVAssetExportSession *exporter) {
        NSLog(@"in the exporter completion block");

        // Testing that the status is completed
        STAssertTrue(exporter.status == AVAssetExportSessionStatusCompleted, @"The status is %d, but should have been %d (completed)", exporter.status, AVAssetExportSessionStatusCompleted);
        
        // Adding the URL to the array of resources that should be deleted in the tear-down method
        [self.resourcesToDelete addObject:exporter.outputURL];
        
        AVAsset *scaledVideo = [AVAsset assetWithURL:exporter.outputURL];
        int expectedDuration = lroundf(CMTimeGetSeconds(tenSeconds));
        int scaledVideoDuration = lroundf(CMTimeGetSeconds(scaledVideo.duration));
        
        STAssertTrue(scaledVideoDuration == expectedDuration, @"The scaled video duration should be %d seconds, while it is %d seconds", expectedDuration, scaledVideoDuration);
        
        // This will release the dispatch_group_wait
        dispatch_group_leave(dispatchGroup);
    }];
    
    int timeoutInSeconds = 3;
    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, timeoutInSeconds * NSEC_PER_SEC);
    long response = dispatch_group_wait(dispatchGroup, timeout);
    STAssertTrue(response == 0, @"timeout for waiting for async block to complete");
}

- (void)testScaleFaster
{
    CMTime oneSecond = CMTimeMake(1000, 1000);
    
    // Creating a dispatch group so we can wait for the below async block to complete
    dispatch_group_t dispatchGroup = dispatch_group_create();
    dispatch_group_enter(dispatchGroup);
    
    [HMGAVUtils scaleVideo:self.video2 toDuration:oneSecond completion:^(AVAssetExportSession *exporter) {
        NSLog(@"in the exporter completion block");
        
        // Testing that the status is completed
        STAssertTrue(exporter.status == AVAssetExportSessionStatusCompleted, @"The status is %d, but should have been %d (completed)", exporter.status, AVAssetExportSessionStatusCompleted);
        
        // Adding the URL to the array of resources that should be deleted in the tear-down method
        [self.resourcesToDelete addObject:exporter.outputURL];
        
        AVAsset *scaledVideo = [AVAsset assetWithURL:exporter.outputURL];
        int expectedDuration = lroundf(CMTimeGetSeconds(oneSecond));
        int scaledVideoDuration = lroundf(CMTimeGetSeconds(scaledVideo.duration));
        
        STAssertTrue(scaledVideoDuration == expectedDuration, @"The scaled video duration should be %d seconds, while it is %d seconds", expectedDuration, scaledVideoDuration);
        
        // This will release the dispatch_group_wait
        dispatch_group_leave(dispatchGroup);
    }];
    
    int timeoutInSeconds = 3;
    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, timeoutInSeconds * NSEC_PER_SEC);
    long response = dispatch_group_wait(dispatchGroup, timeout);
    STAssertTrue(response == 0, @"timeout for waiting for async block to complete");
}

- (void)testImagesToVideoMutipleImagesFastDuration
{
    NSArray *images = @[self.image1, self.image2, self.image3];
    CMTime imageDuration = CMTimeMake(500, 1000);
    __block BOOL jobDone = NO;
    
    [HMGAVUtils imagesToVideo:images withFrameTime:imageDuration completion:^(AVAssetWriter *assetWriter) {
        NSLog(@"in the writer completion block");
        
        // Testing that the status is completed
        STAssertTrue(assetWriter.status == AVAssetWriterStatusCompleted, @"The status is %d, but should have been %d (completed)", assetWriter.status, AVAssetWriterStatusCompleted);
        
        // Adding the URL to the array of resources that should be deleted in the tear-down method
        [self.resourcesToDelete addObject:assetWriter.outputURL];
        
        AVAsset *imagesVideo = [AVAsset assetWithURL:assetWriter.outputURL];
        CMTime expectedDuration = CMTimeMultiply(imageDuration, images.count);
        CMTime imagesVideoDuration = imagesVideo.duration;
        
        STAssertTrue(CMTIME_COMPARE_INLINE(expectedDuration, ==, imagesVideoDuration), @"The images video duration should be %d seconds, while it is %d seconds", expectedDuration, imagesVideoDuration);
        
        jobDone = YES;
    }];
    
    WAIT_WHILE(!jobDone, 3);
}

- (void)testImagesToVideoMutipleImagesSlowDuration
{
    NSArray *images = @[self.image1, self.image2, self.image3];
    CMTime imageDuration = CMTimeMake(5000, 1000);
    __block BOOL jobDone = NO;
    
    [HMGAVUtils imagesToVideo:images withFrameTime:imageDuration completion:^(AVAssetWriter *assetWriter) {
        NSLog(@"in the writer completion block");
        
        // Testing that the status is completed
        STAssertTrue(assetWriter.status == AVAssetWriterStatusCompleted, @"The status is %d, but should have been %d (completed)", assetWriter.status, AVAssetWriterStatusCompleted);
        
        // Adding the URL to the array of resources that should be deleted in the tear-down method
        [self.resourcesToDelete addObject:assetWriter.outputURL];
        
        AVAsset *imagesVideo = [AVAsset assetWithURL:assetWriter.outputURL];
        CMTime expectedDuration = CMTimeMultiply(imageDuration, images.count);
        CMTime imagesVideoDuration = imagesVideo.duration;
        
        STAssertTrue(CMTIME_COMPARE_INLINE(expectedDuration, ==, imagesVideoDuration), @"The images video duration should be %d seconds, while it is %d seconds", expectedDuration, imagesVideoDuration);
        
        jobDone = YES;
    }];
    
    WAIT_WHILE(!jobDone, 3);
}

- (void)testImagesToVideoSingleImage
{
    NSArray *images = @[self.image1];
    CMTime imageDuration = CMTimeMake(3000, 1000);
    __block BOOL jobDone = NO;
    
    [HMGAVUtils imagesToVideo:images withFrameTime:imageDuration completion:^(AVAssetWriter *assetWriter) {
        NSLog(@"in the writer completion block");
        
        // Testing that the status is completed
        STAssertTrue(assetWriter.status == AVAssetWriterStatusCompleted, @"The status is %d, but should have been %d (completed)", assetWriter.status, AVAssetWriterStatusCompleted);
        
        // Adding the URL to the array of resources that should be deleted in the tear-down method
        [self.resourcesToDelete addObject:assetWriter.outputURL];
        
        AVAsset *imagesVideo = [AVAsset assetWithURL:assetWriter.outputURL];
        CMTime expectedDuration = CMTimeMultiply(imageDuration, images.count);
        CMTime imagesVideoDuration = imagesVideo.duration;
        
        STAssertTrue(CMTIME_COMPARE_INLINE(expectedDuration, ==, imagesVideoDuration), @"The images video duration should be %d seconds, while it is %d seconds", expectedDuration, imagesVideoDuration);
        
        jobDone = YES;
    }];
    
    WAIT_WHILE(!jobDone, 3);
}

- (void)testTextOnVideoDefaultFont
{
    NSString *text = @"Testing Text";
    NSString* fontName = @"Helvetica";
    CGFloat fontSize = 72;
    __block BOOL jobDone = NO;
    
    [HMGAVUtils textOnVideo:self.videoForText withText:text withFontName:fontName withFontSize:fontSize completion:^(AVAssetExportSession *exporter) {
        NSLog(@"in the exporter completion block");
        
        STAssertTrue(exporter.status == AVAssetExportSessionStatusCompleted, @"The status is %d, but should have been %d", exporter.status, AVAssetExportSessionStatusCompleted);
        
        // Adding the URL to the array of resources that should be deleted in the tear-down method
        [self.resourcesToDelete addObject:exporter.outputURL];
        
        AVAsset *textVideo = [AVAsset assetWithURL:exporter.outputURL];
        AVAsset *originalVideo = [AVAsset assetWithURL:self.video1];
        
        STAssertNotNil(textVideo, @"textVideo should not be null");
        
        int textVideoDuration = lroundf(CMTimeGetSeconds(textVideo.duration));
        int originalVideoDuration = lroundf(CMTimeGetSeconds(originalVideo.duration));
        
        // Testing that the duration of the merged video equals the duration of the first video
        STAssertTrue(textVideoDuration == originalVideoDuration, @"text video duration is %d while the duration of original video is %d, they should be the same", textVideoDuration, originalVideoDuration);
        
        NSLog(@"Exporter URL: %@", exporter.outputURL.description);
        
        jobDone = YES;
    }];
    
    WAIT_WHILE(!jobDone, 3);
}

- (void)testTextOnVideoOtherFontAndSize
{
    NSString *text = @"Testing Text";
    NSString* fontName = @"Times";
    CGFloat fontSize = 48;
    __block BOOL jobDone = NO;
    
    [HMGAVUtils textOnVideo:self.videoForText withText:text withFontName:fontName withFontSize:fontSize completion:^(AVAssetExportSession *exporter) {
        NSLog(@"in the exporter completion block");
        
        STAssertTrue(exporter.status == AVAssetExportSessionStatusCompleted, @"The status is %d, but should have been %d", exporter.status, AVAssetExportSessionStatusCompleted);
        
        // Adding the URL to the array of resources that should be deleted in the tear-down method
        [self.resourcesToDelete addObject:exporter.outputURL];
        
        AVAsset *textVideo = [AVAsset assetWithURL:exporter.outputURL];
        AVAsset *originalVideo = [AVAsset assetWithURL:self.video1];
        
        STAssertNotNil(textVideo, @"textVideo should not be null");
        
        int textVideoDuration = lroundf(CMTimeGetSeconds(textVideo.duration));
        int originalVideoDuration = lroundf(CMTimeGetSeconds(originalVideo.duration));
        
        // Testing that the duration of the merged video equals the duration of the first video
        STAssertTrue(textVideoDuration == originalVideoDuration, @"text video duration is %d while the duration of original video is %d, they should be the same", textVideoDuration, originalVideoDuration);
        
        NSLog(@"Exporter URL: %@", exporter.outputURL.description);
        
        jobDone = YES;
    }];
    
    WAIT_WHILE(!jobDone, 3);
}

// This test will take an image, transform it to a video, and then put a text on the video
- (void)testTextOnImage
{
    NSArray *backgroundImageArray = @[self.backgroundImage];
    CMTime frameTime = CMTimeMake(3000, 1000);
    __block NSURL *videoBackgroundURL;
    __block BOOL jobDone = NO;
    
    [HMGAVUtils imagesToVideo:backgroundImageArray withFrameTime:frameTime completion:^(AVAssetWriter *assetWriter) {

        // Testing that the status is completed
        STAssertTrue(assetWriter.status == AVAssetWriterStatusCompleted, @"The status is %d, but should have been %d (completed)", assetWriter.status, AVAssetWriterStatusCompleted);
        
        // Adding the URL to the array of resources that should be deleted in the tear-down method
        [self.resourcesToDelete addObject:assetWriter.outputURL];
        
        videoBackgroundURL = assetWriter.outputURL;
        
        jobDone = YES;

    }];
    
    WAIT_WHILE(!jobDone, 3);
    
    NSString *text = @"Testing Text";
    NSString* fontName = @"Helvetica";
    CGFloat fontSize = 72;
    jobDone = NO;
    
    [HMGAVUtils textOnVideo:videoBackgroundURL withText:text withFontName:fontName withFontSize:fontSize completion:^(AVAssetExportSession *exporter) {
        NSLog(@"in the exporter completion block");
        
        STAssertTrue(exporter.status == AVAssetExportSessionStatusCompleted, @"The status is %d, but should have been %d", exporter.status, AVAssetExportSessionStatusCompleted);
        
        // Adding the URL to the array of resources that should be deleted in the tear-down method
        [self.resourcesToDelete addObject:exporter.outputURL];
        
        AVAsset *textVideo = [AVAsset assetWithURL:exporter.outputURL];
        AVAsset *originalVideo = [AVAsset assetWithURL:self.video1];
        
        STAssertNotNil(textVideo, @"textVideo should not be null");
        
        int textVideoDuration = lroundf(CMTimeGetSeconds(textVideo.duration));
        int originalVideoDuration = lroundf(CMTimeGetSeconds(originalVideo.duration));
        
        // Testing that the duration of the merged video equals the duration of the first video
        STAssertTrue(textVideoDuration == originalVideoDuration, @"text video duration is %d while the duration of original video is %d, they should be the same", textVideoDuration, originalVideoDuration);
        
        NSLog(@"Exporter URL: %@", exporter.outputURL.description);
        
        jobDone = YES;
    }];
    
    WAIT_WHILE(!jobDone, 3);

}



@end
