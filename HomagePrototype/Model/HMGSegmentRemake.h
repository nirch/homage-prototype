//
//  HMGSegmentRemake.h
//  HomagePrototype
//
//  Created by Tomer Harry on 9/22/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMGSegment.h"
#import <AVFoundation/AVFoundation.h>

@interface HMGSegmentRemake : NSObject <NSCoding>

// Array of NSURLs each item in the array holds a URL to a video represnting a processed take for this segment
@property (strong, nonatomic,readonly) NSMutableArray *takes;
@property (nonatomic) NSInteger selectedTakeIndex;
@property (strong, nonatomic) HMGSegment *segment;


// This method will create a video based on the data in the current instance. The operation is asynchronous. After the video is successfully created, it will be saved as a new take and the completion handler will be called. If the there was a faliure in the video creation, videoURL in the completion handler will be nil, and an error will apear in the error object
- (void)processVideoAsynchronouslyWithCompletionHandler:(void (^)(NSURL *videoURL, NSError *error))completion;

@end


