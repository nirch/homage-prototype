//
//  HMGTake.m
//  HomagePrototype
//
//  Created by Yoav Caspin on 10/27/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGTake.h"

@implementation HMGTake

#pragma mark NSCoding

#define kVideoKey            @"TakeVideo"
#define kThumbnailKey        @"TakeImage"
#define kSelectedKey         @"TakeSelected"

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.videoURL forKey:kVideoKey];
    [encoder encodeObject:self.thumbnail forKey:kThumbnailKey];
    [encoder encodeBool:self.selected forKey:kSelectedKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self.videoURL = [decoder decodeObjectForKey:kVideoKey];
    self.thumbnail = [decoder decodeObjectForKey:kThumbnailKey];
    self.selected = [decoder decodeBoolForKey:kSelectedKey];
    return self;
}

@end
