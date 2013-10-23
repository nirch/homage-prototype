//
//  TemplateMainViewController.h
//  HomagePrototype
//
//  Created by Yoav Caspin on 8/31/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//   

#import <UIKit/UIKit.h>
#import "HMGTemplate.h"
#import "HMGRemake.h"
#import "HMGRemakeCVCell.h"
#import "HMGReviewSegmentsViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "HMGLog.h"

@interface HMGTemplateDetailedViewController : UIViewController

@property (strong,nonatomic) HMGTemplate *templateToDisplay;

@end
