//
// Created by Виктор Шаманов on 2/17/14.
// Copyright (c) 2014 Applifto. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "KPJCoreDataManager.h"
#import "KPJJournal.h"

@interface KPJCoreDataManager()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@end

@implementation KPJCoreDataManager

- (void)initExampleObjects {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    if (![userDefaults boolForKey:@"openedBefore"]) {
        NSManagedObjectContext *managedObjectContext = self.context;

//        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Journal-iOS-recourse" ofType:@"bundle"];

//        NSBundle *bundle = [[NSBundle alloc] initWithPath:bundlePath];

        NSBundle *bundle = [NSBundle mainBundle];

        NSData *firstPDF = [NSData dataWithContentsOfURL:[bundle URLForResource:@"journal0" withExtension:@"pdf"]];

        KPJJournal *firstJournal = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([KPJJournal class])
                                                                 inManagedObjectContext:managedObjectContext];

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



        NSData *secondPDF = [NSData dataWithContentsOfURL:[bundle URLForResource:@"journal1" withExtension:@"pdf"]];

        KPJJournal *secondJournal = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([KPJJournal class])
                                                                  inManagedObjectContext:managedObjectContext];

        secondJournal.title = @"Second_journal";
        secondJournal.journalID = @2;
        secondJournal.sortID = @3;
        secondJournal.publicationDate = [NSDate date];

        NSString *secondJournalFilePath = [NSString stringWithFormat:@"%@/%@.pdf", documentPath, secondJournal.title];
        secondJournal.filePath = secondJournalFilePath;

        [[NSFileManager defaultManager] createFileAtPath:secondJournalFilePath
                                                contents:secondPDF
                                              attributes:nil];


        [managedObjectContext save:nil];

        [userDefaults setBool:YES forKey:@"openedBefore"];
        [userDefaults synchronize];

    }
}

+ (instancetype)sharedManager {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (!_managedObjectModel) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"KPJJournal" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

- (NSManagedObjectContext *)context {
    if (!_context) {
        NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
        if (coordinator != nil) {
            _context = [[NSManagedObjectContext alloc] init];
            _context.persistentStoreCoordinator = coordinator;
        }
    }
    return _context;
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