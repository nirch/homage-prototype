//
//  Template.m
//  HomagePrototype
//
//  Created by Tomer Harry on 8/29/13.
//  Copyright (c) 2013 Homage. All rights reserved.
// this is a Test
// another Try

#import "HMGTemplate.h"
#import "HMGLog.h"

@implementation HMGTemplate

-(NSString *) levelDescription
{
    switch (self.level) {
        case Easy:
            return NSLocalizedString(@"TEMPLATE_EASY",nil);
            break;
        case Medium:
            return NSLocalizedString(@"TEMPLATE_MEDIUM",nil);
            break;
        case Hard:
            return NSLocalizedString(@"TEMPLATE_HARD",nil);
            break;
        default:
            HMGLogWarning(@"this template has a non defined level: %@" , self.level);
            return nil;
            break;
    }

}

@end
