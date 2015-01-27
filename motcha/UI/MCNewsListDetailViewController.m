#import "MCNewsListDetailViewController.h"

static CGFloat newsImageViewHeightRatio     = 0.5f;
static CGFloat scrollViewContentInsetRatio  = 1.0f/7.0f;

@interface MCNewsListDetailViewController ()<UIScrollViewDelegate>
@end

@implementation MCNewsListDetailViewController {
  UIImageView   *_imageView;
  UIScrollView  *_scrollView;
  UIView        *_contentView;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  self.title = @"I am news detail";
}

- (void)loadView {
  [super loadView];
  
  CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
  CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
  self.automaticallyAdjustsScrollViewInsets = NO;
  
  // Add image view
  _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                0,
                screenWidth,
                screenHeight*newsImageViewHeightRatio)];
  [_imageView setBackgroundColor:[UIColor yellowColor]];
  [self.view addSubview:_imageView];
  
  // Add content view to scroll view
  _contentView = [[UIView alloc] initWithFrame:_scrollView.bounds];
  [_contentView setBackgroundColor:[UIColor blueColor]];
  
  // Add scroll view
  _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
  _scrollView.delegate = self;
  
  // Calculate and adjust content view size
  CGRect contentRect = CGRectZero;
  for (UIView *view in _contentView.subviews) {
    contentRect = CGRectUnion(contentRect, view.frame);
  }
  CGRect contentViewFrame = _contentView.frame;
  _contentView.frame = CGRectMake(contentViewFrame.origin.x,
                                  contentViewFrame.origin.y,
                                  contentRect.size.width,
                                  contentRect.size.height);
  _scrollView.contentSize = contentRect.size;
  
  [self.view addSubview:_scrollView];
  
  // Set content top inset
  _scrollView.contentInset = UIEdgeInsetsMake(screenHeight *
                                              scrollViewContentInsetRatio, 0, 0, 0);
  
  // Scroll to top
  [_scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
  
  [_scrollView addSubview:_contentView];
  
  // TODO: add title, time, source, dash and author views
}

@end

