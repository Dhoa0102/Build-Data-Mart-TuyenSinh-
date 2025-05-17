-- 1.1. stg_ThiSinh: sheet “ThiSinh”
CREATE TABLE Dim_ThiSinh (
  CCCD       VARCHAR(20)   primary key,
  Van        DECIMAL(5,2)  NULL,
  Toan       DECIMAL(5,2)  NULL,
  Su         DECIMAL(5,2)  NULL,
  Dia        DECIMAL(5,2)  NULL,
  TA         DECIMAL(5,2)  NULL
);
-- 1.2. stg_TuyenSinh: sheet “TuyenSinh”
CREATE TABLE Dim_TuyenSinh (
  Ma_nganh          VARCHAR(20)  primary key,
  Chi_Tieu_TS       INT          NULL,
  Diem_XetTuyen     DECIMAL(5,2) NULL,
  C00               BIT          NULL,
  D01               BIT          NULL,
  D09               BIT          NULL,
  D10               BIT          NULL,
  D15               BIT          NULL
);
-- 1.3. stg_NguyenVong: sheet “NguyenVong”
CREATE TABLE Dim_NguyenVong (
  MaNguyenVong int IDENTITY(1,1) PRIMARY KEY,
  CCCD               VARCHAR(20)   Not Null,
  ThuTu_NguyenVong   INT           NOT NULL,
  Ma_nganh           VARCHAR(20)   NOT NULL,
);
CREATE TABLE Dim_ToHopMon (
  Ma_ToHop     VARCHAR(10)    primary key,  -- e.g. 'C00', 'D01'
  Mon1         VARCHAR(50)    NOT NULL,  -- ví dụ 'Van'
  Mon2         VARCHAR(50)    NOT NULL,  -- ví dụ 'Su'
  Mon3         VARCHAR(50)    NOT NULL   -- ví dụ 'Dia'
);

CREATE TABLE Fact_XetTuyen (
  ScoreID       INT IDENTITY(1,1) PRIMARY KEY,
  
  -- Các foreign key đến dimension
  CCCD          VARCHAR(20) NOT NULL  
                   REFERENCES Dim_ThiSinh(CCCD),
  Ma_nganh        VARCHAR(20) NOT NULL  
                   REFERENCES Dim_TuyenSinh(Ma_nganh),
	MaNguyenVong int references Dim_NguyenVong(MaNguyenVong),
	DiemNguyenVong decimal(5,2) ,
	ToHopTrungTuyen varchar(20),
	TrangThaiTrungTuyen int
);
select * from Dim_TuyenSinh
select * from Fact_XetTuyen inner join  on Dim_NguyenVong.

select Ma_ToHop, COUNT(Fact_XetTuyen.TrangThaiTrungTuyen) as ThiSinhXetToHop, Sum(Fact_XetTuyen.TrangThaiTrungTuyen) as ThiSinhDauToHop
from Fact_XetTuyen inner join ToHop on ToHop.Ma_ToHop=Fact_XetTuyen.ToHopTrungTuyen
group by Ma_ToHop

group by Ma_nganh

SELECT Ma_nganh,Min(DiemNguyenVong) AS DiemChuan
FROM Fact_XetTuyen
WHERE TrangThaiTrungTuyen = 1
GROUP BY Ma_nganh;

select Ma_nganh, max(DiemNguyenVong), min(DiemNguyenVong), avg(DiemNguyenVong) from Fact_XetTuyen where TrangThaiTrungTuyen=1
group by Ma_nganh
select Ma_nganh, 
case 
max(DiemNguyenVong), min(DiemNguyenVong), avg(DiemNguyenVong) from Fact_XetTuyen where TrangThaiTrungTuyen=1
group by Ma_nganh







SELECT 
        ths.CCCD, 
        nv.MaNguyenVong, 
        nv.Ma_nganh,
		ts.Chi_Tieu_TS,
		ths.Dia,
		ths.Su,
		ths.TA,
		ths.Toan,
		ths.Van,
		ts.C00,
		ts.D01,
		ts.D09,
		ts.D10,
		ts.D15,
        ts.Diem_XetTuyen
    FROM Dim_NguyenVong nv
    JOIN Dim_ThiSinh ths ON nv.CCCD = ths.CCCD
    JOIN Dim_TuyenSinh ts ON ts.Ma_nganh= nv.Ma_nganh

	SELECT
    ths.CCCD,
    nv.MaNguyenVong,
    nv.Ma_nganh,
	nv.ThuTu_NguyenVong,
	ts.Chi_Tieu_TS,
    ths.Dia,
    ths.Su,
    ths.TA,      -- ngoại ngữ
    ths.Toan,
    ths.Van,
    ts.C00, ts.D01, ts.D09, ts.D10, ts.D15,
    ts.Diem_XetTuyen,

    -- đây là cột mới tính Diem_NguyenVong
    calc.Diem_NguyenVong

FROM Dim_NguyenVong nv
JOIN Dim_ThiSinh    ths ON nv.CCCD        = ths.CCCD
JOIN Dim_TuyenSinh  ts  ON ts.Ma_nganh    = nv.Ma_nganh

