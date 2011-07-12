#!/usr/bin/sh
#######################################################
#
# ģ��: dbschema.sh
#
# ����: ����һ�����ݿ���������ȡ��Ӧ�Ľṹ�ű�
#
# ���� 1 = �û���/����[@ʵ����]
# ���� 2 = ����/��ͼ��(��ѡ)
#
# ���� Bing He
#
# �޸ļ�¼
# ���� �޸��� �޸�����
#
# 10/20/2003 Bing He ��ʼ��д
#
# 2009.07.31 yangjiandong
#
######################################################
######################################################
##-- �ֲ���������
lv_argc=0 #��������θ���
lv_loginfo="" #�������еĵ�¼��Ϣ
lv_table_name="" #�������еı�����Ϣ
lv_filename="" #������ļ���
lv_tab_number=0 #��Ҫ����ı�ĸ���
lv_sep='|' #�ָ���
lv_grid_str="\t" #����ľ����׵Ŀո�
lv_deal_table="" #��ǰ����ı�
lv_file_temp1="get_ddl.temp1" #��ʱ�ļ���
lv_file_temp2="get_ddl.temp2" #��ʱ�ļ���
lv_file_temp3="get_ddl.temp3" #��ʱ�ļ���
lv_file_tab_col="get_ddl.col1" #��ʱ�ļ���
lv_file_tab_con="get_ddl.con1" #��ʱ�ļ���
lv_file_col_con="get_ddl.con2" #��ʱ�ļ���
lv_file_tab_ind="get_ddl.ind1" #��ʱ�ļ���
lv_file_col_ind="get_ddl.ind2" #��ʱ�ļ���
####################################################
####################################################
##-- ����û��������Ȩ��
f_check_userid()
{
echo "
set echo off;
set heading off;
desc user_tables;
" | sqlplus ${lv_loginfo} < /dev/null
exit
#!
if [ "$?" -ne 0 ]
then
echo "Error:f_check_userid failed."
echo " Please check the username/passwd=[${lv_loginfo}]."
exit
fi
}
################################################
################################################
##-- �����Ƿ����
f_check_tablename()
{
echo "
set echo off;
set heading off;
spool ${lv_file_temp1};
select count(*) from user_tables where table_name='${lv_table_name}';
spool off;
" | sqlplus ${lv_loginfo} < /dev/null
exit
#!
if [ "$?" -ne 0 ]
then
echo "Error:f_check_tablename failed."
echo " Please check the [${lv_table_name}]."
exit
fi
lv_number=`cat ${lv_file_temp1}|grep -v "^SQL>"|grep -v "^$"|grep -v "rows selected"`
if [ ${lv_number} -eq 0 ]
then
echo "Error:f_check_tablenaem failed."
echo " Please check the table [${lv_table_name}]
in [${lv_loginfo}]."
exit
fi
}
################################################
################################################
##-- ��ʼ������ļ�
f_generate_file()
{
if [ ${lv_argc} -eq 1 ]
then
lv_str=`echo ${lv_loginfo}|cut -d"/" -f1|tr "[:upper:]" "[:lower:]"`
lv_str_main="Structure For User ${lv_str}"
else
lv_str=`echo ${lv_table_name}| tr "[:upper:]" "[:lower:]"`
lv_str_main="Structure For Table ${lv_str}"
fi
lv_filename_drop_index="${lv_str}.drop_index"
lv_filename_drop_foreign="${lv_str}.drop_foreign"
lv_filename_drop_table="${lv_str}.drop_table"
lv_filename_create_table="${lv_str}.create_table"
lv_filename_create_foreign="${lv_str}.create_foreign"
lv_filename="${lv_str}.sql"
rm -f ${lv_filename_drop_index}
rm -f ${lv_filename_drop_foreign}
rm -f ${lv_filename_drop_table}
rm -f ${lv_filename_create_table}
rm -f ${lv_filename_create_foreign}
rm -f ${lv_filename}

##--���ɻ�������
lv_str1="-------------------------------------"
echo "\n"${lv_str1} >> ${lv_filename_drop_index}
echo "--** ��һ��: ɾ������ **--" >> ${lv_filename_drop_index}
echo ${lv_str1}"\n" >> ${lv_filename_drop_index}

lv_str1="--------------------------------------"
echo "\n"${lv_str1} >> ${lv_filename_drop_foreign}
echo "--** �ڶ���: ɾ����� **--" >> ${lv_filename_drop_foreign}
echo ${lv_str1}"\n" >> ${lv_filename_drop_foreign}

lv_str1="---------------------------------------"
echo "\n"${lv_str1} >> ${lv_filename_drop_table}
echo "--** ������: ɾ���� **--" >> ${lv_filename_drop_table}
echo ${lv_str1}"\n" >> ${lv_filename_drop_table}

lv_str1="---------------------------------------"
echo "\n"${lv_str1} >> ${lv_filename_create_table}
echo "--** ���Ĳ�: ������ṹ,����,����**--" >> ${lv_filename_create_table}
echo ${lv_str1} >> ${lv_filename_create_table}

lv_str1="---------------------------------------"
echo "\n"${lv_str1} >> ${lv_filename_create_foreign}
echo "--** ���岽: ������� **--" >> ${lv_filename_create_foreign}
echo ${lv_str1}"\n" >> ${lv_filename_create_foreign}

lv_str1="---------------------------------------"
echo "\n"${lv_str1} >> ${lv_filename}
echo "--** DESC :${lv_str_main}" >> ${lv_filename}
echo "--** AUTHOR:Bing He" >> ${lv_filename}
echo "--** DATE :20`date +%y-%m-%d`" >> ${lv_filename}
echo ${lv_str1}"\n" >> ${lv_filename}
}
#########################################
#########################################
##-- ��ȡ�û��µı��б�
f_get_tables()
{
rm -f ${lv_file_temp1}
echo "
set colsep ${lv_sep};
set echo off;
set feedback off;
set heading off;
set pagesize 0;
set linesize 1000;
set numwidth 12;
set termout off;
set trimout on;
set trimspool on;
spool ${lv_file_temp1};
select table_name from user_tables;
spool off;
" | sqlplus ${lv_loginfo} </dev/null
exit
#!
if [ "$?" -ne 0 ] ; then
echo "Usage:f_get_tables failed."
exit
fi

if [ -f ${lv_file_temp1} ]
then
lv_table_name=`cat ${lv_file_temp1} |grep -v "^SQL>" 
| tr -d ' '| tr "[:lower:]" "[:upper:]"`
echo ${lv_table_name} > 1.out
else
echo "Error:f_get_tables failed.${lv_file_temp1} file not found!"
exit
fi
rm -f ${lv_file_temp1}
}
#################
##--  ���ɱ�Ļ����ṹ
f_generate_tab_column()
{
  lv_str1="------------------------------------------------------------------"
  lv_str2="--**Table: ${lv_deal_table}**--"                                     
  lv_str3="create table ${lv_deal_table} ("
  lv_str4=") tablespace \"${lv_tab_tablespace_name}\";"
  lv_col_name=""
  lv_col_nullable=""
  lv_col_data_type=""
  lv_col_data_length=""
  lv_col_data_precision=""
  lv_col_data_scale=""

  echo "\n\n"${lv_str1} >> ${lv_filename_create_table}
  echo ${lv_str2}       >> ${lv_filename_create_table}
  echo ${lv_str1}"\n" >> ${lv_filename_create_table}
  echo ${lv_str3}       >> ${lv_filename_create_table}
  lv_tab_col_rows=`wc -l ${lv_file_tab_col}`
  lv_index=1
  for lv_line_info in `cat ${lv_file_tab_col}|sed -e "s/ /\~/g"`
  do
    lv_col_name=`echo ${lv_line_info}|awk -F'|' '{print $2}'`
    lv_col_nullable=`echo ${lv_line_info}|awk -F'|' '{print $3}'`
    lv_col_data_type=`echo ${lv_line_info}|awk -F'|' '{print $4}'`
    lv_col_data_length=`echo ${lv_line_info}|awk -F'|' '{print $5}'`
    lv_col_data_precision=`echo ${lv_line_info}|awk -F'|' '{print $6}'`
    lv_col_data_scale=`echo ${lv_line_info}|awk -F'|' '{print $7}'`

    lv_str5=${lv_grid_str}${lv_col_name}${lv_grid_str}${lv_col_data_type}"("${lv_col_data_length}")"
    if [ ${lv_col_data_type} = "DATE" ]
    then
      lv_str5=${lv_grid_str}${lv_col_name}${lv_grid_str}${lv_col_data_type}
    fi
    if [ ${lv_col_data_type} = "LONG~RAW" ]
    then
      lv_str5=${lv_grid_str}${lv_col_name}${lv_grid_str}"LONG RAW"
    fi
    if [ ${lv_col_data_type} = "NUMBER" ]
    then
      if [ "X"${lv_col_data_precision} = "X" ] 
      then
        lv_str5=${lv_grid_str}${lv_col_name}${lv_grid_str}${lv_col_data_type}
      else
        lv_str5=${lv_grid_str}${lv_col_name}${lv_grid_str}${lv_col_data_type}"("${lv_col_data_precision}","${lv_col_data_scale}")"
      fi
    fi
    if [ ${lv_col_nullable} = 'N' ]
    then
       lv_str5=${lv_str5}${lv_grid_str}"NOT NULL"
    fi
    if [ ${lv_index} -eq ${lv_tab_col_rows} ]
    then
      #echo ${lv_str5}                   >> ${lv_filename} 
      echo ${lv_str5}                   >> ${lv_filename_create_table} 
    else
      #echo ${lv_str5}","                >> ${lv_filename} 
      echo ${lv_str5}","                >> ${lv_filename_create_table} 
    fi
    lv_index=`expr ${lv_index} + 1`
  done
  
  #echo ${lv_str4}       >> ${lv_filename}
  echo ${lv_str4}       >> ${lv_filename_create_table}
  #rm -f ${lv_file_tab_col}
}
################################################################################

