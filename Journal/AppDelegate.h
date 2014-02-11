//
//  AppDelegate.h
//  Journal
//
//  Created by Виктор Шаманов on 2/11/14.
//  Copyright (c) 2014 Applifto. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NSManagedObjectModel;
@class NSPersistentStoreCoordinator;
@class NSManagedObjectContext;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSManagedObjectModel          *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator  *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectContext        *managedObjectContext;

@end
