//
//  CardViewCell.m
//  OrderMapDemo
//
//  Created by clf on 2018/1/10.
//  Copyright © 2018年 clf. All rights reserved.
//

#import "CardViewCell.h"
#import "CardView.h"

#define kTopOffsetY -self.delegate.oldFrame.origin.y+64
#define kBottomOffetY SCREEN_HEIGHT-self.delegate.oldFrame.origin.y-60
#define kNormalOffsetY 0
#define kStretchH 100//弹性范围
#define kHeaderViewH 60.f
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//#define kScaleW


typedef enum _CardDirection{
    CardDirectionUp,
    CardDirectionDown,
    CardDirectionLeft,
    CardDirectionRight
}CardDirection;




@interface CardViewCell()<UIGestureRecognizerDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,CardCellDelegate>
@property(nonatomic, strong) UIView * headerView;
@property(nonatomic, strong) UITableView * tableView;
@property(nonatomic, strong) UIPanGestureRecognizer * pan;
@property(nonatomic, assign) CardState cardState;
@property(nonatomic, assign) CardDirection direction;
@property(nonatomic, assign) BOOL isFirstChanged;
@property(nonatomic, assign) CGFloat oldOffset;
@property(nonatomic, assign) BOOL isCardSelected;

@end
@implementation CardViewCell



- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.tableView  = [[UITableView alloc] initWithFrame:CGRectMake(10, kHeaderViewH, self.bounds.size.width-20, self.bounds.size.height-kHeaderViewH)];
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.clipsToBounds = YES;
        self.tableView.scrollEnabled = NO;
        self.tableView.directionalLockEnabled = YES;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.f green:arc4random()%255/255.f blue:arc4random()%255/255.f alpha:1.0];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
        
        self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        self.pan.maximumNumberOfTouches = 1;
        self.pan.delegate = self;
        self.cardState = CardStateNormal;
        [self.tableView addGestureRecognizer:self.pan];
        [self.tableView.panGestureRecognizer requireGestureRecognizerToFail:self.pan];
        [self addSubview:self.tableView];
        [self initHeaderView];
        
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        pan.maximumNumberOfTouches = 1;
        pan.delegate = self;
        [self.headerView addGestureRecognizer:pan];
    }
    return self;
}

- (void)initHeaderView{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.bounds.size.width-20,kHeaderViewH)];
    headerView.backgroundColor = [UIColor redColor];
    headerView.layer.shadowOffset = CGSizeMake(0, 2);
    headerView.layer.shadowColor = [UIColor whiteColor].CGColor;
    headerView.layer.shadowOpacity = 0.1;
    headerView.layer.shadowRadius = 2.0;
    self.headerView = headerView;
    [self addSubview:headerView];
    
}
- (void)headerShadowHidden:(BOOL)hidden{
    if (!hidden) {
        self.headerView.layer.shadowColor = [UIColor blackColor].CGColor;
    }else{
        self.headerView.layer.shadowColor = [UIColor whiteColor].CGColor;
    }
}


- (void)setCardState:(CardState)cardState {
    if (_cardState != cardState) {
        _cardState = cardState;
        switch (cardState) {
            case CardStateNormal:
                self.tableView.scrollEnabled = NO;
                [self.delegate cardViewHorizontalScrollEnabled:YES];
                break;
            case CardStateEditing:
                self.tableView.scrollEnabled = NO;
                [self.delegate cardViewHorizontalScrollEnabled:NO];
                
                break;
            case CardStateTop:
                self.tableView.scrollEnabled = YES;
                [self.delegate cardViewHorizontalScrollEnabled:NO];
                
                break;
            case CardDirectionRight:
                self.tableView.scrollEnabled = NO;
                [self.delegate cardViewHorizontalScrollEnabled:NO];
                
                break;
                
            default:
                break;
        }
        
    }
}

