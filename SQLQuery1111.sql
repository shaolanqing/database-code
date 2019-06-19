use mem
go


--�������ݿ�
create database mem
on primary                    --�����ļ�
(  name=mem_data1,
   filename='d:\sql1\mem_data1.mdf',
   size=100,
   maxsize=256,
   filegrowth=10%
)
/*filegroup  mem1                     --ָ���ļ�����
(  name=mem_data2,
   filename='d:\sql1\mem_data2.ndf',
   size=5,
   maxsize=256,
   filegrowth=10%
)
*/
log on                         --��־�ļ�
(  name=mem_log1,
   filename='d:\sql1\mem_log1.ldf',
   size=5,
   maxsize=unlimited,
   filegrowth=10
 )









--member(id���֤��,name����,sex�Ա�,consume���ѽ��,cdate��������,cnumber����)
create table member                 --��Ա��Ϣ
(
  id char(20) not null
  constraint pk_id primary key,  --����
  name varchar(20) not null,
  sex char(2) null
  constraint ck_sex check (sex='��' or sex= 'Ů'),
  consume float  null,
  cdate date not null,
  cnumber char(20) not null
  constraint fk_cnumber foreign key references card_number(cnumber)  --���
 )

drop table member 
 select * from member 


 --admin(adnumber����,adname����,adsex�Ա�,adphone�绰��)
 create table admin                                             --����Ա��Ϣ
 ( 
   adnumber char(20) not null
   constraint pk_adnumber primary key,                            --����
   adname varchar(20) not null,
   adsex char(2) null,
   adphone char(20) null
  )

 drop table admin

 select * from admin

   
   
 --card_number(cnumber����,ctype��Ա����,cdiscount�ۿ�,cremain���,all_consume�����ѽ��,adnumber����,recharge��ֵ,gs��ʧ)
 create table card_number           --��Ա����Ϣ
 (
   cnumber char(20) not null
   constraint pk_cnumber primary key,                             --����
   ctype varchar(20) not null,                     --��Ա�ȼ�
   cdiscount real,
   cremain int  null,
   all_consume float not null,
   adnumber char(20) not null
   constraint fk_adnumber foreign key references admin(adnumber),        --���
   recharge float null,
   gs char(20) null
   )


  drop table card_number

select * from card_number


  




use mem
go

--��ѯ

--�����Ų�ѯ
select *
from card_number 
where cnumber='01111'


--�����֤�Ų�ѯ
select *
from member  
where id='36052119907300047'

--��������ѯ
select *
from member
where name='С��'

--����Ա���Ͳ�ѯ
select *
from card_number 
where ctype='��ͨ��Ա'







--������ͼ
use mem 
go

--��ѯ���������ͼ
create view consumed
as 
select name,consume,cnumber                       --�����ҵ����������������ѵĽ������γ���ͼ
from member 
where month(cdate)=month(getdate())              --���ص���int����         ���ǻ����ȥ���·ݺͽ����·�һ����������

drop view consumed

select * from consumed




--�����������յĻ�Ա��ͼ�������ҵĵ������յĻ�Ա�����������ţ����֤��һ�𹹽���ͼ
alter view viwe_birth
as
 select name,cnumber,id
 from member 
 where substring(member.id,11,2)=month(getdate())      --��ǰ�����·ݸպ����Ա�����·�һ��  �ӵ�7��λ�ÿ�ʼȡ8λ          (sysdate,'yyyymmdd')

select * from viwe_birth

 drop view viwe_birth

 select getdate()   --��ȡ��ǰϵͳ��ʱ��





--ǰ10����Ա���ź�����������ͼ
create view view_reward
as 
 select top 10 member.cnumber,name
 from member join card_number on member.cnumber=card_number.cnumber 
 order by all_consume desc                             --���÷���,��Ϊ�������all_consume�ֶΣ�group by member.cnumber

 select * from view_reward 
 
 drop view view_reward


