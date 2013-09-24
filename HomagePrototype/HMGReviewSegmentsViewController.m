//
//  HMGReviewSegmentsViewController.m
//  HomagePrototype
//
//  Created by Yoav Caspin on 9/22/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGReviewSegmentsViewController.h"
#import "HMGRecordSegmentViewConroller.h"

@interface HMGReviewSegmentsViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *segmentsCView;
@property (strong,nonatomic) NSArray *segmentsArray;
@property (strong,nonatomic) HMGRemakeProject *remakeProject;

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
        segmentCell.origSegmentVideo = segment.video;
        segmentCell.segmentName.text = segment.name;
        segmentCell.segmentDescription.text = segment.description;
        segmentCell.segmentDuration.text = [self formatToTimeString:segment.duration];
        segmentCell.segmentRemake = self.remakeProject.segmentRemakes[index];
        
        [segmentCell.playOrigSegmentButton addTarget:self action:@selector(playSegmentVideo:) forControlEvents:UIControlEventTouchUpInside];
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
        UIButton *button = (UIButton *)sender;
        HMGsegmentCVCell *cell = button.superview.superview;
        destController.videoSegmentRemake = cell.segmentRemake;
    }
}


@end
