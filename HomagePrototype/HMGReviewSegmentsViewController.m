//
//  HMGReviewSegmentsViewController.m
//  HomagePrototype
//
//  Created by Yoav Caspin on 9/22/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGReviewSegmentsViewController.h"



@interface HMGReviewSegmentsViewController () <UICollectionViewDataSource,UICollectionViewDelegate>


@property (strong,nonatomic) HMGRemakeProject *remakeProject;

@property (nonatomic) UIBarButtonItem *doneButton;
@property (nonatomic) NSMutableArray *images;

@property (strong,nonatomic) HMGImageSegmentRemake *currentImageSegmentRemake;
@property (strong,nonatomic) HMGTextSegmentRemake *currentTextSegmentRemake;

@property (nonatomic) UIAlertView *textFieldAlertView;
@property (nonatomic) UIImagePickerController *imagesPicker;
@property (nonatomic) BOOL imageSelection;

@property (weak, nonatomic) IBOutlet UICollectionView *segmentsCView;

@end

const NSInteger SEGMENT_CV_TAG = 10;
const NSInteger SINGLE_SEGMENT_TAKES_CV_TAG = 20;

@implementation HMGReviewSegmentsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    self.remakeProject = [[HMGRemakeProject alloc] initWithTemplate: self.templateToDisplay];
    self.imageSelection = NO;
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
}


