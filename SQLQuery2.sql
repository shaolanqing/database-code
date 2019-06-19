--readers表（列名，描述，数据类型，允许空值，说明）
use TSGL
go
create table rdd
( readerid char(10) not null  --readerid字段，非空约束
  constraint pk_readerid primary key  --主键约束
  --constraint ck_readerid  
  --check(readerid like '20172018[0-9][0-9]'),   --检查约束
  name char(8)  null,   --name字段，可空约束
  typeid int  null
  constraint fk_typeid foreign key references ree(typeid),  --外键
  borrowedquantity int null
 )

 select * from rdd
 drop table rdd 
  
 
 --books表 
 use TSGL
 create table boo
 ( bookid char(15) not null        --bookid字段，非空约束
   constraint pk_bookid primary key,  --主键约束
   name varchar(50) null,
   author char(8) null,
   publisher varchar(30),
   publisheddate smalldatetime null,
   price real null
  )
  
 select * from boo  
  drop table boo
  
  
  --borrowinfo表
 use TSGL
 create table boff
 ( readerid char(10) not null
   constraint fk_readerid foreign key references rdd(readerid),--外键约束
   bookid char(15) not null
   constraint fk_bookid foreign key references boo(bookid),  --外键约束
   constraint pk_readerid_bookid primary key(readerid,bookid),
   borroweddate datetime not null,
   returndate datetime null
  )
  
  select * from boff  
  drop table boff          
  
  
  
  --readtype表
  use TSGL
  create table ree
  ( typeid int not null
    constraint pk_typeid primary key,
    name varchar(20) not null,
    limitborrowquantity int null,
    borrowterm int null
    )
    
    
  select * from ree 
  drop table ree
   
    
   
  insert into rdd
  values('4','小白',3,3),
  ('5','小牛',4,3)

   update ree set limitborrowquantity=30,borrowterm=1

   delete from rdd where name='小明'
 

