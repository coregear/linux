#若尚未退出mysql服务器，直接使用如下命令添加root用户

insert into user set user='root',ssl_cipher='',x509_issuer='',x509_subject='';  

update user set Host='localhost',select_priv='y', insert_priv='y',update_priv='y', Alter_priv='y',delete_priv='y',create_priv='y',drop_priv='y',reload_priv='y',shutdown_priv='y',Process_priv='y',file_priv='y',grant_priv='y',References_priv='y',index_priv='y',create_user_priv='y',show_db_priv='y',super_priv='y',create_tmp_table_priv='y',Lock_tables_priv='y',execute_priv='y',repl_slave_priv='y',repl_client_priv='y',create_view_priv='y',show_view_priv='y',create_routine_priv='y',alter_routine_priv='y',create_user_priv='y' where user='root';  

#若当前已退出mysql服务器，则杀死当前mysql进程，绕过授权表进入mysql服务器添加用户，之后再正常启动。

#killall mysqld
#mysqld_safe --skip-grant-tables &
#/usr/local/mysql/bin/mysql
