//
//  HMGTextSegment.h
//  HomagePrototype
//
//  Created by Tomer Harry on 9/12/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGSegment.h"

@interface HMGTextSegment : HMGSegment

typedef enum {
    Top,
    Center,
    Bottom
} HMGTextLocation;


@property (strong, nonatomic) NSString *font;
@property (nonatomic) CGFloat fontSize;
@property (nonatomic) NSUInteger numOfLines;
@property (nonatomic) HMGTextLocation location;
@property (strong, nonatomic) NSString *imagePath;

@property (nonatomic, strong) NSString *templateFolder;
@property (nonatomic, strong) NSString *dynamicText;

@end
