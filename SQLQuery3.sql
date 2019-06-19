drop database jxgl
CREATE DATABASE jxgl
ON PRIMARY
( NAME=books_data,
  filename='f:\sql\books2_data.mdf',
  size=3,
  maxsize=20,
  filegrowth=5%
 )
 LOG ON
 ( name=books_log,
   filename='f:\sql\books2_log.ldf',
   size=2,
   maxsize=10,
   filegrowth=1
 )
  





use  jxgl
--ѧ����s(sno,sname,sex,birthday,college)
create table s
(
 sno char(6) not null
 constraint pk_sno primary key
 constraint ck_sno check(sno like 's[0-9][0-9]'),
 sname varchar(20) not null,
 sex char(2) null
 constraint ck_sex check(sex='��' or sex='Ů'),
 brithday date null,
 college varchar(20) null default '���ѧԺ'
 )
 
 --�γ̱�c(cno,cname,ms,credit,c_college)
 create table c
 ( cno char(3) constraint pk_cno primary key,
 cname varchar(20) not null constraint uk_cname unique,
 ms varchar(50),
 credit decimal(2,1)
 constraint ck_credit check(credit between 1 and 6),
 c_college varchar(20)
 )
 
 --ѡ�ޱ�sc(sno,cno,grade)
 create table sc
 (
 sno char(6)
 constraint fk_sno foreign key references s(sno),
 cno char(3)
 constraint fk_cno foreign key references c(cno),
 grade decimal(4,1)
 constraint ck_grade check(grade between 0 and 100),
 constraint pk_sno_cno primary key(sno,cno)
 )









--����s_grade�Ĵ洢���̣�Ҫ���ѯÿ��ѧ�����Ź��εĳɼ�
use jxgl
go
create procedure s_grade
as
select s.sno,s.sname,s.cname,s.grade
from s join sc on s.sno=sc.sno join c on sc.cno=c.cno
go

--���ô洢����s_grade
use jxgl
go
exec s_grade
go




--����proc_exp�Ĵ洢����
use jxgl
go
create procedure proc_exp @s_name char(20)
as
select AVG(grade) as 'ƽ���ɼ�'
from s join sc on s.sno=sc.sno and sname=@s_name


--���ô洢����proc_exp
use jxgl
exec proc_exp '����'







--����s_info�Ĵ洢����
use jxgl
go
create procedure s_info @s_name char(8)
as 
declare @s_count int,@s_avg real
select @s_count=COUNT(cno),@s_avg=AVG(grade)
from s join sc on sc.sno =s.sno  and sname=@s_name
print @s_name+'ͬѧ��ѡ����'+str(@s_count)+'�ſγ�.ƽ���ɼ�Ϊ:'+str(@s_avg)
go




--�鿴���ݱ�������Ϣ
use jxgl
go
create proc table_info @table varchar(30)
as
select table_name=sysobjects.name,
index_name=sysindexes.name,index_id=indid
from sysindexes inner join sysobjects on sysobjects.id=sysindexes.id
where sysobjects.name=@table
go




use tsgl              -------
go
create procedure r_f
@r_readerid char(10)
as 
begin
select rd.readerid,rd.name,bo.bookid,bo.name,bof.borroweddate,bof.returndate
from rd inner join bof on rd.readerid=bof.readerid inner join bo on bof.bookid=bo.bookid
where rd.readerid=@r_readerid
end




use TSGL
go
create proc  t
@borroweddate datetime,@returndate datetime
as
select rd.readerid,rd.name,bo.bookid,bo.name
from rd inner join bof on rd.readerid=bof.readerid inner join bo on bo.bookid=bof.bookid
where borroweddate=@borroweddate and GETDATE()=@returndate 
go


--ɾ���洢����
use tsgl
go
drop proc t
go
 





--T-SQL��䴴���ϲ鿴��ͼ
--create  view _name 
--as 
--select_statement


