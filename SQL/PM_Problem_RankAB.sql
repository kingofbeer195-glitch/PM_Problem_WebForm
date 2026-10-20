USE [jig_tool_system]
GO

/****** Object:  View [dbo].[PM_Problem_RankAB]    Script Date: 10/20/2026 9:08:56 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[PM_Problem_RankAB]
AS
SELECT        A.PM_problem_id, A.PM_problem_name, A.PRC_Grop_id, B.PRC_Grop_name, F.tool_id, F.tool_no, G.toolSub_id, C.CheckListAB_id AS CheckListC1_id, C.CheckListAB_name AS CheckListC1_name, '' AS CheckListC2_id, 
                         '' AS CheckListC2_name, A.isClose, REPLACE(CONVERT(varchar, B.check_date, 106), ' ', '-') + ' ' + CONVERT(varchar, B.check_date, 108) AS check_date, CASE WHEN A.shift IS NULL 
                         THEN (CASE WHEN CAST(B.check_date AS time) BETWEEN '08:00:00' AND '19:59:59' THEN 1 ELSE 2 END) ELSE A.shift END AS Shift, A.prob_detail, A.prob_topic, REPLACE(CONVERT(varchar, A.plan_finish, 106), ' ', '-') 
                         AS plan_finish, REPLACE(CONVERT(varchar, A.actual_finish, 106), ' ', '-') AS actual_finish, A.pic, A.symbol, A.pro_type1, A.pro_type2, A.pro_type3, A.part_equi, A.priority, A.isOnplan, A.prog_status, F.rank_id, 
                         K.group_id AS group_owner, A.group_resp, A.TSS_sub, A.TSS_Main, A.TSS_comment, REPLACE(CONVERT(varchar, A.Follow_up, 106), ' ', '-') AS Follow_up, A.PM_DOC AS TypeProblem, A.action_id, G.FixAcces, A.touch_status, 
                         A.risk_status, B.check_by, P.fname AS check_name, A.spec_checkList, A.actual_spec_checkList, A.result_spec_checkList, A.result_prob_detail, B.manual_status
FROM            dbo.jtPM_problem AS A LEFT OUTER JOIN
                         dbo.jtPM_PeriodCheck_his AS B ON A.PRC_Grop_id = B.PRC_Grop_id AND A.check_list1 = B.check_list1 AND ISNULL(A.check_list2, 0) = ISNULL(B.check_list2, 0) AND SUBSTRING(A.PM_problem_name, 5, 2) 
                         = SUBSTRING(B.PRC_Grop_name, 5, 2) LEFT OUTER JOIN
                         dbo.jtPM_CheckListAB_master AS C ON A.check_list1 = C.CheckListAB_id LEFT OUTER JOIN
                         dbo.tool_master AS F ON B.tool_id = F.tool_id LEFT OUTER JOIN
                         dbo.toolSub_list AS G ON B.tool_id = G.tool_id AND B.toolSub_id = G.toolSub_id LEFT OUTER JOIN
                         CPTSVS528.user_master.dbo.eng_group_master AS K ON F.classification = K.group_id AND K.dept IN (3, 5) LEFT OUTER JOIN
                         CPTSVS528.user_master.dbo.sys_user_master AS P ON B.check_by = P.emp_id
WHERE        (F.rank_id IN ('A', 'B'))
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4[30] 2[28] 3) )"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2[52] 3) )"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 5
   End
   Begin DiagramPane = 
      PaneHidden = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "A"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 230
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "B"
            Begin Extent = 
               Top = 6
               Left = 268
               Bottom = 136
               Right = 458
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "C"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 251
               Right = 228
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "F"
            Begin Extent = 
               Top = 138
               Left = 266
               Bottom = 268
               Right = 436
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "G"
            Begin Extent = 
               Top = 252
               Left = 38
               Bottom = 382
               Right = 213
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "K"
            Begin Extent = 
               Top = 6
               Left = 496
               Bottom = 136
               Right = 666
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "P"
            Begin Extent = 
               Top = 6
               Left = 704
               Bottom = 146
               Right = 879
            End
            DisplayFlags = 280
            TopColumn = 0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PM_Problem_RankAB'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 44
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      PaneHidden = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PM_Problem_RankAB'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PM_Problem_RankAB'
GO


