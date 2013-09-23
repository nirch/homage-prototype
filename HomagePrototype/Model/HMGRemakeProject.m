//
//  HMGRemakeProject.m
//  HomagePrototype
//
//  Created by Tomer Harry on 9/22/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGRemakeProject.h"
#import "HMGSegment.h"
#import "HMGVideoSegment.h"
#import "HMGImageSegment.h"
#import "HMGTextSegment.h"
#import "HMGSegmentRemake.h"
#import "HMGVideoSegmentRemake.h"
#import "HMGImageSegmentRemake.h"
#import "HMGTextSegmentRemake.h"

@implementation HMGRemakeProject

- (id)initWithTemplate:(HMGTemplate *) templateObj
{
    self = [super init];
    
    if (self)
    {
        self.templateObj = templateObj;
        NSMutableArray *segmentRemakes = [[NSMutableArray alloc] init];
        
        // Looping over the segments of the template in order to create the parallel segment remake objects
        for (HMGSegment *segment in self.templateObj.segments)
        {
            HMGSegmentRemake *segmentRemake = [self createSegmentRemakeFrom:segment];
            [segmentRemakes addObject:segmentRemake];
        }
        
        // Converting the NSMutable array into an NSArray
        self.segmentRemakes = [NSArray arrayWithArray:segmentRemakes];
    }

    return self;
}

// Creating a SegmentRemake object from a given Segment object
- (HMGSegmentRemake *)createSegmentRemakeFrom:(HMGSegment *)segment
{
    HMGSegmentRemake *segmentRemake;
    
    if ([segment isKindOfClass:[HMGVideoSegment class]])
    {
        segmentRemake = [[HMGVideoSegmentRemake alloc] init];
    }
    else if ([segment isKindOfClass:[HMGImageSegment class]])
    {
        segmentRemake = [[HMGImageSegmentRemake alloc] init];
    }
    else if ([segment isKindOfClass:[HMGTextSegment class]])
    {
        segmentRemake = [[HMGTextSegmentRemake alloc] init];
    }
    
    return segmentRemake;
}



@end
