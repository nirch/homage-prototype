//
//  HMGRemakeProject.h
//  HomagePrototype
//
//  Created by Tomer Harry on 9/22/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMGTemplate.h"

@interface HMGRemakeProject : NSObject

@property (strong, nonatomic) HMGTemplate *templateObj;
@property (strong, nonatomic) NSString *user;
@property (strong, nonatomic) NSArray *segmentRemakes;

- (id)initWithTemplate:(HMGTemplate *) templateObj;

- (NSURL *)createVideo;

@end
