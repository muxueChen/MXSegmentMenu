//
//  ViewController.m
//  SectionchoiceDemo
//
//  Created by muxue on 2019/1/3.
//  Copyright © 2019 暮雪. All rights reserved.
//

#import "ViewController.h"
#import "MXSegmentMenu.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController () <MXSegmentMenuDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) MXSegmentMenu *sectionchoiceView;
@property (nonatomic, strong) MXSegmentMenu *segemntMenu;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.segemntMenu = [[MXSegmentMenu alloc] initWithFrame:CGRectMake(0, 40, 300, 50)];
    self.segemntMenu.center = CGPointMake(self.view.center.x, self.segemntMenu.center.y);
    self.segemntMenu.backgroundColor = UIColor.greenColor;
    self.segemntMenu.titleSelectedColor = UIColor.redColor;
    self.segemntMenu.titleNormaColor = UIColor.grayColor;
    self.segemntMenu.delegate = self;
    [self.view addSubview:self.segemntMenu];
    
    self.sectionchoiceView = [[MXSegmentMenu alloc] initWithFrame:CGRectMake(0, 100, 300, 50)];
    self.sectionchoiceView.center = CGPointMake(self.view.center.x, self.sectionchoiceView.center.y);
    self.sectionchoiceView.backgroundColor = UIColor.greenColor;
    self.sectionchoiceView.delegate = self;
    self.sectionchoiceView.titleSelectedColor = UIColor.redColor;
    self.sectionchoiceView.titleNormaColor = UIColor.grayColor;
    self.sectionchoiceView.flagStyle = MXSegmentMenuFlagStyleBackground;
    [self.view addSubview:self.sectionchoiceView];
}


#pragma mark -
- (NSArray *)dataSourceSegmentMenu:(MXSegmentMenu *)sectionchoiceView {
    return @[@"全部", @"未付款", @"交易完成", @"售后"];
}

- (BOOL)segmentMenu:(MXSegmentMenu *)sectionchoiceView shouldSelectIndex:(NSInteger)index {
    return YES;
}

- (void)segmentMenu:(MXSegmentMenu *)sectionchoiceView didSelectedIndex:(NSInteger)index {
//     [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * index, 0) animated:YES];
}


- (void)addScrollView {
    CGFloat Y = CGRectGetMaxY(self.sectionchoiceView.frame) + 20;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, Y, ScreenWidth - 20, ScreenHeight - Y - 40)];
    [self.view addSubview:self.scrollView];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = UIColor.greenColor;
    [self setupScrollSubView];
}

- (void)setupScrollSubView {
    NSArray <UIColor *>*backgroundColorArray = @[UIColor.greenColor, UIColor.redColor, UIColor.yellowColor, UIColor.purpleColor];
    for (NSInteger  i = 0; i < backgroundColorArray.count; i ++) {
        UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(self.scrollView.frame.size.width * i, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        titlelabel.textAlignment = NSTextAlignmentCenter;
        titlelabel.backgroundColor = backgroundColorArray[i];
        titlelabel.text = [NSString stringWithFormat:@"--%ld--", i];
        [self.scrollView addSubview:titlelabel];
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * backgroundColorArray.count,0);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x/scrollView.frame.size.width;
    self.sectionchoiceView.selectIndex = page;
}
@end
