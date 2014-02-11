//
//  Journal.h
//  Journal
//
//  Created by Виктор Шаманов on 2/11/14.
//  Copyright (c) 2014 Applifto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Journal : NSManagedObject

@property (nonatomic, retain) NSString  *filePath;
@property (nonatomic, retain) NSString  *title;
@property (nonatomic, retain) NSNumber  *journalID;
@property (nonatomic, retain) NSNumber  *sortID;
@property (nonatomic, retain) NSDate    *publicationDate;

@end