################################################################################
##-- ��ñ���޶�
f_generate_tab_constraint()
{
  lv_constraint_name=""
  lv_constraint_type=""
  lv_r_constraint_name=""
  lv_search_condition=""
  lv_str1="alter table ${lv_deal_table} add constraint " 
  for lineinfo in `cat ${lv_file_tab_con}|sed -e "s/ /\~/g"`
  do
    lv_constraint_name=`echo ${lineinfo}|awk -F'|' '{print $1}'`
    lv_constraint_type=`echo ${lineinfo}|awk -F'|' '{print $2}'`
    lv_r_constraint_name=`echo ${lineinfo}|awk -F'|' '{print $3}'`
    lv_search_condition=`echo ${lineinfo}|awk -F'|' '{print $4}'`
    lv_str2=""
    #echo ${lv_search_condition}
    if [ ${lv_constraint_type} = "P" ]
    then
      sqlplus ${lv_loginfo} <<! > /dev/null
      set echo off;
      set heading off;
      spool ${lv_file_temp2}
      select position||'|'||column_name||'|' from user_cons_columns where table_name='${lv_deal_table}' and constraint_name='${lv_constraint_name}' order by position;
      spool off;
      exit
!
      cat ${lv_file_temp2}|grep -v "^SQL>"|grep -v "^$"|grep -v "rows selected" > ${lv_file_col_con}
      lv_col_rows=`wc -l ${lv_file_col_con}`
      lv_index=1
      for col_line in `cat ${lv_file_col_con}`
      do
        lv_str3=`echo ${col_line}|awk -F'|' '{print $2}'`
        if [ ${lv_index} -eq ${lv_col_rows} ]
        then
          lv_str2=${lv_str2}${lv_str3}
        else
          lv_str2=${lv_str2}${lv_str3}","
        fi
      lv_index=`expr ${lv_index} + 1` 
      done 
      lv_str2=${lv_str1}${lv_constraint_name}" primary key ("${lv_str2}");"
      echo ${lv_str2}              >> ${lv_filename_create_table}
    fi
    if [ ${lv_constraint_type} = "C" ]
    then
      lv_str2=${lv_str1}${lv_constraint_name}" check ("`echo ${lv_search_condition}|sed -e "s/\~/ /g"`");"
      echo ${lv_str2}              >> ${lv_filename_create_table}
    fi
    if [ ${lv_constraint_type} = "R" ]
    then
      #lv_str2=${lv_str1}${lv_constraint_name}" check ("`echo ${lv_search_condition}|sed -e "s/\~/ /g"`")"
      ##-- ��ȡ���������ֶ� --##
      sqlplus ${lv_loginfo} <<! > /dev/null
      set echo off;
      set heading off;
      spool ${lv_file_temp2}
      select position||'|'||column_name||'|' from user_cons_columns where table_name='${lv_deal_table}' and constraint_name='${lv_constraint_name}' order by position;
      spool off;
      exit
!
      cat ${lv_file_temp2}|grep -v "^SQL>"|grep -v "^$"|grep -v "rows selected" > ${lv_file_col_con}
      lv_col_rows=`wc -l ${lv_file_col_con}`
      lv_index=1
      for col_line in `cat ${lv_file_col_con}`
      do
        lv_str3=`echo ${col_line}|awk -F'|' '{print $2}'`
        if [ ${lv_index} -eq ${lv_col_rows} ]
        then
          lv_str2=${lv_str2}${lv_str3}
        else
          lv_str2=${lv_str2}${lv_str3}","
        fi
      lv_index=`expr ${lv_index} + 1` 
      done 
      lv_str2="${lv_str1}${lv_constraint_name} foreign key (${lv_str2}) "

      ##--��ȡ������ֶ���Ϣ--##
      sqlplus ${lv_loginfo} <<! > /dev/null
      set echo off;
      set heading off;
      spool ${lv_file_temp3}
      select position||'|'||table_name||'|'||column_name from user_cons_columns where constraint_name='${lv_r_constraint_name}' order by position;
      spool off;
      exit
!
      cat ${lv_file_temp3}|grep -v "^SQL>"|grep -v "^$"|grep -v "rows selected" > ${lv_file_col_con}
      lv_col_rows=`wc -l ${lv_file_col_con}`
      lv_index=1
      lv_str4=""
      for col_line in `cat ${lv_file_col_con}`
      do
        if [ ${lv_index} -eq 1 ]
        then
          lv_str6=`echo ${col_line}|awk -F'|' '{print $2}'`
        fi
        lv_str5=`echo ${col_line}|awk -F'|' '{print $3}'`
        if [ ${lv_index} -eq ${lv_col_rows} ]
        then
          lv_str4=${lv_str4}${lv_str5}
        else
          lv_str4=${lv_str4}${lv_str5}","
        fi
        lv_index=`expr ${lv_index} + 1` 
      done 
      lv_str2="${lv_str2} references ${lv_str6} (${lv_str4});"
      echo "alter table ${lv_deal_table} drop constraint ${lv_constraint_name};" >> ${lv_filename_drop_foreign}
      echo ${lv_str2}              >> ${lv_filename_create_foreign}
    fi
    #echo ${lv_str2}              >> ${lv_filename}
    #echo ${lv_str2}              >> ${lv_filename_create_table}
  done
}
################################################################################
################################################################################
##-- ��ȡ���������Ϣ
f_generate_tab_index()
{
  lv_tab_ind_name=""
  lv_tab_ind_uniqueness=""
  lv_tab_ind_tablespace=""
  for lineinfo in `cat ${lv_file_tab_ind}`
  do
    lv_tab_ind_name=`echo ${lineinfo}|awk -F'|' '{print $1}'`
    lv_tab_ind_uniqueness=`echo ${lineinfo}|awk -F'|' '{print $2}'`
    lv_tab_ind_tablespace=`echo ${lineinfo}|awk -F'|' '{print $3}'`
    lv_str2=""
    sqlplus ${lv_loginfo} <<! > /dev/null
    set echo off;
    set heading off;
    spool ${lv_file_temp2}
    select column_position||'|'||column_name||'|'||descend from user_ind_columns where table_name='${lv_deal_table}' and index_name='${lv_tab_ind_name}' order by column_position;
    spool off;
    exit
!
    cat ${lv_file_temp2}|grep -v "^SQL>"|grep -v "^$"|grep -v "rows selected" > ${lv_file_col_ind}
    lv_col_rows=`wc -l ${lv_file_col_ind}`
    lv_index=1
    for col_line in `cat ${lv_file_col_ind}`
    do
      lv_str3=`echo ${col_line}|awk -F'|' '{print $2}'`
      lv_str4=`echo ${col_line}|awk -F'|' '{print $3}'`
      if [ ${lv_index} -eq ${lv_col_rows} ]
      then
        lv_str2=${lv_str2}${lv_str3}" "${lv_str4}
      else
        lv_str2=${lv_str2}${lv_str3}" "${lv_str4}","
      fi
      lv_index=`expr ${lv_index} + 1` 
    done
    if [ ${lv_tab_ind_uniqueness} = "NONUNIQUE" ]
    then
      lv_str2="create index ${lv_tab_ind_name} on ${lv_deal_table} ("${lv_str2}") tablespace \"${lv_tab_ind_tablespace}\";"
    else
      lv_str2="create ${lv_tab_ind_uniqueness} index ${lv_tab_ind_name} on ${lv_deal_table} ("${lv_str2}") tablespace \"${lv_tab_ind_tablespace}\";"
    fi
    #echo ${lv_str2}                        >> ${lv_filename}
    echo "drop index ${lv_tab_ind_name};" >> ${lv_filename_drop_index}
    echo ${lv_str2}                         >> ${lv_filename_create_table}
  done
}
################################################################################
################################################################################
##-- ��ȡ�������Ϣ,�������ָ���ļ���
f_get_tab_info()
{
  lv_tab_tablespace_name=""
  lv_tab_initial_extent=""
  lv_tab_next_extent=""
  lv_tab_min_extents=""
  lv_tab_max_extents=""
  lv_tab_pct_increase=""
    
  ##*************************************************************##
  ##��ȡuser_table�б����Ϣ
  sqlplus ${lv_loginfo} <<! > /dev/null
  set echo off;
  set heading off;
  spool ${lv_file_temp1}
  select tablespace_name||'|'||initial_extent||'|'||next_extent||'|'||min_extents||'|'||max_extents||'|'||pct_increase||'|' from user_tables where table_name='${lv_deal_table}';
  spool off;
  exit
!
  lv_str=`cat ${lv_file_temp1} |grep -v "^SQL>" | grep -v "rows selected"|tr -d ' '`
  lv_tab_tablespace_name=`echo ${lv_str}|awk -F'|' '{print $1}'`
  lv_tab_initial_extent=`echo ${lv_str}|awk -F'|' '{print $2}'`
  lv_tab_next_extents=`echo ${lv_str}|awk -F'|' '{print $3}'`
  lv_tab_min_extents=`echo ${lv_str}|awk -F'|' '{print $4}'`
  lv_tab_max_extents=`echo ${lv_str}|awk -F'|' '{print $5}'`
  lv_tab_pct_increase=`echo ${lv_str}|awk -F'|' '{print $6}'`

  ##*************************************************************##
  ##��ȡuser_tab_columns����Ϣ

  rm -f ${lv_file_temp1}
  sqlplus ${lv_loginfo} <<! > /dev/null
  set echo off;
  set heading off;
  spool ${lv_file_temp1}
  select column_id||'|'||column_name||'|'||nullable||'|'||data_type||'|'||data_length||'|'||data_precision||'|'||data_scale||'|' from user_tab_columns where table_name='${lv_deal_table}' order by column_id;
  spool off;
  exit
!
  cat ${lv_file_temp1}|grep -v "^SQL>"|grep -v "^$"|grep -v "rows selected" > ${lv_file_tab_col}

  f_generate_tab_column

  rm -f ${lv_file_temp1}
  rm -f ${lv_file_tab_col}

  ##*************************************************************##

  ##*************************************************************##
  ##��ȡuser_constraints����Ϣ
  ##*************************************************************##
  rm -f ${lv_file_temp1}
  sqlplus ${lv_loginfo} <<! > /dev/null
  set colsep ${lv_sep};
  set echo off;
  set feedback off;
  set heading off;
  set pagesize 0;
  set linesize 1000;
  set numwidth 12;
  set termout off;
  set trimout on;
  set trimspool on;
  spool ${lv_file_temp1};
  select constraint_name,constraint_type,r_constraint_name,search_condition from user_constraints where table_name='${lv_deal_table}' and generated='USER NAME' order by constraint_type;
  spool off;
  exit
!
  cat ${lv_file_temp1}|grep -v "^SQL>"|grep -v "^$"|grep -v "rows selected"|sed "s/$/\|/g" |sed -e "s/ *\|/\|/g" > ${lv_file_tab_con}

  if [ -s ${lv_file_tab_con} ]
  then
    f_generate_tab_constraint
  fi

  rm -f ${lv_file_temp1}
  rm -f ${lv_file_tab_con}

  ##*************************************************************##
  ##��ȡuser_indexes����Ϣ
  ##*************************************************************##
  rm -f ${lv_file_temp1}
  sqlplus ${lv_loginfo} <<! > /dev/null
  set colsep ${lv_sep};
  set echo off;
  set feedback off;
  set heading off;
  set pagesize 0;
  set linesize 1000;
  set numwidth 12;
  set termout off;
  set trimout on;
  set trimspool on;
  spool ${lv_file_temp1};
  select index_name,uniqueness,tablespace_name from user_indexes where table_name='${lv_deal_table}' and index_name not in(select constraint_name from user_constraints where table_name='${lv_deal_table}');
  spool off;
  exit
!
  cat ${lv_file_temp1}|grep -v "^SQL>"|grep -v "^$"|grep -v "rows selected"|sed "s/$/\|/g" |sed -e "s/ *\|/\|/g" > ${lv_file_tab_ind}

  if [ -s ${lv_file_tab_ind} ]
  then
    f_generate_tab_index
  fi

  rm -f ${lv_file_temp1}
  rm -f ${lv_file_temp2}
  rm -f ${lv_file_temp3}
  rm -f ${lv_file_tab_col}
  rm -f ${lv_file_col_con}
  rm -f ${lv_file_tab_ind}
  rm -f ${lv_file_col_ind}

}
################################################################################
################################################################################
##-- �������¼
lv_argc=$#
case ${lv_argc} in
 1 )
