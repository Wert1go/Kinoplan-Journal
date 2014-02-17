//
//  AppDelegate.m
//  Journal
//
//  Created by Виктор Шаманов on 2/11/14.
//  Copyright (c) 2014 Applifto. All rights reserved.
//

@import CoreData;
#import "AppDelegate.h"

#import "KPJStandViewController.h"

#define PRESENTATION_MODE TRUE

#if PRESENTATION_MODE

#import "KPJJournal.h"

#endif

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;

    KPJStandViewController *standViewController = (KPJStandViewController *)navigationController.topViewController;

    standViewController.managedObjectContext = self.managedObjectContext;

#if PRESENTATION_MODE

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    if (![userDefaults boolForKey:@"openedBefore"]) {

        NSData *firstPDF = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"journal0" withExtension:@"pdf"]];

        KPJJournal *firstJournal = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([KPJJournal class])
                                                                 inManagedObjectContext:self.managedObjectContext];

        firstJournal.title = @"First_journal";
        firstJournal.journalID = @1;
        firstJournal.sortID = @1;
        firstJournal.publicationDate = [NSDate date];

        NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [searchPaths objectAtIndex:0];

        NSString *firstJournalFilePath = [NSString stringWithFormat:@"%@/%@.pdf", documentPath, firstJournal.title];
        firstJournal.filePath = firstJournalFilePath;

        [[NSFileManager defaultManager] createFileAtPath:firstJournalFilePath
                                                contents:firstPDF
                                              attributes:nil];



        NSData *secondPDF = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"journal1" withExtension:@"pdf"]];

        KPJJournal *secondJournal = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([KPJJournal class])
                                                                  inManagedObjectContext:self.managedObjectContext];

        secondJournal.title = @"Second_journal";
        secondJournal.journalID = @2;
        secondJournal.sortID = @3;
        secondJournal.publicationDate = [NSDate date];

        NSString *secondJournalFilePath = [NSString stringWithFormat:@"%@/%@.pdf", documentPath, secondJournal.title];
        secondJournal.filePath = secondJournalFilePath;

        [[NSFileManager defaultManager] createFileAtPath:secondJournalFilePath
                                                contents:secondPDF
                                              attributes:nil];


        [self.managedObjectContext save:nil];

        [userDefaults setBool:YES forKey:@"openedBefore"];
        [userDefaults synchronize];

    }

#endif

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Core Data

#pragma mark - Getters

- (NSManagedObjectModel *)managedObjectModel {
    if (!_managedObjectModel) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"KPJJournal" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (!_managedObjectContext) {
        NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
        if (coordinator != nil) {
            _managedObjectContext = [[NSManagedObjectContext alloc] init];
            _managedObjectContext.persistentStoreCoordinator = coordinator;
        }
    }
    return _managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (!_persistentStoreCoordinator) {
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"KPJJournal.sqlite"];

        NSError *error = nil;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.

             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

             Typical reasons for an error here include:
             * The persistent store is not accessible;
             * The schema for the persistent store is incompatible with current managed object model.
             Check the error message to determine what the actual problem was.


             If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.

             If you encounter schema incompatibility errors during development, you can reduce their frequency by:
             * Simply deleting the existing store:
             [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]

             * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
             @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}

             Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.

             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    return _persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
