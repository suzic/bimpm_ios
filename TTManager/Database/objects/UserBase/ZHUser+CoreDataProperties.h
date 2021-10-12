//
//  ZHUser+CoreDataProperties.h
//  TTManager
//
//  Created by chao liu on 2021/10/12.
//
//

#import "ZHUser+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ZHUser (CoreDataProperties)

+ (NSFetchRequest<ZHUser *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, copy) NSString *avatar;
@property (nullable, nonatomic, copy) NSString *captcha_code;
@property (nonatomic) int32_t current_project;
@property (nullable, nonatomic, copy) NSString *device;
@property (nullable, nonatomic, copy) NSString *email;
@property (nonatomic) int16_t gender;
@property (nonatomic) int32_t id_user;
@property (nonatomic) BOOL is_login;
@property (nullable, nonatomic, copy) NSString *lock_password;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *pass_md5;
@property (nullable, nonatomic, copy) NSString *password;
@property (nullable, nonatomic, copy) NSString *phone;
@property (nullable, nonatomic, copy) NSString *signature;
@property (nonatomic) int16_t status;
@property (nullable, nonatomic, copy) NSString *token;
@property (nullable, nonatomic, copy) NSString *uid_chat;
@property (nullable, nonatomic, copy) NSString *verify_code;
@property (nullable, nonatomic, copy) NSString *wechat_num;
@property (nullable, nonatomic, retain) NSSet<ZHFlow *> *asFlowCreator;
@property (nullable, nonatomic, retain) NSSet<ZHForm *> *asFormEditor;
@property (nullable, nonatomic, retain) NSSet<ZHMessage *> *asReceiver;
@property (nullable, nonatomic, retain) NSSet<ZHMessage *> *asSender;
@property (nullable, nonatomic, retain) NSSet<ZHTask *> *asTaskCurrent;
@property (nullable, nonatomic, retain) NSSet<ZHTask *> *asTaskEnder;
@property (nullable, nonatomic, retain) NSSet<ZHTask *> *asTaskStarter;
@property (nullable, nonatomic, retain) NSSet<ZHAllow *> *hasAllows;
@property (nullable, nonatomic, retain) NSSet<ZHUserProject *> *hasProjects;
@property (nullable, nonatomic, retain) NSSet<ZHStep *> *hasSteps;
@property (nullable, nonatomic, retain) NSSet<ZHTask *> *hasTasks;
@property (nullable, nonatomic, retain) NSSet<ZHTarget *> *ownTargets;
@property (nullable, nonatomic, retain) ZHProjectMemo *hasMemo;

@end

@interface ZHUser (CoreDataGeneratedAccessors)

- (void)addAsFlowCreatorObject:(ZHFlow *)value;
- (void)removeAsFlowCreatorObject:(ZHFlow *)value;
- (void)addAsFlowCreator:(NSSet<ZHFlow *> *)values;
- (void)removeAsFlowCreator:(NSSet<ZHFlow *> *)values;

- (void)addAsFormEditorObject:(ZHForm *)value;
- (void)removeAsFormEditorObject:(ZHForm *)value;
- (void)addAsFormEditor:(NSSet<ZHForm *> *)values;
- (void)removeAsFormEditor:(NSSet<ZHForm *> *)values;

- (void)addAsReceiverObject:(ZHMessage *)value;
- (void)removeAsReceiverObject:(ZHMessage *)value;
- (void)addAsReceiver:(NSSet<ZHMessage *> *)values;
- (void)removeAsReceiver:(NSSet<ZHMessage *> *)values;

- (void)addAsSenderObject:(ZHMessage *)value;
- (void)removeAsSenderObject:(ZHMessage *)value;
- (void)addAsSender:(NSSet<ZHMessage *> *)values;
- (void)removeAsSender:(NSSet<ZHMessage *> *)values;

- (void)addAsTaskCurrentObject:(ZHTask *)value;
- (void)removeAsTaskCurrentObject:(ZHTask *)value;
- (void)addAsTaskCurrent:(NSSet<ZHTask *> *)values;
- (void)removeAsTaskCurrent:(NSSet<ZHTask *> *)values;

- (void)addAsTaskEnderObject:(ZHTask *)value;
- (void)removeAsTaskEnderObject:(ZHTask *)value;
- (void)addAsTaskEnder:(NSSet<ZHTask *> *)values;
- (void)removeAsTaskEnder:(NSSet<ZHTask *> *)values;

- (void)addAsTaskStarterObject:(ZHTask *)value;
- (void)removeAsTaskStarterObject:(ZHTask *)value;
- (void)addAsTaskStarter:(NSSet<ZHTask *> *)values;
- (void)removeAsTaskStarter:(NSSet<ZHTask *> *)values;

- (void)addHasAllowsObject:(ZHAllow *)value;
- (void)removeHasAllowsObject:(ZHAllow *)value;
- (void)addHasAllows:(NSSet<ZHAllow *> *)values;
- (void)removeHasAllows:(NSSet<ZHAllow *> *)values;

- (void)addHasProjectsObject:(ZHUserProject *)value;
- (void)removeHasProjectsObject:(ZHUserProject *)value;
- (void)addHasProjects:(NSSet<ZHUserProject *> *)values;
- (void)removeHasProjects:(NSSet<ZHUserProject *> *)values;

- (void)addHasStepsObject:(ZHStep *)value;
- (void)removeHasStepsObject:(ZHStep *)value;
- (void)addHasSteps:(NSSet<ZHStep *> *)values;
- (void)removeHasSteps:(NSSet<ZHStep *> *)values;

- (void)addHasTasksObject:(ZHTask *)value;
- (void)removeHasTasksObject:(ZHTask *)value;
- (void)addHasTasks:(NSSet<ZHTask *> *)values;
- (void)removeHasTasks:(NSSet<ZHTask *> *)values;

- (void)addOwnTargetsObject:(ZHTarget *)value;
- (void)removeOwnTargetsObject:(ZHTarget *)value;
- (void)addOwnTargets:(NSSet<ZHTarget *> *)values;
- (void)removeOwnTargets:(NSSet<ZHTarget *> *)values;

@end

NS_ASSUME_NONNULL_END
