//
// Created by Виктор Шаманов on 2/12/14.
// Copyright (c) 2014 Applifto. All rights reserved.
//

#import "UIImage+Caching.h"

static NSCache *_cache = nil;

@implementation UIImage (Caching)

+ (UIImage *)cachedImageNamed:(NSString *)name firstLoad:(UIImage *(^)())loadingBlock{
    if (!_cache) _cache = [[NSCache alloc] init];

    if (![_cache objectForKey:name]) {
        UIImage *image = loadingBlock ? loadingBlock() : nil;
        [_cache setObject:image forKey:name];
    }

    return [_cache objectForKey:name];
}

+ (void)emptyCache {
    [_cache removeAllObjects];
}

@end