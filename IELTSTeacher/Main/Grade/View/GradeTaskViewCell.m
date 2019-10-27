//
//  GradeTaskViewCell.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/6/27.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "GradeTaskViewCell.h"
#import "GradeTaskModel.h"

@interface GradeTaskViewCell()

@property (nonatomic,strong) UIImageView *typeImage;  //类型图片
@property (nonatomic,strong) UIImageView *finishImage;//完成图片
@property (nonatomic,strong) UILabel     *titleLbale; //标题
@property (nonatomic,strong) UIButton    *tipButton;  //提示按钮
@property (nonatomic,strong) UILabel     *lineCol;    //划线

@property (nonatomic,assign) BOOL isConstraintLine;

@end
@implementation GradeTaskViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self _initView];
    }
    return self;
}
/**
 *  初始化视图
 */
- (void)_initView
{
    [self.contentView addSubview:self.typeImage];
    [self.contentView addSubview:self.lineCol];
    [self.contentView addSubview:self.finishImage];
    [self.contentView addSubview:self.tipButton];
    [self.contentView addSubview:self.titleLbale];
}

#pragma mark -
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat height = self.frame.size.height;
    
    self.typeImage.frame = CGRectMake(20*AUTO_SIZE_SCALE_X , (height-25*AUTO_SIZE_SCALE_X)/2, 25*AUTO_SIZE_SCALE_X, 25*AUTO_SIZE_SCALE_X);
    self.finishImage.frame = CGRectMake(self.typeImage.frame.origin.x+self.typeImage.frame.size.width+10, (height-19*AUTO_SIZE_SCALE_X)/2, 19*AUTO_SIZE_SCALE_X, 19*AUTO_SIZE_SCALE_X);
    self.titleLbale.frame = CGRectMake(self.finishImage.frame.size.width+self.finishImage.frame.origin.x+20*AUTO_SIZE_SCALE_X, (height-20*AUTO_SIZE_SCALE_X)/2, 250*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X);
    self.tipButton.frame = CGRectMake(self.frame.size.width-60*AUTO_SIZE_SCALE_X,(height-40*AUTO_SIZE_SCALE_X)/2, 35*AUTO_SIZE_SCALE_X, 35*AUTO_SIZE_SCALE_X);
    
    /**
     *  线的判断
     */
    if (self.isFristRow && self.isLastRow) {
        self.lineCol.frame = CGRectZero;
    }else if (self.isFristRow) {
        self.lineCol.frame = CGRectMake(self.finishImage.frame.origin.x+self.finishImage.frame.size.width/2, self.frame.size.height/2+19*AUTO_SIZE_SCALE_Y/2, 0.5, self.frame.size.height);
    }else if (self.isLastRow)
    {
        self.lineCol.frame = CGRectMake(self.finishImage.frame.origin.x+self.finishImage.frame.size.width/2, 0, 0.5, self.frame.size.height/2-19*AUTO_SIZE_SCALE_Y/2);
    }else
    {
        self.lineCol.frame = CGRectMake(self.finishImage.frame.origin.x+self.finishImage.frame.size.width/2, 0, 0.5, self.frame.size.height);
    }
    
    if (self.dataDic.count > 0) {
        GradeTaskModel *taskModel = [self.dataDic objectForKey:@"data"];
        
        NSNumber *checkRemind =  taskModel.checkRemind;
        CHECK_DATA_IS_NSNULL(checkRemind, NSNumber);
        //0是未提醒， 1是已提醒
        if ([checkRemind isEqualToNumber:@0]) {
            self.tipButton.selected = NO;
        }else{
            self.tipButton.selected = YES;
        }
        
        CHECK_DATA_IS_NSNULL(taskModel.checkFinish, NSNumber);
        NSInteger checkFinish = [taskModel.checkFinish integerValue];
        if (checkFinish == 0) {   //是否完成 0=未完成；1=已完成;
            self.isFinishStyle = NO;
        }else if(checkFinish == 1){
            self.isFinishStyle = YES;
        }
        
        /**
         *  高亮判断
         */
        
        //标题
        CHECK_DATA_IS_NSNULL(taskModel.Name, NSString);
        CHECK_STRING_IS_NULL(taskModel.Name);
        self.titleLbale.text = taskModel.Name;
        
        NSString *isFrist = [self.dataDic objectForKey:@"isFrist"];
        NSString *type = [self.dataDic objectForKey:@"type"];
        
        //    TaskType = 任务类型 1:模考; 2:练习; 3:资料 4:测试资料;
        if (self.isFinishStyle) {
            //如果完成任务，查找是否有上次的推送时间,但是任务为完成状态。移除本地存储时间
            
            //提醒按钮
             self.tipButton.hidden = YES;
            
            self.finishImage.image = [UIImage imageNamed:@"dynamic_xuanzgibf.png"];
            if ([type isEqualToString:@"资料"]) {
                if ([isFrist isEqualToString:@"NO"]) {
                    self.typeImage.hidden = YES;
                }else if ([isFrist isEqualToString:@"YES"]){
                    self.typeImage.hidden = NO;
                    self.typeImage.image = [UIImage imageNamed:@"dynamic_ziliao.png"];
                }
            }else if ([type isEqualToString:@"练习"])
            {
                if ([isFrist isEqualToString:@"NO"]) {
                    self.typeImage.hidden = YES;
                }else if ([isFrist isEqualToString:@"YES"]){
                    self.typeImage.hidden = NO;
                    self.typeImage.image = [UIImage imageNamed:@"dynamic_shi_hong.png"];
                }
            }else if ([type isEqualToString:@"模考"])
            {
                if ([isFrist isEqualToString:@"NO"]) {
                    self.typeImage.hidden = YES;
                }else if ([isFrist isEqualToString:@"YES"]){
                    self.typeImage.hidden = NO;
                    self.typeImage.image = [UIImage imageNamed:@"dynamic_mokao_hong.png"];
                }
            }else if ([type isEqualToString:@"测试试卷"])
            {
                if ([isFrist isEqualToString:@"NO"]) {
                    self.typeImage.hidden = YES;
                }else if ([isFrist isEqualToString:@"YES"]){
                    self.typeImage.hidden = NO;
                    self.typeImage.image = [UIImage imageNamed:@"task_test.png"];
                }
            }
            
        }else    //未完成
        {
            //提醒按钮
            self.tipButton.hidden = NO;
            
            self.finishImage.image = [UIImage imageNamed:@"dynamic_huidian.png"];
            
            if ([type isEqualToString:@"资料"]) {
                if ([isFrist isEqualToString:@"NO"]) {
                    self.typeImage.hidden = YES;
                }else if ([isFrist isEqualToString:@"YES"]){
                    self.typeImage.hidden = NO;
                    self.typeImage.image = [UIImage imageNamed:@"dynamic_ziliao_hui.png"];
                }
            }else if ([type isEqualToString:@"练习"])
            {
                if ([isFrist isEqualToString:@"NO"]) {
                    self.typeImage.hidden = YES;
                }else if ([isFrist isEqualToString:@"YES"]){
                    self.typeImage.hidden = NO;
                    self.typeImage.image = [UIImage imageNamed:@"dynamic_shi.png"];
                }
            }else if ([type isEqualToString:@"模考"])
            {
                if ([isFrist isEqualToString:@"NO"]) {
                    self.typeImage.hidden = YES;
                }else if ([isFrist isEqualToString:@"YES"]){
                    self.typeImage.hidden = NO;
                    self.typeImage.image = [UIImage imageNamed:@"dynamic_mokao_hui.png"];
                }
            }else if ([type isEqualToString:@"测试试卷"])
            {
                if ([isFrist isEqualToString:@"NO"]) {
                    self.typeImage.hidden = YES;
                }else if ([isFrist isEqualToString:@"YES"]){
                    self.typeImage.hidden = NO;
                    self.typeImage.image = [UIImage imageNamed:@"task_test_gray.png"];
                }
            }

        }

    }
}

