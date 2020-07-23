//
//  HLLoadingView.m
//  loadingTest
//
//  Created by 纪志刚 on 2017/8/10.
//  Copyright © 2017年 纪志刚. All rights reserved.
//

#import "HLLoadingView.h"

@interface HLLoadingView ()

@property (nonatomic, strong) UIView *theLoadingView; /**< loadingView*/

@end

@implementation HLLoadingView




static HLLoadingView * shareView;
/**
 生成单利类
 
 @return 单利对象
 */
+ (instancetype) shareInstance {
    
    static dispatch_once_t onceToken;
    if (!shareView) {
        dispatch_once(&onceToken, ^{
            shareView = [[HLLoadingView alloc]init];
        });
    }
    
    return shareView;
}


+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    if (!shareView) {
        dispatch_once(&onceToken, ^{
            shareView = [super allocWithZone:zone];
        });
    }
    return shareView;
}



-(instancetype)init{
    //self = [super initWithFrame:CGRectMake(0, 64, KScreenBounds.size.width, KScreenBounds.size.height-64-49)]
    if (self = [super initWithFrame:CGRectMake(0, 0, KScreenBounds.size.width, KScreenBounds.size.height)]) {
        self.backgroundColor = [UIColor clearColor];
//        self.alpha = 0.3;
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToHidden:)];
//        [self addGestureRecognizer:tap];
    }
    return self;
}


- (void)tapToHidden:(UITapGestureRecognizer *)tap {
    [self dismissLoading];
}




/**
 显示loading
 
 @param title loading标题
 */
- (void) showTitle:(NSString *)title {
    if (self.superview) {
        [self removeFromSuperview];
    }
    
//    UIViewController *theVC = [HLUtilTool currentViewController];
//    if (theVC) {
//        self.frame = CGRectMake(0, 0, KScreenBounds.size.width, theVC.view.frame.size.height);
//        [theVC.view addSubview:self];
//    }else{
        [[UIApplication sharedApplication].keyWindow addSubview:self];
//    }
    
    
    if (self.theLoadingView.superview) {
        [self.theLoadingView removeFromSuperview];
    }
    
//    CGRect rect = CGRectMake(self.center.x-100, self.center.y-75, 200, 150);
    self.theLoadingView = [[UIView alloc]init];
    self.theLoadingView.backgroundColor = [UIColor grayColor];
    self.theLoadingView.alpha = 0.65;
    self.theLoadingView.layer.masksToBounds = YES;
    self.theLoadingView.layer.cornerRadius = 5.f;
    [self addSubview:self.theLoadingView];
    [self.theLoadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(150, 120));
    }];
    
//    CGRect imageRect = CGRectMake(self.theLoadingView.center.x-25, self.theLoadingView.center.y-30, 50, 50);
    UIImageView *theImageView = [[UIImageView alloc]init];
    theImageView.image = [UIImage imageNamed:@"loadingImage"];
//    theImageView.center = CGPointMake(self.theLoadingView.center.x, self.theLoadingView.center.y-30);
    [self.theLoadingView addSubview:theImageView];
    [theImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                                    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
                                    animation.fromValue = [NSNumber numberWithFloat:0.f];
                                    animation.toValue =  [NSNumber numberWithFloat: M_PI *2];
                                    animation.duration  = 1;
                                    animation.autoreverses = NO;
                                    animation.fillMode =kCAFillModeForwards;
                                    animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
                                    [theImageView.layer addAnimation:animation forKey:nil];
    
    
    
    
    UILabel *theLabel = [[UILabel alloc]init];//WithFrame:CGRectMake(0, CGRectGetMaxY(theImageView.frame)+10, CGRectGetWidth(theImageView.frame), 20)
//    theLabel.center = CGPointMake(self.theLoadingView.center.x, self.theLoadingView.center.y+10);
    theLabel.text = title;
    theLabel.textColor = [UIColor whiteColor];
    theLabel.textAlignment = NSTextAlignmentCenter;
    [self.theLoadingView addSubview:theLabel];
    [theLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(theImageView.mas_bottom).offset(10);
    }];
    
    
}



/**
 loading去掉
 */
- (void) dismissLoading {
    [self removeFromSuperview];
    [self.theLoadingView removeFromSuperview];
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
