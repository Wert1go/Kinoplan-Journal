//
//  KPStandViewController.m
//  Journal
//
//  Created by Виктор Шаманов on 2/11/14.
//  Copyright (c) 2014 Applifto. All rights reserved.
//

#import "KPStandViewController.h"

#import "KPStandViewCell.h"

#import "Journal.h"

@interface KPStandViewController ()

@property (strong, nonatomic) NSArray *journals;

@end

@implementation KPStandViewController

#pragma mark - View controller lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.journals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *const CellIdentifier = @"JournalCell";
    KPStandViewCell *cell = (KPStandViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                                         forIndexPath:indexPath];

    Journal *journal = self.journals[indexPath.row];

    return cell;
}

#pragma mark - Setters

- (void)setJournals:(NSArray *)journals {
    if (_journals != journals) {
        _journals = journals;
        [self.collectionView reloadData];
    }
}

@end
