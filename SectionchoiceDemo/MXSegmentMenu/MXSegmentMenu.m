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

/** 选中状态内容图片 */
MXSegmentMenuAttributeKey MXSegmentMenuContentImage = @"MXSegmentMenuContentImageKey";
/** item宽度 */
MXSegmentMenuAttributeKey MXSegmentMenuContentSize = @"MXSegmentMenuContentSizeKey";
/** 文本内容 */
MXSegmentMenuAttributeKey MXSegmentMenuContentString = @"MXSegmentMenuContentStringkey";

@interface MXSegmentMenu ()
@property (nonatomic, assign) NSInteger numberRows;
//选中标识符颜色
@property (nonatomic, strong) UIColor *flagColor;

@end

@implementation MXSegmentMenu

+ (instancetype)segmentMenuWithFrame:(CGRect)frame direction:(MXSegmentMenuDirection)direction {
    return direction == MXSegmentMenuDirectionHorizontals ? [[MXSegmentHorizontalsMenu alloc] initWithFrame:frame] : [[MXSegmentMenuVertical alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _flagColor = UIColor.blackColor;
        _selectedTitleColor = UIColor.whiteColor;
        _normalTitleColor = UIColor.whiteColor;
        _selectIndex = 0;
        _normalFont = [UIFont systemFontOfSize:14];
        _selectedFont = [UIFont systemFontOfSize:14];
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
        _flagView.backgroundColor = UIColor.blackColor;
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
