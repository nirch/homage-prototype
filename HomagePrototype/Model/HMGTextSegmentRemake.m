//
//  HMGTextSegmentRemake.m
//  HomagePrototype
//
//  Created by Tomer Harry on 9/22/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGTextSegmentRemake.h"
#import "HMGTextSegment.h"
#import "HMGAVUtils.h"
#import "HMGSegmentRemakeProtectedMethods.h"
#import "HMGLog.h"

@implementation HMGTextSegmentRemake

// This method will create a video based on the data in the current instance. The operation is asynchronous. After the video is successfully created, it will be saved as a new take and the completion handler will be called. If the there was a faliure in the video creation, videoURL in the completion handler will be nil, and an error will apear in the error object.
- (void)processVideoAsynchronouslyWithCompletionHandler:(void (^)(NSURL *videoURL, NSError *error))completion
{
    HMGLogDebug(@"%s started", __PRETTY_FUNCTION__);
    
    HMGTextSegment *textSegment = (HMGTextSegment *)self.segment;

    [HMGAVUtils textOnVideo:textSegment.video withText:self.text withFontName:textSegment.font withFontSize:textSegment.fontSize completion:^(AVAssetExportSession *exporter) {
        [self processVideoDidFinish:exporter withCompletion:completion];
    }];
    
    HMGLogDebug(@"%s ended", __PRETTY_FUNCTION__);
}

- (NSString *)text
{
    if(!_text) _text = [[NSString alloc] init];
    return _text;
}


@end
