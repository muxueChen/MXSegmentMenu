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
@property (nonatomic, strong) NSArray *topMenuTitles;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.segemntMenu = [[MXSegmentMenu alloc] initWithFrame:CGRectMake(0, 40, 300, 50)];
    self.segemntMenu.center = CGPointMake(self.view.center.x, self.segemntMenu.center.y);
    self.segemntMenu.backgroundColor = UIColor.greenColor;
    self.segemntMenu.segmentDelegate = self;
    [self.view addSubview:self.segemntMenu];
    
    self.sectionchoiceView = [[MXSegmentMenu alloc] initWithFrame:CGRectMake(0, 100, 300, 50)];
    self.sectionchoiceView.center = CGPointMake(self.view.center.x, self.sectionchoiceView.center.y);
    self.sectionchoiceView.backgroundColor = UIColor.greenColor;
    self.sectionchoiceView.segmentDelegate = self;
    self.sectionchoiceView.flagStyle = MXSegmentMenuFlagStyleBackground;
    [self.view addSubview:self.sectionchoiceView];
    
    MXSegmentMenu *sectionchoiceView = [[MXSegmentMenu alloc] initWithFrame:CGRectMake(0, 160, 300, 50)];
    sectionchoiceView.center = CGPointMake(self.view.center.x, sectionchoiceView.center.y);
    sectionchoiceView.backgroundColor = UIColor.greenColor;
    sectionchoiceView.segmentDelegate = self;

    sectionchoiceView.flagStyle = MXSegmentMenuFlagStyleBackground;
    [self.view addSubview:sectionchoiceView];
    
    MXSegmentMenu *sectionchoiceView1 = [[MXSegmentMenu alloc] initWithFrame:CGRectMake(0, 220, 100, ScreenHeight - 300)];
    sectionchoiceView1.center = CGPointMake(self.view.center.x, sectionchoiceView1.center.y);
    sectionchoiceView1.backgroundColor = UIColor.greenColor;
    sectionchoiceView1.segmentDelegate = self;
    sectionchoiceView1.direction = MXSegmentMenuDirectionVertical;
    sectionchoiceView.flagStyle = MXSegmentMenuFlagStyleBackground;
    [self.view addSubview:sectionchoiceView1];
}

- (NSArray *)topMenuTitles {
    if (!_topMenuTitles) {
        _topMenuTitles = @[@"全部", @"未付款", @"交易完成", @"售后",@"全部", @"未付款", @"交易完成", @"售后",@"全部", @"未付款", @"交易完成", @"售后",  @"未付款", @"交易完成", @"售后",@"全部", @"未付款", @"交易完成", @"售后"];
    }
    return _topMenuTitles;
}
#pragma mark - MXSegmentMenuDelegate
// 一共显示多少个 Item
- (NSInteger)numberRowsWithsegmentMenu:(MXSegmentMenu *)segmentMenuView {
    return self.topMenuTitles.count;
}
- (MXSegmentMenuAttributes)itemAttrbuteWithSegmentMenu:(MXSegmentMenu *)segmentMenuView itemForIndex:(NSInteger)index {
    NSString *text = self.topMenuTitles[index];
    UIFont *font = [UIFont systemFontOfSize:17];
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: font}];
    return @{MXSegmentMenuAttributeTitleNormalFont: font,
             MXSegmentMenuAttributeTitleContentString: text,
             MXSegmentMenuAttributeTitleWidth:@(size.width + 20)};
}
@end
