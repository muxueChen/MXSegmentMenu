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

/** 默认状态下的标题字体 */
UIKIT_EXTERN MXSegmentMenuAttributeKey MXSegmentMenuAttributeTitleNormalFont;
/** 选中状态下的标题字体 */
UIKIT_EXTERN MXSegmentMenuAttributeKey MXSegmentMenuAttributeTitleSelectedFont;

/** 默认状态下标题颜色 */
UIKIT_EXTERN MXSegmentMenuAttributeKey MXSegmentMenuAttributeTitleNormalColor;
/** 选中状态下的标题颜色 */
UIKIT_EXTERN MXSegmentMenuAttributeKey MXSegmentMenuAttributeTitleSelectedColor;

/** 默认状态下标题颜色 */
UIKIT_EXTERN MXSegmentMenuAttributeKey MXSegmentMenuAttributeTitleNormalColor;
/** 选中状态下的标题颜色 */
UIKIT_EXTERN MXSegmentMenuAttributeKey MXSegmentMenuAttributeTitleSelectedColor;

/** 默认状态背景图片 */
UIKIT_EXTERN MXSegmentMenuAttributeKey MXSegmentMenuAttributeBackguroundNormalImage;
/** 选中状态背景图片 */
UIKIT_EXTERN MXSegmentMenuAttributeKey MXSegmentMenuAttributeBackguroundSelectedImage;

/** 默认状态内容图片 */
UIKIT_EXTERN MXSegmentMenuAttributeKey MXSegmentMenuAttributeNormalContentImage;
/** 选中状态内容图片 */
UIKIT_EXTERN MXSegmentMenuAttributeKey MXSegmentMenuAttributeSelectContentImage;

/** item宽度 */
UIKIT_EXTERN MXSegmentMenuAttributeKey MXSegmentMenuAttributeTitleWidth;

/** 文本内容 */
UIKIT_EXTERN MXSegmentMenuAttributeKey MXSegmentMenuAttributeTitleContentString;

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

@interface MXSegmentMenu : UIScrollView <CAAnimationDelegate>
//选择菜单
@property (nonatomic, assign) NSInteger selectIndex;
//代理对象
@property (nonatomic, weak) id <MXSegmentMenuDelegate> segmentDelegate;
//选中标识符样式
@property (nonatomic, assign) MXSegmentMenuFlagStyle flagStyle;
//菜单的方向
@property (nonatomic, assign) MXSegmentMenuDirection direction;
//选中标识符高度
@property (nonatomic, assign) CGFloat flagHeight;
//标题宽度
@property (nonatomic, assign) CGFloat itemW;

// 刷新数据
- (void)reLoadView;
// 返回指定的Button
- (UIButton *)itemWithIndex:(NSInteger)index;
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
