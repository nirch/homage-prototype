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

@end

@implementation AVUtilsTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testExample
{
    [HMGAVUtils mergeVideos:nil withSoundtrack:nil completion:^(AVAssetExportSession *exporter) {
        NSLog(@"Exporter Status :%d", exporter.status);
        NSLog(@"Exporter URL: %@", exporter.outputURL.description);
    }];
   // STFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
