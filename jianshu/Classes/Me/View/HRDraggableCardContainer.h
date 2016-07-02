//
//  HRDraggableCardContainer.h
//  jianshu
//
//  Created by Hiro on 16/5/24.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HRDraggableCardContainer;

typedef NS_OPTIONS(NSInteger, HRDraggableDirection) {
    HRDraggableDirectionDefault     = 0,
    HRDraggableDirectionLeft        = 1 << 0,
    HRDraggableDirectionRight       = 1 << 1,
    HRDraggableDirectionUp          = 1 << 2,
    HRDraggableDirectionDown        = 1 << 3
};
@protocol HRDraggableCardContainerDataSource <NSObject>

- (UIView *)cardContainerViewNextViewWithIndex:(NSInteger)index;
- (NSInteger)cardContainerViewNumberOfViewInIndex:(NSInteger)index;

@end
@protocol HRDraggableCardContainerDelegate <NSObject>

- (void)cardContainerView:(HRDraggableCardContainer *)cardContainerView
    didEndDraggingAtIndex:(NSInteger)index
            draggableView:(UIView *)draggableView
       draggableDirection:(HRDraggableDirection)draggableDirection;

@optional
- (void)cardContainerViewDidCompleteAll:(HRDraggableCardContainer *)container;

- (void)cardContainerView:(HRDraggableCardContainer *)cardContainerView
         didSelectAtIndex:(NSInteger)index
            draggableView:(UIView *)draggableView;

- (void)cardContainderView:(HRDraggableCardContainer *)cardContainderView updatePositionWithDraggableView:(UIView *)draggableView draggableDirection:(HRDraggableDirection)draggableDirection widthRatio:(CGFloat)widthRatio heightRatio:(CGFloat)heightRatio;

@end


@interface HRDraggableCardContainer : UIView
@property (nonatomic, assign) HRDraggableDirection canDraggableDirection;
@property (nonatomic, weak) id <HRDraggableCardContainerDataSource> dataSource;
@property (nonatomic, weak) id <HRDraggableCardContainerDelegate> delegate;
- (void)reloadCardContainer;

- (void)movePositionWithDirection:(HRDraggableDirection)direction isAutomatic:(BOOL)isAutomatic;
- (void)movePositionWithDirection:(HRDraggableDirection)direction isAutomatic:(BOOL)isAutomatic undoHandler:(void (^)())undoHandler;

- (UIView *)getCurrentView;

@end
