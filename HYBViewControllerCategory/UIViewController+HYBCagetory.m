//
//  UIViewController+HYBCagetory.m
//  Demo
//
//  Created by huangyibiao on 15/9/6.
//  Copyright © 2015年 huangyibiao. All rights reserved.
//

#import "UIViewController+HYBCagetory.h"

#ifndef kIOSVersion
#define kIOSVersion ((float)[[[UIDevice currentDevice] systemVersion] doubleValue])
#endif

static UIColor *sg_navButtonTextColor;
static UIColor *sg_navButtonBackgroundColor;
static UIFont  *sg_navButtonFont;
static UIColor *sg_navButtonBorderColor;
static CGFloat sg_navButtonCornerRadius;

@implementation UIViewController (HYBCagetory)

+ (void)initialize {
  [super initialize];
  
  if (!sg_navButtonFont) {
    sg_navButtonFont = [UIFont systemFontOfSize:16];
  }
  
  if (!sg_navButtonBackgroundColor) {
    sg_navButtonBackgroundColor = [UIColor clearColor];
  }
  
  if (!sg_navButtonTextColor) {
    sg_navButtonTextColor = [UIColor blackColor];
  }
}

#pragma mark - 全局配置导航按钮样式
+ (void)hyb_navButtonStyleWithTextColor:(UIColor *)textColor
                        backgroundColor:(UIColor *)backgroundColor
                                   font:(UIFont *)font
                            borderColor:(UIColor *)borderColor
                           cornerRadius:(CGFloat)cornerRadius {
  sg_navButtonTextColor = textColor;
  sg_navButtonBackgroundColor = backgroundColor;
  sg_navButtonFont = font;
  sg_navButtonBorderColor = borderColor;
  sg_navButtonCornerRadius = cornerRadius;
}


#pragma mark - UINavigationBar全局配置
- (void)hyb_configNavBarWithBackImage:(id)backImage
                          shadowImage:(id)shadowImage
                            tintColor:(UIColor *)tintColor
                         barTintColor:(UIColor *)barTintColor
                           titleColor:(UIColor *)titleColor
                            titleFont:(UIFont *)titleFont
                        hideBackTitle:(BOOL)hideBackTitle {
  if ([self isKindOfClass:[UINavigationController class]]) {
    UINavigationController *navController = (UINavigationController *)self;
    UINavigationBar *navBar = navController.navigationBar;
    
    NSDictionary *textAttributes = nil;
    if (kIOSVersion >= 7.0) {
      if (barTintColor) {
        [navBar setTintColor:barTintColor];//返回按钮的箭头颜色
      }
      
      textAttributes = @{NSFontAttributeName: titleFont,
                         NSForegroundColorAttributeName: titleColor};
      if (tintColor) {
        [navBar setBarTintColor:barTintColor];
      }
      
      if (backImage) {
        UIImage *image = nil;
        if ([backImage isKindOfClass:[NSString class]]) {
          image = [UIImage imageNamed:backImage];
        } else {
          image = backImage;
        }
        
        UIImage *backButtonImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 30)];
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage
                                                          forState:UIControlStateNormal
                                                        barMetrics:UIBarMetricsDefault];
      }
      
      // 将返回按钮的文字position设置不在屏幕上显示
      if (hideBackTitle) {
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin)
                                                             forBarMetrics:UIBarMetricsDefault];
      }
      
      navController.interactivePopGestureRecognizer.enabled = YES;
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
      textAttributes = @{
                         UITextAttributeFont: titleFont,
                         UITextAttributeTextColor: titleColor,
                         UITextAttributeTextShadowColor: [UIColor clearColor],
                         UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                         };
      
      UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
      if (backImage) {
        UIImage *image = nil;
        if ([backImage isKindOfClass:[NSString class]]) {
          image = [UIImage imageNamed:backImage];
        } else {
          image = backImage;
        }
        
        UIImage *backButtonImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 30)];
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage
                                                          forState:UIControlStateNormal
                                                        barMetrics:UIBarMetricsDefault];
      }
      
      if (hideBackTitle) {
        [item setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
      }
      
      self.navigationItem.backBarButtonItem = item;
#endif
    }
    
    [navBar setTitleTextAttributes:textAttributes];
    if (shadowImage) {
      if ([shadowImage isKindOfClass:[NSString class]]) {
        navBar.shadowImage = [UIImage imageNamed:shadowImage];
      } else {
        navBar.shadowImage = shadowImage;
      }
    } else {
      navBar.shadowImage = [UIImage new];
    }
  }
}


