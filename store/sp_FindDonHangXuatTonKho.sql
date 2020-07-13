USE [QLCUNGUNG]
GO
/****** Object:  StoredProcedure [dbo].[sp_FindDonHangNhap]    Script Date: 4/19/2020 6:06:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Alter PROCEDURE [dbo].[sp_FindDonHangXuatTonKho] @maSP NVARCHAR(Max)
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