//
//  HMGSegmentRemakeProtectedMethods.h
//  HomagePrototype
//
//  Created by Tomer Harry on 10/1/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HMGSegmentRemakeProtectedMethods <NSObject>

// This method should be called once the video export is finished
- (void)processVideoDidFinish:(AVAssetExportSession*)exporter withCompletion:(void (^)(NSURL *videoURL, NSError *error))completion;

// Addes a video to the takes
- (void)addVideoTake:(NSURL *)videoURL;

@end


@interface HMGSegmentRemake (ProtectedMethods) < HMGSegmentRemakeProtectedMethods >
@end