#pragma mark - UITabBarItem
- (void)hyb_setTabBarItemWithTitle:(NSString *)title
                     selectedImage:(id)selectedImage
                   unSelectedImage:(id)unSelectedImage
                 selectedTextColor:(UIColor *)selectedTextColor
               unSelectedTextColor:(UIColor *)unSelectedTextColor {
  [self hyb_setTabBarItemWithTitle:title
                     selectedImage:selectedImage
                   unSelectedImage:unSelectedImage
                 selectedTextColor:selectedTextColor
               unSelectedTextColor:unSelectedTextColor
                      selectedFont:nil
                    unSelectedFont:nil];
}

- (void)hyb_setTabBarItemWithTitle:(NSString *)title
                     selectedImage:(id)selectedImage
                   unSelectedImage:(id)unSelectedImage
                 selectedTextColor:(UIColor *)selectedTextColor
               unSelectedTextColor:(UIColor *)unSelectedTextColor
                      selectedFont:(UIFont *)selectedFont
                    unSelectedFont:(UIFont *)unSelectedFont {
  UITabBarItem *item = [[UITabBarItem alloc] init];
  item.title = title;
  
  UIImage *normalImg = nil;
  if (unSelectedImage != nil) {
    if ([unSelectedImage isKindOfClass:[NSString class]]) {
      normalImg = [UIImage imageNamed:unSelectedImage];
    } else {
      normalImg = unSelectedImage;
    }
  }
  
  UIImage *selectedImg = nil;
  if (selectedImage != nil) {
    if ([selectedImage isKindOfClass:[NSString class]]) {
      selectedImg = [UIImage imageNamed:selectedImage];
    } else {
      selectedImg = selectedImage;
    }
  }
  
  if (kIOSVersion >= 7) {
    if (selectedImg) {
      item.selectedImage = [selectedImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    if (normalImg) {
      item.image = [normalImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    NSMutableDictionary *titleSelectedAttributes = [[NSMutableDictionary alloc] init];
    if (selectedTextColor) {
      [titleSelectedAttributes setObject:selectedTextColor forKey:NSForegroundColorAttributeName];
    }
    if (selectedFont) {
      [titleSelectedAttributes setObject:selectedFont forKey:NSFontAttributeName];
    }
    
    NSMutableDictionary *titleAttributes = [[NSMutableDictionary alloc] init];
    if (unSelectedTextColor) {
      [titleAttributes setObject:unSelectedTextColor forKey:NSForegroundColorAttributeName];
    }
    if (unSelectedFont) {
      [titleAttributes setObject:unSelectedFont forKey:NSFontAttributeName];
    }
    
    if (titleSelectedAttributes) {
      [item setTitleTextAttributes:titleSelectedAttributes forState:UIControlStateSelected];
    }
    
    if (titleAttributes) {
      [item setTitleTextAttributes:titleAttributes forState:UIControlStateNormal];
    }
  } else { // 6.0
    [item setFinishedSelectedImage:selectedImg
       withFinishedUnselectedImage:normalImg];
    
    NSMutableDictionary *titleSelectedAttributes = [[NSMutableDictionary alloc] init];
    if (selectedTextColor) {
      [titleSelectedAttributes setObject:selectedTextColor forKey:UITextAttributeTextColor];
    }
    if (selectedFont) {
      [titleSelectedAttributes setObject:selectedFont forKey:UITextAttributeFont];
    }
    
    NSMutableDictionary *titleAttributes = [[NSMutableDictionary alloc] init];
    if (unSelectedTextColor) {
      [titleAttributes setObject:unSelectedTextColor forKey:UITextAttributeTextColor];
    }
    if (unSelectedFont) {
      [titleAttributes setObject:unSelectedFont forKey:NSFontAttributeName];
    }
    
    if (titleSelectedAttributes) {
      [item setTitleTextAttributes:titleSelectedAttributes forState:UIControlStateSelected];
    }
    
    if (titleAttributes) {
      [item setTitleTextAttributes:titleAttributes forState:UIControlStateNormal];
    }
  }
  
  self.tabBarItem = item;
}

#pragma mark - UINavigationBar or UINavigationItem
- (void)hyb_navWithTitle:(id)title {
  [self hyb_navWithTitle:title rightImage:nil rightClicked:nil];
}

- (void)hyb_navWithTitle:(id)title rightTitle:(id)rightTitle rightClicked:(HYBButtonBlock)rightBlock {
  if (rightTitle) {
    [self hyb_navWithTitle:title rightTitles:@[rightTitle] rightClicked:^(NSUInteger atIndex, UIButton *sender) {
      if (rightBlock) {
        rightBlock(sender);
      }
    }];
  } else {
    [self hyb_navWithTitle:title rightTitles:nil rightClicked:nil];
  }
}

- (void)hyb_navWithTitle:(id)title rightTitles:(NSArray *)rightTitles rightClicked:(HYBButtonArrayBlock)rightBlock {
  [self hyb_navWithLeftImage:nil title:title rightTitles:rightTitles leftClicked:nil rightClicked:rightBlock];
}

- (void)hyb_navWithLeftImage:(id)leftImage
                       title:(id)title
                 rightTitles:(id)rightTitles
                 leftClicked:(HYBButtonBlock)leftClicked
                rightClicked:(HYBButtonArrayBlock)rightClicked {
  [self privateConfigTitleView:title];
  [self privateConfigLeftItem:leftImage isImage:YES leftBlock:leftClicked];
  [self privateConfigRightItems:rightTitles isImage:NO rightClicked:rightClicked];
}

- (void)hyb_navWithLeftTitle:(id)leftTitle
                       title:(id)title
                 rightTitles:(NSArray *)rightTitles
                 leftClicked:(HYBButtonBlock)leftClicked
                rightClicked:(HYBButtonArrayBlock)rightClicked {
  [self privateConfigTitleView:title];
  [self privateConfigLeftItem:leftTitle isImage:NO leftBlock:leftClicked];
  [self privateConfigRightItems:rightTitles isImage:NO rightClicked:rightClicked];
}


- (void)hyb_navWithLeftTitle:(id)leftTitle
                       title:(id)title
                 rightImages:(id)rightImages
                 leftClicked:(HYBButtonBlock)leftClicked
                rightClicked:(HYBButtonArrayBlock)rightClicked {
  [self privateConfigTitleView:title];
  [self privateConfigLeftItem:leftTitle isImage:NO leftBlock:leftClicked];
  [self privateConfigRightItems:rightImages isImage:YES rightClicked:rightClicked];
}

- (void)hyb_navWithLeftImage:(id)leftImage
                       title:(id)title
                 rightImages:(NSArray *)rightImages
                 leftClicked:(HYBButtonBlock)leftClicked
                rightClicked:(HYBButtonArrayBlock)rightClicked {
  [self privateConfigTitleView:title];
  [self privateConfigLeftItem:leftImage isImage:YES leftBlock:leftClicked];
  [self privateConfigRightItems:rightImages isImage:YES rightClicked:rightClicked];
}

- (void)hyb_navWithTitle:(id)title rightImage:(id)rightImage rightClicked:(HYBButtonBlock)rightBlock {
  if (rightImage) {
    [self hyb_navWithLeftTitle:nil title:title rightImages:@[rightImage] leftClicked:nil rightClicked:^(NSUInteger atIndex, UIButton *sender) {
      if (rightBlock) {
        rightBlock(sender);
      }
    }];
  } else {
    [self hyb_navWithLeftTitle:nil title:title rightTitles:nil leftClicked:nil rightClicked:nil];
  }
}

- (void)hyb_navWithTitle:(id)title rightImages:(NSArray *)rightImages rightClicked:(HYBButtonArrayBlock)rightBlock {
  [self hyb_navWithLeftTitle:nil title:title rightImages:rightImages leftClicked:nil rightClicked:rightBlock];
}

- (void)hyb_navWithLeftTitle:(id)leftTitle title:(id)title leftClicked:(HYBButtonBlock)leftClicked {
  [self hyb_navWithLeftTitle:leftTitle title:title rightTitle:nil leftClicked:leftClicked rightClicked:nil];
}

- (void)hyb_navWithLeftImage:(id)leftImage title:(id)title leftClicked:(HYBButtonBlock)leftClicked {
  [self hyb_navWithLeftImage:leftImage title:title rightTitles:nil leftClicked:leftClicked rightClicked:nil];
}

- (void)hyb_navWithLeftTitle:(id)leftTitle
                       title:(id)title
                  rightTitle:(id)rightTitle
                 leftClicked:(HYBButtonBlock)leftClicked
                rightClicked:(HYBButtonBlock)rightClicked {
  NSArray *rightTitles = nil;
  if (rightTitle) {
    rightTitles = @[rightTitle];
  }
  
  [self hyb_navWithLeftTitle:leftTitle title:title rightTitles:rightTitles leftClicked:leftClicked rightClicked:^(NSUInteger atIndex, UIButton *sender) {
    if (rightClicked) {
      rightClicked(sender);
    }
  }];
}

- (void)hyb_navWithLeftImage:(id)leftImage
                       title:(id)title
                  rightTitle:(id)rightTitle
                 leftClicked:(HYBButtonBlock)leftClicked
                rightClicked:(HYBButtonBlock)rightClicked {
  NSArray *rightTitles = nil;
  if (rightTitle) {
    rightTitles = @[rightTitle];
  }
  
  [self hyb_navWithLeftImage:leftImage title:title rightTitles:rightTitles leftClicked:leftClicked rightClicked:^(NSUInteger atIndex, UIButton *sender) {
    if (rightClicked) {
      rightClicked(sender);
    }
  }];
}

- (void)hyb_navWithLeftTitle:(id)leftTitle
                       title:(id)title
                  rightImage:(id)rightImage
                 leftClicked:(HYBButtonBlock)leftClicked
                rightClicked:(HYBButtonBlock)rightClicked {
  NSArray *rightImages = nil;
  if (rightImage) {
    rightImages = @[rightImage];
  }
  
  [self hyb_navWithLeftTitle:leftTitle title:title rightImages:rightImages leftClicked:leftClicked rightClicked:^(NSUInteger atIndex, UIButton *sender) {
    if (rightClicked) {
      rightClicked(sender);
    }
  }];
}

- (void)hyb_navWithLeftImage:(id)leftImage
                       title:(id)title
                  rightImage:(id)rightImage
                 leftClicked:(HYBButtonBlock)leftClicked
                rightClicked:(HYBButtonBlock)rightClicked {
  NSArray *rightImages = nil;
  if (rightImage) {
    rightImages = @[rightImage];
  }
  
  [self hyb_navWithLeftImage:leftImage title:title rightImages:rightImages leftClicked:leftClicked rightClicked:^(NSUInteger atIndex, UIButton *sender) {
    if (rightClicked) {
      rightClicked(sender);
    }
  }];
}

- (void)updateTitle:(id)title {
  [self privateConfigTitleView:title];
}

#pragma mark - Private
- (void)privateConfigTitleView:(id)title {
  if ([title isKindOfClass:[NSString class]]) {
    self.navigationItem.title = title;
  } else {
    self.navigationItem.titleView = title;
  }
}

- (void)privateConfigLeftItem:(id)leftItem isImage:(BOOL)isImage leftBlock:(HYBButtonBlock)leftBlock {
  if (leftItem == nil) {
    return;
  }
  
  UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
  
  if (isImage) {
    if ([leftItem isKindOfClass:[NSString class]]) {
      [btn setImage:[UIImage imageNamed:leftItem] forState:UIControlStateNormal];
    } else {
      [btn setImage:leftItem forState:UIControlStateNormal];
    }
  } else {
    [self privateConfigTitleButton:leftItem btn:btn];
  }
  
  btn.hyb_touchUp = leftBlock;
  
  [self privateSetNavItems:@[btn] isLeft:YES];
}

- (void)privateSetNavItems:(NSArray *)buttons isLeft:(BOOL)isLeft {
  UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                     target:nil
                                     action:nil];
  negativeSpacer.width = -8;
  if (kIOSVersion < 7) {
    negativeSpacer.width = 0;
  }
  
  NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:buttons.count];
  [items addObject:negativeSpacer];
  
  for (NSUInteger i = 0; i < buttons.count; ++i) {
    UIButton *btn = [buttons objectAtIndex:i];
    [btn sizeToFit];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [items addObject:item];
  }
  
  if (isLeft) {
    self.navigationItem.leftBarButtonItems = items;
  } else {
    self.navigationItem.rightBarButtonItems = items;
  }
}

- (void)privateConfigRightItems:(NSArray *)rightItems
                        isImage:(BOOL)isImage
                   rightClicked:(HYBButtonArrayBlock)rightClicked {
  if ([rightItems isKindOfClass:[NSArray class]] && rightItems.count >= 1) {
    NSUInteger i = 0;
    NSMutableArray *rightItemButotns = [[NSMutableArray alloc] init];
    for (id item in rightItems) {
      UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
      
      if (isImage) {
        if ([item isKindOfClass:[NSString class]]) {
          [btn setImage:[UIImage imageNamed:item] forState:UIControlStateNormal];
        } else {
          [btn setImage:item forState:UIControlStateNormal];
        }
      } else {
        [self privateConfigTitleButton:item btn:btn];
      }
      
      btn.hyb_touchUp = ^(UIButton *sender) {
        if (rightClicked) {
          rightClicked(i, sender);
        }
      };
      
      [rightItemButotns addObject:btn];
      i++;
    }
    
    [self privateSetNavItems:rightItemButotns isLeft:NO];
  }
}

- (void)privateConfigTitleButton:(id)buttonTitle btn:(UIButton *)btn {
  [btn setTitle:buttonTitle forState:UIControlStateNormal];
  [btn setTitleColor:sg_navButtonTextColor forState:UIControlStateNormal];
  [btn setBackgroundColor:sg_navButtonBackgroundColor];
  btn.titleLabel.font = sg_navButtonFont;
}

@end