use jxgl
go
create view view_s_grade
as 
select s.sno,sname,cname,grade
from s,sc,c
where s.sno=sc.sno and sc.cno=c.cno
go



--T-SQL����޸���ͼ
--alter view view_name 
--as 
--select_statement


use jxgl
go
alter view view_s_grade
as select s.sno,sname,cname,grade
from s,sc,c
where s.sno=sc.sno and sc.cno=c.cno
go




--T-SQL���ɾ����ͼ��ͼ
use jxgl
go
drop view view_s_grade
go




--���������ļ�

--���������ļ�IX_sdept
use jxgl
go
create index IX_sdept on s(dept)
go


--��s�������ֶ�age���������ļ�IX_sdept,����
use jxgl
go
create index IX_age on s(age desc)
go


--ɾ�������ļ�
--drop index table_name.index_name

--ɾ����s�������ļ�I_sname
use jxgl
go
drop index s.I_sname
go


--ʹ�ô洢����sp_helpindex�鿴�����ļ�
use jxgl
go
exec sp_helpindex  s
go







drop database edcu
CREATE DATABASE educ
ON PRIMARY
( NAME=books_data,
  filename='f:\sql\books3_data.mdf',
  size=3,
  maxsize=20,
  filegrowth=5%
 )
 LOG ON
 ( name=books_log,
   filename='f:\sql\books3_log.ldf',
   size=2,
   maxsize=10,
   filegrowth=1
 )
  






/*use  educ
--ѧ����s(sno,sname,sex,birthday,college)
create table s
(
 sno char(6) not null
 constraint pk_sno primary key
 constraint ck_sno check(sno like 's[0-9][0-9]'),
 sname varchar(20) not null,
 sex char(2) null
 constraint ck_sex check(sex='��' or sex='Ů'),
 brithday date null,
 college varchar(20) null default '���ѧԺ'
 )
 
 --�γ̱�c(cno,cname,ms,credit,c_college)
 create table c
 ( cno char(3) constraint pk_cno primary key,
 cname varchar(20) not null constraint uk_cname unique,
 ms varchar(50),
 credit decimal(2,1)
 constraint ck_credit check(credit between 1 and 6),
 c_college varchar(20)
 )
 
 --ѡ�ޱ�sc(sno,cno,score)
 create table sc
 (
 sno char(6)
 constraint fk_sno foreign key references s(sno),
 cno char(3)
 constraint fk_cno foreign key references c(cno),
 score decimal(4,1)
 constraint ck_score check(score between 0 and 100),
 constraint pk_sno_cno primary key(sno,cno)
 )



use educ
go
create view v_computer
as
select * from s
where college='�����ϵ'
go


use educ
go
create view v_sc_g
as
select s.sno,s.sname,.tcid,c.cname,sc.score
from s,sc,c 
where  s.sno=sc.sno and sc.cno=c.cno
go


use educ
go
create view v_num_avg
as
select COUNT(*) as 'ϵѧ������',avg(year(GETDATE())-YEAR(birthday)) as 'ƽ������'
from s
go


use educ
go
create view v_year
as
select birthday
from s
go


use educ
go
create view v_avg_s_c
as
select COUNT(*),AVG(score)
from sc,s 
where on sc.sno=s.sno
group by sno
*/


use tsgl
go
create view read_borrow_book
as
select rd.readerid,rd.name,borroweddate,bo.bookid,bo.name as 'booksname'        --��ͼ�����е���������Ψһ������Ҫ������
from rd inner join bof on rd.readerid=bof.readerid inner join bo on bof.bookid=bo.bookid
where borrowedquantity>3
go



use tsgl
go
drop view read_borrow_book
go


use tsgl
go
create view b_book
as
select bookid,name,author,publisher,publisheddate
from bo
where publisher='�廪��ѧ������' and price>30
go



use tsgl
go
create view borrow_inf
as
select rd.readerid,name,typeid,borroweddate
from rd inner join bof on rd.readerid=bof.readerid
where returndate = null
go