//
//  HMGRecordSegmentViewConroller.m
//  HomagePrototype
//
//  Created by Tomer Harry on 9/23/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGRecordSegmentViewConroller.h"
#import "HMGFileManager.h"
#import "HMGLog.h"

@interface HMGRecordSegmentViewConroller ()
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureMovieFileOutput *captureOutput;
@property (nonatomic, weak) AVCaptureDeviceInput *activeVideoInput;
@property (strong,nonatomic) IBOutlet UILabel *segmentDuration;
@property (strong,nonatomic) IBOutlet UILabel *currentRecordTime;
@property (strong,nonatomic) NSTimer *recordDurationTracker;
@property (nonatomic, strong)  AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic,strong) NSURL *tempUrl;
@end

static NSString * const VIDEO_FILE_PREFIX = @"raw";
static NSString * const VIDEO_FILE_TYPE = @"mov";

@implementation HMGRecordSegmentViewConroller

- (void)viewDidLoad
{
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    [super viewDidLoad];
	[self setUpCaptureSession];
    self.segmentDuration.text = [self formatToTimeString:self.videoSegmentRemake.segment.duration];
    HMGLogDebug(@"%s finished", __PRETTY_FUNCTION__);
}

//convert from cmtime structure to MIN:SEC format. this is code dupliation from reviewsegmentsVC and we should have a general file for methods like this
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
                                 
                                 
- (void)setUpCaptureSession
{
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    self.captureSession = [[AVCaptureSession alloc] init];
	NSError *error;
    
	// Set up hardware devices
	AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	if (videoDevice) {
		AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
		if (input) {
			[self.captureSession addInput:input];
			self.activeVideoInput = input;
		}
	}
	AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
	if (audioDevice) {
		AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
		if (audioInput) {
			[self.captureSession addInput:audioInput];
		}
	}
	// Setup the still image file output
	AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
	[stillImageOutput setOutputSettings:@{AVVideoCodecKey : AVVideoCodecJPEG}];
    
	if ([self.captureSession canAddOutput:stillImageOutput]) {
		[self.captureSession addOutput:stillImageOutput];
	}
    
	// Start running session so preview is available
	[self.captureSession startRunning];
    
	// Set up preview layer
	dispatch_async(dispatch_get_main_queue(), ^{
		self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
		self.previewLayer.frame = self.previewView.bounds;
		self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
		[[self.previewLayer connection] setVideoOrientation:[self currentVideoOrientation]];
		[self.previewView.layer addSublayer:self.previewLayer];
	});
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);

}



- (AVCaptureVideoOrientation)currentVideoOrientation {
	UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
	if (deviceOrientation == UIDeviceOrientationLandscapeLeft) {
		return AVCaptureVideoOrientationLandscapeRight;
	} else {
		return AVCaptureVideoOrientationLandscapeLeft;
	}
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[[self.previewLayer connection] setVideoOrientation:[self currentVideoOrientation]];
}

- (void)didReceiveMemoryWarning
{
    //TBD - Do i need this Method?
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startStopRecording:(id)sender
{
    HMGLogDebug(@"%s started", __PRETTY_FUNCTION__);
    
    if ([sender isSelected])
    {
        [sender setSelected:NO];
        [self.captureOutput stopRecording];
        HMGLogDebug(@"invalidating timer");
        [self.recordDurationTracker invalidate];

        
    }else
    {
		[sender setSelected:YES];
		if (!self.captureOutput)
        {
			self.captureOutput = [[AVCaptureMovieFileOutput alloc] init];
			[self.captureSession addOutput:self.captureOutput];
        }
		[self.captureSession startRunning];
        
        
		AVCaptureConnection *videoConnection = [self connectionWithMediaType:AVMediaTypeVideo fromConnections:self.captureOutput.connections];
        
		if ([videoConnection isVideoOrientationSupported]) {
			videoConnection.videoOrientation = [self currentVideoOrientation];
		}
        
		if ([videoConnection isVideoStabilizationSupported]) {
			videoConnection.enablesVideoStabilizationWhenAvailable = YES;
		}
        
        self.tempUrl =[HMGFileManager uniqueUrlWithPrefix:VIDEO_FILE_PREFIX ofType:VIDEO_FILE_TYPE];
		[self.captureOutput startRecordingToOutputFileURL:self.tempUrl recordingDelegate:self];
        HMGLogDebug(@"initiating timer for keeping track of record duration");
        self.recordDurationTracker = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateRecordDuration) userInfo:nil repeats:YES];
        //self.toggleCameraButton.enabled = ![sender isSelected];
	}
    
    HMGLogDebug(@"%s ended", __PRETTY_FUNCTION__);
}
- (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections {
	for (AVCaptureConnection *connection in connections) {
		for (AVCaptureInputPort *port in [connection inputPorts]) {
			if ([[port mediaType] isEqual:mediaType]) {
				return connection;
			}
		}
	}
	return nil;
}
                                 
                                 

#pragma mark - AVCaptureFileOutputRecordingDelegate

// This method is being invoked once the video record finished
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    HMGLogDebug(@"%s started", __PRETTY_FUNCTION__);

	if (!error)
    {
        
        //calling delegate function to pass data back to reviewSegmentsViewController
        NSURL *videoToPassBack = outputFileURL;
        [self.delegate addItemViewController:self didFinishGeneratingVideo:videoToPassBack];
        
        //old code
        /*self.videoSegmentRemake.video = outputFileURL;
         self.videoSegmentRemake processVideoAsynchronouslyWithCompletionHandler:^(NSURL *videoURL, NSError *error) {
            [self videoProcessDidFinish:videoURL withError:error];
        }];*/
    }
    else
    {
        HMGLogError([error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR", nil) message:[error localizedDescription]
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alert show];
	}
    
    [self.navigationController popViewControllerAnimated:YES];
    
    HMGLogDebug(@"%s ended", __PRETTY_FUNCTION__);
}

-(void)updateRecordDuration
{
    HMGLogDebug(@"%s started", __PRETTY_FUNCTION__);
    //case for recorded duration is still within time duration of segment
    if (CMTimeCompare(self.captureOutput.recordedDuration,self.videoSegmentRemake.segment.duration) == 1) {
        self.currentRecordTime.textColor = [UIColor redColor];
    }
    
    self.currentRecordTime.text = [self formatToTimeString:self.captureOutput.recordedDuration];
    HMGLogDebug(@"%s ended", __PRETTY_FUNCTION__);
}

@end
