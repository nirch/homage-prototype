//
//  HMGSegmentRemake.h
//  HomagePrototype
//
//  Created by Tomer Harry on 9/22/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMGSegmentRemake : NSObject

@property (strong, nonatomic) NSArray *takes; // Array of NSURLs each item in the array holds a URL to a video represnting a processed take for this segment

@property (strong, nonatomic) NSURL *selectedTake;

- (NSURL *)createVideo;

@end
