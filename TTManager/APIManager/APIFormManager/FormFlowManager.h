//
//  FormFlowManager.h
//  TTManager
//
//  Created by chao liu on 2021/2/4.
//

#import <Foundation/Foundation.h>

/**
 1:下载当前表单文件form.json,之后调用detail，如果失败，则是快照，不可编辑,直接依据form.json显示app页面，步骤到此结束，否则继续下一步
 2:模版是固化的（instance_ident==nil），实例中的历史记录版本也是固化的（通过buddy_file=uid_target进行FormDetail拿不到数据的为历史记录版本）。固化的版本不需要判断是否可编辑（multi_editable是否大于0）
 3:判断是否可编辑，如果可编辑直接编辑当前表格，
 4:如果不可编辑，TargetClone，下载clone后的表单文件clone_form.json,
 5:FormOperations-FILL，更新form.json(或者clone_form.json)，使用FileUpload上传当前form.json(或者clone_form.json)
 5:最后上传成功之后 再调用TargetUpdate 告诉更新了哪个target（clone_target）。
 */


NS_ASSUME_NONNULL_BEGIN

@protocol FormFlowManagerDelgate <NSObject>

/// 刷新页面数据
- (void)reloadView;
/// 获取表单详情成功
- (void)formDetailResult:(BOOL)success;
/// 表单下载成功
- (void)formDownLoadResult:(BOOL)success;
/// 克隆表单成功
- (void)formCloneTargetResult:(BOOL)success;
/// 表单操作完成
- (void)formOperationsFillResult:(BOOL)success;
/// 表单更新完成
- (void)targetUpdateResult:(BOOL)success;

@end

@interface FormFlowManager : NSObject

@property (nonatomic, assign)id<FormFlowManagerDelgate>delegate;
/// ！！！初始化时的表单id 外部实际使用instanceBuddy_file
@property (nonatomic, strong) NSString *buddy_file;
/// 表单的id(克隆或原始) 提供给外部使用
@property (nonatomic, copy) NSString *instanceBuddy_file;
/// 克隆后的表单数据(克隆或原始,页面显示数据)
@property (nonatomic, strong) NSMutableDictionary *instanceDownLoadForm;
/// 表单详情获取到的数据(克隆或原始)
@property (nonatomic, strong) NSMutableDictionary *instanceFromDic;
/// 是否修改过表单数据
@property (nonatomic, assign) BOOL isModification;
/// 是否是编辑状态
@property (nonatomic, assign) BOOL isEditForm;
/// 是否是快照
@property (nonatomic, assign) BOOL isSnapshoot;
/// 当前表单是否可克隆
@property (nonatomic, assign) BOOL canCloneForm;
/// 是否是克隆
@property (nonatomic, assign) BOOL isCloneForm;
/// 当前下载的json是否可编辑
@property (nonatomic, assign) BOOL canEditForm;

/// 进入编辑模式
- (void)enterEditModel;
/// 退出编辑模式
- (void)exitEditorModel;

/// 下载表单
- (void)downLoadCurrentFormJsonByBuddy_file:(NSString *)buddy_file;
/// 克隆表单
- (void)cloneCurrentFormByBuddy_file;
/// 修改表单
- (void)operationsFormFill;

/// 修改表单内容(文本相关)
/// @param modifyData 当前修改的表单信息(包含indexPath 和需要修改的数据)
/// @params automatic 自动修改
- (void)modifyCurrentDownLoadForm:(NSDictionary *)modifyData automatic:(BOOL)automatic;
/// 添加图片到表单中
/// @param addDic 图片信息(包含indexPath 和需要修改的数据)
- (void)addImageToCurrentImageFormItem:(NSDictionary *)addDic;

/// 删除当前表单中的数据
/// @param deleteDic 删除的信息(包含indexPath和需要删除的图片的下标 和需要修改的数据)
- (void)deleteImageToCurrentImageFormItem:(NSDictionary *)deleteDic;

/// 保存当前表单内容
- (void)save;

@end

NS_ASSUME_NONNULL_END
