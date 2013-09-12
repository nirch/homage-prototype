//
//  TemplateCVCell.h
//  HomagePrototype
//
//  Created by Yoav Caspin on 9/4/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMGTemplate.h"

@interface TemplateCVCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel     *templateName;
@property (weak, nonatomic) IBOutlet UIImageView *templatePreviewImageView;
@property (weak, nonatomic) IBOutlet UILabel     *lastUpdated;
@property (weak, nonatomic) IBOutlet UILabel     *numOfRemakes;
@property (weak, nonatomic) IBOutlet UILabel     *totalViews;
@property (strong,nonatomic) HMGTemplate         *templateObj;

@end
