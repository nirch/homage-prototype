//
//  TemplatesViewControllerTests.m
//  HomagePrototype
//
//  Created by Tomer Harry on 10/28/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "HMGExploreTemplatesViewController.h"

@interface TemplatesViewControllerTests : SenTestCase

@property (strong, nonatomic) UIStoryboard *storyboard;
@property (strong, nonatomic) HMGExploreTemplatesViewController *templatesViewController;

@end

@implementation TemplatesViewControllerTests

- (void)setUp
{
    [super setUp];
    
    self.storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    self.templatesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TemplatesViewController"];
    [self.templatesViewController performSelectorOnMainThread:@selector(view) withObject:nil waitUntilDone:YES];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testNumOfTemplates
{
    STAssertTrue(self.templatesViewController.templatesArray.count == 4, @"Expecting that num of templates to display will be 4, but it is %d", self.templatesViewController.templatesArray.count);
}

/*
 - (void)testExample
 {
 STAssertNotNil(self.storyboard, @"storyboard is nil!");
 STAssertNotNil(self.templatesViewController, @"templates view controller is nil!");
 
 NSArray *visibleCells = self.templatesViewController.templateCView.visibleCells;
 STAssertNotNil(visibleCells, @"visible Cells is nil!");
 
 NSArray *childViews = self.templatesViewController.view.subviews;
 NSLog(@"Num of child views: %d", childViews.count);
 for (UIView *childView in childViews) {
 if ([childView isKindOfClass:[UICollectionView class]])
 {
 UICollectionView *collectionView = (UICollectionView *)childView;
 
 NSLog(@"Number of sections: %d", collectionView.numberOfSections);
 
 NSLog(@"Number of items in the first section: %d", [collectionView numberOfItemsInSection:0]);
 
 UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
 STAssertNotNil(cell, @"Cell is nil!");
 
 STAssertTrue([cell isKindOfClass:[HMGTemplateCVCell class]], @"cell is not a HMGTemplateCell");
 HMGTemplateCVCell *templateCell = (HMGTemplateCVCell *)cell;
 STAssertTrue([templateCell.templateName.text isEqualToString:@"Wrong Meeting"], @"template name should be <Wrong Meeting> but it is <%@>", templateCell.templateName.text);
 
 NSLog(@"Number of visible cells: %d", collectionView.visibleCells.count);
 }
 }
 
 NSLog(@"Number of sections: %d", self.templatesViewController.templateCView.numberOfSections);
 
 NSLog(@"Number of items in the first section: %d", [self.templatesViewController.templateCView numberOfItemsInSection:0]);
 
 UICollectionViewCell *cell = [self.templatesViewController.templateCView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
 STAssertNotNil(cell, @"Cell is nil!");
 
 
 // Testing that the number of the visible cells is 3
 STAssertTrue(visibleCells.count == 3, @"number of visible cells should be 3 but it is: %d", visibleCells.count);
 
 //STFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
 }
 */

@end