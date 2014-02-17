//
//  Journal.h
//  Journal
//
//  Created by Виктор Шаманов on 2/17/14.
//  Copyright (c) 2014 Applifto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface KPJJournal : NSManagedObject

@property (nonatomic, retain) NSString * filePath;
@property (nonatomic, retain) NSNumber * journalID;
@property (nonatomic, retain) NSDate * publicationDate;
@property (nonatomic, retain) NSNumber * sortID;
@property (nonatomic, retain) NSString * title;

@end
