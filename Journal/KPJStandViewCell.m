//
//  KPStandViewCell.m
//  Journal
//
//  Created by Виктор Шаманов on 2/11/14.
//  Copyright (c) 2014 Applifto. All rights reserved.
//

#import "KPJStandViewCell.h"

@implementation KPJStandViewCell

#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {

    }
    return self;
}

#pragma mark - UIView methods

//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//    if (self.imageView.image) {
//        CGSize imageSize = self.imageView.image.size;
//
//        CGFloat hFactor = imageSize.width / self.imageView.frame.size.width;
//        CGFloat vFactor = imageSize.height / self.imageView.frame.size.height;
//
//        CGFloat factor = (CGFloat)fmax(hFactor, vFactor);
//
//        CGFloat newWidth = imageSize.width / factor;
//        CGFloat newHeight = imageSize.height / factor;
//
//        CGFloat newX = (self.frame.size.width - newWidth) / 2.0;
//        CGFloat newY = self.frame.size.height - newHeight;
//
//        self.imageView.frame = CGRectMake(newX, newY, newWidth, newHeight);
//    }
//
//}

@end
