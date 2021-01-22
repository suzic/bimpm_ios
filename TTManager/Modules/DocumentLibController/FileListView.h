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
@property (nonatomic, copy) NSString *uid_target;
@property (nonatomic, assign)  id uid_parent;
@property (nonatomic, copy)  NSString *id_module;
@property (nonatomic, assign) BOOL chooseTargetFile;

- (void)reoladNetwork;

@end

NS_ASSUME_NONNULL_END
