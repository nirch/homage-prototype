//
//  Template.h
//  HomagePrototype
//
//  Created by Tomer Harry on 8/29/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMGTemplate : NSObject

@property (strong, nonatomic) NSUUID *templateID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *level;
@property (strong, nonatomic) NSURL *video;
@property (strong, nonatomic) NSArray *remakes;
@property (strong, nonatomic) NSArray *segments;
@property (strong, nonatomic) NSURL *soundtrack;
@property (strong, nonatomic) UIImage *thumbnail;


@end
