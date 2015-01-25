#import "MCIntroCollectionViewLayout.h"

@implementation MCIntroCollectionViewLayout {
  NSUInteger _numberOfItems;
  CGFloat _margin;
  CGSize _finalSize;
}

- (void)prepareLayout {
  // Assuming we have only 1 section in the view.
  _numberOfItems = [self.collectionView.dataSource collectionView:self.collectionView
                                           numberOfItemsInSection:0];
  NSUInteger rowWidth = _numberOfElementsInEachRow *
      (_preferredElementSize.width + _spacing) - _spacing;
  _margin = _isFlexibleWidth ?
      _spacing : MAX((self.collectionView.bounds.size.width - rowWidth) / 2, _spacing);
  CGSize preferredSize = _preferredElementSize;
  CGFloat maximumWidth = (self.collectionView.bounds.size.width + _spacing -  2 * _margin) /
      _numberOfElementsInEachRow - _spacing;
  _finalSize = preferredSize;
  if (maximumWidth < preferredSize.width || _isFlexibleWidth) {
    CGFloat height = maximumWidth / preferredSize.width * preferredSize.height;
    _finalSize = CGSizeMake(maximumWidth, height);
  }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
  NSMutableArray *attributesArray = [NSMutableArray array];
  for (NSUInteger i = 0; i < _numberOfItems; i++) {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
    UICollectionViewLayoutAttributes *attributes =
        [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    NSUInteger rowIndex = i / _numberOfElementsInEachRow;
    NSUInteger colIndex = i % _numberOfElementsInEachRow;
    attributes.size = _finalSize;
    attributes.frame = CGRectMake((attributes.size.width +_spacing) * colIndex + _margin,
                                  (attributes.size.height + _spacing) * rowIndex,
                                  attributes.size.width,
                                  attributes.size.height);
    [attributesArray addObject:attributes];
  }
  return attributesArray;
}

- (CGSize)collectionViewContentSize {
  NSUInteger numberOfRows = _numberOfItems / _numberOfElementsInEachRow + 1;
  return CGSizeMake(self.collectionView.bounds.size.width,
                    (_finalSize.height +_spacing) * numberOfRows);
}

@end
