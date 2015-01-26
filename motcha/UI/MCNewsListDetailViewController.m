//
//  MCNewsListDetail.m
//  motcha
//
//  Created by HuaqingLi on 2015-01-26.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

#import "MCNewsListDetailViewController.h"

@interface MCNewsListDetailViewController ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation MCNewsListDetailViewController
- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  [self setTitle:@"I am news detail"];
  [self initView];
}


- (void)initView {
  CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
  CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
  self.automaticallyAdjustsScrollViewInsets = NO;
  
  //add image view
  _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                             0,
                                                             screenWidth,
                                                             screenHeight*NEWS_IAMGE_VIEW_HEIGHT_RATIO)];
  [_imageView setBackgroundColor:[UIColor yellowColor]];
  [self.view addSubview:_imageView];
  
  //add scroll view
  _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
  _scrollView.delegate = self;
  _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width, 1000);
  [self.view addSubview:_scrollView];
  
  //add content view to scroll view
  UIView *contentView = [[UIView alloc] initWithFrame:_scrollView.bounds];
  [contentView setBackgroundColor:[UIColor blueColor]];
  
  [_scrollView setContentInset:UIEdgeInsetsMake(screenHeight*SCROLL_VIEW_CONTENT_INSET_RATIO, 0, 0, 0)];
  [_scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
  [_scrollView addSubview:contentView];
  
#warning add more details in the future!
  //TODO: add title, time, source, dash and author views
  
}

@end
