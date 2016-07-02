//
//  HRDraggableCardContainer.m
//  jianshu
//
//  Created by Hiro on 16/5/24.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HRDraggableCardContainer.h"
static const CGFloat kPreloadViewCount = 3.0f;
static const CGFloat kSecondCard_Scale = 0.98f;
static const CGFloat kTherdCard_Scale = 0.96f;
static const CGFloat kCard_Margin = 7.0f;
static const CGFloat kDragCompleteCoefficient_width_default = 0.8f;
static const CGFloat kDragCompleteCoefficient_height_default = 0.6f;
typedef NS_ENUM(NSInteger, MoveSlope) {
    MoveSlopeTop = 1,
    MoveSlopeBottom = -1
};
@interface HRDraggableCardContainer()
@property (nonatomic, assign) MoveSlope moveSlope;
@property (nonatomic, assign) CGRect defaultFrame;
@property (nonatomic, assign) CGFloat cardCenterX;
@property (nonatomic, assign) CGFloat cardCenterY;
@property (nonatomic, assign) NSInteger loadedIndex;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSMutableArray *currentViews;
@property (nonatomic, assign) BOOL isInitialAnimation;


@end
@implementation HRDraggableCardContainer
- (id)init
{
    self = [super init];
    if (self) {
        [self setUp];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cardViewTap:)];
        [self addGestureRecognizer:tapGesture];
        
        _canDraggableDirection = HRDraggableDirectionLeft | HRDraggableDirectionLeft;
    }
    return self;
}

- (void)setUp
{
    _moveSlope = MoveSlopeTop;
    _loadedIndex = 0.0f;
    _currentIndex = 0.0f;
    _currentViews = [NSMutableArray array];
}

#pragma mark -- Public

-(void)reloadCardContainer
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [_currentViews removeAllObjects];
    _currentViews = [NSMutableArray array];
    [self setUp];
    [self loadNextView];
    _isInitialAnimation = NO;
    [self viewInitialAnimation];
}

- (void)movePositionWithDirection:(HRDraggableDirection)direction isAutomatic:(BOOL)isAutomatic undoHandler:(void (^)())undoHandler
{
    [self cardViewDirectionAnimation:direction isAutomatic:isAutomatic undoHandler:undoHandler];
}

- (void)movePositionWithDirection:(HRDraggableDirection)direction isAutomatic:(BOOL)isAutomatic
{
    [self cardViewDirectionAnimation:direction isAutomatic:isAutomatic undoHandler:nil];
}

- (UIView *)getCurrentView
{
    return [_currentViews firstObject];
}

#pragma mark -- Private

