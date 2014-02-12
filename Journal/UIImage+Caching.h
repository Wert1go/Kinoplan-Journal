//
// Created by Виктор Шаманов on 2/12/14.
// Copyright (c) 2014 Applifto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (Caching)

+ (UIImage *)cachedImageNamed:(NSString *)name firstLoad:(UIImage *(^)())loadingBlock;
+ (void)emptyCache;

@end