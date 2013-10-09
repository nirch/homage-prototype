//
//  HMGAVUtils.m
//  HomagePrototype
//
//  Created by Tomer Harry on 9/29/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGAVUtils.h"
#import "HMGLog.h"
#import "HMGFileManager.h"


@implementation HMGAVUtils

// This method receives a list of videos (URLs to the videos) and a soundtrack (URL to the soundtrack). The method merges the videos and soundtrack into a new video. The completion method will be called asynchronously once the new video is ready
+ (void)mergeVideos:(NSArray*)videoUrls withSoundtrack:(NSURL*)soundtrackURL completion:(void (^)(AVAssetExportSession*))completion
{
    HMGLogDebug(@"%s started", __PRETTY_FUNCTION__);
    
    // If video url array doesn't have at least one video, throwing an exception
    if (!(videoUrls.count > 0))
    {
        [NSException raise:@"InvalidArgumentException" format:@"videoUrls count of 0 is invalid (videoUrls count must be > 0)"];
    }
    
    // Creating the composition object. This object will hold the composition track instances
    AVMutableComposition *mainComposition = [[AVMutableComposition alloc] init];
    
    // Creating a composition track for the video which is also added to the main composition oject
    AVMutableCompositionTrack *compositionVideoTrack = [mainComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    // *** Step 1: Merging the videos ***
    
    // The time to insert a current video in the below loop (the first video will be inserted in zime zero, then the variable will be increased)
    CMTime insertTime = kCMTimeZero;
    
    // Looping over the videos and adding them (merging) to the main composition
    for(NSURL *videoURL in videoUrls)
    {
        // Creating a video asset for the current video URL
        AVAsset *videoAsset = [AVAsset assetWithURL:videoURL];
        
        // Checking if this URL is really a video
        NSArray *videoAssetVideoTracks = [videoAsset tracksWithMediaType:AVMediaTypeVideo];
        if (videoAssetVideoTracks.count == 0)
        {
            [NSException raise:@"InvalidArgumentException" format:@"videoURL <%@> doesn't have a video track", videoURL.description];
        }
        
        // Inserting the video to the composition track in the correct time range
        [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:[videoAssetVideoTracks objectAtIndex:0] atTime:insertTime error:nil];
        
        // Updating the insertTime for the next insert
        insertTime = CMTimeAdd(insertTime, videoAsset.duration);
    }
    
    // *** Step 2: Adding the soundtrack ***

    if (soundtrackURL)
    {
        // Creating an asset object from the soundtrack URL
        AVAsset *soundtrackAsset = [AVAsset assetWithURL:soundtrackURL];
        
        // Checking if this URL is really a video
        NSArray *soundtrackAssetAudioTracks = [soundtrackAsset tracksWithMediaType:AVMediaTypeAudio];
        if (soundtrackAssetAudioTracks.count == 0)
        {
            [NSException raise:@"InvalidArgumentException" format:@"soundtrackURL <%@> doesn't have an audio track", soundtrackURL.description];
        }
        
        // Creating a composition track for the soundtrack which is also added to the main composition oject
        AVMutableCompositionTrack *soundtrackTrack = [mainComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        
        // Inserting the soundtrack to the composition track in the correct time frame
        [soundtrackTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, insertTime) ofTrack:[soundtrackAssetAudioTracks objectAtIndex:0] atTime:kCMTimeZero error:nil];
    }
    
    // *** Step 3: Exporting the video ***
    
    NSURL *outptVideoUrl = [HMGFileManager uniqueUrlWithPrefix:@"mergeVideo-" ofType:@"mov"];
    
    // Creating an export session using the main composition
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mainComposition presetName:AVAssetExportPresetHighestQuality];
    
    // Setting attributes of the exporter
    exporter.outputURL=outptVideoUrl;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;

    HMGLogDebug(@"exporter output URL (before export): %@", exporter.outputURL.description);
    
    // Doing the actual export and setting the completion method that will be invoked asynchronously once the new video is ready
    [exporter exportAsynchronouslyWithCompletionHandler:^{ completion(exporter); }];
    
    HMGLogDebug(@"%s ended", __PRETTY_FUNCTION__);
}


