//
//  GradeCheckModelCell.m
//  IELTSTeacher
//
//  Created by DevNiudun on 15/7/21.
//  Copyright (c) 2015年 xdf. All rights reserved.
//

#import "GradeCheckModelCell.h"

#define kUseBlockAPIToTrackPlayerStatus     1
@interface GradeCheckModelCell()<CustomSliderViewDelegate>

@property (nonatomic, strong) CustomSliderView *sliderView;
@property (nonatomic, strong) UILabel  *showTimes;

@property (nonatomic, assign) long indexNumber;
@property (nonatomic, assign) BOOL isFirst;

@property (nonatomic, copy) NSString *durationTimes;
@property (nonatomic, assign) CGFloat thisCountDuration;
@property (nonatomic, assign) BOOL isStops;


@end

@implementation GradeCheckModelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self _initView];
    }
    return self;
}

- (void)_initView
{
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView addSubview:self.sliderView];
    [self.contentView addSubview:self.playButton];
    [self.contentView addSubview:self.showTimes];
    
    WS(this_gradecheck);
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(47*AUTO_SIZE_SCALE_X, 47*AUTO_SIZE_SCALE_X));
        make.top.mas_equalTo((93-47)*AUTO_SIZE_SCALE_X/2);
        make.left.mas_equalTo(27*AUTO_SIZE_SCALE_X);
    }];
    
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(261*AUTO_SIZE_SCALE_X, 8*AUTO_SIZE_SCALE_X));
        make.left.mas_equalTo(this_gradecheck.playButton.mas_right).with.offset(24*AUTO_SIZE_SCALE_X);
        make.top.mas_equalTo((93-8)*AUTO_SIZE_SCALE_X/2);
    }];
    
    [self.showTimes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100*AUTO_SIZE_SCALE_X, 20*AUTO_SIZE_SCALE_X));
        make.right.mas_equalTo(this_gradecheck.sliderView.mas_right);
        make.top.mas_equalTo(this_gradecheck.sliderView.mas_bottom).with.offset(5*AUTO_SIZE_SCALE_X);
    }];
    self.showTimes.text = @"00:00/00:00";
    [self getMp3InfoWithAVURLAsset];
    
    //创建音频
    [self _creatStream];
    
}

-(void)getMp3InfoWithAVURLAsset
{
    NSURL *fileUrl = [NSURL URLWithString:self.urlString];
    AVURLAsset *mp3Asset = [AVURLAsset URLAssetWithURL:fileUrl options:nil];
    CMTime durationTime = mp3Asset.duration;
    CGFloat duration = CMTimeGetSeconds(durationTime);

    self.thisCountDuration = duration;
    if (self.thisCountDuration > 0) {
        _durationTimes =  [NSString stringWithFormat:@"%02d:%02d",(int)self.thisCountDuration /60,(int)self.thisCountDuration %60];
        self.showTimes.text = [NSString stringWithFormat:@"00:00/%@",_durationTimes];
    }
}

#pragma mark - <CustomSliderViewDelegate>
- (void)valueChange:(float)value
{
     [_audioPlayer seekToTime:self.thisCountDuration  * value];
}


