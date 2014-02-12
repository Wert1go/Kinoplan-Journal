//
//  Journal+ImagePreview.h
//  Journal
//
//  Created by Виктор Шаманов on 2/12/14.
//  Copyright (c) 2014 Applifto. All rights reserved.
//

#import "Journal.h"

@interface Journal (ImagePreview)

- (UIImage *)previewImage;

- (UIImage *)previewImagewithSize:(CGSize)imageSize;

- (UIImage *)previewImagewithSize:(CGSize)imageSize scale:(CGFloat)scale;

@end
