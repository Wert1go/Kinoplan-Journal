//
// Created by Виктор Шаманов on 2/17/14.
// Copyright (c) 2014 Applifto. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSManagedObjectContext;

@interface KPJCoreDataManager : NSObject

@property (strong, nonatomic, readonly) NSManagedObjectContext *context;

+ (instancetype)sharedManager;

@end