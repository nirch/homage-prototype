//
//  HMGRemakeProject.h
//  HomagePrototype
//
//  Created by Tomer Harry on 9/22/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMGTemplate.h"

@interface HMGRemakeProject : NSObject <NSCoding>

@property (strong, nonatomic) HMGTemplate *templateObj;
@property (strong, nonatomic) NSString *user;
@property (strong, nonatomic) NSArray *segmentRemakes;

+ (BOOL)savedProjectFileExistsForTemplate:(NSString *)templateName;
- (void)saveData;
- (void)deleteSavedProjectFile;
- (id)initWithFileForTemplate:(NSString *)templateName;
- (id)initWithTemplate:(HMGTemplate *) templateObj;


// This method will create/render the final video based on the selected take of each of its SegmentRemake objects. After the video is successfully created the completion handler will be called with the URL to the new video. If the there was a faliure in the video creation, videoURL in the completion handler will be nil, and an error will apear in the error object
- (void)renderVideoAsynchronouslyWithCompletionHandler:(void (^)(NSURL *videoURL, NSError *error))completion;


@end
