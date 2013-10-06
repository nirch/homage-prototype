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
+(void)scaleVideo:(NSURL*)videoURL toDuration:(CMTime)duration completion:(void (^)(AVAssetExportSession*))completion
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



@end
