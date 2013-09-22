//
//  TemplateMainViewController.m
//  HomagePrototype
//
//  Created by Yoav Caspin on 8/31/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "TemplateMainViewController.h"


@interface TemplateMainViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *templateName;
@property (weak, nonatomic) IBOutlet UIButton *templatePlayButton;
@property (weak, nonatomic) IBOutlet UICollectionView *remakesCView;
@property (strong,nonatomic) NSArray *remakesArray;

@end

@implementation TemplateMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //template player
    [self.templatePlayButton setBackgroundImage:self.templateToDisplay.thumbnail forState:UIControlStateNormal];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"pb_play_icon" ofType:@"png"];
    UIImage *playButtonImage = [UIImage imageWithContentsOfFile:imagePath];
    [self.templatePlayButton setImage:playButtonImage forState:UIControlStateNormal];
    self.templateName.text = self.templateToDisplay.name;
    
    //remakes
    self.remakesArray = self.templateToDisplay.remakes;
    
}

//initiate the video player upon press on templatePlayButton
- (IBAction)playTemplate:(id)sender {
    MPMoviePlayerViewController *moviePlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:self.templateToDisplay.video];
    [self presentMoviePlayerViewControllerAnimated:moviePlayerViewController];
}


/*- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
 {
 return 1;
 }*/ //if not implemented, this value is set on default to 1

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [self.remakesArray count];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.remakesCView dequeueReusableCellWithReuseIdentifier:@"RemakeCell"
                                                                               forIndexPath:indexPath];
    HMGRemake *remake = self.remakesArray[indexPath.item];
    [self updateCell:cell withRemake:remake];
    return cell;
}

- (void)updateCell:(UICollectionViewCell *)cell withRemake:(HMGRemake *)remake
{
    if ([cell isKindOfClass: [HMGRemakeCVCell class]]) {
        HMGRemakeCVCell *remakeCell = (HMGRemakeCVCell *) cell;
        remakeCell.imageView.image = remake.thumbnail;
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"pb_play_icon" ofType:@"png"];
        UIImage *playButtonImage = [UIImage imageWithContentsOfFile:imagePath];
        remakeCell.pbImageView.image = playButtonImage;
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
