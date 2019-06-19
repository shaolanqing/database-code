use TSGL
go
--readers表（列名，描述，数据类型，允许空值，说明）
create table rd
( readerid char(10) not null  --readerid字段，非空约束
  constraint readerid primary key  --主键约束
  constraint ck_readerid  
  check(readerid like '20172018[0-9][0-9]'),   --检查约束
  name char(8)  null,   --name字段，可空约束
  typeid int  null
  constraint fk_typeid foreign key references re(typeid),  --外键
  borrowedquantity int null
 )

 select * from rd
 drop table rd 
  
 
 --books表 
 use TSGL
 create table bo
 ( bookid char(15) not null        --bookid字段，非空约束
   constraint pk_bookid primary key,  --主键约束
   name varchar(50) null,
   author char(8) null,
   publisher varchar(30),
   publisheddate smalldatetime null,
   price real null
  )
  
 select * from bo  
  drop table bo
  
  
  --borrowinfo表
 use TSGL
 create table bof
 ( readerid char(10) not null
   constraint fk_readerid foreign key references rd(readerid),--外键约束
   bookid char(15) not null
   constraint fk_bookid foreign key references bo(bookid),  --外键约束
   constraint pk_readerid_bookid primary key(readerid,bookid),
   borroweddate datetime not null,
   returndate datetime null
  )
  
  select * from bof  
  drop table bof          
  
  
  
  --readtype表
  use TSGL
  create table re
  ( typeid int not null
    constraint pk_typeid primary key,
    name varchar(20) not null,
    limitborrowquantity int null,
    borrowterm int null
    )
    
    
  select * from re  
  drop table re
   
    
   
   
alter table rd
add constraint ck_typeid 
check(typeid like '[0-9]')
   
   
 alter table rd  
--delete from rd where typeid and   readerid
drop foreign key typeid
drop primary key readerid
  
  
  
alter table rd
add constraint pk_readerid primary key(readerid)

 
 
alter table bof
add constraint pk_readerid_bookid primary key(readerid,bookid)



select * from rd

select * from rd
where readerid=2017201801


select name,author
from bo
where publisher='北京'


select * from bo
where name='c'


select * from bo
where publisher='北京'
 order by price
  
 
select borrowedquantity
from rd inner join bof on rd.readerid=bof.readerid
where borroweddate>='2004-1-1' and borroweddate<= '2004-12-31'    --日期加单引号



select bof.*           --,rd.* 
from bof inner join rd  on bof.readerid=rd.readerid
where borroweddate>='2000 -1-1' and borroweddate<= '2019-12-31'  and rd.name='小白'



select readerid,borrowedquantity
from rd 
where borrowedquantity >= 3






select * from bo
where price>
( select avg(price)
  from bo
  )


select * from books
where publisher='北京' and price > 
(  select AVG(price)
   from books
   )
   






  