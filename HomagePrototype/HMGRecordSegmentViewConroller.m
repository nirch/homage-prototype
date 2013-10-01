//
//  HMGRecordSegmentViewConroller.m
//  HomagePrototype
//
//  Created by Tomer Harry on 9/23/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGRecordSegmentViewConroller.h"
#import "HMGFileManager.h"
//TBD - Understand how exactly the output of the Video Works

#define VIDEO_FILE_PREFIX @"test"
#define VIDEO_FILE_TYPE @".mov"

@interface HMGRecordSegmentViewConroller ()
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureMovieFileOutput *captureOutput;
@property (nonatomic, weak) AVCaptureDeviceInput *activeVideoInput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
//TBD - Check with Nir if this is the Right way to do this
@property (nonatomic,strong) NSURL *tempUrl;

@end

@implementation HMGRecordSegmentViewConroller

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
	[self setUpCaptureSession];
}

- (void)setUpCaptureSession
{
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
    //TBD - Understand what is the puepose of this code
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
        
		//[[self.previewLayer connection] setVideoOrientation:[self currentVideoOrientation]];
		[self.previewView.layer addSublayer:self.previewLayer];
	});

}

- (AVCaptureVideoOrientation)currentVideoOrientation {
	UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
	if (deviceOrientation == UIDeviceOrientationLandscapeLeft) {
		return AVCaptureVideoOrientationLandscapeRight;
	} else {
		return AVCaptureVideoOrientationLandscapeLeft;
	}
}
- (void)didReceiveMemoryWarning
{
    //TBD - Do i need this Method?
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AVCaptureFileOutputRecordingDelegate

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
	if (!error) {
    //TBD - What to do in after the Video Is captured
    } else {
		NSLog(@"Error: %@", [error localizedDescription]);
	}
}

- (IBAction)startRecording:(id)sender
{
    if ([sender isSelected])
    {
        [sender setSelected:NO];
        [self.captureOutput stopRecording];
        //Logic of filling the SegmentRemake - the URL of the Video should be placed in a different location then the current outputURL function
// NIR***** change this code        [self.videoSegmentRemake assignVideo:self.tempUrl];
        [self.navigationController popViewControllerAnimated:YES];
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
        //self.toggleCameraButton.enabled = ![sender isSelected];
	}

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
//- (NSURL *)outputURL {
//	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//   
//	NSUUID  *UUID = [NSUUID UUID];
//    NSString *fileName = [[UUID UUIDString] stringByAppendingString:VIDEO_FILE];
//    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
//    self.tempUrl = [NSURL fileURLWithPath:filePath];
//	return self.tempUrl;
//}
@end
