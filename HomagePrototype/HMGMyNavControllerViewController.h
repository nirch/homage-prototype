//
//  HMGMyNavControllerViewController.h
//  HomagePrototype
//
//  Created by Yoav Caspin on 11/15/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BackButtonHandlerProtocol <NSObject>
@optional
// Override this method in UIViewController derived class to handle 'Back' button click
-(BOOL)navigationShouldPopOnBackButton;
@end

@interface UIViewController (BackButtonHandler) <BackButtonHandlerProtocol>

@end

@interface HMGMyNavControllerViewController : UINavigationController

@end