#pragma mark segments and takes collection views control
// note: we are implementing 2 collection views. to tell them apart, we use UIview tags
// 1. main segments collection view - tagged "10" in attributes inspector
// 2. takes collection view (inside each segment collection view cell) - tagged "20"

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    HMGLogDebug(@"%s started, will return number of items in section" , __PRETTY_FUNCTION__);
    //case for main collection
    if (collectionView.tag == SEGMENT_CV_TAG) {
        HMGLogDebug(@"main collection view. tag is %d" , SEGMENT_CV_TAG);
        HMGLogDebug(@"number of items in section is: %d" , self.remakeProject.segmentRemakes.count);
        return [self.remakeProject.segmentRemakes count];
    
    } else if (collectionView.tag == SINGLE_SEGMENT_TAKES_CV_TAG) {
        HMGLogDebug(@"main collection view. tag is %d" , SINGLE_SEGMENT_TAKES_CV_TAG);
        UICollectionViewCell *parentSegmentCVCell = (UICollectionViewCell *)collectionView.superview.superview;
        NSIndexPath *indexPath = [self.segmentsCView indexPathForCell:parentSegmentCVCell];
        HMGSegmentRemake *segmentRemake = self.remakeProject.segmentRemakes[indexPath.item];
        return [segmentRemake.takes count];
    } else {
        HMGLogError(@"collectionView tag undefined: %d" , collectionView.tag);
        return 0;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    
    //case for segments collection view
    if (collectionView.tag == SEGMENT_CV_TAG ) {
        HMGLogDebug(@"main collection view. tag is %d" , SEGMENT_CV_TAG);
        HMGsegmentCVCell *segmentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"segmentCell"
                                                            forIndexPath:indexPath];
        HMGSegmentRemake *segmentRemake = self.remakeProject.segmentRemakes[indexPath.item];
        
        //setting data source and delegate for secondary collection view
        segmentCell.singleSegmentTakesCView.delegate = self;
        segmentCell.singleSegmentTakesCView.dataSource = self;
        
        [self updateCell:segmentCell withSegmentRemake:segmentRemake];
        HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
        return segmentCell;
  
    //case for specific cell film strip of takes
    } else if (collectionView.tag == SINGLE_SEGMENT_TAKES_CV_TAG) {
        HMGLogDebug(@"secondary takes collection view. tag is %d" , SINGLE_SEGMENT_TAKES_CV_TAG);
        HMGtakeCVCell *takeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"takeCell" forIndexPath:indexPath];
        UICollectionViewCell *parentSegmentCVCell = (UICollectionViewCell *)collectionView.superview.superview;
        NSIndexPath *segmentRemakeIndexPath = [self.segmentsCView indexPathForCell:parentSegmentCVCell];
        HMGSegmentRemake *segmentRemake = self.remakeProject.segmentRemakes[segmentRemakeIndexPath.item];
        HMGTake *take = segmentRemake.takes[indexPath.item];
        
        //as didSelect/select CV delegate are being called just with user touch interaction, this code verifies that only the right cell will be highlighted and selected.
        HMGLogDebug(@"indexPath.item = %d segmentRemake.selectedTakeIndex = %d" , indexPath.item , segmentRemake.selectedTakeIndex);
        if (indexPath.item  == segmentRemake.selectedTakeIndex)
        {
            takeCell.contentView.backgroundColor = [UIColor greenColor];
            [collectionView selectItemAtIndexPath: indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        } else {
            takeCell.contentView.backgroundColor = [UIColor clearColor];
        }
        
        [self updateCell:takeCell withTake:take];
        HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
        return takeCell;
    } else {
        HMGLogError(@"collection view tag is unknown: %d" , collectionView.tag);
        return nil;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
    
    if (collectionView.tag == SINGLE_SEGMENT_TAKES_CV_TAG) {
        HMGtakeCVCell *takeCell = (HMGtakeCVCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        //highlight frame of selected take
        takeCell.contentView.backgroundColor = [UIColor greenColor];
        
        HMGsegmentCVCell *parentSegmentCVCell = (HMGsegmentCVCell *) (UICollectionViewCell *)collectionView.superview.superview;
        NSIndexPath *segmentRemakeIndexPath = [self.segmentsCView indexPathForCell:parentSegmentCVCell];
        HMGSegmentRemake *segmentRemake = self.remakeProject.segmentRemakes[segmentRemakeIndexPath.item];
        segmentRemake.selectedTakeIndex = indexPath.item;
        HMGLogDebug(@"selected indexPath is now: %d" , segmentRemake.selectedTakeIndex);
        parentSegmentCVCell.userSegmentImageView.image = takeCell.thumbnail.image;
    }
    
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
    
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    if (collectionView.tag == SINGLE_SEGMENT_TAKES_CV_TAG) {
        HMGLogDebug(@"indexPath that was deselected is: %d" , indexPath.item);
        HMGtakeCVCell *takeCell = (HMGtakeCVCell *)[collectionView cellForItemAtIndexPath:indexPath];
        takeCell.contentView.backgroundColor = [UIColor clearColor];
    }
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
}

- (void)updateCell:(UICollectionViewCell *)cell withSegmentRemake:(HMGSegmentRemake *)segmentRemake
{
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    
    if ([cell isKindOfClass: [HMGsegmentCVCell class]]) {
        HMGsegmentCVCell *segmentCell = (HMGsegmentCVCell *) cell;
        segmentCell.origSegmentImageView.image = [UIImage imageWithContentsOfFile:segmentRemake.segment.thumbnailPath];
        segmentCell.segmentName.text = segmentRemake.segment.name;
        segmentCell.segmentDescription.text = segmentRemake.segment.description;
        segmentCell.segmentDuration.text = [self formatToTimeString:segmentRemake.segment.duration];
        
        if (segmentRemake.takes.count > 0)
        {
            HMGTake *selectedTake = segmentRemake.takes[segmentRemake.selectedTakeIndex];
            segmentCell.userSegmentImageView.image = selectedTake.thumbnail;
        }
        else
        {
            segmentCell.userSegmentImageView.image = nil;
        }
        
        [segmentCell.userSegmentRecordButton addTarget:self action:@selector(remakeButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
        
        [segmentCell.singleSegmentTakesCView reloadData];
    }
    
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
    
}

- (void)updateCell:(UICollectionViewCell *)cell withTake:(HMGTake *)take
{
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    
    if ([cell isKindOfClass: [HMGtakeCVCell class]])
    {
        HMGtakeCVCell *takeCell = (HMGtakeCVCell *) cell;
        takeCell.thumbnail.image = take.thumbnail;
        //takeCell.takeVideo = take.videoURL;
    }
    
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
    
}

#pragma mark play/record methods

//this action is called if the user hit the original segments play button
- (IBAction)playSegmentVideo:(UIButton *)button
{
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    
    UICollectionViewCell *cell = (UICollectionViewCell *)button.superview.superview;
    if ([cell isKindOfClass: [HMGsegmentCVCell class]]) {
        HMGsegmentCVCell *segmentCell = (HMGsegmentCVCell *) cell;
        NSIndexPath *indexPath = [self.segmentsCView indexPathForCell:cell];
        
        NSURL *videoURL = [[NSURL alloc] init];
        if (button == segmentCell.playOrigSegmentButton) {
            videoURL = [self getVideoFromRemakeAtIndex: indexPath.item ofType:@"orig"];
        } else if (button == segmentCell.userSegmentPlayButton) {
            videoURL = [self getVideoFromRemakeAtIndex: indexPath.item ofType:@"user"];
        }
        HMGLogInfo(@"user chose to play video segment: %@" , segmentCell.segmentName.text);
        [self playMovieWithURL:videoURL];
    }
    
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
}

-(NSURL *)getVideoFromRemakeAtIndex:(NSUInteger)index ofType:(NSString *)type
{
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    HMGSegmentRemake *segmentRemake = self.remakeProject.segmentRemakes[index];
    if ([type isEqualToString:@"orig"])
    {
        return segmentRemake.segment.video;
    } else if ([type isEqualToString:@"user"])
    {
        HMGTake *selectedTake = segmentRemake.takes[segmentRemake.selectedTakeIndex];
        return selectedTake.videoURL;
    } else {
        HMGLogError(@"unknown video type :@" , type);
        return nil;
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

//this action is called when the user decided to make a remake of a specific segment
-(IBAction)remakeButtonPushed:(UIButton *)button
{
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    
    UICollectionViewCell *cell = (UICollectionViewCell *)button.superview.superview;
    if ([cell isKindOfClass: [HMGsegmentCVCell class]]) {
        HMGsegmentCVCell *segmentCell = (HMGsegmentCVCell *) cell;
        NSIndexPath *indexPath = [self.segmentsCView indexPathForCell:segmentCell];
        HMGSegmentRemake *segmentRemake = self.remakeProject.segmentRemakes[indexPath.item];
        NSString *type = [segmentRemake.segment getSegmentType];
        
        HMGLogNotice(@"user selected to remake segment:%@" , segmentCell.segmentName.text);
        
        if ([type isEqualToString:@"video"]) {
            [self performSegueWithIdentifier:@"recordVideoSegment" sender:segmentCell];
        } else if ([type isEqualToString:@"image"]) {
            self.images = [[NSMutableArray alloc] init];
            self.currentImageSegmentRemake = self.remakeProject.segmentRemakes[indexPath.item];
            [self selectImages];
        } else if ([type isEqualToString:@"text"]) {
            self.currentTextSegmentRemake = self.remakeProject.segmentRemakes[indexPath.item];
            [self editTextSegment];
        } else {
            HMGLogError(@"segment is of unknown type: %@ !!" , type);
        }
    }
    
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
    
}

#pragma mark segue to record view controller

//this method will be called if the user chose to remake a video segment
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    
    if ([segue.identifier isEqualToString:@"recordVideoSegment"])
    {
        HMGRecordSegmentViewConroller *destController = (HMGRecordSegmentViewConroller *)segue.destinationViewController;
        destController.delegate = self;
        HMGsegmentCVCell *cell = (HMGsegmentCVCell *)sender;
        NSIndexPath *indexPath = [self.segmentsCView indexPathForCell:cell];
        NSInteger index = indexPath.item;
        HMGSegmentRemake *segmentRemake = self.remakeProject.segmentRemakes[index];
        HMGLogInfo(@"user selected to segue to view controller: %@ and to remake segment: %@. index of segment in remake project is: %d" , destController.class , segmentRemake.segment.name , index );
        destController.videoSegmentRemake = (HMGVideoSegmentRemake *)segmentRemake;
    }
    
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);

}

#pragma mark video segment control and process methods

- (void)didFinishGeneratingVideo:(NSURL *)video forVideoSegmentRemake:(HMGVideoSegmentRemake *)videoSegmentRemake {
    
    HMGLogDebug(@"%s started", __PRETTY_FUNCTION__);
    HMGLogDebug(@"video that was passed is: %s" , video.path);
    videoSegmentRemake.video = video;
    [videoSegmentRemake processVideoAsynchronouslyWithCompletionHandler:^(NSURL *videoURL, NSError *error) {
        [self videoProcessDidFinish:videoURL withError:error];
    }];
    
    HMGLogDebug(@"%s finished", __PRETTY_FUNCTION__);
}

//this action will be called when the user wants to render the final product from the remakes
- (IBAction)renderFinal:(id)sender {
    
    HMGLogDebug(@"%s started", __PRETTY_FUNCTION__);
    [self.remakeProject renderVideoAsynchronouslyWithCompletionHandler:^(NSURL *videoURL, NSError *error) {
        [self videoRenderDidFinish:videoURL withError:error];
    }];
    HMGLogDebug(@"%s finished", __PRETTY_FUNCTION__);

}

- (void)videoProcessDidFinish:(NSURL *)videoURL withError:(NSError *)error
{
    HMGLogDebug(@"%s started", __PRETTY_FUNCTION__);
    
    // TODO: Should we do here something if the video processing finished successfully? Update the UI?
    
    if (!videoURL) {
        HMGLogError(@"video url is null for segment. error is:%@" , error.description);
        
    } else if (error) {
        HMGLogError([error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR", nil) message:[error localizedDescription]
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alert show];
    } else {
        [self.segmentsCView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }
    
    HMGLogDebug(@"%s ended", __PRETTY_FUNCTION__);
}

//closure block for "renderVideoAsynchronouslyWithCompletionHandler"
- (void)videoRenderDidFinish:(NSURL *)videoURL withError:(NSError *)error
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
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR", nil) message:NSLocalizedString(@"VIDEO_SAVING_FAILED", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
                        [alert show];
                    }
                    else
                    {
                        HMGLogNotice(@"Video <%@> saved successfully to photo album", videoURL.description);
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VIDEO_SAVED", nil) message:NSLocalizedString(@"SAVED_TO_PHOTO_ALBUM", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
                        [alert show];
                    }
                });
            }];
        }
    }
    else
    {
        HMGLogError([error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR", nil) message:[error localizedDescription]
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alert show];
    }
    
    HMGLogDebug(@"%s ended", __PRETTY_FUNCTION__);

}

