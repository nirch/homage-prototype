//
//  TemplatesIteratorTests.m
//  HomagePrototype
//
//  Created by Tomer Harry on 9/2/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "TemplatesIteratorTests.h"
#import "TemplatesIterator.h"

@interface TemplatesIteratorTests()

@property (strong, nonatomic) TemplatesIterator *templatesIterator;

@end

#define MAX_NUM_OF_TEMPLATES_DEFAULT 3

@implementation TemplatesIteratorTests

- (void)setUp
{
    [super setUp];
    
    self.templatesIterator = [[TemplatesIterator alloc] init];
}

- (void)tearDown
{

    [super tearDown];
}

- (void)testInitialization
{
    // Testing that the object is initialized
    STAssertNotNil(self.templatesIterator, @"templatesIterator is nil");
}

- (void)testDefaultValues
{
    // Testing the default values of the object
    STAssertTrue(self.templatesIterator.maxNumOfTemplatesPerIteration == MAX_NUM_OF_TEMPLATES_DEFAULT, @"The max number of templates is %d whereas it is expected to be %d", self.templatesIterator.maxNumOfTemplatesPerIteration, MAX_NUM_OF_TEMPLATES_DEFAULT);
}


@end
