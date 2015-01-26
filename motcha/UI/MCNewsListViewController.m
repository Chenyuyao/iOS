//
//  MCNewsListViewController.m
//  motcha
//
//  Created by HuaqingLi on 2015-01-26.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

#import "MCNewsListViewController.h"
#import "MCNewsListDetailViewController.h"
#import "MCNewsListCollectionViewCell.h"

@interface MCNewsListViewController ()

@end

@implementation MCNewsListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setTitle:@"I am news list"];
  // Register cell classes
  [self.collectionView registerNib:[UINib nibWithNibName:@"MCNewsListCollectionViewCell" bundle:nil]
        forCellWithReuseIdentifier:MC_NEWS_LIST_CELL];
  
  // Do any additional setup after loading the view.
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete method implementation -- Return the number of sections
  return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete method implementation -- Return the number of items in the section
  return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MC_NEWS_LIST_CELL forIndexPath:indexPath];
  // Configure the cell
  return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  MCNewsListDetailViewController *detailView = [[MCNewsListDetailViewController alloc] initWithNibName:@"MCNewsListDetailViewController" bundle:nil];
  [self.navigationController pushViewController:detailView animated:YES];
  NSLog(@"Select cell at index %ld", (long)indexPath.row);
}


@end
