//
//  SectionchoiceView.m
//  SectionchoiceDemo
//
//  Created by muxue on 2019/1/3.
//  Copyright © 2019 暮雪. All rights reserved.
//

#import "SectionchoiceView.h"

#define kBaseItemTag 100
#define kFont [UIFont systemFontOfSize:16]

@interface SectionchoiceView () <CAAnimationDelegate>
@property (nonatomic, strong) NSArray <NSString *>*titleSources;
@property (nonatomic, strong) UIView *flagView;
@property (nonatomic, strong) UIButton *selectedView;
@end

@implementation SectionchoiceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _selectIndex = 0;
        [self addSubview:self.flagView];
    }
    return self;
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    if (selectIndex >= self.titleSources.count) {
        return;
    }
    _selectIndex = selectIndex;
    self.selectedView = (UIButton *)[self viewWithTag:selectIndex + kBaseItemTag];
    [self moveFlagView];
    [self.delegate sectionchoiceView:self didSelectedIndex:self.selectedView.tag - kBaseItemTag];
}

- (UIView *)flagView {
    if (!_flagView) {
        _flagView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 0, self.frame.size.height - 20)];
        _flagView.backgroundColor = UIColor.blackColor;
        _flagView.layer.cornerRadius = (self.frame.size.height - 20)/2.0;
    }
    return _flagView;
}

- (void)loadView {
    self.titleSources = [self.delegate dataSourceSectionchoiceView:self];
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
        [self addSubview:item];
        item.tag = i + kBaseItemTag;
        X = CGRectGetMaxX(item.frame);
    }
    self.selectIndex = self.selectIndex;
}

- (void)clicked:(UIButton *)btn {
    //是否选中
    if ([self.delegate respondsToSelector:@selector(sectionchoiceView:shouldSelectIndex:)]) {
        if (![self.delegate sectionchoiceView:self shouldSelectIndex:btn.tag - kBaseItemTag]) {
            return;
        }
    }
    self.selectIndex = btn.tag - kBaseItemTag;
}

//移动到 selectView 位置处
- (void)moveFlagView {
    CGSize size = [self.selectedView.currentTitle sizeWithAttributes:@{NSFontAttributeName: kFont}];
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.toValue = [NSValue valueWithCGPoint:self.selectedView.center];
    
    CABasicAnimation *frameAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.size.width"];
    frameAnimation.toValue = @(size.width + 20);
    
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
