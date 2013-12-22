//
//  HMGShareViewController.h
//  HomagePrototype
//
//  Created by Yoav Caspin on 12/22/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <MessageUI/MessageUI.h>

@interface HMGShareViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (strong,nonatomic) NSString *URLToShare;

@end
