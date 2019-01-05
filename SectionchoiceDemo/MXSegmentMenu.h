//
//  MXSegmentMenu.h
//  SectionchoiceDemo
//
//  Created by muxue on 2019/1/4.
//  Copyright © 2019 暮雪. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//选中标志风格
typedef NS_ENUM(NSUInteger, MXSegmentMenuFlagStyle) {
    MXSegmentMenuFlagStyleBackground,//作为背景 define
    MXSegmentMenuFlagStyleBottomLine,//底部选中标志
    MXSegmentMenuFlagStyleBottomNone,//无样式
    MXSegmentMenuFlagStyleBottomCustom,//自定义选中标识
};
@protocol MXSegmentMenuDelegate;

@interface MXSegmentMenu : UIScrollView
//选择菜单
@property (nonatomic, assign) NSInteger selectIndex;
//代理对象
@property (nonatomic, weak) id <MXSegmentMenuDelegate> segmentDelegate;
//选中标识符样式
@property (nonatomic, assign) MXSegmentMenuFlagStyle flagStyle;
//选中标识符颜色
@property (nonatomic, strong) UIColor *flagColor;
//选中标识符高度
@property (nonatomic, assign) CGFloat flagHeight;

//标题颜色
@property (nonatomic, strong) UIColor *titleNormaColor;
@property (nonatomic, strong) UIColor *titleSelectedColor;

//标题字体
@property (nonatomic, strong) UIFont *titleNormaFont;
@property (nonatomic, strong) UIFont *titleSelectedFont;

//标题宽度
@property (nonatomic, assign) CGFloat itemW;

// 刷新数据
- (void)reLoadView;
// 返回指定的Button
- (UIButton *)itemWithIndex:(NSInteger)index;
@end

@protocol MXSegmentMenuDelegate <NSObject>
// 一共显示多少个 Item
- (NSInteger)numberRowsWithsegmentMenu:(MXSegmentMenu *)segmentMenuView;
// 对应item填充的文本内容
- (NSString *)segmentMenu:(MXSegmentMenu *)segmentMenuView itemForIndex:(NSInteger)index;
// 对应Index 的宽度
- (CGFloat)itemWidthWithSegmentMenu:(MXSegmentMenu *)segmentMenuView itemForIndex:(NSInteger)index;

// 自定义title默认颜色
- (UIColor *)titleNormaColorWithSegmentMenu:(MXSegmentMenu *)segmentMenuView itemForIndex:(NSInteger)index;
// 自定义title选中颜色
- (UIColor *)titleSelectedColorWithSegmentMenu:(MXSegmentMenu *)segmentMenuView itemForIndex:(NSInteger)index;

// 自定义默认状态下字体大小
- (UIFont *)titleSelectedFontWithSegmentMenu:(MXSegmentMenu *)segmentMenuView itemForIndex:(NSInteger)index;
// 自定义选中状态下字体大小
- (UIFont *)titleNormaFontWithSegmentMenu:(MXSegmentMenu *)segmentMenuView itemForIndex:(NSInteger)index;

// 自定义FlagView，如果 flagStyle 选择了 MXSegmentMenuFlagStyleBottomCustom 代理必须实现这个方法，如果不实现则没有选中标识
- (UIView *)customFlagViewSegmentMenu:(MXSegmentMenu *)segmentMenuView;

// 将要选择第 index 个 item
- (BOOL)segmentMenu:(MXSegmentMenu *)segmentMenuView shouldSelectIndex:(NSInteger)index;
// 已经选择第 index 个 item
- (void)segmentMenu:(MXSegmentMenu *)segmentMenuView didSelectedIndex:(NSInteger)index;
// 取消选择第 index 个 item
- (void)segmentMenu:(MXSegmentMenu *)segmentMenuView deSelectedIndex:(NSInteger)index;
@end
NS_ASSUME_NONNULL_END
