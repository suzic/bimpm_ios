//
//  UIViewController+ImagePicker.m
//  TTManager
//
//  Created by chao liu on 2021/1/7.
//

#import "UIViewController+ImagePicker.h"

#import <objc/runtime.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <MobileCoreServices/MobileCoreServices.h>

static void *kImagePickerCompletionHandlerKey = @"kImagePickerCompletionHandlerKey";
static void *kCameraPickerKey = @"kCameraPickerKey";
static void *kPhotoLibraryPickerKey = @"kPhotoLibraryPickerKey";
static void *kImageSizeKey = @"kimageSizeKey";
static void *isCut =  @"isCut"; //截取
static void *sheetType = @"actionSheetType";

@interface UIViewController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *cameraPicker;
@property (nonatomic, strong) UIImagePickerController *photoLibraryPicker;
@property (nonatomic, copy) ImagePickerCompletionHandler completionHandler;

@property (nonatomic, assign) BOOL isCutImageBool;
@property (nonatomic, assign) CGSize imageSize;

@end

@implementation UIViewController (ImagePicker)

- (void)initializeImagePicker{
    //先创建好 不然调用的时候 第一次创建很慢 有2秒的延迟
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        //判断相机可用
        [self setUpCameraPickControllerIsEdit:self.isCutImageBool];
    }
    [self setUpPhotoPickControllerIsEdit:self.isCutImageBool];
}

- (void)pickImageWithCompletionHandler:(ImagePickerCompletionHandler)completionHandler {
    self.completionHandler = completionHandler;
    [self presentChoseActionSheet];
}

- (void)pickImageWithpickImageCutImageWithImageSize:(CGSize)imageSize CompletionHandler:(ImagePickerCompletionHandler)completionHandler {
    self.completionHandler = completionHandler;
    self.isCutImageBool = YES;
    self.imageSize = imageSize;
    [self presentChoseActionSheet];
}
- (void)setUpCameraPickControllerIsEdit:(BOOL)isEdit {
    self.cameraPicker = [[UIImagePickerController alloc] init];
    self.cameraPicker.allowsEditing = isEdit; //拍照选去是否可以截取，和代理中的获取截取后的方法配合使用
    self.cameraPicker.delegate = self;
    self.cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    NSString *requiredMediaType = (NSString *)kUTTypeImage;
//    NSString *requiredMediaType1 = (NSString *)kUTTypeMovie;
    NSArray *arrMediaTypes=[NSArray arrayWithObjects:requiredMediaType,nil];
    [self.cameraPicker setMediaTypes:arrMediaTypes];
}
- (void)setUpPhotoPickControllerIsEdit:(BOOL)isEdit {
    self.photoLibraryPicker = [[UIImagePickerController alloc] init];
    self.photoLibraryPicker.allowsEditing = isEdit; // 相册选取是否截图
    self.photoLibraryPicker.delegate = self;
    //去掉毛玻璃效果 否则在ios11 下 全局设置了UIScrollViewContentInsetAdjustmentNever 导致导航栏遮住了内容视图
    self.photoLibraryPicker.navigationBar.translucent = NO;
    self.photoLibraryPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    NSString *requiredMediaType = (NSString *)kUTTypeImage;
//    NSString *requiredMediaType1 = (NSString *)kUTTypeMovie;
    NSArray *arrMediaTypes=[NSArray arrayWithObjects:requiredMediaType,nil];
    [self.photoLibraryPicker setMediaTypes:arrMediaTypes];
}
- (void)presentChoseActionSheet {
    
    UIAlertController * actionController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    UIAlertAction * takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:self.cameraPicker animated:YES completion:nil];
                    });
            }
            else {
                UIAlertController * noticeAlertController = [UIAlertController alertControllerWithTitle:@"未开启相机权限，请到设置界面开启" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
                
                UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"现在就去" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //跳转到设置界面
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
                    }];
                }];
                
                [noticeAlertController addAction:cancelAction];
                               [noticeAlertController addAction:okAction];
               dispatch_async(dispatch_get_main_queue(), ^{
                       [self presentViewController:noticeAlertController animated:YES completion:nil];
                   });
                               
            }
        }];
    }];
                   
    UIAlertAction * choseFromAlbumAction = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //判断相册权限
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusNotDetermined || status == PHAuthorizationStatusAuthorized) {
                //未知的   第一次访问
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:self.photoLibraryPicker animated:YES completion:nil];
                   });
                }else {
                    UIAlertController * noticeAlertController = [UIAlertController alertControllerWithTitle:@"未开启相册权限，请到设置界面开启" message:nil preferredStyle:UIAlertControllerStyleAlert];
                               UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
                               
                    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"现在就去" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        //跳转到设置界面
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {}];
                    }];
                               
                    [noticeAlertController addAction:cancelAction];
                    [noticeAlertController addAction:okAction];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self presentViewController:noticeAlertController animated:YES completion:nil];
                   });
                }
        }];
    }];
    [actionController addAction:cancelAction];
    [actionController addAction:takePhotoAction];
    [actionController addAction:choseFromAlbumAction];
    if (self.actionSheetType != 3) {
        UIAlertAction * fileAction = [UIAlertAction actionWithTitle: self.actionSheetType == 1 ? @"文件库":@"新建文件夹" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (self.actionSheetType == 1) {
                [self routerEventWithName:open_document_library userInfo:@{}];
            }else if(self.actionSheetType == 2){
                [self routerEventWithName:target_new_file_group userInfo:@{}];
            }
        }];
        [actionController addAction:fileAction];
    }
   
    [self presentViewController:actionController animated:YES completion:^{}];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    [picker dismissViewControllerAnimated:YES completion:nil];
    [picker dismissViewControllerAnimated:YES completion:^{
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
            UIImage *editedimage = [[UIImage alloc] init];
            if(self.isCutImageBool){
                 //获取裁剪的图
                editedimage = info[@"UIImagePickerControllerEditedImage"]; //获取裁剪的图
                CGSize imageSize = CGSizeMake(413, 626);
                if (self.imageSize.height>0) {
                    imageSize = self.imageSize;
                }
                editedimage = [self reSizeImage:editedimage toSize:imageSize];
            }
            else{
                editedimage = info[@"UIImagePickerControllerOriginalImage"];
            }
            NSData *imageData = UIImageJPEGRepresentation(editedimage, 0.0001);//首次进行压缩
            UIImage *image = [UIImage imageWithData:imageData];
            //图片限制大小不超过 1M     CGFloat  kb =   data.lenth / 1000;  计算kb方法 os 按照千进制计算
            while (imageData.length/1000 > 1024) {
                NSLog(@"图片超过1M 压缩");
                imageData = UIImageJPEGRepresentation(image, 0.5);
                image = [UIImage imageWithData:imageData];
            }
            self.completionHandler(imageData, image,mediaType);
        }
        // 录制视频
        else if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
            NSURL *url=[info objectForKey:UIImagePickerControllerMediaURL];//视频路径
            NSString *urlStr=[url path];
            if (picker == self.cameraPicker) {
                if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
                    //保存视频到相簿，注意也可以使用ALAssetsLibrary来保存
                    UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);//保存视频到相簿
                }
            }
            
            NSData *videoData = [NSData dataWithContentsOfFile:urlStr];
            self.completionHandler(videoData, nil,mediaType);
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
}

