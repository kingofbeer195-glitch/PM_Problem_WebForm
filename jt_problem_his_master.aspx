<%@ Page Language="C#" AutoEventWireup="true"
    CodeFile="jt_problem_his_master.aspx.cs"
    Inherits="jig_tool.jt_problem_his_master"
    MasterPageFile="~/MasterPage_Problem.master"
    MaintainScrollPositionOnPostback="true"
    EnableEventValidation="false" %>

<asp:Content ID="Content1" runat="server" ContentPlaceHolderID="ContentPlaceHolder1">

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="Content/bootstrap.css" />
    <link href="CSS/Color_History_Status.css" rel="stylesheet" />
    <link href="CSS/Color_Priority.css" rel="stylesheet" />
    <link href="CSS/Color_symbol.css" rel="stylesheet" />
    <link href="DataTables-1.10.18/fixedHeader.dataTables.min.css" rel="stylesheet" />
        <link rel="stylesheet" href="Content/font-awesome.css" />
    <link href="DateTimePicker/2-bootstrap-datetimepicker.min.css" rel="stylesheet" />
    <link href="DateTimePicker/3-bootstrap-datetimepicker-standalone.css" rel="stylesheet" />
    <link rel="stylesheet" href="Content/bootstrap.css" />

    <script src="DataTables-1.10.18/dataTables.fixedHeader.min.js"></script>

    <script src="DateTimePicker/1-moment.min.js"></script>
    <script src="DateTimePicker/4-bootstrap-datetimepicker.min.js"></script>

     <%--UpdateProgress--%>
    <style type="text/css">
        .overlay {
            position: fixed;
            z-index: 98;
            top: 0px;
            left: 0px;
            right: 0px;
            bottom: 0px;
            background-color: #aaa;
            filter: alpha(opacity=80);
            opacity: 0.8;
        }

        .overlayContent {
            z-index: 99;
            margin: 250px auto;
            width: 80px;
            height: 80px;
        }

            .overlayContent h2 {
                font-size: 18px;
                font-weight: bold;
                color: #000;
            }

            .overlayContent img {
                width: 80px;
                height: 80px;
            }
    </style>

    <style type="text/css">
       
        .status {
            background-color: #dbf1ff;
        }

        .status2 {
            background-color: darkgray;
        }

        .status3 {
            background-color: #F2CD5C;
        }

        .table-noborder tr td {
            border: 0px !important;
        }

        .btn-default {
            border: 1px solid gray;
        }


        .btn {
            height: 26px;
            vertical-align: middle !important;
            padding: 3px 6px;
        }

        .symbol_99 {
            background-color: #AAE3E2;
            color: #262626;
        }

        .form-control {
            height: 26px !important;
            vertical-align: middle !important;
            padding: 3px 6px;
            font-size: small;
        }

        .scrollbar {
            scrollbar-base-color: #ffffff;
            scrollbar-face-color: #dce5ef;
            scrollbar-3dlight-color: #f2f2f2;
            scrollbar-highlight-color: #ffffff;
            scrollbar-track-color: #f2f2f2;
            scrollbar-arrow-color: #f2f2f2;
            scrollbar-shadow-color: #dce5ef;
            scrollbar-dark-shadow-color: #f2f2f2;
        }

        table thead tr th {
            text-align: center !important;
        }

        table tbody tr td {
            /*text-align: center !important;*/
            vertical-align: middle !important;
        }

        .input-group-addon {
            padding: 4px 10px;
        }
    </style>

    <script type="text/javascript">
        $(document).ready(function () {
            Set_datePicker();
            gridviewScroll();

            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(gridviewScroll);
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(Set_datePicker);

        });
        function Set_datePicker() {

            $('.date').datetimepicker({
                format: 'DD-MMM-YYYY',
            });

        }

        function gridviewScroll() {
            var gridHeight = $(window).height();
            var gridWidth = $(window).width();
            var table = $("#" + "<%= gv1.ClientID %>").DataTable({
                "bDestroy": true,
                "ordering": false,
                "scrollX": true,
                "dom": '<<t>>',
                "pageLength": 200,
                scrollCollapse: true,
                scrollY: "" + (gridHeight - 450) + "px",
                fixedColumns: {
                    leftColumns: 5
                },
                "initComplete": function (settings, json) {
                    $('body').find('.dataTables_scrollBody').addClass("scrollbar");
                    //$("div.dataTables_wrapper").css('max-width', "" + (gridWidth - 30) + "px");
                },
            });
        }
    </script>

    <asp:ScriptManager ID="ScriptManager1" EnablePageMethods="true" runat="server"></asp:ScriptManager>

    <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1" DisplayAfter="100">
        <ProgressTemplate>
            <div class="overlay">
                <div class="overlayContent">
                    <div style="border-width: 0px; position: fixed; font-size: 36px; margin: auto; text-align: center">
                        Loading...
                            <br />
                        <i class="fa fa-spinner fa-spin"></i>
                    </div>
                </div>
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server" >
        <ContentTemplate>
            <asp:Panel ID="Panel1" runat="server">
                <div class="container" style="margin-top: -20px !important; background-color: #F2F2F2; width: 100%">
                    <div class="form-inline">
                        <div class="form-group tdLabel">
                            <asp:Label ID="lbl_list" runat="server" Font-Bold="true" Font-Size="20" CssClass="form-control-static" ForeColor="#747474"><span class="glyphicon glyphicon-list-alt"></span>&nbsp;PM Problem Control List</asp:Label>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-lg-5">
                            <table style="width: 100%" class="tb_border">
                                <tr>
                                    <td style="width: 30%; text-align: end">
                                        <label class="form-control-static">PM Problem No. :&nbsp;</label>
                                    </td>
                                    <td style="width: 25%">
                                        <asp:TextBox ID="txt_problem" runat="server" CssClass="form-control" OnTextChanged="txt_problem_TextChanged" AutoPostBack="true"></asp:TextBox>

                                    </td>
                                    <td style="width: 25%"></td>
                                    <td style="width: 20%"></td>
                                </tr>
                                <tr>
                                    <td style="text-align: end">
                                        <label class="form-control-static">type :&nbsp;</label>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddl_type" runat="server" CssClass="form-control"
                                            AppendDataBoundItems="true" DataSourceID="sql_ddl_type"
                                            DataTextField="pm_docName"
                                            ataValueField="pm_docID"
                                            OnSelectedIndexChanged="ddl_type_SelectedIndexChanged"
                                            AutoPostBack="true">
                                            <asp:ListItem Value="">-selected-</asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:SqlDataSource ID="sql_ddl_type" runat="server"
                                            ConnectionString="<%$ ConnectionStrings:jig_tool_systemConnectionString  %>"
                                            SelectCommand="select * from jtPM_master_doc where active = 1 order by pm_docID"></asp:SqlDataSource>
                                    </td>
                                    <td style="text-align: end">
                                        <label class="form-control-static">&nbsp;Status :&nbsp;</label>

                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddl_status" runat="server" CssClass="form-control" AppendDataBoundItems="true"
                                            OnSelectedIndexChanged="ddl_status_SelectedIndexChanged"
                                            DataSourceID="sql_promStatus" 
                                            DataValueField="perm_status_id" 
                                            DataTextField="perm_status_name"
                                            AutoPostBack="true">
                                            <asp:ListItem Value="">-selected-</asp:ListItem>
                                           
                                        </asp:DropDownList>
                                          <asp:SqlDataSource ID="sql_promStatus" runat="server" ConnectionString="<%$ ConnectionStrings:jig_tool_systemConnectionString %>"
                                                SelectCommand="select * from  jtPM_permStatus_master "></asp:SqlDataSource>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: end">
                                        <label class="form-control-static">Symbol :&nbsp;</label>
                                    </td>
                                    <td>
                                        <asp:DropDownList runat="server"
                                            ID="ddl_symbol"
                                            DataSourceID="sql_type1"
                                            DataTextField="SYM_NAME"
                                            DataValueField="symbol_id"
                                            CssClass="form-control " AppendDataBoundItems="true" AutoPostBack="true" OnSelectedIndexChanged="ddl_symbol_SelectedIndexChanged">
                                            <asp:ListItem Value="">-</asp:ListItem>
                                        </asp:DropDownList>
                                         
                                    </td>
                                    <td style="text-align: end">
                                        <label class="form-control-static">&nbsp;Resp. Group :&nbsp;</label>

                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddl_resp" runat="server" CssClass="form-control" DataSourceID="sql_resp" DataValueField="group_id" DataTextField="group_name"
                                            AppendDataBoundItems="true" OnSelectedIndexChanged="ddl_resp_SelectedIndexChanged" AutoPostBack="true">
                                            <asp:ListItem Value="">-selected-</asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:SqlDataSource ID="sql_resp" runat="server"
                                            ConnectionString="<%$ ConnectionStrings:User_ConnectionString %>"
                                            SelectCommand="select * from user_master.dbo.eng_group_master where active = 1 and dept in(3,5) order by group_name "></asp:SqlDataSource>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: end">
                                        <label class="form-control-static">Action :&nbsp;</label>

                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddl_action" runat="server" CssClass="form-control" AppendDataBoundItems="true"
                                            OnSelectedIndexChanged="ddl_action_SelectedIndexChanged" 
                                            DataSourceID="SqlDataSource1" 
                                            DataValueField="action_id" 
                                            DataTextField="action_name"
                                            AutoPostBack="true">
                                            <asp:ListItem Value="">-selected-</asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:jig_tool_systemConnectionString %>"
                                         SelectCommand="select action_id,action_name from  jtPM_actionStatus_master order by action_id"></asp:SqlDataSource>
                                    </td>
                                    <td style="text-align: end">
                                        <label class="form-control-static">&nbsp;Resp. Name :&nbsp; </label>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddl_resp_name" runat="server" CssClass="form-control"
                                            DataSourceID="sql_ddl_resp_name" DataValueField="emp_id"
                                            DataTextField="name" AppendDataBoundItems="true" OnSelectedIndexChanged="ddl_resp_name_SelectedIndexChanged" AutoPostBack="true">
                                        <asp:ListItem Value="">-selected-</asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:SqlDataSource ID="sql_ddl_resp_name" runat="server"
                                            ConnectionString="<%$ ConnectionStrings:User_ConnectionString %>"
                                            SelectCommand=" select 'Pakapol S.' as name ,8 as position_id,5 as eng_group_id,5 as user_dept,'018710' as emp_id , 1 as order_
                                                            union 
                                                            select REPLACE(REPLACE(fname,'Ms.',''),'Mr.','') + ' ' + SUBSTRING(lname,1,1) + '.' as name,position_id,eng_group_id,user_dept ,emp_id, 1 as order_ 
                                                            from user_master.dbo.sys_user_master a where user_dept in (3,5) and position_id <> 7 and status = 1 and position_id <> 9 order by name"></asp:SqlDataSource>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: end">
                                        <label class="form-control-static">Priority :&nbsp;</label>

                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddl_priority" runat="server" CssClass="form-control" AppendDataBoundItems="true"
                                            OnSelectedIndexChanged="ddl_priority_SelectedIndexChanged"
                                            AutoPostBack="true">
                                            <asp:ListItem Value="">-selected-</asp:ListItem>
                                            <asp:ListItem Value="A">A : Calibration / Urgent action</asp:ListItem>
                                            <asp:ListItem Value="B">B : Action / Use lead time for action</asp:ListItem>
                                            <asp:ListItem Value="C">C : Accept use / Monitoring</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                    <td style="text-align: end">
                                        <label class="form-control-static">Issue Name :&nbsp;</label>
                                    </td>
                                    <td>
                                        <asp:DropDownList runat="server" ID="ddl_Issue"
                                            CssClass="form-control"
                                            AutoPostBack="true" DataSourceID="sql_ddl_resp_name"
                                            DataValueField="emp_id"
                                            DataTextField="name" AppendDataBoundItems="true"
                                            OnSelectedIndexChanged="ddl_Issue_SelectedIndexChanged">
                                        <asp:ListItem Value="">-selected-</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: end">
                                        <label class="form-control-static">Follow Up :&nbsp;</label>
                                    </td>
                                    <td>
                                        <div class='input-group date' id='div1' runat="server">
                                            <asp:TextBox ID="txt_follow_up" runat="server" CssClass="form-control ff" AutoPostBack="true" OnTextChanged="txt_follow_up_TextChanged"></asp:TextBox>
                                            <span class="input-group-addon">
                                                <span class="glyphicon glyphicon-calendar"></span>
                                            </span>
                                        </div>
                                    </td>
                                    <td style="text-align: end!important">
                                        <div class='input-group date' id='div2' runat="server">
                                            <asp:TextBox ID="txt_follow_up2" runat="server" CssClass="form-control ff" AutoPostBack="true" OnTextChanged="txt_follow_up_TextChanged"></asp:TextBox>
                                            <span class="input-group-addon">
                                                <span class="glyphicon glyphicon-calendar"></span>
                                            </span>
                                        </div>
                                    </td>
                                    <td></td>
                                </tr>
                            </table>
                        </div>
                        <div class="col-lg-4">
                            <table style="width: 100%!important">
                                <tr>
                                    <td style="width: 30%; text-align: end">
                                        <label class="form-control-static">Tool No :&nbsp;</label>
                                    </td>
                                    <td style="width: 25%">
                                        <asp:TextBox ID="txt_tool_no" runat="server" CssClass="form-control" OnTextChanged="txt_tool_no_TextChanged" AutoPostBack="true"></asp:TextBox>
                                    </td>
                                    <td style="width: 25%; text-align: end">
                                        <label class="form-control-static">&nbsp; Model :&nbsp;</label>

                                    </td>
                                    <td style="width: 20%">
                                        <asp:DropDownList ID="ddl_model" runat="server" CssClass="form-control"
                                            DataSourceID="sql_model" DataValueField="model_id" DataTextField="model_name"
                                            AppendDataBoundItems="true" OnSelectedIndexChanged="ddl_model_SelectedIndexChanged" AutoPostBack="true">
                                            <asp:ListItem Value="">-selected-</asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:SqlDataSource ID="sql_model" runat="server"
                                            ConnectionString="<%$ ConnectionStrings:jig_tool_systemConnectionString %>"
                                            SelectCommand="select model_id, model_name from draw_master_model order by model_id"></asp:SqlDataSource>
                                    </td>
                                </tr>

                                <tr>
                                    <td style="text-align: end">
                                        <label class="form-control-static">No of Tool :&nbsp;</label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txt_no_of_tool" runat="server" CssClass="form-control" Width="80px" OnTextChanged="txt_no_of_tool_TextChanged" AutoPostBack="true"></asp:TextBox>
                                    </td>
                                    <td>
                                        <label class="form-control-static" style="text-align: end">&nbsp; Tool Owner :&nbsp;</label>

                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddl_tool_owner" runat="server" CssClass="form-control"
                                            DataSourceID="sql_tool_owner" DataValueField="group_id" DataTextField="group_name"
                                            AppendDataBoundItems="true" OnSelectedIndexChanged="ddl_tool_owner_SelectedIndexChanged" AutoPostBack="true">
                                            <asp:ListItem Value="">-selected-</asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:SqlDataSource ID="sql_tool_owner" runat="server"
                                            ConnectionString="<%$ ConnectionStrings:User_ConnectionString %>"
                                            SelectCommand="select * from user_master.dbo.eng_group_master where dept in (3,5) and active = 1"></asp:SqlDataSource>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: end">
                                        <label>Problem Date:&nbsp;</label>
                                    </td>
                                    <td>
                                        <div class='input-group date' id='div3' runat="server">
                                            <asp:TextBox ID="txt_problem1" runat="server" CssClass="form-control ff" AutoPostBack="true" OnTextChanged="txt_follow_up_TextChanged"></asp:TextBox>
                                            <span class="input-group-addon">
                                                <span class="glyphicon glyphicon-calendar"></span>
                                            </span>
                                        </div>
                                    </td>
                                    <td style="text-align: center!important" class="row">
                                        <div class='input-group date' id='div4' runat="server">
                                            <asp:TextBox ID="txt_problem2" runat="server" CssClass="form-control ff" AutoPostBack="true" OnTextChanged="txt_follow_up_TextChanged"></asp:TextBox>
                                            <span class="input-group-addon">
                                                <span class="glyphicon glyphicon-calendar"></span>
                                            </span>
                                        </div>
                                    </td>
                                    <td></td>
                                </tr>

                                <tr>
                                    <td style="width: 6%; text-align: end">
                                        <label class="form-control-static">Year :&nbsp;</label>
                                    </td>
                                    <td style="width: 22%">

                                        <asp:DropDownList ID="ddl_year" runat="server" CssClass="form-control" AppendDataBoundItems="false" OnSelectedIndexChanged="ddl_year_SelectedIndexChanged" AutoPostBack="true">
                                            <asp:ListItem Value="">-selected-</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                    <td style="text-align: end">
                                        <label class="form-control-static">&nbsp; Shift :&nbsp;</label>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddl_shift" runat="server" CssClass="form-control" AppendDataBoundItems="true" OnSelectedIndexChanged="ddl_shift_SelectedIndexChanged" AutoPostBack="true">
                                            <asp:ListItem Value="">-</asp:ListItem>
                                            <asp:ListItem Value="1">Day</asp:ListItem>
                                            <asp:ListItem Value="2">Night</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: end">
                                        <label class="form-control-static">TSS Main :&nbsp;</label>
                                    </td>
                                    <td>
                                        <table style="text-align: center!important">
                                            <tr>
                                                <td>
                                                    <asp:TextBox ID="txt_tss_main1" runat="server" CssClass="form-control" OnTextChanged="txt_tss_main_TextChanged" AutoPostBack="true"></asp:TextBox>

                                                </td>
                                                <td>
                                                    <label>-</label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txt_tss_main2" runat="server" CssClass="form-control" OnTextChanged="txt_tss_main_TextChanged" AutoPostBack="true"></asp:TextBox>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td class="row"></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td style="text-align: end">
                                        <label class="form-control-static">TSS Sub :&nbsp;</label>
                                    </td>
                                    <td>
                                        <table>
                                            <tr>
                                                <td style="text-align: center!important">
                                                    <asp:TextBox ID="txt_tss_sub1" runat="server" CssClass="form-control" OnTextChanged="txt_tss_sub_TextChanged" AutoPostBack="true"></asp:TextBox>
                                                </td>
                                                <td style="text-align: center!important">
                                                    <label>-</label>
                                                </td>
                                                <td style="text-align: center!important">
                                                    <asp:TextBox ID="txt_tss_sub2" runat="server" CssClass="form-control" OnTextChanged="txt_tss_sub_TextChanged" AutoPostBack="true"></asp:TextBox>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td class="row"></td>
                                    <td></td>
                                </tr>
                            </table>
                        </div>
                        <div class="col-lg-3">
                            <table style="width: 100%">
                                <tr>
                                    <td style="width: 65%; text-align: end">
                                        <label class="form-control-static">Problem Type 1 :&nbsp; </label>
                                    </td>
                                    <td>
                                        <asp:DropDownList runat="server"
                                            ID="ddl_Pro_type1"
                                            DataSourceID="sql_type1"
                                            DataTextField="SYM_NAME"
                                            DataValueField="symbol_id"
                                            CssClass="form-control " AppendDataBoundItems="true" AutoPostBack="true" OnSelectedIndexChanged="ddl_Pro_type1_SelectedIndexChanged">
                                            <asp:ListItem Value="">-</asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:SqlDataSource ID="sql_type1" runat="server" ConnectionString="<%$ ConnectionStrings:jig_tool_systemConnectionString %>"
                                            SelectCommand="select  id_no as symbol_id ,CONVERT(nvarchar,ROW_NUMBER() OVER(ORDER BY id_no ASC))+'. '+ symbol_name as SYM_NAME ,type from jtPM_symbol_master where type in (1,99) "></asp:SqlDataSource>

                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: end">
                                        <label class="form-control-static">Problem Type 2 :&nbsp; </label>
                                    </td>
                                    <td>
                                        <asp:DropDownList runat="server" ID="ddl_Pro_type2"
                                            DataSourceID="sql_type2"
                                            DataTextField="SYM_NAME"
                                            DataValueField="symbol_id"
                                            CssClass="form-control " AppendDataBoundItems="true" AutoPostBack="true" OnSelectedIndexChanged="ddl_Pro_type2_SelectedIndexChanged">
                                            <asp:ListItem Value="">-</asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:SqlDataSource ID="sql_type2" runat="server" ConnectionString="<%$ ConnectionStrings:jig_tool_systemConnectionString %>"
                                            SelectCommand="select  id_no as symbol_id ,CONVERT(nvarchar,ROW_NUMBER() OVER(ORDER BY id_no ASC))+'. '+ symbol_name as SYM_NAME ,type from jtPM_symbol_master where type in (2,99)"></asp:SqlDataSource>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: end">
                                        <label class="form-control-static">Problem Type 3 :&nbsp; </label>
                                    </td>
                                    <td>
                                        <asp:DropDownList runat="server" ID="ddl_Pro_type3"
                                            DataSourceID="sql_type3"
                                            DataTextField="SYM_NAME"
                                            DataValueField="symbol_id"
                                            CssClass="form-control " AppendDataBoundItems="true" AutoPostBack="true" OnSelectedIndexChanged="ddl_Pro_type3_SelectedIndexChanged">
                                            <asp:ListItem Value="">-</asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:SqlDataSource ID="sql_type3" runat="server" ConnectionString="<%$ ConnectionStrings:jig_tool_systemConnectionString %>"
                                            SelectCommand="select  id_no as symbol_id ,CONVERT(nvarchar,ROW_NUMBER() OVER(ORDER BY id_no ASC))+'. '+ symbol_name as SYM_NAME ,type from jtPM_symbol_master where type in (3,99)"></asp:SqlDataSource>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: end">
                                        <label class="form-control-static">Part , Equipment :&nbsp; </label>
                                    </td>
                                    <td>
                                        <asp:DropDownList runat="server" ID="ddl_part_equi"
                                            DataSourceID="sql_equi"
                                            DataTextField="EQUI"
                                            DataValueField="equi_id"
                                            CssClass="form-control " AppendDataBoundItems="true" AutoPostBack="true" OnSelectedIndexChanged="ddl_part_equi_SelectedIndexChanged">
                                            <asp:ListItem Value="">-</asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:SqlDataSource ID="sql_equi" runat="server" ConnectionString="<%$ ConnectionStrings:jig_tool_systemConnectionString %>"
                                            SelectCommand="select *, CONVERT(varchar,equi_id)+'. '+equi_name as EQUI from jtPM_equipment_master"></asp:SqlDataSource>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: end">
                                        <label class="form-control-static">สัมผัสกับชิ้นงานหรือไม่ :&nbsp; </label>
                                    </td>
                                    <td>
                                        <asp:DropDownList runat="server" ID="ddl_touch" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddl_touch_SelectedIndexChanged">
                                            <asp:ListItem Value="">-</asp:ListItem>
                                            <asp:ListItem Value="Yes">Yes</asp:ListItem>
                                            <asp:ListItem Value="No">No</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: end">
                                        <label class="form-control-static">เสี่ยงต่อการเกิดอุบัติเหตุ :&nbsp; </label>
                                    </td>
                                    <td>
                                        <asp:DropDownList runat="server" ID="ddl_risk" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddl_risk_SelectedIndexChanged">
                                            <asp:ListItem Value="">-</asp:ListItem>
                                            <asp:ListItem Value="Yes">Yes</asp:ListItem>
                                            <asp:ListItem Value="No">No</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="row" style="text-align:center">
                        
                            <img src="icon/flow_problem.jpg" style="width:70%" />
                        </div>
                        <table style="width: 100% !important">
                            <tr>
                                <td>
                                    <div id="pagin" runat="server" style="padding-left: 10px">
                                        <ul class="pagination">
                                            <li id="li_first" runat="server">
                                                <asp:LinkButton ID="first" runat="server" OnClick="first_Click" OnClientClick="if(this.disabled){return;}"><i class="fa fa-angle-double-left"></i></asp:LinkButton>
                                            </li>
                                            <li id="li_back" runat="server">
                                                <asp:LinkButton ID="back" runat="server" OnClick="back_Click" OnClientClick="if(this.disabled){return;}"><i class="fa fa-angle-left"></i> Provious</asp:LinkButton>
                                            </li>
                                            <li id="li_next" runat="server">
                                                <asp:LinkButton ID="next" runat="server" OnClick="next_Click" OnClientClick="if(this.disabled){return;}">Next <i class="fa fa-angle-right"></i></asp:LinkButton>
                                            </li>
                                            <li id="li_last" runat="server">
                                                <asp:LinkButton ID="last" runat="server" OnClick="last_Click" OnClientClick="if(this.disabled){return;}"><i class="fa fa-angle-double-right"></i></asp:LinkButton>
                                            </li>
                                        </ul>
                                    </div>
                                </td>
                                <td style="text-align: -webkit-center">
                                    <asp:LinkButton ID="btn_search" runat="server" OnClick="btn_search_Click" CssClass=" btn btn-primary"><span class="glyphicon glyphicon-search"></span>&nbsp;Search</asp:LinkButton>
                                    <asp:LinkButton ID="xls" runat="server" CssClass=" btn" OnClick="xls_Click" BackColor="#ffb900"><span class="glyphicon glyphicon-save"></span>&nbsp;Export to Excel</asp:LinkButton>

                                </td>
                            </tr>
                        </table>
                    </div>
                </div>

                <asp:GridView ID="gv1" runat="server" CssClass=" table table-bordered table-condensed"
                    OnRowDataBound="gv1_RowDataBound"
                    EmptyDataText="No Data" AutoGenerateColumns="false">
                    <EmptyDataRowStyle CssClass="danger text-danger jumbotron" />
                    <HeaderStyle CssClass=" theme-bg-color1 theme-text-color2" ForeColor="White" Wrap="false" HorizontalAlign="Center" Font-Size="Small" />
                    <RowStyle HorizontalAlign="Center" />
                    <Columns>
                        <asp:TemplateField HeaderText="No">
                            <ItemTemplate>
                                <asp:Label ID="lb_no" runat="server" Text='<%#Eval("MyRowNumber") %>'></asp:Label>
                                <%-- <%# Container.DataItemIndex + 1 %>--%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Problem No" ItemStyle-Wrap="false">
                            <ItemTemplate>
                                <asp:HiddenField ID="hd_problem_id" runat="server" Value='<%#Eval("PM_problem_id") %>' />
                                <asp:Label ID="lb_probNo" runat="server" Font-Bold="true" Font-Size="Medium" ForeColor="#262626" Text='<%#Eval("PM_problem_name") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Type">
                            <ItemTemplate>
                                <asp:Label ID="lb_type" runat="server" ForeColor="Chocolate" Font-Bold="true" Text='<%#Eval("typeProblem") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <%-- <asp:TemplateField HeaderText="Promblem_type1">
                                <ItemTemplate>
                                    <asp:HiddenField ID="hd_proType1" runat="server" Value='<%#Eval("pro_type1")%>' />
                                    <asp:Label ID="lb_proType1" runat="server" Text='<%#Eval("pro_type1") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>--%>

                        <asp:TemplateField HeaderText="Detail">
                            <ItemTemplate>
                                <asp:LinkButton ID="btn_detail_problem" runat="server" CssClass="btn btn-default" OnClick="btn_detail_problem_Click"><span class="glyphicon glyphicon-blackboard" style=" font-size:large"></span></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Symbol">
                            <ItemTemplate>
                                <asp:HiddenField ID="hd_symbol" runat="server" Value='<%#Eval("pro_type1")%>' />
                                <asp:Label ID="lb_symbol" runat="server" Text='<%#Eval("pro_type1") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Priority">
                            <ItemTemplate>
                                <asp:Label ID="lb_priority" runat="server" Text='<%#Eval("priority") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Status" ItemStyle-Wrap="false">
                            <ItemTemplate>
                                <asp:HiddenField ID="hd_status" runat="server" Value='<%#Eval("isOnplan") %>' />
                                <asp:Label ID="lb_status" runat="server"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                <asp:HiddenField ID="hd_action" runat="server" Value='<%#Eval("action_id") %>' />
                                <asp:Label ID="lb_action" runat="server" Text='<%#Eval("action_name") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Resp.Name" ItemStyle-Wrap="false">
                            <ItemTemplate>
                                <asp:Label ID="lb_resp" runat="server" Text='<%#Eval("PIC") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Resp.Group" ItemStyle-Wrap="false">
                            <ItemTemplate>
                                <asp:Label ID="lb_pic" runat="server" Text='<%#Eval("rep_group") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Follow Up">
                            <ItemTemplate>
                                <asp:Label ID="lb_follow_up" runat="server" Text='<%#Eval("Follow_up") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Plan Finish">
                            <ItemTemplate>
                                <div style="word-wrap: break-word; flex-wrap: wrap; width: 100px">
                                    <asp:Label ID="lb_planFinish" runat="server" Text='<%#Eval("plan_finish") %>'></asp:Label>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Actual Finish">
                            <ItemTemplate>
                                <div style="word-wrap: break-word; flex-wrap: wrap; width: 100px">
                                    <asp:Label ID="lb_actualFinish" runat="server" Text='<%#Eval("actual_finish") %>'></asp:Label>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Tool No." ItemStyle-Wrap="false">
                            <ItemTemplate>
                                <asp:HiddenField ID="hd_tool_id" runat="server" Value='<%#Eval("tool_id") %>' />
                                <asp:Label ID="lb_tool_no" runat="server" ForeColor="Purple" Font-Bold="true" Text='<%#Eval("tool_no") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="No of Tool">
                            <ItemTemplate>
                                <asp:HiddenField ID="hd_toolSub_id" runat="server" Value='<%#Eval("toolSub_id") %>' />
                                <asp:Label ID="lb_noOfTool" runat="server" Text='<%#Eval("toolSub_Name") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Model">
                            <ItemTemplate>
                                <asp:Label ID="lb_model" runat="server" Text='<%#Eval("model_name") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Problem Date">
                            <ItemTemplate>
                                <div style="width: 100px !important;">
                                    <asp:Label ID="lb_prob_date" runat="server" Text='<%#Eval("check_date") %>'></asp:Label>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Shift">
                            <ItemTemplate>
                                <asp:Label ID="lb_shift" runat="server" Text='<%#Eval("shift") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="TSS Sub">
                            <ItemTemplate>
                                <asp:Label ID="lb_tssSub" runat="server" Text='<%#Eval("TSS_sub") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="TSS Main">
                            <ItemTemplate>
                                <asp:Label ID="lb_tssMain" runat="server" Text='<%#Eval("TSS_Main") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Tool Owner">
                            <ItemTemplate>
                                <asp:Label ID="lb_toolOwner" runat="server" Text='<%#Eval("owner_group") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="P2">
                            <ItemTemplate>
                                <asp:Label ID="lb_proType2" runat="server" Text='<%#Eval("proType2") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="P3">
                            <ItemTemplate>
                                <asp:Label ID="lb_proType3" runat="server" Text='<%#Eval("proType3") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="P4">
                            <ItemTemplate>
                                <asp:Label ID="lb_proType4" runat="server" Text='<%#Eval("part") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="P5">
                            <ItemTemplate>
                                <asp:Label ID="lb_proType5" runat="server" Text='<%#Eval("touch_status") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="P6">
                            <ItemTemplate>
                                <asp:Label ID="lb_proType6" runat="server" Text='<%#Eval("risk_status") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>

                <asp:Label ID="test" runat="server"></asp:Label>


            </asp:Panel>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="first" />
            <asp:PostBackTrigger ControlID="back" />
            <asp:PostBackTrigger ControlID="next" />
            <asp:PostBackTrigger ControlID="last" />
            <%--<asp:PostBackTrigger ControlID="btn_search" />--%>
            <asp:PostBackTrigger ControlID="xls" />
        </Triggers>
    </asp:UpdatePanel>

    <script>
        $(document).ready(function () {
            SetTooltip();
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(SetTooltip);
        });

        function SetTooltip() {
            $('[data-toggle="tooltip"]').tooltip();
        }
       //$(document).ready(function() { $('#<%= UpdateProgress1.ClientID %>').show();});
       
    </script>
</asp:Content>
