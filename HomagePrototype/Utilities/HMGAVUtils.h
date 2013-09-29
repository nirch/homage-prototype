//
//  HMGAVUtils.h
//  HomagePrototype
//
//  Created by Tomer Harry on 9/29/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface HMGAVUtils : NSObject

// This method receives a list of videos (URLs to the videos) and a soundtrack (URL to the soundtrack). The method merges the videos and soundtrack into a new video. The completion method will be called asynchronously once the new video is ready
+(void)mergeVideos:(NSArray*)videoUrls withSoundtrack:(NSURL*)soundtrackURL completion:(void (^)(AVAssetExportSession*))completion;

@end