#pragma mark - setters & getters
- (void)setCompletionHandler:(ImagePickerCompletionHandler)completionHandler {
    objc_setAssociatedObject(self, kImagePickerCompletionHandlerKey, completionHandler, OBJC_ASSOCIATION_COPY);
}

- (ImagePickerCompletionHandler)completionHandler {
    return objc_getAssociatedObject(self, kImagePickerCompletionHandlerKey);
}

- (void)setCameraPicker:(UIImagePickerController *)cameraPicker {
    objc_setAssociatedObject(self, kCameraPickerKey, cameraPicker, OBJC_ASSOCIATION_RETAIN);
}

- (UIImagePickerController *)cameraPicker {
    return objc_getAssociatedObject(self, kCameraPickerKey);;
}

- (void)setPhotoLibraryPicker:(UIImagePickerController *)photoLibraryPicker {
    objc_setAssociatedObject(self, kPhotoLibraryPickerKey, photoLibraryPicker, OBJC_ASSOCIATION_RETAIN);
}

- (UIImagePickerController *)photoLibraryPicker {
    return objc_getAssociatedObject(self, kPhotoLibraryPickerKey);
}

- (void)setIsCutImageBool:(BOOL)isCutImageBool {
    return objc_setAssociatedObject(self, isCut, @(isCutImageBool), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isCutImageBool {
    return [objc_getAssociatedObject(self, isCut) boolValue];
}
- (void)setActionSheetType:(NSInteger)actionSheetType{
    return objc_setAssociatedObject(self, sheetType, @(actionSheetType), OBJC_ASSOCIATION_RETAIN);
}
- (NSInteger)actionSheetType{
    return [objc_getAssociatedObject(self, sheetType) integerValue];
}
- (void)setImageSize:(CGSize)imageSize {
    return objc_setAssociatedObject(self, kImageSizeKey, [NSValue valueWithCGSize:imageSize], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGSize)imageSize {
    NSValue * value = objc_getAssociatedObject(self, kImageSizeKey);
    return  value.CGSizeValue;
}
@end

