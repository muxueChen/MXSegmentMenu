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
    
    //垂直方向
    MXSegmentMenu *sectionchoiceView1 = [MXSegmentMenu segmentMenuWithFrame:CGRectMake(10, 220, 100, ScreenHeight - 300) direction:MXSegmentMenuDirectionVertical];
    sectionchoiceView1.backgroundColor = UIColor.greenColor;
    sectionchoiceView1.segmentDelegate = self;
    sectionchoiceView1.flagStyle = MXSegmentMenuFlagStyleBackground;
    sectionchoiceView1.flagView.backgroundColor = UIColor.redColor;
    [self.view addSubview:sectionchoiceView1];
    
    MXSegmentMenu *sectionchoiceView2 = [MXSegmentMenu segmentMenuWithFrame:CGRectMake(120, 220, 100, ScreenHeight - 300) direction:MXSegmentMenuDirectionVertical];
    sectionchoiceView2.backgroundColor = UIColor.greenColor;
    sectionchoiceView2.segmentDelegate = self;
    sectionchoiceView2.flagStyle = MXSegmentMenuFlagStyleBottomNone;
    sectionchoiceView2.normalBackgroundColor = UIColor.greenColor;
    sectionchoiceView2.selectedBackgroundColor = UIColor.redColor;
    [self.view addSubview:sectionchoiceView2];
    
    MXSegmentMenu *sectionchoiceView3 = [MXSegmentMenu segmentMenuWithFrame:CGRectMake(230, 220, 100, ScreenHeight - 300) direction:MXSegmentMenuDirectionVertical];
    sectionchoiceView3.backgroundColor = UIColor.greenColor;
    sectionchoiceView3.segmentDelegate = self;
    sectionchoiceView3.flagStyle = MXSegmentMenuFlagStyleBottomLine;
    [self.view addSubview:sectionchoiceView3];
    
    
    //水平方向
    MXSegmentMenu *sectionchoiceView4 = [MXSegmentMenu segmentMenuWithFrame:CGRectMake(10, 40, 400, 50) direction:MXSegmentMenuDirectionHorizontals];
    sectionchoiceView4.center = CGPointMake(self.view.center.x, sectionchoiceView4.center.y);
    sectionchoiceView4.backgroundColor = UIColor.greenColor;
    sectionchoiceView4.segmentDelegate = self;
    sectionchoiceView4.flagStyle = MXSegmentMenuFlagStyleBackground;
    sectionchoiceView4.flagView.backgroundColor = UIColor.redColor;
    sectionchoiceView4.normalBackgroundColor = UIColor.greenColor;
    sectionchoiceView4.selectedBackgroundColor = UIColor.redColor;
    [self.view addSubview:sectionchoiceView4];
    
    MXSegmentMenu *sectionchoiceView5 = [MXSegmentMenu segmentMenuWithFrame:CGRectMake(10, 100, 400,50) direction:MXSegmentMenuDirectionHorizontals];
    sectionchoiceView5.center = CGPointMake(self.view.center.x, sectionchoiceView5.center.y);
    sectionchoiceView5.backgroundColor = UIColor.greenColor;
    sectionchoiceView5.segmentDelegate = self;
    sectionchoiceView5.flagStyle = MXSegmentMenuFlagStyleBottomNone;
//    sectionchoiceView5.normalBackgroundColor = UIColor.greenColor;
//    sectionchoiceView5.selectedBackgroundColor = UIColor.redColor;
    [self.view addSubview:sectionchoiceView5];
    
    MXSegmentMenu *sectionchoiceView6 = [MXSegmentMenu segmentMenuWithFrame:CGRectMake(10, 160, 400, 50) direction:MXSegmentMenuDirectionHorizontals];
    sectionchoiceView6.center = CGPointMake(self.view.center.x, sectionchoiceView6.center.y);
    sectionchoiceView6.backgroundColor = UIColor.greenColor;
    sectionchoiceView6.segmentDelegate = self;
    sectionchoiceView6.flagStyle = MXSegmentMenuFlagStyleBottomLine;
//    sectionchoiceView6.normalBackgroundColor = UIColor.greenColor;
//    sectionchoiceView6.selectedBackgroundColor = UIColor.redColor;
    [self.view addSubview:sectionchoiceView6];
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
             MXSegmentMenuAttributeTitleWidth:@(size.width + 40),
             MXSegmentMenuAttributeTitleNormalColor:UIColor.grayColor,
             MXSegmentMenuAttributeTitleSelectedColor:UIColor.blackColor
             };
}
@end
