//
//  FileListView.h
//  TTManager
//
//  Created by chao liu on 2020/12/31.
//

#import <UIKit/UIKit.h>

@class DocumentLibController;

NS_ASSUME_NONNULL_BEGIN

@interface FileListView : UITableViewController

@property (nonatomic, weak) DocumentLibController *containerVC;

@end

NS_ASSUME_NONNULL_END