- (void)loadNextView
{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(cardContainerViewNumberOfViewInIndex:)]) {
        NSInteger index = [self.dataSource cardContainerViewNumberOfViewInIndex:_loadedIndex];
        
        // all cardViews Dragging end
        if (index != 0 && index == _currentIndex) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(cardContainerViewDidCompleteAll:)]) {
                [self.delegate cardContainerViewDidCompleteAll:self];
            }
            return;
        }
        
        // load next cardView
        if (_loadedIndex < index) {
            
            NSInteger preloadViewCont = index <= kPreloadViewCount ? index : kPreloadViewCount;
            
            for (NSInteger i = _currentViews.count; i < preloadViewCont; i++) {
                if (self.dataSource && [self.dataSource respondsToSelector:@selector(cardContainerViewNextViewWithIndex:)]) {
                    UIView *view = [self.dataSource cardContainerViewNextViewWithIndex:_loadedIndex];
                    if (view) {
                        _defaultFrame = view.frame;
                        _cardCenterX = view.center.x;
                        _cardCenterY = view.center.y;
                        
                        [self addSubview:view];
                        [self sendSubviewToBack:view];
                        [_currentViews addObject:view];
                        
                        if (i == 1 && _currentIndex != 0) {
                            view.frame = CGRectMake(_defaultFrame.origin.x, _defaultFrame.origin.y + kCard_Margin, _defaultFrame.size.width, _defaultFrame.size.height);
                            view.transform = CGAffineTransformScale(CGAffineTransformIdentity,kSecondCard_Scale,kSecondCard_Scale);
                        }
                        
                        if (i == 2 && _currentIndex != 0) {
                            view.frame = CGRectMake(_defaultFrame.origin.x, _defaultFrame.origin.y + (kCard_Margin * 2), _defaultFrame.size.width, _defaultFrame.size.height);
                            view.transform = CGAffineTransformScale(CGAffineTransformIdentity,kTherdCard_Scale,kTherdCard_Scale);
                        }
                        _loadedIndex++;
                    }
                    
                }
            }
        }
        
        UIView *view = [self getCurrentView];
        if (view) {
            UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
            [view addGestureRecognizer:gesture];
        }
    }
}
- (void)cardViewDirectionAnimation:(HRDraggableDirection)direction isAutomatic:(BOOL)isAutomatic undoHandler:(void (^)())undoHandler
{
    if (!_isInitialAnimation) { return; }
    UIView *view = [self getCurrentView];
    if (!view) { return; }
    
    __weak HRDraggableCardContainer *weakself = self;
    if (direction == HRDraggableDirectionDefault) {
        view.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:0.55
                              delay:0.0
             usingSpringWithDamping:0.6
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             view.frame = _defaultFrame;
                             
                             [weakself cardViewDefaultScale];
                         } completion:^(BOOL finished) {
                         }];
        
        return;
    }
    
    if (!undoHandler) {
        [_currentViews removeObject:view];
        _currentIndex++;
        [self loadNextView];
    }
    
    if (direction == HRDraggableDirectionRight || direction == HRDraggableDirectionLeft || direction == HRDraggableDirectionDown) {
        
        [UIView animateWithDuration:0.35
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             
                             if (direction == HRDraggableDirectionLeft) {
                                 view.center = CGPointMake(-1 * (weakself.frame.size.width), view.center.y);
                                 
                                 if (isAutomatic) {
                                     view.transform = CGAffineTransformMakeRotation(-1 * M_PI_4);
                                 }
                             }
                             
                             if (direction == HRDraggableDirectionRight) {
                                 view.center = CGPointMake((weakself.frame.size.width * 2), view.center.y);
                                 
                                 if (isAutomatic) {
                                     view.transform = CGAffineTransformMakeRotation(direction * M_PI_4);
                                 }
                             }
                             
                             if (direction == HRDraggableDirectionDown) {
                                 view.center = CGPointMake(view.center.x, (weakself.frame.size.height * 1.5));
                             }
                             
                             if (!undoHandler) {
                                 [weakself cardViewDefaultScale];
                             }
                         } completion:^(BOOL finished) {
                             if (!undoHandler) {
                                 [view removeFromSuperview];
                             } else  {
                                 if (undoHandler) { undoHandler(); }
                             }
                         }];
    }
    
    if (direction == HRDraggableDirectionUp) {
        [UIView animateWithDuration:0.15
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             
                             if (direction == HRDraggableDirectionUp) {
                                 if (isAutomatic) {
                                     view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.03,0.97);
                                     view.center = CGPointMake(view.center.x, view.center.y + kCard_Margin);
                                 }
                             }
                             
                         } completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.35
                                                   delay:0.0
                                                 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                                              animations:^{
                                                  view.center = CGPointMake(view.center.x, -1 * ((weakself.frame.size.height) / 2));
                                                  [weakself cardViewDefaultScale];
                                              } completion:^(BOOL finished) {
                                                  if (!undoHandler) {
                                                      [view removeFromSuperview];
                                                  } else  {
                                                      if (undoHandler) { undoHandler(); }
                                                  }
                                              }];
                         }];
    }
}

