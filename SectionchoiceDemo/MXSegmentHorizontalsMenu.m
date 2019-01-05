//
//  MXSegmentHorizontalsMenu.m
//  SectionchoiceDemo
//
//  Created by muxue on 2019/1/5.
//  Copyright © 2019 暮雪. All rights reserved.
//

#import "MXSegmentHorizontalsMenu.h"

@interface MXSegmentHorizontalsMenu ()
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

@implementation MXSegmentHorizontalsMenu


- (void)setFlagStyle:(MXSegmentMenuFlagStyle)flagStyle {
    [super setFlagStyle:flagStyle];
    switch (self.flagStyle) {
        case MXSegmentMenuFlagStyleBackground:
            self.flagView.frame = CGRectMake(0, 10, 0, self.frame.size.height - 20);
            break;
        case MXSegmentMenuFlagStyleBottomLine:
            self.flagView.frame = CGRectMake(0, self.frame.size.height - 4, 0, 4);
            break;
        case MXSegmentMenuFlagStyleBottomNone:
            [self.flagView removeFromSuperview];
            self.flagView = nil;
            break;
        case MXSegmentMenuFlagStyleBottomCustom:
            [self.flagView removeFromSuperview];
            self.flagView = nil;
            break;
        default:
            break;
    }
    [self moveFlagView];
    [self setNeedsLayout];
}

- (void)setFlagThickness:(CGFloat)flagThickness {
    [super setFlagThickness:flagThickness];
    CGRect frame = self.flagView.frame;
    frame.size.height = flagThickness;
    self.flagView.frame = frame;
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    if (selectIndex >= self.numberRows) {
        return;
    }
    if ([self.segmentDelegate respondsToSelector:@selector(segmentMenu:deSelectedIndex:)]) {
        [self.segmentDelegate segmentMenu:self deSelectedIndex:self.selectedView.tag - kBaseItemTag];
    }
    
    [super setSelectIndex:selectIndex];
    self.selectedView.backgroundColor = self.normalBackgroundColor;
    self.selectedView = (UIButton *)[self viewWithTag:selectIndex + kBaseItemTag];
    self.selectedView.selected = YES;
    self.selectedView.backgroundColor = self.selectedBackgroundColor;
    //滑动父视图
    CGFloat offsetX = MAX(self.selectedView.center.x - self.frame.size.width * 0.5, 0);
    CGFloat maxOffsetX = MAX(self.contentSize.width - self.frame.size.width, 0);
    [self setContentOffset:CGPointMake(MIN(offsetX, maxOffsetX), 0) animated:YES];
    //移动滑动标示
    [self moveFlagView];
    
    if ([self.segmentDelegate respondsToSelector:@selector(segmentMenu:didSelectedIndex:)]) {
        [self.segmentDelegate segmentMenu:self didSelectedIndex:self.selectedView.tag - kBaseItemTag];
    }
}

//移动到 selectView 位置处
- (void)moveFlagView {
    if (!self.selectedView) {
        return;
    }
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.selectedView.center.x, self.flagView.center.y)];
    
    CABasicAnimation *frameAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.size.width"];
    frameAnimation.toValue = @(self.flagViewWidth);
    groupAnimation.animations = @[positionAnimation, frameAnimation];
    groupAnimation.removedOnCompletion = NO;
    groupAnimation.fillMode = kCAFillModeForwards;
    groupAnimation.duration = 0.25;
    [self.flagView.layer addAnimation:groupAnimation forKey:nil];
}

- (CGFloat)flagViewWidth {
    CGSize size = [self.selectedView.currentTitle sizeWithAttributes:@{NSFontAttributeName: self.selectedView.titleLabel.font}];
    switch (self.flagStyle) {
        case MXSegmentMenuFlagStyleBackground:
            return size.width + 20;
            break;
        case MXSegmentMenuFlagStyleBottomLine:
            return size.width;
            break;
        default:
            break;
    }
    return 0;
}

- (void)createTitles {
    CGFloat normalW = self.frame.size.width/self.numberRows;
    CGFloat itemH = self.frame.size.height;
    CGFloat Y = 0;
    CGFloat X = 0;
    for (NSInteger i = 0; i < self.numberRows; i++) {
        
        UIButton *item = [[UIButton alloc] init];
        [item addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat W = normalW;
        UIColor *normalColor = self.titleNormaColor;
        UIColor *selectedColor = self.titleSelectedColor;
        UIFont *font = self.titleNormaFont;
        NSString *text = nil;
        
        MXSegmentMenuAttributes attrbutes = [self.segmentDelegate itemAttrbuteWithSegmentMenu:self itemForIndex:i];
        if (attrbutes[MXSegmentMenuAttributeTitleWidth]) {
            W = [attrbutes[MXSegmentMenuAttributeTitleWidth] floatValue];
        }
        if (attrbutes[MXSegmentMenuAttributeTitleNormalFont]) {
            font = attrbutes[MXSegmentMenuAttributeTitleNormalFont];
        }
        if (attrbutes[MXSegmentMenuAttributeTitleNormalColor]) {
            normalColor = attrbutes[MXSegmentMenuAttributeTitleNormalColor];
        }
        if (attrbutes[MXSegmentMenuAttributeTitleSelectedColor]) {
            selectedColor = attrbutes[MXSegmentMenuAttributeTitleSelectedColor];
        }
        if (attrbutes[MXSegmentMenuAttributeNormalContentImage]) {
            [item setImage:attrbutes[MXSegmentMenuAttributeNormalContentImage] forState:UIControlStateNormal];
        }
        if (attrbutes[MXSegmentMenuAttributeSelectContentImage]) {
            [item setImage:attrbutes[MXSegmentMenuAttributeSelectContentImage] forState:UIControlStateSelected];
        }
        if (attrbutes[MXSegmentMenuAttributeBackguroundNormalImage]) {
            [item setBackgroundImage:attrbutes[MXSegmentMenuAttributeBackguroundNormalImage] forState:UIControlStateNormal];
        }
        if (attrbutes[MXSegmentMenuAttributeBackguroundSelectedImage]) {
            [item setBackgroundImage: attrbutes[MXSegmentMenuAttributeBackguroundSelectedImage] forState:UIControlStateSelected];
        }
        if (attrbutes[MXSegmentMenuAttributeTitleContentString]) {
            text = attrbutes[MXSegmentMenuAttributeTitleContentString];
        }
        item.frame = CGRectMake(X, Y, W, itemH);
        [item setTitle:text forState:UIControlStateNormal];
        [item setTitleColor:selectedColor forState:UIControlStateSelected];
        [item setTitleColor:normalColor forState:UIControlStateNormal];
        item.titleLabel.font = font;
        [self addSubview:item];
        item.tag = i + kBaseItemTag;
        X = CGRectGetMaxX(item.frame);
    }
    self.contentSize = CGSizeMake(X, 0);
    self.selectIndex = self.selectIndex;
}

- (void)clicked:(UIButton *)btn {
    //是否选中
    if ([self.delegate respondsToSelector:@selector(segmentMenu:shouldSelectIndex:)]) {
        if (![self.segmentDelegate segmentMenu:self shouldSelectIndex:btn.tag - kBaseItemTag]) {
            return;
        }
    }
    self.selectIndex = btn.tag - kBaseItemTag;
}
@end
