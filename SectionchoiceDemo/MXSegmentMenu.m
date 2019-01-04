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
@property (nonatomic, strong) NSArray <NSString *>*titleSources;
@property (nonatomic, strong) UIView *flagView;
@property (nonatomic, strong) UIButton *selectedView;
@property (nonatomic, readonly) CGFloat flagViewWidth;
@end

@implementation MXSegmentMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _flagColor = UIColor.blackColor;
        _titleSelectedColor = UIColor.whiteColor;
        _titleNormaColor = UIColor.whiteColor;
        _selectIndex = 0;
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
        default:
            break;
    }
    return size.width;
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
        default:
            break;
    }
    [self moveFlagView];
    [self setNeedsLayout];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self loadView];
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    if (selectIndex >= self.titleSources.count) {
        return;
    }
    _selectIndex = selectIndex;
    self.selectedView.selected = NO;
    self.selectedView = (UIButton *)[self viewWithTag:selectIndex + kBaseItemTag];
    self.selectedView.selected = YES;
    [self moveFlagView];
    [self.delegate segmentMenu:self didSelectedIndex:self.selectedView.tag - kBaseItemTag];
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

- (void)loadView {
    self.titleSources = [self.delegate dataSourceSegmentMenu:self];
    for (UIView *view in self.subviews) {
        if (![view isEqual:self.flagView]) {
            [view removeFromSuperview];
        }
    }
    if (self.titleSources.count <= 0) {
        self.hidden = YES;
        return;
    }
    self.hidden = NO;
    [self createTitles];
}

- (void)createTitles {
    CGFloat itemW = self.frame.size.width/self.titleSources.count;
    CGFloat itemH = self.frame.size.height;
    CGFloat Y = 0;
    CGFloat X = 0;
    for (NSInteger i = 0; i < self.titleSources.count; i++) {
        UIButton *item = [[UIButton alloc] initWithFrame:CGRectMake(X, Y, itemW, itemH)];
        item.titleLabel.font = kFont;
        [item addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
        [item setTitle:self.titleSources[i] forState:UIControlStateNormal];
        [item setTitleColor:self.titleSelectedColor forState:UIControlStateSelected];
        [item setTitleColor:self.titleNormaColor forState:UIControlStateNormal];
        [self addSubview:item];
        item.tag = i + kBaseItemTag;
        X = CGRectGetMaxX(item.frame);
    }
    self.selectIndex = self.selectIndex;
}

- (void)clicked:(UIButton *)btn {
    //是否选中
    if ([self.delegate respondsToSelector:@selector(segmentMenu:shouldSelectIndex:)]) {
        if (![self.delegate segmentMenu:self shouldSelectIndex:btn.tag - kBaseItemTag]) {
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
