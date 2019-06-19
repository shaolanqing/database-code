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







drop database educ
CREATE DATABASE educ
ON PRIMARY
( NAME=books_data,
  filename='e:\sql\books3_data.mdf',
  size=5,
  maxsize=20,
  filegrowth=5%
 )
 LOG ON
 ( name=books_log,
   filename='e:\sql\books3_log.ldf',
   size=2,
   maxsize=10,
   filegrowth=1
 )
  







use  educ

--ѧ����student_info(sno,sname,s_native,birthday,dno,classno,entime,home,tel)
create table student_info
(
 sno char(8) not null
 constraint pk_sno primary key
 constraint ck_sno check(sno like 's[0-9][0-9]'),
 sname char(8) not null,
 sex char(2) null
 constraint ck_sex check(sex='��' or sex='Ů'),
 brithday smalldatetime null,
 
 -- s_native varchar(50) null,
/* dno char(4) null 
 constraint fk_dno foreign key references teacher_info(dno), 
classno char(4) null
 constraint fk_classno foreign key references class_info(classno),
  entime smalldatetime null,
  home varchar(50) null,
  tel char(12) null
 */
 )
 
 drop table student_info
 
 --�γ̱�course(cno,cname,experiment,lecture,semester,credit)
 create table course_info
 ( cno char(10) not null
 constraint pk_cno primary key,
 cname varchar(20) not null,
 experiment tinyint null,
 lecture tinyint null,
 semester tinyint null,
 credit tinyint null
 )
 
 drop table course_info
 
 
 --ѡ�ޱ�sc_info(sno,tcid,score)
 create table sc_info
 (
 sno char(8) not null
 constraint fk_sno foreign key references student_info(sno),
 cno char(2) not null,
 --constraint fk_tcid foreign key references tc_info(tcid),
 --constraint pk_sno_tcid primary key(sno,tcid),
 score tinyint null
 )
 
 drop table sc_info
 
--��ʦ��Ϣ��teacher_info(tno,tname,sex,birthday,dno,title,home,tel)
create table teacher_info
(
 tno char(8) not null
 constraint pk_tno primary key,
 tname char(8) not null,
 sex char(2) null,
 
 birthday smalldatetime null,
 title char(14) null
 /*dno char(4) null
 constraint fk_cno foreign key references dept_info(dno),
 home varchar(50) null,
 tel char(12) null*/
 )
 
  drop table teacher_info

/*--��ʦ�Ͽ���Ϣ��tc_info(tcid,tno,score,classno,cno,semester,schoolyear,classroom,classtime)
create table tc_info
(
 tcid char(2) not null
 constraint pk_tcid primary key,
 tno char(8) null
 constraint fk_tno foreign key references teacher_info(tno),
 score tinyint null,
 --classno char(4) null
 --constraint fk_classno foreign key references class_info(classno),
 --cno char(10) not null
 --constraint fk_cno foreign key references course_info(cno),
 semester char(6) null,
 schoolyear char(10) null,
 classroom varchar(10) null,
 classtime varchar(50) null
 )
 
 drop table tc_info
 */
 




/* --Ժϵ��Ϣ��dept_info(dno,dname,d_chair,d_address,tel)
 create table dept_info
 (
  dno char(4) not null
   constraint pk_dno primary key,
   dname char(16) not null,
   d_chair char(8) null,
   d_address varchar(50) null,
   tel char(12) null
   )
   */
/* --�༶��Ϣ��class_info(classno,classname,monitor,instructor,dno)
 create table class_info
(
 classno char(4) not null
 constraint pk_classno primary key,
 classname char(16) not null,
 monitor char(8) null,
 instructor char(8) null,
 dno char(4) not  null
 constraint fk_dno foreign key references dept_info(dno)
 )
 
 drop table class_info
 */
 
 
 create trigger tr_sc_score
 on sc_info
 for insert,update
 as
 declare @score_read tinyint
 select @score_read =score from instered 
 if(@score_read>=0 and @score_read<=100)
  begin
  print'������޸ĳɹ�'
 end
 else
  begin
  rollback
  print'������޸�ʧ�ܣ��ɼ�������Χ'
  end
 
update sc_info set score=100

drop trigger tr_sc_score


 create trigger tr_teacher
 on teacher_info
 after insert
 as 
 declare @age int,@sex char(2),@title char(14)
 select @age=year(getdate())-year(birthday) from inserted
 select @sex=sex,@title=title from teacher_info
 if(@sex='��' and @age>60 ) 
 begin
   print'��ְ�����䳬����Χ'
   rollback
 end
 if(@sex='Ů' and @title='����' and @age>60 )
 begin
   print'Ůְ���������䳬����Χ'
   rollback
 end
 if( @sex='Ů' and @age>55 )
 begin
   print'��ͨŮְ�����䳬����Χ'
   rollback
 end
 
 --Ϊstudent_info��sc_info��������������

 --Ϊstudent_info���sc_info����һ�������´�����
 create trigger tr_s_update
 on student_info
 for update
 as
 if update(sno)
  begin
    declare @sno_new char(8),@sno_old char(8)
	select @sno_new=sno from inserted
	select @sno_old=sno from deleted
	update student_info set sno=@sno_new  where sno=@sno_old
	update sc_info set sno=@sno_new  where sno=@sno_old
  end
 
 create trigger tr_sc_update
 on sc_info
 for update
 as
 if update(sno)
  begin
    declare @sno_new char(8),@sno_old char(8)
	select @sno_new=sno from inserted
	select @sno_old=sno from deleted
	update sc_info set sno=@sno_new  where sno=@sno_old
	update student_info set sno=@sno_new  where sno=@sno_old
  end
 
 --Ϊstudent_info���sc_info��������ɾ��
 create trigger tr_sc_delete
 on sc_info
 after delete
 as
 begin
 declare @sno char(8)
 select @sno=sno from deleted
 delete from sc_info  where sc_info.sno=@sno
 delete from student_info where student_info.sno=@sno
 rollback
 end
 
 create trigger tr_s_delete
 on student_info
 after delete
 as
 begin
 declare @sno char(8)
 select @sno=sno from deleted
 delete from student_info  where student_info.sno=@sno
 delete from sc_info where sc_info.sno=@sno
 rollback
 end
 
 
 
 
 use tsgl
 go
 create trigger tr_borrowinf
 on bof
 after insert
 as 
  update borrowedquantity set num=num+1
  where readerid=(select readerid from inserted)
  update borrowedquantity set num=num-1
  where readerid=(select readerid from deleted)

 
  
 use tsgl          ----------------------
 go
 create trigger tr_fine
 on bof
 after update
 as
 declare @day int          --,@month int
 select @day =DATEDIFF(day,returndate,borroweddate) from inserted          --,@month=(datename(month,returnday)-datename(month,borroweddate)) 
 alter table bof  add fine float 
 if(@day>90)
   begin
    update bof
     set fine=0.5*(@day-90)
	 where returndate=(select returndate from inserted)
  end
 


 create trigger tr_borr
 on rd
 after update,insert
 as
 declare @borrowedquantity int,@limitborrowquantity int
 select @borrowedquantity=borrowedquantity from inserted 
 select @limitborrowquantity=limitborrowquantity from re  where typeid=(select typeid from inserted) 
  if @borrowedquantity>@limitborrowquantity
    begin
	 rollback
	 print'�ѳ���������Ŀ����ֹ����'
	 end

drop trigger tr_borr

 
  
 
   
   
 
 
 
 
 
 
 
   
 
 
 
 
 
 
 





























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