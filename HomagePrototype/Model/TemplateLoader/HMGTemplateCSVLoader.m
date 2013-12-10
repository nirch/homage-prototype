//
//  HMGTemplateCSVLoader.m
//  HomagePrototype
//
//  Created by Tomer Harry on 9/9/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGTemplateCSVLoader.h"
#import "HMGRemake.h"
#import "HMGSegment.h"
#import "HMGVideoSegment.h"
#import "HMGImageSegment.h"
#import "HMGTextSegment.h"
#import "HMGFixedSegment.h"
#import "HMGLog.h"

@interface HMGTemplateCSVLoader () <CHCSVParserDelegate>
@property (nonatomic) NSUInteger loadTemplateAtRecord;
@property (nonatomic) NSUInteger currParsedRecord;
@property (strong, nonatomic) HMGTemplate *template;
@property (nonatomic) BOOL templateIdMatched;

@property (strong, nonatomic) HMGRemake *remake;
@property (strong, nonatomic) NSMutableArray *remakes;

@property (strong, nonatomic) HMGSegment *segment;
@property (strong, nonatomic) NSMutableArray *segments;


// Parsers (one per file we are parsing)
@property (strong, nonatomic) CHCSVParser *templatesCSVParser;
@property (strong, nonatomic) CHCSVParser *remakesCSVParser;
@property (strong, nonatomic) CHCSVParser *segmentsCSVParser;
@property (strong, nonatomic) CHCSVParser *videoSegmentsCSVParser;
@property (strong, nonatomic) CHCSVParser *imageSegmentsCSVParser;
@property (strong, nonatomic) CHCSVParser *textSegmentsCSVParser;


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
    TemplateThumbnail,
    TemplateFolder,
    TemplateProject,
    NumOfTemplateFields // Always ending with this value so we can know how many fields are there
};

// Listing the remake fields of the CSV. The order here must reflect the order in the CSV file itself
enum RemakeFields {
    RemakeTemplateID,
    RemakeVideo,
    RemakeThumbnail,
    NumOfRemakeFields
};

enum SegmentFields {
    SegmentTemplateID,
    SegmentType,
    SegmentName,
    SegmentDescription,
    SegmentDuarion,
    SegmentVideo,
    SegmentThumbnail,
    NumOfSegmentFields
};

// Defining the segment types
#define VIDEO_SEGMENT @"VideoSegment"
#define IMAGE_SEGMENT @"ImageSegment"
#define TEXT_SEGMENT @"TextSegment"

enum VideoSegmentFields {
    VideoSegmentTemplateID,
    VideoSegmentIndex,
    VideoSegmentRecordDuration,
    VideoSegmentTemplateFolder,
    VideoSegmentFile,
    NumOfVideoSegmentFields
};

enum ImageSegmentFields {
    ImageSegmentTemplateID,
    ImageSegmentIndex,
    ImageSegmentMinNumOfImages,
    ImageSegmentMaxNumOfImages,
    NumOfImageSegmentFields
};

enum TextSegmentFields {
    TextSegmentTemplateID,
    TextSegmentIndex,
    TextSegmentFont,
    TextSegmentFontSize,
    TextSegmentNumOfLines,
    TextSegmentLocation,
    TextSegmentVideo,
    TextSegmentImage,
    TextSegmentTemplateFolder,
    TextSegmentDynamicText,
    NumOfTextSegmentFields
};

- (void)initSelf:(NSUInteger)index
{
    // Initializing the properties
    self.loadTemplateAtRecord = index + 2; //adding 2 to the index since the first record is 1 and not 0, and since the first record is a header
    self.template = nil;
    self.remake = nil;
    self.remakes = [[NSMutableArray alloc] init];
    self.segment = nil;
    self.segments = [[NSMutableArray alloc] init];
}

