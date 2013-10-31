//
//  HMGsegmentCVCell.m
//  HomagePrototype
//
//  Created by Yoav Caspin on 9/22/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGsegmentCVCell.h"

@implementation HMGsegmentCVCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    self.singleSegmentTakesCView.allowsMultipleSelection = NO;
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