#pragma mark - event respon
- (void)tipButtonAction:(UIButton *)button
{
    NDLog(@"提醒");
    
    GradeTaskModel *taskModel = [self.dataDic objectForKey:@"data"];
    NSNumber *checkRemind =  taskModel.checkRemind;
    CHECK_DATA_IS_NSNULL(checkRemind, NSNumber);

    if ([checkRemind isEqualToNumber:@0]) {
        button.selected = !button.selected;
        
        [[Service sharedInstance]remindTaskWithClassCode:self.classCode
                                                 message:taskModel.Name
                                                  taskID:[taskModel.ST_ID stringValue]
                                             SuccessData:^(NSDictionary *result) {
                                                 if (k_IsSuccess(result)) {
                                                     
                                                     taskModel.checkRemind = @1;
                                                     
                                                     [self.viewController showHint:@"提醒成功!"];

                                                 }else
                                                 {
                                                      button.selected = !button.selected;
                                                     if (![[result objectForKey:@"Infomation"] isKindOfClass:[NSNull class]]) {
                                                         [self.viewController showHint:[result objectForKey:@"Infomation"]];
                                                     }
                                                 }
        } errorData:^(NSError *error) {
             button.selected = !button.selected;
             NSString *er = [error networkErrorInfo];
            [self.viewController showHint:er];
        }];

    }else{
//        self.tipButton.selected = NO;
        button.selected = YES;
        [self.viewController showHint:@"今天已经提醒过了!"];
    }
    
   
    
    
    
    
}

#pragma mark - set or get
- (UIImageView *)typeImage
{
    if (!_typeImage) {
        _typeImage = [CommentMethod createImageViewWithImageName:@""];
    }
    return _typeImage;
}

- (UIImageView *)finishImage
{
    if (!_finishImage) {
        _finishImage = [CommentMethod createImageViewWithImageName:@""];
    }
    return _finishImage;
}

- (UIButton *)tipButton
{
    if (!_tipButton) {
        _tipButton = [CommentMethod createButtonWithImageName:@"dynamic_task_tixing.png" Target:self Action:@selector(tipButtonAction:) Title:@""];
        [_tipButton setBackgroundImage:[UIImage imageNamed:@"dynamic_task_yixing.png"] forState:UIControlStateSelected];
    }
    return _tipButton;
}

- (UILabel *)titleLbale
{
    if (!_titleLbale) {
        _titleLbale = [[UILabel alloc]init];    
        _titleLbale.font = [UIFont systemFontOfSize:18.0f*AUTO_SIZE_SCALE_X];
        _titleLbale.textColor=[UIColor darkGrayColor];
    }
    return _titleLbale;
}


- (UILabel *)lineCol
{
    if (!_lineCol) {
        _lineCol = [CommentMethod createLabelWithFont:0 Text:@""];
        _lineCol.backgroundColor = RGBACOLOR(200, 200, 200, 0.5);
    }
    return _lineCol;
}




@end
