//
//  HMGTemplateCSVLoader.m
//  HomagePrototype
//
//  Created by Tomer Harry on 9/9/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGTemplateCSVLoader.h"
#import "HMGRemake.h"

@interface HMGTemplateCSVLoader () <CHCSVParserDelegate>
@property (nonatomic) NSUInteger loadIndex;
@property (nonatomic) NSUInteger currentIndex;
@property (strong, nonatomic) HMGTemplate *template;
@property (nonatomic) FileParsingEnum fileParsing;
@property (nonatomic) BOOL appendRemake;
@property (strong, nonatomic) HMGRemake *remake;
@property (strong, nonatomic) NSMutableArray *remakes;
@end

@implementation HMGTemplateCSVLoader

// Listing the template fields of the CSV. The order here must reflect the order in the CSV file itself
enum TemplateFields {
    TemplateID,
    TemplateName,
    TemplateDescription,
    TemplateLevel,
    TemplateVideo,
    TemplateSoundtrack,
    TemplateThumbnail
};

// Listing the remake fields of the CSV. The order here must reflect the order in the CSV file itself
enum RemakeFields {
    RemakeTemplateID,
    RemakeVideo,
    RemakeThumbnail
};


// Loads a template at the given index
- (HMGTemplate *)templateAtIndex:(NSUInteger) index
{
    // Initializing the properties
    self.loadIndex = index + 2; //adding 2 to the index since the first record is 1 and not 0, and since the first record is a header
    self.template = nil;
    self.remake = nil;
    self.remakes = [[NSMutableArray alloc] init];
    
    // Path for the templates CSV file
    NSString *templatesCSVFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"Templates.csv" ofType:@""];
    CHCSVParser *templatesCSVParser = [[CHCSVParser alloc] initWithContentsOfCSVFile:templatesCSVFilePath];
    templatesCSVParser.delegate = self;
    self.fileParsing = TemplatesParser;
    [templatesCSVParser parse];


    // If a template was loaded we are procedding with loading its remakes
    if (self.template)
    {
        NSString *remakesCSVFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"Remakes.csv" ofType:@""];
        CHCSVParser *remakesCSVParser = [[CHCSVParser alloc] initWithContentsOfCSVFile:remakesCSVFilePath];
        remakesCSVParser.delegate = self;
        self.fileParsing = RemakesParser;
        [remakesCSVParser parse];
    }

    
    return self.template;
}

#pragma mark - CHCSVParserDelegate

- (void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber
{
    // Checking which file we are now parsing
    if (self.fileParsing == TemplatesParser)
    {
        // Saving the current index that is parsed. If the current index matches the template we need to return, then we are initializing the template object
        self.currentIndex = recordNumber;
        if (self.currentIndex == self.loadIndex)
        {
            self.template = [[HMGTemplate alloc] init];
        }
    }
    else if (self.fileParsing == RemakesParser)
    {
        // In the begining of each record we will set the "appendRemake" boolean to false, later we will check if we should append this remake or not
        self.appendRemake = NO;
    }
}

- (void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex
{
    NSString *fullFilePath;
    
    // Checking which file we are now parsing
    if (self.fileParsing == TemplatesParser)
    {
        // We are always loading a single template, so I we are checking that the current index (record) that we are parsing matches the desired template that should be returned, otherwise doing nothing
        if (self.currentIndex == self.loadIndex)
        {
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
    else if (self.fileParsing == RemakesParser)
    {
        switch (fieldIndex)
        {
            case RemakeTemplateID:
                // Checking that the current remake template id parsed matches the template id that will be returned
                if ([field isEqualToString:self.template.templateID])
                {
                    self.appendRemake = YES;
                    self.remake = [[HMGRemake alloc] init];
                }
                break;
            case RemakeVideo:
                if (self.appendRemake)
                {
                    fullFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:field ofType:@""];
                    self.remake.video = [NSURL fileURLWithPath:fullFilePath];
                }
                break;
            case RemakeThumbnail:
                if (self.appendRemake)
                {
                    fullFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:field ofType:@""];
                    self.remake.thumbnail = [UIImage imageWithContentsOfFile:fullFilePath];
                }
                break;
        }
    }
}

- (void)parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber
{
    if (self.fileParsing == RemakesParser)
    {
        if (self.appendRemake)
        {
            [self.remakes addObject:self.remake];
        }
    }
}

- (void)parserDidEndDocument:(CHCSVParser *)parser
{
    if (self.fileParsing == RemakesParser)
    {
        self.template.remakes = [NSArray arrayWithArray:self.remakes];
    }
}

- (void)parser:(CHCSVParser *)parser didFailWithError:(NSError *)error
{
    NSLog(@"%@", error.description);
}

@end
