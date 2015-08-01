//
//  FatieViewController.m
//  IWatchII
//
//  Created by mac on 14-11-17.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "FatieViewController.h"
#import "ImageDownManager.h"
#import "JSON.h"
#import "ASIDownManager.h"

@interface FatieViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    UITextField *title;
    UITextView *textView;
    UIButton *imageBtn;
    UIImage * image;
    UILabel *tishi;
    
    UIActivityIndicatorView *mActView;
    
    BOOL isPick;
    UIView *bottomView;
    UIImageView *imageView;
}
@property (nonatomic, strong) ASIDownManager *mDownManager;

@end

@implementation FatieViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    isPick = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    UIButton *confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:confirmBtn];
    self.title = @"发帖";
    [self makeUI];

    // Do any additional setup after loading the view.
}
-(void)cancelClick
{
    
    if (textView.text.length != 0||title.text.length != 0) {
        [self Cancel];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你打算放弃发表，离开此页面吗？" delegate:self cancelButtonTitle:@"离开" otherButtonTitles:@"继续发表", nil];
        alert.tag = 1000001;
        [alert show];
    }
    else
    {
         self.mDownManager.delegate = nil;
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000001) {
        if (buttonIndex == 0) {
            if (self.navigationController) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                [self dismissViewControllerAnimated:YES completion:^{
                }];
            }
        }
    }else if (alertView.tag == 1000000)
    {
        if (buttonIndex == 1) {
            imageView.image = nil;
            isPick = NO;
        }
    }
    
}
-(void)confirmClick
{
    [self tap];
    NSLog(@"%@",self.bID);
    if (textView.text.length != 0) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *userID = [user objectForKey:@"userID"];
        if (!userID) {
            return;
        }
        [self StartLoading];
        ////www.iwatch365.com/json/iphone/json.php?t=104
        NSString *urlstr = [NSString stringWithFormat:@"%@json.php?t=104", SERVER_URL];
        NSLog(@"%@",urlstr);
        
        NSString *filePath = [NSString stringWithFormat:@"%@/Documents/",NSHomeDirectory()];
        filePath = [NSString stringWithFormat:@"%@%@.%@",filePath,@"image",@"jpg"];
        UIImage *tempImage = [UIImage imageWithContentsOfFile:filePath];
        float width = tempImage.size.width;
        NSDictionary *dic = [[NSDictionary alloc]init];
        dic = @{@"title":title.text,@"content":textView.text,@"uid": userID,@"type": @"1",@"device": @"0",@"fid": self.bID,@"picwidth":[NSString stringWithFormat:@"%f",width]};
        self.mDownManager = [[ASIDownManager alloc] init];
        _mDownManager.delegate = self;
        _mDownManager.OnImageDown = @selector(OnLoadFinish:);
        _mDownManager.OnImageFail = @selector(OnLoadFail:);

        if (isPick) {
            [_mDownManager PostHttpRequest:urlstr :dic :filePath :@"file"];
        }
        else
        {
            [_mDownManager PostHttpRequest:urlstr :dic :nil :nil];
        }
    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"发帖不能为空";
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.5];
    }
}
- (void)OnLoadFinish:(ASIDownManager *)sender {
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        if ([[dict[@"success"] stringValue]isEqualToString:@"1"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"fatietip" object:nil];
             self.mDownManager.delegate = nil;
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"发帖失败";
            hud.margin = 10.f;
            hud.yOffset = 150.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1.5];
        }
    }
    
}
- (void)OnLoadFail:(ASIDownManager *)sender {
    [self Cancel];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"回帖失败";
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];

}
- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}
-(void)makeUI
{
    
    
    title = [[UITextField alloc]initWithFrame:CGRectMake(5, 20, self.view.frame.size.width -10, 40)];
    title.placeholder = @"    请输入您要发表的标题(最多40字)";
    title.delegate = self;
//    title.layer.cornerRadius = 3;
//    title.clipsToBounds = YES;
    title.font = [UIFont systemFontOfSize:16];
    title.backgroundColor = [UIColor colorWithRed:230.0/256 green:230.0/256 blue:230.0/256 alpha:1];
    title.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:title];
    
    
    textView  = [[UITextView alloc]initWithFrame:CGRectMake(5, 65, self.view.frame.size.width - 10, 250)];
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    textView.returnKeyType = UIReturnKeyGo;
    textView.hidden = NO;
    textView.delegate = self;
//    textView.layer.cornerRadius = 3;
//    textView.clipsToBounds = YES;
    textView.backgroundColor = [UIColor colorWithRed:230.0/256 green:230.0/256 blue:230.0/256 alpha:1];
    textView.font = [UIFont systemFontOfSize:16];
    
    tishi = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 30)];
    tishi.text = @"  请输入您要发表的内容";
    tishi.font = [UIFont systemFontOfSize:16];
    tishi.backgroundColor = [UIColor clearColor];
    tishi.enabled = NO;
    tishi.textColor = [UIColor lightGrayColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [tishi addGestureRecognizer:tap];
    [textView addSubview:tishi];
    [self.view addGestureRecognizer:tap];
    
    [self.view addSubview:textView];
    
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 55, 260 , 50, 50)];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(removeImage:)]];
    [self.view addSubview:imageView];
    
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 104, self.view.frame.size.width, 40)];
    bottomView.backgroundColor = [UIColor colorWithRed:248.0/256 green:248.0/256 blue:248.0/256 alpha:1];
    [self.view addSubview:bottomView];
    
    UIButton *cameraBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 10, 25, 20)];
    [cameraBtn addTarget:self action:@selector(cameraClick:) forControlEvents:UIControlEventTouchUpInside];
    cameraBtn.tag = 100;
    [cameraBtn setBackgroundImage:[UIImage imageNamed:@"xiangji@2x.png"] forState:UIControlStateNormal];
    [bottomView addSubview:cameraBtn];
    UIButton *photoBtn = [[UIButton alloc]initWithFrame:CGRectMake(65, 10, 25, 20)];
    [photoBtn addTarget:self action:@selector(cameraClick:) forControlEvents:UIControlEventTouchUpInside];
    photoBtn.tag = 101;
    [photoBtn setBackgroundImage:[UIImage imageNamed:@"tupian@2x.png"] forState:UIControlStateNormal];