- (void)_creatStream
{
    if (_audioPlayer) {
        [_audioPlayer dispose];
        if (!kUseBlockAPIToTrackPlayerStatus) {
            [_audioPlayer removeObserver:self forKeyPath:@"progress"];
            [_audioPlayer removeObserver:self forKeyPath:@"playerState"];
        }
        _audioPlayer = nil;
    }

    NSURL *url = [NSURL URLWithString:self.urlString];
    _audioPlayer = [CCAudioPlayer audioPlayerWithContentsOfURL:url];
    
    typeof(self) __weak weakSelf = self;
    [_audioPlayer trackPlayerProgress:^(NSTimeInterval progress) {
        GradeCheckModelCell *strongSelf = weakSelf;
        [strongSelf updateProgressView];
    } playerState:^(CCAudioPlayerState playerState) {
        GradeCheckModelCell *strongSelf = weakSelf;
        [strongSelf updateStatusViews];
    }];

}
#pragma mark - 更新进度、更新状态
//更新进度
- (void)updateProgressView
{
    [self.sliderView.volumeSlide setValue:_audioPlayer.progress / self.thisCountDuration  animated:YES];
    
    //当前时间
    int min = _audioPlayer.progress/60;
    int second = (int)_audioPlayer.progress % 60;
//    CHECK_STRING_IS_NULL(_durationTimes);
//    if ([_durationTimes isEqualToString:@""]) {
//        _durationTimes =  [NSString stringWithFormat:@"%02d:%02d",(int)self.thisCountDuration/60,(int)self.thisCountDuration%60];
//    }
    NSString *curentTimes = [NSString stringWithFormat:@"%02d:%02d",min,second];
    self.showTimes.text = [NSString stringWithFormat:@"%@/%@",curentTimes,_durationTimes];
//    //改变进度颜色
    self.sliderView.showImage.frame = CGRectMake(0, 0,261*AUTO_SIZE_SCALE_X * self.sliderView.volumeSlide.value, 8*AUTO_SIZE_SCALE_X);
    
}
//更新状态
- (void)updateStatusViews
{
    switch (_audioPlayer.playerState) {
        case CCAudioPlayerStatePlaying:
        {
//            self.playButton.selected = NO;

        }
            break;
        case CCAudioPlayerStateBuffering:
        {
//            _statusLabel.text = @"Buffering";
        }
            break;
            
        case CCAudioPlayerStatePaused:
        {
//            self.playButton.selected = YES;
//            [self.playButton setBackgroundImage:[UIImage imageNamed:@"checkList_kaishi.png"] forState:UIControlStateNormal];
        }
            break;
            
        case CCAudioPlayerStateStopped:
        {
            [_audioPlayer dispose];
            self.isStops = YES;
            [self.playButton setBackgroundImage:[UIImage imageNamed:@"checkList_stop.png"] forState:UIControlStateNormal];
             self.playButton.selected = NO;
        }
            break;
        default:
            break;
    }
}


#pragma mark--开始播放
- (void)playButtonAction:(UIButton *)button
{
    
    if ([_audioPlayer isPlaying]) {
        [_audioPlayer pause];
    }else
    {
        if (self.isStops) {
            [self _creatStream];
            [self.playButton setBackgroundImage:[UIImage imageNamed:@"checkList_zanting.png"] forState:UIControlStateNormal];
            [self.playButton setBackgroundImage:[UIImage imageNamed:@"checkList_kaishi.png"] forState:UIControlStateSelected];
            self.isStops = NO;
        }
        [_audioPlayer play];

    }
    //代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectPlay:curentCell:)]) {
        [self.delegate selectPlay:button curentCell:self];
    }
    
    button.selected = !button.selected;
}

#pragma mark - set or get
- (CustomSliderView *)sliderView
{
    if (!_sliderView) {
        _sliderView = [[CustomSliderView alloc]initWithFrame:CGRectMake(0, 0, 261*AUTO_SIZE_SCALE_X, 8*AUTO_SIZE_SCALE_X)];
        _sliderView.delegate = self;
    }
    return _sliderView;
}
- (UILabel *)showTimes
{
    if (!_showTimes) {
        _showTimes = [CommentMethod createLabelWithFont:16.0f Text:@""];
        _showTimes.textAlignment = NSTextAlignmentRight;
    }
    return _showTimes;
}
- (UIButton *)playButton
{
    if (!_playButton) {
        
        _playButton = [CommentMethod createButtonWithImageName:@"checkList_zanting.png" Target:self Action:@selector(playButtonAction:) Title:@""];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"checkList_kaishi.png"] forState:UIControlStateSelected];
    }
    return _playButton;
}
@end
