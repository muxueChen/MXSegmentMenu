//
//  MXSegmentMenu.m
//  SectionchoiceDemo
//
//  Created by muxue on 2019/1/4.
//  Copyright © 2019 暮雪. All rights reserved.
//

#import "MXSegmentMenu.h"
#import "MXSegmentMenuVertical.h"
#import "MXSegmentHorizontalsMenu.h"
#define kBaseItemTag 100
#define kFont [UIFont systemFontOfSize:16]

MXSegmentMenuAttributeKey MXSegmentMenuAttributeTitleNormalFont         = @"MXSegmentMenuAttributeTitleNormalFontKey";
MXSegmentMenuAttributeKey MXSegmentMenuAttributeTitleSelectedFont       = @"MXSegmentMenuAttributeTitleSelectedFontkey";

MXSegmentMenuAttributeKey MXSegmentMenuAttributeTitleWidth              = @"MXSegmentMenuAttributeTitleWidthKey";
/** 默认状态下标题颜色 */
MXSegmentMenuAttributeKey MXSegmentMenuAttributeTitleNormalColor        = @"MXSegmentMenuAttributeTitleNormalColor";
/** 选中状态下的标题颜色 */
MXSegmentMenuAttributeKey MXSegmentMenuAttributeTitleSelectedColor      = @"MXSegmentMenuAttributeTitleSelectedColor";
/** 默认状态背景图片 */
MXSegmentMenuAttributeKey MXSegmentMenuAttributeBackguroundNormalImage  = @"MXSegmentMenuAttributeBackguroundNormalImage";
/** 选中状态背景图片 */
MXSegmentMenuAttributeKey MXSegmentMenuAttributeBackguroundSelectedImage = @"MXSegmentMenuAttributeBackguroundSelectedImage";
/** 默认状态内容图片 */
MXSegmentMenuAttributeKey MXSegmentMenuAttributeNormalContentImage      = @"MXSegmentMenuAttributeNormalContentImage";
/** 选中状态内容图片 */
MXSegmentMenuAttributeKey MXSegmentMenuAttributeSelectContentImage      = @"MXSegmentMenuAttributeSelectContentImage";
/** 文本内容 */
MXSegmentMenuAttributeKey MXSegmentMenuAttributeTitleContentString      = @"MXSegmentMenuAttributeTitleContentString";


@interface MXSegmentMenu () 

@property (nonatomic, strong) UIView *flagView;
@property (nonatomic, strong) UIButton *selectedView;
@property (nonatomic, readonly) CGFloat flagViewWidth;
@property (nonatomic, assign) NSInteger numberRows;
//选中标识符颜色
@property (nonatomic, strong) UIColor *flagColor;

//标题颜色
@property (nonatomic, strong) UIColor *titleNormaColor;
@property (nonatomic, strong) UIColor *titleSelectedColor;
//默认状态标题字体
@property (nonatomic, strong) UIFont *titleNormaFont;
//选中状态字体
@property (nonatomic, strong) UIFont *titleSelectedFont;

@end

@implementation MXSegmentMenu

+ (instancetype)segmentMenuWithFrame:(CGRect)frame direction:(MXSegmentMenuDirection)direction {
    return direction == MXSegmentMenuDirectionHorizontals ? [[MXSegmentHorizontalsMenu alloc] initWithFrame:frame] : [[MXSegmentMenuVertical alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _flagColor = UIColor.blackColor;
        _titleSelectedColor = UIColor.whiteColor;
        _titleNormaColor = UIColor.whiteColor;
        _selectIndex = 0;
        _titleNormaFont = [UIFont systemFontOfSize:14];
        _titleSelectedFont = [UIFont systemFontOfSize:14];
    }
    return self;
}
//返回指定的Button
- (UIButton *)itemWithIndex:(NSInteger)index {
    return [self viewWithTag:kBaseItemTag + index];
}
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self reLoadView];
}
- (void)setFlagColor:(UIColor *)flagColor {
    _flagColor = flagColor;
    self.flagView.backgroundColor = flagColor;
}
- (UIView *)flagView {
    if (!_flagView) {
        _flagView = [[UIView alloc] init];
        [self addSubview:self.flagView];
    }
    return _flagView;
}
- (void)reLoadView {
    for (UIView *view in self.subviews) {
        if (![view isEqual:self.flagView]) {
            [view removeFromSuperview];
        }
    }
    self.numberRows = [self.segmentDelegate numberRowsWithsegmentMenu:self];
    if (self.numberRows <= 0) {
        self.flagView.hidden = YES;
        return;
    }
    self.flagView.hidden = NO;
    [self createTitles];
}

- (void)createTitles {
    
}
@end
