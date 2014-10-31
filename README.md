DAO-iOS
=======

Data access object (DAO) abstracts all data persistence, cache and access for application layer. Data is cached in heap and persisted in disk and optionally in cloud.

MingDAO - handles data in the heap cache and interfaces with application layer. Unless your application is very simple and one DAO is good enough, you normally need to create multiple DAO classes (as singleton) which must subclass from MingDAO.

MingStore (MingStoreWithxxx) - handles data in the local disk, currently supports saving data in preference, property list, file and SQL lite. You can provide other means for disk storage, but they all need to conform to MingStore protocol.

MingCloud (MingCloudWithxxx) - handles data in backend cloud, currently supports Parse. It can be easily extended to support other backend cloud.

INSTALLATION
-------------
DAO is not provided as a static library. To install, just add all these .h/m files into your project, and also add the dependent libraries specified below.

DEPENDENT LIBRARIES
-------------------
FMDB: https://github.com/ccgus/fmdb

TMCACHE: https://github.com/tumblr/TMCache

PARSE: https://parse.com/

USAGE
-----
//declare a DAO class

@interface My1DAO : MingDAO

@end


//create cloud object

id<MingCloud> cloud = [[MingCloudWithParse alloc] init];


//create store object

id<MingStore> store = [[MingStoreWithPropertyList alloc] initWithName:@"myfile.plist" andCloud:cloud];


//create DAO object, it's better to make it singleton

My1DAO *dao = [[My1DAO alloc] initWithStore:store];


//save object (blocking call)

NSDictionary *obj = ......

[dao setObject:obj ByKey:@"myKey"];


//retrieve object (blocking call)

id object = [dao getObjectByKey:@"myKey"];


//remove object (blocking call)
[dao removeObjectByKey:@"myKey"];
