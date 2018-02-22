//
//  CardView.h
//  OrderMapDemo
//
//  Created by clf on 2018/1/10.
//  Copyright © 2018年 clf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardViewCell.h"
@protocol CardViewDelegate<NSObject>
- (void)cardListCardStateWillChange:(CardState)cardState;
- (void)cardListDidMoved:(CGFloat)offset;
- (void)cardListLoadNextData:(NSInteger)index;
@end
@interface CardView : UIView
//@property (nonatomic, assign) NSInteger totalCount;
//@property (nonatomic, assign) NSInteger curIndex;
@property (nonatomic, assign, readonly) CGRect oldFrame;
@property (nonatomic, weak) id<CardViewDelegate> delegate;
- (void)resumeCardList;//恢复正常状态
- (void)minimizeCardList;//最小化
@end

