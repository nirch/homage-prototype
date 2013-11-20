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

@end
