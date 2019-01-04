//
//  MXSegmentMenu.h
//  SectionchoiceDemo
//
//  Created by muxue on 2019/1/4.
//  Copyright © 2019 暮雪. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, MXSegmentMenuFlagStyle) {
    MXSegmentMenuFlagStyleBackground,
    MXSegmentMenuFlagStyleBottomLine,
};
@protocol MXSegmentMenuDelegate;

@interface MXSegmentMenu : UIView
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, weak) id <MXSegmentMenuDelegate> delegate;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleNormaColor;
@property (nonatomic, strong) UIColor *titleSelectedColor;
@property (nonatomic, assign) MXSegmentMenuFlagStyle flagStyle;
@property (nonatomic, strong) UIColor *flagColor;

- (void)loadView;
@end

@protocol MXSegmentMenuDelegate <NSObject>
- (NSArray *)dataSourceSegmentMenu:(MXSegmentMenu *)sectionchoiceView;
- (BOOL)segmentMenu:(MXSegmentMenu *)sectionchoiceView shouldSelectIndex:(NSInteger)index;
- (void)segmentMenu:(MXSegmentMenu *)sectionchoiceView didSelectedIndex:(NSInteger)index;
@end
NS_ASSUME_NONNULL_END