// This methods scales the given video into a different duration (makes the video faster or slower). The completion method will be called asynchronously once the new video is ready
+ (void)scaleVideo:(NSURL*)videoURL toDuration:(CMTime)duration completion:(void (^)(AVAssetExportSession*))completion
{
    HMGLogDebug(@"%s started", __PRETTY_FUNCTION__);
    
    // If there is no video URL assiged we cannot proceed
    if (!videoURL)
    {
        [NSException raise:@"InvalidArgumentException" format:@"videoURL must not be null"];
    }
        
    // Creating the composition object. This object will hold the composition track instances
    AVMutableComposition *mainComposition = [[AVMutableComposition alloc] init];
    
    // Creating a composition track for the video which is also added to the main composition oject
    AVMutableCompositionTrack *compositionVideoTrack = [mainComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    // Creating a video asset for the current video URL
    AVAsset *videoAsset = [AVAsset assetWithURL:videoURL];
    
    // Checking if this URL is really a video
    NSArray *videoAssetVideoTracks = [videoAsset tracksWithMediaType:AVMediaTypeVideo];
    if (videoAssetVideoTracks.count == 0)
    {
        [NSException raise:@"InvalidArgumentException" format:@"videoURL <%@> doesn't have a video track", videoURL.description];
    }
    
    // Inserting the video to the composition track in the correct time range
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    // scaling the video (making it faster/slower)
    [compositionVideoTrack scaleTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) toDuration:duration];
    
    // Exporting the new scaled video
    
    NSURL *outptVideoUrl = [HMGFileManager uniqueUrlWithPrefix:@"scaleVideo-" ofType:@"mov"];
    
    // Creating an export session using the main composition
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mainComposition presetName:AVAssetExportPresetHighestQuality];
    
    // Setting attributes of the exporter
    exporter.outputURL=outptVideoUrl;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    
    // Doing the actual export and setting the completion method that will be invoked asynchronously once the new video is ready
    [exporter exportAsynchronouslyWithCompletionHandler:^{ completion(exporter); }];
    
    HMGLogDebug(@"%s ended", __PRETTY_FUNCTION__);
}

// This method transformes a list of images into a video. It receives an array of images (UIImage) and frame time in milliseconds for the time that each image will be displayed in the video. The completion method will be called asynchronously once the new video is ready
+ (void)imagesToVideo:(NSArray*)images withFrameTime:(CMTime)frameTime completion:(void (^)(AVAssetWriter*))completion
{
    NSError *error = nil;
    
    // Create the URL to which the video will be stored/saved    
    NSURL *outptUrl = [HMGFileManager uniqueUrlWithPrefix:@"imagesVideo-" ofType:@"mov"];

    
    // Creating the container to which the video will be written to
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:outptUrl fileType:AVFileTypeQuickTimeMovie
                                                              error:&error];
    NSParameterAssert(videoWriter);
    
    // Specifing settings for the new video (codec, width, hieght)
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   AVVideoCodecH264, AVVideoCodecKey,
                                   [NSNumber numberWithInt:640], AVVideoWidthKey,
                                   [NSNumber numberWithInt:480], AVVideoHeightKey,
                                   nil];
    
    // Creating a writer input
    AVAssetWriterInput* writerInput = [AVAssetWriterInput
                                       assetWriterInputWithMediaType:AVMediaTypeVideo
                                       outputSettings:videoSettings];
    
    NSParameterAssert(writerInput);
    NSParameterAssert([videoWriter canAddInput:writerInput]);
    
    // Connecting the writer input with the video wrtier
    [videoWriter addInput:writerInput];
    
    // Creating an AVAssetWriterInputPixelBufferAdaptor based on writerInput
    AVAssetWriterInputPixelBufferAdaptor *assetWriterInputPixelAdapter = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput sourcePixelBufferAttributes:nil];
    
    // Start writing
    [videoWriter startWriting];
    
    // The duration of each frame in the video is "frameTime". The present time for each fram will start at 0 and then we will add the frame time to the present time for each frame
    CMTime presentTime = CMTimeMake(0, frameTime.timescale);
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    // Looping over all the images we want to append to the video
    for(UIImage *image in images)
    {
        // Resizing image to 640:480
        UIImage *scaledImage = [self scaleImage:image toSize:CGSizeMake(640.0, 480.0)];
        
        // Appending image to asset writer
        BOOL appendSuccess = [assetWriterInputPixelAdapter appendPixelBuffer:[self newPixelBufferFromCGImage:scaledImage.CGImage] withPresentationTime:presentTime];
        NSLog(appendSuccess ? @"Append Success" : @"Append Failed");
        
        // Increasing the present time
        presentTime = CMTimeAdd(presentTime,frameTime);
    }
    
    // If there is only one image in the array, there is a need to append it again in the last time (otherwise the video will always be 0 seconds long)
    if (images.count == 1)
    {
        // Resizing image to 640:480
        UIImage *scaledImage = [self scaleImage:[images objectAtIndex:0] toSize:CGSizeMake(640.0, 480.0)];
        
        // Appending image to asset writer
        BOOL appendSuccess = [assetWriterInputPixelAdapter appendPixelBuffer:[self newPixelBufferFromCGImage:scaledImage.CGImage] withPresentationTime:presentTime];
        NSLog(appendSuccess ? @"Append Success" : @"Append Failed");
    }
    
    // Finishing the video. The actaul finish process is asynchronic, so we are assigning a completion handler to be invoked once the the video is ready
    [writerInput markAsFinished];
    [videoWriter endSessionAtSourceTime:presentTime];
    [videoWriter finishWritingWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(videoWriter);
        });
    }];
}