// Loads a template at the given index
- (HMGTemplate *)templateAtIndex:(NSUInteger) index
{
    HMGLogDebug(@"[%@ %@] index: %d", [[self class] description], @"templateAtIndex", index);
    
    [self initSelf:index];
    
    // Parsing the templates CSV file
    NSString *templatesCSVFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"Templates.csv" ofType:@""];
    self.templatesCSVParser = [[CHCSVParser alloc] initWithContentsOfCSVFile:templatesCSVFilePath];
    self.templatesCSVParser.delegate = self;
    HMGLogDebug(@"Templates.csv parsing started");
    [self.templatesCSVParser parse];
    HMGLogDebug(@"Templates.csv parsing ended");
    
    // If a template was loaded we are procedding with loading the other parts of the template
    if (self.template)
    {
        // Parsing the template's remakes
        NSString *remakesCSVFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"Remakes.csv" ofType:@""];
        self.remakesCSVParser = [[CHCSVParser alloc] initWithContentsOfCSVFile:remakesCSVFilePath];
        self.remakesCSVParser.delegate = self;
        HMGLogDebug(@"Remakes.csv parsing started");
        [self.remakesCSVParser parse];
        HMGLogDebug(@"Remakes.csv parsing ended");

        // Loading the template's segments
        NSString *segmentsCSVFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"Segments.csv" ofType:@""];
        self.segmentsCSVParser = [[CHCSVParser alloc] initWithContentsOfCSVFile:segmentsCSVFilePath];
        self.segmentsCSVParser.delegate = self;
        HMGLogDebug(@"Segments.csv parsing started");
        [self.segmentsCSVParser parse];
        HMGLogDebug(@"Segments.csv parsing ended");
        
        // Updating the template's video segments
        NSString *videoSegmentsCSVFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"VideoSegments.csv" ofType:@""];
        self.videoSegmentsCSVParser = [[CHCSVParser alloc] initWithContentsOfCSVFile:videoSegmentsCSVFilePath];
        self.videoSegmentsCSVParser.delegate = self;
        HMGLogDebug(@"VideoSegments.csv parsing started");
        [self.videoSegmentsCSVParser parse];
        HMGLogDebug(@"VideoSegments.csv parsing ended");
        
        // Updating the template's image segments
        NSString *imageSegmentsCSVFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"ImageSegments.csv" ofType:@""];
        self.imageSegmentsCSVParser = [[CHCSVParser alloc] initWithContentsOfCSVFile:imageSegmentsCSVFilePath];
        self.imageSegmentsCSVParser.delegate = self;
        HMGLogDebug(@"ImageSegments.csv parsing started");
        [self.imageSegmentsCSVParser parse];
        HMGLogDebug(@"ImageSegments.csv parsing ended");
        
        // Updating the template's text segments
        NSString *textSegmentsCSVFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"TextSegments.csv" ofType:@""];
        self.textSegmentsCSVParser = [[CHCSVParser alloc] initWithContentsOfCSVFile:textSegmentsCSVFilePath];
        self.textSegmentsCSVParser.delegate = self;
        HMGLogDebug(@"TextSegments.csv parsing started");
        [self.textSegmentsCSVParser parse];
        HMGLogDebug(@"TextSegments.csv parsing ended");
    }

    
    return self.template;
}

#pragma mark - CHCSVParserDelegate

