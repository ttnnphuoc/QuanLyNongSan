ALTER PROCEDURE [dbo].[sp_FindNhaCC] @ma NVARCHAR(Max)
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