// This method addes text to video. It recevies a video (as a URL) and the text that will be displyed on the video. The completion method will be called asynchronously once the new video is ready
+ (void)textOnVideo:(NSURL*)videoURL withText:(NSString*)text withFontName:(NSString*)fontName withFontSize:(CGFloat)fontSize completion:(void (^)(AVAssetExportSession*))completion
{
    // Creating the composition object. This object will hold the composition track instances
    AVMutableComposition *mainComposition = [[AVMutableComposition alloc] init];
    
    // Creating a composition track for the video which is also added to the main composition oject
    AVMutableCompositionTrack *compositionVideoTrack = [mainComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    // Initialaing the video asset using the video URL given as input
    //AVURLAsset *videoAsset = [[AVURLAsset alloc]initWithURL:videoURL  options:nil];
    AVAsset *videoAsset = [AVAsset assetWithURL:videoURL];
    
    // Getting the video asset track from the video asset
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    // Inserting the video to the composition track in the correct time range
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:videoAssetTrack atTime:kCMTimeZero error:nil];
    
    // Setting the preferred transform of the composition track to be the same as for the video asset track
    [compositionVideoTrack setPreferredTransform:[videoAssetTrack preferredTransform]];
    
    // Getting the size of this video
    CGSize videoSize = [videoAssetTrack naturalSize];
    
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    videoLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    [parentLayer addSublayer:videoLayer];
    
    // Creating the text layer and setting some attributes
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.string = text;
    textLayer.font = (__bridge CFTypeRef)fontName;//(__bridge CFTypeRef)(@"Helvetica");
    textLayer.fontSize = fontSize;
    //??textLayer.shadowOpacity = 0.5;
    textLayer.alignmentMode = kCAAlignmentCenter;
    
    // Setting the rectangle in which the text will be showed in. The rectangle's width is the video width, and the rectangle's hieght is the hieght of the text (20% more than the font size
    textLayer.bounds = CGRectMake(0, 0, videoSize.width, textLayer.fontSize * 1.2);
    
    // Positioning the text box (in the middle of the video)
    textLayer.position = CGPointMake(videoSize.width/2, videoSize.height/2);
    
    [parentLayer addSublayer:textLayer];
    
    // Creating a video composition to hold the instruction below. Then this video composition will be applied to the main composition
    AVMutableVideoComposition* videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.renderSize = videoSize;
    videoComposition.frameDuration = CMTimeMake(1, 30);
    videoComposition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
    // Creating a video composition instruction and adding it to the video composition
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, [mainComposition duration]);
    AVAssetTrack *videoTrackFromMainComposition = [[mainComposition tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVMutableVideoCompositionLayerInstruction* layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrackFromMainComposition];
    instruction.layerInstructions = [NSArray arrayWithObject:layerInstruction];
    videoComposition.instructions = [NSArray arrayWithObject: instruction];
    
    // Generating the output URL video
    NSURL *outptVideoUrl = [HMGFileManager uniqueUrlWithPrefix:@"textVideo-" ofType:@"mov"];
    
    // Creating an export session using the main composition and setting some attributes
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mainComposition presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL=outptVideoUrl;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = videoComposition;
    
    // Doing the actual export and setting the completion method that will be invoked asynchronously once the new video is ready
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(exporter);
        });
    }];
}


#pragma mark Private methods

// Returning a new imaged scaled to the given size using a given image
+(UIImage*) scaleImage:(UIImage*)originalImage toSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [originalImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

// Creating a CVPixelBuffer from a CGImage
+(CVPixelBufferRef) newPixelBufferFromCGImage: (CGImageRef) image
{
    CGSize frameSize = CGSizeMake(640.0, 480.0);
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, frameSize.width,
                                          frameSize.height, kCVPixelFormatType_32ARGB, (__bridge  CFDictionaryRef) options,
                                          &pxbuffer);
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, frameSize.width,
                                                 frameSize.height, 8, 4*frameSize.width, rgbColorSpace,
                                                 (CGBitmapInfo)kCGImageAlphaNoneSkipFirst);
    NSParameterAssert(context);
    CGContextConcatCTM(context, CGAffineTransformIdentity);
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image),
                                           CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}



@end
