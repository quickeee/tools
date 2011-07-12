2010.02.24
----------

1��mssql �еķָ��
Create this function:
CREATE FUNCTION dbo.Split(@String nvarchar(4000), @Delimiter char(1))
returns @Results TABLE (Items nvarchar(4000))
as
begin
declare @index int
declare @slice nvarchar(4000)

select @index = 1
if @String is null return

while @index != 0

begin
select @index = charindex(@Delimiter,@String)
if @index !=0
select @slice = left(@String,@index - 1)
else
select @slice = @String

insert into @Results(Items) values(@slice)
select @String = right(@String,len(@String) - @index)
if len(@String) = 0 break
end return
endand then try:

select * from dbo.split('a,b,c,d,e,f,g,h,i,j,k,l'), ',')

2010.02.08
----------

1��SQL Server �洢���̵ķ�ҳ
SQL Server �洢���̵ķ�ҳ����������Ѿ����۹������ˣ��ܶ����������ң������ڴ˷���һ���ҵĹ۵�
������

CREATE TABLE [TestTable] (
 [ID] [int] IDENTITY (1, 1) NOT NULL ,
 [FirstName] [nvarchar] (100) COLLATE Chinese_PRC_CI_AS NULL ,
 [LastName] [nvarchar] (100) COLLATE Chinese_PRC_CI_AS NULL ,
 [Country] [nvarchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
 [Note] [nvarchar] (2000) COLLATE Chinese_PRC_CI_AS NULL
) ON [PRIMARY]
GO

�������ݣ�(2�������ø�������ݲ��Ի�����һЩ)
SET IDENTITY_INSERT TestTable ON

declare @i int
set @i=1
while @i<=20000
begin
    insert into TestTable([id], FirstName, LastName, Country,Note) values(@i, 'FirstName_XXX','LastName_XXX','Country_XXX','Note_XXX')
    set @i=@i+1
end

SET IDENTITY_INSERT TestTable OFF
-------------------------------------

��ҳ����һ��(����Not In��SELECT TOP��ҳ)
�����ʽ��
SELECT TOP 10 *
FROM TestTable
WHERE (ID NOT IN
          (SELECT TOP 20 id
         FROM TestTable
         ORDER BY id))
ORDER BY ID


SELECT TOP ҳ��С *
FROM TestTable
WHERE (ID NOT IN
          (SELECT TOP ҳ��С*ҳ�� id
         FROM ��
         ORDER BY id))
ORDER BY ID

-------------------------------------

��ҳ��������(����ID���ڶ��ٺ�SELECT TOP��ҳ��
�����ʽ��
SELECT TOP 10 *
FROM TestTable
WHERE (ID >
          (SELECT MAX(id)
         FROM (SELECT TOP 20 id
                 FROM TestTable
                 ORDER BY id) AS T))
ORDER BY ID


SELECT TOP ҳ��С *
FROM TestTable
WHERE (ID >
          (SELECT MAX(id)
         FROM (SELECT TOP ҳ��С*ҳ�� id
                 FROM ��
                 ORDER BY id) AS T))
ORDER BY ID
-------------------------------------

��ҳ��������(����SQL���α�洢���̷�ҳ)
create  procedure XiaoZhengGe
@sqlstr nvarchar(4000), --��ѯ�ַ���
@currentpage int, --��Nҳ
@pagesize int --ÿҳ����
as
set nocount on
declare @P1 int, --P1���α��id
 @rowcount int
exec sp_cursoropen @P1 output,@sqlstr,@scrollopt=1,@ccopt=1,@rowcount=@rowcount output
select ceiling(1.0*@rowcount/@pagesize) as ��ҳ��--,@rowcount as ������,@currentpage as ��ǰҳ
set @currentpage=(@currentpage-1)*@pagesize+1
exec sp_cursorfetch @P1,16,@currentpage,@pagesize
exec sp_cursorclose @P1
set nocount off

�����ķ��������û����������������ʱ��Ҳ�����÷�������������Ч�ʻ�͡�
�����Ż���ʱ�򣬼�����������������ѯЧ�ʻ���ߡ�

ͨ��SQL ��ѯ����������ʾ�Ƚϣ��ҵĽ�����:
��ҳ��������(����ID���ڶ��ٺ�SELECT TOP��ҳ��Ч����ߣ���Ҫƴ��SQL���
��ҳ����һ��(����Not In��SELECT TOP��ҳ)   Ч�ʴ�֮����Ҫƴ��SQL���
��ҳ��������(����SQL���α�洢���̷�ҳ)    Ч����������Ϊͨ��

��ʵ������У�Ҫ���������

2010.01.28
----------

1����ҳ

--busdate����Ϊ����
select drugcost,*
from
    (
        select row_number() over(order by busdate desc) as RowNum, *
        from
            h_indrugincome
    ) t
where
  t.RowNum between  begin_num and end_num

--
SELECT * FROM
     (
     SELECT TOP(100 ) * FROM
     (
          SELECT TOP (100 * page ) *
          FROM h_indrugincome
          ORDER BY specialdeptcode DESC
     ) a
     ORDER BY specialdeptcode ASC
) b
ORDER BY specialdeptcode DESC

2010.01.27
----------

1��MS SQL2005 ���������ؽ�(Index Defragment)�ű�
MS SQL Server �������ܶ࣬ʱ�䳤�ˣ�����ؽ�һ�£���֤���ݿ�Ŀɿ��ԡ�

Step 1. ��ȡindex�� ����ִ�нű���

CREATE TABLE #table_index (
 table_index_id  INT IDENTITY(1, 1)  NOT NULL,
 table_name  VARCHAR(255)   NULL,
 index_name  VARCHAR(255)   NULL,
 sql_statement  VARCHAR(5000)   NULL,
   )
INSERT #table_index (
 table_name,
 index_name)
SELECT  c.name + '.' +
  a.name AS table_name,
 b.name AS index_name
FROM sysobjects a
INNER JOIN sysindexes b
ON  a.id = b.id
AND b.indid <> 0 -- table  itself
AND   b.indid <> 255 -- text column
AND  a.name <> 'dtproperties'
AND a.type = 'u'
INNER JOIN sysusers c
ON  c.uid = a.uid
ORDER BY 1

IF @@ERROR <> 0
 BEGIN
  RAISERROR('error occured while populating a temp table', 16, 1)
  RETURN
 END

UPDATE  #table_index
SET  sql_statement =
'DBCC INDEXDEFRAG(' + db_name() + ', ''' + table_name + ''',''' + index_name + ''')'
FROM  #table_index a

select * from #table_index

ִ�������ű�����ȡindex ����

Step2: Ȼ�� �ӽ�����п���sql_statement�����ݵ�sql management studio.

ִ����Щdbcc command��
 DBCC INDEXDEFRAG(hotel, 'dbo.GuestInfo','PK__GuestInf__0C47285A15502E78')

.......

Step3: check result when finished.������е�Message��Ϣ��ȷ���ɹ���

2010.01.15
----------

1�����ʹ�����
select object_name(id)  ��,
8*reserved/1024 Ԥ����С,rtrim(8*dpages/1024)+'Mb' ��ʹ��,
8*(reserved-dpages)/1024 δʹ��,8*dpages/1024-rows/1024*minlen/1024 ����,
rows,* from sysindexes
where indid=1
order by reserved desc

select object_name(id) tablename,8*reserved/1024 reserved,rtrim(8*dpages/1024)+'Mb' used,8*(reserved-dpages)/1024 unused,8*dpages/1024-rows/1024*minlen/1024 free,
rows,* from sysindexes
where indid=1
order by reserved desc

2009.12.02
-----------

1������ˢ��������ͼ
SELECT REPLACE(B.TEXT,'CREATE','ALTER')
FROM SYSOBJECTS A,SYSCOMMENTS   B
WHERE A.ID=B.ID  AND A.XTYPE='V'

2009.11.16
----------

1��TRUNCATE TABLE
�ڹ������벻�� Where �Ӿ�� Delete �����ͬ�����߾�ɾ�����е�ȫ���С��� TRUNCATE TABLE �� Delete �ٶȿ죬��ʹ�õ�ϵͳ��������־��Դ�١�

2009.10.18
----------

1��sql
   1.txt

2009.06.08
-----------

1��Trees-in-relational-databases
   http://gfilter.net/?Post=Trees-in-relational-databases
   save/Jonathan Holland - Trees in relational databases.htm

   --END