- (void)cardViewUpDateScale
{
    UIView *view = [self getCurrentView];
    
    float ratio_w = fabs((view.center.x - _cardCenterX) / _cardCenterX);
    float ratio_h = fabs((view.center.y - _cardCenterY) / _cardCenterY);
    float ratio = ratio_w > ratio_h ? ratio_w : ratio_h;
    
    if (_currentViews.count == 2) {
        if (ratio <= 1) {
            UIView *view = _currentViews[1];
            view.transform = CGAffineTransformIdentity;
            view.frame = CGRectMake(_defaultFrame.origin.x, _defaultFrame.origin.y + (kCard_Margin - (ratio * kCard_Margin)), _defaultFrame.size.width, _defaultFrame.size.height);
            view.transform = CGAffineTransformScale(CGAffineTransformIdentity,kSecondCard_Scale + (ratio * (1 - kSecondCard_Scale)),kSecondCard_Scale + (ratio * (1 - kSecondCard_Scale)));
        }
    }
    if (_currentViews.count == 3) {
        if (ratio <= 1) {
            {
                UIView *view = _currentViews[1];
                view.transform = CGAffineTransformIdentity;
                view.frame = CGRectMake(_defaultFrame.origin.x, _defaultFrame.origin.y + (kCard_Margin - (ratio * kCard_Margin)), _defaultFrame.size.width, _defaultFrame.size.height);
                view.transform = CGAffineTransformScale(CGAffineTransformIdentity,kSecondCard_Scale + (ratio * (1 - kSecondCard_Scale)),kSecondCard_Scale + (ratio * (1 - kSecondCard_Scale)));
            }
            {
                UIView *view = _currentViews[2];
                view.transform = CGAffineTransformIdentity;
                view.frame = CGRectMake(_defaultFrame.origin.x, _defaultFrame.origin.y + ((kCard_Margin * 2) - (ratio * kCard_Margin)), _defaultFrame.size.width, _defaultFrame.size.height);
                view.transform = CGAffineTransformScale(CGAffineTransformIdentity,kTherdCard_Scale + (ratio * (kSecondCard_Scale - kTherdCard_Scale)),kTherdCard_Scale + (ratio * (kSecondCard_Scale - kTherdCard_Scale)));
            }
        }
    }
}

- (void)cardViewDefaultScale
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cardContainderView:updatePositionWithDraggableView:draggableDirection:widthRatio:heightRatio:)]) {
        
        [self.delegate cardContainderView:self updatePositionWithDraggableView:[self getCurrentView]
                       draggableDirection:HRDraggableDirectionDefault
                               widthRatio:0 heightRatio:0];
    }
    
    for (int i = 0; i < _currentViews.count; i++) {
        UIView *view = _currentViews[i];
        if (i == 0) {
            view.transform = CGAffineTransformIdentity;
            view.frame = _defaultFrame;
        }
        if (i == 1) {
            view.transform = CGAffineTransformIdentity;
            view.frame = CGRectMake(_defaultFrame.origin.x, _defaultFrame.origin.y + kCard_Margin, _defaultFrame.size.width, _defaultFrame.size.height);
            view.transform = CGAffineTransformScale(CGAffineTransformIdentity,kSecondCard_Scale,kSecondCard_Scale);
        }
        if (i == 2) {
            view.transform = CGAffineTransformIdentity;
            view.frame = CGRectMake(_defaultFrame.origin.x, _defaultFrame.origin.y + (kCard_Margin * 2), _defaultFrame.size.width, _defaultFrame.size.height);
            view.transform = CGAffineTransformScale(CGAffineTransformIdentity,kTherdCard_Scale,kTherdCard_Scale);
        }
    }
}

- (void)viewInitialAnimation
{
    for (UIView *view in _currentViews) {
        view.alpha = 0.0;
    }
    
    UIView *view = [self getCurrentView];
    if (!view) { return; }
    __weak HRDraggableCardContainer *weakself = self;
    view.alpha = 1.0;
    view.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.5f,0.5f);
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.05f,1.05f);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.1
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              view.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.95f,0.95f);
                                          }
                                          completion:^(BOOL finished) {
                                              [UIView animateWithDuration:0.1
                                                                    delay:0.0
                                                                  options:UIViewAnimationOptionCurveEaseOut
                                                               animations:^{
                                                                   view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0f,1.0f);
                                                               }
                                                               completion:^(BOOL finished) {
                                                                   
                                                                   for (UIView *view in _currentViews) {
                                                                       view.alpha = 1.0;
                                                                   }
                                                                   
                                                                   [UIView animateWithDuration:0.25f
                                                                                         delay:0.01f
                                                                                       options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                                                                                    animations:^{
                                                                                        [weakself cardViewDefaultScale];
                                                                                    } completion:^(BOOL finished) {
                                                                                        weakself.isInitialAnimation = YES;
                                                                                    }];
                                                               }
                                               ];
                                          }
                          ];
                     }
     ];
}

