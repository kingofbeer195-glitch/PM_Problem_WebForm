USE [jig_tool_system]
GO

/****** Object:  Table [dbo].[jtPM_problem]    Script Date: 10/20/2026 8:14:40 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[jtPM_problem](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[PM_problem_id] [int] NULL,
	[PM_problem_name] [varchar](50) NULL,
	[PRC_Grop_id] [int] NULL,
	[check_list1] [int] NULL,
	[check_list2] [int] NULL,
	[isClose] [int] NULL,
	[plan_finish] [date] NULL,
	[actual_finish] [date] NULL,
	[prob_detail] [nvarchar](2000) NULL,
	[shift] [int] NULL,
	[prob_topic] [nvarchar](150) NULL,
	[symbol] [int] NULL,
	[priority] [varchar](1) NULL,
	[isOnplan] [int] NULL,
	[prog_status] [int] NULL,
	[problem_type] [int] NULL,
	[temp_status] [int] NULL,
	[temp_planFinish] [date] NULL,
	[perm_status] [int] NULL,
	[perm_planFinish] [date] NULL,
	[TSS_sub] [int] NULL,
	[TSS_Main] [int] NULL,
	[group_resp] [int] NULL,
	[pic] [varchar](10) NULL,
	[PM_DOC] [int] NULL,
	[Follow_up] [date] NULL,
	[TSS_comment] [nvarchar](2000) NULL,
	[action_id] [int] NULL,
	[acknowledge_date] [datetime] NULL,
	[acknowledge_by] [nvarchar](50) NULL,
	[pro_type1] [int] NULL,
	[pro_type2] [int] NULL,
	[pro_type3] [int] NULL,
	[part_equi] [int] NULL,
	[touch_status] [nvarchar](50) NULL,
	[risk_status] [nvarchar](50) NULL,
	[check_by] [nvarchar](50) NULL,
	[EmailAcknowledge_date] [datetime] NULL,
	[EmailAcknowledge_by] [nvarchar](50) NULL,
	[EmailFollow_date] [datetime] NULL,
	[EmailFollow_by] [nvarchar](50) NULL,
	[spec_checkList] [nvarchar](50) NULL,
	[actual_spec_checkList] [nvarchar](50) NULL,
	[result_spec_checkList] [nvarchar](50) NULL,
	[result_prob_detail] [nvarchar](500) NULL,
 CONSTRAINT [PK_jtPM_problem] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'jtPM_symbol_master' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'jtPM_problem', @level2type=N'COLUMN',@level2name=N'symbol'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'jtPM_master_doc' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'jtPM_problem', @level2type=N'COLUMN',@level2name=N'PM_DOC'
GO