CROSS APPLY (
    SELECT MAX(score) AS Diem_NguyenVong
    FROM ( VALUES
        -- C00: Văn + Sử + Địa
        (CASE WHEN ts.C00 = 1 THEN ths.Van  + ths.Su  + ths.Dia ELSE NULL END),
        -- D01: Toán + Văn + Ngoại ngữ (TA)
        (CASE WHEN ts.D01 = 1 THEN ths.Toan + ths.Van + ths.TA  ELSE NULL END),
        -- D09: Toán + TA + Su
        (CASE WHEN ts.D09 = 1 THEN ths.Toan + ths.TA + ths.Su ELSE NULL END),
        -- D10: Toán + Địa + Anh
        (CASE WHEN ts.D10 = 1 THEN ths.Toan + ths.Dia + ths.TA ELSE NULL END),
        -- D15: Văn + Địa + Anh
        (CASE WHEN ts.D15 = 1 THEN ths.Van  + ths.Dia + ths.TA ELSE NULL END)
    ) AS scores(score)
) AS calc;

WITH Ranked AS (
    SELECT
        ths.CCCD, 
        nv.MaNguyenVong, 
        nv.Ma_nganh,
        nv.ThuTu_NguyenVong,
        ths.Dia, ths.Su, ths.TA, ths.Toan, ths.Van,
        ts.C00, ts.D01, ts.D09, ts.D10, ts.D15,
        ts.Chi_Tieu_TS,
        ts.Diem_XetTuyen,
        calc.Diem_NguyenVong,
        ROW_NUMBER() OVER (
            PARTITION BY nv.Ma_nganh
            ORDER BY calc.Diem_NguyenVong DESC,
                     nv.ThuTu_NguyenVong ASC
        ) AS rn
    FROM Dim_NguyenVong nv
    JOIN Dim_ThiSinh   ths ON nv.CCCD     = ths.CCCD
    JOIN Dim_TuyenSinh ts  ON ts.Ma_nganh = nv.Ma_nganh
    CROSS APPLY (
        SELECT MAX(score) AS Diem_NguyenVong
        FROM ( VALUES
            (CASE WHEN ts.C00 = 1 THEN ths.Van  + ths.Su  + ths.Dia ELSE NULL END),
            (CASE WHEN ts.D01 = 1 THEN ths.Toan + ths.Van + ths.TA  ELSE NULL END),
            (CASE WHEN ts.D09 = 1 THEN ths.Toan + ths.TA  + ths.Su ELSE NULL END),
            (CASE WHEN ts.D10 = 1 THEN ths.Toan + ths.Dia + ths.TA ELSE NULL END),
            (CASE WHEN ts.D15 = 1 THEN ths.Van  + ths.Dia + ths.TA ELSE NULL END)
        ) AS scores(score)
    ) AS calc
)
SELECT
    CCCD,
    MaNguyenVong,
    Ma_nganh,
    ThuTu_NguyenVong,
    Dia, Su, TA, Toan, Van,
    C00, D01, D09, D10, D15,
    Chi_Tieu_TS,
    Diem_XetTuyen,
    Diem_NguyenVong,
    CASE 
      WHEN Diem_NguyenVong > Diem_XetTuyen 
           AND rn <= Chi_Tieu_TS 
      THEN 1 ELSE 0 
    END AS TrungTuyen
FROM Ranked
ORDER BY Ma_nganh, rn;

CREATE LOGIN [NT Service\MSOLAP$DINHHOADEV] FROM WINDOWS;
ALTER SERVER ROLE [sysadmin] ADD MEMBER [NT Service\MSOLAP$DINHHOADEV];

-- Kiểm tra có login không
SELECT name, principal_id  
FROM sys.server_principals  
WHERE name = N'NT SERVICE\MSOLAP$DINHHOADEV';  
-- Kiểm tra đã là thành viên sysadmin chưa
SELECT rm.role_principal_id, rp.name AS role_name, mp.name AS member_name  
FROM sys.server_role_members rm  
JOIN sys.server_principals rp ON rm.role_principal_id = rp.principal_id  
JOIN sys.server_principals mp ON rm.member_principal_id = mp.principal_id  
WHERE rp.name = N'sysadmin'  
  AND mp.name = N'NT SERVICE\MSOLAP$DINHHOADEV';  

  IF NOT EXISTS (
    SELECT 1 
    FROM sys.server_principals 
    WHERE name = N'NT SERVICE\MSOLAP$DINHHOADEV'
)
    CREATE LOGIN [NT SERVICE\MSOLAP$DINHHOADEV] FROM WINDOWS;

