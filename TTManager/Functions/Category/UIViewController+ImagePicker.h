//
//  UIViewController+ImagePicker.h
//  TTManager
//
//  Created by chao liu on 2021/1/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ImagePickerCompletionHandler)(NSData *imageData, UIImage *image);
@interface UIViewController (ImagePicker)

- (void)initializeImagePicker;

// 1 从附件中选择 2 新建文件夹 3,不显示新建文件夹
@property (nonatomic,assign) NSInteger actionSheetType;


- (void)pickImageWithCompletionHandler:(ImagePickerCompletionHandler)completionHandler;
- (void)pickImageWithpickImageCutImageWithImageSize:(CGSize)imageSize CompletionHandler:(ImagePickerCompletionHandler)completionHandler;
@end

NS_ASSUME_NONNULL_END