// This method is called in the beginning of each record parsed
- (void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber
{
    HMGLogDebug(@"[%@ %@] record: %d", [[self class] description], @"parser didBeginLine", recordNumber);
    
    // Checking which file we are now parsing
    if (parser == self.templatesCSVParser)
    {
        // Saving the current index that is parsed. If the current record matches the template we need to return, then we are initializing the template object
        self.currParsedRecord = recordNumber;
        if (self.currParsedRecord == self.loadTemplateAtRecord)
        {
            self.template = [[HMGTemplate alloc] init];
        }
    }
    
    // When we start parsing each record, the template id is still not matched until proved otherwise
    self.templateIdMatched = NO;
}

// This mehtod is called when for each field that is being parsed
- (void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex
{
    HMGLogDebug(@"[%@ %@] field: %@ index: %d", [[self class] description], @"parser didReadField", field, fieldIndex);
    
    NSString *fullFilePath;
    
    // Checking which file we are now parsing
    if (parser == self.templatesCSVParser)
    {
        // We are always loading a single template, so I we are checking that the current index (record) that we are parsing matches the desired template that should be returned, otherwise doing nothing
        if (self.currParsedRecord == self.loadTemplateAtRecord)
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
                    if (fullFilePath)
                    {
                        self.template.video = [NSURL fileURLWithPath:fullFilePath];
                    }
                    else
                    {
                        self.template.video = [NSURL URLWithString:field];
                    }
                    break;
                case TemplateSoundtrack:
                    fullFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:field ofType:@""];
                    if (fullFilePath) self.template.soundtrack = [NSURL fileURLWithPath:fullFilePath];
                    break;
                case TemplateThumbnail:
                    fullFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:field ofType:@""];
                    if (fullFilePath) {
                        self.template.thumbnailPath = fullFilePath;
                    } else {
                        self.template.thumbnailPath = field;
                    }
                    break;
                case TemplateFolder:
                    self.template.templateFolder = field;
                    break;
                case TemplateProject:
                    self.template.templateProject = field;
                    break;
            }
        }
    }
    else if (parser == self.remakesCSVParser)
    {
        switch (fieldIndex)
        {
            case RemakeTemplateID:
                // Checking that the current remake template id parsed matches the template id that will be returned
                if ([field isEqualToString:self.template.templateID])
                {
                    self.templateIdMatched = YES;
                    self.remake = [[HMGRemake alloc] init];
                }
                break;
            case RemakeVideo:
                if (self.templateIdMatched)
                {
                    fullFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:field ofType:@""];
                    self.remake.video = [NSURL fileURLWithPath:fullFilePath];
                }
                break;
            case RemakeThumbnail:
                if (self.templateIdMatched)
                {
                    fullFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:field ofType:@""];
                    self.remake.thumbnailPath = fullFilePath;
                }
                break;
        }
    }
    else if (parser == self.segmentsCSVParser)
    {
        switch (fieldIndex)
        {
            case SegmentTemplateID:
                // Checking that the current segment template id parsed matches the template id that will be returned
                if ([field isEqualToString:self.template.templateID])
                {
                    self.templateIdMatched = YES;
                }
                break;
            case SegmentType:
                if (self.templateIdMatched)
                {
                    if ([field isEqualToString:VIDEO_SEGMENT])
                    {
                        self.segment = [[HMGVideoSegment alloc] init];
                    }
                    else if ([field isEqualToString:IMAGE_SEGMENT])
                    {
                        self.segment = [[HMGImageSegment alloc] init];
                    }
                    else if ([field isEqualToString:TEXT_SEGMENT])
                    {
                        self.segment = [[HMGTextSegment alloc] init];
                    }
                    else
                    {
                        // raise exception
                        [NSException raise:@"Invalid SegmentType value in CSV file" format:@"value of %@ is invalid", field];
                    }
                }
                break;
            case SegmentName:
                if (self.templateIdMatched)
                {
                    self.segment.name = field;
                }
                break;
            case SegmentDescription:
                if (self.templateIdMatched)
                {
                    self.segment.description = field;
                }
                break;
            case SegmentDuarion:
                if (self.templateIdMatched)
                {
                    self.segment.duration = CMTimeMake([field integerValue], 1000);
                }
                break;
            case SegmentVideo:
                if (self.templateIdMatched)
                {
                    fullFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:field ofType:@""];
                    self.segment.video = [NSURL fileURLWithPath:fullFilePath];
                }
                break;
            case SegmentThumbnail:
                if (self.templateIdMatched)
                {
                    fullFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:field ofType:@""];
                    self.segment.thumbnailPath = fullFilePath;
                }
                break;
            default:
                [NSException raise:@"Invalid fieldIndex value for segments CSV" format:@"value of %d is invalid (value must be < %d)", fieldIndex, NumOfSegmentFields];
                break;
        }
    }
    else if (parser == self.videoSegmentsCSVParser)
    {
        switch (fieldIndex)
        {
            case VideoSegmentTemplateID:
                // Checking that the current segment template id parsed matches the template id that will be returned
                if ([field isEqualToString:self.template.templateID])
                {
                    self.templateIdMatched = YES;
                }
                break;
            case VideoSegmentIndex:
                if (self.templateIdMatched)
                {
                    // Getting the segment from the given index
                    self.segment = [self.template.segments objectAtIndex:[field integerValue]];
                }
                break;
            case VideoSegmentRecordDuration:
                if (self.templateIdMatched)
                {
                    HMGVideoSegment *videoSegment = (HMGVideoSegment*) self.segment;
                    videoSegment.recordDuration = CMTimeMake([field integerValue], 1000);
                }
                break;
            case VideoSegmentTemplateFolder:
                if (self.templateIdMatched)
                {
                    HMGVideoSegment *videoSegment = (HMGVideoSegment*) self.segment;
                    videoSegment.templateFolder = field;
                }
                break;
            case VideoSegmentFile:
                if (self.templateIdMatched)
                {
                    HMGVideoSegment *videoSegment = (HMGVideoSegment*) self.segment;
                    videoSegment.segmentFile = field;
                }
                break;
            default:
                [NSException raise:@"Invalid fieldIndex value for video segments CSV" format:@"value of %d is invalid (value must be < %d)", fieldIndex, NumOfVideoSegmentFields];
                break;
        }
    }
    else if (parser == self.imageSegmentsCSVParser)
    {
        switch (fieldIndex)
        {
            case ImageSegmentTemplateID:
                // Checking that the current segment template id parsed matches the template id that will be returned
                if ([field isEqualToString:self.template.templateID])
                {
                    self.templateIdMatched = YES;
                }
                break;
            case ImageSegmentIndex:
                if (self.templateIdMatched)
                {
                    // Getting the segment from the given index
                    self.segment = [self.template.segments objectAtIndex:[field integerValue]];
                }
                break;
            case ImageSegmentMinNumOfImages:
                if (self.templateIdMatched)
                {
                    HMGImageSegment *imageSegment = (HMGImageSegment*) self.segment;
                    imageSegment.minNumOfImages = [field integerValue];
                }
                break;
            case ImageSegmentMaxNumOfImages:
                if (self.templateIdMatched)
                {
                    HMGImageSegment *imageSegment = (HMGImageSegment*) self.segment;
                    imageSegment.maxNumOfImages = [field integerValue];
                }
                break;                
            default:
                [NSException raise:@"Invalid fieldIndex value for image segments CSV" format:@"value of %d is invalid (value must be < %d)", fieldIndex, NumOfImageSegmentFields];
                break;
        }
    }
    else if (parser == self.textSegmentsCSVParser)
    {
        switch (fieldIndex)
        {
            case TextSegmentTemplateID:
                // Checking that the current segment template id parsed matches the template id that will be returned
                if ([field isEqualToString:self.template.templateID])
                {
                    self.templateIdMatched = YES;
                }
                break;
            case TextSegmentIndex:
                if (self.templateIdMatched)
                {
                    // Getting the segment from the given index
                    self.segment = [self.template.segments objectAtIndex:[field integerValue]];
                }
                break;
            case TextSegmentFont:
                if (self.templateIdMatched)
                {
                    HMGTextSegment *textSegment = (HMGTextSegment*) self.segment;
                    textSegment.font = field;
                }
                break;
            case TextSegmentFontSize:
                if (self.templateIdMatched)
                {
                    HMGTextSegment *textSegment = (HMGTextSegment*) self.segment;
                    textSegment.fontSize = [field floatValue];
                }
                break;
            case TextSegmentNumOfLines:
                if (self.templateIdMatched)
                {
                    HMGTextSegment *textSegment = (HMGTextSegment*) self.segment;
                    textSegment.numOfLines = [field integerValue];
                }
                break;
            case TextSegmentLocation:
                if (self.templateIdMatched)
                {
                    HMGTextSegment *textSegment = (HMGTextSegment*) self.segment;
                    textSegment.location = [field integerValue];
                }
                break;
            case TextSegmentVideo:
                if (self.templateIdMatched)
                {
                    HMGTextSegment *textSegment = (HMGTextSegment*) self.segment;
                    fullFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:field ofType:@""];
                    
                    textSegment.video = [NSURL fileURLWithPath:fullFilePath];
                }
                break;
            case TextSegmentImage:
                if (self.templateIdMatched)
                {
                    HMGTextSegment *textSegment = (HMGTextSegment*) self.segment;
                    fullFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:field ofType:@""];
                    
                    textSegment.imagePath = fullFilePath;
                }
                break;
            case TextSegmentTemplateFolder:
                if (self.templateIdMatched)
                {
                    HMGTextSegment *textSegment = (HMGTextSegment*) self.segment;
                    textSegment.templateFolder = field;
                }
                break;
            case TextSegmentDynamicText:
                if (self.templateIdMatched)
                {
                    HMGTextSegment *textSegment = (HMGTextSegment*) self.segment;
                    textSegment.dynamicText = field;
                }
                break;
            default:
                [NSException raise:@"Invalid fieldIndex value for text segments CSV" format:@"value of %d is invalid (value must be < %d)", fieldIndex, NumOfTextSegmentFields];
                break;
        }
    }
}

// This method is called when the parser finishes to parse a certain record
- (void)parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber
{
    HMGLogDebug(@"[%@ %@] record: %d", [[self class] description], @"parser didEndLine", recordNumber);

    
    if (parser == self.remakesCSVParser)
    {
        if (self.templateIdMatched)
        {
            [self.remakes addObject:self.remake];
        }
    }
    else if (parser == self.segmentsCSVParser)
    {
        if (self.templateIdMatched)
        {
            [self.segments addObject:self.segment];
        }
    }
}

// This method is called when the parser finishes to parse the whole document
- (void)parserDidEndDocument:(CHCSVParser *)parser
{
    if (parser == self.remakesCSVParser)
    {
        self.template.remakes = [NSArray arrayWithArray:self.remakes];
    }
    else if (parser == self.segmentsCSVParser)
    {
        self.template.segments = [NSArray arrayWithArray:self.segments];
    }
    
}

- (void)parser:(CHCSVParser *)parser didFailWithError:(NSError *)error
{
    HMGLogError(@"Error prasing CSV file: %@", error.description);
}

@end
