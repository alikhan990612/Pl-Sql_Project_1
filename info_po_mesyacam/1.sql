-- Создаю временню таблицу. Куда через цикл буду заполнять данные
CREATE GLOBAL TEMPORARY TABLE WG_INFO_PO_MESYACAM_L_SH
(
  FIO_NAIM        VARCHAR2(500 BYTE),
  PROP            NUMBER,
  ULICA_NAIM      VARCHAR2(150 BYTE),
  DOM             VARCHAR2(20 BYTE),
  KV              VARCHAR2(10 BYTE),
  NACH_HV         NUMBER,
  NACH_KAN        NUMBER,
  NACH_ALL        NUMBER,
  OPL_ALL         NUMBER,
  PER_ALL         NUMBER,
  NA_KONEC_ALL    NUMBER,
  NA_NACHALO_ALL  NUMBER,
  MESYAC          VARCHAR2(10 BYTE),
  DAT_N           DATE,
  L_SH            NUMBER
)
ON COMMIT DELETE ROWS
NOCACHE;

--Даю грант на user JASPRI.Потому что все отчеты формируется под этим пользователем 

GRANT DELETE, SELECT, UPDATE ON WG_INFO_PO_MESYACAM_L_SH TO JASPRI;
