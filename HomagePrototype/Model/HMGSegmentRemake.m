//
//  HMGSegmentRemake.m
//  HomagePrototype
//
//  Created by Tomer Harry on 9/22/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGSegmentRemake.h"
#import "HMGSegmentRemakeProtectedMethods.h"
#import "HMGLog.h"

@interface HMGSegmentRemake()

@property (strong, nonatomic,readwrite) NSMutableArray *takes;
//@property(nonatomic,copy) void (^completion)(NSURL *videoURL, NSError *error);

@end


@implementation HMGSegmentRemake

-(id)init
{
    self = [super init];
    
    if (self)
    {
        self.selectedTakeIndex = -1;
    }
    return self;
}

-(NSMutableArray *)takes
{
    if(!_takes) _takes = [[NSMutableArray alloc] init];
    return _takes;
}

// This method will create a video based on the data in the current instance. The operation is asynchronous. After the video is successfully created, it will be saved as a new take and the completion handler will be called. If the there was a faliure in the video creation, videoURL in the completion handler will be nil, and an error will apear in the error object
- (void)processVideoAsynchronouslyWithCompletionHandler:(void (^)(NSURL *videoURL, NSError *error))completion
{
    // This is an abstract method of an abstract class, this implementation should never be invoked
    [NSException raise:@"InvocationException" format:@"processVideoAsynchronouslyWithCompletionHandler should not be invoked on HMGSegmentRemake since it is an abstract method"];
}


// This method should be called once the video export is finished
- (void)processVideoDidFinish:(AVAssetExportSession*)exporter withCompletion:(void (^)(NSURL *videoURL, NSError *error))completion
{
    HMGLogDebug(@"%s started", __PRETTY_FUNCTION__);
    
    NSURL *outputVideoURL = nil;
    NSError *error = nil;
    
    // Checking if the export session completed successfully, if so adding the processed video to the takes aray
    if (exporter.status == AVAssetExportSessionStatusCompleted)
    {
        outputVideoURL = exporter.outputURL;
        [self addVideoTake:outputVideoURL];
    }
    else
    {
        error = exporter.error;
        HMGLogError(@"process video finished with error: %@", error.description);
    }
    
    completion(outputVideoURL, error);

    HMGLogDebug(@"%s ended", __PRETTY_FUNCTION__);
}

// This method should be called once the video export is finished
- (void)processVideoDidFinishWithWriter:(AVAssetWriter *)assetWriter withCompletion:(void (^)(NSURL *videoURL, NSError *error))completion
{
    HMGLogDebug(@"%s started", __PRETTY_FUNCTION__);
    
    NSURL *outputVideoURL = nil;
    NSError *error = nil;
    
    // Checking if the export session completed successfully, if so adding the processed video to the takes aray
    if (assetWriter.status == AVAssetWriterStatusCompleted)
    {
        outputVideoURL = assetWriter.outputURL;
        [self addVideoTake:outputVideoURL];
    }
    else
    {
        error = assetWriter.error;
        HMGLogError(@"process video finished with error: %@", error.description);
    }
    
    completion(outputVideoURL, error);
    
    HMGLogDebug(@"%s ended", __PRETTY_FUNCTION__);
}

// Addes a video to the takes
- (void)addVideoTake:(NSURL *)videoURL
{
    [self.takes addObject:videoURL];

    //if this is the first take then assign the selectedIndex to be the first item
    if (self.takes.count == 1)
    {
        self.selectedTakeIndex = 0;
    }
}



@end
