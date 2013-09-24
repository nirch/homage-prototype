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

@interface HMGRecordSegmentViewConroller : UIViewController<AVCaptureFileOutputRecordingDelegate>
@property (weak, nonatomic) IBOutlet UIView *previewView;
@property(nonatomic) HMGVideoSegmentRemake *videoSegmentRemake;
- (IBAction)startRecording:(id)sender;

@end
