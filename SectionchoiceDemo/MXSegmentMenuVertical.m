//
//  MXSegmentMenuVertical.m
//  SectionchoiceDemo
//
//  Created by muxue on 2019/1/5.
//  Copyright © 2019 暮雪. All rights reserved.
//

#import "MXSegmentMenuVertical.h"

@interface MXSegmentMenuVertical ()
@property (nonatomic, strong) UIButton *selectedView;
@property (nonatomic, readonly) CGFloat flagViewWidth;
@property (nonatomic, readonly) CGFloat flagViewHeight;
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
//描述
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, MXSegmentMenuAttributes>*attrbutes;
@end

@implementation MXSegmentMenuVertical

- (CGFloat)flagViewHeight {
    CGSize size = [self.selectedView.currentTitle sizeWithAttributes:@{NSFontAttributeName: self.selectedView.titleLabel.font}];
    switch (self.flagStyle) {
        case MXSegmentMenuFlagStyleBackground:
            return size.height + 20;
            break;
        case MXSegmentMenuFlagStyleBottomLine:
            return self.selectedView.frame.size.height;
            break;
        default:
            break;
    }
    return 0;
}

- (void)setFlagThickness:(CGFloat)flagThickness {
    [super setFlagThickness:flagThickness];
    CGRect frame = self.flagView.frame;
    frame.size.width = flagThickness;
    self.flagView.frame = frame;
}

- (void)setFlagStyle:(MXSegmentMenuFlagStyle)flagStyle {
    [super setFlagStyle:flagStyle];
    switch (self.flagStyle) {
        case MXSegmentMenuFlagStyleBackground:
            self.flagView.frame = CGRectMake(10, 0, self.frame.size.width - 20, 0);
            break;
        case MXSegmentMenuFlagStyleBottomLine:
            self.flagView.frame = CGRectMake(0, 0, 4, 0);
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

- (void)createTitles {
    CGFloat W = self.frame.size.width;
    CGFloat normalH = self.frame.size.height/self.numberRows;
    CGFloat Y = 0;
    CGFloat X = 0;
    for (NSInteger i = 0; i < self.numberRows; i++) {
        
        UIButton *item = [[UIButton alloc] init];
        [item addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat itemH = normalH;
        UIColor *normalColor = self.titleNormaColor;
        UIColor *selectedColor = self.titleSelectedColor;
        UIFont *font = self.titleNormaFont;
        NSString *text = nil;
        
        MXSegmentMenuAttributes attrbutes = [self.segmentDelegate itemAttrbuteWithSegmentMenu:self itemForIndex:i];
        if (attrbutes[MXSegmentMenuAttributeTitleWidth]) {
            itemH = [attrbutes[MXSegmentMenuAttributeTitleWidth] floatValue];
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
        Y = CGRectGetMaxY(item.frame);
    }
    self.contentSize = CGSizeMake(0, Y);
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

//移动到 selectView 位置处
- (void)moveFlagView {
    if (!self.selectedView) {
        return;
    }
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.flagView.center.x, self.selectedView.center.y)];
    
    CABasicAnimation *frameAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.size.height"];
    frameAnimation.toValue = @(self.flagViewHeight);
    groupAnimation.animations = @[positionAnimation, frameAnimation];
    groupAnimation.removedOnCompletion = NO;
    groupAnimation.fillMode = kCAFillModeForwards;
    groupAnimation.duration = 0.25;
    [self.flagView.layer addAnimation:groupAnimation forKey:nil];
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    if (selectIndex >= self.numberRows) {
        return;
    }
    if ([self.segmentDelegate respondsToSelector:@selector(segmentMenu:deSelectedIndex:)]) {
        [self.segmentDelegate segmentMenu:self deSelectedIndex:self.selectedView.tag - kBaseItemTag];
    }
    
    [super setSelectIndex:selectIndex];
    self.selectedView.selected = NO;
    self.selectedView = (UIButton *)[self viewWithTag:selectIndex + kBaseItemTag];
    self.selectedView.selected = YES;
    
    CGFloat offsetY = MAX(self.selectedView.center.y - self.frame.size.height * 0.5, 0);
    CGFloat maxOffsetY = MAX(self.contentSize.height - self.frame.size.height, 0);
    [self setContentOffset:CGPointMake(0, MIN(offsetY, maxOffsetY)) animated:YES];
    //移动滑动标示
    [self moveFlagView];
    
    if ([self.segmentDelegate respondsToSelector:@selector(segmentMenu:didSelectedIndex:)]) {
        [self.segmentDelegate segmentMenu:self didSelectedIndex:self.selectedView.tag - kBaseItemTag];
    }
}
@end
