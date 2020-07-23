//
//  ViewController.m
//  OCNetDemo
//
//  Created by 纪志刚 on 2020/7/23.
//  Copyright © 2020 纪志刚. All rights reserved.
//

#import "ViewController.h"
#import "TMHomeTopicModel.h"

@interface ViewController ()
@property(nonatomic, strong) UILabel *lab1;
@property(nonatomic, strong) UILabel *lab2;
@property(nonatomic, strong) UILabel *lab3;
@property(nonatomic, strong) UILabel *lab4;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lab1 = [[UILabel alloc] init];
    self.lab1.textColor = [UIColor blackColor];
    self.lab1.font = [UIFont systemFontOfSize:17];
    self.lab1.text = @"hello world!";
    self.lab1.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.lab1];
    
    [self.lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(-100);
    }];
    
    self.lab2 = [[UILabel alloc] init];
    self.lab2.textColor = [UIColor blackColor];
    self.lab2.font = [UIFont systemFontOfSize:17];
    self.lab2.text = @"hello world!";
    self.lab2.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.lab2];
    
    [self.lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(-50);
    }];
    
    self.lab3 = [[UILabel alloc] init];
    self.lab3.textColor = [UIColor blackColor];
    self.lab3.font = [UIFont systemFontOfSize:17];
    self.lab3.text = @"hello world!";
    self.lab3.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.lab3];
    
    [self.lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);    }];
    
    self.lab4 = [[UILabel alloc] init];
    self.lab4.textColor = [UIColor blackColor];
    self.lab4.font = [UIFont systemFontOfSize:17];
    self.lab4.text = @"hello world!";
    self.lab4.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.lab4];
    
    [self.lab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(50);    }];
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"点击开始网络请求" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(didClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(150);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(50);
    }];
    
   
    
    
    
    // Do any additional setup after loading the view.
}


//点击开始网络请求
- (void) didClicked{
     
        MJWeakSelf
        [TMHomeTopicModel requestTopicListSucc:^(NSArray *topicArr) {
            weakSelf.lab1.text = @"网络请求1成功";
        } fail:^(NSString *errStr) {
            weakSelf.lab1.text = [NSString stringWithFormat:@"网络请求1失败：%@",errStr];
        }];
        
            [TMHomeTopicModel requestTopicListSucc:^(NSArray *topicArr) {
                weakSelf.lab2.text = @"网络请求2成功";
            } fail:^(NSString *errStr) {
                weakSelf.lab2.text = [NSString stringWithFormat:@"网络请求2失败：%@",errStr];
            }];
        
            [TMHomeTopicModel requestTopicListSucc:^(NSArray *topicArr) {
                weakSelf.lab3.text = @"网络请求3成功";
            } fail:^(NSString *errStr) {
                weakSelf.lab3.text = [NSString stringWithFormat:@"网络请求3失败：%@",errStr];
            }];
        
            [TMHomeTopicModel requestTopicListSucc:^(NSArray *topicArr) {
                weakSelf.lab4.text = @"网络请求4成功";
            } fail:^(NSString *errStr) {
                weakSelf.lab4.text = [NSString stringWithFormat:@"网络请求4失败：%@",errStr];
            }];
}


@end
