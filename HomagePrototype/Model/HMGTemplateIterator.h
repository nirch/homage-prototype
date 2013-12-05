//
//  TemplateManager.h
//  HomagePrototype
//
//  Created by Tomer Harry on 8/29/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMGTemplate.h"

#define DEFUALT_TEMPLATES_PER_ITERATION 4

@interface HMGTemplateIterator : NSObject

// This property determins the max number of templates that will be returned in each iteration (in the last iteration, less templates might return)
@property (nonatomic) NSInteger numOfTemplatesPerIteration;

// Convenient init, to initialize the iterator with a customer number of returned templates per iteration
-(id)initWithCustom:(NSInteger) numOfTemplatesPerIteration;

// Returns the next list of templates (the maxNumOfTemplatesPerIteration property determines how many templates will be returned in each iteration. in the last iteration, less templates might return). nil will be returned when no templates are left
- (NSArray*)next;

@end
