//
//  AVUtilsTests.m
//  HomagePrototype
//
//  Created by Tomer Harry on 9/29/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "HMGAVUtils.h"

@interface AVUtilsTests : SenTestCase

@property (strong, nonatomic) NSMutableArray *resourcesToDelete;

@property (strong, nonatomic) NSURL *video1;
@property (strong, nonatomic) NSURL *video2;

@end

static NSString * const video1Name = @"Red.mov";
static NSString * const video2Name = @"Tikim_Text.mp4";

@implementation AVUtilsTests

- (void)setUp
{
    [super setUp];

    NSString *video1Path = [[NSBundle bundleForClass:[self class]] pathForResource:video1Name ofType:nil];
    self.video1 = [NSURL fileURLWithPath:video1Path];
    
    NSString *video2Path = [[NSBundle bundleForClass:[self class]] pathForResource:video2Name ofType:nil];
    self.video2 = [NSURL fileURLWithPath:video2Path];
    
    self.resourcesToDelete = [[NSMutableArray alloc] init];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

// Testing that the setUp method successfully initialized the properties
- (void)testSetUp
{
    NSLog(@"Video 1 URL: %@", self.video1.description);
    
    // Checking that the URL of the video contains the name of the video
    STAssertTrue([self.video1.description rangeOfString:video1Name].location != NSNotFound, @"Video name:<%@> was not found in URL:<%@>", video1Name, self.video1.description);
    
    NSLog(@"Video 2 URL: %@", self.video2.description);
    
    // Checking that the URL of the video contains the name of the video
    STAssertTrue([self.video2.description rangeOfString:video2Name].location != NSNotFound, @"Video name:<%@> was not found in URL:<%@>", video2Name, self.video2.description);
    
}

- (void)testMergeVideosNoSoundtrack
{
    NSArray *videosToMerge = @[self.video1, self.video2];
    
    [HMGAVUtils mergeVideos:videosToMerge withSoundtrack:nil completion:^(AVAssetExportSession *exporter) {
        NSLog(@"Exporter Status :%d", exporter.status);
        NSLog(@"Exporter URL: %@", exporter.outputURL.description);
    }];
}

@end
