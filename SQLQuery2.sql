--readers���������������������ͣ������ֵ��˵����
use TSGL
go
create table rdd
( readerid char(10) not null  --readerid�ֶΣ��ǿ�Լ��
  constraint pk_readerid primary key  --����Լ��
  --constraint ck_readerid  
  --check(readerid like '20172018[0-9][0-9]'),   --���Լ��
  name char(8)  null,   --name�ֶΣ��ɿ�Լ��
  typeid int  null
  constraint fk_typeid foreign key references ree(typeid),  --���
  borrowedquantity int null
 )

 select * from rdd
 drop table rdd 
  
 
 --books�� 
 use TSGL
 create table boo
 ( bookid char(15) not null        --bookid�ֶΣ��ǿ�Լ��
   constraint pk_bookid primary key,  --����Լ��
   name varchar(50) null,
   author char(8) null,
   publisher varchar(30),
   publisheddate smalldatetime null,
   price real null
  )
  
 select * from boo  
  drop table boo
  
  
  --borrowinfo��
 use TSGL
 create table boff
 ( readerid char(10) not null
   constraint fk_readerid foreign key references rdd(readerid),--���Լ��
   bookid char(15) not null
   constraint fk_bookid foreign key references boo(bookid),  --���Լ��
   constraint pk_readerid_bookid primary key(readerid,bookid),
   borroweddate datetime not null,
   returndate datetime null
  )
  
  select * from boff  
  drop table boff          
  
  
  
  --readtype��
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
  values('4','С��',3,3),
  ('5','Сţ',4,3)

   update ree set limitborrowquantity=30,borrowterm=1

   delete from rdd where name='С��'
 

