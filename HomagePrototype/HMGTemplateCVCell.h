//
//  TemplateCVCell.h
//  HomagePrototype
//
//  Created by Yoav Caspin on 9/4/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMGTemplate.h"

@interface HMGTemplateCVCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel     *templateName;
@property (weak, nonatomic) IBOutlet UIImageView *templatePreviewImageView;
@property (weak, nonatomic) IBOutlet UILabel     *difficulty;
@property (weak, nonatomic) IBOutlet UILabel     *numOfRemakes;
//@property (weak, nonatomic) IBOutlet UILabel     *totalViews;

@end
