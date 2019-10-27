//
//  CustomSegmentedView.m
//  WangliBank
//
//  Created by Sidney on 14-4-24.
//  Copyright (c) 2014年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import "CustomSegmentedView.h"

#define k_lineBackColor RGBACOLOR(210, 210 , 210 , 1)
@interface CustomSegmentedView()
{
    
}
@property(nonatomic , strong) UIScrollView * backScrollView;

@property(nonatomic , copy) UIButton * lastSelectedBtn;
@property(nonatomic , strong) UIView * selectedBottomView;

@end

@implementation CustomSegmentedView
@synthesize mType,segmentsedDelegate;

- (id)initWithFrame:(CGRect)frame type:(SEGMENTED_TYPE)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.mType = type;
        switch (self.mType) {
            case SEGMENTED_TYPE_SYSTEM_DEFAULT:
            {
                [self.layer setBorderColor:RGBACOLOR(40,174,213,1).CGColor];
                [self.layer setBorderWidth:1];
                [self.layer setCornerRadius:5];
                [self.layer setMasksToBounds:YES];
                self.backgroundColor = RGBACOLOR(40,174,213,1);
            }
                break;
            case SEGMENTED_TYPE_NORMAL:
            {
                [self.layer setBorderColor:RGBACOLOR(205,205,205,1).CGColor];
                [self.layer setBorderWidth:0.5f];
                self.backgroundColor = RGBACOLOR(205,205,205,1);

            }
                break;
            case SEGMENTED_TYPE_NORMAL_MOCK_EXAM:
            {
                
                UIView * line  = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 0.5f, kScreenWidth, 0.5f)];
                line.backgroundColor = RGBACOLOR(177, 177, 177, 1);
                [self addSubview:line];
                
                self.selectedBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 3, kScreenWidth / 4, 3)];
                self.selectedBottomView.backgroundColor = RGBACOLOR(0, 0, 44, 1);
                
            }
                break;
            case SEGMENTED_TYPE_NORMAL_ESSENCE_LISTENS_LIST:
            {
                self.backScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
                self.backScrollView.showsHorizontalScrollIndicator = NO;
                [self addSubview:self.backScrollView];
                
                self.backgroundColor = [UIColor whiteColor];
                self.backScrollView.backgroundColor = [UIColor whiteColor];
                
                UIView * line  = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 0.5f, kScreenWidth, 0.5f)];
                line.backgroundColor = RGBACOLOR(170, 170, 170, 1);
                [self addSubview:line];
                
                self.selectedBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 3, kScreenWidth / 5, 3)];
                self.selectedBottomView.backgroundColor = k_PinkColor;

            }
                break;
            default:
                break;
        }
    }
    return self;
}

- (void)addSegmentedSelectedBlock:(void (^)(CustomSegmentedView *, NSInteger, NSInteger))block
{
    self.segmentedSelectedBlock = [block copy];
}

