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
#import "HMGTake.h"
#import "HMGtakeCVCell.h"
#import "HMGRecordSegmentViewConroller.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "Toast+UIView.h"
#import "HMGFileManager.h"

@interface HMGReviewSegmentsViewController : UIViewController <videoPassingDelegate>;

@property (strong,nonatomic) HMGTemplate *templateToDisplay;

@end
