USE [jig_tool_system]
GO

/****** Object:  Table [dbo].[jtPM_symbol_master]    Script Date: 10/20/2026 8:16:13 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[jtPM_symbol_master](
	[symbol_id] [int] NOT NULL,
	[symbol_name] [nvarchar](50) NULL,
	[type] [int] NULL,
	[id_no] [int] NULL,
 CONSTRAINT [PK_jtPM_symbol_master] PRIMARY KEY CLUSTERED 
(
	[symbol_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


