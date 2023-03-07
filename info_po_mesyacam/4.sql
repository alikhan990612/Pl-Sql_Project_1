declare 
	a_call varchar2(2000);
	user_name varchar2(30);
	
begin	
	if 
  	:b4.v_l_sh_4 is null 
  then
    message('Введите лицевой счет');
    message('Введите лицевой счет');
    raise form_trigger_failure; 
  end if;
	select user into user_name from dual;
  message('Идет формирование...',NO_ACKNOWLEDGE);
  
  SET_APPLICATION_PROPERTY(CURSOR_STYLE,'BUSY');
  
  if
    get_const(102)is not null
  then
     -- Передаю параметры через программу. После этого на программе джаспер будут формироваться отчет.
     -- get_const(102,1) это айпи адрес компьютера. Айпи адрес запустится в браузере передавая параметры на джаспер. После этого формируется отчет

    a_call:='start "" "'||akbulak.get_const(102,1)||'akbulak/INFO_PO_MESYACAM_L_SH&_repFormat=pdf&_dataSource='||get_const(102,2)
            ||'&P_DAT_N='||to_char(:b4.v_dat_n_4, 'dd.mm.rrrr')
            ||'&P_DAT_K='||to_char(last_day(:b4.v_dat_k_4)+1, 'dd.mm.rrrr')
            ||'&P_L_SH='||to_char(:b4.v_l_sh_4)
            ||'&P_USER_NAME='||user_name
            ||'"';
            
    host(a_call, NO_SCREEN);
    
    message('Формирование выполнено. Запуск отчета...');
     
  else
    message('Нет интеграции с  Jasper отчетом!');
    message('Нет интеграции с  Jasper отчетом!');
    raise form_trigger_failure;
  end if;
  
  
	SET_APPLICATION_PROPERTY(CURSOR_STYLE,'DEFAULT');
end;
