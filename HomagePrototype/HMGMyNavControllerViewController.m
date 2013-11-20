//
//  HMGMyNavControllerViewController.m
//  HomagePrototype
//
//  Created by Yoav Caspin on 11/15/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGMyNavControllerViewController.h"

@interface HMGMyNavControllerViewController ()

@end

@implementation UIViewController (BackButtonHandler)

@end

@implementation HMGMyNavControllerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    
    if([self.viewControllers count] < [navigationBar.items count]) {
		return YES;
	}
    
	BOOL shouldPop = YES;
	UIViewController* vc = [self topViewController];
	if([vc respondsToSelector:@selector(navigationShouldPopOnBackButton)]) {
		shouldPop = [vc navigationShouldPopOnBackButton];
	}
    
	if(shouldPop) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self popViewControllerAnimated:YES];
		});
	}
    
	return NO;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