--�����Ѷ�Ϊǰ10�Ļ�Ա��(���н����ر�,��ߴ��۶��,�ô洢���̣�
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
                    order by all_consume desc                             --���÷���,��Ϊ�������all_consume�ֶΣ�group by member.cnumber
					)
end

update card_number
set all_consume=all_consume+100
where cnumber=01111

select * from card_number  

drop trigger p2_reward



--���ݻ�Ա���Ͳ鿴��Ա��Ϣ������ͼ
create view view_type
as 
 select name,member.cnumber,sex
 from member join card_number on member.cnumber=card_number.cnumber 
 where ctype='�׽�vip'

select * from view_type

drop view view_type



--�����洢����ʵ���ۼ����ѽ�� ,�����ۼ���������ܵ�����           *
create proc p_consume
@consume float,@cnumber char(20)
as
 declare @all_consume float
 select @all_consume=all_consume from card_number
 update member set consume=@consume where cnumber=@cnumber   --�ȸ���consume���е�consume
 select @all_consume=@consume + all_consume                                                    
 from  card_number join member on card_number.cnumber=member.cnumber
 where consume= @consume and card_number.cnumber=@cnumber
 print @all_consume


  p_consume '700','01111'                                 

 select all_consume from card_number
 where cnumber='01111'

 drop proc p_consume







--�����洢���̣����ݿ��Ż�ȡ�ֿ���Ա��Ϣ          *
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






--����������������������ѽ���Զ�����                     ***********
create trigger tr_remain
on member
for update,insert
as
 begin
 declare @consume float 
 if update(consume)
   select @consume=(select consume from inserted ) 
   update card_number 
   set cremain=cremain-@consume       --������
   where cnumber=(select cnumber from deleted )            --���ݿ���
   update card_number 
   set all_consume=all_consume+@consume     --�����Ѷ����
   where cnumber =(select cnumber from inserted)
end


update member
set consume=200
where cnumber=03333

select all_consume,cremain from card_number          
where cnumber=03333


drop trigger tr_remain




 --�����洢����ʵ�ֻ�Ա�������ۼ����ѽ���Զ�����            ****************
create proc m_upgrade
@cnumber char(20)
as
  update card_number               
  set ctype=(case     
  
                when card_number.all_consume>=2500  then '�ƽ�vip'	
				when all_consume>=1000  then '�׽�vip'
				when all_consume>=500   then '��ͨvip'
                when all_consume<500   then '��ͨ��Ա'
				end
			)
   where cnumber=@cnumber

   

exec  m_upgrade '03333'

drop  proc m_upgrade


--�����ۿ����Ա�����Զ�����                         ***************
create trigger tr_ctype
on card_number 
after update,insert
as
 begin
   update card_number 
   set cdiscount=(case ctype
                   when  '��ͨ��Ա' then 0.97
                   when  '��ͨvip' then 0.95
				   when  '�׽�vip' then 0.90
                   when  '�ƽ�vip' then 0.87
				   end
				  )
 end

 drop trigger tr_ctype
    
 insert into card_number(cnumber,ctype,cremain,all_consume )
values(06666,'��ͨvip',5000,2000)

update  card_number
set all_consume=1600
where cnumber=04444







--����1����¼�����ݿ��û������������ݿ����ԱȨ��

sp_addlogin 'login2','123'   --������¼login1

use mem                      --�����������ݿ�mem���û�
go
sp_adduser 'login2','user2'

use mem
go
sp_addrolemember db_owner, user2 /*����Ϊ���ݿ����Ա*/
go





use mem

sp_addrolemember db_owner,user2

exec sp_addsrvrolemember 'login1','sysadmin'/*����Ϊ����������Ա*/



use mem
go
exec sp_addlogin 'toto','123','mem'/*�����ݿⴴ����¼��*/
go

sp_adduser 'toto','user_toto'     /*�������¼����Ӧ���û���*/

go
sp_addrolemember db_owner,user_toto/*����Ϊ���ݿ����Ա*/
go

exec sp_addsrvrolemember 'toto','sysadmin'/*����Ϊ����������Ա*/
 


