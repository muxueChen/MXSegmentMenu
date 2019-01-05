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


@interface MXSegmentMenu () <CAAnimationDelegate>

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
//描述
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, MXSegmentMenuAttributes>*attrbutes;
@end

@implementation MXSegmentMenu

+ (void)initialize {
    if (self == [self class]) {
        
    }
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

- (NSMutableDictionary<NSNumber *, MXSegmentMenuAttributes>*)attrbutesb {
    if (!_attrbutes) {
        _attrbutes = [NSMutableDictionary dictionary];
    }
    return _attrbutes;
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
- (void)setDirection:(MXSegmentMenuDirection)direction {
    _direction = direction;
    [self reLoadView];
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
    if (self.direction == MXSegmentMenuDirectionHorizontals) {
        
    } else {
        
    }
    
}

//水平方向
- (void)createHorizontalsItmes {
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
        if (self.direction == MXSegmentMenuDirectionHorizontals) {
            X = CGRectGetMaxX(item.frame);
        } else {
            Y = CGRectGetMaxY(item.frame);
        }
    }
    if (self.direction == MXSegmentMenuDirectionHorizontals) {
        self.contentSize = CGSizeMake(X, 0);
    } else {
        self.contentSize = CGSizeMake(0, Y);
    }
    self.selectIndex = self.selectIndex;
}

//垂直方向
- (void)createVerticalItmes {
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
        if (self.direction == MXSegmentMenuDirectionHorizontals) {
            X = CGRectGetMaxX(item.frame);
        } else {
            Y = CGRectGetMaxY(item.frame);
        }
    }
    if (self.direction == MXSegmentMenuDirectionHorizontals) {
        self.contentSize = CGSizeMake(X, 0);
    } else {
        self.contentSize = CGSizeMake(0, Y);
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

//移动到 selectView 位置处
- (void)moveFlagView {
    if (!self.selectedView) {
        return;
    }
    if (self.direction == MXSegmentMenuDirectionHorizontals) {
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
}

- (void)animationDidStart:(CAAnimation *)anim {
    NSLog(@"动画开始");
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSLog(@"动画结束");
}
@end
