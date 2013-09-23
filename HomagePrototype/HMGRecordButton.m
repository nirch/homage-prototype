//
//  HMGRecord.m
//  HomagePrototype
//
//  Created by Tomer Harry on 9/23/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGRecordButton.h"
#import <QuartzCore/QuartzCore.h>

#define IMAGE_NAME @"record_indicator_off"
#define IMAGE_NAME_SELECTED @"record_indicator_on"
#define IMAGE_NAME_SELECTED_GLOW [NSString stringWithFormat:@"%@_glow", IMAGE_NAME_SELECTED]


@interface HMGRecordButton ()
@property (nonatomic, strong) CALayer *glowLayer;
@property (nonatomic, assign) CGFloat imageHeight;
@property (nonatomic, assign) CGFloat imageWidth;
@end


@implementation HMGRecordButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
			if (self) {
		// Make these the button image instead of the background image so that the button's
		// internal imageView gets initialized.  This is necessary to get the glow effect I need.
		[self setImage:[UIImage imageNamed:IMAGE_NAME] forState:UIControlStateNormal];
		[self setImage:[UIImage imageNamed:IMAGE_NAME_SELECTED] forState:UIControlStateSelected];
	}
	return self;
}
- (void)setSelected:(BOOL)selected {
	[super setSelected:selected];
	if (selected) {
		[self pulse];
	} else {
		[self clearAnimations];
	}
}
- (void)pulse {
	self.glowLayer = [CALayer layer];
	self.glowLayer.frame = self.imageView.bounds;
	self.glowLayer.contents = (id)[UIImage imageNamed:IMAGE_NAME_SELECTED_GLOW].CGImage;
	self.glowLayer.opacity = 0.0f;
	[self.imageView.layer addSublayer:self.glowLayer];

	CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	pulseAnimation.toValue = @1.0f;
	pulseAnimation.delegate = self;
	[self setAnimationTiming:pulseAnimation];
	[self.glowLayer addAnimation:pulseAnimation forKey:@"pulse"];
}

- (void)setAnimationTiming:(CABasicAnimation *)animation {
	animation.duration = 0.7f;
	animation.repeatCount = HUGE_VALF;
	animation.autoreverses = YES;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
	[self clearAnimations];
}
- (BOOL)pulsing {
	return self.glowLayer.animationKeys.count > 0;
}

- (void)clearAnimations {
	[self.glowLayer removeAllAnimations];
	[self.glowLayer removeFromSuperlayer];
	[self.imageView.layer removeAllAnimations];
}

@end




//

//

//

//
//@end
