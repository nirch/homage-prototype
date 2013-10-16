//
//  HMGReviewSegmentsViewController.m
//  HomagePrototype
//
//  Created by Yoav Caspin on 9/22/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGReviewSegmentsViewController.h"
#import "HMGRecordSegmentViewConroller.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "HMGLog.h"

@interface HMGReviewSegmentsViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *segmentsCView;
@property (strong,nonatomic) NSArray *segmentsArray;
@property (strong,nonatomic) HMGRemakeProject *remakeProject;
@property (nonatomic) NSInteger selectedSegmentIndex;

@end

@implementation HMGReviewSegmentsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.segmentsArray = self.templateToDisplay.segments;
    self.remakeProject = [[HMGRemakeProject alloc] initWithTemplate: self.templateToDisplay];
}


/*- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
 {
 return 1;
 }*/ //if not implemented, this value is set on default to 1

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [self.segmentsArray count];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.segmentsCView dequeueReusableCellWithReuseIdentifier:@"segmentCell"
                                                                        forIndexPath:indexPath];
    HMGSegment *segment = self.segmentsArray[indexPath.item];
    [self updateCell:cell withSegment:segment withIndex:indexPath.item];
    return cell;
}

- (void)updateCell:(UICollectionViewCell *)cell withSegment:(HMGSegment *)segment withIndex:(NSInteger)index
{
    if ([cell isKindOfClass: [HMGsegmentCVCell class]]) {
        HMGsegmentCVCell *segmentCell = (HMGsegmentCVCell *) cell;
        segmentCell.origSegmentImageView.image = segment.thumbnail;
        //segmentCell.segmentType = [cell getSegmentType];
        segmentCell.origSegmentVideo = segment.video;
        segmentCell.segmentName.text = segment.name;
        segmentCell.segmentDescription.text = segment.description;
        segmentCell.segmentDuration.text = [self formatToTimeString:segment.duration];
        
        [segmentCell.playOrigSegmentButton addTarget:self action:@selector(playSegmentVideo:) forControlEvents:UIControlEventTouchUpInside];
        
        [segmentCell.userSegmentRecordButton addTarget:self action:@selector(recordSegment:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (IBAction)playSegmentVideo:(UIButton *)button
{
    
    //Acccess the cell
    UICollectionViewCell *cell = (UICollectionViewCell *)button.superview.superview;
    if ([cell isKindOfClass: [HMGsegmentCVCell class]]) {
        HMGsegmentCVCell *segmentCell = (HMGsegmentCVCell *) cell;
        NSURL *videoURL = segmentCell.origSegmentVideo;
        [self playMovieWithURL:videoURL];
    }
}

-(IBAction)recordSegment:(UIButton *)button
{
    UICollectionViewCell *cell = (UICollectionViewCell *)button.superview.superview;
    if ([cell isKindOfClass: [HMGsegmentCVCell class]]) {
        HMGsegmentCVCell *segmentCell = (HMGsegmentCVCell *) cell;
        [self performSegueWithIdentifier:@"recordSegment" sender:segmentCell];
    }
    
}


-(void)playMovieWithURL:(NSURL *)videoURL
{
    MPMoviePlayerViewController *moviePlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
    [self presentMoviePlayerViewControllerAnimated:moviePlayerViewController];
}

-(NSString *)formatToTimeString:(CMTime)duration
{
    NSUInteger dTotalSeconds = CMTimeGetSeconds(duration);
    NSUInteger dMinutes = floor(dTotalSeconds % 3600 / 60);
    NSUInteger dSeconds = floor(dTotalSeconds % 3600 % 60);
    NSString *videoDurationText = [NSString stringWithFormat:@"%02i:%02i", dMinutes, dSeconds];
    return videoDurationText;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([segue.identifier isEqualToString:@"recordSegment"])
    {
        
        HMGRecordSegmentViewConroller *destController = (HMGRecordSegmentViewConroller *)segue.destinationViewController;
        //UIButton *button = (UIButton *)sender;
        HMGsegmentCVCell *cell = (HMGsegmentCVCell *)sender;
        NSIndexPath *indexPath = [self.segmentsCView indexPathForCell:cell];
        NSInteger index = indexPath.item;
        HMGSegmentRemake *segmentRemake = self.remakeProject.segmentRemakes[index];
        destController.videoSegmentRemake = segmentRemake;
    }
}

- (IBAction)renderFinal:(id)sender {
    //place holder for nir to render final cut
    
    [self.remakeProject renderVideoAsynchronouslyWithCompletionHandler:^(NSURL *videoURL, NSError *error) {
        [self videoProcessDidFinish:videoURL withError:error];
    }];
}

- (void)videoProcessDidFinish:(NSURL *)videoURL withError:(NSError *)error
{
    HMGLogDebug(@"%s started", __PRETTY_FUNCTION__);
    
    if (!error)
    {
        // Getting the exported video URL and validating if we can save it
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:videoURL])
        {
            // Saving the video. This is an asynchronous process. The completion block (which is implemented here inline) will be invoked once the saving process finished
            [library writeVideoAtPathToSavedPhotosAlbum:videoURL completionBlock:^(NSURL *assetURL, NSError *error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error)
                    {
                        HMGLogError([error localizedDescription]);
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    }
                    else
                    {
                        HMGLogNotice(@"Video <%@> saved successfully to photo album", videoURL.description);
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    }
                });
            }];
        }
    }
    else
    {
        HMGLogError([error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription]
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    HMGLogDebug(@"%s ended", __PRETTY_FUNCTION__);

}

@end
