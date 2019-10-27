//
//  ChoiceViewController.m
//  IELTSTeacher
//
//  Created by 陈帅府 on 15/7/21.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "ChoiceViewController.h"
#import "ChooseTableViewCell.h"
#import "OptionListModel.h"
#import "AccListModel.h"
#import "StudentAchieveModel.h"
@interface ChoiceViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation ChoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = self.str;
    [self.view  addSubview:self.tableView];
    [self  addSub];
}
- (void)addSub{
    WS(this_choose);
    [self.tableView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(67+10);
        make.width.mas_equalTo(kScreenWidth);
        make.centerX.mas_equalTo(this_choose.view);
        make.bottom.mas_equalTo(this_choose.view);
    }];

}

#pragma mark--数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _optionModel.studentChooseList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChooseTableViewCell * cell = [ChooseTableViewCell cellWithChooseTabelView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.countdown.text = @"雅思考试倒计时: 32天";
    if ([self.titles  isEqual:@"选择答案A的学员"]) {
        cell.abCLabel.text = @"A";
        for (_stuModel in _optionModel.studentChooseList) {
            NSString *str = [NSString stringWithFormat:@"%ld",_stuModel.sName.length * 20];
            
            cell.nameW = [str floatValue];
            NDLog(@"%f",cell.nameW);
            cell.codeLabel.text = _stuModel.sCode;
            cell.nameLabel.text = _stuModel.sName;
            cell.countdown.text = [NSString stringWithFormat:@"雅思考试倒计时:%@天",_stuModel.TargetDateDiff];
            NSString *imgPath = [NSString stringWithFormat:@"%@/%@", BaseUserIconPath, _stuModel.IconUrl];
            [cell.imgView sd_setImageWithURL:[NSURL  URLWithString:imgPath] placeholderImage:[UIImage imageNamed:@"person_default"]];
            
            NSNumber *num1 = [NSNumber numberWithLong:1];
            NSNumber *num2 = [NSNumber numberWithLong:2];
            if (_stuModel.nGender == num1) {
                cell.sexView.image = [UIImage imageNamed:@"nan"];
                
            }else if (_stuModel.nGender == num2){
            
                cell.sexView.image = [UIImage imageNamed:@"nv"];
            }
            
        }
        
    }else if ([self.titles isEqual:@"选择答案B的学员"]){
    cell.abCLabel.text = @"B";
        for (_stuModel in _optionModel.studentChooseList) {
        cell.codeLabel.text = _stuModel.sCode;
        cell.nameLabel.text = _stuModel.sName;
        cell.countdown.text = [NSString stringWithFormat:@"雅思考试倒计时:%@天",_stuModel.TargetDateDiff];
        NSString *imgPath = [NSString stringWithFormat:@"%@/%@", BaseUserIconPath, _stuModel.IconUrl];
        [cell.imgView sd_setImageWithURL:[NSURL  URLWithString:imgPath] placeholderImage:[UIImage imageNamed:@"person_default"]];
            
            NSNumber *num1 = [NSNumber numberWithLong:1];
            NSNumber *num2 = [NSNumber numberWithLong:2];
            if (_stuModel.nGender == num1) {
                cell.sexView.image = [UIImage imageNamed:@"nan"];
                
            }else if (_stuModel.nGender == num2){
                
                cell.sexView.image = [UIImage imageNamed:@"nv"];
            }

        }
    }else if ([self.titles isEqual:@"选择答案C的学员"]){
        for (_stuModel in _optionModel.studentChooseList) {
        cell.abCLabel.text = @"C";
        cell.codeLabel.text = _stuModel.sCode;
        cell.nameLabel.text = _stuModel.sName;
        cell.countdown.text = [NSString stringWithFormat:@"雅思考试倒计时:%@天",_stuModel.TargetDateDiff];
        NSString *imgPath = [NSString stringWithFormat:@"%@/%@", BaseUserIconPath, _stuModel.IconUrl];
        [cell.imgView sd_setImageWithURL:[NSURL  URLWithString:imgPath] placeholderImage:[UIImage imageNamed:@"person_default"]];
            
            NSNumber *num1 = [NSNumber numberWithLong:1];
            NSNumber *num2 = [NSNumber numberWithLong:2];
            if (_stuModel.nGender == num1) {
                cell.sexView.image = [UIImage imageNamed:@"nan"];
                
            }else if (_stuModel.nGender == num2){
                
                cell.sexView.image = [UIImage imageNamed:@"nv"];
            }

        }
    }else if ([self.titles isEqual:@"选择答案D的学员"]){
        for (_stuModel in _optionModel.studentChooseList) {
        cell.abCLabel.text = @"D";
        cell.codeLabel.text = _stuModel.sCode;
        cell.nameLabel.text = _stuModel.sName;
        cell.countdown.text = [NSString stringWithFormat:@"雅思考试倒计时:%@天",_stuModel.TargetDateDiff];
        NSString *imgPath = [NSString stringWithFormat:@"%@/%@", BaseUserIconPath, _stuModel.IconUrl];
        [cell.imgView sd_setImageWithURL:[NSURL  URLWithString:imgPath] placeholderImage:[UIImage imageNamed:@"person_default"]];
            
            
            NSNumber *num1 = [NSNumber numberWithLong:1];
            NSNumber *num2 = [NSNumber numberWithLong:2];
            if (_stuModel.nGender == num1) {
                cell.sexView.image = [UIImage imageNamed:@"nan"];
                
            }else if (_stuModel.nGender == num2){
                
                cell.sexView.image = [UIImage imageNamed:@"nv"];
            }

        }
    }else if ([self.titles isEqual:@"选择答案TRUE的学员"]){
    cell.abCLabel.text = @"TRUE";
    }else if ([self.titles isEqual:@"选择答案FALSE的学员"]){
        cell.abCLabel.text = @"FALSE";
    }else if ([self.titles isEqual:@"选择答案NOT GIVEN的学员"]){
        cell.abCLabel.text = @"NOT GIVEN";
    }else if ([self.titles isEqual:@"答案 apple 的学员"]){
    cell.abCLabel.text = @"apple";
    }else if ([self.titles isEqual:@"答案 other 的学员"]){
        cell.abCLabel.text = @"other";
    }
    cell.answerLabel.text = @"答案";
    
    return cell;
}
#pragma mark--代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 95;
}



#pragma mark--get方法
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView  alloc]init];
        _tableView.backgroundColor = [UIColor  clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}
@end
