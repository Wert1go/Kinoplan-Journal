//
// Created by Виктор Шаманов on 2/20/14.
// Copyright (c) 2014 Applifto. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KPJPreviewLoader : NSObject

+ (void)generatePreviewForDocumentAtPath:(NSString *)path;
+ (void)generatePreviewForDocumentAtPath:(NSString *)path withSize:(CGSize)imageSize;
+ (NSString *)previewPathForDocumentAtPath:(NSString *)path;

@end