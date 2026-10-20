USE [jig_tool_system]
GO

/****** Object:  Table [dbo].[jtPM_ProblemCheck_approve]    Script Date: 10/20/2026 8:14:59 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[jtPM_ProblemCheck_approve](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[PM_problem_id] [int] NULL,
	[PM_problem_name] [varchar](50) NULL,
	[Leader_eng3_by] [varchar](50) NULL,
	[Leader_eng3_date] [datetime] NULL,
	[Leader_eng4_by] [varchar](50) NULL,
	[Leader_eng4_date] [datetime] NULL,
	[Mgr_by] [varchar](50) NULL,
	[Mgr_date] [datetime] NULL,
 CONSTRAINT [PK_jtPM_ProblemCheck_approve] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


