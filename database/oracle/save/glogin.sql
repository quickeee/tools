--
-- Copyright (c) 1988, 2004, Oracle Corporation.  All Rights Reserved.
--
-- NAME
--   glogin.sql
--
-- DESCRIPTION
--   SQL*Plus global login "site profile" file
--
--   Add any SQL*Plus commands here that are to be executed when a
--   user starts SQL*Plus, or uses the SQL*Plus CONNECT command
--
-- USAGE
--   This script is automatically run
--

-- Used by Trusted Oracle
COLUMN ROWLABEL FORMAT A15

-- Used for the SHOW ERRORS command
COLUMN LINE/COL FORMAT A8
COLUMN ERROR    FORMAT A65  WORD_WRAPPED

-- Used for the SHOW SGA command
COLUMN name_col_plus_show_sga FORMAT a24
COLUMN units_col_plus_show_sga FORMAT a15
-- Defaults for SHOW PARAMETERS
COLUMN name_col_plus_show_param FORMAT a36 HEADING NAME
COLUMN value_col_plus_show_param FORMAT a30 HEADING VALUE

-- Defaults for SHOW RECYCLEBIN
COLUMN origname_plus_show_recyc   FORMAT a16 HEADING 'ORIGINAL NAME'
COLUMN objectname_plus_show_recyc FORMAT a30 HEADING 'RECYCLEBIN NAME'
COLUMN objtype_plus_show_recyc    FORMAT a12 HEADING 'OBJECT TYPE'
COLUMN droptime_plus_show_recyc   FORMAT a19 HEADING 'DROP TIME'

-- Defaults for SET AUTOTRACE EXPLAIN report
-- These column definitions are only used when SQL*Plus
-- is connected to Oracle 9.2 or earlier.
COLUMN id_plus_exp FORMAT 990 HEADING i
COLUMN parent_id_plus_exp FORMAT 990 HEADING p
COLUMN plan_plus_exp FORMAT a60
COLUMN object_node_plus_exp FORMAT a8
COLUMN other_tag_plus_exp FORMAT a29
COLUMN other_plus_exp FORMAT a44

-- Default for XQUERY
COLUMN result_plus_xquery HEADING 'Result Sequence'

--��ʾ��ǰ���뮔ǰ�r�g
set time on
--Ӌ��SQL����ʹ�Õr�g
set timi on
--�O���Ќ�20
col colname format a20

set colsep' ';
--������ָ���

set echo off;
--��ʾstart�����Ľű��е�ÿ��sql���ȱʡΪon

--set feedback off;
--���Ա���sql�����ļ�¼������ȱʡΪon

--set heading off;
--�������⣬ȱʡΪon

set pagesize 0;
--���ÿҳ������ȱʡΪ24,Ϊ�˱����ҳ�����趨Ϊ0��

set linesize 80;
--���һ���ַ�������ȱʡΪ80

set numwidth 12;
--���number�����򳤶ȣ�ȱʡΪ10

set termout off;
--��ʾ�ű��е������ִ�н����ȱʡΪon

--set timing off;
--��ʾÿ��sql����ĺ�ʱ��ȱʡΪoff

set trimout on;
--ȥ����׼���ÿ�е���β�ո�ȱʡΪoff

set trimspool on;
--ȥ���ض���spool�����ÿ�е���β�ո�ȱʡΪoff
