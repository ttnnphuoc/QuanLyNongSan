
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE GetAllGhiLog
	@id varchar(10)
AS
BEGIN
	select * from GhiLog where (@id = '' or Id = @id)
END
GO
