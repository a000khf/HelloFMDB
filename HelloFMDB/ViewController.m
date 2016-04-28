//
//  ViewController.m
//  HelloFMDB
//
//  Created by zhu on 16/4/29.
//  Copyright © 2016年 zhu. All rights reserved.
//

/*---------------------------------------------------------------
 = Blog about this article:http://www.jianshu.com/p/869ca5c7477e =
 ----------------------------------------------------------------*/

#import "ViewController.h"
#import "FMDB.h"
@interface ViewController ()
@property (strong,nonatomic)FMDatabase *db;
@property BOOL studentTable;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1要学会生成文件并进入数据库
    //2学会插入数据
    //3学会查询数据
    //4学会删除数据
    
    //1获取数据库文件路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *path = [documentDirectory stringByAppendingPathComponent:@"student.sqlite"];
    //获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    //创建表格
    if ([db open]) {
//        NSString *sqlStudentTable =  [NSString stringWithFormat:@"create table if not exists iOS_students (student_id integer PRIMARY KEY AUTOINCREMENT,name text NOT NULL,age integer NOT NULL )"];
//        BOOL studentTable = [db executeUpdate:sqlStudentTable];
        _studentTable = [db executeUpdate:[NSString stringWithFormat:@"create table if not exists iOS_students (student_id integer PRIMARY KEY AUTOINCREMENT,name text NOT NULL,age integer NOT NULL )"]];
        if (_studentTable) {
            NSLog(@"创建表格成功");
        }else{
            NSLog(@"不能创建表格");
        }
       
        [db close];
         self.db =db;
    }
    //插入数据
    
//    //插入方式1;
//    [_db open];
//    NSString *insertSpl1 = [NSString stringWithFormat:@"insert into iOS_students (name,age) values ('%@','%@');",@"林拾壹",@"16"];
//    BOOL spl1 = [_db executeUpdate:insertSpl1];
//    NSString *insertSpl2 = [NSString stringWithFormat:@"insert into iOS_students (name,age) values ('%@','%@');",@"雯猪猪",@"18"];
//    BOOL spl2 = [_db executeUpdate:insertSpl2];
//    
//    if (_studentTable) {
//          NSLog(@"创建人物属性成功");
//    }else{
//          NSLog(@"创建人物属性失败");
//    }
        [_db open];
//    //插入方式2;(含多样化)
    for (int i = 0; i<10; i++) {
         NSString *name = [NSString stringWithFormat:@"临时工-%d", arc4random_uniform(25)];
         // executeUpdate : 不确定的参数用?来占位(最好用对象,直接赋值有弹出黄色狂)
         [self.db executeUpdate:@"INSERT INTO iOS_students (name, age) VALUES (?, ?);", name, @(arc4random_uniform(15)+10)];
 
        // executeUpdateWithFormat : 不确定的参数用%@、%d等来占位
        //        [self.db executeUpdateWithFormat:@"INSERT INTO iOS_students (name, age) VALUES (%@, %d);", name, arc4random_uniform(40)];
    }
    

    // 执行查询语句
         FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM iOS_students"];
    //遍历
    while ([resultSet next]) {
        int numID = [resultSet intForColumn:@"student_id"];
        NSString *studentName = [resultSet stringForColumn:@"name"];
        int age = [resultSet intForColumn:@"age"];
        NSLog(@"编号=%d人名=%@年龄%d", numID, studentName, age);
    }
    //删除数据
    
    //删除列表内的数据
    //    [self.db executeUpdate:@"DELETE FROM iOS_students;"];
    //删除列表,删除后恢复表格. 等于重新加载
    //    [self.db executeUpdate:@"drop table if exists iOS_students"];
    //    [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS iOS_students (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL);"];//
    
    //删除制定属性数值
            [self.db executeUpdate:@"DELETE FROM iOS_students where student_id <4"];
    
}
    
    
@end
