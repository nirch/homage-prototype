//
//  HMGSegment.m
//  HomagePrototype
//
//  Created by Tomer Harry on 9/12/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGSegment.h"

@implementation HMGSegment

-(NSString *)getSegmentType
{
    [NSException raise:@"InvalidArgumentException" format:@"videoUrls count of 0 is invalid (videoUrls count must be > 0)"];
    return nil;
}

#pragma mark NSCoding

#define kNameKey             @"SegmentName"
#define kDescriptionKey      @"SegmentDescription"
#define kTimeKey             @"SegmentTime"
#define kVideoKey            @"SegmentRafi"
#define kThumbnailKey        @"SegmentThumbnail"

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.name forKey:kNameKey];
    [encoder encodeObject:self.description forKey:kDescriptionKey];
    [encoder encodeObject:self.video forKey:kVideoKey];
    [encoder encodeObject:self.thumbnailPath forKey:kThumbnailKey];
    [encoder encodeCMTime:self.duration forKey:kVideoKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self.name = [decoder decodeObjectForKey:kNameKey];
    self.description = [decoder decodeObjectForKey:kDescriptionKey];
    self.video = [decoder decodeObjectForKey:kVideoKey];
    self.thumbnailPath = [decoder decodeObjectForKey:kThumbnailKey];
    self.duration = [decoder decodeCMTimeForKey:kTimeKey];
    return self;
}


@end
