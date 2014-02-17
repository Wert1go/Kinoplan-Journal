//
//  KPStandViewController.m
//  Journal
//
//  Created by Виктор Шаманов on 2/11/14.
//  Copyright (c) 2014 Applifto. All rights reserved.
//

#import "KPJStandViewController.h"

#import "KPJStandViewCell.h"
#import "ReaderViewController.h"

#import "KPJJournal.h"

#import "KPJJournal+ImagePreview.h"

@interface KPJStandViewController () <ReaderViewControllerDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSArray *journals;

@end

@implementation KPJStandViewController

#pragma mark - Private methods

- (void)updateJournals
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"KPJJournal"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"journalID" ascending:YES]];

    NSFetchedResultsController *resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                        managedObjectContext:self.managedObjectContext
                                                                                          sectionNameKeyPath:nil
                                                                                                   cacheName:@"Stand"];
    [resultsController performFetch:nil];

    self.journals = resultsController.fetchedObjects;
}

#pragma mark - View controller lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor grayColor];

    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    
    
    //for iOS 6 and lower, set solid background color of UINavigationBar
    if ([[UIDevice currentDevice] systemVersion].floatValue < 7.0) {

        UIColor *color = [UIColor lightGrayColor];

        CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();

        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, rect);

        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        [navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        navigationBar.shadowImage = [[UIImage alloc] init];
    } else {
        navigationBar.barTintColor = [UIColor lightGrayColor];
    }


    [self updateJournals];
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.journals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *const CellIdentifier = @"StandViewCell";
    KPJStandViewCell *cell = (KPJStandViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                                           forIndexPath:indexPath];

    KPJJournal *journal = self.journals[indexPath.row];

    cell.imageView.image = journal.previewImage;

    return cell;
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    KPJJournal *journal = self.journals[indexPath.row];

    ReaderDocument *document = [ReaderDocument withDocumentFilePath:journal.filePath password:nil];

    ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
    readerViewController.delegate = self;

    [self presentViewController:readerViewController animated:YES completion:nil];

}

#pragma mark - Collection view flow layout delegate

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
}

#pragma mark - ReaderViewControllerDelegate

- (void)dismissReaderViewController:(ReaderViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Setters

- (void)setJournals:(NSArray *)journals {
    if (_journals != journals) {
        _journals = journals;
        [self.collectionView reloadData];
    }
}

@end