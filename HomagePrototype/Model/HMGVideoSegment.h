//
//  HMGVideoSegment.h
//  HomagePrototype
//
//  Created by Tomer Harry on 9/12/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGSegment.h"

@interface HMGVideoSegment : HMGSegment

@property (nonatomic) CMTime recordDuration;

@property (strong, nonatomic) NSString *templateFolder;
@property (strong, nonatomic) NSString *segmentFile;


@end
