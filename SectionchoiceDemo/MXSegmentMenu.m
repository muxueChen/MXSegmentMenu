//
//  MXSegmentMenu.m
//  SectionchoiceDemo
//
//  Created by muxue on 2019/1/4.
//  Copyright © 2019 暮雪. All rights reserved.
//

#import "MXSegmentMenu.h"

#define kBaseItemTag 100
#define kFont [UIFont systemFontOfSize:16]

@interface MXSegmentMenu () <CAAnimationDelegate>
@property (nonatomic, strong) UIView *flagView;
@property (nonatomic, strong) UIButton *selectedView;
@property (nonatomic, readonly) CGFloat flagViewWidth;
@property (nonatomic, assign) NSInteger numberRows;
@end

@implementation MXSegmentMenu

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

- (CGFloat)flagViewWidth {
    CGSize size = [self.selectedView.currentTitle sizeWithAttributes:@{NSFontAttributeName: kFont}];
    switch (self.flagStyle) {
        case MXSegmentMenuFlagStyleBackground:
            return size.width + 20;
            break;
        case MXSegmentMenuFlagStyleBottomLine:
            return size.width;
            break;
        case MXSegmentMenuFlagStyleBottomNone:
            return 0;
            break;
        case MXSegmentMenuFlagStyleBottomCustom:
            return 0;
            break;
        default:
            break;
    }
    return 0;
}

- (void)setFlagStyle:(MXSegmentMenuFlagStyle)flagStyle {
    _flagStyle = flagStyle;
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

//返回指定的Button
- (UIButton *)itemWithIndex:(NSInteger)index {
    return [self viewWithTag:kBaseItemTag + index];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self reLoadView];
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    if (selectIndex >= self.numberRows) {
        return;
    }
    if ([self.segmentDelegate respondsToSelector:@selector(segmentMenu:deSelectedIndex:)]) {
        [self.segmentDelegate segmentMenu:self deSelectedIndex:self.selectedView.tag - kBaseItemTag];
    }
    
    _selectIndex = selectIndex;
    self.selectedView.selected = NO;
    self.selectedView = (UIButton *)[self viewWithTag:selectIndex + kBaseItemTag];
    self.selectedView.selected = YES;
    [self moveFlagView];
    if ([self.segmentDelegate respondsToSelector:@selector(segmentMenu:didSelectedIndex:)]) {
        [self.segmentDelegate segmentMenu:self didSelectedIndex:self.selectedView.tag - kBaseItemTag];
    }
}

- (void)setTitleNormaColor:(UIColor *)titleNormaColor {
    _titleNormaColor = titleNormaColor;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:UIButton.class]) {
            [(UIButton *)view setTitleColor:titleNormaColor forState:UIControlStateNormal];
        }
    }
}

- (void)setTitleSelectedColor:(UIColor *)titleSelectedColor {
    _titleSelectedColor = titleSelectedColor;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:UIButton.class]) {
            [(UIButton *)view setTitleColor:titleSelectedColor forState:UIControlStateSelected];
        }
    }
}

- (void)setFlagColor:(UIColor *)flagColor {
    _flagColor = flagColor;
    self.flagView.backgroundColor = flagColor;
}

- (UIView *)flagView {
    if (!_flagView) {
        _flagView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 4, 0, 4)];
        _flagView.backgroundColor = self.flagColor;
        _flagView.layer.cornerRadius = 2.0;
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
    CGFloat normalW = self.frame.size.width/self.numberRows;
    CGFloat itemH = self.frame.size.height;
    CGFloat Y = 0;
    CGFloat X = 0;
    for (NSInteger i = 0; i < self.numberRows; i++) {
        CGFloat W = normalW;
        if ([self.segmentDelegate respondsToSelector:@selector(itemWidthWithSegmentMenu:itemForIndex:)]) {
            W = [self.segmentDelegate itemWidthWithSegmentMenu:self itemForIndex:i];
        }
        UIButton *item = [[UIButton alloc] initWithFrame:CGRectMake(X, Y, W, itemH)];
        item.titleLabel.font = kFont;
        [item addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *string = [self.segmentDelegate segmentMenu:self itemForIndex:i];
        [item setTitle:string forState:UIControlStateNormal];
        
        UIColor *normalColor = self.titleNormaColor;
        if ([self.segmentDelegate respondsToSelector:@selector(titleNormaColorWithSegmentMenu:itemForIndex:)]) {
            normalColor = [self.segmentDelegate titleNormaColorWithSegmentMenu:self itemForIndex:i];
        }
        UIColor *selectedColor = self.titleSelectedColor;
        if ([self.segmentDelegate respondsToSelector:@selector(titleSelectedColorWithSegmentMenu:itemForIndex:)]) {
            selectedColor = [self.segmentDelegate titleSelectedColorWithSegmentMenu:self itemForIndex:i];
        }
        [item setTitleColor:selectedColor forState:UIControlStateSelected];
        [item setTitleColor:normalColor forState:UIControlStateNormal];
        UIFont *font = self.titleNormaFont;
        if ([self.segmentDelegate respondsToSelector:@selector(titleNormaFontWithSegmentMenu:itemForIndex:)]) {
            font = [self.segmentDelegate titleNormaFontWithSegmentMenu:self itemForIndex:i];
        }
        item.titleLabel.font = font;
        
        [self addSubview:item];
        item.tag = i + kBaseItemTag;
        X = CGRectGetMaxX(item.frame);
    }
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

- (void)layoutSubviews {
//    [super layoutSubviews];
//    UIView *topView = nil;
//    for (NSInteger i = 0; i < self.numberRows; i ++) {
//        UIView *view = [self viewWithTag:i + kBaseItemTag];
//        if (view) {
//            topView.frame = CGRectMake(CGRectGetMaxX(topView.frame), view.frame.origin.x, view.frame.size.width, view.frame.size.height);
//            topView = view;
//        }
//    }
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
    groupAnimation.delegate = self;
    groupAnimation.duration = 0.25;
    [self.flagView.layer addAnimation:groupAnimation forKey:nil];
}

- (void)animationDidStart:(CAAnimation *)anim {
    NSLog(@"动画开始");
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSLog(@"动画结束");
}
@end
