//
//  DataManager.m
//  classonline
//
//  Created by 苏智 on 2017/3/16.
//  Copyright © 2020年 Suzic. All rights reserved.
//

#import "DataManager.h"

static NSString *const CoreDataModelFileName = @"bimpm";

@interface DataManager ()

@end

@implementation DataManager

@synthesize persistentContainer = _persistentContainer;

#pragma mark - Core Data Saving support

// 单例模式下的默认实例的创建
+ (instancetype)defaultInstance
{
    static DataManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

// 初始化操作，注册进入后台操作监听
- (id)init
{
    if (self = [super init])
    {
        // 监听程序进入前后台
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillEnterbackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
    return self;
}

// 进入后台操作监听
- (void)applicationWillEnterbackground:(NSNotification *)notification
{
    [self saveContext];
}

// 当前用户的项目列表
- (NSMutableArray *)currentProjectList
{
    if (_currentProjectList == nil || _currentProjectList.count <= 0)
    {
        _currentProjectList = [NSMutableArray array];
        for (ZHUserProject *UP in self.currentUser.hasProjects)
            [_currentProjectList addObject:UP.belongProject];
        NSArray *resultArr = [_currentProjectList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            ZHProject *project1 = (ZHProject *)obj1;
            ZHProject *project2 = (ZHProject *)obj2;
            if (project1.id_project > project2.id_project) {
                return NSOrderedDescending;
            }else if (project1.id_project < project2.id_project){
                return NSOrderedAscending;
            }else{
                return NSOrderedSame;
            }
        }];
        _currentProjectList = [NSMutableArray arrayWithArray:resultArr];
    }
    return _currentProjectList;
}

// 当前用户限定
- (ZHUser *)currentUser
{
    if (_currentUser == nil)
    {
        _currentUser = [self getUserLogin];
        NSString *identifierStr = [SZUtil getUUID];
        NSLog(@"Current User has Device ID : %@", identifierStr);
        _currentUser.device = identifierStr;
    }
    return _currentUser;
}

// 获得一个用户（如果有已登录用户则优先取得它）
- (ZHUser *)getUserLogin
{
    ZHUser *userLogin = nil;
    NSString *currentLoginPhone = [LoginUserManager defaultInstance].currentLoginUserPhone;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"phone = %@", currentLoginPhone];
    NSArray *result = [self arrayFromCoreData:@"ZHUser" predicate:predicate limit:NSIntegerMax offset:0 orderBy:nil];
#warning 在调用currentUser时创建了一个临时用户（没有phone），当时在登录时又通过手机号查找当前用户，由于查找不到对应phone的user 又创建了一个新表，并且设置了phone，会存在两个user同时都没有登录的情况
    // 如果没有任何用户，创建一个临时用户作为当前用户
//    if (result == nil || result.count <= 0)
//    {
//        userLogin = (ZHUser *)[self insertIntoCoreData:@"ZHUser"];
//        userLogin.id_user = 0;
//        userLogin.phone = @"";      // @"18710223512"
//        userLogin.password = @"";   // @"123123"
//        userLogin.token = @"";
//        userLogin.device = @"";
//        userLogin.is_login = NO;
//    }
//    else
//    {
//        // 从所有用户列表中找出已经登录的一个
//        for (ZHUser *user in result)
//        {
//            if (user.is_login == YES)
//                userLogin = user;
//        }
//
//        // 没有登录用户，则默认返回第一个用户（必然是未登录者）
//        if (userLogin == nil)
//            userLogin = result[0];
//    }
    if (result != nil && result.count > 0) {
        userLogin = (ZHUser *)result[0];
    }
    return userLogin;
}
- (ZHProject *)currentProject{
    if (_currentProject == nil) {
        NSString *id_project = [LoginUserManager defaultInstance].currentSelectedProjectId;
        if (id_project == nil || [id_project isEqualToString:@""]) {
            
        }else{
            ZHProject *project = [self getProjectFromCoredataById:[id_project intValue]];
            _currentProject = project;
        }
    }
    return _currentProject;
}
// 网络请求缓存字典
- (NSMutableDictionary *)netwrokParamsCache
{
    if (_netwrokParamsCache == nil)
        _netwrokParamsCache = [NSMutableDictionary dictionary];
    return _netwrokParamsCache;
}

// 存储Core Data数据文件的目录
- (NSURL *)applicationDatabaseDirectory
{
    // 应用用于存储Core Data数据文件的目录。这段代码使用一个名为“com.offcn.classonline”的目录，它位于该应用沙盒的Library目录中。
    // 注意，由于该数据文件要保持和服务器一致，故属于缓存性质，缓存的数据放进library；如果是用户个人数据，则应放在Document目录中。
    return [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Core Data stack

- (NSPersistentContainer *)persistentContainer
{
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self)
    {
        if (_persistentContainer == nil)
        {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:CoreDataModelFileName];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error)
             {
                if (error != nil)
                {
                    // 如果有特殊的错误处理机制，请重写下面的代码.
                    //#warning abort() 会导致软件崩溃退出的同时生成错误日志. 如果你要发布该应用，应当避免使用该方法，它只是在开发阶段会很有用.

                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext
{
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error])
    {
        // 如果有特殊的错误处理机制，请重写下面的代码.
        //#warning abort() 会导致软件崩溃退出的同时生成错误日志. 如果你要发布该应用，应当避免使用该方法，它只是在开发阶段会很有用.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    else
    {
        NSLog(@"数据存储成功");
    }
}

#pragma mark - Core Data using implementation

/**
 *  @abstract 从数据库中取得数据
 */
- (NSArray *)arrayFromCoreData:(NSString *)entityName
                     predicate:(NSPredicate *)predicate
                         limit:(NSUInteger)limit
                        offset:(NSUInteger)offset
                       orderBy:(NSArray *)sortDescriptors
{
    NSManagedObjectContext *context = self.persistentContainer.viewContext;

    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    if (sortDescriptors != nil && sortDescriptors.count > 0)
        [request setSortDescriptors:sortDescriptors];
    if (predicate)
        [request setPredicate:predicate];
    
    [request setFetchLimit:limit];
    [request setFetchOffset:offset];
    
    NSError *error = nil;
    NSArray *fetchObjects = [context executeFetchRequest:request error:&error];
    
    if (error)
    {
        NSLog(@"fetch request error = %@", error);
        return nil;
    }
    
    return fetchObjects;
}

/**
 *  @abstract 向数据库中插入一条新建数据
 *
 */
- (NSManagedObject *)insertIntoCoreData:(NSString *)entityName
{
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSManagedObject *obj = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
    return obj;
}

/**
 *  @abstract 从数据库中删除一条数据
 */
- (void)deleteFromCoreData:(NSManagedObject *) obj
{
    if (obj != nil)
        [self.persistentContainer.viewContext deleteObject:obj];
}

/**
 *  @abstract 指定表名，清空该表
 */
- (void)cleanCoreDatabyEntityName:(NSString*)entityName
{
    NSArray *DBarray = [self arrayFromCoreData:entityName predicate:nil limit:NSIntegerMax offset:0 orderBy:nil];
    if (DBarray.count > 0)
    {
        for (NSManagedObject *obj in DBarray)
            [self deleteFromCoreData:obj];
    }
}

@end
