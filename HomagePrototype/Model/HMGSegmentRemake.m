//
//  HMGSegmentRemake.m
//  HomagePrototype
//
//  Created by Tomer Harry on 9/22/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGSegmentRemake.h"
@interface HMGSegmentRemake()
@property (strong, nonatomic,readwrite) NSMutableArray *takes;
@end

@implementation HMGSegmentRemake

-(id)init
{
    self = [super init];
    
  if(!self)
    {
        self.selectedTakeIndex = -1;
    }
    return self;
}

-(NSMutableArray *)takes
{
    if(!_takes) _takes = [[NSMutableArray alloc] init];
    return _takes;
}
@end
