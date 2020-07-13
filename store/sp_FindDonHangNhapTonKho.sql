USE [QLCUNGUNG]
GO
/****** Object:  StoredProcedure [dbo].[sp_FindDonHangNhap]    Script Date: 4/19/2020 6:06:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Alter PROCEDURE [dbo].[sp_FindDonHangNhapTonKho] @maSP NVARCHAR(Max)
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