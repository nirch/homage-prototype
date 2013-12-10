//
//  TemplatesIteratorTests.m
//  HomagePrototype
//
//  Created by Tomer Harry on 9/2/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "TemplatesIteratorTests.h"
#import "HMGTemplateIterator.h"

@interface TemplatesIteratorTests()

@property (strong, nonatomic) HMGTemplateIterator *templateIterator;

@end

@implementation TemplatesIteratorTests

- (void)setUp
{
    [super setUp];
    
    self.templateIterator = [[HMGTemplateIterator alloc] init];
}

- (void)tearDown
{

    [super tearDown];
}

- (void)testDefaultInitialization
{
    // Testing that the object is initialized
    STAssertNotNil(self.templateIterator, @"templatesIterator is nil");
    
    // Testing the default values of the object
    STAssertTrue(self.templateIterator.numOfTemplatesPerIteration == DEFUALT_TEMPLATES_PER_ITERATION, @"The number of templates per iteration is %d whereas it is expected to be %d", self.templateIterator.numOfTemplatesPerIteration, DEFUALT_TEMPLATES_PER_ITERATION);

}

- (void)testCustomInitialization
{
    NSInteger customNumOfTemplatesPerIteration = 1;
    self.templateIterator = [[HMGTemplateIterator alloc] initWithCustom:customNumOfTemplatesPerIteration];
    
    // Testing that the object is initialized
    STAssertNotNil(self.templateIterator, @"templatesIterator is nil");

    // Testing the value of the numOfTemplates property
    STAssertTrue(self.templateIterator.numOfTemplatesPerIteration == customNumOfTemplatesPerIteration, @"The number of templates per iteration is %d whereas it is expected to be %d", self.templateIterator.numOfTemplatesPerIteration, customNumOfTemplatesPerIteration);
}

- (void)testZeroNumOfTemplatesSetter
{
    // When setting the numOfTemplatesPerIteration with a 0 value, an exception should be thorwn
    STAssertThrows(self.templateIterator.numOfTemplatesPerIteration = 0, @"An exception should be thrown when setting the numOfTemplatesPerIteration with a zero value");
}

-(void)testNegativeNumOfTemplatesSetter
{
    // When setting the numOfTemplatesPerIteration with a negative value, an exception should be thorwn
    STAssertThrows(self.templateIterator.numOfTemplatesPerIteration = -3, @"An exception should be thrown when setting the numOfTemplatesPerIteration with a negative value");
}

-(void)testDefaultNext
{
    NSArray *templates;
    
    
//    while ((templates = self.templateIterator.next))
//    {
//
//    }
    
    templates = self.templateIterator.next;
    STAssertTrue([templates count] == DEFUALT_TEMPLATES_PER_ITERATION, @"next should return %d templates, whereas it returned %d templates", DEFUALT_TEMPLATES_PER_ITERATION, templates.count);
}

-(void)testCustomNext
{
    NSArray *templates;
    self.templateIterator.numOfTemplatesPerIteration = 1;
    
    templates = self.templateIterator.next;
    STAssertTrue([templates count] == 1, @"next should return %d templates, whereas it returned %d templates", 1, templates.count);
    
    templates = self.templateIterator.next;
    STAssertTrue([templates count] == 1, @"next should return %d templates, whereas it returned %d templates", 1, templates.count);

    templates = self.templateIterator.next;
    STAssertTrue([templates count] == 1, @"next should return %d templates, whereas it returned %d templates", 1, templates.count);

    templates = self.templateIterator.next;
    STAssertTrue([templates count] == 1, @"next should return %d templates, whereas it returned %d templates", 1, templates.count);
    
    templates = self.templateIterator.next;
    STAssertTrue([templates count] == 1, @"next should return %d templates, whereas it returned %d templates", 1, templates.count);
    
    templates = self.templateIterator.next;
    STAssertNil(templates, @"templates was supposed to be nil but it is not");

}




@end
