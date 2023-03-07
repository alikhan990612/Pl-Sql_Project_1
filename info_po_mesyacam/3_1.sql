select
	p01 FIO_NAIM,
	p02 PROP,
	p03 ULICA_NAIM,
	p04 DOM,
	p05 KV,
	to_number(p06) NACH_HV,
	to_number(p07) NACH_KAN,
	to_number(p08) NACH_ALL,
	to_number(p09) OPL_ALL,
	to_number(p10) PER_ALL,
	to_number(p11) NA_KONEC_ALL,
	to_number(p12) NA_NACHALO_ALL,
          p13 MESYAC,
          p14 DAT_N,
          p15 DAT_N,
          to_number(p16) TEK_NACHALO_ALL,
          to_number(p17) TEK_KONEC_ALL
from table(jasper.jasper_table(
'
begin                         -- Запускаю процедуру передав параметры. dat_n = '01.01.2021', dat_k = '01.05.2021'
INFO_PO_MESYACAM_L_SH(to_date('''||$P{P_DAT_N}||''',''dd.mm.rrrr''),to_date('''||$P{P_DAT_K}||''',''dd.mm.rrrr''),to_number('''||$P{P_L_SH}||'''),'''||$P{P_USER_NAME}||''');
end;
',
'
select                         -- После выполнения собираю данные. Сначала беру данные за все месяца. Потом через left из этой же временной таблицы беру данные за тек.месяц
a.FIO_NAIM,
   a.PROP,
   a.ULICA_NAIM,
   a.DOM,
   a.KV,
   a.NACH_HV,
   a.NACH_KAN,
   a.NACH_ALL,
   a.OPL_ALL,
   a.PER_ALL,
   a.NA_KONEC_ALL,
   a.NA_NACHALO_ALL,
   a.MESYAC,
   to_char(a.DAT_N,''yyyy'') DAT_N,
   a.DAT_N DAT_N1,
   b.TEK_NACHALO_ALL,
   b.TEK_KONEC_ALL
from
(
select
   FIO_NAIM,
   PROP,
   ULICA_NAIM,
   DOM,
   KV,
   NACH_HV,
   NACH_KAN,
   NACH_ALL,
   OPL_ALL,
   PER_ALL,
   NA_KONEC_ALL,
   NA_NACHALO_ALL,
   MESYAC,
   DAT_N,
   L_SH
from WG_INFO_PO_MESYACAM_L_SH
where MESYAC is not null
order by DAT_N
) a
left join
(
Select
  L_SH,
  NA_NACHALO_ALL  TEK_NACHALO_ALL,
  NA_KONEC_ALL  TEK_KONEC_ALL
from WG_INFO_PO_MESYACAM_L_SH
where mesyac is null
) b on b.L_SH = a.L_SH
order by DAT_N1
'))