//    [photoBtn setBackgroundColor: [UIColor redColor]];
    [bottomView addSubview:photoBtn];
    
    UIButton *keyBoardBackBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 35, 10, 25, 20)];
    keyBoardBackBtn.tag = 102;
    [keyBoardBackBtn setBackgroundImage:[UIImage imageNamed:@"jianpian@2x.png"] forState:UIControlStateNormal];
    [keyBoardBackBtn addTarget:self action:@selector(cameraClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:keyBoardBackBtn];
    //观察键盘的弹出和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
-(void)removeImage:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你打算删除这张照片吗？" delegate:self cancelButtonTitle:@"不删除" otherButtonTitles:@"删除", nil];
        al.tag = 1000000;
        [al show];
        
    }
}
//键盘出现
-(void)keyboardShow:(NSNotification *)notification
{
    //计算键盘高度
    float height = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [UIView animateWithDuration:0.3 animations:^{
        bottomView.frame = CGRectMake(0, self.view.frame.size.height - height - 40, self.view.frame.size.width, 40);
    }];
    //设置位置偏移
    
}
//键盘消失
-(void)keyboardHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        bottomView.frame = CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40);
    }];
}

-(void)cameraClick:(UIButton *)sender
{
    
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;

    if (sender.tag == 100) {
        //如果选择是相机，需要判断相机是否可以开启
        if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
        {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"相机无法打开" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
    }
    [self presentViewController:picker animated:YES completion:nil];
    }
    else if(sender.tag == 101)
    {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else if(sender.tag == 102)
    {
        [textView resignFirstResponder];
        [title resignFirstResponder];
    }
}
-(void)textViewDidChange:(UITextView *)textView1
{
//    self.examineText =  textView.text;
    if (textView1.text.length == 0) {
        tishi.text = @"请输入您要发表的内容";
    }else{
        tishi.text = @"";
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //判断是谁触发
    if(textField == title)
    {
        [textView becomeFirstResponder];
    }
    return YES;
}
-(void)tap
{
    [textView resignFirstResponder];
    [title resignFirstResponder];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //获取照片
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //进行相应记录
    isPick = YES;

    int miWidth = 1024;
    int  miHeight = 1024;
    int iWidth = image.size.width;
    int iHeight = image.size.height;
    
    if (iWidth > iHeight) {
        if (iWidth>miWidth) {
            iWidth = miWidth;
            iHeight = image.size.height*iWidth/image.size.width;
//            if (iHeight>miHeight) {
//                iHeight = miHeight;
//                iWidth = image.size.width*iHeight/image.size.height;
//            }
        }
    }
    else
    {
        if (iHeight>miHeight) {
            iHeight = miHeight;
            iWidth = image.size.width*iHeight/image.size.height;
            
//            if (iWidth>miWidth) {
//                iWidth = miWidth;
//                iHeight = image.size.height*iWidth/image.size.width;
//            }
        }
    }
    
       image = [self scaleToSize:image :CGSizeMake(iWidth, iHeight)];

    
    NSData *data = nil;
    NSString *picType;
    if (UIImagePNGRepresentation(image)) {
        
        data = UIImageJPEGRepresentation(image, 0.9);
        picType = @"jpg";
    }else{
        data = UIImageJPEGRepresentation(image, 0.9);
        picType = @"jpg";
    }
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/",NSHomeDirectory()];
    filePath = [NSString stringWithFormat:@"%@%@.%@",filePath,@"image",picType];
    [data writeToFile:filePath atomically:YES];
    imageView.image = [UIImage imageWithContentsOfFile:filePath];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//图片缩放
- (UIImage *)scaleToSize:(UIImage *)image1 :(CGSize)newsize {
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(newsize);
    
    // 绘制改变大小的图片
    [image1 drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

-(void)imageFinish
{
//    [self dismissViewControllerAnimated:NO completion:nil];
    imageView.image = image;
}
//-(void)myThreadMainMethod
//{
//    NSData *data = nil;
//    NSString *picType;
//    if (UIImagePNGRepresentation(image)) {
//        
//        data = UIImageJPEGRepresentation(image, 0.00001);
//        picType = @"jpg";
//    }else{
//        data = UIImageJPEGRepresentation(image, 0.00001);
//        picType = @"jpg";
//    }
//    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/",NSHomeDirectory()];
//    filePath = [NSString stringWithFormat:@"%@%@.%@",filePath,@"image",picType];
//    [data writeToFile:filePath atomically:YES];
//
//}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