lv_loginfo=`echo $1| tr  "[:lower:]" "[:upper:]"`
f_check_userid
f_get_tables
f_generate_file
        ;;
 2 )
lv_loginfo=`echo $1| tr  "[:upper:]" "[:lower:]"`
lv_table_name=`echo $2| tr  "[:lower:]" "[:upper:]"`
f_check_userid
f_check_tablename
f_generate_file
        ;;
 * )
echo "Usage:$0 username/passwd[@sid] [tablename]"
echo "      username/passwd[@sid] ��¼��/����[@ʵ����]"
echo "      tablename             [����]"
echo "      ��[]�ı�ʾ��ѡ"
exit
        ;;
esac

##ɾ�������Ϣ����
for lv_deal_table in ${lv_table_name}
do
  echo "drop table ${lv_deal_table} cascade constraints;" >> ${lv_filename_drop_table}
  lv_tab_number=`expr ${lv_tab_number} + 1`
done

##׼������
lv_tab_index=1
for lv_deal_table in ${lv_table_name}
do
  echo "[${lv_tab_index}/${lv_tab_number}]:${lv_deal_table}"
  f_get_tab_info
  lv_tab_index=`expr ${lv_tab_index} + 1`
done

##�ۺ�����

##--ɾ������
cat ${lv_filename_drop_index} >> ${lv_filename}

##--ɾ�����
cat ${lv_filename_drop_foreign} >> ${lv_filename}

##--ɾ��ɾ����
cat ${lv_filename_drop_table} >> ${lv_filename}

##--������,����,����
cat ${lv_filename_create_table} >> ${lv_filename}

##--�������
cat ${lv_filename_create_foreign} >> ${lv_filename}

rm -f ${lv_filename_drop_index}
rm -f ${lv_filename_drop_foreign}
rm -f ${lv_filename_drop_table}
rm -f ${lv_filename_create_table}
rm -f ${lv_filename_create_foreign}
