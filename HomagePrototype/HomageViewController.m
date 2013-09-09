//
//  HomageViewController.m
//  HomagePrototype
//
//  Created by Tomer Harry on 8/29/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HomageViewController.h"
#import "TemplateCVCell.h"
#import "HMGTemplateIterator.h"
#import "HMGTemplate.h"

@interface HomageViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak,nonatomic) IBOutlet UICollectionView *templateCView;
@property (strong,nonatomic) NSArray *templatesArray;
@property (strong,nonatomic) HMGTemplateIterator *templateIterator;

@end

@implementation HomageViewController


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
    if ([cell isKindOfClass: [TemplateCVCell class]]) {
        TemplateCVCell *templateCell = (TemplateCVCell *) cell;
        
        templateCell.templateName.text        = template.name;
        templateCell.templatePreviewImageView.image = template.thumbnail;
        //templateCell.uploaded             = template.uploadDate;
        templateCell.numOfRemakes.text      = [NSString stringWithFormat:@"#remakes: %d" , [template.remakes count]];
        //cell.totalViews           = template.totalViews;
    }
        
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.templateIterator = [[HMGTemplateIterator alloc] init];
    self.templatesArray = [self.templateIterator next];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
