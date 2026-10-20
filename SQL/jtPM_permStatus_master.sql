USE [jig_tool_system]
GO

/****** Object:  Table [dbo].[jtPM_permStatus_master]    Script Date: 10/20/2026 8:15:43 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[jtPM_permStatus_master](
	[perm_status_id] [int] NOT NULL,
	[perm_status_name] [nvarchar](50) NULL,
 CONSTRAINT [PK_jtPM_permStatus_master] PRIMARY KEY CLUSTERED 
(
	[perm_status_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


