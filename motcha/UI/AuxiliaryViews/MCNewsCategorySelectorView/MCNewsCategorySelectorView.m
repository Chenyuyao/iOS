#import "MCNewsCategorySelectorView.h"

#import "MCNewsCategoryAddView.h"

@interface MCNewsCategorySelectorView()
@end

@implementation MCNewsCategorySelectorView {
  MCNewsCategoryAddView *_addView;
}

- (instancetype)init {
  if (self = [super initWithFrame:CGRectMake(0, 0, 0, kCategorySelectorViewHeight)]) {
    [self initCategoryScrollView];
    [self initAddButtonView];
    NSDictionary *views = NSDictionaryOfVariableBindings(_addView, _categoryScrollView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_categoryScrollView][_addView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
  }
  return self;
}

- (void)initCategoryScrollView {
  _categoryScrollView = [[MCNewsCategorySelectorScrollView alloc] init];
  _categoryScrollView.translatesAutoresizingMaskIntoConstraints = NO;
  [self addSubview:_categoryScrollView];
  NSDictionary *views = NSDictionaryOfVariableBindings(_categoryScrollView);
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_categoryScrollView]|"
                                                               options:0
                                                               metrics:nil
                                                                 views:views]];
}

- (void)initAddButtonView {
  _addView = [[NSBundle mainBundle] loadNibNamed:@"MCNewsCategoryAddView" owner:self options:nil][0];
  _addView.translatesAutoresizingMaskIntoConstraints = NO;
  [self addSubview:_addView];
  NSDictionary *views = NSDictionaryOfVariableBindings(_addView);
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_addView]|"
                                                               options:0
                                                               metrics:nil
                                                                 views:views]];
}

- (IBAction)addCategoryButtonPressed:(UIButton *)sender {
  if ([_mcDelegate conformsToProtocol:@protocol(MCNewsCategorySelectorViewDelegate)] &&
      [_mcDelegate respondsToSelector:@selector(addCategoriesButtonPressed)]) {
    [_mcDelegate addCategoriesButtonPressed];
  }
}

@end
