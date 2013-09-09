//
//  TemplateCSVLoaderTests.m
//  HomagePrototype
//
//  Created by Tomer Harry on 9/10/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "TemplateCSVLoaderTests.h"
#import "HMGTemplateCSVLoader.h"
#import "HMGTemplate.h"

@implementation TemplateCSVLoaderTests

- (void)testLoadTemplate
{
    HMGTemplateCSVLoader *templateLoader = [[HMGTemplateCSVLoader alloc] init];
    
    HMGTemplate *template = [templateLoader templateAtIndex:0];
    
    STAssertTrue([template.templateID isEqualToString:@"1"], @"template ID not equal");
}

- (void)testNilTemplate
{
    HMGTemplateCSVLoader *templateLoader = [[HMGTemplateCSVLoader alloc] init];
    
    HMGTemplate *template = [templateLoader templateAtIndex:3];
    
    STAssertNil(template, @"Template Should be nil");
}

@end
