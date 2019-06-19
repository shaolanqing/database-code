use mem
go


--创建数据库
create database mem
on primary                    --数据文件
(  name=mem_data1,
   filename='d:\sql1\mem_data1.mdf',
   size=100,
   maxsize=256,
   filegrowth=10%
)
/*filegroup  mem1                     --指定文件数组
(  name=mem_data2,
   filename='d:\sql1\mem_data2.ndf',
   size=5,
   maxsize=256,
   filegrowth=10%
)
*/
log on                         --日志文件
(  name=mem_log1,
   filename='d:\sql1\mem_log1.ldf',
   size=5,
   maxsize=unlimited,
   filegrowth=10
 )









--member(id身份证号,name姓名,sex性别,consume消费金额,cdate消费日期,cnumber卡号)
create table member                 --会员信息
(
  id char(20) not null
  constraint pk_id primary key,  --主键
  name varchar(20) not null,
  sex char(2) null
  constraint ck_sex check (sex='男' or sex= '女'),
  consume float  null,
  cdate date not null,
  cnumber char(20) not null
  constraint fk_cnumber foreign key references card_number(cnumber)  --外键
 )

drop table member 
 select * from member 


 --admin(adnumber工号,adname姓名,adsex性别,adphone电话号)
 create table admin                                             --管理员信息
 ( 
   adnumber char(20) not null
   constraint pk_adnumber primary key,                            --主键
   adname varchar(20) not null,
   adsex char(2) null,
   adphone char(20) null
  )

 drop table admin

 select * from admin

   
   
 --card_number(cnumber卡号,ctype会员类型,cdiscount折扣,cremain余额,all_consume总消费金额,adnumber工号,recharge充值,gs挂失)
 create table card_number           --会员卡信息
 (
   cnumber char(20) not null
   constraint pk_cnumber primary key,                             --主键
   ctype varchar(20) not null,                     --会员等级
   cdiscount real,
   cremain int  null,
   all_consume float not null,
   adnumber char(20) not null
   constraint fk_adnumber foreign key references admin(adnumber),        --外键
   recharge float null,
   gs char(20) null
   )


  drop table card_number

select * from card_number


  




use mem
go

--查询

--按卡号查询
select *
from card_number 
where cnumber='01111'


--按身份证号查询
select *
from member  
where id='36052119907300047'

--按姓名查询
select *
from member
where name='小美'

--按会员类型查询
select *
from card_number 
where ctype='普通成员'







--创建视图
use mem 
go

--查询消费情况视图
create view consumed
as 
select name,consume,cnumber                       --将查找到的姓名，当月消费的金额，卡号形成视图
from member 
where month(cdate)=month(getdate())              --返回的是int类型         但是会出现去年月份和今年月份一样，都出现

drop view consumed

select * from consumed




--创建当月生日的会员视图，将查找的当月生日的会员的姓名，卡号，身份证号一起构建视图
alter view viwe_birth
as
 select name,cnumber,id
 from member 
 where substring(member.id,11,2)=month(getdate())      --当前日期月份刚好与会员生日月份一样  从第7个位置开始取8位          (sysdate,'yyyymmdd')

select * from viwe_birth

 drop view viwe_birth

 select getdate()   --获取当前系统的时间





--前10名会员卡号和姓名构成视图
create view view_reward
as 
 select top 10 member.cnumber,name
 from member join card_number on member.cnumber=card_number.cnumber 
 order by all_consume desc                             --不用分组,因为本身就有all_consume字段，group by member.cnumber

 select * from view_reward 
 
 drop view view_reward


