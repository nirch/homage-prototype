//
//  HMGReviewSegmentsViewController.h
//  HomagePrototype
//
//  Created by Yoav Caspin on 9/22/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMGsegmentCVCell.h"
#import "HMGTemplate.h"
#import "HMGSegment.h"
#import "HMGRemakeProject.h"
#import <MediaPlayer/MediaPlayer.h>
#import "HMGSegmentRemake.h"
#import "HMGVideoSegment.h"
#import "HMGTextSegment.h"
#import "HMGImageSegment.h"
#import "HMGImageSegmentRemake.h"
#import "HMGTextSegmentRemake.h"
#import "HMGLog.h"


@interface HMGReviewSegmentsViewController : UIViewController

@property (strong,nonatomic) HMGTemplate *templateToDisplay;

@end
