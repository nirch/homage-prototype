//
//  Template.m
//  HomagePrototype
//
//  Created by Tomer Harry on 8/29/13.
//  Copyright (c) 2013 Homage. All rights reserved.
// this is a Test
// another Try

#import "HMGTemplate.h"
#import "HMGLog.h"

@implementation HMGTemplate

-(NSString *) levelDescription
{
    switch (self.level) {
        case Easy:
            return NSLocalizedString(@"TEMPLATE_EASY",nil);
            break;
        case Medium:
            return NSLocalizedString(@"TEMPLATE_MEDIUM",nil);
            break;
        case Hard:
            return NSLocalizedString(@"TEMPLATE_HARD",nil);
            break;
        default:
            HMGLogWarning(@"this template has a non defined level: %d" , self.level);
            return nil;
            break;
    }

}

- (void)setThumbnailPath:(NSString *)thumbnailPath
{
    _thumbnailPath = thumbnailPath;
    _thumbnail = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        _thumbnail = self.thumbnail;
    });
}

- (UIImage *)thumbnail
{
    if (_thumbnail)
    {
        return _thumbnail;
    }
    
    _thumbnail = [UIImage imageWithContentsOfFile:self.thumbnailPath];
    if (_thumbnail)
    {
        return _thumbnail;
    }
    
    NSURL *imageURL = [NSURL URLWithString:self.thumbnailPath];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    _thumbnail = [UIImage imageWithData:imageData];
    
    return _thumbnail;
}

#pragma mark NSCoding

#define kTemplateIDKey       @"TemplateID"
#define kNameKey             @"TemaplteName"
#define kDescriptionKey      @"TempalteDescription"
#define kLevelKey            @"TempalteLevel"
#define kVideoKey            @"TemplateVideo"
#define kRemakesKey          @"TemplateRemakes"
#define kSegmentsKey         @"TemmplateSegments"
#define kSoundTrackKey       @"TemaplteSoundTrack"
#define kthumbnailKey        @"TemplateThumbnail"



- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.templateID forKey:kTemplateIDKey];
    [encoder encodeObject:self.name forKey:kNameKey];
    [encoder encodeObject:self.description forKey:kDescriptionKey];
    [encoder encodeObject:self.video forKey:kVideoKey];
    [encoder encodeObject:self.remakes forKey:kRemakesKey];
    [encoder encodeObject:self.segments forKey:kSegmentsKey];
    [encoder encodeObject:self.soundtrack forKey:kSoundTrackKey];
    [encoder encodeObject:self.thumbnailPath forKey:kthumbnailKey];
    [encoder encodeInteger:self.level forKey:kLevelKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self.templateID = [decoder decodeObjectForKey:kTemplateIDKey];
    self.name = [decoder decodeObjectForKey:kNameKey];
    self.description = [decoder decodeObjectForKey:kDescriptionKey];
    self.video = [decoder decodeObjectForKey:kVideoKey];
    self.remakes = [decoder decodeObjectForKey:kRemakesKey];
    self.segments = [decoder decodeObjectForKey:kSegmentsKey];
    self.soundtrack = [decoder decodeObjectForKey:kSoundTrackKey];
    self.thumbnailPath = [decoder decodeObjectForKey:kthumbnailKey];
    self.level = [decoder decodeIntegerForKey:kLevelKey];
    return self;
}

@end
