//
//  Remake.m
//  HomagePrototype
//
//  Created by Tomer Harry on 8/29/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGRemake.h"

@implementation HMGRemake

#pragma mark NSCoding

#define kVideoKey            @"RamakeVideo"
#define kThumbnailKey        @"RemakeImage"

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.video forKey:kVideoKey];
    [encoder encodeObject:self.thumbnailPath forKey:kThumbnailKey];
   
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self.video = [decoder decodeObjectForKey:kVideoKey];
    self.thumbnailPath = [decoder decodeObjectForKey:kThumbnailKey];
    return self;
}


@end
