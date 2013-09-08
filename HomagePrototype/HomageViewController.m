//
//  HomageViewController.m
//  HomagePrototype
//
//  Created by Tomer Harry on 8/29/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HomageViewController.h"
//#import "Template.h"
#import "TemplateCVCell.h"
//#import "TemplatesIteration.h"

@interface HomageViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak,nonatomic) IBOutlet UICollectionView *templateCView;


@end

@implementation HomageViewController


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return 20;
    //return self.numberOfTemplates;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*UICollectionViewCell *cell = [templateCView dequeueReusableCellWithReuseIdentifier:@"TemplateCell"
                                                                          forIndexPath:indexPath];
    Template *template = [self.templateModel templateAtIndex:indexPath.item];
    [self updateCell:cell withTemplate:template];
    return cell;*/
    return nil;
}

/*- (void)updateCell:(UICollectionViewCell *)cell withTemplate:(Template *)template
{
    if ([cell isKindOfClass: [TemplateCVCell class]]) {
        cell.templateName.text    = template.name; /// need to see how to assign each field correctly
        cell.templatePreviewImage = template.previewImage;
        cell.lastUpdated          = template.uploadDate;
        cell.numOfRemakes         = [template.remakes count];
        cell.totalViews           = template.totalViews;
    }
        
}*/

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
