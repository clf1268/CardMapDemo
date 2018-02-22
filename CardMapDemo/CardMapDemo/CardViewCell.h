//
//  CardViewCell.h
//  OrderMapDemo
//
//  Created by clf on 2018/1/10.
//  Copyright © 2018年 clf. All rights reserved.
//

#import <UIKit/UIKit.h>
//定义订单卡片的几种状态
typedef enum _CardState{
    CardStateNormal,//正常状态
    CardStateEditing,//编辑状态
    CardStateTop,//置顶
    CardStateBottom//置底
} CardState;
@class CardView;
@protocol CardCellDelegate<NSObject>
@required
- (void)cardViewHorizontalScrollEnabled:(BOOL)enable;
- (void)cardViewDidMoved:(CGFloat)offset;
- (void)cardViewPanGensterRequiredCollectViewPanGesterFailed:(BOOL)failed;
- (BOOL)collectionViewPanGenstureEnabled;
- (void)cardViewCardStateWillChange:(CardState)cardState;
//- (void)cardViewShowRightCard:(BOOL)isRight;
@end


@interface CardViewCell : UICollectionViewCell

@property (nonatomic, weak) CardView<CardCellDelegate> * delegate;
- (void)resumeCardView;//恢复正常状态
- (void)minimizeCardView;//最小化
@end


