//
//  HMGTemplateCSVLoader.m
//  HomagePrototype
//
//  Created by Tomer Harry on 9/9/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGTemplateCSVLoader.h"

@interface HMGTemplateCSVLoader () <CHCSVParserDelegate>
@property (nonatomic) NSUInteger loadIndex;
@property (nonatomic) NSUInteger currentIndex;
@property (strong, nonatomic) HMGTemplate *template;
@end

@implementation HMGTemplateCSVLoader

// Listing the template fields of the CSV
enum TemplateFields {
    TemplateID,
    TemplateName,
    TemplateDescription,
    TemplateLevel,
    TemplateVideo,
    TemplateSoundtrack,
    TemplateThumbnail
};

// Loads a template at the given index
- (HMGTemplate *)templateAtIndex:(NSUInteger) index
{
    // Initializing the properties
    self.loadIndex = index + 2; //adding 2 to the index since the first record is 1 and not 0, and since the first record is a header
    self.template = nil;
    
    // Path for the CSV file
    NSString *csvFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"Templates.csv" ofType:@""];
    
    CHCSVParser *csvParser = [[CHCSVParser alloc] initWithContentsOfCSVFile:csvFilePath];
 
    csvParser.delegate = self;
    [csvParser parse];
    
    return self.template;
}

#pragma mark - CHCSVParserDelegate

- (void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber
{
    self.currentIndex = recordNumber;
    
    if (self.currentIndex == self.loadIndex)
    {
        self.template = [[HMGTemplate alloc] init];
    }
}

- (void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex
{
    // We are always loading a single template, so I we are checking that the current index (record) that we are parsing matches the desired template that should be returned, otherwise doing nothing
    if (self.currentIndex == self.loadIndex)
    {
        NSString *fullFilePath;
        
        switch (fieldIndex)
        {
            case TemplateID:
                self.template.templateID = field;
                break;
            case TemplateName:
                self.template.name = field;
                break;
            case TemplateDescription:
                self.template.description = field;
                break;
            case TemplateLevel:
                self.template.level = [field intValue];
                break;
            case TemplateVideo:
                fullFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:field ofType:@""];
                self.template.video = [NSURL fileURLWithPath:fullFilePath];
                break;
            case TemplateSoundtrack:
                fullFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:field ofType:@""];
                self.template.soundtrack = [NSURL fileURLWithPath:fullFilePath];
                break;
            case TemplateThumbnail:
                fullFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:field ofType:@""];
                self.template.thumbnail = [UIImage imageWithContentsOfFile:fullFilePath];
                break;
        }
    }
}

- (void)parser:(CHCSVParser *)parser didFailWithError:(NSError *)error
{
    NSLog(@"%@", error.description);
}

@end
