//
//  SectionchoiceView.h
//  SectionchoiceDemo
//
//  Created by muxue on 2019/1/3.
//  Copyright © 2019 暮雪. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SectionchoiceFlagStyle) {
    SectionchoiceFlagStyleBackground,
    SectionchoiceFlagStyleBottomLine,
};

@protocol SectionchoiceViewDelegate;
NS_ASSUME_NONNULL_BEGIN
@interface SectionchoiceView : UIView
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, weak) id<SectionchoiceViewDelegate> delegate;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *normaColor;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, assign) SectionchoiceFlagStyle flagStyle;

- (void)loadView;
@end

@protocol SectionchoiceViewDelegate <NSObject>
- (NSArray *)dataSourceSectionchoiceView:(SectionchoiceView *)sectionchoiceView;
- (BOOL)sectionchoiceView:(SectionchoiceView *)sectionchoiceView shouldSelectIndex:(NSInteger)index;
- (void)sectionchoiceView:(SectionchoiceView *)sectionchoiceView didSelectedIndex:(NSInteger)index;
@end
NS_ASSUME_NONNULL_END
