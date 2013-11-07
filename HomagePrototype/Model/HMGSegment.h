//
//  HMGSegment.h
//  HomagePrototype
//
//  Created by Tomer Harry on 9/12/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CMTime.h>

@interface HMGSegment : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description;
@property (nonatomic) CMTime duration;
@property (strong, nonatomic) NSURL *video;
@property (strong, nonatomic) NSString *thumbnailPath;

-(NSString *)getSegmentType;

@end
