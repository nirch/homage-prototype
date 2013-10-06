//
//  TemplateManager.m
//  HomagePrototype
//
//  Created by Tomer Harry on 8/29/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGTemplateIterator.h"
#import "HMGTemplateCSVLoader.h"
#import "HMGLog.h"

@interface HMGTemplateIterator ()

    // The current position of the returned templates (this is how we know what is the next templates that needs to be returned
    @property (nonatomic) int position;

@end

@implementation HMGTemplateIterator

// Convenient init, to initialize the iterator with a customer number of returned templates per iteration
-(id)initWithCustom:(NSInteger) numOfTemplatesPerIteration
{
    self = [super init];
    
    if (self)
    {
        self.numOfTemplatesPerIteration = numOfTemplatesPerIteration;
        self.position = 0;
    }
    
    return self;
}

// Overriding the init method in order to initialize the numOfTemplatesPerIteration with default value
- (id)init
{
    return [self initWithCustom:DEFUALT_TEMPLATES_PER_ITERATION];
}


// Returns the next list of templates (the maxNumOfTemplatesPerIteration property determines how many templates will be returned in each iteration. in the last iteration, less templates might return). nil will be returned when no templates are left
- (NSArray*)next
{
    HMGLogDebug(@"%s started", __PRETTY_FUNCTION__);
    
    HMGTemplateCSVLoader *templateLoader = [[HMGTemplateCSVLoader alloc] init];
    NSMutableArray *templates = [[NSMutableArray alloc] init];
    
    for (int index = 0; index < self.numOfTemplatesPerIteration; ++index)
    {
        HMGTemplate *template = [templateLoader templateAtIndex:self.position];
        ++self.position;
        
        if (template)
        {
            [templates addObject:template];
        }
    }
    
    if ([templates count] == 0)
    {
        return nil;
    }
    else
    {
        return [NSArray arrayWithArray:templates];
    }
    
    HMGLogDebug(@"%s ended", __PRETTY_FUNCTION__);
}

// Overriding the setter so it will only accept values bigger than 0. Throwing an exception if the value is less than 1 since this is a programmatic error
-(void) setNumOfTemplatesPerIteration:(NSInteger) customNumOfTemplatesPerIteration
{
    if (customNumOfTemplatesPerIteration <= 0)
    {
        [NSException raise:@"Invalid numOfTemplatesPerIteration value" format:@"value of %d is invalid (value must be > 0)", customNumOfTemplatesPerIteration];
    }
    
    _numOfTemplatesPerIteration = customNumOfTemplatesPerIteration;
}

@end
