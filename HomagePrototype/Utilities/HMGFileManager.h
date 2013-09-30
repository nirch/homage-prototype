//
//  HMGFileManager.h
//  HomagePrototype
//
//  Created by Tomer Harry on 9/29/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMGFileManager : NSObject
//TBD - Should i make this a Static Class?
- (NSURL *)outputURL:(NSString *)fileName;
-(NSURL *)copyVideoToNewURL:(NSURL *) videoURL forFileName:(NSString *)fileName;

@end
