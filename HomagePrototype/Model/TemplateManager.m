//
//  TemplateManager.m
//  HomagePrototype
//
//  Created by Tomer Harry on 8/29/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "TemplateManager.h"

@implementation TemplateManager

+ (NSArray*)getTemplates
{
    Template *template1 = [[Template alloc] init];
    template1.name = @"Template 1";
    
    Template *template2 = [[Template alloc] init];
    template2.name = @"Template 2";
    
    Template *template3 = [[Template alloc] init];
    template3.name = @"Template 3";
    
    return [[NSArray alloc] initWithObjects:template1, template2, template3, nil];
}

@end
