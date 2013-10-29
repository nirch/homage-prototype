//
//  HomageViewController.m
//  HomagePrototype
//
//  Created by Tomer Harry on 8/29/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGExploreTemplatesViewController.h"
#import "HMGTemplateDetailedViewController.h"
#import "HMGTemplateCVCell.h"
#import "HMGTemplateIterator.h"
#import "HMGTemplate.h"

@interface HMGExploreTemplatesViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak,nonatomic) IBOutlet UICollectionView *templateCView;
@property (strong,nonatomic) HMGTemplateIterator *templateIterator;
@property (nonatomic) NSInteger selectedTemplateIndex;

@end

@implementation HMGExploreTemplatesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.templateIterator = [[HMGTemplateIterator alloc] init];
    self.templatesArray = [self.templateIterator next];
}


/*- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}*/ //if not implemented, this value is set on default to 1

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [self.templatesArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.templateCView dequeueReusableCellWithReuseIdentifier:@"TemplateCell"
                                  forIndexPath:indexPath];
    HMGTemplate *template = self.templatesArray[indexPath.item];
    [self updateCell:cell withTemplate:template];
    return cell;
}

- (void)updateCell:(UICollectionViewCell *)cell withTemplate:(HMGTemplate *)template
{
    if ([cell isKindOfClass: [HMGTemplateCVCell class]]) {
        HMGTemplateCVCell *templateCell = (HMGTemplateCVCell *) cell;
        templateCell.templateName.text              = template.name;
        templateCell.templatePreviewImageView.image = template.thumbnail;
        templateCell.difficulty.text = template.levelDescription;
        //templateCell.uploaded                     = template.uploadDate;
        templateCell.numOfRemakes.text              = [NSString stringWithFormat:NSLocalizedString(@"NUM_OF_REMAKES", nil), [template.remakes count]];
        //cell.totalViews                           = template.totalViews;
    }
        
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedTemplateIndex = indexPath.item;
    UICollectionViewCell *cell = [self.templateCView cellForItemAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"showTemplate" sender:cell];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showTemplate"])
    {
        if ([segue.destinationViewController isKindOfClass:[HMGTemplateDetailedViewController class]] && [sender isKindOfClass:[HMGTemplateCVCell class]])
        {
            HMGTemplateDetailedViewController *destController = (HMGTemplateDetailedViewController *)segue.destinationViewController;
            HMGTemplate *templateToDisplay = self.templatesArray[self.selectedTemplateIndex];
            destController.templateToDisplay = templateToDisplay;
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
