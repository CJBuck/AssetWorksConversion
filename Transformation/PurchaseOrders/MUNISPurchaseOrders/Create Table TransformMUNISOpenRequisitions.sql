USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformMUNISOpenRequisitions]    Script Date: 09/15/2015 09:21:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransformMUNISOpenRequisitions]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[TransformMUNISOpenRequisitions]
GO

USE [AssetWorksConversion]
GO

/****** Object:  Table [dbo].[TransformMUNISOpenRequisitions]    Script Date: 09/15/2015 09:21:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TransformMUNISOpenRequisitions](
	[rh_fiscal_year] [float] NULL,
	[a_requisition_no] [float] NULL,
	[rh_prep_date] [datetime] NULL,
	[rh_comments_generl] [nvarchar](255) NULL,
	[rh_amount_total] [float] NULL,
	[a_purch_order_no] [float] NULL,
	[rh_status_code] [float] NULL,
	[rh_vendor_suggest] [float] NULL,
	[a_department_code] [nvarchar](255) NULL,
	[rh_clerk_id] [nvarchar](255) NULL,
	[CreateDt] [datetime] NOT NULL
) ON [PRIMARY]
GO

INSERT INTO TransformMUNISOpenRequisitions
SELECT
	[rh_fiscal_year], [a_requisition_no], [rh_prep_date], [rh_comments_generl],
	[rh_amount_total], [a_purch_order_no], [rh_status_code], [rh_vendor_suggest],
	[a_department_code], [rh_clerk_id],
	GETDATE()
FROM STAGING_TransformMUNISOpenRequisitions