IF NOT EXISTS (
    SELECT 1 
    FROM sys.server_role_members rm
    JOIN sys.server_principals p 
      ON rm.member_principal_id = p.principal_id
    WHERE rm.role_principal_id = SUSER_ID(N'sysadmin')
      AND p.name = N'NT SERVICE\MSOLAP$DINHHOADEV'
)
    ALTER SERVER ROLE [sysadmin] ADD MEMBER [NT SERVICE\MSOLAP$DINHHOADEV];


	WITH Ranked AS (
    SELECT
        ths.CCCD, 
        nv.MaNguyenVong, 
        nv.Ma_nganh,
        nv.ThuTu_NguyenVong,
        ths.Dia, ths.Su, ths.TA, ths.Toan, ths.Van,
        ts.C00, ts.D01, ts.D09, ts.D10, ts.D15,
        ts.Chi_Tieu_TS,
        ts.Diem_XetTuyen,
        calc.Diem_NguyenVong,
        calc.ToHop_TrungTuyen,
        ROW_NUMBER() OVER (
            PARTITION BY nv.Ma_nganh
            ORDER BY calc.Diem_NguyenVong DESC,
                     nv.ThuTu_NguyenVong ASC
        ) AS rn
    FROM Dim_NguyenVong nv
    JOIN Dim_ThiSinh   ths ON nv.CCCD     = ths.CCCD
    JOIN Dim_TuyenSinh ts  ON ts.Ma_nganh = nv.Ma_nganh
    CROSS APPLY (
        SELECT TOP 1
            score      AS Diem_NguyenVong,
            tohop      AS ToHop_TrungTuyen
        FROM ( VALUES
            (CASE WHEN ts.C00 = 1 THEN ths.Van  + ths.Su  + ths.Dia ELSE NULL END, 'C00'),
            (CASE WHEN ts.D01 = 1 THEN ths.Toan + ths.Van + ths.TA  ELSE NULL END, 'D01'),
            (CASE WHEN ts.D09 = 1 THEN ths.Toan + ths.TA  + ths.Su  ELSE NULL END, 'D09'),
            (CASE WHEN ts.D10 = 1 THEN ths.Toan + ths.Dia + ths.TA  ELSE NULL END, 'D10'),
            (CASE WHEN ts.D15 = 1 THEN ths.Van  + ths.Dia + ths.TA  ELSE NULL END, 'D15')
        ) AS scores(score, tohop)
        WHERE score IS NOT NULL
        ORDER BY score DESC
    ) AS calc
)
SELECT
    CCCD,
    MaNguyenVong,
    Ma_nganh,
    ThuTu_NguyenVong,
    Dia, Su, TA, Toan, Van,
    C00, D01, D09, D10, D15,
    Chi_Tieu_TS,
    Diem_XetTuyen,
    Diem_NguyenVong,
    ToHop_TrungTuyen,
    CASE 
      WHEN Diem_NguyenVong > Diem_XetTuyen 
           AND rn <= Chi_Tieu_TS 
      THEN 1 ELSE 0 
    END AS TrungTuyen
FROM Ranked
ORDER BY Ma_nganh, rn;

-- new etl
WITH Ranked AS (
    SELECT
        ths.CCCD, 
        nv.MaNguyenVong, 
        nv.Ma_nganh,
        nv.ThuTu_NguyenVong,
        ths.Dia, ths.Su, ths.TA, ths.Toan, ths.Van,
        ts.C00, ts.D01, ts.D09, ts.D10, ts.D15,
        ts.Chi_Tieu_TS,
        ts.Diem_XetTuyen,
        calc.Diem_NguyenVong,
        calc.ToHop_TrungTuyen,
        ROW_NUMBER() OVER (
            PARTITION BY nv.Ma_nganh
            ORDER BY calc.Diem_NguyenVong DESC,
                     nv.ThuTu_NguyenVong ASC
        ) AS rn
    FROM Dim_NguyenVong nv
    JOIN Dim_ThiSinh   ths ON nv.CCCD     = ths.CCCD
    JOIN Dim_TuyenSinh ts  ON ts.Ma_nganh = nv.Ma_nganh
    CROSS APPLY (
        SELECT TOP 1
            score      AS Diem_NguyenVong,
            tohop      AS ToHop_TrungTuyen
        FROM ( VALUES
            (CASE WHEN ts.C00 = 1 THEN ths.Van  + ths.Su  + ths.Dia ELSE NULL END, 'C00'),
            (CASE WHEN ts.D01 = 1 THEN ths.Toan + ths.Van + ths.TA  ELSE NULL END, 'D01'),
            (CASE WHEN ts.D09 = 1 THEN ths.Toan + ths.TA  + ths.Su  ELSE NULL END, 'D09'),
            (CASE WHEN ts.D10 = 1 THEN ths.Toan + ths.Dia + ths.TA  ELSE NULL END, 'D10'),
            (CASE WHEN ts.D15 = 1 THEN ths.Van  + ths.Dia + ths.TA  ELSE NULL END, 'D15')
        ) AS scores(score, tohop)
        WHERE score IS NOT NULL
        ORDER BY score DESC
    ) AS calc
)
SELECT
    CCCD,
    MaNguyenVong,
    Ma_nganh,
    ThuTu_NguyenVong,
    Dia, Su, TA, Toan, Van,
    C00, D01, D09, D10, D15,
    Chi_Tieu_TS,
    Diem_XetTuyen,
    Diem_NguyenVong,
    ToHop_TrungTuyen,
    CASE 
      WHEN Diem_NguyenVong <= Diem_XetTuyen 
      THEN 1 ELSE 0 
    END AS TrungTuyen
FROM Ranked
ORDER BY Ma_nganh, rn;
