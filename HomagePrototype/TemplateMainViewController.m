//
//  TemplateMainViewController.m
//  HomagePrototype
//
//  Created by Yoav Caspin on 8/31/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "TemplateMainViewController.h"

@interface TemplateMainViewController ()

@property (weak, nonatomic) IBOutlet UILabel *templateName;
@property (weak, nonatomic) IBOutlet UIButton *templatePlayButton;

@end

@implementation TemplateMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.templatePlayButton setBackgroundImage:self.templateToDisplay.thumbnail forState:UIControlStateNormal];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"pb_play_icon" ofType:@"png"];
    UIImage *playButtonImage = [UIImage imageWithContentsOfFile:imagePath];
    [self.templatePlayButton setImage:playButtonImage forState:UIControlStateNormal];
    self.templateName.text = self.templateToDisplay.name;
	
}

- (IBAction)playTemplate:(id)sender {
    MPMoviePlayerViewController *moviePlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:self.templateToDisplay.video];
    [self presentMoviePlayerViewControllerAnimated:moviePlayerViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
