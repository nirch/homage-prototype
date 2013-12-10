//
//  TemplateMainViewController.m
//  HomagePrototype
//
//  Created by Yoav Caspin on 8/31/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGTemplateDetailedViewController.h"


@interface HMGTemplateDetailedViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *templateName;
@property (weak, nonatomic) IBOutlet UIButton *templatePlayButton;
@property (weak, nonatomic) IBOutlet UICollectionView *remakesCView;
@property (strong,nonatomic) NSArray *remakesArray;
@property (weak, nonatomic) IBOutlet UIImageView *templatethumbnailImageView;
@property (weak, nonatomic) IBOutlet UIButton *playTemplateButton;
@property (weak, nonatomic) IBOutlet UIButton *recordTemplateButton;

@end

@implementation HMGTemplateDetailedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    
    //template player
    [self.templatePlayButton setBackgroundImage:[UIImage imageWithContentsOfFile:self.templateToDisplay.thumbnailPath] forState:UIControlStateNormal];
    
    // Since getting the thumbnail might take time (network), doing this on a different thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        UIImage *thumbnail = self.templateToDisplay.thumbnail;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            self.templatethumbnailImageView.image = thumbnail;
        });
    });
    
    
    //self.templatethumbnailImageView.image = [UIImage imageWithContentsOfFile:self.templateToDisplay.thumbnailPath];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"pb_play_icon" ofType:@"png"];
    UIImage *playButtonImage = [UIImage imageWithContentsOfFile:imagePath];
    [self.templatePlayButton setImage:playButtonImage forState:UIControlStateNormal];
    self.templateName.text = self.templateToDisplay.name;
    
    //remakes
    self.remakesArray = self.templateToDisplay.remakes;
    
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
}

//initiate the video player upon press on templatePlayButton
- (IBAction)playTemplate:(id)sender {
    
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    NSURL *videoURL = self.templateToDisplay.video;
    [self playMovieWithURL:videoURL];
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
}


//============================= code for remakes collection view ===================================

/*- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
 {
 return 1;
 }*/ //if not implemented, this value is set on default to 1

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    HMGLogDebug(@"%s started and finished" , __PRETTY_FUNCTION__);
    return [self.remakesArray count];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    UICollectionViewCell *cell = [self.remakesCView dequeueReusableCellWithReuseIdentifier:@"RemakeCell"
                                                                               forIndexPath:indexPath];
    HMGRemake *remake = self.remakesArray[indexPath.item];
    [self updateCell:cell withRemake:remake];
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
    return cell;
}

- (void)updateCell:(UICollectionViewCell *)cell withRemake:(HMGRemake *)remake
{
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);

    if ([cell isKindOfClass: [HMGRemakeCVCell class]]) {
        HMGRemakeCVCell *remakeCell = (HMGRemakeCVCell *) cell;
        remakeCell.imageView.image = [UIImage imageWithContentsOfFile:remake.thumbnailPath];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"pb_play_icon" ofType:@"png"];
        UIImage *playButtonImage = [UIImage imageWithContentsOfFile:imagePath];
        remakeCell.pbImageView.image = playButtonImage;
    }
    
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
}

//this method is called when the user decides to play a specific remake
-(IBAction)playRemake:(UITapGestureRecognizer *)gesture
{
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);

    CGPoint tapLocation = [gesture locationInView:self.remakesCView];
    NSIndexPath *indexPath = [self.remakesCView indexPathForItemAtPoint:tapLocation];
    if (indexPath)
    {
        HMGRemake *remake = self.remakesArray[indexPath.item];
        NSURL *videoURL = remake.video;
        HMGLogInfo(@"the user selected to play remake at index: @d" , indexPath.item);
        [self playMovieWithURL:videoURL];
    }
    
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    if ([segue.identifier isEqualToString:@"remakeTemplate"])
    {
        
        if ([segue.destinationViewController isKindOfClass:[HMGReviewSegmentsViewController class]])
        {
            HMGReviewSegmentsViewController *destController = (HMGReviewSegmentsViewController *)segue.destinationViewController;
            destController.templateToDisplay = self.templateToDisplay;
            HMGLogInfo(@"user selected to remake template: %@" , self.templateToDisplay.name);
        }
        
    }
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
}


-(void)playMovieWithURL:(NSURL *)videoURL
{
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    MPMoviePlayerViewController *moviePlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
    [self presentMoviePlayerViewControllerAnimated:moviePlayerViewController];
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
}

- (void)didReceiveMemoryWarning
{
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    HMGLogWarning(@"recieved memory warning");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);

}

@end
