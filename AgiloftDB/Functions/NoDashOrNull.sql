CREATE FUNCTION [dbo].[NoDashOrNull]
(
	@Txt nvarchar(Max)
)
RETURNS Nvarchar(MAX)
AS
BEGIN
	RETURN CASE WHEN @Txt is null or @Txt = '-' THEN '' ELSE @Txt END
END