#pragma mark image segment methods

- (void)selectImages
{
    
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    self.imageSelection = YES;
    
    // Opening the media picker to select the images
    self.imagesPicker = [self startMediaBrowserFromViewController:self withMediaTypes:[[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil] usingDelegate:self];
}

// Opening the media picker.
- (UIImagePickerController*)startMediaBrowserFromViewController:(UIViewController*)controller withMediaTypes:(NSArray*)mediaTypes usingDelegate:(id)delegate
{
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    
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
    
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
    return mediaUI;
}


- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    
    // Adding the "done" button only if we are selecting images
    if (self.imageSelection)
    {
        HMGLogDebug(@"Inside navigationController ...");
        
        if (!self.doneButton)
        {
            self.doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"DONE", nil) style:UIBarButtonItemStyleDone target:self action:@selector(saveImagesDone:)];
        }
        
        viewController.navigationItem.rightBarButtonItem = self.doneButton;
    }
}

// This method is called when the user clicked on the "done" button. Closing the image picker
- (IBAction)saveImagesDone:(id)sender
{
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    
    // Dismissing the image picker
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.imageSelection = NO;
    self.currentImageSegmentRemake.images = [NSArray arrayWithArray:self.images];
    
    if (self.currentImageSegmentRemake.images.count > 0) {
        [self.currentImageSegmentRemake processVideoAsynchronouslyWithCompletionHandler:^(NSURL *videoURL, NSError *error) {
            [self videoProcessDidFinish:videoURL withError:error];
        }];
    }
    
    // Releasing the images
    self.images = nil;
    self.currentImageSegmentRemake.images = nil;
    
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    //We will save that image, but will not close the picker since we want the user to select multiple images. The picker will be closed only after the user clicks on the "done" button (see below)
    
    // Getting the image that the user selected
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    HMGLogInfo(@"image selected: %@",[image description]);
    
    // Adding the selected image to the images array
    [self.images addObject:image];
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
}

