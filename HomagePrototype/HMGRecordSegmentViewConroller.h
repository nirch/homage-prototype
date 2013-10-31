//
//  HMGRecordSegmentViewConroller.h
//  HomagePrototype
//
//  Created by Tomer Harry on 9/23/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "HMGVideoSegmentRemake.h"
#import "HMGVideoSegment.h"


//delegeate for passing data back to HMGReviewSegmentsViewController
@class HMGRecordSegmentViewConroller;

@protocol videoPassingDelegate <NSObject>
- (void)addItemViewController:(HMGRecordSegmentViewConroller *)controller didFinishGeneratingVideo:(NSURL *)video;
@end

@interface HMGRecordSegmentViewConroller : UIViewController<AVCaptureFileOutputRecordingDelegate>
@property (nonatomic, weak) id <videoPassingDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *previewView;
@property(nonatomic) HMGVideoSegmentRemake *videoSegmentRemake;
- (IBAction)startRecording:(id)sender;

@end