- (void)pan:(UIPanGestureRecognizer * )recognize {
    switch (recognize.state) {
        case UIGestureRecognizerStateBegan:
            self.isFirstChanged = YES;
            //获得上次偏移量
            self.oldOffset = self.delegate.frame.origin.y - self.delegate.oldFrame.origin.y;
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            UIPanGestureRecognizer * pan = recognize;
            //距离落置点的偏移量，y<0向上 x<0向右
            CGPoint offset = [pan translationInView:pan.view];
            //            NSLog(@"%@", NSStringFromCGPoint(offset));
            CGFloat xOffset = fabs(offset.x);
            CGFloat yOffset = fabs(offset.y);
            CGFloat maxOffsetH = -self.delegate.oldFrame.origin.y+64;
            if (self.isFirstChanged) {
                
                if (yOffset < xOffset) {
                    if (offset.x < 0) {
                        self.direction = CardDirectionRight;
                        //                        if (self.cardState == CardStateNormal) {
                        //                            [self.delegate cardViewShowRightCard:YES];
                        //                        }
                        NSLog(@"right");
                        
                    }else{
                        self.direction = CardDirectionLeft;
                        //                        if (self.cardState == CardStateNormal) {
                        //                            [self.delegate cardViewShowRightCard:NO];
                        //                        }
                        NSLog(@"left");
                    }
                    pan.enabled = NO;
                    pan.enabled = YES;
                } else {
                    if (offset.y < 0) {
                        self.direction = CardDirectionUp;
                        NSLog(@"up");
                    }else{
                        self.direction = CardDirectionDown;
                        NSLog(@"down");
                    }
                    if ([self.delegate collectionViewPanGenstureEnabled]) {
                        [self.delegate cardViewPanGensterRequiredCollectViewPanGesterFailed:NO];
                    }
                }
                self.isFirstChanged = NO;
            }
            if (self.cardState == CardStateTop) {
                self.tableView.scrollEnabled = YES;
                if (self.direction == CardDirectionUp ){
                    //处理pan与scrollview的pangensture
                    pan.enabled = NO;
                    pan.enabled = YES;
                }else if(self.direction == CardDirectionDown){
                    CGFloat curOffsetY = self.tableView.contentOffset.y;
                    if (curOffsetY <= 0) {
                        self.tableView.contentOffset = CGPointZero;
                        self.tableView.scrollEnabled = NO;
                        
                        [self.delegate cardViewDidMoved:self.oldOffset + offset.y];
                    }else{
                        //处理pan与scrollview的pangensture
                        pan.enabled = NO;
                        pan.enabled = YES;
                    }
                }
                return;
                
            }else if (self.cardState == CardStateBottom && self.direction == CardDirectionDown){
                return;
            }else if (self.direction == CardDirectionUp||self.direction == CardDirectionDown){
                CGFloat offsetH = self.oldOffset + offset.y;
                if (offsetH < maxOffsetH) {
                    offsetH = maxOffsetH;
                }
                self.tableView.scrollEnabled = NO;
                [self.delegate cardViewDidMoved:offsetH];
            }
            return;
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        {
            if (self.cardState == CardStateNormal) {
                if (self.delegate.frame.origin.y - self.delegate.oldFrame.origin.y < -kStretchH) {
                    [self reloadUI:kTopOffsetY carState:CardStateTop];
                } else if (self.delegate.frame.origin.y - self.delegate.oldFrame.origin.y > kStretchH) {
                    [self reloadUI:kBottomOffetY carState:CardStateBottom];
                } else {
                    [self reloadUI:kNormalOffsetY carState:CardStateNormal];
                }
            }else if(self.cardState == CardStateTop) {
                if (self.delegate.frame.origin.y  > kStretchH+64) {
                    [self reloadUI:kNormalOffsetY carState:CardStateNormal];
                }else{
                    [self reloadUI:kTopOffsetY carState:CardStateTop];
                }
            }else if (self.cardState == CardStateBottom) {
                if (self.delegate.frame.origin.y - self.delegate.oldFrame.origin.y < kStretchH) {//距离基准线的距离
                    [self reloadUI:kNormalOffsetY carState:CardStateNormal];
                }else{
                    [self reloadUI:kBottomOffetY carState:CardStateBottom];
                }
            }
            
            return;
        }
            break;
        case UIGestureRecognizerStateCancelled:
            break;
        case UIGestureRecognizerStateFailed:
            break;
        default:
            break;
    }
    
}

- (void)reloadUI:(CGFloat)offset carState:(CardState)cardState {
    if (cardState == CardStateTop) {
        [self headerShadowHidden:false];
    }else{
        [self headerShadowHidden:true];
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self reloadContentView:cardState];
        [self.delegate cardViewCardStateWillChange:cardState];
        [self.delegate cardViewDidMoved:offset];
    } completion:^(BOOL finished) {
        self.cardState = cardState;
    }];
}

- (void)reloadContentView:(CardState)cardState {
    
    if (cardState == CardStateTop) {
        //        CGAffineTransform transform = self.tableView.transform;
        //        transform = CGAffineTransformScale(transform, scale,1);
        
        CGFloat scale = SCREEN_WIDTH/(SCREEN_WIDTH-20);
        [self setViewScale:scale];
    }else{
        //        CGAffineTransform transform = self.tableView.transform;
        //        transform = CGAffineTransformScale(transform, scale,1);
        [self setViewScale:1.0];
        
    }
}

- (void)setViewScale:(CGFloat)scale{
    
    self.tableView.transform = CGAffineTransformMakeScale(scale,scale);
    self.headerView.transform = CGAffineTransformMakeScale(scale,scale);
    CGRect newFrame = self.headerView.frame;
    self.headerView.frame = CGRectMake(newFrame.origin.x, 0, newFrame.size.width, newFrame.size.height);
    CGFloat height = self.headerView.frame.size.height;
    self.tableView.frame = CGRectMake(newFrame.origin.x, height, newFrame.size.width, self.bounds.size.height-height);
    
}


#pragma mark - gestureDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - publicMethod
- (void)resumeCardView {
    [self reloadUI:kNormalOffsetY carState:CardStateNormal];
}

- (void)minimizeCardView {
    [self reloadUI:kBottomOffetY carState:CardStateBottom];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
        cell.contentView.backgroundColor = self.tableView.backgroundColor;
        cell.textLabel.text = @"我是cell";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.f;
}


@end

