//
//  NetworkManagerTests.m
//  HomagePrototype
//
//  Created by Tomer Harry on 11/27/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "HMGNetworkManager.h"
#import "AGWaitForAsyncTestHelper.h"

@interface NetworkManagerTests : SenTestCase

@property (strong, nonatomic) NSURL *serverUploadURL;
@property (strong, nonatomic) NSURL *serverUpdateTextURL;
@property (strong, nonatomic) NSURL *redVideo;
@property (strong, nonatomic) NSURL *finishLineVideo;


@end

static NSString * const redVideoName = @"Red.mov";
static NSString * const finishLineVideoName = @"Tikim_FinishLine_Export.mp4";


@implementation NetworkManagerTests

- (void)setUp
{
    [super setUp];
    
    self.serverUploadURL = [NSURL URLWithString:@"http://54.204.34.168:4567/upload"];
    
    self.serverUpdateTextURL = [NSURL URLWithString:@"http://54.204.34.168:4567/update_text"];
    
    NSString *redVideoPath = [[NSBundle bundleForClass:[self class]] pathForResource:redVideoName ofType:nil];
    self.redVideo = [NSURL fileURLWithPath:redVideoPath];
    
    NSString *finishLinePath = [[NSBundle bundleForClass:[self class]] pathForResource:finishLineVideoName ofType:nil];
    self.finishLineVideo = [NSURL fileURLWithPath:finishLinePath];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

// Testing the request bodu size, it should be bigger than the size of the file we want to upload
- (void)testRequestBodySize
{
    NSURLRequest *request = [HMGNetworkManager requestToUploadURL:self.serverUploadURL withFile:self.redVideo withParams:nil];
    
    NSData *videoData = [NSData dataWithContentsOfFile:self.redVideo.path];
    
    STAssertTrue([request HTTPBody].length > videoData.length, nil);
}

- (void)testMIMEType
{
    NSString *mimeType = [HMGNetworkManager fileMIMEType:self.redVideo.path];
    
    STAssertTrue([mimeType isEqualToString:@"video/quicktime"], nil);
}

/*
- (void)testRender
{
    NSURL *serverRender = [NSURL URLWithString:@"http://54.204.34.168:4567/render"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *fileOutputName = @"output";
    __block BOOL jobDone = NO;
    NSDictionary *postParams = [NSDictionary dictionaryWithObjectsAndKeys:@"Test.aep", @"template_project", @"Test", @"template_folder", fileOutputName, @"output", nil];
    
    // Build POST request
    NSURLRequest *request = [HMGNetworkManager createPostRequestURL:serverRender withParams:postParams];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error)
        {
            STFail(error.description);
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        STAssertTrue(httpResponse.statusCode == 200, nil);
        
        jobDone = YES;
    }];
    
    [postDataTask resume];
    
    // Waiting 30 seconds for the above block to complete
    WAIT_WHILE(!jobDone, 30);
}


- (void)testUpdateText
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *text = @"My Text";
    __block BOOL jobDone = NO;
    NSDictionary *postParams = [NSDictionary dictionaryWithObjectsAndKeys:text, @"dynamic_text", @"Test", @"template_folder", @"DynamicText.txt", @"dynamic_text_file", nil];
    
    // Build POST request
    NSURLRequest *request = [HMGNetworkManager createPostRequestURL:self.serverUpdateTextURL withParams:postParams];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error)
        {
            STFail(error.description);
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        STAssertTrue(httpResponse.statusCode == 200, nil);
        
        jobDone = YES;
    }];
    
    [postDataTask resume];
    
    // Waiting 3 seconds for the above block to complete
    WAIT_WHILE(!jobDone, 3);
}


// Testing the upload of a small file (˜145KB)
- (void)testUploadSmallFile
{
    __block BOOL jobDone = NO;
    NSURLSession *session = [NSURLSession sharedSession];

    NSDictionary *uploadParams = [NSDictionary dictionaryWithObjectsAndKeys:@"Test", @"template_folder", @"test.mov", @"segment_file", nil];
    
    NSURLRequest *request = [HMGNetworkManager requestToUploadURL:self.serverUploadURL withFile:self.redVideo withParams:uploadParams];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:[request HTTPBody] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error)
        {
            STFail(error.description);
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        STAssertTrue(httpResponse.statusCode == 200, nil);

        jobDone = YES;
    }];
    
    [uploadTask resume];

    // Waiting 3 seconds for the above block to complete
    WAIT_WHILE(!jobDone, 3);
}

// Testing the upload of a big file (˜5MB)
- (void)testUploadBigFile
{
    __block BOOL jobDone = NO;
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSDictionary *uploadParams = [NSDictionary dictionaryWithObjectsAndKeys:@"Test", @"template_folder", @"test.mov", @"segment_file", nil];
    
    NSURLRequest *request = [HMGNetworkManager requestToUploadURL:self.serverUploadURL withFile:self.finishLineVideo withParams:uploadParams];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:[request HTTPBody] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error)
        {
            STFail(error.description);
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        STAssertTrue(httpResponse.statusCode == 200, nil);
        
        NSLog(@"%@", response.description);
        jobDone = YES;
    }];
    
    [uploadTask resume];
    
    // Waiting 30 seconds for the above block to complete
    WAIT_WHILE(!jobDone, 30);
}
*/

@end