--总消费额为前10的会员，(进行奖励回报,提高打折额度,用存储过程）
create trigger p2_reward
 on card_number
 for insert,update
 as 
 begin
   update card_number
   set cremain=cremain+100
   where cnumber in(
                    select top 5 cnumber
                    from  card_number  
                    order by all_consume desc                             --不用分组,因为本身就有all_consume字段，group by member.cnumber
					)
end

update card_number
set all_consume=all_consume+100
where cnumber=01111

select * from card_number  

drop trigger p2_reward



--根据会员类型查看会员信息构成视图
create view view_type
as 
 select name,member.cnumber,sex
 from member join card_number on member.cnumber=card_number.cnumber 
 where ctype='白金vip'

select * from view_type

drop view view_type



--创建存储过程实现累计消费金额 ,根据累计消费求出总的消费           *
create proc p_consume
@consume float,@cnumber char(20)
as
 declare @all_consume float
 select @all_consume=all_consume from card_number
 update member set consume=@consume where cnumber=@cnumber   --先更新consume表中的consume
 select @all_consume=@consume + all_consume                                                    
 from  card_number join member on card_number.cnumber=member.cnumber
 where consume= @consume and card_number.cnumber=@cnumber
 print @all_consume


  p_consume '700','01111'                                 

 select all_consume from card_number
 where cnumber='01111'

 drop proc p_consume







--创建存储过程，根据卡号获取持卡会员信息          *
create proc p_info
@cnumber char(20)
as
  declare @name varchar(20),@ctype varchar(20)
  select @name=name,@ctype=ctype
  from member join card_number on member.cnumber=card_number.cnumber 
  where member.cnumber=@cnumber 
  print @name
  print @ctype

 p_info '02222'

drop proc p_info






--创建触发器卡内余额随消费金额自动更新                     ***********
create trigger tr_remain
on member
for update,insert
as
 begin
 declare @consume float 
 if update(consume)
   select @consume=(select consume from inserted ) 
   update card_number 
   set cremain=cremain-@consume       --余额更新
   where cnumber=(select cnumber from deleted )            --根据卡号
   update card_number 
   set all_consume=all_consume+@consume     --总消费额更新
   where cnumber =(select cnumber from inserted)
end


update member
set consume=200
where cnumber=03333

select all_consume,cremain from card_number          
where cnumber=03333


drop trigger tr_remain




 --创建存储过程实现会员类型随累计消费金额自动更新            ****************
create proc m_upgrade
@cnumber char(20)
as
  update card_number               
  set ctype=(case     
  
                when card_number.all_consume>=2500  then '黄金vip'	
				when all_consume>=1000  then '白金vip'
				when all_consume>=500   then '普通vip'
                when all_consume<500   then '普通成员'
				end
			)
   where cnumber=@cnumber

   

exec  m_upgrade '03333'

drop  proc m_upgrade


--销售折扣随会员类型自动更新                         ***************
create trigger tr_ctype
on card_number 
after update,insert
as
 begin
   update card_number 
   set cdiscount=(case ctype
                   when  '普通成员' then 0.97
                   when  '普通vip' then 0.95
				   when  '白金vip' then 0.90
                   when  '黄金vip' then 0.87
				   end
				  )
 end

 drop trigger tr_ctype
    
 insert into card_number(cnumber,ctype,cremain,all_consume )
values(06666,'普通vip',5000,2000)

update  card_number
set all_consume=1600
where cnumber=04444







--创建1个登录、数据库用户，并分配数据库管理员权限

sp_addlogin 'login2','123'   --创建登录login1

use mem                      --创建访问数据库mem的用户
go
sp_adduser 'login2','user2'

use mem
go
sp_addrolemember db_owner, user2 /*升级为数据库管理员*/
go





use mem

sp_addrolemember db_owner,user2

exec sp_addsrvrolemember 'login1','sysadmin'/*升级为服务器管理员*/



use mem
go
exec sp_addlogin 'toto','123','mem'/*在数据库创建登录名*/
go

sp_adduser 'toto','user_toto'     /*建立与登录名对应的用户名*/

go
sp_addrolemember db_owner,user_toto/*升级为数据库管理员*/
go

exec sp_addsrvrolemember 'toto','sysadmin'/*升级为服务器管理员*/
 


