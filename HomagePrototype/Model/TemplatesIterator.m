//
//  TemplateManager.m
//  HomagePrototype
//
//  Created by Tomer Harry on 8/29/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "TemplatesIterator.h"

@interface TemplatesIterator ()

    // The current position of the returned templates (this is how we know what is the next templates that needs to be returned
    @property (nonatomic) int position;

@end

@implementation TemplatesIterator


// Overriding the init method in order to initialize the numOfTemplatesPerIteration with default value
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.maxNumOfTemplatesPerIteration = 3;
    }
    
    return self;
}


// Returns the next list of templates (the maxNumOfTemplatesPerIteration property determines how many templates will be returned in each iteration. in the last iteration, less templates might return). nil will be returned when no templates are left
- (NSArray*)next
{
    if (self.position == 0)
    {
        Template *template1 = [[Template alloc] init];
        template1.name = @"Template 1";
        
        Template *template2 = [[Template alloc] init];
        template2.name = @"Template 2";
        
        Template *template3 = [[Template alloc] init];
        template3.name = @"Template 3";
    
        return [[NSArray alloc] initWithObjects:template1, template2, template3, nil];
    }
    else
    {
        return nil;
    }
}

@end
