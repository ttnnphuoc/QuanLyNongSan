USE [QLCUNGUNG]
GO
/****** Object:  StoredProcedure [dbo].[HangTonKho]    Script Date: 4/22/2020 3:05:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[HangTonKho]

AS
BEGIN
	create table #Temp1(
		MaSP int,
		SoLuong int
	)

	create table #Temp2(
		MaSP int,
		SoLuong int
	)

	insert into #Temp2(MaSP,SoLuong) select MaSP, sum(SoLuong) as SoLuong from chitietdonhangxuat group by MaSP

	insert into #Temp1(MaSP,SoLuong) select MaSP, sum(SoLuong) as SoLuong from CHITIETDONHANGNHAP group by MaSP


	select SANPHAM.TenSP, #Temp1.MaSP,#Temp1.SoLuong as SLN,#Temp2.SoLuong as SLX,  (#Temp1.SoLuong - #temp2.SoLuong) as SoLuongConLai
	from #Temp1 
	left join #temp2 on #temp1.MaSP = #temp2.MaSP 
	left join SANPHAM on SANPHAM.MaSP = #Temp1.MaSP
	where (#Temp1.SoLuong - #temp2.SoLuong) > 0 order by   #Temp1.MaSP

END

GO
/****** Object:  StoredProcedure [dbo].[sp_FindDonHangNhap]    Script Date: 4/22/2020 3:05:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_FindDonHangNhap] @maLoaiSP NVARCHAR(Max)
AS
BEGIN TRY
  select nv.Hoten,'' as TenDL, ct.MaDHN as MaDHX,ct.TrangThai as TrangThai, '' as TenTram,ct.SoLuong, sp.TenSP,ncc.TenNhaCC, lsp.TenLoai, sp.MaSP,dhn.ThoiGian, dhn.PhuongTien from DONHANGNHAP dhn
		left join CHITIETDONHANGNHAP ct on dhn.MaDHN = ct.MaDHN
		left join SANPHAM sp on sp.MaSP = ct.MaSP
		left join LOAISANPHAM lsp on lsp.MaLoai = sp.MaLoai
		left join NHANVIEN nv on nv.MaNV = dhn.MaNV
		left join NHACUNGCAP ncc on ncc.MaNCC = sp.MaNCC
		
		where dhn.MaDHN = @maLoaiSP and ct.isXoa = 0 and dhn.isXoa = 0 and sp.isXoa = 0 and lsp.isXoa = 0 and ncc.isXoa = 0 and nv.isXoa = 0
END TRY

BEGIN CATCH 
   PRINT 'There was an error. Check to make sure object exists.'
   PRINT error_message()
END CATCH 
GO
/****** Object:  StoredProcedure [dbo].[sp_FindDonHangNhapTonKho]    Script Date: 4/22/2020 3:05:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_FindDonHangNhapTonKho] @maSP NVARCHAR(Max)
AS
BEGIN TRY
  select nv.Hoten,'' as TenDL, ct.MaDHN as MaDHX,ct.TrangThai as TrangThai, '' as TenTram,ct.SoLuong, sp.TenSP,ncc.TenNhaCC, lsp.TenLoai, sp.MaSP,dhn.PhuongTien,dhn.ThoiGian
		from CHITIETDONHANGNHAP ct
		left join DONHANGNHAP dhn on dhn.MaDHN = ct.MaDHN
		left join SANPHAM sp on sp.MaSP = ct.MaSP
		left join LOAISANPHAM lsp on lsp.MaLoai = sp.MaLoai
		left join NHANVIEN nv on nv.MaNV = dhn.MaNV
		left join NHACUNGCAP ncc on ncc.MaNCC = sp.MaNCC
		
		where ct.MaSP = @maSP and ct.isXoa = 0 and dhn.isXoa = 0 and sp.isXoa = 0 and lsp.isXoa = 0 and ncc.isXoa = 0 and nv.isXoa = 0
END TRY

BEGIN CATCH 
   PRINT 'There was an error. Check to make sure object exists.'
   PRINT error_message()
END CATCH 
GO
/****** Object:  StoredProcedure [dbo].[sp_FindDonHangXuat]    Script Date: 4/22/2020 3:05:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_FindDonHangXuat] @maLoaiSP NVARCHAR(Max)
AS
BEGIN TRY
  select nv.Hoten,dl.Ten as TenDL, ct.MaDHX,lv.TrangThai, t.TenTram,ct.SoLuong, sp.TenSP,ncc.TenNhaCC, lsp.TenLoai, sp.MaSP,dhx.PhuongTien, dhx.ThoiGian from DONHANGXUAT dhx
		left join CHITIETDONHANGXUAT ct on dhx.MaDHX = ct.MaDHX
		left join SANPHAM sp on sp.MaSP = ct.MaSP
		left join LOAISANPHAM lsp on lsp.MaLoai = sp.MaLoai
		left join LUUVET lv on lv.MaDHX = ct.MaDHX
		left join TRAM t on t.MaTram = lv.MaTram
		left join NHANVIEN nv on nv.MaNV = lv.MaNV
		left join NHACUNGCAP ncc on ncc.MaNCC = sp.MaNCC
		left join DAILY dl on dl.MaDL = dhx.MaDaiLy
		where dhx.MaDHX = @maLoaiSP and lv.isXoa = 0 and ct.isXoa = 0 and dl.isXoa = 0 and dhx.isXoa = 0 and sp.isXoa = 0 and lsp.isXoa = 0 and ncc.isXoa = 0 and nv.isXoa = 0
END TRY

BEGIN CATCH 
   PRINT 'There was an error. Check to make sure object exists.'
   PRINT error_message()
END CATCH 
GO
/****** Object:  StoredProcedure [dbo].[sp_FindDonHangXuatTonKho]    Script Date: 4/22/2020 3:05:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_FindDonHangXuatTonKho] @maSP NVARCHAR(Max)
AS
BEGIN TRY
  select nv.Hoten,dl.Ten as TenDL, ct.MaDHX,lv.TrangThai, t.TenTram,ct.SoLuong, sp.TenSP,ncc.TenNhaCC, lsp.TenLoai, sp.MaSP,dhx.PhuongTien, dhx.ThoiGian from CHITIETDONHANGXUAT  ct
		left join DONHANGXUAT dhx on dhx.MaDHX = ct.MaDHX
		left join SANPHAM sp on sp.MaSP = ct.MaSP
		left join LOAISANPHAM lsp on lsp.MaLoai = sp.MaLoai
		left join LUUVET lv on lv.MaDHX = ct.MaDHX
		left join TRAM t on t.MaTram = lv.MaTram
		left join NHANVIEN nv on nv.MaNV = lv.MaNV
		left join NHACUNGCAP ncc on ncc.MaNCC = sp.MaNCC
		left join DAILY dl on dl.MaDL = dhx.MaDaiLy
		where sp.MaSP = @maSP and lv.isXoa = 0 and ct.isXoa = 0 and dl.isXoa = 0 and dhx.isXoa = 0 and sp.isXoa = 0 and lsp.isXoa = 0 and ncc.isXoa = 0 and nv.isXoa = 0
END TRY

BEGIN CATCH 
   PRINT 'There was an error. Check to make sure object exists.'
   PRINT error_message()
END CATCH 
GO
/****** Object:  StoredProcedure [dbo].[sp_FindLoaiSanPham]    Script Date: 4/22/2020 3:05:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_FindLoaiSanPham] @maLoaiSP NVARCHAR(Max)
AS

BEGIN TRY
  select nv.Hoten,dl.Ten as TenDL, ct.MaDHX,lv.TrangThai, t.TenTram,ct.SoLuong, sp.TenSP,ncc.TenNhaCC, lsp.TenLoai,sp.MaSP from LOAISANPHAM lsp
		left join SANPHAM sp on sp.MaLoai = lsp.MaLoai
		left join CHITIETDONHANGXUAT ct on sp.MaSP = ct.MaSP
		left join LUUVET lv on lv.MaDHX = ct.MaDHX
		left join TRAM t on t.MaTram = lv.MaTram
		left join NHANVIEN nv on nv.MaNV = lv.MaNV
		left join NHACUNGCAP ncc on ncc.MaNCC = sp.MaNCC
		left join DONHANGXUAT dhx on dhx.MaDHX = ct.MaDHX
		left join DAILY dl on dl.MaDL = dhx.MaDaiLy
		where lsp.MaLoai = @maLoaiSP and lv.isXoa = 0 and ct.isXoa = 0 and dhx.isXoa = 0 and sp.isXoa = 0 and lsp.isXoa = 0 and ncc.isXoa = 0 and nv.isXoa = 0 and dl.isXoa = 0
END TRY

BEGIN CATCH 
   PRINT 'There was an error. Check to make sure object exists.'
   PRINT error_message()
END CATCH 
GO
/****** Object:  StoredProcedure [dbo].[sp_FindNhaCC]    Script Date: 4/22/2020 3:05:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_FindNhaCC] @ma NVARCHAR(Max)
AS

BEGIN TRY
  select nv.Hoten,ct.MaDHN as MaDHX,ct.TrangThai, ct.SoLuong, sp.TenSP,ncc.TenNhaCC, lsp.TenLoai, sp.MaSP from NHACUNGCAP ncc
  		left join DONHANGNHAP dhn on dhn.MaNhaCC = ncc.MaNCC
		left join CHITIETDONHANGNHAP ct on dhn.MaDHN = ct.MaDHN
		left join SANPHAM sp on sp.MaSP = ct.MaSP
		left join NHANVIEN nv on nv.MaNV = dhn.MaNV
		left join LOAISANPHAM lsp on lsp.MaLoai = sp.MaLoai
		where ncc.MaNCC = @ma and ct.isXoa = 0 and sp.isXoa = 0 and lsp.isXoa = 0 and ncc.isXoa = 0 and nv.isXoa = 0
END TRY

BEGIN CATCH 
   PRINT 'There was an error. Check to make sure object exists.'
   PRINT error_message()
END CATCH 
GO
/****** Object:  StoredProcedure [dbo].[sp_FindNhanVien]    Script Date: 4/22/2020 3:05:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_FindNhanVien] @maNV NVARCHAR(Max)
AS

BEGIN TRY
  select nv.Hoten,dl.Ten as TenDL, ct.MaDHX,lv.TrangThai, t.TenTram,ct.SoLuong, sp.TenSP,ncc.TenNhaCC, lsp.TenLoai, sp.MaSP from LUUVET lv 
		left join TRAM t on t.MaTram = lv.MaTram
		left join CHITIETDONHANGXUAT ct on lv.MaDHX=ct.MaDHX
		left join DONHANGXUAT dhx on dhx.MaDHX = ct.MaDHX
		left join SANPHAM sp on sp.MaSP = ct.MaSP
		left join LOAISANPHAM lsp on lsp.MaLoai = sp.MaLoai
		left join NHACUNGCAP ncc on sp.MaNCC = ncc.MaNCC
		left join NHANVIEN nv on nv.MaNV = dhx.MaNV
		left join DAILY dl on dl.MaDL = dhx.MaDaiLy
		where nv.MaNV = @maNV and lv.isXoa = 0 and ct.isXoa = 0 and dhx.isXoa = 0 and sp.isXoa = 0 and lsp.isXoa = 0 and ncc.isXoa = 0 and nv.isXoa = 0 and dl.isXoa = 0
END TRY

BEGIN CATCH 
   PRINT 'There was an error. Check to make sure object exists.'
   PRINT error_message()
END CATCH 
GO
/****** Object:  StoredProcedure [dbo].[sp_FindSanPham]    Script Date: 4/22/2020 3:05:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_FindSanPham] @maSP NVARCHAR(Max)
AS

BEGIN TRY
  select nv.Hoten,dl.Ten as TenDL, ct.MaDHX,lv.TrangThai, t.TenTram,ct.SoLuong, sp.TenSP,ncc.TenNhaCC, lsp.TenLoai , sp.MaSP from SANPHAM sp
		left join CHITIETDONHANGXUAT ct on sp.MaSP = ct.MaSP
		left join LUUVET lv on lv.MaDHX = ct.MaDHX
		left join TRAM t on t.MaTram = lv.MaTram
		left join NHANVIEN nv on nv.MaNV = lv.MaNV
		left join NHACUNGCAP ncc on ncc.MaNCC = sp.MaNCC
		left join DONHANGXUAT dhx on dhx.MaDHX = ct.MaDHX
		left join DAILY dl on dl.MaDL = dhx.MaDaiLy
		left join LOAISANPHAM lsp on lsp.MaLoai = sp.MaLoai
		where sp.MaSP = @maSP and lv.isXoa = 0 and ct.isXoa = 0 and dhx.isXoa = 0 and sp.isXoa = 0 and lsp.isXoa = 0 and ncc.isXoa = 0 and nv.isXoa = 0 and dl.isXoa = 0
END TRY

BEGIN CATCH 
   PRINT 'There was an error. Check to make sure object exists.'
   PRINT error_message()
END CATCH 
GO
/****** Object:  StoredProcedure [dbo].[sp_FindStringInTable]    Script Date: 4/22/2020 3:05:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_FindStringInTable] @stringToFind NVARCHAR(Max), @schema sysname, @table sysname 
AS

BEGIN TRY
   DECLARE @sqlCommand NVARCHAR(max) = 'SELECT * FROM [' + @schema + '].[' + @table + '] WHERE ' 

   SELECT @sqlCommand = @sqlCommand + '[' + COLUMN_NAME + '] LIKE N''%' + @stringToFind+ '%'' OR '
   FROM INFORMATION_SCHEMA.COLUMNS 
   WHERE TABLE_SCHEMA = @schema
   AND TABLE_NAME = @table 
   --AND DATA_TYPE IN ('char','nchar','ntext','nvarchar','text','varchar')
   
   print @sqlCommand

   SET @sqlCommand = left(@sqlCommand,len(@sqlCommand)-3)
   EXEC (@sqlCommand)
   
   
END TRY

BEGIN CATCH 
   PRINT 'There was an error. Check to make sure object exists.'
   PRINT error_message()
END CATCH 
GO
/****** Object:  Table [dbo].[CHITIETDONHANGNHAP]    Script Date: 4/22/2020 3:05:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHITIETDONHANGNHAP](
	[MaDHN] [int] NOT NULL,
	[MaSP] [int] NOT NULL,
	[SoLuong] [int] NULL,
	[TrangThai] [nvarchar](50) NULL,
	[isXoa] [bit] NULL,
 CONSTRAINT [PK_CHITIETDONHANGNHAP] PRIMARY KEY CLUSTERED 
(
	[MaDHN] ASC,
	[MaSP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CHITIETDONHANGXUAT]    Script Date: 4/22/2020 3:05:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHITIETDONHANGXUAT](
	[MaDHX] [int] NOT NULL,
	[MaSP] [int] NOT NULL,
	[SoLuong] [int] NULL,
	[isXoa] [bit] NULL,
 CONSTRAINT [PK_CHITIETDONHANGXUAT_1] PRIMARY KEY CLUSTERED 
(
	[MaDHX] ASC,
	[MaSP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DAILY]    Script Date: 4/22/2020 3:05:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DAILY](
	[MaDL] [int] IDENTITY(1,1) NOT NULL,
	[MaLoai] [int] NULL,
	[Ten] [nvarchar](50) NULL,
	[SoDT] [varchar](50) NULL,
	[DiaChi] [nvarchar](500) NULL,
	[isXoa] [bit] NULL,
 CONSTRAINT [PK_DAILY] PRIMARY KEY CLUSTERED 
(
	[MaDL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DONHANGNHAP]    Script Date: 4/22/2020 3:05:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DONHANGNHAP](
	[MaDHN] [int] IDENTITY(1,1) NOT NULL,
	[MaNhaCC] [int] NOT NULL,
	[NgayNhap] [datetime] NULL,
	[MaNV] [int] NULL,
	[isXoa] [bit] NULL,
	[ThoiGian] [int] NULL,
	[PhuongTien] [nvarchar](500) NULL,
 CONSTRAINT [PK_DONHANGNHAP] PRIMARY KEY CLUSTERED 
(
	[MaDHN] ASC,
	[MaNhaCC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DONHANGXUAT]    Script Date: 4/22/2020 3:05:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DONHANGXUAT](
	[MaDHX] [int] IDENTITY(1,1) NOT NULL,
	[MaDaiLy] [int] NOT NULL,
	[MaNV] [int] NULL,
	[TrangThai] [bit] NULL,
	[isXoa] [bit] NULL,
	[ThoiGian] [int] NULL,
	[PhuongTien] [nvarchar](500) NULL,
 CONSTRAINT [PK_DONHANGXUAT] PRIMARY KEY CLUSTERED 
(
	[MaDHX] ASC,
	[MaDaiLy] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LOAIDAILY]    Script Date: 4/22/2020 3:05:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOAIDAILY](
	[MaLoai] [int] IDENTITY(1,1) NOT NULL,
	[Cap] [int] NULL,
	[MucChietKhau] [nvarchar](50) NULL,
	[isXoa] [bit] NULL,
 CONSTRAINT [PK_LOAIDAILY] PRIMARY KEY CLUSTERED 
(
	[MaLoai] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LOAISANPHAM]    Script Date: 4/22/2020 3:05:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOAISANPHAM](
	[MaLoai] [int] IDENTITY(1,1) NOT NULL,
	[TenLoai] [nvarchar](50) NULL,
	[isXoa] [bit] NULL,
 CONSTRAINT [PK_LOAISANPHAM] PRIMARY KEY CLUSTERED 
(
	[MaLoai] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LUUVET]    Script Date: 4/22/2020 3:05:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LUUVET](
	[MaDHX] [int] NOT NULL,
	[MaTram] [int] NOT NULL,
	[MaNV] [int] NOT NULL,
	[TrangThai] [bit] NULL,
	[isXoa] [bit] NULL,
 CONSTRAINT [PK_LUUVET] PRIMARY KEY CLUSTERED 
(
	[MaDHX] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NHACUNGCAP]    Script Date: 4/22/2020 3:05:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NHACUNGCAP](
	[MaNCC] [int] IDENTITY(1,1) NOT NULL,
	[TenNhaCC] [nvarchar](50) NULL,
	[GhiChu] [nvarchar](50) NULL,
	[isXoa] [bit] NULL,
 CONSTRAINT [PK_NHACUNGCAP] PRIMARY KEY CLUSTERED 
(
	[MaNCC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NHANVIEN]    Script Date: 4/22/2020 3:05:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NHANVIEN](
	[MaNV] [int] IDENTITY(1,1) NOT NULL,
	[Hoten] [nvarchar](50) NULL,
	[Ngaysinh] [date] NULL,
	[Gioitinh] [bit] NULL,
	[Ngayvaolam] [date] NULL,
	[isXoa] [bit] NULL,
 CONSTRAINT [PK_NHANVIEN] PRIMARY KEY CLUSTERED 
(
	[MaNV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SANPHAM]    Script Date: 4/22/2020 3:05:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SANPHAM](
	[MaSP] [int] IDENTITY(1,1) NOT NULL,
	[MaLoai] [int] NULL,
	[MaNCC] [int] NULL,
	[TenSP] [nvarchar](50) NULL,
	[TrongLuong] [float] NULL,
	[ThoiHanSuDung] [smallint] NULL,
	[QuyCachDongGoi] [nvarchar](50) NULL,
	[Gia] [float] NULL,
	[Ghichu] [nvarchar](500) NULL,
	[isXoa] [bit] NULL,
	[ThoiGian] [nvarchar](500) NULL,
	[BaoQuan] [nvarchar](500) NULL,
 CONSTRAINT [PK_SANPHAM] PRIMARY KEY CLUSTERED 
(
	[MaSP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SQLGOIY]    Script Date: 4/22/2020 3:05:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SQLGOIY](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[NameTable] [nvarchar](50) NULL,
	[Name] [nvarchar](max) NULL,
	[SqlString] [nvarchar](max) NULL,
 CONSTRAINT [PK_SQLGOIY] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TAIKHOAN]    Script Date: 4/22/2020 3:05:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TAIKHOAN](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TaiKhoan] [nvarchar](50) NULL,
	[MatKhau] [nvarchar](50) NULL,
	[HoTen] [nvarchar](500) NULL,
	[ISADMIN] [bit] NULL,
 CONSTRAINT [PK_TAIKHOAN] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TRAM]    Script Date: 4/22/2020 3:05:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TRAM](
	[MaTram] [int] IDENTITY(1,1) NOT NULL,
	[TenTram] [nvarchar](50) NULL,
	[isXoa] [bit] NULL,
 CONSTRAINT [PK_TRAM] PRIMARY KEY CLUSTERED 
(
	[MaTram] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (1, 1, 50, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (1, 2, 300, N'', 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (2, 2, 200, N'1', 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (3, 3, 160, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (4, 4, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (5, 5, 500, N'1', 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (6, 6, 750, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (7, 7, 530, N'1', 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (8, 8, 150, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (9, 9, 230, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (10, 10, 150, N'1', 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (11, 11, 180, N'1', 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (12, 12, 175, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (13, 13, 500, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (14, 14, 50, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (15, 2, 10, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (15, 4, 10, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (15, 10, 10, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (15, 14, 10, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (16, 57, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (16, 68, 20, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (16, 77, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (17, 198, 15, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (17, 199, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (18, 92, 100, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (18, 93, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (18, 97, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (18, 101, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (18, 104, 30, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (19, 197, 23, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (19, 198, 23, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (20, 49, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (20, 68, 40, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (20, 76, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (20, 77, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (21, 49, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (21, 59, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (21, 77, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (22, 34, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (22, 41, 500, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (22, 45, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (22, 46, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (22, 47, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (23, 49, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (23, 59, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (23, 68, 15, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (24, 34, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (24, 45, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (24, 96, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (24, 127, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (25, 57, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (25, 72, 500, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (25, 76, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (25, 77, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (26, 2, 25, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (26, 4, 25, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (26, 6, 25, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (26, 14, 25, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (26, 16, 500, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (27, 41, 500, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (27, 119, 40, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (27, 139, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (27, 191, 40, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (27, 192, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (28, 33, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (28, 36, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (28, 44, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (28, 46, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (28, 170, 50, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (29, 197, 36, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (29, 198, 36, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (29, 199, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (30, 197, 22, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (30, 198, 22, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (31, 157, 33, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (31, 158, 33, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (31, 160, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (31, 161, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (32, 2, 20, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (32, 5, 20, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (32, 15, 20, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (32, 17, 20, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (32, 35, 500, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (33, 3, 15, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (33, 4, 15, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (33, 6, 15, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (33, 14, 15, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (33, 19, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (34, 15, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (34, 17, 370, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (34, 18, 500, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (34, 26, 150, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (34, 27, 220, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (35, 6, 14, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (35, 9, 14, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (35, 17, 14, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (35, 21, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (36, 198, 14, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (36, 199, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (37, 197, 22, NULL, 0)
GO
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (37, 198, 22, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (37, 199, 250, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (38, 20, 1000, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (38, 22, 1000, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (38, 23, 1000, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (38, 24, 1000, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (38, 25, 1000, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (38, 28, 1000, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (38, 30, 1000, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (38, 31, 1000, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (38, 32, 1000, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (39, 37, 780, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (39, 38, 780, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (39, 39, 780, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (39, 40, 780, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (39, 42, 780, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (39, 43, 780, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (39, 48, 780, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (39, 66, 780, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (39, 74, 780, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (40, 79, 890, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (40, 80, 890, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (40, 82, 890, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (40, 91, 890, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (40, 94, 890, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (40, 95, 890, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (40, 98, 890, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (40, 99, 890, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (40, 100, 890, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (41, 102, 650, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (41, 103, 650, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (41, 106, 650, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (41, 107, 650, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (41, 108, 650, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (41, 111, 650, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (41, 112, 650, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (41, 113, 650, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (41, 115, 650, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (42, 116, 550, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (42, 120, 550, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (42, 123, 550, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (42, 124, 550, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (42, 125, 550, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (42, 126, 550, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (42, 129, 550, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (42, 130, 550, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (42, 131, 550, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (43, 132, 420, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (43, 135, 420, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (43, 136, 420, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (43, 140, 420, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (43, 149, 420, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (43, 150, 420, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (43, 152, 420, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (43, 155, 420, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (43, 163, 420, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (44, 171, 339, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (44, 172, 339, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (44, 182, 339, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (44, 185, 339, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (44, 186, 339, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (44, 188, 339, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (44, 190, 339, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (44, 194, 339, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (44, 195, 339, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (44, 196, 339, NULL, 0)
INSERT [dbo].[CHITIETDONHANGNHAP] ([MaDHN], [MaSP], [SoLuong], [TrangThai], [isXoa]) VALUES (45, 200, 200, NULL, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (1, 7, 52, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (2, 2, 15, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (2, 9, 15, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (3, 66, 21, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (3, 115, 21, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (4, 34, 16, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (4, 48, 16, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (5, 35, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (5, 47, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (5, 49, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (5, 93, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (6, 39, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (6, 57, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (6, 68, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (6, 72, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (7, 185, 35, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (7, 188, 35, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (7, 190, 35, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (8, 5, 22, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (8, 7, 22, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (8, 10, 22, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (9, 6, 33, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (9, 8, 33, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (9, 10, 33, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (9, 11, 33, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (9, 12, 33, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (10, 17, 50, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (10, 25, 50, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (10, 26, 50, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (10, 30, 50, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (11, 6, 25, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (11, 10, 25, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (11, 11, 25, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (11, 16, 25, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (11, 19, 25, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (12, 115, 35, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (12, 124, 35, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (12, 129, 35, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (12, 131, 35, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (13, 2, 12, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (13, 16, 12, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (13, 18, 12, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (13, 21, 12, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (13, 34, 12, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (14, 17, 11, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (14, 35, 11, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (14, 48, 11, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (15, 6, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (15, 7, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (15, 18, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (15, 19, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (15, 21, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (16, 2, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (16, 18, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (16, 19, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (16, 22, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (17, 6, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (17, 22, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (17, 23, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (17, 25, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (18, 38, 24, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (18, 44, 24, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (18, 46, 24, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (18, 77, 24, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (19, 4, 21, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (19, 23, 21, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (19, 25, 21, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (19, 43, 21, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (19, 46, 21, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (19, 106, 21, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (20, 6, 24, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (20, 17, 24, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (20, 20, 24, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (20, 44, 24, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (20, 135, 24, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (20, 198, 24, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (21, 20, 60, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (21, 22, 60, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (21, 39, 60, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (21, 77, 60, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (21, 113, 60, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (22, 45, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (22, 47, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (22, 57, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (22, 72, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (22, 91, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (23, 20, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (23, 37, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (23, 40, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (23, 68, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (23, 72, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (24, 5, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (24, 7, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (24, 14, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (24, 17, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (25, 1, 40, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (25, 2, 40, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (25, 4, 40, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (25, 6, 40, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (25, 9, 40, 0)
GO
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (25, 12, 40, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (25, 14, 40, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (26, 1, 10, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (26, 3, 10, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (26, 5, 10, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (26, 6, 10, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (26, 8, 10, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (26, 12, 10, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (26, 15, 10, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (26, 16, 10, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (26, 18, 10, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (26, 19, 10, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (26, 22, 10, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (26, 43, 10, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (27, 2, 22, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (27, 6, 22, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (27, 19, 22, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (27, 20, 22, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (27, 23, 22, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (27, 25, 22, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (27, 31, 22, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (27, 40, 22, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (28, 7, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (28, 14, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (28, 17, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (28, 18, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (28, 23, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (28, 24, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (29, 76, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (29, 95, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (29, 97, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (29, 98, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (29, 101, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (29, 113, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (30, 7, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (30, 19, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (30, 27, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (30, 34, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (30, 40, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (30, 43, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (31, 4, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (31, 7, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (31, 18, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (31, 20, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (31, 24, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (31, 25, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (32, 6, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (32, 7, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (32, 9, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (32, 25, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (32, 92, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (32, 100, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (32, 124, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (33, 7, 10, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (33, 10, 10, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (33, 25, 10, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (33, 26, 10, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (34, 82, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (34, 108, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (34, 111, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (34, 120, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (34, 160, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (35, 31, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (35, 45, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (35, 47, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (35, 49, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (35, 95, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (36, 37, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (36, 39, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (36, 40, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (36, 92, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (36, 100, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (37, 7, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (37, 9, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (37, 23, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (37, 25, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (37, 30, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (37, 125, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (38, 6, 25, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (38, 18, 25, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (38, 20, 25, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (38, 21, 25, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (38, 23, 25, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (38, 33, 25, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (39, 46, 25, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (39, 49, 25, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (39, 74, 25, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (39, 79, 25, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (39, 91, 25, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (40, 22, 15, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (40, 34, 15, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (40, 36, 15, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (40, 38, 15, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (40, 41, 15, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (40, 44, 15, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (41, 6, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (41, 8, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (41, 21, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (41, 24, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (41, 25, 20, 0)
GO
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (41, 36, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (41, 38, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (42, 22, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (42, 39, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (42, 49, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (42, 59, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (42, 79, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (42, 94, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (43, 7, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (43, 21, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (43, 23, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (43, 24, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (43, 26, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (43, 27, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (43, 31, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (43, 38, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (44, 2, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (44, 17, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (44, 18, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (44, 19, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (45, 80, 35, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (45, 123, 35, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (45, 126, 35, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (45, 127, 35, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (46, 136, 37, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (46, 160, 37, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (46, 163, 37, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (46, 182, 37, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (47, 32, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (47, 42, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (47, 49, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (47, 97, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (47, 199, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (48, 13, 34, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (48, 25, 34, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (48, 36, 34, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (48, 72, 34, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (48, 77, 34, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (48, 101, 34, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (49, 96, 70, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (49, 130, 70, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (49, 131, 70, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (49, 132, 70, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (49, 135, 70, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (50, 2, 44, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (50, 31, 44, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (50, 35, 44, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (50, 45, 44, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (50, 48, 44, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (50, 57, 44, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (51, 30, 27, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (51, 149, 27, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (51, 185, 27, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (51, 190, 27, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (51, 198, 27, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (52, 6, 35, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (52, 11, 35, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (52, 35, 35, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (52, 38, 35, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (52, 40, 35, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (52, 72, 35, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (53, 6, 22, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (53, 8, 22, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (53, 37, 22, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (53, 170, 22, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (53, 195, 22, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (53, 198, 22, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (54, 5, 17, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (54, 18, 17, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (54, 25, 17, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (54, 96, 17, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (54, 152, 17, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (54, 157, 17, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (55, 130, 19, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (55, 152, 19, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (55, 171, 19, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (55, 194, 19, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (55, 199, 19, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (56, 120, 26, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (56, 136, 26, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (56, 158, 26, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (56, 161, 26, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (56, 185, 26, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (57, 31, 7, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (57, 92, 7, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (57, 93, 7, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (57, 186, 7, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (57, 194, 7, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (58, 59, 8, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (58, 66, 8, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (58, 72, 8, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (58, 77, 8, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (58, 125, 8, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (59, 22, 6, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (59, 36, 6, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (59, 80, 6, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (59, 103, 6, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (59, 106, 6, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (59, 199, 6, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (60, 3, 15, 0)
GO
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (60, 32, 15, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (60, 34, 15, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (60, 43, 15, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (60, 46, 15, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (61, 3, 40, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (61, 32, 40, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (61, 34, 40, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (61, 35, 40, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (62, 2, 19, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (62, 18, 19, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (62, 30, 19, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (62, 31, 19, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (62, 34, 19, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (63, 7, 50, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (63, 39, 50, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (63, 42, 50, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (63, 46, 50, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (63, 76, 50, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (63, 97, 50, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (64, 4, 9, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (64, 5, 9, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (64, 19, 9, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (64, 33, 9, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (64, 43, 9, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (64, 119, 9, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (64, 196, 9, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (65, 135, 6, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (65, 155, 6, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (65, 172, 6, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (65, 195, 6, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (65, 197, 6, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (66, 7, 37, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (66, 11, 37, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (66, 17, 37, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (66, 28, 37, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (66, 38, 37, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (66, 72, 37, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (66, 77, 37, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (67, 6, 60, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (67, 40, 60, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (67, 41, 60, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (67, 57, 60, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (67, 72, 60, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (68, 7, 44, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (68, 38, 44, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (68, 40, 44, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (68, 46, 44, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (68, 112, 44, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (68, 161, 44, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (69, 2, 55, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (69, 37, 55, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (69, 43, 55, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (69, 72, 55, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (69, 102, 55, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (70, 17, 35, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (70, 19, 35, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (70, 38, 35, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (70, 59, 35, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (70, 72, 35, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (70, 199, 35, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (71, 2, 9, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (71, 18, 9, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (71, 32, 9, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (71, 42, 9, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (71, 68, 9, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (71, 127, 9, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (72, 2, 32, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (72, 18, 32, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (72, 31, 32, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (72, 190, 32, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (73, 2, 7, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (73, 17, 7, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (73, 20, 7, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (73, 32, 7, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (73, 59, 7, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (74, 4, 36, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (74, 33, 36, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (74, 34, 36, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (74, 39, 36, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (74, 49, 36, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (74, 59, 36, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (74, 194, 36, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (75, 2, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (75, 3, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (75, 18, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (75, 30, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (75, 35, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (75, 115, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (75, 197, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (76, 6, 7, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (76, 41, 7, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (76, 76, 7, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (76, 135, 7, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (76, 157, 7, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (77, 3, 12, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (77, 38, 12, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (77, 40, 12, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (77, 44, 12, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (77, 99, 12, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (78, 7, 15, 0)
GO
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (78, 42, 15, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (78, 131, 15, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (78, 161, 15, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (78, 171, 15, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (79, 6, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (79, 8, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (79, 17, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (79, 172, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (79, 199, 20, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (80, 2, 16, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (80, 6, 16, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (80, 32, 16, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (80, 33, 16, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (80, 49, 16, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (80, 95, 16, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (81, 6, 6, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (81, 8, 6, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (81, 34, 6, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (81, 38, 6, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (81, 74, 6, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (81, 199, 6, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (82, 6, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (82, 9, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (82, 34, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (82, 35, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (82, 38, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (82, 140, 30, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (83, 6, 15, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (83, 17, 15, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (83, 41, 15, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (83, 45, 15, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (83, 46, 15, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (84, 19, 12, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (84, 57, 12, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (84, 74, 12, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (84, 191, 12, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (84, 198, 12, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (85, 6, 7, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (85, 20, 7, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (85, 22, 7, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (85, 23, 7, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (85, 199, 7, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (86, 2, 16, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (86, 20, 16, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (86, 38, 16, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (86, 39, 16, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (86, 40, 16, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (86, 106, 16, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (87, 3, 9, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (87, 15, 9, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (87, 17, 9, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (87, 20, 9, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (87, 199, 9, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (88, 6, 22, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (88, 30, 22, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (88, 33, 22, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (88, 38, 22, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (88, 186, 22, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (88, 198, 22, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (89, 6, 6, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (89, 35, 6, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (89, 37, 6, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (89, 49, 6, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (89, 190, 6, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (89, 197, 6, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (89, 199, 6, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (90, 6, 22, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (90, 35, 22, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (90, 43, 22, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (90, 74, 22, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (90, 77, 22, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (90, 197, 22, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (91, 24, 16, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (91, 25, 16, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (91, 28, 16, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (91, 38, 16, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (91, 41, 16, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (91, 49, 16, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (91, 57, 16, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (92, 5, 11, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (92, 6, 11, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (92, 21, 11, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (92, 25, 11, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (92, 35, 11, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (92, 41, 11, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (93, 5, 6, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (93, 23, 6, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (93, 34, 6, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (93, 35, 6, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (93, 68, 6, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (93, 116, 6, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (94, 6, 9, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (94, 24, 9, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (94, 37, 9, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (94, 82, 9, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (94, 101, 9, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (94, 198, 9, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (95, 5, 17, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (95, 19, 17, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (95, 37, 17, 0)
GO
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (95, 43, 17, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (95, 95, 17, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (95, 127, 17, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (96, 6, 15, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (96, 47, 15, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (96, 92, 15, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (96, 93, 15, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (97, 3, 22, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (97, 25, 22, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (97, 35, 22, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (97, 38, 22, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (97, 40, 22, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (97, 72, 22, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (98, 6, 27, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (98, 23, 27, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (98, 34, 27, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (98, 37, 27, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (98, 40, 27, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (98, 131, 27, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (98, 195, 27, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (99, 6, 29, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (99, 25, 29, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (99, 26, 29, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (99, 40, 29, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (99, 72, 29, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (99, 102, 29, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (99, 150, 29, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (100, 2, 24, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (100, 3, 24, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (100, 24, 24, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (100, 30, 24, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (100, 101, 24, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (100, 106, 24, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (100, 107, 24, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (101, 6, 27, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (101, 25, 27, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (101, 37, 27, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (101, 38, 27, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (101, 59, 27, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (101, 197, 27, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (102, 192, 50, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (103, 93, 175, 0)
INSERT [dbo].[CHITIETDONHANGXUAT] ([MaDHX], [MaSP], [SoLuong], [isXoa]) VALUES (103, 139, 175, 0)
SET IDENTITY_INSERT [dbo].[DAILY] ON 

INSERT [dbo].[DAILY] ([MaDL], [MaLoai], [Ten], [SoDT], [DiaChi], [isXoa]) VALUES (1, 1, N'Hoa Quả Sấy Nguyên Vũ - Đà Lạt', N' 0977 844 909', N' CT4 Đỗ Nhuận, Xuân Đỉnh, Bắc Từ Liêm, Hà Nội (cạnh công viên Hòa Bình)', 0)
INSERT [dbo].[DAILY] ([MaDL], [MaLoai], [Ten], [SoDT], [DiaChi], [isXoa]) VALUES (2, 1, N'Đại lý hoa quả sấy Đà Lạt Farm', N'0977 554 663', N'68D, Bùi Thị Xuân, Phường 8 , TP.Đà Lạt, Lâm Đồng', 0)
INSERT [dbo].[DAILY] ([MaDL], [MaLoai], [Ten], [SoDT], [DiaChi], [isXoa]) VALUES (3, 3, N'Đại Lý Đặc Sản Mai Anh Đào
', N'0263 3553 695', N'263 Đường Mai Anh Đào, Phường 8, Thành phố Đà Lạt, Lâm Đồng', 0)
INSERT [dbo].[DAILY] ([MaDL], [MaLoai], [Ten], [SoDT], [DiaChi], [isXoa]) VALUES (4, 1, N'Đại Lý Trà Vĩnh Tiến
', N'091 846 55 66', N'1 Đường Trương Công Định, Phường 1, Tp. Đà Lạt, Lâm Đồng', 0)
INSERT [dbo].[DAILY] ([MaDL], [MaLoai], [Ten], [SoDT], [DiaChi], [isXoa]) VALUES (5, 2, N'Cơ Sở Mứt Đặc Sản Đà Lạt Anh Thư - Cẩm Tú', N'0263 3831 223', N'223 Đường Mai Anh Đào, Phường 8, Tp. Đà Lạt, Lâm Đồng', 0)
SET IDENTITY_INSERT [dbo].[DAILY] OFF
SET IDENTITY_INSERT [dbo].[DONHANGNHAP] ON 

INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (1, 1, CAST(0x0000AA9C00000000 AS DateTime), 1, 0, 2, N'Hàng Không')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (2, 1, CAST(0x0000AA9C00000000 AS DateTime), 1, 0, 2, N'Hàng Khôngggg')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (3, 1, CAST(0x0000AA9C00000000 AS DateTime), 16, 0, 2, N'Hàng Không')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (4, 2, CAST(0x0000AA9C00000000 AS DateTime), 1, 0, 2, N'Hàng Không')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (5, 2, CAST(0x0000AA9C00000000 AS DateTime), 1, 0, 2, N'Hàng Không')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (6, 2, CAST(0x0000AA9C00000000 AS DateTime), 8, 0, 2, N'Hàng Không')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (7, 2, CAST(0x0000AA9C00000000 AS DateTime), 1, 0, 2, N'Hàng Không')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (8, 2, CAST(0x0000AA9C00000000 AS DateTime), 1, 0, 2, N'Hàng Không')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (9, 3, CAST(0x0000AA9C00000000 AS DateTime), 6, 0, 2, N'Hàng Không')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (10, 3, CAST(0x0000AA9C00000000 AS DateTime), 1, 0, 2, N'Hàng Không')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (11, 3, CAST(0x0000AA9C00000000 AS DateTime), 1, 0, 2, N'Hàng Không')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (12, 3, CAST(0x0000AADB00000000 AS DateTime), 4, 0, 2, N'Hàng Không')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (13, 3, CAST(0x0000AADD00000000 AS DateTime), 11, 0, 2, N'Hàng Không')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (14, 2, CAST(0x0000A9D100000000 AS DateTime), 3, 0, 2, N'Hàng Không')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (15, 5, CAST(0x0000AB6900000000 AS DateTime), 1, 0, 2, N'Hàng Không')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (16, 6, CAST(0x0000AB7C00000000 AS DateTime), 15, 0, 5, NULL)
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (17, 7, CAST(0x0000AB7400000000 AS DateTime), 1, 0, 5, N'Xe đầu kéo, Container')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (18, 5, CAST(0x0000AB7600000000 AS DateTime), 14, 0, 5, N'Xe đầu kéo, Container')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (19, 7, CAST(0x0000AB7400000000 AS DateTime), 15, 0, 5, N'Xe đầu kéo, Container')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (20, 6, CAST(0x0000AB7600000000 AS DateTime), 11, 0, 5, N'Xe đầu kéo, Container')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (21, 6, CAST(0x0000AB6000000000 AS DateTime), 9, 0, 5, N'Xe đầu kéo, Container')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (22, 5, CAST(0x0000AB7500000000 AS DateTime), 17, 0, 5, N'Xe đầu kéo, Container')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (23, 6, CAST(0x0000AB8000000000 AS DateTime), 243, 0, 7, N'Tàu lửa')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (24, 5, CAST(0x0000AB5800000000 AS DateTime), 277, 0, 7, N'Tàu lửa')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (25, 6, CAST(0x0000AB7100000000 AS DateTime), 362, 0, 7, N'Tàu lửa')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (26, 2, CAST(0x0000AB6F00000000 AS DateTime), 379, 0, 7, N'Tàu lửa')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (27, 5, CAST(0x0000AB6D00000000 AS DateTime), 1, 0, 7, N'Tàu lửa')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (28, 5, CAST(0x0000AB7000000000 AS DateTime), 454, 0, 7, N'Tàu lửa')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (29, 7, CAST(0x0000AB7500000000 AS DateTime), 371, 0, 7, N'Tàu lửa')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (30, 7, CAST(0x0000AB7500000000 AS DateTime), 438, 0, 7, N'Tàu lửa')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (31, 5, CAST(0x0000AB7600000000 AS DateTime), 349, 0, 9, N'Xe máy')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (32, 1, CAST(0x0000AB7600000000 AS DateTime), 303, 0, 9, N'Xe máy')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (33, 1, CAST(0x0000AB7800000000 AS DateTime), 241, 0, 9, N'Xe máy')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (34, 1, CAST(0x0000AB7700000000 AS DateTime), 313, 0, 9, N'Xe máy')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (35, 1, CAST(0x0000AB6900000000 AS DateTime), 297, 0, 3, N'Xe Ôtô')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (36, 7, CAST(0x0000AB7D00000000 AS DateTime), 1, 0, 3, N'Xe Ôtô')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (37, 7, CAST(0x0000AB6900000000 AS DateTime), 326, 0, 3, N'Xe Ôtô')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (38, 3, CAST(0x0000AB8200000000 AS DateTime), 268, 0, 3, N'Xe Ôtô')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (39, 3, CAST(0x0000AB8B00000000 AS DateTime), 332, 0, 3, N'Xe Ôtô')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (40, 2, CAST(0x0000AB8200000000 AS DateTime), 310, 0, 3, N'Xe Ôtô')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (41, 4, CAST(0x0000AB8F00000000 AS DateTime), 416, 0, 3, N'Xe Khách')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (42, 1, CAST(0x0000AB9C00000000 AS DateTime), 315, 0, 3, N'Xe Khách')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (43, 2, CAST(0x0000AB9000000000 AS DateTime), 353, 0, 3, N'Xe Khách')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (44, 6, CAST(0x0000AB9900000000 AS DateTime), 407, 0, 3, N'Xe Khách')
INSERT [dbo].[DONHANGNHAP] ([MaDHN], [MaNhaCC], [NgayNhap], [MaNV], [isXoa], [ThoiGian], [PhuongTien]) VALUES (45, 4, CAST(0x0000AB8B00000000 AS DateTime), 326, 0, 3, N'Xe Máy')
SET IDENTITY_INSERT [dbo].[DONHANGNHAP] OFF
SET IDENTITY_INSERT [dbo].[DONHANGXUAT] ON 

INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (2, 3, 1, 0, 0, 4, N'Xe Ôtô')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (3, 1, 3, 1, 0, 3, N'Xe Ôtô')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (4, 3, 4, 0, 0, 3, N'Xe Ôtô')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (5, 3, 4, 1, 0, 3, N'Xe Ôtô')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (6, 2, 4, 0, 0, 3, N'Xe Ôtô')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (7, 3, 5, 1, 0, 3, N'Xe Ôtô')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (8, 2, 6, 0, 0, 5, N'Xe Ôtô')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (9, 2, 7, 0, 0, 5, N'Xe Ôtô')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (10, 3, 16, 1, 0, 5, N'Xe Ôtô')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (11, 4, 7, 0, 0, 5, N'Xe Ôtô')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (12, 4, 12, 1, 0, 5, N'Xe Ôtô')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (13, 3, 11, 0, 0, 5, N'Xe Ôtô')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (14, 3, 9, 0, 0, 5, N'Xe Ôtô')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (15, 3, 6, 1, 0, 5, N'Xe Ôtô')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (16, 1, 13, 0, 0, 5, N'Xe Ôtô')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (17, 2, 11, 0, 0, 5, N'Xe Ôtô')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (18, 4, 7, 1, 0, 5, N'Xe đầu kéo, Container')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (19, 4, 3, 0, 0, 5, N'Xe đầu kéo, Container')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (20, 5, 16, 0, 0, 5, N'Xe đầu kéo, Container')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (21, 3, 7, 1, 0, 5, N'Xe đầu kéo, Container')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (22, 4, 8, 0, 0, 5, N'Xe đầu kéo, Container')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (23, 3, 5, 1, 0, 5, N'Xe đầu kéo, Container')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (24, 3, 6, 0, 0, 5, N'Xe đầu kéo, Container')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (25, 5, 6, 1, 0, 5, N'Xe đầu kéo, Container')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (26, 4, 12, 0, 0, 5, N'Xe đầu kéo, Container')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (27, 3, 14, 0, 0, 5, N'Xe đầu kéo, Container')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (28, 4, 15, 1, 0, 5, N'Xe đầu kéo, Container')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (29, 3, 12, 0, 0, 5, N'Xe đầu kéo, Container')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (30, 4, 1, 0, 0, 5, N'Xe đầu kéo, Container')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (31, 3, 1, 1, 0, 9, N'Tàu lửa')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (32, 3, 11, 0, 0, 9, N'Tàu lửa')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (33, 4, 5, 0, 0, 9, N'Tàu lửa')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (34, 3, 15, 1, 0, 9, N'Tàu lửa')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (35, 4, 8, 0, 0, 6, N'Tàu lửa')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (36, 4, 10, 0, 0, 6, N'Tàu lửa')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (37, 3, 15, 1, 0, 6, N'Tàu lửa')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (38, 3, 1, 0, 0, 6, N'Tàu lửa')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (39, 3, 11, 1, 0, 6, N'Tàu lửa')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (40, 4, 16, 0, 0, 6, N'Tàu lửa')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (41, 2, 9, 0, 0, 6, N'Tàu lửa')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (42, 4, 7, 1, 0, 6, N'Tàu lửa')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (43, 2, 3, 0, 0, 6, N'Tàu lửa')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (44, 2, 267, 0, 0, 6, N'Tàu lửa')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (45, 3, 439, 1, 0, 6, N'Tàu lửa')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (46, 2, 455, 0, 0, 7, N'Xe đầu kéo, Container')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (47, 5, 449, 1, 0, 7, N'Xe đầu kéo, Container')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (48, 3, 372, 0, 0, 7, N'Xe đầu kéo, Container')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (49, 4, 409, 0, 0, 7, N'Xe đầu kéo, Container')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (50, 2, 363, 0, 0, 7, N'Xe đầu kéo, Container')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (51, 4, 366, 1, 0, 7, N'Xe đầu kéo, Container')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (52, 4, 373, 0, 0, 7, N'Xe đầu kéo, Container')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (53, 3, 370, 0, 0, 7, N'Xe đầu kéo, Container')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (54, 1, 453, 1, 0, 7, N'Xe đầu kéo, Container')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (55, 3, 240, 0, 0, 7, N'Xe đầu kéo, Container')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (56, 4, 391, 1, 0, 10, N'Xe Máy')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (57, 4, 355, 0, 0, 10, N'Xe Máy')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (58, 4, 444, 0, 0, 10, N'Xe Máy')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (59, 4, 447, 1, 0, 10, N'Xe Máy')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (60, 4, 429, 0, 0, 10, N'Xe Máy')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (61, 4, 392, 0, 0, 10, N'Xe Máy')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (62, 4, 427, 1, 0, 10, N'Xe Máy')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (63, 5, 382, 0, 0, 10, N'Xe Máy')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (64, 5, 421, 0, 0, 10, N'Xe Máy')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (65, 5, 450, 1, 0, 10, N'Xe Máy')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (66, 5, 328, 0, 0, 10, N'Xe Máy')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (67, 5, 402, 1, 0, 10, N'Xe Máy')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (68, 3, 288, 0, 0, 10, N'Xe Máy')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (69, 1, 343, 1, 0, 10, N'Xe Máy')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (70, 1, 351, 0, 0, 10, N'Xe Máy')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (71, 1, 442, 0, 0, 2, N'Tàu lửa')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (72, 1, 440, 1, 0, 2, N'Tàu lửa')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (73, 1, 453, 0, 0, 2, N'Tàu lửa')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (74, 1, 369, 1, 0, 2, N'Tàu lửa')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (75, 1, 386, 0, 0, 2, N'Tàu lửa')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (76, 1, 427, 0, 0, 2, N'Tàu lửa')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (77, 5, 385, 1, 0, 2, N'Tàu lửa')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (78, 5, 406, 0, 0, 2, N'Tàu lửa')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (79, 5, 336, 0, 0, 2, N'Tàu lửa')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (80, 1, 438, 1, 0, 2, N'Tàu lửa')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (81, 5, 339, 0, 0, 1, N'Hàng Không')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (82, 1, 381, 1, 0, 1, N'Hàng Không')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (83, 5, 448, 1, 0, 1, N'Hàng Không')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (84, 5, 277, 0, 0, 1, N'Hàng Không')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (85, 2, 446, 0, 0, 1, N'Hàng Không')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (86, 2, 299, 1, 0, 1, N'Hàng Không')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (87, 1, 443, 0, 0, 1, N'Hàng Không')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (88, 1, 256, 1, 0, 1, N'Hàng Không')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (89, 1, 351, 0, 0, 1, N'Hàng Không')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (90, 2, 317, 1, 0, 1, N'Hàng Không')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (91, 2, 439, 0, 0, 3, N'Xe Ôtô')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (92, 2, 384, 1, 0, 3, N'Xe Ôtô')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (93, 3, 397, 0, 0, 3, N'Xe Ôtô')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (94, 3, 276, 0, 0, 3, N'Xe Ôtô')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (95, 4, 314, 1, 0, 3, N'Xe Ôtô')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (96, 4, 443, 0, 0, 3, N'Xe Ôtô')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (97, 4, 277, 0, 0, 3, N'Xe Ôtô')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (98, 4, 333, 1, 0, 3, N'Xe Ôtô')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (99, 5, 282, 0, 0, 3, N'Xe Ôtô')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (100, 5, 247, 1, 0, 3, N'Xe Ôtô')
GO
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (101, 5, 364, 0, 0, 3, N'Xe Ôtô')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (102, 5, 1, 0, 0, 3, N'Xe Ôtô')
INSERT [dbo].[DONHANGXUAT] ([MaDHX], [MaDaiLy], [MaNV], [TrangThai], [isXoa], [ThoiGian], [PhuongTien]) VALUES (103, 2, 240, 0, 0, 9, N'Xe Máy')
SET IDENTITY_INSERT [dbo].[DONHANGXUAT] OFF
SET IDENTITY_INSERT [dbo].[LOAIDAILY] ON 

INSERT [dbo].[LOAIDAILY] ([MaLoai], [Cap], [MucChietKhau], [isXoa]) VALUES (1, 1, N'1000', 0)
INSERT [dbo].[LOAIDAILY] ([MaLoai], [Cap], [MucChietKhau], [isXoa]) VALUES (2, 2, N'850', 0)
INSERT [dbo].[LOAIDAILY] ([MaLoai], [Cap], [MucChietKhau], [isXoa]) VALUES (3, 3, N'750', 0)
SET IDENTITY_INSERT [dbo].[LOAIDAILY] OFF
SET IDENTITY_INSERT [dbo].[LOAISANPHAM] ON 

INSERT [dbo].[LOAISANPHAM] ([MaLoai], [TenLoai], [isXoa]) VALUES (1, N'Trà', 0)
INSERT [dbo].[LOAISANPHAM] ([MaLoai], [TenLoai], [isXoa]) VALUES (2, N'Trái cây thông dụng sấy', 0)
INSERT [dbo].[LOAISANPHAM] ([MaLoai], [TenLoai], [isXoa]) VALUES (3, N'Atiso', 0)
INSERT [dbo].[LOAISANPHAM] ([MaLoai], [TenLoai], [isXoa]) VALUES (4, N'Hạt, đậu', 0)
INSERT [dbo].[LOAISANPHAM] ([MaLoai], [TenLoai], [isXoa]) VALUES (5, N'Cà phê', 0)
INSERT [dbo].[LOAISANPHAM] ([MaLoai], [TenLoai], [isXoa]) VALUES (7, N'Trà Túi Lọc', 0)
INSERT [dbo].[LOAISANPHAM] ([MaLoai], [TenLoai], [isXoa]) VALUES (8, N'Bánh mứt đặc sản', 0)
INSERT [dbo].[LOAISANPHAM] ([MaLoai], [TenLoai], [isXoa]) VALUES (9, N'Trái Cây  Sấy Dẻo', 0)
INSERT [dbo].[LOAISANPHAM] ([MaLoai], [TenLoai], [isXoa]) VALUES (10, N'Trà Hòa Tan', 0)
INSERT [dbo].[LOAISANPHAM] ([MaLoai], [TenLoai], [isXoa]) VALUES (11, N'Thảo Mộc', 0)
INSERT [dbo].[LOAISANPHAM] ([MaLoai], [TenLoai], [isXoa]) VALUES (12, N'Trà sencha hoa', 0)
SET IDENTITY_INSERT [dbo].[LOAISANPHAM] OFF
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (1, 2, 1, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (2, 3, 2, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (3, 2, 3, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (4, 3, 4, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (5, 2, 4, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (6, 2, 4, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (7, 2, 5, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (8, 2, 6, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (9, 2, 7, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (10, 1, 16, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (11, 2, 7, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (12, 2, 12, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (13, 1, 11, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (14, 1, 9, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (15, 1, 6, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (16, 3, 13, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (17, 2, 11, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (18, 2, 7, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (19, 1, 3, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (20, 2, 16, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (21, 2, 7, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (22, 3, 8, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (23, 2, 5, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (24, 2, 6, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (25, 2, 6, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (26, 1, 12, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (27, 3, 14, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (28, 2, 15, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (29, 2, 12, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (30, 2, 1, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (31, 2, 1, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (32, 3, 11, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (33, 4, 5, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (34, 5, 15, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (35, 5, 8, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (36, 5, 10, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (37, 5, 15, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (38, 5, 1, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (39, 4, 11, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (40, 3, 16, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (41, 2, 9, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (42, 2, 7, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (43, 3, 3, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (44, 2, 267, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (45, 4, 439, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (46, 5, 455, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (47, 3, 449, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (48, 3, 372, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (49, 3, 409, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (50, 5, 363, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (51, 3, 366, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (52, 2, 373, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (53, 3, 370, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (54, 5, 453, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (55, 3, 240, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (56, 5, 391, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (57, 5, 355, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (58, 5, 444, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (59, 5, 447, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (60, 5, 429, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (61, 5, 392, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (62, 5, 427, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (63, 4, 382, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (64, 4, 421, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (65, 5, 450, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (66, 5, 328, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (67, 4, 402, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (68, 2, 288, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (69, 1, 343, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (70, 2, 351, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (71, 1, 442, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (72, 3, 440, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (73, 3, 453, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (74, 4, 369, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (75, 4, 386, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (76, 5, 427, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (77, 1, 385, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (78, 2, 406, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (79, 4, 336, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (80, 2, 438, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (81, 4, 339, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (82, 3, 381, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (83, 3, 448, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (84, 2, 277, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (85, 5, 446, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (86, 3, 299, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (87, 2, 443, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (88, 2, 256, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (89, 4, 351, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (90, 5, 317, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (91, 5, 439, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (92, 3, 384, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (93, 3, 397, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (94, 3, 276, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (95, 4, 314, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (96, 3, 443, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (97, 5, 277, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (98, 2, 333, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (99, 5, 282, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (100, 3, 247, 0, 0)
GO
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (101, 5, 364, 1, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (102, 2, 1, 0, 0)
INSERT [dbo].[LUUVET] ([MaDHX], [MaTram], [MaNV], [TrangThai], [isXoa]) VALUES (103, 3, 240, 0, 0)
SET IDENTITY_INSERT [dbo].[NHACUNGCAP] ON 

INSERT [dbo].[NHACUNGCAP] ([MaNCC], [TenNhaCC], [GhiChu], [isXoa]) VALUES (1, N'CÔNG TY TNHH DALAVI', N'CÔNG TY TNHH DALAVI
', 0)
INSERT [dbo].[NHACUNGCAP] ([MaNCC], [TenNhaCC], [GhiChu], [isXoa]) VALUES (2, N'CÔNG TY TNHH ĐÀ LẠT XANH VN
', N'CÔNG TY TNHH ĐÀ LẠT XANH VN
', 0)
INSERT [dbo].[NHACUNGCAP] ([MaNCC], [TenNhaCC], [GhiChu], [isXoa]) VALUES (3, N'Cầu Đất Farm
', N'Cung cấp các loại đặc sản hoa quả sấy khô
', 0)
INSERT [dbo].[NHACUNGCAP] ([MaNCC], [TenNhaCC], [GhiChu], [isXoa]) VALUES (4, N'Ngon lạ Đà Lạt
', N'Cung cấp đặc sản vừa ngon, lạ của xứ ngàn hoa
', 0)
INSERT [dbo].[NHACUNGCAP] ([MaNCC], [TenNhaCC], [GhiChu], [isXoa]) VALUES (5, N'L''angfarm', N'L''angfarm', 0)
INSERT [dbo].[NHACUNGCAP] ([MaNCC], [TenNhaCC], [GhiChu], [isXoa]) VALUES (6, N'Thái Bảo', N'Thái Bảo', 0)
INSERT [dbo].[NHACUNGCAP] ([MaNCC], [TenNhaCC], [GhiChu], [isXoa]) VALUES (7, N'Matchi Matcha', N'Matchi Matcha', 0)
SET IDENTITY_INSERT [dbo].[NHACUNGCAP] OFF
SET IDENTITY_INSERT [dbo].[NHANVIEN] ON 

INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (1, N'Phan Ngọc Bảo', CAST(0x17100B00 AS Date), 1, CAST(0x9A360B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (2, N'Nguyễn Thị Huyền', CAST(0x85110B00 AS Date), 0, CAST(0x52320B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (3, N'Trần Thị Ngọc Mai', CAST(0xF2120B00 AS Date), 0, CAST(0x52320B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (4, N'Nguyễn Thị Toản', CAST(0x18100B00 AS Date), 0, CAST(0x52320B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (5, N'Đàm Đình Chung', CAST(0x11240B00 AS Date), 1, CAST(0x53320B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (6, N'Nguyễn Phan Bích Ngọc', CAST(0x11240B00 AS Date), 0, CAST(0x53320B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (7, N'Hà Vương Ngọc', CAST(0x11240B00 AS Date), 1, CAST(0x53320B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (8, N'Nguyễn Phương Nam', CAST(0x11240B00 AS Date), 1, CAST(0x53320B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (9, N'Trần Đức Lợi', CAST(0x11240B00 AS Date), 1, CAST(0x53320B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (10, N'Nguyễn Sanh Mân', CAST(0x11240B00 AS Date), 1, CAST(0x53320B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (11, N'Nguyễn Trung Toản', CAST(0x16400B00 AS Date), 1, CAST(0x33400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (12, N'Nguyễn Trung Dũng', CAST(0x18400B00 AS Date), 1, CAST(0x36400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (13, N'Đàm Thanh Tùng', CAST(0x513D0B00 AS Date), 1, CAST(0x38400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (14, N'Đàm Thanh Tùng B', CAST(0x60250B00 AS Date), 1, CAST(0x2A2B0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (15, N'Nguyễn Đức Thanh', CAST(0x07240B00 AS Date), 1, CAST(0x20330B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (16, N'Đàm Đình Tiến', CAST(0x1F110B00 AS Date), 0, CAST(0x8D330B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (17, N'Lê Thị Thanh Xuân', CAST(0xD11C0B00 AS Date), 0, CAST(0x243F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (239, N'Nguyễn Thị Kim Loan', CAST(0x941B0B00 AS Date), 0, CAST(0xF73E0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (240, N'Lê Như Thắng Lợi', CAST(0x55060B00 AS Date), 1, CAST(0xDA3E0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (241, N'Phạm Thị Thanh Tâm', CAST(0x84010B00 AS Date), 0, CAST(0x083F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (242, N'Nguyễn Minh Như Anh', CAST(0x24160B00 AS Date), 0, CAST(0x043F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (243, N'Vũ Huỳnh Khánh Trân', CAST(0xF01E0B00 AS Date), 0, CAST(0xF43E0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (244, N'Trần VănCường', CAST(0xF8050B00 AS Date), 1, CAST(0x90400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (245, N'Lê Thị Ngọc Bích', CAST(0x330C0B00 AS Date), 0, CAST(0x90400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (246, N'Nguyễn Thị Thu Lan', CAST(0x86060B00 AS Date), 0, CAST(0x90400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (247, N'Trần Hoàng Nhã Điểm', CAST(0xF8170B00 AS Date), 0, CAST(0xF43E0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (248, N'Cao Thị Thanh Hằng', CAST(0xF70F0B00 AS Date), 0, CAST(0xF43E0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (249, N'Lê Y Nhung', CAST(0xAF1A0B00 AS Date), 0, CAST(0x7F400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (250, N'Trần Thị Cẩm Diêu', CAST(0x9D0A0B00 AS Date), 0, CAST(0x523F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (251, N'Hoàng Thị Hải An', CAST(0x22070B00 AS Date), 0, CAST(0x233F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (252, N'Nguyễn Thị Ngọc Ánh', CAST(0x1E0C0B00 AS Date), 0, CAST(0x90400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (253, N'Nguyễn Hữu Phong', CAST(0x2C050B00 AS Date), 1, CAST(0x65400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (254, N'Nguyễn Văn Duy', CAST(0x9F0A0B00 AS Date), 1, CAST(0x47400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (255, N'Nguyễn Quốc Việt', CAST(0x990A0B00 AS Date), 1, CAST(0x233F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (256, N'Nguyễn Đỗ Đình Thoại', CAST(0x4BFF0A00 AS Date), 1, CAST(0xF63E0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (257, N'Bùi Đình Tuấn', CAST(0xB50F0B00 AS Date), 1, CAST(0x71400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (258, N'Trần Hữu Thái', CAST(0xCF170B00 AS Date), 1, CAST(0x233F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (259, N'Đỗ Duy Quân', CAST(0x251C0B00 AS Date), 1, CAST(0x86400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (260, N'Trần Duy Dũng', CAST(0x82070B00 AS Date), 1, CAST(0x423F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (261, N'Thống Hính Lùng', CAST(0x041F0B00 AS Date), 1, CAST(0x0D3F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (262, N'Huỳnh Thanh Sơn', CAST(0x10200B00 AS Date), 1, CAST(0x7A400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (263, N'Lê Đình Huy', CAST(0x820E0B00 AS Date), 1, CAST(0x423F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (264, N'Nguyễn Văn Triêu', CAST(0x5AFA0A00 AS Date), 1, CAST(0x71400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (265, N'Nguyễn Trần Sơn Tùng', CAST(0x79120B00 AS Date), 1, CAST(0x90400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (266, N'Đinh Quang Hải', CAST(0xCD140B00 AS Date), 1, CAST(0x61400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (267, N'Lê Huỳnh Phương', CAST(0xCF120B00 AS Date), 1, CAST(0xDA3E0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (268, N'Nguyễn Hoàng Bích Phượng', CAST(0x3B120B00 AS Date), 0, CAST(0x61400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (269, N'Huỳnh Nguyên Nhật', CAST(0x05170B00 AS Date), 1, CAST(0x233F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (270, N'Lâm Lê Ngọc Thủy', CAST(0x6F1E0B00 AS Date), 0, CAST(0xF43E0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (271, N'Huỳnh Thủy Thanh Vân', CAST(0xA71D0B00 AS Date), 0, CAST(0xF43E0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (272, N'Nguyễn Thị Hồng Vân', CAST(0xBF1F0B00 AS Date), 0, CAST(0xFD3E0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (273, N'Nguyễn Thanh Hòa', CAST(0x45190B00 AS Date), 1, CAST(0xFD3E0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (274, N'Trần Đình Nghĩa', CAST(0x5F130B00 AS Date), 1, CAST(0x81400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (275, N'Trần Đạt Quân', CAST(0x861F0B00 AS Date), 1, CAST(0x71400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (276, N'Bùi Hữu Tuấn', CAST(0xC81D0B00 AS Date), 1, CAST(0x71400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (277, N'Nguyễn Thị Diễm Hằng', CAST(0x301B0B00 AS Date), 0, CAST(0x053F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (278, N'Hoàng Thị Phương', CAST(0x5D1C0B00 AS Date), 0, CAST(0x6A400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (279, N'Nguyễn Thanh Mỹ', CAST(0x3EFC0A00 AS Date), 1, CAST(0x71400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (280, N'Nguyễn Hoàng Lâm', CAST(0xE9140B00 AS Date), 1, CAST(0x71400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (281, N'Hồ Xuân Lâm', CAST(0x1D0D0B00 AS Date), 1, CAST(0xDA3E0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (282, N'Đào Lý Đạt Huyền Thoại', CAST(0x39150B00 AS Date), 1, CAST(0x56400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (283, N'Hoàng Phúc Nguyên', CAST(0xDB1C0B00 AS Date), 0, CAST(0x56400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (284, N'Huỳnh Quang Huy', CAST(0x51200B00 AS Date), 1, CAST(0x043F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (285, N'Huỳnh Thanh Hoàng Nam', CAST(0xED1C0B00 AS Date), 1, CAST(0x71400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (286, N'Lâm Thị Như Ngọc', CAST(0xEC120B00 AS Date), 0, CAST(0x71400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (287, N'Trịnh Thị Nhật Linh', CAST(0x151F0B00 AS Date), 0, CAST(0x71400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (288, N'Nguyễn Như Quỳnh', CAST(0xE9200B00 AS Date), 0, CAST(0x7A400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (289, N'Huỳnh Như Ngọc', CAST(0x53200B00 AS Date), 0, CAST(0x7F400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (290, N'Huỳnh Quốc Khánh', CAST(0x36210B00 AS Date), 1, CAST(0x5D3F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (291, N'Hoàng Thị Cảnh', CAST(0x02200B00 AS Date), 0, CAST(0x71400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (292, N'Trương Ngọc Bảo Hòa', CAST(0xC6120B00 AS Date), 0, CAST(0x043F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (293, N'Trương Anh Vũ', CAST(0xB4160B00 AS Date), 1, CAST(0x56400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (294, N'Hồ NgọcToàn', CAST(0xB8130B00 AS Date), 1, CAST(0x56400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (295, N'Mai Ngọc Bảo Trâm', CAST(0x0A210B00 AS Date), 0, CAST(0x043F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (296, N'Mai Mộng Điền', CAST(0x19210B00 AS Date), 1, CAST(0x043F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (297, N'Huỳnh Phan Thị Thanh Phương', CAST(0x92210B00 AS Date), 0, CAST(0x423F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (298, N'Đỗ Văn Toàn', CAST(0x50FD0A00 AS Date), 1, CAST(0x043F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (299, N'Trịnh Chí Nghĩa', CAST(0xD2140B00 AS Date), 1, CAST(0xF43E0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (300, N'Lê Mai Khánh Duy', CAST(0x60200B00 AS Date), 1, CAST(0x043F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (301, N'Nguyễn Tuấn Vũ', CAST(0x5A190B00 AS Date), 1, CAST(0x71400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (302, N'Nguyễn Trần Hồng Hà', CAST(0xE31F0B00 AS Date), 1, CAST(0x71400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (303, N'Hoàng Công Định', CAST(0x33210B00 AS Date), 1, CAST(0x71400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (304, N'Võ Thị Hiền', CAST(0x1B170B00 AS Date), 0, CAST(0x043F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (305, N'Phạm Ngọc Bảo Châu', CAST(0x91140B00 AS Date), 1, CAST(0x043F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (306, N'Nguyễn Huỳnh Thục Đoan', CAST(0x521F0B00 AS Date), 0, CAST(0x043F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (307, N'Trần Thị Thủy', CAST(0x3A1A0B00 AS Date), 0, CAST(0x043F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (308, N'Nguyễn ThịThảo', CAST(0x3AF90A00 AS Date), 0, CAST(0x903E0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (309, N'Trần NgọcTú', CAST(0x4F1E0B00 AS Date), 1, CAST(0x123F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (310, N'Trần Thị Hiền Vi', CAST(0x1B0B0B00 AS Date), 0, CAST(0x423F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (311, N'Trần Cảnh Thái', CAST(0x1A1A0B00 AS Date), 1, CAST(0x483F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (312, N'Nguyễn Thị Kim Đức', CAST(0xD0F40A00 AS Date), 0, CAST(0x043F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (313, N'Nguyễn Đình Thịnh', CAST(0x0D1D0B00 AS Date), 1, CAST(0x233F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (314, N'Trương Duy Vũ', CAST(0x0C250B00 AS Date), 1, CAST(0x233F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (315, N'Nguyễn Minh Tuyển', CAST(0xEBFA0A00 AS Date), 1, CAST(0xDA3E0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (316, N'Mai Lệ Quyên', CAST(0xB3120B00 AS Date), 0, CAST(0x56400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (317, N'Đặng Hương Diệu', CAST(0x26130B00 AS Date), 0, CAST(0xE93E0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (318, N'Bùi Minh Thoại', CAST(0x83190B00 AS Date), 0, CAST(0x043F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (319, N'Võ Huỳnh Thiên Thy', CAST(0x78200B00 AS Date), 0, CAST(0x71400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (320, N'Nguyễn Huyền Thanh', CAST(0x11150B00 AS Date), 0, CAST(0x71400B00 AS Date), 0)
GO
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (321, N'Phan Thị Thu Hương', CAST(0x140C0B00 AS Date), 0, CAST(0x71400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (322, N'Hồ Thị KimThanh', CAST(0x0E200B00 AS Date), 0, CAST(0x71400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (323, N'Bùi Thị Giáng Thu', CAST(0xB5110B00 AS Date), 0, CAST(0x043F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (324, N'Phan Thị Mỹ Nhung', CAST(0x60120B00 AS Date), 0, CAST(0x71400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (325, N'Hoàng Thanh Hùng', CAST(0xCA110B00 AS Date), 1, CAST(0x1F3F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (326, N'Nguyễn Thị Xuân', CAST(0x6E0B0B00 AS Date), 0, CAST(0x1A3F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (327, N'Vũ Thị Ngoan', CAST(0x37110B00 AS Date), 0, CAST(0x233F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (328, N'Ngô Võ Trúc Vi', CAST(0x15190B00 AS Date), 0, CAST(0x90400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (329, N'Lê Thị Thanh Xuân', CAST(0x41FF0A00 AS Date), 0, CAST(0x043F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (330, N'Hồ Vĩnh Kiều', CAST(0x06110B00 AS Date), 1, CAST(0x71400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (331, N'Nguyễn Thị Huỳnh Oanh', CAST(0xE8030B00 AS Date), 0, CAST(0x043F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (332, N'Hồ Thị Bình', CAST(0x66140B00 AS Date), 0, CAST(0x233F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (333, N'Huỳnh Phan Trọng Tín', CAST(0x52230B00 AS Date), 1, CAST(0x573F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (334, N'Nguyễn Thị Bảy', CAST(0xBD000B00 AS Date), 0, CAST(0x043F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (335, N'Hồ Thị Hồng Thanh', CAST(0x93000B00 AS Date), 0, CAST(0x7F400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (336, N'Phạm Nguyễn Minh Hoàng', CAST(0x5B1B0B00 AS Date), 1, CAST(0x56400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (337, N'Phạm Thị Lệ Phấn', CAST(0x940E0B00 AS Date), 0, CAST(0x043F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (338, N'Nguyễn Thị Phượng', CAST(0x1EF30A00 AS Date), 0, CAST(0x8D400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (339, N'Lê Thị Ánh Nguyệt', CAST(0xCF0A0B00 AS Date), 0, CAST(0xF93F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (340, N'Vũ Thị Ngọc Mai', CAST(0xED0B0B00 AS Date), 0, CAST(0x02400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (341, N'Lê Văn Thành', CAST(0x2E140B00 AS Date), 1, CAST(0x61400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (342, N'Tăng Chí Hùng', CAST(0x58FA0A00 AS Date), 1, CAST(0x6F400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (343, N'Ngô Chí Cường', CAST(0xB7F90A00 AS Date), 1, CAST(0x6F400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (344, N'Phan Đình Thắng', CAST(0x1A210B00 AS Date), 1, CAST(0x023F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (345, N'Vũ Thiện Tâm', CAST(0xC1190B00 AS Date), 1, CAST(0x78400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (346, N'Phan Minh Đức', CAST(0x4E100B00 AS Date), 1, CAST(0x0B3F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (347, N'Nguyễn Như Quyến', CAST(0xBC070B00 AS Date), 1, CAST(0xB8400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (348, N'Nguyễn Tuấn Anh', CAST(0xB81A0B00 AS Date), 1, CAST(0x9F400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (349, N'Lê Cao Thưởng', CAST(0x1D0F0B00 AS Date), 1, CAST(0x593F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (350, N'Phạm Kim Thúy', CAST(0x1D0F0B00 AS Date), 0, CAST(0xDA3E0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (351, N'Nghiêm Vũ Linh Giang', CAST(0xB01A0B00 AS Date), 0, CAST(0xF43E0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (352, N'Trịnh Minh Đỗ Uyên', CAST(0x65140B00 AS Date), 0, CAST(0x02400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (353, N'Nguyễn Thị Ngọc Đoan', CAST(0x5F1A0B00 AS Date), 0, CAST(0x71400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (354, N'Hà Vũ Linh', CAST(0xBB1B0B00 AS Date), 1, CAST(0x043F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (355, N'Lê Dương Thúy Vi', CAST(0x66200B00 AS Date), 0, CAST(0x503F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (356, N'Lê ThịTám', CAST(0x4A160B00 AS Date), 0, CAST(0x3F3F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (357, N'Đỗ Tuyết Trinh', CAST(0x88200B00 AS Date), 0, CAST(0x503F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (358, N'Phan Thị Nhật Tân', CAST(0x890D0B00 AS Date), 0, CAST(0x123F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (359, N'Nguyễn Nữ Thục Nhi', CAST(0xAD1D0B00 AS Date), 0, CAST(0xF43E0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (360, N'Phạm Thị Hải Yến', CAST(0x2D120B00 AS Date), 0, CAST(0x61400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (361, N'Hồ Thị Phương Thanh', CAST(0x1C1A0B00 AS Date), 0, CAST(0x423F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (362, N'Linh Huyền Chiêu', CAST(0x84050B00 AS Date), 0, CAST(0x453F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (363, N'Huỳnh Thanh Trường Sơn', CAST(0xE70E0B00 AS Date), 1, CAST(0x5F3F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (364, N'Đàng Thị Thu Vy', CAST(0xAD180B00 AS Date), 0, CAST(0x623F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (365, N'Dương Thị Lai', CAST(0x7A070B00 AS Date), 0, CAST(0x233F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (366, N'Hoàng Thị Quỳnh Châu', CAST(0xC0080B00 AS Date), 0, CAST(0x643F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (367, N'Lê Đình Lạc', CAST(0x5AF90A00 AS Date), 1, CAST(0x233F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (368, N'Nguyễn Thanh Hợi', CAST(0xEFE00A00 AS Date), 1, CAST(0x233F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (369, N'Lê Duy Bảo', CAST(0xB51B0B00 AS Date), 1, CAST(0x8A3F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (370, N'Nguyễn Hoàng QuốcBảo', CAST(0x5E200B00 AS Date), 1, CAST(0x6C3F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (371, N'Phan Thị ThúyHằng', CAST(0x81140B00 AS Date), 0, CAST(0x6F3F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (372, N'Nguyễn ThịThu Trang', CAST(0xD3F90A00 AS Date), 0, CAST(0x883F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (373, N'Lê Thị Mai Uyên', CAST(0x3A1E0B00 AS Date), 0, CAST(0x8B3F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (374, N'Phạm Quang Minh', CAST(0x7C1F0B00 AS Date), 1, CAST(0x9B3F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (375, N'Vũ Nguyên Hà', CAST(0x710F0B00 AS Date), 0, CAST(0x9B3F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (376, N'Nguyễn Thị Thơ', CAST(0x920C0B00 AS Date), 0, CAST(0x8F3F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (377, N'Nguyễn Thụy Hoài Hương', CAST(0xF9080B00 AS Date), 0, CAST(0xF93F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (378, N'Nguyễn Thị Hương Quỳnh', CAST(0x9A120B00 AS Date), 0, CAST(0x853F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (379, N'Bùi Thụy Thục Đoan', CAST(0xC4050B00 AS Date), 0, CAST(0x9E3F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (380, N'Nguyễn Thị Bích Loan', CAST(0x8F090B00 AS Date), 0, CAST(0x9B3F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (381, N'Trần Thị Thúy Hằng', CAST(0xC7010B00 AS Date), 0, CAST(0xA53F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (382, N'Nguyễn AnhToàn', CAST(0x6C0D0B00 AS Date), 1, CAST(0x973F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (383, N'Phan Thế Hiển', CAST(0x43140B00 AS Date), 1, CAST(0x7D3F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (384, N'Nguyễn Đỗ Hữu Long', CAST(0x68020B00 AS Date), 1, CAST(0xA93F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (385, N'Bùi Thị Quỳnh Giao', CAST(0x6DFE0A00 AS Date), 0, CAST(0xA63F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (386, N'Trần Ngọc Duy', CAST(0xAE0A0B00 AS Date), 1, CAST(0xB33F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (387, N'Đặng Nguyễn Tường Vy', CAST(0x05230B00 AS Date), 0, CAST(0xC13F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (388, N'Lại Thị Thùy Ngọc', CAST(0x54200B00 AS Date), 0, CAST(0xC13F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (389, N'Võ Hoàng Tuấn Anh', CAST(0xA01D0B00 AS Date), 1, CAST(0xC13F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (390, N'Tiêu Minh Tiến', CAST(0x111B0B00 AS Date), 1, CAST(0xC13F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (391, N'Châu Thị Tuyết Nhung', CAST(0x03170B00 AS Date), 0, CAST(0xE23F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (392, N'Lê Hữu Duy Khang', CAST(0xDB1A0B00 AS Date), 1, CAST(0x02400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (393, N'Nguyễn Thị Anh Thư', CAST(0x010E0B00 AS Date), 0, CAST(0x02400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (394, N'Trần Thị Thực', CAST(0x0D1E0B00 AS Date), 0, CAST(0xE73F0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (395, N'Nguyễn Bảo Lân', CAST(0x01210B00 AS Date), 1, CAST(0x0C400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (396, N'Lâm Dương An', CAST(0x42010B00 AS Date), 1, CAST(0x1D400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (397, N'Nguyễn Trí Thanh', CAST(0x101B0B00 AS Date), 1, CAST(0x0C400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (398, N'Nguyễn Thanh Minh', CAST(0xC8FB0A00 AS Date), 1, CAST(0x2B400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (399, N'Đặng Thị Bích Thủy', CAST(0xDE040B00 AS Date), 0, CAST(0x1B400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (400, N'Lê Văn Mạnh', CAST(0xBC210B00 AS Date), 1, CAST(0x2E400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (401, N'Lê Thị Giang Linh', CAST(0xD00D0B00 AS Date), 0, CAST(0x32400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (402, N'Lê Huy Hùng', CAST(0xF5240B00 AS Date), 1, CAST(0x16400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (403, N'Trần Hải Yến', CAST(0x66150B00 AS Date), 0, CAST(0x38400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (404, N'Phan Thị Thanh Hiền', CAST(0xE4170B00 AS Date), 0, CAST(0x1A400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (405, N'Giang Phước An', CAST(0xA10E0B00 AS Date), 1, CAST(0x34400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (406, N'Nguyễn Chiến Thắng', CAST(0x85FD0A00 AS Date), 1, CAST(0x24400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (407, N'Trịnh Đình Hùng', CAST(0xAB040B00 AS Date), 1, CAST(0x3F400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (408, N'Đoàn Bảo Ngọc', CAST(0x61180B00 AS Date), 0, CAST(0x37400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (409, N'Lê Anh Khoa', CAST(0xB0090B00 AS Date), 1, CAST(0x55400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (410, N'Ngô XuânToàn', CAST(0x190E0B00 AS Date), 1, CAST(0x24400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (411, N'Trần Thy Lan', CAST(0x66080B00 AS Date), 0, CAST(0xD43C0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (412, N'Nguyễn Nhật Trường', CAST(0x36150B00 AS Date), 1, CAST(0x9D3E0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (413, N'Nguyễn Công Lộc', CAST(0x99160B00 AS Date), 1, CAST(0xC73E0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (414, N'Hà Thị Kiều Trang', CAST(0xC51D0B00 AS Date), 0, CAST(0x903E0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (415, N'Nguyễn Tiến Dũng', CAST(0x35150B00 AS Date), 1, CAST(0x513E0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (416, N'Nguyễn Thị Hồng Ngọc', CAST(0x321F0B00 AS Date), 0, CAST(0xBC3D0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (417, N'Phạm Thị Hằng', CAST(0x9B160B00 AS Date), 0, CAST(0xC43D0B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (418, N'Phùng Hữu Anh Vũ', CAST(0xB4220B00 AS Date), 1, CAST(0x27400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (419, N'Lê Thanh Uyên Vy', CAST(0xE8200B00 AS Date), 0, CAST(0x28400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (420, N'Lê Nữ Đông Triều', CAST(0xBF160B00 AS Date), 0, CAST(0x46400B00 AS Date), 0)
GO
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (421, N'Nguyễn Minh Phú', CAST(0xD5160B00 AS Date), 1, CAST(0x46400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (422, N'Nguyễn Anh Khoa', CAST(0xCF220B00 AS Date), 1, CAST(0x47400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (423, N'Trần Thị Dung', CAST(0x130F0B00 AS Date), 0, CAST(0x4E400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (424, N'Ma TháiTrường', CAST(0x82FD0A00 AS Date), 1, CAST(0x71400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (425, N'Nguyễn Văn Thọ', CAST(0x60080B00 AS Date), 1, CAST(0x4D400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (426, N'Ninh Thế Đông', CAST(0x6E120B00 AS Date), 1, CAST(0x2B400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (427, N'Lê Thanh Nguyên', CAST(0x030F0B00 AS Date), 0, CAST(0x18400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (428, N'Chiếng Bích Liên', CAST(0x711C0B00 AS Date), 0, CAST(0x43400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (429, N'Chương Xuân Thị Ngọc Quyên', CAST(0xCC140B00 AS Date), 0, CAST(0x62400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (430, N'Nguyễn Thị Mỹ Chi', CAST(0xAD140B00 AS Date), 0, CAST(0x69400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (431, N'Hoàng Thị Thu', CAST(0xF3FF0A00 AS Date), 0, CAST(0x4D400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (432, N'Phạm Vũ An', CAST(0xEF1D0B00 AS Date), 1, CAST(0x4C400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (433, N'Lê Thị Thùy Linh', CAST(0xB71D0B00 AS Date), 0, CAST(0x70400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (434, N'Lê Thị Tú Uyên', CAST(0x59F60A00 AS Date), 0, CAST(0x53400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (435, N'Nguyễn Thùy Trinh', CAST(0x2B100B00 AS Date), 0, CAST(0x53400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (436, N'Nguyễn Thị Tường Vân', CAST(0xD6FE0A00 AS Date), 0, CAST(0x59400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (437, N'Nguyễn ThùyDinh', CAST(0x51240B00 AS Date), 0, CAST(0x7A400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (438, N'Trần Xuân Vinh', CAST(0x0A130B00 AS Date), 1, CAST(0x85400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (439, N'Lê Hưng Thông', CAST(0xFF220B00 AS Date), 1, CAST(0x85400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (440, N'Nguyễn Hồ Thị Bích Nga', CAST(0x31F00A00 AS Date), 0, CAST(0x89400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (441, N'Nguyễn Thị Thu Thảo', CAST(0x801A0B00 AS Date), 0, CAST(0x85400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (442, N'Nguyễn Thị Thu Trang', CAST(0xBF1E0B00 AS Date), 0, CAST(0x90400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (443, N'Long DưngH'' In', CAST(0x351B0B00 AS Date), 0, CAST(0x75400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (444, N'Nguyễn Thị Phú', CAST(0x12120B00 AS Date), 0, CAST(0x56400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (445, N'Nguyễn Đặng Lệ Quyên', CAST(0xD31F0B00 AS Date), 0, CAST(0x76400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (446, N'Trương Trường An', CAST(0x14280B00 AS Date), 1, CAST(0x9A400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (447, N'Nguyễn Thị Hạnh', CAST(0x72060B00 AS Date), 0, CAST(0x7D400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (448, N'Đỗ Nguyên Thái Bảo', CAST(0x91150B00 AS Date), 1, CAST(0x84400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (449, N'Đặng Thị Hà', CAST(0xFF020B00 AS Date), 0, CAST(0x89400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (450, N'Văn Đình Sơn', CAST(0x8B200B00 AS Date), 1, CAST(0x89400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (451, N'Tạ Đức Ban', CAST(0xD3200B00 AS Date), 1, CAST(0x92400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (452, N'Cao Thị Ngọc Ánh', CAST(0x7F180B00 AS Date), 0, CAST(0x92400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (453, N'Đào Thị Kim Phượng', CAST(0x671F0B00 AS Date), 0, CAST(0x95400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (454, N'Lê Văn Chung', CAST(0xDA030B00 AS Date), 1, CAST(0x98400B00 AS Date), 0)
INSERT [dbo].[NHANVIEN] ([MaNV], [Hoten], [Ngaysinh], [Gioitinh], [Ngayvaolam], [isXoa]) VALUES (455, N'Nguyễn Thị Giáng Hương', CAST(0x4D160B00 AS Date), 0, CAST(0x793F0B00 AS Date), 0)
SET IDENTITY_INSERT [dbo].[NHANVIEN] OFF
SET IDENTITY_INSERT [dbo].[SANPHAM] ON 

INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (1, 1, 1, N'Trà sencha hoa lài', 0.5, 24, N'Đóng hộp', 105000, NULL, 0, N'4', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (2, 1, 1, N'Trà sencha hoa cúc', 0.5, 24, N'Đóng hộp', 109000, NULL, 0, N'4', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (3, 1, 1, N'Trà tim sen', 0.5, 24, N'Đóng hộp', 200000, NULL, 0, N'4', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (4, 2, 3, N'Hồng chẻ sấy dẻo', 0.5, 12, N'Đóng hộp', 80000, NULL, 0, N'4', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (5, 2, 3, N'Hồng chén sấy khô', 0.5, 12, N'Đóng hộp', 75000, NULL, 0, N'4', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (6, 3, 3, N'Bông atiso sấy khô', 0.5, 12, N'Đóng hộp', 150000, NULL, 0, N'4', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (7, 3, 3, N'Rễ atiso sấy khô', 0.5, 12, N'Đóng hộp', 200000, NULL, 0, N'4', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (8, 4, 3, N'Đậu phụng', 0.5, 12, N'Bịch', 33000, NULL, 0, N'4', N'Đựng trong bao bì 2 lớp hút chân không hoặc các hộp kín, Bảo quản ở nơi khô thoáng

')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (9, 4, 3, N'Đậu nành', 0.5, 12, N'Bịch', 35000, N'Món ăn vặt ưa thích, thích hợp tiêu dùng hoặc làm quà tặng.
Giòn, ngon, béo, hương vị vừa miệng, hấp dẫn.', 0, N'5', N'Đựng trong bao bì 2 lớp hút chân không hoặc các hộp kín, Bảo quản ở nơi khô thoáng')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (10, 4, 3, N'Đậu hòa lan', 0.5, 5, N'Bịch', 42000, NULL, 0, N'4', N'Đựng trong bao bì 2 lớp hút chân không hoặc các hộp kín, Bảo quản ở nơi khô thoáng

')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (11, 4, 3, N'Hạt mác ca', 0.5, 12, N'Bịch', 116000, NULL, 0, N'10', N'Đựng trong bao bì 2 lớp hút chân không hoặc các hộp kín, Bảo quản ở nơi khô thoáng

')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (12, 2, 3, N'Mít sấy', 0.5, 12, N'Bịch', 150000, NULL, 0, N'10', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (13, 2, 3, N'Xoài sấy dẻo', 0.5, 6, N'Bịch', 89000, NULL, 0, N'10', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (14, 2, 3, N'Khoai lang sấy dẻo', 0.5, 12, N'Bịch', 120000, NULL, 0, N'10', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (15, 2, 3, N'Chuối sấy dẻo', 0.5, 12, N'Bịch', 100000, NULL, 0, N'10', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (16, 2, 3, N'Thập cẩm sấy', 0.45, 5, N'Bịch', 75000, NULL, 0, N'10', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (17, 1, 1, N'Trà', 0.5, 24, N'Túi lọc, đóng hộp', 68000, NULL, 0, N'10', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (18, 1, 1, N'Trà tim sen túi lọc', 0.5, 24, N'Túi lọc, đóng hộp', 69000, NULL, 0, N'10', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (19, 1, 1, N'Trà cỏ ngọt túi lọc', 0.5, 24, N'Túi lọc, đóng hộp', 80000, NULL, 0, N'10', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (20, 1, 1, N'Trà hoa cúc túi lọc', 0.5, 24, N'Túi lọc, đóng hộp', 75000, NULL, 0, N'10', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (21, 1, 1, N'Trà atiso túi lọc', 0.5, 24, N'Túi lọc, đóng hộp', 65000, NULL, 0, N'8', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (22, 1, 1, N'Trà gừng túi lọc', 0.5, 24, N'Túi lọc, đóng hộp', 85000, NULL, 0, N'8', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (23, 2, 3, N'Hồng sấy treo Nhật Bản cắt lác', 0.09, 1, N'Cắt lác, bịch, mẫu giấy wasabi', 80000, N'Bảo quản nơi khô ráo, thoáng mát', 0, N'8', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (24, 5, 2, N'Cà phê phối trộn nhẹ', 0.25, 12, N'Bịch', 70000, N'Arabica 50%, Robusta 50%', 0, N'8', N'Nơi thoáng mát, tránh ánh nắng trực tiếp')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (25, 5, 2, N'Cà phê phối trộn đậm', 0.25, 12, N'Bịch', 74000, N'Arabica 20%, Robusta 80%', 0, N'8', N'Nơi thoáng mát, tránh ánh nắng trực tiếp')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (26, 5, 2, N'Cà phê phối trộn vừa', 0.25, 12, N'Bịch', 79000, N'Arabica 80%, Robusta 20%', 0, N'8', N'Nơi thoáng mát, tránh ánh nắng trực tiếp')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (27, 1, 1, N'Thử nghiệm', 0.5, 2, N'Bịch', 100, N'Thành phần cấu tạo', 0, N'8', N'Đựng trong bao bì 2 lớp hút chân không hoặc các hộp kín, Bảo quản ở nơi khô thoáng

')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (28, 1, 1, N'Đậu hòa lan 2	', 0.5, 2, N'Bịch', 200, N'Thành phần cấu tạo', 0, N'8', N'Đựng trong bao bì 2 lớp hút chân không hoặc các hộp kín, Bảo quản ở nơi khô thoáng

')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (30, 7, 5, N'Trà nụ vối túi lọc', 40, 24, N'hộp', 39000, N'Trà nụ vối túi lọc, 20 tép, hộp', 0, N'8', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (31, 7, 5, N'Trà sâm túi lọc', 0.04, 24, N'hộp', 57000, N'Trà sâm túi lọc, 20 tép, hộp', 0, N'11', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (32, 7, 5, N'Trà râu bắp túi lọc', 0.04, 24, N'hộp', 37000, N'Trà râu bắp túi lọc, 20 tép, hộp', 0, N'15', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (33, 7, 5, N'Trà hoa hoè túi lọc', 0.04, 24, N'hộp', 40000, N'Trà hoa hoè túi lọc, 20 tép, hộp', 0, N'15', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (34, 7, 5, N'Trà nhân trần túi lọc', 0.04, 24, N'hộp', 37000, N'Trà nhân trần túi lọc, 20 tép, hộp', 0, N'15', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (35, 7, 5, N'Trà đắng túi lọc', 0.04, 24, N'hộp', 35000, N'Trà đắng túi lọc, 20 tép, hộp', 0, N'15', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (36, 7, 5, N'Trà trái nhàu túi lọc', 0.04, 24, N'hộp', 33000, N'Trà trái nhàu túi lọc, 20 tép, hộp', 0, N'15', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (37, 7, 5, N'Trà khổ qua túi lọc', 0.04, 24, N'hộp', 43000, N'Trà khổ qua túi lọc, 20 tép, hộp', 0, N'15', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (38, 7, 5, N'Trà gừng túi lọc', 0.04, 24, N'hộp', 35000, N'Trà gừng túi lọc, 20 tép, hộp', 0, N'15', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (39, 7, 5, N'Trà xanh túi lọc', 0.04, 24, N'hộp', 37000, N'Trà xanh túi lọc, 20 tép, hộp', 0, N'15', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (40, 7, 5, N'Trà trinh nữ hoàng cung túi lọc', 0.04, 24, N'hộp', 40000, N'Trà trinh nữ hoàng cung túi lọc', 0, N'15', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (41, 7, 5, N'Trà tim sen túi lọc', 0.04, 4, N'hộp', 40000, N'Trà tim sen túi lọc, 20 tép, hộp', 0, N'3', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (42, 7, 5, N'Trà oolong túi lọc', 0.04, 24, N'hộp', 39000, N'Trà oolong túi lọc, 20 tép, hộp', 0, N'3', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (43, 7, 5, N'Trà linh chi túi lọc', 0.04, 24, N'hộp', 54000, N'Trà linh chi túi lọc, 20 tép, hộp', 0, N'3', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (44, 7, 5, N'Trà hoa cúc túi lọc', 0.04, 24, N'hộp', 52000, N'Trà hoa cúc túi lọc, 20 tép, hộp', 0, N'3', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (45, 7, 5, N'Trà hà thủ ô túi lọc', 0.04, 1, N'hộp', 46000, N'Trà hà thủ ô túi lọc, 20 tép, hộp', 0, N'3', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (46, 7, 5, N'Trà diệp hạ châu túi lọc', 0.04, 24, N'hộp', 39000, N'Trà diệp hạ châu túi lọc, 20 tép, hộp', 0, N'2', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (47, 7, 5, N'Trà cỏ ngọt túi lọc', 0.04, 24, N'hộp', 40000, N'Trà cỏ ngọt túi lọc, 20 tép, hộp', 0, N'2', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (48, 7, 5, N'Trà atisô túi lọc', 0.04, 24, N'hộp', 48000, N'Trà atisô túi lọc, 20 tép, hộp', 0, N'2', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (49, 7, 6, N'Trà xanh túi lọc', 0.04, 24, N'bịch', 39000, N'Trà xanh túi lọc, 40 tép, bịch, mẫu xanh, Thái Bảo', 0, N'2', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (57, 7, 6, N'Trà xanh túi lọc', 0.02, 24, N'hộp', 21000, N'Trà xanh túi lọc, 20 tép, hộp, mẫu xanh, Thái Bảo', 0, N'2', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (59, 7, 6, N'Trà đắng túi lọc', 0.02, 24, N'hộp', 25000, N'Trà đắng túi lọc, 20 tép, hộp, mẫu xanh, Thái Bảo', 0, N'2', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (66, 7, 6, N'Trà hoa cúc túi lọc', 0.02, 24, N'hộp', 32000, N'Trà hoa cúc túi lọc, 20 tép', 0, N'4', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (68, 7, 6, N'Trà sâm túi lọc', 0.02, 24, N'hộp', 32000, N'Trà sâm túi lọc, 20 tép, hộp, mẫu xanh, Thái Bảo', 0, N'4', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (72, 7, 6, N'Trà gừng túi lọc', 0.02, 24, N'hộp', 25000, N'Trà gừng túi lọc, 20 tép, hộp, mẫu xanh, Thái Bảo', 0, N'4', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (74, 7, 6, N'Trà atisô túi lọc', 0.02, 24, N'hộp', 25000, N'Trà atisô túi lọc, 20 tép, hộp, mẫu xanh, Thái Bảo', 0, N'4', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (76, 7, 6, N'Trà oolong túi lọc', 0.04, 24, N'lon', 72000, N'Trà oolong túi lọc, 40 tép, lon, mẫu tết, Thái Bảo', 0, N'4', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (77, 7, 6, N'Trà xanh túi lọc', 0.04, 24, N'lon', 65000, N'Trà xanh túi lọc, 40 tép, lon, mẫu tết, Thái Bảo', 0, N'4', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (79, 8, 5, N'Mứt đậu trắng', 0.5, 5, N'bịch', 42000, N'Mứt đậu trắng, 500g, bịch, mẫu kraft 1 mặt trong', 0, N'4', N'Trong các túi nilon (tránh để không khí lọt vào) và để nơi thoáng mát')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (80, 8, 5, N'Mứt đậu ngự', 0.3, 24, N'bịch', 42000, N'Mứt đậu ngự, 300g, bịch, mẫu kraft 1 mặt trong', 0, N'4', N'Trong các túi nilon (tránh để không khí lọt vào) và để nơi thoáng mát')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (82, 8, 5, N'Kẹo me cay', 0.3, 24, N'bịch', 29000, N'Kẹo me cay, 300g, bịch, mẫu kraft 1 mặt trong', 0, N'7', N'Trong một hộp có nắp đậy, tránh xa nhiệt và ánh sáng ở nhiệt độ phòng (khoảng 70 độ)')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (91, 8, 5, N'Kẹo me cay', 0.3, 8, N'hũ', 35000, N'Kẹo me cay, 300g, hũ, mẫu nắp nhôm', 0, N'7', N'Trong một hộp có nắp đậy, tránh xa nhiệt và ánh sáng ở nhiệt độ phòng (khoảng 70 độ)')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (92, 8, 5, N'Kẹo hương môn dẻo', 0.35, 24, N'hũ', 41000, N'Kẹo hương môn dẻo, 350g, hũ, mẫu nắp nhôm', 0, N'7', N'Trong một hộp có nắp đậy, tránh xa nhiệt và ánh sáng ở nhiệt độ phòng (khoảng 70 độ)')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (93, 8, 5, N'Kẹo hương mác mác dẻo', 0.35, 24, N'hũ', 41000, N'Kẹo hương mác mác dẻo, 350g, hũ, mẫu nắp nhôm', 0, N'7', N'Trong một hộp có nắp đậy, tránh xa nhiệt và ánh sáng ở nhiệt độ phòng (khoảng 70 độ)')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (94, 8, 5, N'Kẹo hương dâu tây dẻo', 0.35, 24, N'hũ', 41000, N'Kẹo hương dâu tây dẻo, 350g, hũ, mẫu nắp nhôm', 0, N'7', N'Trong một hộp có nắp đậy, tránh xa nhiệt và ánh sáng ở nhiệt độ phòng (khoảng 70 độ)')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (95, 8, 5, N'Kẹo hương bắp dẻo', 0.35, 24, N'hũ', 41000, N'Kẹo hương bắp dẻo, 350g, hũ, mẫu nắp nhôm', 0, N'7', N'Trong một hộp có nắp đậy, tránh xa nhiệt và ánh sáng ở nhiệt độ phòng (khoảng 70 độ)')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (96, 8, 5, N'Kẹo hương nha đam dẻo', 0.35, 7, N'hũ', 41000, N'Kẹo hương nha đam dẻo, 350g, hũ, mẫu nắp nhôm', 0, N'7', N'Trong một hộp có nắp đậy, tránh xa nhiệt và ánh sáng ở nhiệt độ phòng (khoảng 70 độ)')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (97, 8, 5, N'Kẹo hương thập cẩm dẻo', 0.35, 24, N'hũ', 41000, N'Kẹo hương thập cẩm dẻo, 350g, hũ, mẫu nắp nhôm', 0, N'7', N'Trong một hộp có nắp đậy, tránh xa nhiệt và ánh sáng ở nhiệt độ phòng (khoảng 70 độ)')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (98, 8, 5, N'Kẹo hương dâu tằm', 0.35, 24, N'hũ', 35000, N'Kẹo hương dâu tằm, 350g, hũ, mẫu nắp nhôm', 0, N'7', N'Trong một hộp có nắp đậy, tránh xa nhiệt và ánh sáng ở nhiệt độ phòng (khoảng 70 độ)')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (99, 8, 5, N'Kẹo hương dâu tây', 0.35, 24, N'hũ', 35000, N'Kẹo hương dâu tây, 350g, hũ, mẫu nắp nhôm', 0, N'7', N'Trong một hộp có nắp đậy, tránh xa nhiệt và ánh sáng ở nhiệt độ phòng (khoảng 70 độ)')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (100, 8, 5, N'Kẹo hương dâu tây', 0.18, 4, N'bịch', 14000, N'Kẹo hương dâu tây, 180g, bịch, mẫu bịch bạc', 0, N'6', N'Trong một hộp có nắp đậy, tránh xa nhiệt và ánh sáng ở nhiệt độ phòng (khoảng 70 độ)')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (101, 8, 5, N'Kẹo hương thập cẩm dẻo', 0.18, 24, N'bịch', 17000, N'Kẹo hương thập cẩm dẻo, 180g, bịch, mẫu bịch bạc', 0, N'6', N'Trong một hộp có nắp đậy, tránh xa nhiệt và ánh sáng ở nhiệt độ phòng (khoảng 70 độ)')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (102, 8, 5, N'Kẹo hương nha đam dẻo', 0.18, 24, N'bịch', 17000, N'Kẹo hương nha đam dẻo, 180g, bịch, mẫu bịch bạc', 0, N'6', N'Trong một hộp có nắp đậy, tránh xa nhiệt và ánh sáng ở nhiệt độ phòng (khoảng 70 độ)')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (103, 8, 5, N'Kẹo hương môn dẻo', 0.18, 24, N'bịch', 17000, N'Kẹo hương môn dẻo, 180g, bịch, mẫu bịch bạc', 0, N'6', N'Trong một hộp có nắp đậy, tránh xa nhiệt và ánh sáng ở nhiệt độ phòng (khoảng 70 độ)')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (104, 8, 5, N'Kẹo hương mác mác dẻo', 0.18, 24, N'bịch', 17000, N'Kẹo hương mác mác dẻo, 180g, bịch, mẫu bịch bạc', 0, N'6', N'Trong một hộp có nắp đậy, tránh xa nhiệt và ánh sáng ở nhiệt độ phòng (khoảng 70 độ)')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (105, 8, 5, N'Kẹo me cay', 0.18, 24, N'bịch', 16000, N'Kẹo me cay, 180g, bịch, mẫu bịch bạc', 0, N'6', N'Trong một hộp có nắp đậy, tránh xa nhiệt và ánh sáng ở nhiệt độ phòng (khoảng 70 độ)')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (106, 8, 5, N'Kẹo hương dâu tằm', 0.18, 5, N'bịch', 14000, N'Kẹo hương dâu tằm, 180g, bịch, mẫu bịch bạc', 0, N'6', N'Trong một hộp có nắp đậy, tránh xa nhiệt và ánh sáng ở nhiệt độ phòng (khoảng 70 độ)')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (107, 8, 5, N'Kẹo hương dâu tây dẻo', 0.18, 24, N'bịch', 17000, N'Kẹo hương dâu tây dẻo, 180g, bịch, mẫu bịch bạc', 0, N'6', N'Trong một hộp có nắp đậy, tránh xa nhiệt và ánh sáng ở nhiệt độ phòng (khoảng 70 độ)')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (108, 8, 5, N'Kẹo hương bắp dẻo', 0.18, 24, N'bịch', 17000, N'Kẹo hương bắp dẻo, 180g, bịch, mẫu bịch bạc', 0, N'6', N'Trong một hộp có nắp đậy, tránh xa nhiệt và ánh sáng ở nhiệt độ phòng (khoảng 70 độ)')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (111, 9, 5, N'Mận sấy dẻo', 0.3, 24, N'hũ', 131000, N'Mận sấy dẻo, 300g, hũ, mẫu nắp nhôm', 0, N'6', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (112, 9, 5, N'Xoài sấy dẻo', 0.225, 24, N'bịch', 104000, N'Xoài sấy dẻo, 225g, bịch, mẫu kraft 1 mặt trong', 0, N'6', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (113, 9, 5, N'Thơm sấy dẻo', 0.225, 24, N'bịch', 95000, N'Thơm sấy dẻo, 225g, bịch, mẫu kraft 1 mặt trong', 0, N'6', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (115, 9, 5, N'Táo sấy khô', 0.3, 7, N'bịch', 79000, N'Táo sấy khô, 300g, bịch, mẫu kraft 1 mặt trong', 0, N'6', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (116, 9, 5, N'Mứt nho', 0.25, 24, N'bịch', 79000, N'Mứt nho, 250g, bịch, mẫu kraft 1 mặt trong', 0, N'6', N'Trong các túi nilon (tránh để không khí lọt vào) và để nơi thoáng mát')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (117, 9, 5, N'Đu đủ sấy dẻo', 0.225, 24, N'bịch', 71000, N'Đu đủ sấy dẻo, 225g, bịch, mẫu kraft 1 mặt trong', 0, N'6', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (119, 9, 5, N'Bưởi sấy dẻo', 0.225, 24, N'bịch', 71000, N'Bưởi sấy dẻo, 225g, bịch, mẫu kraft 1 mặt trong', 0, N'6', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (120, 9, 5, N'Hồng sấy treo', 0.225, 24, N'bịch', 131000, N'Hồng sấy treo, dòng phổ thông, 225g, bịch', 0, N'8', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (123, 9, 5, N'Mứt nho', 0.18, 24, N'bịch', 54000, N'Mứt nho, 180g, bịch, mẫu bịch bạc', 0, N'8', N'Trong các túi nilon (tránh để không khí lọt vào) và để nơi thoáng mát')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (124, 9, 5, N'Khoai lang sấy dẻo', 0.3, 9, N'bịch', 73000, N'Khoai lang sấy dẻo, 300g, bịch, mẫu hút chân không', 0, N'8', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (125, 9, 5, N'Hồng chén sấy dẻo', 0.3, 24, N'bịch', 117000, N'Hồng chén sấy dẻo, 300g, bịch, mẫu hút chân không', 0, N'8', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (126, 9, 5, N'Hồng chẻ sấy dẻo', 0.3, 24, N'bịch', 104000, N'Hồng chẻ sấy dẻo, 300g, bịch, mẫu hút chân không', 0, N'8', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (127, 9, 5, N'Xoài sấy dẻo', 0.225, 24, N'hũ', 110000, N'Xoài sấy dẻo, 225g, hũ, mẫu nắp nhôm', 0, N'8', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (128, 9, 5, N'Thơm sấy dẻo', 0.225, 24, N'hũ', 101000, N'Thơm sấy dẻo, 225g, hũ, mẫu nắp nhôm', 0, N'8', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (129, 9, 5, N'Thanh long sấy dẻo', 0.225, 24, N'bịchhũ', 85000, N'Thanh long sấy dẻo, 225g, hũ, mẫu nắp nhôm', 0, N'8', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (130, 9, 5, N'Táo sấy khô', 0.3, 8, N'hũ', 85000, N'Táo sấy khô, 300g, hũ, mẫu nắp nhôm', 0, N'8', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (131, 9, 5, N'Mứt nho', 0.225, 24, N'hũ', 85000, N'Mứt nho, 250g, hũ, mẫu nắp nhôm', 0, N'9', N'Trong các túi nilon (tránh để không khí lọt vào) và để nơi thoáng mát')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (132, 9, 5, N'Đu đủ sấy dẻo', 0.225, 24, N'hũ', 77000, N'Đu đủ sấy dẻo, 225g, hũ, mẫu nắp nhôm', 0, N'9', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (133, 9, 5, N'Chanh dây sấy dẻo', 0.25, 24, N'hũ', 106000, N'Chanh dây sấy dẻo, 250g, hũ, mẫu nắp nhôm', 0, N'9', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (134, 9, 5, N'Bưởi sấy dẻo', 0.225, 24, N'hũ', 77000, N'Bưởi sấy dẻo, 225g, hũ, mẫu nắp nhôm', 0, N'9', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (135, 9, 5, N'Chuối sấy dẻo', 0.3, 24, N'hũ', 50000, N'Chuối sấy dẻo, 300g, bịch, mẫu hút chân không', 0, N'9', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (136, 4, 5, N'Hạt macca', 0.25, 8, N'hũ', 116000, N'Hạt macca, 250g, hũ, mẫu nắp nhôm', 0, N'9', N'Đựng trong bao bì 2 lớp hút chân không hoặc các hộp kín, Bảo quản ở nơi khô thoáng

')
GO
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (138, 4, 5, N'Hạt sen sấy', 0.175, 24, N'bịch', 93000, N'Hạt sen sấy, 175g, bịch, mẫu kraft 1 mặt trong', 0, N'2', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (139, 4, 5, N'Hạt điều vỏ lụa', 0.225, 24, N'bịch', 103000, N'Hạt điều vỏ lụa, 225g, bịch, mẫu kraft 1 mặt trong', 0, N'2', N'Đựng trong bao bì 2 lớp hút chân không hoặc các hộp kín, Bảo quản ở nơi khô thoáng

')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (140, 4, 5, N'Hạt điều vàng', 0.225, 24, N'bịch', 125000, N'Hạt điều vàng, 225g, bịch, mẫu kraft 1 mặt trong', 0, N'2', N'Đựng trong bao bì 2 lớp hút chân không hoặc các hộp kín, Bảo quản ở nơi khô thoáng

')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (146, 4, 5, N'Đậu nành sấy', 0.225, 24, N'bịch', 29000, N'Đậu nành sấy, 225g, bịch, mẫu kraft 1 mặt trong', 0, N'2', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (149, 4, 5, N'Hạnh nhân rang bơ', 0.15, 24, N'hũ', 77000, N'Hạnh nhân rang bơ, 150g, hũ, mẫu nắp nhôm', 0, N'2', N'Đựng trong bao bì 2 lớp hút chân không hoặc các hộp kín, Bảo quản ở nơi khô thoáng

')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (150, 4, 5, N'Hạnh nhân rang muối biển', 0.275, 9, N'hũ', 161000, N'Hạnh nhân rang muối biển, 275g, hũ, mẫu nắp nhôm', 0, N'2', N'Đựng trong bao bì 2 lớp hút chân không hoặc các hộp kín, Bảo quản ở nơi khô thoáng

')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (151, 4, 5, N'Hạt sen sấy', 0.175, 24, N'hũ', 99000, N'Hạt sen sấy, 175g, hũ, mẫu nắp nhôm', 0, N'1', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (152, 4, 5, N'Hạt điều vàng', 0.225, 24, N'hũ', 131000, N'Hạt điều vàng, 225g, hũ, mẫu nắp nhôm', 0, N'1', N'Đựng trong bao bì 2 lớp hút chân không hoặc các hộp kín, Bảo quản ở nơi khô thoáng

')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (153, 4, 5, N'Hạt điều vỏ lụa', 0.225, 24, N'hũ', 109000, N'Hạt điều vỏ lụa, 225g, hũ, mẫu nắp nhôm', 0, N'1', N'Đựng trong bao bì 2 lớp hút chân không hoặc các hộp kín, Bảo quản ở nơi khô thoáng

')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (154, 4, 5, N'Đậu hoà lan muối', 0.225, 24, N'hũ', 38000, N'Đậu hoà lan muối, 225g, hũ, mẫu nắp nhôm', 0, N'1', N'Đựng trong bao bì 2 lớp hút chân không hoặc các hộp kín, Bảo quản ở nơi khô thoáng

')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (155, 4, 5, N'Ngũ hạt thập cẩm', 0.185, 6, N'hũ', 42000, N'Ngũ hạt thập cẩm, 185g, hũ, mẫu nắp nhôm', 0, N'1', N'Đựng trong bao bì 2 lớp hút chân không hoặc các hộp kín, Bảo quản ở nơi khô thoáng

')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (156, 4, 5, N'Đậu phộng sấy sữa bắp', 0.125, 24, N'hũ', 32000, N'Đậu phộng sấy sữa bắp, 125g, hũ, mẫu nắp nhôm', 0, N'1', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (157, 4, 5, N'Đậu phộng sấy rau củ', 0.135, 24, N'hũ', 33000, N'Đậu phộng sấy rau củ, 135g, hũ, mẫu nắp nhôm', 0, N'1', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (158, 4, 5, N'Đậu phộng nước cốt dừa', 0.25, 8, N'hũ', 40000, N'Đậu phộng nước cốt dừa, 250g, hũ, mẫu nắp nhôm', 0, N'1', N'Đựng trong bao bì 2 lớp hút chân không hoặc các hộp kín, Bảo quản ở nơi khô thoáng

')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (159, 4, 5, N'Đậu nành sấy', 0.225, 24, N'hũ', 35000, N'Đậu nành sấy, 225g, hũ, mẫu nắp nhôm', 0, N'1', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (160, 4, 5, N'Đậu hoà lan wasabi', 0.2, 24, N'hũ', 42000, N'Đậu hoà lan wasabi, 200g, hũ, mẫu nắp nhôm', 0, N'1', N'Đựng trong bao bì 2 lớp hút chân không hoặc các hộp kín, Bảo quản ở nơi khô thoáng

')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (161, 2, 5, N'Thập cẩm sấy', 0.1, 24, N'bịch', 25000, N'Thập cẩm sấy, 100g, bịch, mẫu kraft 1 mặt trong', 0, N'1', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (162, 2, 5, N'Mít sấy', 0.08, 8, N'bịch', 32000, N'Mít sấy, 80g, bịch, mẫu kraft 1 mặt trong', 0, N'1', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (163, 2, 5, N'Khoai môn sấy', 0.12, 24, N'bịch', 37000, N'Khoai môn sấy, 120g, bịch, mẫu kraft 1 mặt trong', 0, N'1', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (166, 2, 5, N'Chuối sấy', 0.12, 24, N'bịch', 23000, N'Chuối sấy, 120g, bịch, mẫu kraft 1 mặt trong', 0, N'1', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (168, 2, 5, N'Thập cẩm sấy', 0.1, 24, N'hũ', 31000, N'Thập cẩm sấy, 100g, hũ, mẫu nắp nhôm', 0, N'3', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (169, 2, 5, N'Mít sấy', 0.08, 24, N'hũ', 39000, N'Mít sấy, 80g, hũ, mẫu nắp nhôm', 0, N'5', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (170, 2, 5, N'Khoai lang tím sấy (sợi)', 0.12, 5, N'hũ', 31000, N'Khoai lang tím sấy (sợi), 120g, hũ, mẫu nắp nhôm', 0, N'5', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (171, 2, 5, N'Khoai lang vàng sấy (sợi)', 0.12, 24, N'hũ', 36000, N'Khoai lang vàng sấy (sợi), 120g, hũ, mẫu nắp nhôm', 0, N'5', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (172, 2, 5, N'Khoai môn sấy', 0.12, 24, N'hũ', 43000, N'Khoai môn sấy, 120g, hũ, mẫu nắp nhôm', 0, N'5', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (173, 2, 5, N'Chuối sấy', 0.12, 24, N'hũ', 29000, N'Chuối sấy, 120g, hũ, mẫu nắp nhôm', 0, N'5', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (182, 5, 5, N'Cà phê phối trộn đậm', 0.25, 9, N'bịch', 70000, N'Cà phê phối trộn đậm, 250g, bịch', 0, N'5', N'Nơi thoáng mát, tránh ánh nắng trực tiếp')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (183, 5, 5, N'Cà phê phối trộn vừa', 0.25, 24, N'bịch', 74000, N'Cà phê phối trộn vừa, 250g, bịch', 0, N'5', N'Nơi thoáng mát, tránh ánh nắng trực tiếp')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (184, 5, 5, N'Cà phê phối trộn nhẹ', 0.25, 24, N'bịch', 79000, N'Cà phê phối trộn nhẹ, 250g, bịch', 0, N'5', N'Nơi thoáng mát, tránh ánh nắng trực tiếp')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (185, 10, 6, N'Trà gừng hoà tan', 0.06, 6, N'hộp', 21000, N'Trà gừng hoà tan, 5 túi, hộp, Thái Bảo', 0, N'5', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (186, 10, 6, N'Trà gừng hoà tan', 0.264, 24, N'bịch', 79000, N'Trà gừng hoà tan, 22 túi, bịch, Thái Bảo', 0, N'5', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (188, 11, 5, N'Cao atisô', 0.45, 24, N'hộp', 417000, N'Cao atisô, 450g, hộp, mẫu hũ thuỷ tinh', 0, N'5', N'Đựng trong bao bì 2 lớp hút chân không hoặc các hộp kín, Bảo quản ở nơi khô thoáng

')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (189, 11, 5, N'Cao atisô', 0.15, 24, N'hộp', 142000, N'Cao atisô, 150g, hộp, mẫu hũ thuỷ tinh', 0, N'5', N'Đựng trong bao bì 2 lớp hút chân không hoặc các hộp kín, Bảo quản ở nơi khô thoáng

')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (190, 11, 5, N'Khổ qua sấy khô', 0.225, 24, N'bịch', 87000, N'Khổ qua sấy khô, 225g, bịch', 0, N'5', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (191, 11, 5, N'Diệp hạ châu sấy khô', 0.225, 24, N'bịch', 95000, N'Diệp hạ châu sấy khô, 225g, bịch', 0, N'5', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (192, 11, 5, N'Trinh nữ hoàng cung sấy khô', 0.225, 7, N'bịch', 96000, N'Trinh nữ hoàng cung sấy khô, 225g, bịch', 0, N'5', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (193, 11, 5, N'Linh chi sấy khô', 0.225, 24, N'bịch', 329000, N'Linh chi sấy khô, 225g, bịch', 0, N'5', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (194, 11, 5, N'Hà thủ ô sấy khô', 0.45, 24, N'bịch', 181000, N'Hà thủ ô sấy khô, 450g, bịch', 0, N'5', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (195, 11, 5, N'Cỏ ngọt sấy khô', 0.225, 8, N'bịch', 55000, N'Cỏ ngọt sấy khô, 225g, bịch', 0, N'5', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (196, 11, 5, N'Bông atisô sấy khô', 0.225, 24, N'bịch', 219000, N'Bông atisô sấy khô, 225g, bịch', 0, N'5', N'Tủ lạnh')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (197, 12, 7, N'Trà sencha hoa lài', 0.08, 24, N'hộp', 105000, N'Trà sencha hoa lài, 80g, hộp, Matchi Matcha', 0, N'5', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (198, 12, 7, N'Trà sencha hoa hồng', 0.88, 7, N'hộp', 109000, N'Trà sencha hoa hồng, 88g, hộp, Matchi Matcha', 0, N'5', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (199, 12, 7, N'Trà sencha hoa cúc', 0.86, 24, N'hộp', 107000, N'Trà sencha hoa cúc, 86g, hộp, Matchi Matcha', 0, N'5', N'Nơi khô ráo')
INSERT [dbo].[SANPHAM] ([MaSP], [MaLoai], [MaNCC], [TenSP], [TrongLuong], [ThoiHanSuDung], [QuyCachDongGoi], [Gia], [Ghichu], [isXoa], [ThoiGian], [BaoQuan]) VALUES (200, 5, 1, N'Cà phê Robusta nguyên chất', 0.8, 36, N'Bịch', 140000, N'Cà phê Robusta Ro+ là dòng cà phê thành phần thuần hạt cà phê Robusta nguyên chất rang mộc, không thêm bất cứ phụ gia nào khác.', 0, N'5', N'Nơi thoáng mát, tránh ánh nắng trực tiếp')
SET IDENTITY_INSERT [dbo].[SANPHAM] OFF
SET IDENTITY_INSERT [dbo].[SQLGOIY] ON 

INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (2, N'Sản Phẩm', N'Tìm tất cả sản phẩm (2)_SP', N'select * from sanpham')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (3, N'Sản Phẩm', N'Tìm sản phẩm có tên là trà(3)_SP', N'Select * From SANPHAM Where TenSP Like ''%Trà%''')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (4, N'Sản Phẩm', N'Tìm sản phẩm có trọng lượng nhỏ hơn hoặc bằng 0.5(4)_SP', N'select * from SANPHAM where TrongLuong <= 0.5')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (5, N'Sản Phẩm', N'Tìm sản phẩm có trọng lượng lớn hơn 0.5(5)_SP', N'select * from SANPHAM where TrongLuong > 0.5')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (6, N'Sản Phẩm', N'Tìm sản phẩm có hạn sử dụng  lớn hơn 12 tháng(6)_SP', N'select * from SANPHAM where ThoiHanSuDung > 12')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (7, N'Sản Phẩm', N'Tìm sản phẩm có hạn sử dùng là 12 tháng (7)_SP', N'select * from SANPHAM where ThoiHanSuDung = 12')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (8, N'Sản Phẩm', N'Tìm sản phẩm có hạn sử dụng nhỏ hơn 12 tháng(8)_SP', N'select * from SANPHAM where ThoiHanSuDung < 12')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (9, N'Sản Phẩm', N'Tìm sản phẩm có mã loại 1,2,4(9)_SP', N'select * from SANPHAM where MaLoai in (1,2,4)')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (10, N'Sản Phẩm', N'Tìm sản phẩm có mã loại 3,5,7(10)_SP', N'select * from SANPHAM where MaLoai in (3,5,7)')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (11, N'Sản Phẩm', N'Tìm sản phẩm có mã loại 6,8,10(11)_SP', N'select * from SANPHAM where MaLoai in (6,8,10)')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (12, N'Sản Phẩm', N'Tìm sản phẩm có mã loại 9,11,12(12)_SP', N'select * from SANPHAM where MaLoai in (9,11,12)')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (13, N'Sản Phẩm', N'Tìm sản phẩm có giá lớn hơn 50.000(13)_SP', N'select * from SANPHAM where Gia > 50000')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (14, N'Sản Phẩm', N'Tìm sản phẩm có giá nhỏ hơn 50.000	(14)_SP', N'select * from SANPHAM where Gia < 50000')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (15, N'Sản Phẩm', N'Tìm sản phẩm có giá từ 50.000 - 150.000(15)_SP', N'select * from SANPHAM where Gia between 50000 and 150000')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (16, N'Sản Phẩm', N'Tìm sản phẩm có giá lớn hơn 100.000(16)_SP', N'select * from SANPHAM where Gia > 100000')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (17, N'Sản Phẩm', N'Tìm sản phẩm có giá từ 100.000 - 200.000(17)_SP', N'select * from SANPHAM where Gia between 100000 and 200000')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (18, N'Sản Phẩm', N'Tìm sản phẩm có tên là đậu(18)_SP', N'select * from SANPHAM where TenSP like N''%Đậu%''')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (19, N'Sản Phẩm', N'Tìm sản phẩm có quy cách đóng gói là hộp(19)_SP', N'select * from SANPHAM where QuyCachDongGoi like N''%Hộp%''')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (20, N'Sản Phẩm', N'Tìm sản phẩm có quy cách đóng gói là bịch(20)_SP', N'select * from SANPHAM where QuyCachDongGoi like N''%Bịch%''')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (21, N'Sản Phẩm', N'Tìm sản phẩm có quy cách đóng gói là Túi(21)_SP', N'select * from SANPHAM where QuyCachDongGoi like N''%Túi%''')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (22, N'Sản Phẩm', N'Tìm sản phẩm có quy cách đóng gói là hũ(22)_SP', N'select * from SANPHAM where QuyCachDongGoi like N''%hũ%''')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (23, N'Sản Phẩm', N'Tìm sản phẩm có tên là cà phê(23)_SP', N'select * from SANPHAM where TenSP like N''%Cà Phê%''')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (24, N'Sản Phẩm', N'Tìm sản phẩm có tên là Mứt	(24)_SP', N'select * from SANPHAM where TenSP like N''%Mứt%''')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (25, N'Sản Phẩm', N'Tìm sản phẩm có tên là Kẹo(25)_SP', N'select * from SANPHAM where TenSP like N''%Kẹo%''')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (26, N'Sản Phẩm', N'Tìm sản phẩm có nhà cung cấp là 7,2,3(26)_SP', N'select * from SANPHAM where MaNCC in (7,2,3)')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (27, N'Sản Phẩm', N'Tìm sản phẩm có nhà cung cấp 2,3,4(27)_SP', N'select * from SANPHAM where MaNCC in (2,3,4)')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (28, N'Sản Phẩm', N'Tìm sản phẩm có nhà cung cấp là 1,5,6(28)_SP', N'select * from SANPHAM where MaNCC in (1,5,6)')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (29, N'Sản Phẩm', N'Tìm sản phẩm có giá lớn hơn 200.000(29)_SP', N'select * from SANPHAM where Gia > 200000')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (30, N'Nhân Viên', N'Tìm nhân viên có họ nguyễn(30)_NV', N'select * from NHANVIEN where Hoten like N''%Nguyễn%''')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (31, N'Nhân Viên', N'Tìm nhân viên có họ trần(31)_NV', N'select * from NHANVIEN where Hoten like N''%Trần%''')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (32, N'Nhân Viên', N'Tìm nhân viên nam(32)_NV', N'select * from NHANVIEN where Gioitinh = 1')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (33, N'Nhân Viên', N'Tìm nhân viên nữ(33)_NV', N'select * from NHANVIEN where Gioitinh = 0')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (34, N'Nhân Viên', N'Tìm nhân viên sinh trong tháng 1,3,5,7(34)_NV', N'select * from NHANVIEN where MONTH(Ngaysinh) in (1,3,5,7)')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (35, N'Nhân Viên', N'Tìm nhân viên sinh trong tháng 2,4,6,8(35)_NV', N'select * from NHANVIEN where MONTH(Ngaysinh) in (2,4,6,8)')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (36, N'Nhân Viên', N'Tìm nhân viên sinh trong tháng 9,10,11,12(36)_NV', N'select * from NHANVIEN where MONTH(Ngaysinh) in (9,10,11,12)')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (37, N'Nhân Viên', N'Tìm nhân viên có ngày vào làm 1 - 15 trong tháng(37)_NV', N'select * from NHANVIEN where Day(Ngayvaolam) in (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15)')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (38, N'Nhân Viên', N'Tìm nhân viên có ngày vào làm 15-30 trong tháng(38)_NV', N'select * from NHANVIEN where Day(Ngayvaolam) in (16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31)')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (39, N'Sản Phẩm', N'Tìm sản phẩm có  trọng lượng tăng dần(39)_SP', N'select * from sanpham order by  TrongLuong asc')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (40, N'Sản Phẩm', N'Tìm sản phẩm có trọng lượng giảm dần(40)_SP', N'select * from sanpham order by  TrongLuong desc')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (41, N'Sản Phẩm', N'Tìm sản phẩm giảm dần theo hạn sử dụng(41)_SP', N'select * from sanpham order by  ThoiHanSuDung desc')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (42, N'Sản Phẩm', N'Tìm sản phẩm tăng dần theo hạn sử dụng(42)_SP', N'select * from sanpham order by  ThoiHanSuDung asc')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (43, N'Sản Phẩm', N'Tìm sản phẩm tăng dần theo tên(43)_SP', N'select * from sanpham order by  TenSP asc')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (44, N'Sản Phẩm', N'Tìm sản phẩm giảm dần theo tên(44)_SP', N'select * from sanpham order by  TenSP desc')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (45, N'Sản Phẩm', N'Tìm sản phẩm giảm theo giá(45)_SP', N'select * from sanpham order by  Gia desc')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (46, N'Sản Phẩm', N'Tìm sản phẩm tăng theo giá(46)_SP', N'select * from sanpham order by  Gia asc')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (47, N'Đơn Hàng Xuất', N'Tìm tất cả đơn hàng xuất(47)_DHX', N'select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa from DONHANGXUAT dhx left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX order by dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa ')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (48, N'Đơn Hàng Xuất', N'Tìm đơn hàng xuất tăng theo số lượng(48)_DHX', N'select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa from DONHANGXUAT dhx left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
order by dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong asc, ct.isXoa ')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (49, N'Đơn Hàng Xuất', N'Tìm đơn hàng xuất giảm theo số lượng(49)_DHX', N'select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa from DONHANGXUAT dhx left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
order by dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong desc, ct.isXoa ')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (50, N'Đơn Hàng Xuất', N'Tìm đơn hàng xuất có số lượng lớn hơn 20(50)_DHX', N'select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa from DONHANGXUAT dhx left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
where SoLuong > 20
order by dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong desc, ct.isXoa ')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (51, N'Đơn Hàng Xuất', N'Tìm đơn hàng xuất có số lượng lớn hơn 50(51)_DHX', N'select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa from DONHANGXUAT dhx left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
where SoLuong > 50
order by dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong desc, ct.isXoa ')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (52, N'Đơn Hàng Xuất', N'Tìm đơn hàng xuất có số lượng nhỏ hơn 20(52)_DHX', N'select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa from DONHANGXUAT dhx left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
where SoLuong < 20 
order by dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong desc, ct.isXoa ')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (53, N'Đơn Hàng Xuất', N'Tìm đơn hàng đã xuất(53)_DHX', N'select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa from DONHANGXUAT dhx left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX where TrangThai = 1 order by dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa	')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (54, N'Đơn Hàng Xuất', N'Tìm đơn hàng chưa xuất(54)_DHX', N'select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa from DONHANGXUAT dhx left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX where TrangThai = 0 order by dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa	')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (55, N'Nhân Viên', N'Sắp xếp thông tin nhân viên tăng dần theo họ tên, giảm theo ngày sinh(55)_NV', N'select * from NHANVIEN order by Hoten asc,Ngaysinh desc')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (56, N'Sản Phẩm', N'Sắp xếp thông tin nhân viên tăng dần theo họ tên, giảm theo ngày vào làm(56)_SP', N'select * from NHANVIEN order by Hoten asc,Ngayvaolam desc')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (57, N'Sản Phẩm', N'Sắp xếp thông tin nhân viên tăng dần theo họ tên, tăng theo ngày vào làm (57)_SP', N'select * from NHANVIEN order by Hoten asc,Ngayvaolam asc')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (58, N'Sản Phẩm', N'Tìm thông tin của nhân viên có ngày vào làm trước ngày 01-07-2013 (58)_SP', N'select * from NHANVIEN where Ngayvaolam > ''01-07-2013''')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (59, N'Đại Lý', N'Tìm tất cả loại đại lý(59)_DL', N'select * from DAILY dl left join LOAIDAILY ldl on dl.MaLoai = ldl.MaLoai')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (60, N'Đại Lý', N'Tìm đại lý có mức chiết khấu cao nhất(60)_DL', N'select * from DAILY dl left join LOAIDAILY ldl on dl.MaLoai = ldl.MaLoai where ldl.MucChietKhau = (select MAX(MucChietKhau) from LOAIDAILY)')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (61, N'Đại Lý', N'Tìm đại lý có mức chiết khấu thấp nhất(61)_DL', N'select * from DAILY dl left join LOAIDAILY ldl on dl.MaLoai = ldl.MaLoai where ldl.MucChietKhau = (select Min(MucChietKhau) from LOAIDAILY)')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (62, N'Đại Lý', N'Tính tổng đơn hàng xuất ra theo đại lý(62)_DL', N'select COUNT(dhx.MaDaiLy) as SoLuong ,dl.Ten,CONVERT(varchar, dl.MaDL) as Ma from DONHANGXUAT dhx left join DAILY dl on dhx.MaDaiLy = dl.MaDL  group by MaDaiLy,dl.Ten,dl.MaDL order by SoLuong')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (63, N'Đơn Hàng Nhập', N'Tính tổng đơn hàng nhập theo từng nhà cung cấp(63)_DHN', N'select COUNT(ncc.MaNCC) as SoLuong ,ncc.TenNhaCC as Ten,CONVERT(varchar, ncc.MaNCC) as Ma from DONHANGNHAP dhn left join NHACUNGCAP ncc on dhn.MaNhaCC = ncc.MaNCC  group by MaNCC,TenNhaCC  order by SoLuong
')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (64, N'Đơn Hàng Xuất', N'Tìm đơn hàng xuất đã hoàn thành(64)_DHX', N'select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai where TrangThai = 1
order by SoLuong , MucChietKhau,  dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (65, N'Đơn Hàng Xuất', N'Tìm đơn hàng xuất chưa hoàn thành(65)_DHX', N'select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai where TrangThai = 0
order by SoLuong , MucChietKhau,  dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (66, N'Đơn Hàng Xuất', N'Sắp xếp đơn hàng xuất tăng theo số lượng(66)_DHX', N'select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai 
order by SoLuong asc, MucChietKhau,  dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (67, N'Đơn Hàng Xuất', N'Sắp xếp đơn hàng xuất giảm theo số lượng(67)_DHX', N'select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai 
order by SoLuong desc, MucChietKhau,  dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (68, N'Đơn Hàng Xuất', N'Tìm đơn hàng xuất có mức chiết khấu của đại lý cao nhất(68)_DHX', N'select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,ldl.MucChietKhau from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai where ldl.MucChietKhau = (select MAX(CONVERT(int, MucChietKhau)) from LOAIDAILY)
order by SoLuong desc, dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa,ldl.MucChietKhau')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (69, N'Đơn Hàng Xuất', N'Tìm đơn hàng xuất có mức chiết khấu của đại lý thấp nhất(69)_DHX', N'select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,ldl.MucChietKhau from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai where ldl.MucChietKhau = (select Min(CONVERT(int, MucChietKhau)) from LOAIDAILY)
order by SoLuong desc, dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa,ldl.MucChietKhau
')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (70, N'Đơn Hàng Xuất', N'Sắp xếp đơn hàng xuất theo mức chiết khấu tăng dần(70)_DHX', N'select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai 
order by MucChietKhau asc, dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (71, N'Đơn Hàng Xuất', N'Sắp xếp đơn hàng xuất theo mức chiết khấu giảm dần(71)_DHX', N'select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai 
order by MucChietKhau desc, dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (72, N'Đơn Hàng Xuất', N'Sắp xếp đơn hàng xuất theo mức chiết khấu tăng dần và giảm dần theo số lượng(72)_DHX', N'select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai 
order by MucChietKhau asc,SoLuong desc,  dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (73, N'Đơn Hàng Xuất', N'Sắp xếp đơn hàng xuất theo mức chiết khấu giảm dần và tăng dần theo số lượng(73)_DHX', N'select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai 
order by MucChietKhau desc,SoLuong asc,  dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (74, N'Đơn Hàng Xuất', N'Sắp xếp đơn hàng xuất theo mức chiết khấu giảm dần và giảm dần theo số lượng(74)_DHX', N'select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai 
order by MucChietKhau desc,SoLuong desc,  dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (75, N'Đơn Hàng Xuất', N'Sắp xếp đơn hàng xuất theo mức chiết khấu tăng dần và tăng dần theo số lượng(75)_DHX', N'select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai 
order by MucChietKhau asc,SoLuong asc,  dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (76, N'Lưu Vết', N'Tính tổng các đơn hàng qua từng trạm(76)_LV', N'select CONVERT(varchar,t.MaTram) as Ma,TenTram as Ten, COUNT(lv.MaTram) as SoLuong from DONHANGXUAT dhx 
left join LUUVET lv on dhx.MaDHX = lv.MaDHX
left join TRAM t on t.MaTram = lv.MaTram
group by  t.MaTram,TenTram')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (77, N'Lưu Vết', N'Tính tổng các đơn hàng qua từng trạm đã hoàn thành(77)_LV', N'select CONVERT(varchar,t.MaTram) as Ma,TenTram as Ten, COUNT(lv.MaTram) as SoLuong from DONHANGXUAT dhx 
left join LUUVET lv on dhx.MaDHX = lv.MaDHX
left join TRAM t on t.MaTram = lv.MaTram where dhx.TrangThai = 1
group by  t.MaTram,TenTram')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (78, N'Lưu Vết', N'Tính tổng các đơn hàng qua từng trạm chưa hoàn thành(78)_LV', N'select CONVERT(varchar,t.MaTram) as Ma,TenTram as Ten, COUNT(lv.MaTram) as SoLuong from DONHANGXUAT dhx 
left join LUUVET lv on dhx.MaDHX = lv.MaDHX
left join TRAM t on t.MaTram = lv.MaTram where dhx.TrangThai = 0
group by  t.MaTram,TenTram')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (79, N'Sản Phẩm', N'Tìm sản phẩm bảo quản trong tủ lạnh(79)_SP', N'select * from SANPHAM where BaoQuan like N''%Tủ lạnh%''')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (80, N'Sản Phẩm', N'Tìm sản phẩm bảo quản nơi khô ráo(80)_SP', N'select * from SANPHAM where BaoQuan like N''%Nơi khô ráo%''')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (81, N'Sản Phẩm', N'Tìm sản phẩm bảo quản trong túi nilon(81)_SP', N'select * from SANPHAM where BaoQuan like N''%túi nilon%''')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (82, N'Sản Phẩm', N'Tìm sản phẩm bảo quản trong hộp kín(82)_SP', N'select * from SANPHAM where BaoQuan like N''%hộp kín%''')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (83, N'Sản Phẩm', N'Tìm sản phẩm có thời gian sản xuất trên 5 ngày(83)_SP', N'select * from SANPHAM where ThoiGian > 5')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (84, N'Sản Phẩm', N'Tìm sản phẩm có thời gian sản xuất dưới 5 ngày(84)_SP', N'select * from SANPHAM where ThoiGian < 5')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (85, N'Sản Phẩm', N'Tìm sản phẩm có thời gian sản xuất trên 10 ngày(85)_SP', N'select * from SANPHAM where ThoiGian > 10')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (86, N'Sản Phẩm', N'Tìm sản phẩm có thời gian sản xuất dưới 10 ngày(86)_SP', N'select * from SANPHAM where ThoiGian  <10')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (87, N'Sản Phẩm', N'Tìm sản phẩm bảo quản trong tủ lạnh và thời gian lớn hơn 10(87)_SP', N'select * from SANPHAM where BaoQuan like N''%Tủ lạnh%'' and ThoiGian > 10')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (88, N'Sản Phẩm', N'Tìm sản phẩm bảo quản trong tủ lạnh và thời gian nhỏ hơn 10(88)_SP', N'select * from SANPHAM where BaoQuan like N''%Tủ lạnh%'' and ThoiGian < 10')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (89, N'Sản Phẩm', N'Tìm sản phẩm bảo quản trong tủ lạnh và thời gian lớn hơn 5(89)_SP', N'select * from SANPHAM where BaoQuan like N''%Tủ lạnh%'' and ThoiGian > 5')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (90, N'Sản Phẩm', N'Tìm sản phẩm bảo quản trong tủ lạnh và thời gian nhỏ hơn 5(90)_SP', N'select * from SANPHAM where BaoQuan like N''%Tủ lạnh%'' and ThoiGian < 5')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (91, N'Sản Phẩm', N'Tìm sản phẩm bảo quản nơi khô ráo và thời gian lớn hơn 10(91)_SP', N'select * from SANPHAM where BaoQuan like N''%Nơi khô ráo%'' and ThoiGian > 10')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (92, N'Sản Phẩm', N'Tìm sản phẩm bảo quản nơi khô ráo và thời gian nhỏ hơn 10(92)_SP', N'select * from SANPHAM where BaoQuan like N''%Nơi khô ráo%'' and ThoiGian < 10')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (93, N'Sản Phẩm', N'Tìm sản phẩm bảo quản nơi khô ráo và thời gian lớn hơn 5(93)_SP', N'select * from SANPHAM where BaoQuan like N''%Nơi khô ráo%'' and ThoiGian > 5')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (94, N'Sản Phẩm', N'Tìm sản phẩm bảo quản nơi khô ráo và thời gian nhỏ hơn 5(94)_SP', N'select * from SANPHAM where BaoQuan like N''%Nơi khô ráo%'' and ThoiGian < 5')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (95, N'Sản Phẩm', N'Tìm sản phẩm bảo quản trong túi nilon và thời gian nhỏ hơn 5(95)_SP', N'select * from SANPHAM where BaoQuan like N''%Trong túi nilon%'' and ThoiGian < 5')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (96, N'Sản Phẩm', N'Tìm sản phẩm bảo quản trong túi nilon và thời gian lớn hơn 5(96)_SP', N'select * from SANPHAM where BaoQuan like N''%Trong túi nilon%'' and ThoiGian > 5')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (97, N'Sản Phẩm', N'Tìm sản phẩm bảo quản trong túi nilon và thời gian lớn hơn 10(97)_SP', N'select * from SANPHAM where BaoQuan like N''%Trong túi nilon%'' and ThoiGian > 10')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (98, N'Sản Phẩm', N'Tìm sản phẩm bảo quản trong túi nilon và thời gian nhỏ hơn 10(98)_SP', N'select * from SANPHAM where BaoQuan like N''%Trong túi nilon%'' and ThoiGian < 10')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (99, N'Sản Phẩm', N'Tìm sản phẩm có tên là trà có thời gian sản xuất trên 10 ngày(99)_SP', N'Select * From SANPHAM Where TenSP Like ''%Trà%'' and ThoiGian > 10')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (100, N'Sản Phẩm', N'Tìm sản phẩm có tên là trà có thời gian sản xuất dưới 10 ngày(100)_SP', N'Select * From SANPHAM Where TenSP Like ''%Trà%'' and ThoiGian > 10')
GO
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (101, N'Sản Phẩm', N'Tìm sản phẩm có tên là trà có thời gian sản xuất dưới 5 ngày(101)_SP', N'Select * From SANPHAM Where TenSP Like ''%Trà%'' and ThoiGian > 5')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (102, N'Sản Phẩm', N'Tìm sản phẩm có tên là trà có thời gian sản xuất trên 5 ngày(102)_SP', N'Select * From SANPHAM Where TenSP Like ''%Trà%'' and ThoiGian > 5')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (103, N'Sản Phẩm', N'Tìm sản phẩm có tên là Đậu có thời gian sản xuất trên 10 ngày(103)_SP', N'Select * From SANPHAM Where TenSP Like N''%Đậu%'' and ThoiGian > 10')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (104, N'Sản Phẩm', N'Tìm sản phẩm có tên là Đậu có thời gian sản xuất dưới 10 ngày(104)_SP', N'Select * From SANPHAM Where TenSP Like N''%Đậu%'' and ThoiGian < 10')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (105, N'Sản Phẩm', N'Tìm sản phẩm có tên là Đậu có thời gian sản xuất dưới 5 ngày(105)_SP', N'Select * From SANPHAM Where TenSP Like N''%Đậu%'' and ThoiGian < 5')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (106, N'Sản Phẩm', N'Tìm sản phẩm có tên là Đậu có thời gian sản xuất trên 5 ngày(106)_SP', N'Select * From SANPHAM Where TenSP Like N''%Đậu%'' and ThoiGian > 5')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (107, N'Sản Phẩm', N'Tìm sản phẩm có tên là Cà Phê có thời gian sản xuất trên 10 ngày(107)_SP', N'select * from SANPHAM where TenSP like N''%Cà Phê%''and ThoiGian > 10')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (108, N'Sản Phẩm', N'Tìm sản phẩm có tên là Cà Phê có thời gian sản xuất dưới 10 ngày(108)_SP', N'select * from SANPHAM where TenSP like N''%Cà Phê%'' and ThoiGian < 10')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (109, N'Sản Phẩm', N'Tìm sản phẩm có tên là Cà Phê có thời gian sản xuất dưới 5 ngày(109)_SP', N'select * from SANPHAM where TenSP like N''%Cà Phê%'' and ThoiGian < 5')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (110, N'Sản Phẩm', N'Tìm sản phẩm có tên là Cà Phê có thời gian sản xuất trên 5 ngày(110)_SP', N'select * from SANPHAM where TenSP like N''%Cà Phê%'' and ThoiGian > 5
')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (111, N'Sản Phẩm', N'Tìm sản phẩm có tên là Kẹo có thời gian sản xuất trên 10 ngày(111)_SP', N'select * from SANPHAM where TenSP like N''%Kẹo%'' and ThoiGian > 10
')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (112, N'Sản Phẩm', N' Tìm sản phẩm có tên là Kẹo có thời gian sản xuất dưới 10 ngày(112)_SP', N'select * from SANPHAM where TenSP like N''%Kẹo%'' and ThoiGian < 10')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (113, N'Sản Phẩm', N'Tìm sản phẩm có tên là Kẹo có thời gian sản xuất dưới 5 ngày(113)_SP', N'select * from SANPHAM where TenSP like N''%Kẹo%''and ThoiGian < 5')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (114, N'Sản Phẩm', N'Tìm sản phẩm có tên là Kẹo có thời gian sản xuất trên 5 ngày(114)_SP', N'select * from SANPHAM where TenSP like N''%Kẹo%'' and ThoiGian > 5')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (115, N'Sản Phẩm', N'Tìm sản phẩm có quy cách đóng gói là hộp có thời gian sản xuất trên 10 ngày(115)_SP', N'select * from SANPHAM where QuyCachDongGoi like N''%Hộp%'' and ThoiGian > 10')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (116, N'Sản Phẩm', N'Tìm sản phẩm có quy cách đóng gói là hộp có thời gian sản xuất dưới 10 ngày(116)_SP', N'select * from SANPHAM where QuyCachDongGoi like N''%Hộp%'' and ThoiGian < 10')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (117, N'Sản Phẩm', N'Tìm sản phẩm có quy cách đóng gói là hộp có thời gian sản xuất dưới 5 ngày(117)_SP', N'select * from SANPHAM where QuyCachDongGoi like N''%Hộp%'' and ThoiGian < 5')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (118, N'Sản Phẩm', N'Tìm sản phẩm có quy cách đóng gói là hộp có thời gian sản xuất trên 5 ngày(118)_SP', N'select * from SANPHAM where QuyCachDongGoi like N''%Hộp%'' and ThoiGian > 5')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (119, N'Sản Phẩm', N' Tìm sản phẩm có quy cách đóng gói là bịch có thời gian sản xuất trên 10 ngày(119)_SP', N'select * from SANPHAM where QuyCachDongGoi like N''%Bịch%'' and ThoiGian > 10')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (120, N'Sản Phẩm', N'Tìm sản phẩm có quy cách đóng gói là bịch có thời gian sản xuất dưới 10 ngày(120)_SP', N'select * from SANPHAM where QuyCachDongGoi like N''%Bịch%'' and ThoiGian < 10')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (121, N'Sản Phẩm', N'Tìm sản phẩm có quy cách đóng gói là bịch có thời gian sản xuất dưới 5 ngày(121)_SP', N'select * from SANPHAM where QuyCachDongGoi like N''%Bịch%'' and ThoiGian < 5')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (122, N'Sản Phẩm', N'Tìm sản phẩm có quy cách đóng gói là bịch có thời gian sản xuất trên 5 ngày(122)_SP', N'select * from SANPHAM where QuyCachDongGoi like N''%Bịch%'' and ThoiGian > 5')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (123, N'Sản Phẩm', N'Tìm sản phẩm có quy cách đóng gói là Túi có thời gian sản xuất trên 10 ngày(123)_SP', N'select * from SANPHAM where QuyCachDongGoi like N''%Túi%'' and ThoiGian > 10
')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (124, N'Sản Phẩm', N'Tìm sản phẩm có quy cách đóng gói là Túi có thời gian sản xuất dưới 10 ngày(124)_SP', N'select * from SANPHAM where QuyCachDongGoi like N''%Túi%'' and ThoiGian < 10')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (125, N'Sản Phẩm', N'Tìm sản phẩm có quy cách đóng gói là Túi có thời gian sản xuất dưới 5 ngày(125)_SP', N'select * from SANPHAM where QuyCachDongGoi like N''%Túi%'' and ThoiGian < 5')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (126, N'Sản Phẩm', N'Tìm sản phẩm có quy cách đóng gói là Túi có thời gian sản xuất trên 5 ngày(126)_SP', N'select * from SANPHAM where QuyCachDongGoi like N''%Túi%'' and ThoiGian > 5')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (127, N'Sản Phẩm', N'Tìm sản phẩm có quy cách đóng gói là Hũ có thời gian sản xuất trên 10 ngày(127)_SP', N'select * from SANPHAM where QuyCachDongGoi like N''%Hũ%'' and ThoiGian > 10')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (128, N'Sản Phẩm', N'Tìm sản phẩm có quy cách đóng gói là Hũ có thời gian sản xuất dưới 10 ngày(127)_SP', N'select * from SANPHAM where QuyCachDongGoi like N''%Hũ%'' and ThoiGian < 10')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (129, N'Sản Phẩm', N'Tìm sản phẩm có quy cách đóng gói là Hũ có thời gian sản xuất dưới 5 ngày(129)_SP', N'select * from SANPHAM where QuyCachDongGoi like N''%Hũ%'' and ThoiGian < 5')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (130, N'Sản Phẩm', N'Tìm sản phẩm có quy cách đóng gói là Hũ có thời gian sản xuất trên 5 ngày(130)_SP', N'
select * from SANPHAM where QuyCachDongGoi like N''%Hũ%'' and ThoiGian > 5')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (131, N'Sản Phẩm', N'Tìm sản phẩm có giá lớn hơn 50000 có thời gian sản xuất trên 10 ngày(130)_SP', N'select * from SANPHAM where Gia > 50000 and ThoiGian > 10')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (132, N'Sản Phẩm', N'Tìm sản phẩm có giá lớn hơn 50000 có thời gian sản xuất dưới 10 ngày(132)_SP', N'select * from SANPHAM where Gia > 50000 and ThoiGian < 10')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (133, N'Sản Phẩm', N'Tìm sản phẩm có giá lớn hơn 50000 có thời gian sản xuất dưới 5 ngày(132)_SP', N'select * from SANPHAM where Gia > 50000 and ThoiGian < 5')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (134, N'Sản Phẩm', N'Tìm sản phẩm có giá lớn hơn 50000 có thời gian sản xuất trên 5 ngày(132)_SP', N'select * from SANPHAM where Gia > 50000 and ThoiGian > 5')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (135, N'Sản Phẩm', N'Tìm sản phẩm có giá nhỏ hơn 50000 có thời gian sản xuất trên 10 ngày(135)_SP', N'select * from SANPHAM where Gia < 50000 and ThoiGian > 10')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (136, N'Sản Phẩm', N'Tìm sản phẩm có giá nhỏ hơn 50000 có thời gian sản xuất dưới 10 ngày(135)_SP', N'select * from SANPHAM where Gia < 50000 and ThoiGian < 10')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (137, N'Sản Phẩm', N'Tìm sản phẩm có giá nhỏ hơn 50000 có thời gian sản xuất dưới 5 ngày(137)_SP', N'select * from SANPHAM where Gia < 50000 and ThoiGian < 5')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (138, N'Sản Phẩm', N'Tìm sản phẩm có giá nhỏ hơn 50000 có thời gian sản xuất trên 5 ngày(137)_SP', N'select * from SANPHAM where Gia < 50000 and ThoiGian > 5')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (139, N'Sản Phẩm', N'Tìm sản phẩm có giá nhỏ hơn 100000 có thời gian sản xuất trên 10 ngày(139)_SP', N'select * from SANPHAM where Gia < 100000 and ThoiGian > 10')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (140, N'Sản Phẩm', N'Tìm sản phẩm có giá nhỏ hơn 100000 có thời gian sản xuất dưới 10 ngày(139)_SP', N'select * from SANPHAM where Gia < 100000 and ThoiGian < 10')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (141, N'Sản Phẩm', N'Tìm sản phẩm có giá nhỏ hơn 100000 có thời gian sản xuất dưới 5 ngày(139)_SP', N'select * from SANPHAM where Gia < 100000 and ThoiGian < 5')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (142, N'Sản Phẩm', N'Tìm sản phẩm có giá nhỏ hơn 100000 có thời gian sản xuất trên 5 ngày(142)_SP', N'select * from SANPHAM where Gia < 100000 and ThoiGian > 5')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (143, N'Sản Phẩm', N'Tìm sản phẩm có giá lớn hơn 100000 có thời gian sản xuất trên 10 ngày(142)_SP', N'select * from SANPHAM where Gia < 100000 and ThoiGian > 10')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (144, N'Sản Phẩm', N' Tìm sản phẩm có giá lớn hơn 100000 có thời gian sản xuất dưới 10 ngày(144)_SP', N'select * from SANPHAM where Gia < 100000 and ThoiGian < 10')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (145, N'Sản Phẩm', N'Tìm sản phẩm có giá lớn hơn 100000 có thời gian sản xuất dưới 5 ngày(144)_SP', N'select * from SANPHAM where Gia < 100000 and ThoiGian < 5')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (146, N'Sản Phẩm', N' Tìm sản phẩm có giá lớn hơn 100000 có thời gian sản xuất trên 5 ngày(144)_SP', N'select * from SANPHAM where Gia < 100000 and ThoiGian > 5')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (147, N'Đơn Hàng Xuất', N'Tìm đơn hàng xuất có phương tiện vận chuyển là xe ôtô(147)_DHX', N'
select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau,ThoiGian,PhuongTien from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai where PhuongTien like N''%Xe Ôtô%''
order by SoLuong , MucChietKhau,  dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (148, N'Đơn Hàng Xuất', N'Tìm đơn hàng xuất có phương tiện vận chuyển là xe đầu kéo, Container(148)_DHX', N'
select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau,ThoiGian,PhuongTien from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai where PhuongTien like N''%Xe d?u kéo, Container%''
order by SoLuong , MucChietKhau,  dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (149, N'Đơn Hàng Xuất', N'Tìm đơn hàng xuất có phương tiện vận chuyển là Tàu lửa(149)_DHX', N'
select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau,ThoiGian,PhuongTien from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai where PhuongTien like  N''%Tàu l?a%''
order by SoLuong , MucChietKhau,  dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (150, N'Đơn Hàng Xuất', N'Tìm đơn hàng xuất có phương tiện vận chuyển là Hàng Không(150)_DHX', N'
select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau,ThoiGian,PhuongTien from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai where PhuongTien like  N''%Hàng Không%''
order by SoLuong , MucChietKhau,  dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (151, N'Đơn Hàng Xuất', N'Tìm đơn hàng xuất có phương tiện vận chuyển là xe ôtô và thời gian là dưới 5 ngày(151)_DHX', N'
select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau,ThoiGian,PhuongTien from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai where PhuongTien like   N''%Xe Ôtô%'' and thoigian < 5
order by SoLuong , MucChietKhau,  dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (152, N'Đơn Hàng Xuất', N' Tìm đơn hàng xuất có phương tiện vận chuyển là xe ôtô và thời gian là trên 5 ngày(152)_DHX', N'
select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau,ThoiGian,PhuongTien from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai where PhuongTien like   N''%Xe Ôtô%'' and thoigian > 5
order by SoLuong , MucChietKhau,  dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (153, N'Đơn Hàng Xuất', N'Tìm đơn hàng xuất có phương tiện vận chuyển là xe ôtô và thời gian là trên 10 ngày(153)_DHX', N'
select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau,ThoiGian,PhuongTien from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai where PhuongTien like   N''%Xe Ôtô%'' and thoigian > 10
order by SoLuong , MucChietKhau,  dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (154, N'Đơn Hàng Xuất', N'Tìm đơn hàng xuất có phương tiện vận chuyển là xe ôtô và thời gian là dưới 10 ngày(154)_DHX', N'
select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau,ThoiGian,PhuongTien from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai where PhuongTien like   N''%Xe Ôtô%'' and thoigian < 10
order by SoLuong , MucChietKhau,  dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (155, N'Đơn Hàng Xuất', N'Tìm đơn hàng xuất có phương tiện vận chuyển là xe đầu kéo, Container và thời gian là dưới 5 ngày(155)_DHX', N'
select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau,ThoiGian,PhuongTien from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai where PhuongTien like  N''%Xe d?u kéo, Container%'' and thoigian < 5
order by SoLuong , MucChietKhau,  dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (156, N'Đơn Hàng Xuất', N'Tìm đơn hàng xuất có phương tiện vận chuyển là xe đầu kéo, Container và thời gian là trên 5 ngày(156)_DHX', N'
select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau,ThoiGian,PhuongTien from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai where PhuongTien like  N''%Xe d?u kéo, Container%'' and thoigian > 5
order by SoLuong , MucChietKhau,  dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (157, N'Đơn Hàng Xuất', N'Tìm đơn hàng xuất có phương tiện vận chuyển là xe đầu kéo, Container và thời gian là trên 10 ngày(157)_DHX', N'
select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau,ThoiGian,PhuongTien from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai where PhuongTien like   N''%Xe d?u kéo, Container%'' and thoigian > 10
order by SoLuong , MucChietKhau,  dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (158, N'Đơn Hàng Xuất', N' Tìm đơn hàng xuất có phương tiện vận chuyển là xe đầu kéo, Container và thời gian là dưới 10 ngày(158)_DHX', N'
select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau,ThoiGian,PhuongTien from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai where PhuongTien like   N''%Xe d?u kéo, Container%'' and thoigian < 10
order by SoLuong , MucChietKhau,  dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (159, N'Đơn Hàng Xuất', N'Tìm đơn hàng xuất có phương tiện vận chuyển là Tàu lửa và thời gian là dưới 5 ngày(159)_DHX', N'
select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau,ThoiGian,PhuongTien from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai where PhuongTien like   N''%Tàu l?a%'' and thoigian < 5
order by SoLuong , MucChietKhau,  dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (160, N'Đơn Hàng Xuất', N'Tìm đơn hàng xuất có phương tiện vận chuyển là Tàu lửa và thời gian là trên 5 ngày(160)_DHX', N'
select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau,ThoiGian,PhuongTien from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai where PhuongTien like   N''%Tàu l?a%'' and thoigian > 5
order by SoLuong , MucChietKhau,  dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (161, N'Đơn Hàng Xuất', N' Tìm đơn hàng xuất có phương tiện vận chuyển là Tàu lửa và thời gian là trên 10 ngày(161)_DHX', N'
select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau,ThoiGian,PhuongTien from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai where PhuongTien like   N''%Tàu l?a%'' and thoigian > 10
order by SoLuong , MucChietKhau,  dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (162, N'Đơn Hàng Xuất', N' Tìm đơn hàng xuất có phương tiện vận chuyển là Tàu lửa và thời gian là dưới 10 ngày(162)_DHX', N'
select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau,ThoiGian,PhuongTien from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai where PhuongTien like   N''%Tàu l?a%'' and thoigian < 10
order by SoLuong , MucChietKhau,  dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (163, N'Đơn Hàng Xuất', N' Tìm đơn hàng xuất có phương tiện vận chuyển là Hàng Không và thời gian là dưới 5 ngày(163)_DHX', N'
select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau,ThoiGian,PhuongTien from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai where PhuongTien like  N''%Hàng Không%''  and thoigian < 5
order by SoLuong , MucChietKhau,  dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (164, N'Đơn Hàng Xuất', N'Tìm đơn hàng xuất có phương tiện vận chuyển là Hàng Không và thời gian là trên 5 ngày(164)_DHX', N'
select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau,ThoiGian,PhuongTien from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai where PhuongTien like  N''%Hàng Không%''  and thoigian > 5
order by SoLuong , MucChietKhau,  dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (165, N'Đơn Hàng Xuất', N'Tìm đơn hàng xuất có phương tiện vận chuyển là Hàng Không và thời gian là trên 10 ngày(165)_DHX', N'
select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau,ThoiGian,PhuongTien from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai where PhuongTien like  N''%Hàng Không%''  and thoigian > 10
order by SoLuong , MucChietKhau,  dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (166, N'Đơn Hàng Xuất', N'Tìm đơn hàng xuất có phương tiện vận chuyển là Hàng Không  và thời gian là dưới 10 ngày(166)_DHX', N'
select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau,ThoiGian,PhuongTien from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai where PhuongTien like  N''%Hàng Không%''  and thoigian < 10
order by SoLuong , MucChietKhau,  dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (167, N'Đơn Hàng Xuất', N'Tìm đơn hàng xuất có phương tiện vận chuyển là xe ôtô đã hoàn thành(167)_DHX', N'select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau,ThoiGian,PhuongTien from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai where TrangThai = 1 and PhuongTien like N''%Xe Ôtô%''
order by SoLuong , MucChietKhau,  dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa
')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (168, N'Đơn Hàng Xuất', N'Tìm đơn hàng xuất có phương tiện vận chuyển là xe ôtô chưa hoàn thành(168)_DHX', N'select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau,ThoiGian,PhuongTien from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai where TrangThai = 0 and PhuongTien like N''%Xe Ôtô%''
order by SoLuong , MucChietKhau,  dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa
')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (169, N'Đơn Hàng Xuất', N' Tìm đơn hàng xuất có phương tiện vận chuyển là xe đầu kéo, Container đã hoàn thành(169)_DHX', N'select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau,ThoiGian,PhuongTien from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai where TrangThai = 1 and PhuongTien like N''%Xe d?u kéo, Container%''
order by SoLuong , MucChietKhau,  dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa
')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (170, N'Đơn Hàng Xuất', N'Tìm đơn hàng xuất có phương tiện vận chuyển là xe đầu kéo, Container chưa hoàn thành(170)_DHX', N'select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau,ThoiGian,PhuongTien from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai where TrangThai = 0 and PhuongTien like N''%Xe d?u kéo, Container%''
order by SoLuong , MucChietKhau,  dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa
')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (171, N'Đơn Hàng Xuất', N'Tìm đơn hàng xuất có phương tiện vận chuyển là Tàu lửa chưa hoàn thành(171)_DHX', N'select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau,ThoiGian,PhuongTien from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai where TrangThai = 0 and PhuongTien like  N''%Tàu l?a%''
order by SoLuong , MucChietKhau,  dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa
')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (172, N'Đơn Hàng Xuất', N'Tìm đơn hàng xuất có phương tiện vận chuyển là Tàu lửa đã hoàn thành(172)_DHX', N'select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau,ThoiGian,PhuongTien from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai where TrangThai = 1 and PhuongTien like  N''%Tàu l?a%''
order by SoLuong , MucChietKhau,  dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa
')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (173, N'Đơn Hàng Xuất', N'Tìm đơn hàng xuất có phương tiện vận chuyển là Hàng Không chưa hoàn thành(173)_DHX', N'select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau,ThoiGian,PhuongTien from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai where TrangThai = 0 and PhuongTien like  N''%Hàng Không%'' 
order by SoLuong , MucChietKhau,  dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa
')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (174, N'Đơn Hàng Xuất', N'Tìm đơn hàng xuất có phương tiện vận chuyển là Hàng Không đã hoàn thành(174)_DHX', N'select distinct dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX,SoLuong, ct.isXoa,CONVERT(int, ldl.MucChietKhau) as MucChietKhau,ThoiGian,PhuongTien from DONHANGXUAT dhx 
left join CHITIETDONHANGXUAT ct on dhx.MaDHX=ct.MaDHX
left join DAILY dl  on dl.MaDL = dhx.MaDaiLy 
left join LOAIDAILY ldl on ldl.MaLoai = dl.MaLoai where TrangThai = 1 and PhuongTien like  N''%Hàng Không%'' 
order by SoLuong , MucChietKhau,  dhx.MaDHX, MaDaiLy, MaNV, TrangThai, dhx.isXoa, ct.MaDHX, ct.isXoa
')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (175, N'Đơn Hàng Nhập', N'Tìm đơn hàng nhập có phương tiện vận chuyển là xe ôtô(175)_DHN', N'select  dhn.*, ncc.TenNhaCC,Hoten from DONHANGNhap dhn 
left join NhaCungCap ncc on dhn.MaNhaCC = ncc.MaNCC
left join NHANVIEN nv on nv.MaNV = dhn.MaNV 
where PhuongTien like N''%Xe Ôtô%''
')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (176, N'Đơn Hàng Nhập', N'Tìm đơn hàng nhập có phương tiện vận chuyển là xe đầu kéo, Container(176)_DHN', N'select dhn.*, ncc.TenNhaCC,Hoten from DONHANGNhap dhn 
left join NhaCungCap ncc on dhn.MaNhaCC = ncc.MaNCC
left join NHANVIEN nv on nv.MaNV = dhn.MaNV 
where PhuongTien like N''%Xe đầu  kéo, Container%''
')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (177, N'Đơn Hàng Nhập', N'Tìm đơn hàng nhập có phương tiện vận chuyển là Tàu lửa(177)_DHN', N'select dhn.*, ncc.TenNhaCC,Hoten from DONHANGNhap dhn 
left join NhaCungCap ncc on dhn.MaNhaCC = ncc.MaNCC
left join NHANVIEN nv on nv.MaNV = dhn.MaNV 
where PhuongTien like  N''%Tàu  lửa%''
')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (178, N'Đơn Hàng Nhập', N' Tìm đơn hàng nhập có phương tiện vận chuyển là Hàng Không(178)_DHN', N'select dhn.*, ncc.TenNhaCC,Hoten from DONHANGNhap dhn 
left join NhaCungCap ncc on dhn.MaNhaCC = ncc.MaNCC
left join NHANVIEN nv on nv.MaNV = dhn.MaNV 
where PhuongTien like  N''%Hàng Không%'' 
')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (179, N'Đơn Hàng Nhập', N'Tìm đơn hàng nhập có phương tiện vận chuyển là xe ôtô và thời gian là dưới 5 ngày(179)_DHN', N'select dhn.*, ncc.TenNhaCC,Hoten from DONHANGNhap dhn 
left join NhaCungCap ncc on dhn.MaNhaCC = ncc.MaNCC
left join NHANVIEN nv on nv.MaNV = dhn.MaNV 
where PhuongTien like N''%Xe Ôtô%'' and thoigian < 5
')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (180, N'Đơn Hàng Nhập', N'Tìm đơn hàng nhập có phương tiện vận chuyển là xe ôtô và thời gian là trên 5 ngày(180)_DHN', N'select dhn.*, ncc.TenNhaCC,Hoten from DONHANGNhap dhn 
left join NhaCungCap ncc on dhn.MaNhaCC = ncc.MaNCC
left join NHANVIEN nv on nv.MaNV = dhn.MaNV 
where PhuongTien like N''%Xe Ôtô%'' and thoigian > 5
')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (181, N'Đơn Hàng Nhập', N'Tìm đơn hàng nhập có phương tiện vận chuyển là xe ôtô và thời gian là trên 10 ngày(181)_DHN', N'select dhn.*, ncc.TenNhaCC,Hoten from DONHANGNhap dhn 
left join NhaCungCap ncc on dhn.MaNhaCC = ncc.MaNCC
left join NHANVIEN nv on nv.MaNV = dhn.MaNV 
where PhuongTien like N''%Xe Ôtô%'' and thoigian > 10
')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (182, N'Đơn Hàng Nhập', N'Tìm đơn hàng nhập có phương tiện vận chuyển là xe ôtô và thời gian là dưới 10 ngày(182)_DHN', N'select dhn.*, ncc.TenNhaCC,Hoten from DONHANGNhap dhn 
left join NhaCungCap ncc on dhn.MaNhaCC = ncc.MaNCC
left join NHANVIEN nv on nv.MaNV = dhn.MaNV 
where PhuongTien like N''%Xe Ôtô%'' and thoigian < 10
')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (183, N'Đơn Hàng Nhập', N' Tìm đơn hàng nhập có phương tiện vận chuyển là xe đầu kéo, Container và thời gian là dưới 5 ngày(183)_DHN', N'select dhn.*, ncc.TenNhaCC,Hoten from DONHANGNhap dhn 
left join NhaCungCap ncc on dhn.MaNhaCC = ncc.MaNCC
left join NHANVIEN nv on nv.MaNV = dhn.MaNV 
where PhuongTien like N''%Xe đầu kéo, Container%'' and thoigian < 5
')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (184, N'Đơn Hàng Nhập', N'Tìm đơn hàng nhập có phương tiện vận chuyển là xe đầu kéo, Container và thời gian là trên 5 ngày(184)_DHN', N'select dhn.*, ncc.TenNhaCC,Hoten from DONHANGNhap dhn 
left join NhaCungCap ncc on dhn.MaNhaCC = ncc.MaNCC
left join NHANVIEN nv on nv.MaNV = dhn.MaNV 
where PhuongTien like N''%Xe đầu  kéo, Container%'' and thoigian > 5
')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (185, N'Đơn Hàng Nhập', N'Tìm đơn hàng nhập có phương tiện vận chuyển là xe đầu kéo, Container và thời gian là trên 10 ngày(185)_DHN', N'select dhn.*, ncc.TenNhaCC,Hoten from DONHANGNhap dhn 
left join NhaCungCap ncc on dhn.MaNhaCC = ncc.MaNCC
left join NHANVIEN nv on nv.MaNV = dhn.MaNV 
where PhuongTien like N''%Xe đầu  kéo, Container%'' and thoigian > 10
')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (186, N'Đơn Hàng Nhập', N'Tìm đơn hàng nhập có phương tiện vận chuyển là xe đầu kéo, Container và thời gian là dưới 10 ngày(186)_DHN', N'select dhn.*, ncc.TenNhaCC,Hoten from DONHANGNhap dhn 
left join NhaCungCap ncc on dhn.MaNhaCC = ncc.MaNCC
left join NHANVIEN nv on nv.MaNV = dhn.MaNV 
where PhuongTien like N''%Xe đầu  kéo, Container%'' and thoigian < 10
')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (187, N'Đơn Hàng Nhập', N'Tìm đơn hàng nhập có phương tiện vận chuyển là Tàu lửa và thời gian là dưới 5 ngày(187)_DHN', N'select dhn.*, ncc.TenNhaCC,Hoten from DONHANGNhap dhn 
left join NhaCungCap ncc on dhn.MaNhaCC = ncc.MaNCC
left join NHANVIEN nv on nv.MaNV = dhn.MaNV 
where PhuongTien like N''%Tàu lửa%'' and thoigian < 5
')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (188, N'Đơn Hàng Nhập', N'Tìm đơn hàng nhập có phương tiện vận chuyển là Tàu lửa và thời gian là trên 5 ngày(187)_DHN', N'select dhn.*, ncc.TenNhaCC,Hoten from DONHANGNhap dhn 
left join NhaCungCap ncc on dhn.MaNhaCC = ncc.MaNCC
left join NHANVIEN nv on nv.MaNV = dhn.MaNV 
where PhuongTien like N''%Tàu  lửa%'' and thoigian > 5
')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (189, N'Đơn Hàng Nhập', N'Tìm đơn hàng nhập có phương tiện vận chuyển là Tàu lửa và thời gian là trên 10 ngày(188)_DHN', N'select dhn.*, ncc.TenNhaCC,Hoten from DONHANGNhap dhn 
left join NhaCungCap ncc on dhn.MaNhaCC = ncc.MaNCC
left join NHANVIEN nv on nv.MaNV = dhn.MaNV 
where PhuongTien like N''%Tàu lửa%'' and thoigian > 10
')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (190, N'Đơn Hàng Nhập', N'Tìm đơn hàng nhập có phương tiện vận chuyển là Tàu lửa và thời gian là dưới 10 ngày(190)_DHN', N'select dhn.*, ncc.TenNhaCC,Hoten from DONHANGNhap dhn 
left join NhaCungCap ncc on dhn.MaNhaCC = ncc.MaNCC
left join NHANVIEN nv on nv.MaNV = dhn.MaNV 
where PhuongTien like N''%Tàu lửa%'' and thoigian < 10
')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (191, N'Đơn Hàng Nhập', N'Tìm đơn hàng nhập có phương tiện vận chuyển là Hàng Không và thời gian là dưới 5 ngày(191)_DHN', N'select dhn.*, ncc.TenNhaCC,Hoten from DONHANGNhap dhn 
left join NhaCungCap ncc on dhn.MaNhaCC = ncc.MaNCC
left join NHANVIEN nv on nv.MaNV = dhn.MaNV
where PhuongTien likeN''%Hàng Không%''  and thoigian < 5
')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (192, N'Đơn Hàng Nhập', N' Tìm đơn hàng nhập có phương tiện vận chuyển là Hàng Không và thời gian là trên 5 ngày(191)_DHN', N'select dhn.*, ncc.TenNhaCC,Hoten from DONHANGNhap dhn 
left join NhaCungCap ncc on dhn.MaNhaCC = ncc.MaNCC
left join NHANVIEN nv on nv.MaNV = dhn.MaNV
where PhuongTien like N''%Hàng Không%''  and thoigian > 5
')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (193, N'Đơn Hàng Nhập', N' Tìm đơn hàng nhập có phương tiện vận chuyển là Hàng Khôngvà thời gian là trên 10 ngày(192)_DHN', N'select dhn.*, ncc.TenNhaCC,Hoten from DONHANGNhap dhn 
left join NhaCungCap ncc on dhn.MaNhaCC = ncc.MaNCC
left join NHANVIEN nv on nv.MaNV = dhn.MaNV
where PhuongTien like N''%Hàng Không%''  and thoigian > 10
')
INSERT [dbo].[SQLGOIY] ([ID], [NameTable], [Name], [SqlString]) VALUES (194, N'Đơn Hàng Nhập', N'Tìm đơn hàng nhập có phương tiện vận chuyển là Hàng Không và thời gian là dưới 10 ngày(193)_DHN', N'select dhn.*, ncc.TenNhaCC,Hoten from DONHANGNhap dhn 
left join NhaCungCap ncc on dhn.MaNhaCC = ncc.MaNCC
left join NHANVIEN nv on nv.MaNV = dhn.MaNV
where PhuongTien like N''%Hàng Không%''  and thoigian < 10
')
SET IDENTITY_INSERT [dbo].[SQLGOIY] OFF
SET IDENTITY_INSERT [dbo].[TAIKHOAN] ON 

INSERT [dbo].[TAIKHOAN] ([ID], [TaiKhoan], [MatKhau], [HoTen], [ISADMIN]) VALUES (1, N'admin', N'21232F297A57A5A743894A0E4A801FC3', N'phuoc 122', 1)
INSERT [dbo].[TAIKHOAN] ([ID], [TaiKhoan], [MatKhau], [HoTen], [ISADMIN]) VALUES (2, N'tnphuoc', N'21232F297A57A5A743894A0E4A801FC3', N'Tran Ngoc A', 0)
SET IDENTITY_INSERT [dbo].[TAIKHOAN] OFF
SET IDENTITY_INSERT [dbo].[TRAM] ON 

INSERT [dbo].[TRAM] ([MaTram], [TenTram], [isXoa]) VALUES (1, N'Trạm Bùi Thì Xuân', 0)
INSERT [dbo].[TRAM] ([MaTram], [TenTram], [isXoa]) VALUES (2, N'Trạm Nguyễn Văn Cừ', 0)
INSERT [dbo].[TRAM] ([MaTram], [TenTram], [isXoa]) VALUES (3, N'Trạm Phù Đổng Thiên Vương', 0)
INSERT [dbo].[TRAM] ([MaTram], [TenTram], [isXoa]) VALUES (4, N'Trạm Hồ Xuân Hương', 0)
INSERT [dbo].[TRAM] ([MaTram], [TenTram], [isXoa]) VALUES (5, N'Trạm Hoàng Văn Thụ', 0)
SET IDENTITY_INSERT [dbo].[TRAM] OFF
ALTER TABLE [dbo].[LOAIDAILY] ADD  CONSTRAINT [DF_LOAIDAILY_isXoa]  DEFAULT ((0)) FOR [isXoa]
GO
ALTER TABLE [dbo].[LUUVET] ADD  CONSTRAINT [DF_LUUVET_TTVC]  DEFAULT ((0)) FOR [MaTram]
GO
ALTER TABLE [dbo].[LUUVET] ADD  CONSTRAINT [DF_LUUVET_Tram1]  DEFAULT ((0)) FOR [MaNV]
GO
ALTER TABLE [dbo].[LUUVET] ADD  CONSTRAINT [DF_LUUVET_Tram2]  DEFAULT ((0)) FOR [TrangThai]
GO
ALTER TABLE [dbo].[LUUVET] ADD  CONSTRAINT [DF_LUUVET_isXoa]  DEFAULT ((0)) FOR [isXoa]
GO
ALTER TABLE [dbo].[NHACUNGCAP] ADD  CONSTRAINT [DF_NHACUNGCAP_isXoa]  DEFAULT ((0)) FOR [isXoa]
GO
ALTER TABLE [dbo].[NHANVIEN] ADD  CONSTRAINT [DF_NHANVIEN_isXoa]  DEFAULT ((0)) FOR [isXoa]
GO
ALTER TABLE [dbo].[TRAM] ADD  CONSTRAINT [DF_TRAM_isXoa]  DEFAULT ((0)) FOR [isXoa]
GO