- (void)setSegmentedNames:(NSArray *)itemNames
{
    switch (self.mType) {
        case SEGMENTED_TYPE_SYSTEM_DEFAULT:
        {
            float width = CGRectGetWidth(self.frame) / [itemNames count] - 1;
            float height = CGRectGetHeight(self.frame) - 2;

            for (int i = 0; i < [itemNames count]; i ++) {
                
                
                NSString * str = [itemNames objectAtIndex:i];
                
                UIButton * menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                menuBtn.frame = CGRectMake((width + 1)* i + 1, 1 , width, height);
                menuBtn.tag = 1000 + i;
                
                [menuBtn addTarget:self action:@selector(menuBtnPressed:) forControlEvents:UIControlEventTouchDown];
                [menuBtn.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
                [menuBtn setTitle:str forState:UIControlStateNormal];
                
                if (i == 0) {
                    [menuBtn setBackgroundColor:RGBACOLOR(40,174,213,1)];
                    [menuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [self setLastSelectedBtn:menuBtn];
                }else{
                    [menuBtn setBackgroundColor:[UIColor whiteColor]];
                    [menuBtn setTitleColor:RGBACOLOR(40,174,213,1) forState:UIControlStateNormal];
                }
                
                [menuBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
                [self addSubview:menuBtn];
            }

        }
            break;
        case SEGMENTED_TYPE_NORMAL:
        {
            float width = CGRectGetWidth(self.frame) / [itemNames count] - 0.5f;
            float height = CGRectGetHeight(self.frame) - 1;

            for (int i = 0; i < [itemNames count]; i ++) {
                NSString * str = [itemNames objectAtIndex:i];
                
                UIButton * menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                menuBtn.frame = CGRectMake((width + 0.5f) * i + 0.5f, 0.5 , width, height);
                menuBtn.tag = 1000 + i;
                
                [menuBtn addTarget:self action:@selector(menuBtnPressed:) forControlEvents:UIControlEventTouchDown];
                [menuBtn.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
                [menuBtn setTitle:str forState:UIControlStateNormal];
                
                if (i == 0) {
                    [menuBtn setBackgroundColor:RGBACOLOR(113, 143, 169, 1)];
                    [menuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [self setLastSelectedBtn:menuBtn];
                }else{
                    [menuBtn setBackgroundColor:[UIColor whiteColor]];
                    [menuBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                }
                
                [menuBtn.titleLabel setFont:[UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X]];
                [self addSubview:menuBtn];
            }

        }
            break;
        case SEGMENTED_TYPE_NORMAL_MOCK_EXAM:
        {
            float width = CGRectGetWidth(self.frame) / [itemNames count] - 0.5f;
            float height = CGRectGetHeight(self.frame) - 1;
            
            for (int i = 0; i < [itemNames count]; i ++) {
                NSString * str = [itemNames objectAtIndex:i];
                
                UIButton * menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                menuBtn.frame = CGRectMake((width + 0.5f) * i + 0.5f, 0.5 , width, height);
                menuBtn.tag = 1000 + i;
                
                [menuBtn addTarget:self action:@selector(menuBtnPressed:) forControlEvents:UIControlEventTouchDown];
                [menuBtn.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
                [menuBtn setTitle:str forState:UIControlStateNormal];
                
                if (i == 0) {
                    [menuBtn setTitleColor:RGBACOLOR(0, 0, 44, 1) forState:UIControlStateNormal];
                    [self setLastSelectedBtn:menuBtn];
                    [self addSubview:self.selectedBottomView];
                }else{
                    [menuBtn setTitleColor:RGBACOLOR(177, 177, 177, 1) forState:UIControlStateNormal];
                }
                if (i != 0) {
                    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(width * i, 13, 1, 16)];
                    line.backgroundColor = RGBACOLOR(177, 177, 177, 1);
                    [self addSubview:line];
                }
                
                [menuBtn.titleLabel setFont:[UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X]];
                [self addSubview:menuBtn];
            }
            
        }
            break;
        case SEGMENTED_TYPE_NORMAL_ESSENCE_LISTENS_LIST:
        {
            float width = CGRectGetWidth(self.frame) / 5;
//            if ([itemNames count] < 5) {
//                width = CGRectGetWidth(self.frame) / [itemNames count];
//                CGRect frame = self.selectedBottomView.frame;
//                frame.size.width = width;
//                self.selectedBottomView.frame = frame;
//            }
            
            
            float height = CGRectGetHeight(self.frame) - 1;
            
            float lastWidth = 0;
            
            for (int i = 0; i < [itemNames count]; i ++) {
                NSString * str = [itemNames objectAtIndex:i];
                
                UIButton * menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                menuBtn.frame = CGRectMake((width) * i + 0.5f, 0.5 , width, height);
                menuBtn.tag = 1000 + i;
                
                [menuBtn addTarget:self action:@selector(menuBtnPressed:) forControlEvents:UIControlEventTouchDown];
                [menuBtn.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
                [menuBtn setTitle:str forState:UIControlStateNormal];
                
                if (i == 0) {
                    [menuBtn setTitleColor:k_PinkColor forState:UIControlStateNormal];
                    [self setLastSelectedBtn:menuBtn];
                    [self.backScrollView addSubview:self.selectedBottomView];
                }else{
                    [menuBtn setTitleColor:RGBACOLOR(0, 0, 44, 1) forState:UIControlStateNormal];
                }
//                if (i != 0) {
//                    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(width * i, 12, 1, 16)];
//                    line.backgroundColor = k_lineBackColor;
//                    [self.backScrollView addSubview:line];
//                }
                
                [menuBtn.titleLabel setFont:[UIFont systemFontOfSize:14*AUTO_SIZE_SCALE_X]];
                lastWidth = CGRectGetMaxX(menuBtn.frame);
                [self.backScrollView addSubview:menuBtn];
            }
            self.backScrollView.contentSize = CGSizeMake(lastWidth, CGRectGetHeight(self.backScrollView.frame));
        }
            break;
        default:
            break;
    }
    
}

- (void)setLastSelectedBtn:(UIButton *)btn
{
    if (_lastSelectedBtn) {
        _lastSelectedBtn = nil;
    }
    _lastSelectedBtn = btn;
}


- (void)setSelectedIndex:(NSInteger)index
{
    UIButton * sender = (UIButton *)[self viewWithTag:1000 + index];
    [self menuBtnPressed:sender];
}

- (void)menuBtnPressed:(UIButton *)sender
{
    
    NSInteger index = sender.tag - 1000;
    NSInteger lastIndex = _lastSelectedBtn.tag - 1000;
//    NSLog(@"%ld",index);
    
//    if (index == lastIndex) return;
    
    switch (self.mType) {
        case SEGMENTED_TYPE_SYSTEM_DEFAULT:
        {
            [_lastSelectedBtn setBackgroundColor:[UIColor whiteColor]];
            [_lastSelectedBtn setTitleColor:RGBACOLOR(40,174,213,1) forState:UIControlStateNormal];
            
            [sender setBackgroundColor:RGBACOLOR(40,174,213,1)];
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        }
            break;
        case SEGMENTED_TYPE_NORMAL:
        {
            [_lastSelectedBtn setBackgroundColor:[UIColor whiteColor]];
            [_lastSelectedBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            [sender setBackgroundColor:RGBACOLOR(113, 143, 169, 1)];
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        }
            break;
        case SEGMENTED_TYPE_NORMAL_MOCK_EXAM:
        {
            [_lastSelectedBtn setTitleColor:RGBACOLOR(177, 177, 177, 1) forState:UIControlStateNormal];
            
            [sender setTitleColor:RGBACOLOR(0, 0, 44, 1) forState:UIControlStateNormal];
            
            float originX = kScreenWidth / 4 * index;
            [UIView animateWithDuration:0.1f animations:^{
                CGRect frame = self.selectedBottomView.frame;
                frame.origin.x = originX;
                self.selectedBottomView.frame = frame;
            }];

        }
            break;
        case SEGMENTED_TYPE_NORMAL_ESSENCE_LISTENS_LIST:
        {
            [_lastSelectedBtn setTitleColor:RGBACOLOR(0, 0, 44, 1) forState:UIControlStateNormal];
            [sender setTitleColor:k_PinkColor forState:UIControlStateNormal];
            
            float width = CGRectGetWidth(_lastSelectedBtn.frame);
            
            float originX = width * index;
            [UIView animateWithDuration:0.1f animations:^{
                CGRect frame = self.selectedBottomView.frame;
                frame.origin.x = originX;
                self.selectedBottomView.frame = frame;
            }];
            
            float offsetX = (originX - kScreenWidth / 2 + width / 2);
            
            if (offsetX >= 0 && offsetX <= (self.backScrollView.contentSize.width - kScreenWidth)) {
               
                [self.backScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
            
            }
        
            
            
        }
            break;

        default:
            break;
    }
    
    

    [self setLastSelectedBtn:sender];
    
    if (self.segmentedSelectedBlock) {
        self.segmentedSelectedBlock(self,index,lastIndex);
    }

    
    if (segmentsedDelegate && [segmentsedDelegate respondsToSelector:@selector(segmentedSelectedIndex:lastSelectedIndex:menuView:)]) {
        [segmentsedDelegate segmentedSelectedIndex:index lastSelectedIndex:lastIndex menuView:self];
    }
    
}




/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
