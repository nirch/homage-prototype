//
//  HomagePrototypeTests.m
//  HomagePrototypeTests
//
//  Created by Tomer Harry on 8/29/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HomagePrototypeTests.h"
#import "HMGAVUtils.h"

@implementation HomagePrototypeTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    [HMGAVUtils mergeVideos:nil withSoundtrack:nil completion:^(AVAssetExportSession *exporter) {
        NSLog(@"Exporter Status :%d", exporter.status);
        NSLog(@"Exporter URL: %@", exporter.outputURL.description);
    }];
    //STFail(@"Unit tests are not implemented yet in HomagePrototypeTests");
}

@end
