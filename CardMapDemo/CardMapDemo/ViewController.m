//
//  ViewController.m
//  OrderMapDemo
//
//  Created by clf on 2018/1/10.
//  Copyright © 2018年 clf. All rights reserved.
//

#import "ViewController.h"
#import "CardView.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define kScaleH SCREEN_HEIGHT/667.f

@interface ViewController ()<CardViewDelegate>
@property (nonatomic, strong) CardView * cardView;

@property (nonatomic, strong) UIButton * mineLocationBtn;
@property (nonatomic, strong) UIButton * shopBtn;
@property (nonatomic, strong) UIButton * scaleBtn;
@property (nonatomic, strong) UIView * navView;
@property (nonatomic, strong) UIImageView * zoomView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CardView * view = [[CardView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-285 * kScaleH,SCREEN_WIDTH, SCREEN_HEIGHT-60)];
    self.cardView = view;
    self.cardView.delegate = self;
    
    UIImageView * map = [[UIImageView alloc] initWithFrame:self.view.bounds];
    map.image = [UIImage imageNamed:@"1"];
    map.contentMode = UIViewContentModeCenter;
    [self.view addSubview:map];

    [self.view addSubview:view];
    [self.view addSubview:self.mineLocationBtn];
    [self.view addSubview:self.shopBtn];
    [self.view addSubview:self.scaleBtn];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.zoomView];
    [self.view bringSubviewToFront:self.cardView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addShadowOffForView:(UIView *)view{
    view.layer.shadowOffset = CGSizeMake(0, 0);
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOpacity = 0.4;
    view.layer.shadowRadius = 2.0;
}

- (UIButton *)mineLocationBtn {
    if (_mineLocationBtn == nil) {
        UIButton * mineLocationBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, self.cardView.frame.origin.y-90, 36, 36)];
        [mineLocationBtn setImage:[UIImage imageNamed:@"icon_me_map"] forState:(UIControlStateNormal)];
        [self addShadowOffForView:mineLocationBtn];
        _mineLocationBtn = mineLocationBtn;
    }
    return _mineLocationBtn;
}

- (UIButton *)shopBtn {
    if (_shopBtn == nil) {
        UIButton * shopBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, self.mineLocationBtn.frame.origin.y+self.mineLocationBtn.frame.size.height+8, 36, 36)];
        [shopBtn setImage:[UIImage imageNamed:@"icon_shop_map"] forState:(UIControlStateNormal)];
        [self addShadowOffForView:shopBtn];
        
        _shopBtn = shopBtn;
    }
    return  _shopBtn;
}

- (UIButton *)scaleBtn {
    if (_scaleBtn == nil) {
        UIButton * scaleBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-46, self.cardView.frame.origin.y-51, 36, 36)];
        [scaleBtn setImage:[UIImage imageNamed:@"icon_big_map"] forState:(UIControlStateNormal)];
        _scaleBtn = scaleBtn;
        [self addShadowOffForView:scaleBtn];
        
    }
    return _scaleBtn;
}

- (UIView *)navView {
    if (_navView == nil) {
        UIView * navView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-84)/2.f, self.cardView.frame.origin.y-51, 84, 36)];
        navView.backgroundColor = [UIColor whiteColor];
        //        navView.clipsToBounds = YES;
        navView.layer.cornerRadius = 18.f;
        UIButton * navBtn = [[UIButton alloc] initWithFrame:navView.bounds];
        [navBtn setImage:[UIImage imageNamed:@"icon_navigation_map"] forState:(UIControlStateNormal)];
        [navBtn setTitle:@" 导航" forState:(UIControlStateNormal)];
        [navBtn setTitleColor:[UIColor colorWithRed:24/255.f green:162/255.f blue:254/255.f alpha:1.0] forState:(UIControlStateNormal)];
        [navView addSubview:navBtn];
        _navView = navView;
        [self addShadowOffForView:navView];
        
    }
    return _navView;
}

- (UIImageView *)zoomView {
    if (_zoomView == nil) {
        UIImageView * view = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-46, self.cardView.frame.origin.y-171, 36,75)];
        view.image = [UIImage imageNamed:@"icon_change_map"];
        view.userInteractionEnabled = YES;
        UIButton * addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 37)];
        [view addSubview:addBtn];
        UIButton * minusBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 38, 36, 37)];
        [view addSubview:minusBtn];
        view.hidden = YES;
        _zoomView = view;
        [self addShadowOffForView:view];
        
    }
    return _zoomView;
}
#pragma mark - CardViewDelegate

- (void)cardListCardStateWillChange:(CardState)cardState {
    if (cardState == CardStateTop) {

        [UIView animateWithDuration:0.5 animations:^{

            self.zoomView.hidden = YES;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
    }else if (cardState == CardStateNormal){
        [self.scaleBtn setImage:[UIImage imageNamed:@"icon_big_map"] forState:(UIControlStateNormal)];
        [UIView animateWithDuration:0.5 animations:^{
            self.zoomView.hidden = YES;
            [self.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
        }];
    }else if(cardState == CardStateBottom){
        [self.scaleBtn setImage:[UIImage imageNamed:@"icon_small_map"] forState:(UIControlStateNormal)];

        [UIView animateWithDuration:0.3 animations:^{
            self.zoomView.hidden = NO;
            
        } completion:^(BOOL finished) {
            self.zoomView.frame = [self getNewFrameWithOffsetY:-171 orignFrame:self.zoomView.frame];
        }];
    }
}
- (void)cardListDidMoved:(CGFloat)offset {
    if (offset >= 0) {
        self.mineLocationBtn.frame = [self getNewFrameWithOffsetY:-90 orignFrame:self.mineLocationBtn.frame];
        self.shopBtn.frame = [self getNewFrameWithOffsetY:-51 orignFrame:self.shopBtn.frame];
        self.scaleBtn.frame = [self getNewFrameWithOffsetY:-51 orignFrame:self.scaleBtn.frame];
        self.navView.frame = [self getNewFrameWithOffsetY:-51 orignFrame:self.navView.frame];

    }
}

- (CGRect)getNewFrameWithOffsetY:(CGFloat)newY orignFrame:(CGRect)orignFrame{
    CGRect newFrame = orignFrame;
    newFrame.origin.y = self.cardView.frame.origin.y + newY;
    return newFrame;
}

@end
