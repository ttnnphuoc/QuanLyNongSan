-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE HangTonKho

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


	select #Temp1.MaSP,#Temp1.SoLuong as SLN,#Temp2.SoLuong as SLX,  (#Temp1.SoLuong - #temp2.SoLuong) as SoLuongConLai
	from #Temp1 left join #temp2 on #temp1.MaSP = #temp2.MaSP 
	where (#Temp1.SoLuong - #temp2.SoLuong) > 0 order by   #Temp1.MaSP

END
GO
