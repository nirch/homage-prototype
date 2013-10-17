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
#import <MobileCoreServices/UTCoreTypes.h>
#import "HMGLog.h"

@interface HMGReviewSegmentsViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *segmentsCView;
@property (strong,nonatomic) NSArray *segmentsArray;
@property (strong,nonatomic) HMGRemakeProject *remakeProject;
@property (nonatomic) NSInteger selectedSegmentIndex;

@property (nonatomic) BOOL imageSelection;
@property (nonatomic) UIImagePickerController *imagesPicker;
@property (nonatomic) UIBarButtonItem *doneButton;
@property (nonatomic) NSMutableArray *images;
@property (nonatomic) NSURL *imageVideoUrl;

@end

@implementation HMGReviewSegmentsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.segmentsArray = self.templateToDisplay.segments;
    self.remakeProject = [[HMGRemakeProject alloc] initWithTemplate: self.templateToDisplay];
    self.imageSelection = NO;
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
        segmentCell.segmentType = [segment getSegmentType];
        segmentCell.origSegmentVideo = segment.video;
        segmentCell.segmentName.text = segment.name;
        segmentCell.segmentDescription.text = segment.description;
        segmentCell.segmentDuration.text = [self formatToTimeString:segment.duration];
        
        [segmentCell.playOrigSegmentButton addTarget:self action:@selector(playSegmentVideo:) forControlEvents:UIControlEventTouchUpInside];
        
        [segmentCell.userSegmentRecordButton addTarget:self action:@selector(remakeButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
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

-(IBAction)remakeButtonPushed:(UIButton *)button
{
    UICollectionViewCell *cell = (UICollectionViewCell *)button.superview.superview;
    if ([cell isKindOfClass: [HMGsegmentCVCell class]]) {
        HMGsegmentCVCell *segmentCell = (HMGsegmentCVCell *) cell;
        NSString *type = segmentCell.segmentType;
        
        if ([type isEqualToString:@"video"]) {
            [self performSegueWithIdentifier:@"recordVideoSegment" sender:segmentCell];
        } else if ([type isEqualToString:@"image"]) {
            [self selectImages];
        } else if ([type isEqualToString:@"text"]) {
            //TODO - code from text editing
        } else {
            //TODO - add error logging of undefined segment type
        }
        
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

    if ([segue.identifier isEqualToString:@"recordVideoSegment"])
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

//code for image picker
//====================================================

- (void)selectImages
{
    
    self.imageSelection = YES;
    
    // Opening the media picker to select the images
    self.imagesPicker = [self startMediaBrowserFromViewController:self withMediaTypes:[[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil] usingDelegate:self ];
}

// Opening the media picker.
- (UIImagePickerController*)startMediaBrowserFromViewController:(UIViewController*)controller withMediaTypes:(NSArray*)mediaTypes usingDelegate:(id)delegate
{
    // Doing some valiadtions: checking whether the image picker is available or not and checking that there are no null values
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO)
        || (delegate == nil)
        || (controller == nil))
    {
        return nil;
    }
    
    // OK, reaching here means that the image picker is available and we can proceed
    
    
    // Create an image picker
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    mediaUI.mediaTypes = mediaTypes;
    mediaUI.editing = NO;
    mediaUI.delegate = delegate;
    
    // Display the image picker
    [controller presentViewController:mediaUI animated:YES completion:nil];
    
    return mediaUI;
}


- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    // Adding the "done" button only if we are selecting images
    if (self.imageSelection)
    {
        NSLog(@"Inside navigationController ...");
        
        if (!self.doneButton)
        {
            self.doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(saveImagesDone:)];
        }
        
        viewController.navigationItem.rightBarButtonItem = self.doneButton;
    }
}

// This method is called when the user clicked on the "done" button. Closing the image picker
- (IBAction)saveImagesDone:(id)sender
{
    NSLog(@"select images done ...");
    
    // Dismissing the image picker
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.imageSelection = NO;
    
    // Creating a video from a list of images. The completion handler will be invoked once the new video is ready (or there are errors...)
    [VideoUtils imagesToVideo:self.images withFrameTime:1000 completion:^(AVAssetWriter *videoWriter) {
        [self videoWriterDidFinish:videoWriter];
    }];
    
}

// This method is triggered once the video writer is done and the video is ready (or there are errors...)
-(void)videoWriterDidFinish:(AVAssetWriter*)videoWriter
{
    // Checking the status of the video wirter
    if (videoWriter.status == AVAssetWriterStatusCompleted)
    {
        // Getting the output URL
        self.imageVideoUrl = videoWriter.outputURL;
        NSLog(@"Image video is ready");
        
    }
    else
    {
        // Printing the error to the log
        NSError *error = videoWriter.error;
        NSLog(@"Image video error: %@",error.description);
    }
    
    // Initializing the images array
    self.images = [[NSMutableArray alloc] init];
}

@end
