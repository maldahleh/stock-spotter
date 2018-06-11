//
//  StockCollectionDataSource.m
//  StockSpotter
//
//  Created by Mohammed Al-Dahleh on 2018-06-11.
//  Copyright © 2018 Mohammed Al-Dahleh. All rights reserved.
//

#import "StockCollectionDataSource.h"
#import "StockData.h"

@interface StockCollectionDataSource ()
@property (nonatomic, strong) NSMutableArray *stockData;
@end

@implementation StockCollectionDataSource

static NSString * const reuseIdentifier = @"StockCell";

- (void)updateData {
    self.stockData = [NSMutableArray array];
    [self refreshCells];
}

- (void)refreshCells {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"https://api.iextrading.com/1.0/stock/market/list/mostactive"];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
        NSArray *stockData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        for (NSDictionary *dict in stockData) {
            NSLog(@"HIT");
            StockData *dataObject = [StockData stockWithDictionary:dict];
            [self.stockData addObject:dataObject];
        }
    }];
    
    [task resume];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.stockData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    StockData *stockAtCell = [self.stockData objectAtIndex:indexPath.row];
    // TODO: Configure cell
    
    return cell;
}

@end
