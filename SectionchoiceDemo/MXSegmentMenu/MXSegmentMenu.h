//
//  MXSegmentMenu.h
//  SectionchoiceDemo
//
//  Created by muxue on 2019/1/4.
//  Copyright © 2019 暮雪. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * const MXSegmentMenuAttributeKey;
typedef NSDictionary<MXSegmentMenuAttributeKey, id>* MXSegmentMenuAttributes;
#define kBaseItemTag 100
/** 选中状态内容图片 */
UIKIT_EXTERN MXSegmentMenuAttributeKey MXSegmentMenuContentImage;
/** item宽度 */
UIKIT_EXTERN MXSegmentMenuAttributeKey MXSegmentMenuContentSize;
/** 文本内容 */
UIKIT_EXTERN MXSegmentMenuAttributeKey MXSegmentMenuContentString;

//选中标志风格
typedef NS_ENUM(NSUInteger, MXSegmentMenuFlagStyle) {
    MXSegmentMenuFlagStyleBackground,//作为背景 define
    MXSegmentMenuFlagStyleBottomLine,//底部选中标志
    MXSegmentMenuFlagStyleBottomNone,//无样式
    MXSegmentMenuFlagStyleBottomCustom,//自定义选中标识
};

//方向
typedef NS_ENUM(NSUInteger, MXSegmentMenuDirection) {
    MXSegmentMenuDirectionHorizontals,//水平
    MXSegmentMenuDirectionVertical//垂直
};

@protocol MXSegmentMenuDelegate;
/** 抽象类族的顶端 */
@interface MXSegmentMenu : UIScrollView
//选择菜单
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) UIButton *selectedView;
//代理对象
@property (nonatomic, weak) id <MXSegmentMenuDelegate> segmentDelegate;
//选中标识符样式
@property (nonatomic, assign) MXSegmentMenuFlagStyle flagStyle;
//菜单的方向
@property (nonatomic, assign, readonly) MXSegmentMenuDirection direction;
//选中标识符厚度 默认 4pt
@property (nonatomic, assign) CGFloat flagThickness;
//选中指示器
@property (nonatomic, strong) UIView *flagView;
//选中状态下背景颜色 默认 null
@property (nonatomic, strong) UIColor *selectedBackgroundColor;
//默认状态下背景颜色 默认 null
@property (nonatomic, strong) UIColor *normalBackgroundColor;
//选中状态下的标题颜色 默认黑色
@property (nonatomic, strong) UIColor *selectedTitleColor;
//默认状态下的标题颜色 默认黑色
@property (nonatomic, strong) UIColor *normalTitleColor;
//默认状态下字体 默认 17号字体
@property (nonatomic, strong) UIFont *normalFont;
//选中状态下字体 默认17号字体
@property (nonatomic, strong) UIFont *selectedFont;

+ (instancetype)segmentMenuWithFrame:(CGRect)frame direction:(MXSegmentMenuDirection)direction;
/** 刷新数据 */
- (void)reLoadView;
/** 返回指定的Button */
- (UIButton *)itemWithIndex:(NSInteger)index;
/** 集成给子类实现 */
- (void)createTitles;
@end

@protocol MXSegmentMenuDelegate <NSObject>
@required
/** 一共显示多少个 Item */
- (NSInteger)numberRowsWithsegmentMenu:(MXSegmentMenu *)segmentMenuView;
/** item 属性描述 */
- (MXSegmentMenuAttributes)itemAttrbuteWithSegmentMenu:(MXSegmentMenu *)segmentMenuView itemForIndex:(NSInteger)index;

@optional
/** 自定义FlagView，如果 flagStyle 选择了 MXSegmentMenuFlagStyleBottomCustom 代理必须实现这个方法，如果不实现则没有选中标识 */
- (UIView *)customFlagViewSegmentMenu:(MXSegmentMenu *)segmentMenuView;
/** 将要选择第 index 个 item */
- (BOOL)segmentMenu:(MXSegmentMenu *)segmentMenuView shouldSelectIndex:(NSInteger)index;
/** 已经选择第 index 个 item */
- (void)segmentMenu:(MXSegmentMenu *)segmentMenuView didSelectedIndex:(NSInteger)index;
/**  取消选择第 index 个 item */
- (void)segmentMenu:(MXSegmentMenu *)segmentMenuView deSelectedIndex:(NSInteger)index;
@end
NS_ASSUME_NONNULL_END
