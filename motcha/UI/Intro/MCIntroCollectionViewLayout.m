#import "MCIntroCollectionViewLayout.h"

@implementation MCIntroCollectionViewLayout {
  NSUInteger _numberOfItems;
  CGFloat _finalMargin;
  CGSize _finalSize;
}

- (void)prepareLayout {
  // Assuming we have only 1 section in the view.
  _numberOfItems = [self.collectionView.dataSource collectionView:self.collectionView
                                           numberOfItemsInSection:0];
  NSUInteger rowWidth = _numberOfElementsInEachRow *
      (_preferredElementSize.width + _spacing) - _spacing;
  _finalMargin = _isFlexibleWidth ?
      _margin : MAX((self.collectionView.bounds.size.width - rowWidth) / 2, _spacing);
  CGSize preferredSize = _preferredElementSize;
  CGFloat maximumWidth = (self.collectionView.bounds.size.width + _spacing -  2 * _finalMargin) /
      _numberOfElementsInEachRow - _spacing;
  _finalSize = preferredSize;
  if (maximumWidth < preferredSize.width || _isFlexibleWidth) {
    CGFloat height = maximumWidth / preferredSize.width * preferredSize.height;
    _finalSize = CGSizeMake(maximumWidth, height);
  }
  self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, _footerHeight, 0);
  self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
  NSMutableArray *attributesArray = [NSMutableArray array];
  
  // cell attributes
  for (NSUInteger i = 0; i < _numberOfItems; i++) {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
    UICollectionViewLayoutAttributes *attributes =
        [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    NSUInteger rowIndex = i / _numberOfElementsInEachRow;
    NSUInteger colIndex = i % _numberOfElementsInEachRow;
    attributes.size = _finalSize;
    attributes.frame = CGRectMake((attributes.size.width +_spacing) * colIndex + _finalMargin,
                                  (attributes.size.height + _spacing) * rowIndex +
                                      _spacing + _headerHeight,
                                  attributes.size.width,
                                  attributes.size.height);
    [attributesArray addObject:attributes];
  }
  
  // header attribute
  NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
  UICollectionViewLayoutAttributes *headerAttributes = [UICollectionViewLayoutAttributes
      layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                   withIndexPath:indexPath];
  headerAttributes.size = CGSizeMake(self.collectionView.bounds.size.width, _headerHeight);
  headerAttributes.frame = CGRectMake(0, 0,
                                      headerAttributes.size.width,
                                      headerAttributes.size.height);
  [attributesArray addObject:headerAttributes];
  
  // footer attribute
  UICollectionViewLayoutAttributes *footerAttributes = [UICollectionViewLayoutAttributes
      layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                   withIndexPath:indexPath];
  footerAttributes.size = CGSizeMake(self.collectionView.bounds.size.width, _footerHeight);
  footerAttributes.frame =
      CGRectMake(0,
                 self.collectionView.bounds.size.height -
                     _footerHeight + self.collectionView.contentOffset.y,
                 footerAttributes.size.width,
                 footerAttributes.size.height);
  footerAttributes.zIndex = CGFLOAT_MAX;
  [attributesArray addObject:footerAttributes];
  
  return attributesArray;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
  return YES;
}

- (CGSize)collectionViewContentSize {
  NSUInteger numberOfRows = _numberOfItems / _numberOfElementsInEachRow + 1;
  return CGSizeMake(self.collectionView.bounds.size.width,
                    (_finalSize.height +_spacing) * numberOfRows + _headerHeight);
}

@end
