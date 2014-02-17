//
//  Journal+ImagePreview.h
//  Journal
//
//  Created by Виктор Шаманов on 2/12/14.
//  Copyright (c) 2014 Applifto. All rights reserved.
//

#import "KPJJournal.h"

@interface KPJJournal (ImagePreview)

- (UIImage *)previewImage;

- (UIImage *)previewImageWithSize:(CGSize)imageSize;

@end
