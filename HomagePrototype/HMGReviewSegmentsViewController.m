//
//  HMGReviewSegmentsViewController.m
//  HomagePrototype
//
//  Created by Yoav Caspin on 9/22/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGReviewSegmentsViewController.h"

@interface HMGReviewSegmentsViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *segmentsCView;
@property (strong,nonatomic) NSArray *segmentsArray;

@end

@implementation HMGReviewSegmentsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.segmentsArray = self.templateToDisplay.segments;
    
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
    [self updateCell:cell withSegment:segment];
    return cell;
}

- (void)updateCell:(UICollectionViewCell *)cell withSegment:(HMGSegment *)segment
{
    if ([cell isKindOfClass: [HMGsegmentCVCell class]]) {
        HMGsegmentCVCell *segmentCell = (HMGsegmentCVCell *) cell;
        segmentCell.origSegmentImageView.image = segment.thumbnail;
        segmentCell.origSegmentVideo = segment.video;
        segmentCell.segmentName.text = segment.name;
        segmentCell.segmentDescription.text = segment.description;
        segmentCell.segmentDuration.text = [self formatToTimeString:segment.duration];
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

@end
