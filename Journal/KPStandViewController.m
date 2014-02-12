//
//  KPStandViewController.m
//  Journal
//
//  Created by Виктор Шаманов on 2/11/14.
//  Copyright (c) 2014 Applifto. All rights reserved.
//

#import "KPStandViewController.h"

#import "KPStandViewCell.h"
#import "ReaderViewController.h"
#import "ReaderDocument.h"

#import "Journal.h"

#import "Journal+ImagePreview.h"

@interface KPStandViewController () <ReaderViewControllerDelegate>

@property (strong, nonatomic) NSArray *journals;

@end

@implementation KPStandViewController

#pragma mark - Private methods

- (void)updateJournals
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Journal"];
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

    self.collectionView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0);

    [self updateJournals];
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.journals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *const CellIdentifier = @"StandViewCell";
    KPStandViewCell *cell = (KPStandViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                                         forIndexPath:indexPath];

    Journal *journal = self.journals[indexPath.row];

    cell.imageView.image = journal.previewImage;
    
    return cell;
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Journal *journal = self.journals[indexPath.row];

    ReaderDocument *document = [ReaderDocument withDocumentFilePath:journal.filePath password:nil];

    ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
    readerViewController.delegate = self;

    [self presentViewController:readerViewController animated:YES completion:nil];

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
