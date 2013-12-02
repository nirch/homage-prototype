//
//  HMGTake.h
//  HomagePrototype
//
//  Created by Yoav Caspin on 10/27/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMGTake : NSObject <NSCoding>

@property (strong,nonatomic) NSURL   *videoURL;
@property (strong,nonatomic) UIImage *thumbnail;
@property (nonatomic) BOOL selected;

@end
