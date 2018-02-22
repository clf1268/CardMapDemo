//
//  CardView.m
//  OrderMapDemo
//
//  Created by clf on 2018/1/10.
//  Copyright © 2018年 clf. All rights reserved.
//

#import "CardView.h"

@interface CardView()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CardCellDelegate>

@property (nonatomic, strong) UICollectionView * collectView;
@property (nonatomic, assign) CGRect oldFrame;
@property (nonatomic, weak) CardViewCell * currentCell;

//@property (nonatomic, strong) NSMutableArray * dataArr;
@end
@implementation CardView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configUI];
        self.oldFrame = frame;
        //        self.dataArr = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self configUI];
        //        self.dataArr = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)configUI {
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) collectionViewLayout:layout];
    self.collectView.delegate = self;
    self.collectView.dataSource = self;
    self.collectView.pagingEnabled = YES;
    
    self.collectView.directionalLockEnabled = YES;
    
    //    self.collectView.alwaysBounceHorizontal
    //    self.collectView.showsVerticalScrollIndicator = NO;
    //    self.collectView.showsHorizontalScrollIndicator = NO;
    self.collectView.backgroundColor = [UIColor clearColor];
    [self.collectView registerClass:[CardViewCell class] forCellWithReuseIdentifier:@"CardViewCell"];
    [self addSubview:self.collectView];
    
}



- (void)layoutSubviews {
    self.collectView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [self.collectView reloadData];
}


#pragma mark - collectionViewDelagate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
    //    return self.dataArr.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CardViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CardViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    self.currentCell = cell;
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.bounds.size;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark CardViewCellDelegate
- (void)cardViewDidMoved:(CGFloat)offset {
    CGRect frame = self.oldFrame;
    frame.origin.y += offset;
    self.frame = frame;
    [self.delegate cardListDidMoved:offset];
}

- (void)cardViewHorizontalScrollEnabled:(BOOL)enable {
    self.collectView.scrollEnabled = enable;
}

- (void)cardViewPanGensterRequiredCollectViewPanGesterFailed:(BOOL)failed {
    self.collectView.panGestureRecognizer.enabled = failed;
    self.collectView.panGestureRecognizer.enabled = !failed;
}

- (BOOL)collectionViewPanGenstureEnabled {
    return self.collectView.panGestureRecognizer.enabled;
}

- (void)cardViewCardStateWillChange:(CardState)cardState {
    [self.delegate cardListCardStateWillChange:cardState];
}

//- (void)cardViewShowRightCard:(BOOL)isRight {
//    if ([self.delegate respondsToSelector:@selector(cardListLoadNextData:)]) {
//        NSInteger nextIndex = isRight?self.curIndex+1:self.curIndex-1;
//        if (nextIndex < 0 || nextIndex >= self.totalCount) {
//            return ;
//        }
//
//        [self.delegate cardListLoadNextData:nextIndex];
//
//    }
//}

#pragma mark - publicMethod
- (void)resumeCardList {
    [self.currentCell resumeCardView];
}

- (void)minimizeCardList {
    [self.currentCell minimizeCardView];
}



@end

