CREATE OR REPLACE procedure AKBULAK.INFO_PO_MESYACAM_L_SH
(
v_dat_n date,--передаю параметры     (Даты в рамках который должнен сформироваться отчет)
v_dat_k date,
v_l_sh number,                     --(Лицевой счет абонента)
v_user_name spr_t$user.n_user%type --(Название пользователя)
) is
i number;
dat_n date;
dat_k date;
dat date;
dat_tek date;
begin
    dat_k:= v_dat_k;                            -- Переменная dat_k это конец месяца
    dat_n:= add_months(last_day(v_dat_n)+1,-1); -- dat_n начало месяца(формат должет быть как 01.mm.yyyy.То есть должен брать только начало месяца)
    i:= months_between(dat_k,dat_n);            -- Нахожу разницу промежутка. Если dat_n = '01.01.2021', dat_k = '01.05.2021'. i = 4
    dat:= dat_n;                                -- dat это у нас начало каждого следующего месяца. Если конец даты = 01.05.2021 и начало даты = 01.01.2021, тогда dat -> 01.01.2021, 01.02.2021, до 01.05.2021. Май не входит 
    delete from AKBULAK.WG_INFO_PO_MESYACAM_L_SH; -- удаляю записи из временной таблицы
    loop                                          --создаю цикл где i = 4
    delete from wk_g$dat;                         --это тоже временная таблица. Здесь указываем дату месяца
    insert into wk_g$dat (dat_n, dat_k, chto,kassa)
    values (dat, (last_day(dat)+1), 956,v_user_name);
    insert into AKBULAK.WG_INFO_PO_MESYACAM_L_SH   -- Заполняю нашу временную таблицу через select 
    select 
      a.FIO_NAIM ,
      a.PROP,
      a.ULICA_NAIM ,
      a.DOM ,
      a.kV ,
      b.NACH_HV ,
      b.NACH_KAN ,
      (b.NACH_KAN  + b.NACH_HV) NACH_ALL,
      (b.OPL_HV + b.OPL_KAN) OPL_ALL,
      (b.PER_HV + b.PER_KAN) PER_ALL,
      (b.saldo_k_KAN + b.saldo_k_HV) NA_KONEC_ALL,
      (b.saldo_n_HV + b.saldo_n_KAN) NA_NACHALO_ALL,
      (case 
      when to_char(dat,'mm') = '01' then 'Янв'
      when to_char(dat,'mm') = '02' then 'Фев'
      when to_char(dat,'mm') = '03' then 'Мар'
      when to_char(dat,'mm') = '04' then 'Апр'
      when to_char(dat,'mm') = '05' then 'Май'
      when to_char(dat,'mm') = '06' then 'Июн'
      when to_char(dat,'mm') = '07' then 'Июл'
      when to_char(dat,'mm') = '08' then 'Авг'
      when to_char(dat,'mm') = '09' then 'Сен'
      when to_char(dat,'mm') = '10' then 'Окт'
      when to_char(dat,'mm') = '11' then 'Ноя'
      when to_char(dat,'mm') = '12' then 'Дек' 
      end) mesyac,
      to_date(dat,'dd.mm.rrrr') DAT_N,
      a.l_sh L_SH
      from  WV_DATA_l_sh  a
      left join WV_DATA_usl b on b.l_sh = a.l_sh    
      where a.l_sh = v_l_sh;
        i:= i-1;                                 -- Теперь i = 3
        dat:=last_day(dat)+1;                    -- Если в начале dat = '01.01.2021', Теперь dat = '01.02.2021'
        exit when i=0;                           -- Выхожу из цикла когда  i = 0
    end loop;                                    -- Таким образом Заполняю временную таблицу от января до мая. Май не входит
    dat_tek := raschet.last_data;                -- После цикла указываю текущую дату. 
    delete from wk_g$dat;                        -- Удаляю старые даты. Потом заолняю текущими датами
    insert into wk_g$dat(dat_n, dat_k ,chto,kassa) values(dat_tek, last_day(dat_tek)+1, 956,v_user_name);
    insert into AKBULAK.WG_INFO_PO_MESYACAM_L_SH  -- Беру записи из текущего месяца
    select 
      null FIO_NAIM ,
      null PROP,
      null ULICA_NAIM ,
      null DOM ,
      null KV ,
      null NACH_HV ,
      null NACH_KAN ,
      null NACH_ALL,
      null OPL_ALL,
      null PER_ALL,
      b.saldo_k NA_KONEC_ALL,
      b.saldo_n NA_NACHALO_ALL,
      null mesyac,
      null DAT_N,
      a.l_sh
      from  WV_DATA_l_sh  a
      left join WV_DATA_usl b on b.l_sh = a.l_sh   
      Where a.l_sh = v_l_sh;
end;
/
