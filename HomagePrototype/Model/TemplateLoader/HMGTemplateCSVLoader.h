//
//  HMGTemplateCSVLoader.h
//  HomagePrototype
//
//  Created by Tomer Harry on 9/9/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "HMGTemplate.h"
#include "CSVParser/CHCSVParser.h"

@interface HMGTemplateCSVLoader : NSObject

//@property (strong, nonatomic, readonly) CHCSVParser

// Loads a template at the given index
- (HMGTemplate *)templateAtIndex:(NSUInteger) index;

@end
