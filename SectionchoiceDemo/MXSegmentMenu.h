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
    MXSegmentMenuFlagStyleBottomLine,
    MXSegmentMenuFlagStyleBottomNone,
    MXSegmentMenuFlagStyleBottomCustom,
};
@protocol MXSegmentMenuDelegate;

@interface MXSegmentMenu : UIScrollView
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, weak) id <MXSegmentMenuDelegate> segmentDelegate;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleNormaColor;
@property (nonatomic, strong) UIColor *titleSelectedColor;
@property (nonatomic, assign) MXSegmentMenuFlagStyle flagStyle;
@property (nonatomic, strong) UIColor *flagColor;

- (void)loadView;
//返回指定的Button
- (UIButton *)itemWithIndex:(NSInteger)index;
@end

@protocol MXSegmentMenuDelegate <NSObject>
//一共显示多少个 Item
- (NSInteger)numberRowsWithsegmentMenu:(MXSegmentMenu *)segmentMenuView;
//对应item填充的
- (NSString *)segmentMenu:(MXSegmentMenu *)segmentMenuView itemForIndex:(NSInteger)index;
//自定义FlagView
//如果 flagStyle 选择了 MXSegmentMenuFlagStyleBottomCustom 代理必须实现这个方法，如果不实现则没有选中标识
- (UIView *)customFlagViewSegmentMenu:(MXSegmentMenu *)segmentMenuView;
// 将要选择第 index 个 item
- (BOOL)segmentMenu:(MXSegmentMenu *)segmentMenuView shouldSelectIndex:(NSInteger)index;
// 已经选择第 index 个 item
- (void)segmentMenu:(MXSegmentMenu *)segmentMenuView didSelectedIndex:(NSInteger)index;
// 取消选择第 index 个 item
- (void)segmentMenu:(MXSegmentMenu *)segmentMenuView deSelectedIndex:(NSInteger)index;
@end
NS_ASSUME_NONNULL_END