#pragma mark -- Gesture Selector

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture
{
    if (!_isInitialAnimation) { return; }
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint touchPoint = [gesture locationInView:self];
        if (touchPoint.y <= _cardCenterY) {
            _moveSlope = MoveSlopeTop;
        } else {
            _moveSlope = MoveSlopeBottom;
        }
    }
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        
        CGPoint point = [gesture translationInView:self];
        CGPoint movedPoint = CGPointMake(gesture.view.center.x + point.x, gesture.view.center.y + point.y);
        gesture.view.center = movedPoint;
        
        [gesture.view setTransform:
         CGAffineTransformMakeRotation((gesture.view.center.x - _cardCenterX) / _cardCenterX * (_moveSlope * (M_PI / 20)))];
        
        [self cardViewUpDateScale];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(cardContainderView:updatePositionWithDraggableView:draggableDirection:widthRatio:heightRatio:)]) {
            if ([self getCurrentView]) {
                
                float ratio_w = (gesture.view.center.x - _cardCenterX) / _cardCenterX;
                float ratio_h = (gesture.view.center.y - _cardCenterY) / _cardCenterY;
                
                HRDraggableDirection direction = HRDraggableDirectionDefault;
                
                if (fabs(ratio_h) > fabs(ratio_w)) {
                    
                    if (ratio_h <= 0) {
                        // up
                        if (_canDraggableDirection & HRDraggableDirectionUp) {
                            direction = HRDraggableDirectionUp;
                        } else {
                            direction = ratio_w <= 0 ? HRDraggableDirectionLeft : HRDraggableDirectionRight;
                        }
                    } else {
                        // down
                        if (_canDraggableDirection & HRDraggableDirectionDown) {
                            direction = HRDraggableDirectionDown;
                        } else {
                            direction = ratio_w <= 0 ? HRDraggableDirectionLeft : HRDraggableDirectionRight;
                        }
                    }
                    
                } else {
                    if (ratio_w <= 0) {
                        // left
                        if (_canDraggableDirection & HRDraggableDirectionLeft) {
                            direction = HRDraggableDirectionLeft;
                        } else {
                            direction = ratio_h <= 0 ? HRDraggableDirectionUp : HRDraggableDirectionDown;
                        }
                    } else {
                        // right
                        if (_canDraggableDirection & HRDraggableDirectionRight) {
                            direction = HRDraggableDirectionRight;
                        } else {
                            direction = ratio_h <= 0 ? HRDraggableDirectionUp : HRDraggableDirectionDown;
                        }
                    }
                    
                }
                
                [self.delegate cardContainderView:self updatePositionWithDraggableView:gesture.view
                               draggableDirection:direction
                                       widthRatio:fabs(ratio_w) heightRatio:fabsf(ratio_h)];
            }
        }
        
        [gesture setTranslation:CGPointZero inView:self];
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded ||
        gesture.state == UIGestureRecognizerStateCancelled) {
        
        float ratio_w = (gesture.view.center.x - _cardCenterX) / _cardCenterX;
        float ratio_h = (gesture.view.center.y - _cardCenterY) / _cardCenterY;
        
        HRDraggableDirection direction = HRDraggableDirectionDefault;
        if (fabs(ratio_h) > fabs(ratio_w)) {
            if (ratio_h < - kDragCompleteCoefficient_height_default && (_canDraggableDirection & HRDraggableDirectionUp)) {
                // up
                direction = HRDraggableDirectionUp;
            }
            
            if (ratio_h > kDragCompleteCoefficient_height_default && (_canDraggableDirection & HRDraggableDirectionDown)) {
                // down
                direction = HRDraggableDirectionDown;
            }
            
        } else {
            
            if (ratio_w > kDragCompleteCoefficient_width_default && (_canDraggableDirection & HRDraggableDirectionRight)) {
                // right
                direction = HRDraggableDirectionRight;
            }
            
            if (ratio_w < - kDragCompleteCoefficient_width_default && (_canDraggableDirection & HRDraggableDirectionLeft)) {
                // left
                direction = HRDraggableDirectionLeft;
            }
        }
        
        if (direction == HRDraggableDirectionDefault) {
            [self cardViewDirectionAnimation:HRDraggableDirectionDefault isAutomatic:NO undoHandler:nil];
        } else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(cardContainerView:didEndDraggingAtIndex:draggableView:draggableDirection:)]) {
                [self.delegate cardContainerView:self didEndDraggingAtIndex:_currentIndex draggableView:gesture.view draggableDirection:direction];
            }
        }
    }
}

- (void)cardViewTap:(UITapGestureRecognizer *)gesture
{
    if (!_currentViews || _currentViews.count == 0) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(cardContainerView:didSelectAtIndex:draggableView:)]) {
        [self.delegate cardContainerView:self didSelectAtIndex:_currentIndex draggableView:gesture.view];
    }
}


@end