#pragma mark text segment methods

//this function is called when the user wants to remake a text segment
-(void)editTextSegment
{
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    self.textFieldAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"HELLO", nil) message:NSLocalizedString(@"ENTER_TEXT", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"DONE", nil) otherButtonTitles:nil];
    
    self.textFieldAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [self.textFieldAlertView textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeDefault;
    alertTextField.placeholder = NSLocalizedString(@"ENTER_SEGMENT_TEXT", nil);
    [self.textFieldAlertView show];
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
}


//delegation from uialertview
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    
    if ( self.textFieldAlertView == alertView )
    {
        NSString *segmentText = [[alertView textFieldAtIndex:0] text];
        HMGLogInfo(@"user entered text: %@" , segmentText);
        self.currentTextSegmentRemake.text = segmentText;
        [self.currentTextSegmentRemake processVideoAsynchronouslyWithCompletionHandler:^(NSURL *videoURL, NSError *error) {
            
            [self videoProcessDidFinish:videoURL withError:error];
            
        }];
    }
    
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
}


#pragma mark general functions

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    HMGLogWarning(@"received a memory warning!");
    // Dispose of any resources that can be recreated.
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
}

//convert from cmtime structure to MIN:SEC format
//TBD - this Function shoule not be here
-(NSString *)formatToTimeString:(CMTime)duration
{
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    NSUInteger dTotalSeconds = CMTimeGetSeconds(duration);
    NSUInteger dMinutes = floor(dTotalSeconds % 3600 / 60);
    NSUInteger dSeconds = floor(dTotalSeconds % 3600 % 60);
    NSString *videoDurationText = [NSString stringWithFormat:@"%02i:%02i", dMinutes, dSeconds];
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
    return videoDurationText;
}

@end
