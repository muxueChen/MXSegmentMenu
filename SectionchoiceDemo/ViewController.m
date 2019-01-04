//
//  ViewController.m
//  SectionchoiceDemo
//
//  Created by muxue on 2019/1/3.
//  Copyright © 2019 暮雪. All rights reserved.
//

#import "ViewController.h"
#import "SectionchoiceView.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController () <SectionchoiceViewDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) SectionchoiceView *sectionchoiceView;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sectionchoiceView = [[SectionchoiceView alloc] initWithFrame:CGRectMake(0, 100, 300, 50)];
    self.sectionchoiceView.center = CGPointMake(self.view.center.x, self.sectionchoiceView.center.y);
    self.sectionchoiceView.backgroundColor = UIColor.greenColor;
    self.sectionchoiceView.delegate = self;
    [self.view addSubview:self.sectionchoiceView];
    CGFloat Y = CGRectGetMaxY(self.sectionchoiceView.frame) + 20;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, Y, ScreenWidth - 20, ScreenHeight - Y - 40)];
    [self.view addSubview:self.scrollView];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = UIColor.greenColor;
    [self setupScrollSubView];
    [self.sectionchoiceView loadView];
}
- (void)setupScrollSubView {
    UIView *leftView = nil;
    NSArray <UIColor *>*backgroundColorArray = @[UIColor.greenColor, UIColor.redColor, UIColor.yellowColor, UIColor.purpleColor];
    for (UIColor *color in backgroundColorArray) {
        UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame), 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        titlelabel.backgroundColor = color;
        [self.scrollView addSubview:titlelabel];
        
    }
    self.scrollView.contentSize = CGSizeMake(0, self.scrollView.frame.size.width * backgroundColorArray.count);
}
#pragma mark - SectionchoiceViewDelegate
- (NSArray *)dataSourceSectionchoiceView:(SectionchoiceView *)sectionchoiceView {
    return @[@"全部", @"未付款", @"交易完成"];
}

- (BOOL)sectionchoiceView:(SectionchoiceView *)sectionchoiceView shouldSelectIndex:(NSInteger)index {
    return YES;
}

- (void)sectionchoiceView:(SectionchoiceView *)sectionchoiceView didSelectedIndex:(NSInteger)index {
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}
@end
