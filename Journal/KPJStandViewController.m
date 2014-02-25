
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

#import "KPJPreviewLoader.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+DarkReader.h"

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

    UINavigationBar *navigationBar = self.navigationController.navigationBar;

    self.title = NSLocalizedString(@"JOURNAL_TITLE", nil);
    

    UIImage *backgroundImage;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        backgroundImage = [UIImage imageNamed:@"Journal-iOS-resources.bundle/shelf_backgroud_ipad"];
    } else {
        backgroundImage = [UIImage imageNamed:@"Journal-iOS-resources.bundle/shelf_backgroud_iphone"];
    }

    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];

    //for iOS 6 and lower, set solid background color of UINavigationBar
    UIColor *navBarColor = [UIColor readerDarkGrayColor];

    if ([[UIDevice currentDevice] systemVersion].floatValue < 7.0) {

        UIColor *color = navBarColor;

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
        navigationBar.barTintColor = navBarColor;
        self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor:[UIColor whiteColor]};
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

    NSString *previewPath = [KPJPreviewLoader previewPathForDocumentAtPath:journal.filePath];

    UIImage *placeholderImage = [UIImage imageNamed:@"Journal-iOS-resources.bundle/journal_placeholder"];

    [cell.imageView setImageWithURL:[NSURL fileURLWithPath:previewPath]
                   placeholderImage:placeholderImage
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                              [cell layoutSubviews];
                          }];

    return cell;
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    KPJJournal *journal = self.journals[indexPath.row];

    ReaderDocument *document = [ReaderDocument withDocumentFilePath:journal.filePath password:nil];

    ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document title:journal.title];
    readerViewController.delegate = self;

    [self presentViewController:readerViewController animated:YES completion:nil];

}

#pragma mark - Collection view flow layout delegate

- (CGSize)collectionView:(UICollectionView *)collectionView
                         layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(0.0, 26.0);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView
                             layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 27.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return CGSizeMake(130.0, 170.0);
    } else {
        return CGSizeMake(130.0, 170.0);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return UIEdgeInsetsMake(0.0, 40.0, 0.0, 40.0);
    } else {
        return UIEdgeInsetsMake(0.0, 20.0, 0.0, 20.0);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                                  layout:(UICollectionViewLayout*)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 50.0;
    } else {
        return 10.0;
    }
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
