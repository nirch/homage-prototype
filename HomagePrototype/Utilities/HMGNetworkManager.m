//
//  HMGNetworkManager.m
//  HomagePrototype
//
//  Created by Tomer Harry on 11/27/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGNetworkManager.h"
#import <MobileCoreServices/UTType.h>

@implementation HMGNetworkManager

// This method returns an NSURLRequest that will be used for uploading a file with parameters
+ (NSURLRequest*)requestToUploadURL:(NSURL *)url withFile:(NSURL *)file withParams:(NSDictionary *)params
{
    // Creating a new request with the POST method
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    // Creating the request body, boundary string and content type (multipart)
    NSMutableData *body = [NSMutableData data];
    NSString *boundary = @"--HomageBoundary"; // This is a boundary that will mark the different params in a multipart content tyoe request
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    // Appending the file to the body
    NSData *fileData = [NSData dataWithContentsOfFile:file.path];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *filename = [file.path lastPathComponent];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: attachment; name=\"file\"; filename=\"%@\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *mimeType = [HMGNetworkManager fileMIMEType:file.path];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimeType] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:fileData];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Appending the params to the body
    for (NSString *key in [params allKeys]) {
        NSString *value = [params objectForKey:key];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    return request;
}

+ (NSString*) fileMIMEType:(NSString*) file {
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (CFStringRef)CFBridgingRetain([file pathExtension]), NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    return (NSString *)CFBridgingRelease(MIMEType);
}


@end
