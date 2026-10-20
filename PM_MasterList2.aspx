<%@ page title="PM_Master List" language="C#" autoeventwireup="true"
    codefile="PM_MasterList2.aspx.cs"
    inherits="jig_tool.PM_MasterList"
    masterpagefile="~/MasterPage_PM.master"
    maintainscrollpositiononpostback="true" viewstatemode="Enabled"
    enableeventvalidation="false" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <%--<link href="Content/bootstrap.css" rel="stylesheet" />--%>
    <%-- <link href="CSS/font-awesome.css" rel="stylesheet" />
    <link href="css/w3v4.10.css" rel="stylesheet" />--%>
    <%--Boostrap Rewrite--%>
    <script src="chosen/chosen.jquery.js"></script>

    <style type="text/css">
        .jumbotron {
            padding-top: 5px;
            padding-bottom: 5px;
            margin-bottom: 5px;
            color: inherit;
            background-color: #eee;
            text-align-last: start;
        }

        .jumbotron h3,
        .jumbotron .h3 {
            color: inherit;
        }

        .form-control {
            height: 26px;
            padding: 3px 6px;
        }

        .btn {
            padding: 1px 5px;
            margin-bottom: -4px !important;
        }

        .btn_menu {
            padding: 6px 12px !important;
        }

        .tb_no_border tr td {
            border: none !important;
            vertical-align: middle !important;
            text-align: center !important;
        }

        @media (min-width: 639px) {
            .modal-dialog {
                width: 600px;
                margin: 30px auto;
            }

            .modal-content {
                -webkit-box-shadow: 0 5px 15px rgba(0, 0, 0, .5);
                box-shadow: 0 5px 15px rgba(0, 0, 0, .5);
            }

            .modal-sm {
                width: 250px !important;
            }
        }

        .modal-dialog {
            position: relative;
            width: auto;
            margin: 20%;
        }

        .modal-sm {
            width: 250px !important;
        }

        .status {
            cursor: text
        }

        .status0 {
            background-color: #FDAC53;
        }

        .status1 {
            background-color: #F5DF4D;
        }

        .status2 {
            background-color: #E9897E;
        }

        .status3 {
            background-color: #9BB7D4;
        }

        .status4 {
            background-color: #F3E0BE;
        }

        .status5 {
            background-color: #D2C29D;
        }

        .status8 {
            background-color: #D2C29D;
        }

        .status6 {
            background-color: #BE9EC9;
        }

        .status7 {
            background-color: #A0DAA9;
        }
    </style>

    <%--For this Page--%>
    <style type="text/css">
        .tb_search tr td {
            padding: 3px 6px;
        }

        .btn-border {
            border: 1px solid gray;
        }

        .td_center {
            text-align: center !important;
            vertical-align: middle !important;
        }

        .table tr th {
            text-align: center !important;
        }

        .table tr td i {
            font-size: larger !important;
        }

        table tbody th,
        table tbody td {
            padding: 3px 3px;
        }
    </style>

    <%-- ======================================================= --%>
    <%-- เพิ่มใหม่ : Style สำหรับ gv-toolbar (PageSize / Pager / Record Count) --%>
    <%-- อ้างอิงจาก Tool_equipment_MasterList --%>
    <%-- ======================================================= --%>
    <style type="text/css">
        /* ── PageSize dropdown + Record Count bar ── */
        .gv-toolbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 6px 12px;
            background: #eef3fa;
            border: 1px solid #c8d6e5;
            border-bottom: 2px solid #c8d6e5;
            border-radius: 6px 6px 0 0;
            flex-wrap: wrap;
            gap: 8px;
            min-height: 40px;
        }

        /* Zone ซ้าย: PageSize */
        .gv-toolbar-left {
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .gv-toolbar-left label {
            font-size: 12px;
            color: #555;
            font-weight: 600;
            margin: 0;
            white-space: nowrap;
        }

        .gv-toolbar-left select {
            font-size: 12px;
            padding: 2px 8px;
            border-radius: 4px;
            border: 1px solid #c8d6e5;
            height: 26px;
            color: #2c3e50;
        }

        /* Zone กลาง: Pager buttons */
        .gv-toolbar-pager {
            display: flex;
            align-items: center;
            gap: 2px;
            flex-wrap: wrap;
        }

        .gv-toolbar-pager a,
        .gv-toolbar-pager span {
            display: inline-block;
            padding: 2px 9px;
            border: 1px solid #c8d6e5;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
            text-decoration: none;
            color: #1565c0;
            background: #fff;
            transition: all 0.15s;
            line-height: 1.6;
        }

        .gv-toolbar-pager a:hover {
            background: #e3eeff;
            border-color: #1565c0;
        }

        .gv-toolbar-pager span {
            background: #1565c0;
            color: #fff;
            border-color: #1565c0;
        }

        /* Zone ขวา: Record count */
        .gv-toolbar-right {
            font-size: 12px;
            font-weight: 700;
            color: #1565c0;
            white-space: nowrap;
        }

        .gv-toolbar-right b {
            color: #e53935;
            font-size: 14px;
        }

        /* ── ข้อ 3 : Zone กลาง pager (ปุ่มเลือกหน้า อยู่แถวเดียวกับ toolbar) ── */
        .gv-toolbar-pager a,
        .gv-toolbar-pager span {
            display: inline-block;
            padding: 2px 9px;
            margin: 0 2px;
            border: 1px solid #c8d6e5;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
            text-decoration: none;
            color: #1565c0;
            background: #fff;
            cursor: pointer;
            line-height: 1.6;
        }

        .gv-toolbar-pager a:hover {
            background: #e3eeff;
            border-color: #1565c0;
        }

        .gv-toolbar-pager span {
            background: #1565c0;
            color: #fff;
            border-color: #1565c0;
        }

        /* ── ข้อ 1 : Scroll wrapper ครอบ GridView ──
           ความสูงไม่เกินหน้าจอ (เหลือพื้นที่ให้ header+filter+toolbar) */
        .gv-scroll-area {
            overflow: auto;
            max-height: calc(100vh - 360px);
            min-height: 200px;
            border: 1px solid #dee2e6;
            border-radius: 0 0 6px 6px;
            position: relative;
        }

        /* scrollbar สวยงาม */
        .gv-scroll-area::-webkit-scrollbar {
            width: 8px;
            height: 8px;
        }
        .gv-scroll-area::-webkit-scrollbar-track {
            background: #f1f1f1;
        }
        .gv-scroll-area::-webkit-scrollbar-thumb {
            background: #b0b8c9;
            border-radius: 4px;
        }
        .gv-scroll-area::-webkit-scrollbar-thumb:hover {
            background: #7b8fa6;
        }
        /* ── Fix Header (sticky top) ── */
       /* .tableGv thead tr th {
            position: sticky !important;
            top: 0 !important;
            z-index: 10 !important;
            background-color: #1565c0 !important;
            color: #fff !important;
            font-weight: 700;
            font-size: 12px;
            border-bottom: 2px solid #0d47a1 !important;
            box-shadow: 0 2px 4px rgba(0,0,0,0.15);
        }*/
        /* Header ของ GridView ติดบนตอน scroll */
       /* .gv-scroll-area .table thead tr th {
            position: sticky;
            top: 0 !important;
            z-index: 10 !important;
        }*/
/*        .gv-scroll-area .table thead tr th,
        .gv-scroll-area .table tr.theme-bg-color2 th {
            position: sticky;
            top: 0 !important;
            z-index: 10 !important;
            background-color: #1565c0 !important;
            color: #fff !important;
        }*/
        .table thead th {
            position: sticky;
            top: 0 !important;
            z-index: 10 !important;
            background-color: #1565c0 !important;
            color: #fff !important;
        }        
        .gv-header {
            position: sticky;
            top: 0 !important;
            z-index: 10 !important;
            background-color: #1565c0;
            color: white;
        }

        /* ซ่อนแถว pager เดิมที่อยู่ใน GridView (เราย้ายปุ่มไปไว้บน toolbar แล้ว) */
        .gvPagerHidden {
            display: none !important;
        }
    </style>

    <asp:ScriptManager ID="ScriptManager1" EnablePageMethods="true" runat="server"></asp:ScriptManager>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
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

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:Panel ID="Panel1" runat="server" DefaultButton="BTNS_search">
                <div class="container-fluid">
                    <div class="jumbotron">
                        <h3 id="header1" runat="server" style="display: none !important;"><i class="fa fa-list-alt"></i>&nbsp;PM Master List</h3>
                        <h3 id="header2" runat="server"><i class="fa fa-list-alt"></i>&nbsp;PM Send for Check</h3>
                        <h3 id="header3" runat="server"><i class="fa fa-list-alt"></i>&nbsp;PM Mgr. Check</h3>
                    </div>
                    <div class="container-fluid">
                        <table class="tb_search">
                            <tr>
                                <td>
                                    <div class="form-inline">
                                        <label class="form-control-static">Tool ID.&nbsp;</label>
                                        <asp:TextBox ID="txtS_toolId" runat="server" CssClass="form-control" Width="50px"></asp:TextBox>
                                    </div>
                                </td>
                                <td>
                                    <div class="form-inline">
                                        <label class="form-control-static">Tool No.&nbsp;</label>
                                        <asp:TextBox ID="txtS_toolNo" runat="server" CssClass="form-control" Width="200px"></asp:TextBox>
                                    </div>
                                </td>
                                <td>
                                    <div class="form-inline">
                                        <label class="form-control-static">Rank : &nbsp;</label>
                                        <asp:DropDownList ID="ddl_rank" runat="server"
                                            CssClass="form-control">
                                            <asp:ListItem Value=""></asp:ListItem>
                                            <asp:ListItem Value="A">A</asp:ListItem>
                                            <asp:ListItem Value="B">B</asp:ListItem>
                                            <asp:ListItem Value="C">C</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </td>
                                <td>
                                    <div class="form-inline">
                                        <label class="form-control-static">Model : &nbsp;</label>
                                        <asp:DropDownList ID="ddl_model" runat="server"
                                            AppendDataBoundItems="true"
                                            CssClass="form-control ddlModel"
                                            DataSourceID="Sql_ddl_model"
                                            DataValueField="model_id"
                                            DataTextField="model_name">
                                            <asp:ListItem Value=""></asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:SqlDataSource ID="Sql_ddl_model"
                                            runat="server"
                                            ConnectionString="<%$ ConnectionStrings:jig_tool_systemConnectionString %>"
                                            SelectCommand=" SELECT model_name,model_id FROM dbo.draw_master_model ORDER BY model_name "></asp:SqlDataSource>
                                    </div>
                                </td>
                                <td>
                                    <div class="form-inline">
                                        <label class="form-control-static">Category : &nbsp;</label>
                                        <asp:DropDownList runat="server" ID="ddl_cate"
                                            CssClass="form-control ddlModel"
                                            AppendDataBoundItems="true"
                                            DataSourceID="sql_cate"
                                            DataValueField="id"
                                            DataTextField="category">
                                            <asp:ListItem Value=""></asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:SqlDataSource ID="sql_cate"
                                            runat="server"
                                            ConnectionString="<%$ ConnectionStrings:jig_tool_systemConnectionString %>"
                                            SelectCommand=" select* from jt_category_master where category is not null order by id "></asp:SqlDataSource>
                                    </div>
                                </td>
                            </tr>
                        </table>
                        <table class="tb_search">
                            <tr>
                                <td>
                                    <div class="form-inline">
                                        <label class="form-control-static">Location 1 : &nbsp;</label>
                                        <asp:DropDownList ID="ddl_location1" runat="server" AutoPostBack="true"
                                            AppendDataBoundItems="true" OnSelectedIndexChanged="ddl_location1_SelectedIndexChanged"
                                            CssClass="form-control"
                                            DataSourceID="data_ddl_location1"
                                            DataValueField="location1_id"
                                            DataTextField="location1_name">
                                            <asp:ListItem Value=""></asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:SqlDataSource ID="data_ddl_location1"
                                            runat="server"
                                            ConnectionString="<%$ ConnectionStrings:jig_tool_systemConnectionString %>"
                                            SelectCommand="select location1_id,location1_name from master_location1 where is_use = 1 order by location1_name "></asp:SqlDataSource>
                                    </div>
                                </td>
                                <td>
                                    <div class="form-inline">
                                        <label class="form-control-static">Location 2 : &nbsp;</label>
                                        <asp:DropDownList ID="ddl_location2" runat="server"
                                            CssClass="form-control">
                                            <asp:ListItem Value=""></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </td>
                                <td>
                                    <div class="form-inline">
                                        <label class="form-control-static">Status : &nbsp;</label>
                                        <asp:DropDownList ID="ddl_PMstatus" runat="server"
                                            CssClass="form-control">
                                            <asp:ListItem Value=""></asp:ListItem>
                                            <asp:ListItem Value="0">PM Manual</asp:ListItem>
                                            <asp:ListItem Value="1">Check Sheet</asp:ListItem>
                                            <asp:ListItem Value="2">Period Change</asp:ListItem>
                                            <asp:ListItem Value="3">PM-A</asp:ListItem>
                                            <asp:ListItem Value="4">Send for check</asp:ListItem>
                                            <asp:ListItem Value="5">Leader Check</asp:ListItem>
                                            <asp:ListItem Value="6">Set 1st PM</asp:ListItem>
                                            <asp:ListItem Value="7">Completed</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </td>
                                <td>
                                    <asp:LinkButton ID="BTNS_search" runat="server" CssClass="btn btn-info" OnClick="BTNS_search_Click"><i class="fa fa-search"></i>Search</asp:LinkButton>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <hr />
                    <div class="container-fluid">
                        <div class="">
                            <table class=" table table-condensed tb_no_border">
                                <tr>
                                    <td></td>
                                    <td style="width: 140px;">
                                        <p data-toggle="tooltip" title="Wait / Check PM Manual">
                                            <label class="btn status status0" style="width: 110px;">PM Manual</label>
                                        </p>
                                    </td>
                                    <td style="width: 140px;">
                                        <p data-toggle="tooltip" title="Issue PM Check Sheet">
                                            <label class="btn status status1" style="width: 110px;">Check Sheet</label>
                                        </p>
                                    </td>
                                    <td style="width: 140px;">
                                        <p data-toggle="tooltip" title="จัดทำข้อมูล Part Period Change">
                                            <label class="btn status status2" style="width: 110px;">Period Change</label>
                                        </p>
                                    </td>
                                    <td style="width: 140px;">
                                        <p data-toggle="tooltip" title="จัดทำข้อมูล PM-A">
                                            <label class="btn status status3" style="width: 110px;">PM-A</label>
                                        </p>
                                    </td>
                                    <td style="width: 140px;">
                                        <p data-toggle="tooltip" title="Send Document to Leader Check">
                                            <label class="btn status status4" style="width: 110px;">Send for check</label>
                                        </p>
                                    </td>
                                    <td style="width: 140px;">
                                        <p data-toggle="tooltip" title="Wait Leader Check Document">
                                            <label class="btn status status5" style="width: 110px;">Wait Check</label>
                                        </p>
                                    </td>
                                    <td style="width: 140px;">
                                        <p data-toggle="tooltip" title="Wait J3 Up Check Document">
                                            <label class="btn status status5" style="width: 110px;">Wait Approve</label>
                                        </p>
                                    </td>
                                    <td style="width: 140px;">
                                        <p data-toggle="tooltip" title="Setting Period for PM Check">
                                            <label class="btn status status6" style="width: 110px;">Set Period</label>
                                        </p>
                                    </td>
                                    <td style="width: 140px;">
                                        <p data-toggle="tooltip" title="All Process is Completed">
                                            <label class="btn status status7" style="width: 110px;">Completed</label>
                                        </p>
                                    </td>
                                    <td></td>
                                </tr>
                            </table>
                        </div>

                        <%-- ======================================================= --%>
                        <%-- เพิ่มใหม่ : gv-toolbar (ข้อ 1,2,3)                        --%>
                        <%--   ซ้าย  = ddl_pageSize (10/20/50)                        --%>
                        <%--   ขวา   = lblRecordCount "Showing 1 to 20 of 6677 ..."  --%>
                        <%-- ======================================================= --%>
                        <div class="gv-toolbar">
                            <div class="gv-toolbar-left">
                                <label>แสดง</label>
                                <asp:DropDownList ID="ddl_pageSize" runat="server"
                                    AutoPostBack="true"
                                    OnSelectedIndexChanged="ddl_pageSize_SelectedIndexChanged">
                                    <asp:ListItem Value="10">10</asp:ListItem>
                                    <asp:ListItem Value="20" Selected="True">20</asp:ListItem>
                                    <asp:ListItem Value="50">50</asp:ListItem>
                                </asp:DropDownList>
                                <label>รายการ / หน้า</label>
                            </div>

                            <%-- ข้อ 3 : ปุ่มเลือกหน้า ย้ายมาอยู่ตรงนี้ (เติมด้วย JS movePager) --%>
                            <div class="gv-toolbar-pager" id="gv-pager-bar"></div>

                            <div class="gv-toolbar-right">
                                <asp:Label ID="lblRecordCount" runat="server" Text=""></asp:Label>
                            </div>
                        </div>

                        <asp:Label ID="test" runat="server"></asp:Label>

                        <%-- ======================================================= --%>
                        <%-- ข้อ 1 : ครอบ GridView ด้วย scroll-area                  --%>
                        <%-- GridView1 :                                            --%>
                        <%--   AllowPaging + PageSize (ข้อ 1,2)                      --%>
                        <%--   OnPageIndexChanging (ข้อ 2)                           --%>
                        <%--   PagerStyle css = gvPagerHidden (ซ่อน pager เดิม)      --%>
                        <%-- ======================================================= --%>
                        <div class="gv-scroll-area">
                            <asp:GridView ID="GridView1" runat="server" CssClass="table table-bordered table-condensed "
                                EmptyDataText="No Have Data" EmptyDataRowStyle-ForeColor="Red"
                                OnRowDataBound="GridView1_RowDataBound"
                                AutoGenerateColumns="false"
                                AllowPaging="true" PageSize="20"
                                OnPageIndexChanging="GridView1_PageIndexChanging"
                                PagerStyle-CssClass="gvPagerHidden"
                                PagerStyle-HorizontalAlign="Center">
                                <HeaderStyle CssClass="gv-header" HorizontalAlign="Center" />       <%--CssClass="theme-bg-color2 theme-text-color1"--%>
                            <Columns>

                                <asp:BoundField HeaderText="No" DataField="MyRowNumber" ItemStyle-CssClass="td_center" />

                                <asp:TemplateField HeaderText="Action" ItemStyle-CssClass="td_center">
                                    <ItemTemplate>
                                        <asp:HiddenField ID="hd_tool_id" runat="server" Value='<%#Eval("TOOL_ID") %>' />
                                        <asp:HiddenField ID="hd_pmStatusId" runat="server" Value='<%#Eval("PM_STATUSID") %>' />
                                        <asp:LinkButton ID="Btn_ViewDetail" runat="server" OnClick="Btn_ViewDetail_Click"
                                            CssClass="btn btn-default btn-border" data-toggle="tooltip" title="View Detail"><i class="fa fa-eye"></i></asp:LinkButton>
                                        <asp:LinkButton ID="Btn_Edit" runat="server" OnClick="Btn_Edit_Click" CssClass="btn btn-default btn-border" data-toggle="tooltip" title="Edit Document"><i class="fa fa-pencil-square-o"></i></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:BoundField HeaderText="Tool ID" DataField="TOOL_ID_NAME" ItemStyle-CssClass="td_center" />
                                <asp:BoundField HeaderText="Tool No" DataField="TOOL_NO" ItemStyle-CssClass="td_center" />
                                <asp:BoundField HeaderText="Quantity" DataField="QTY" ItemStyle-CssClass="td_center" />
                                <asp:BoundField HeaderText="Group" DataField="GROUP_NAME" ItemStyle-CssClass="td_center" />

                                <asp:TemplateField HeaderText="Rank" ItemStyle-CssClass="td_center">
                                    <ItemTemplate>
                                        <asp:Label ID="lb_Rank" runat="server" Text='<%#Eval("RANK_ID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField HeaderText="Category" DataField="category" ItemStyle-CssClass="td_center" />

                                <asp:TemplateField HeaderText="Status" ItemStyle-CssClass="td_center">
                                    <ItemTemplate>
                                        <asp:HiddenField ID="hd_PMCSH_STATUS" runat="server" Value='<%#Eval("PMCSH_STATUS") %>' />
                                        <asp:LinkButton ID="lb_pmStatus" runat="server" Enabled="false" ForeColor="#333333"
                                            Text='<%#Eval("PMCSH_STATUS_NAME") %>'></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Spacial" ItemStyle-CssClass="td_center">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="pic_check" runat="server" CssClass="btn disabled"><i class="fa fa-check"></i></asp:LinkButton>
                                        <asp:LinkButton ID="pic_cross" runat="server" CssClass="btn disabled"><i class="fa fa-times"></i></asp:LinkButton>
                                        <asp:LinkButton ID="pic_wait" runat="server" CssClass="btn disabled"><i class="fa fa-clock-o"></i></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="PM Manual" ItemStyle-CssClass="td_center">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="pic_crossManual" runat="server" CssClass="btn disabled"><i class="fa fa-times"></i></asp:LinkButton>
                                        <table id="tb_pmmanual" runat="server" style="margin: auto">
                                            <tr>
                                                <td>
                                                    <asp:ImageButton ID="Img_Excel" runat="server" OnClick="Img_Excel_Click" ImageUrl="~/images/FilesType/009-xls.png" Width="25px" Height="25px" />
                                                </td>
                                                <td>
                                                    <asp:ImageButton ID="Img_PDF" runat="server" OnClick="Img_PDF_Click" ImageUrl="~/images/FilesType/pdf.png" Width="25px" Height="25px" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="lb_rev_excel" runat="server" Text="00"></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label ID="lb_rev_pdf" runat="server" Text="01"></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Check Sheet" ItemStyle-CssClass="td_center">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="pic_waitCSH" runat="server" CssClass="btn disabled"><i class="fa fa-clock-o"></i></asp:LinkButton>
                                        <asp:LinkButton ID="pic_crossCSH" runat="server" CssClass="btn disabled"><i class="fa fa-times"></i></asp:LinkButton>
                                        <table id="tb_checkSheet" runat="server" style="margin: auto">
                                            <tr>
                                                <td>
                                                    <%--<asp:ImageButton ID="Img_checksheet" runat="server" ImageUrl="~/images/FilesType/009-xls.png" Width="25px" Height="25px" OnClick="Img_checksheet_Click" />--%>
                                                    <asp:ImageButton ID="Img_checksheet" runat="server" ImageUrl="~/images/FilesType/009-xls.png" Width="25px" Height="25px" OnClick="Btn_ViewCheckSheet_Click" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:HiddenField runat="server" ID="hd_checkSheet_rev" Value='<%#Eval("CheckSheet_REV") %>' />
                                                    <asp:Label ID="lb_rev_checksheet" runat="server" TEXT="00"></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Period Change" ItemStyle-CssClass="td_center">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="pic_waitPC" runat="server" CssClass="btn disabled"><i class="fa fa-clock-o"></i></asp:LinkButton>
                                        <asp:LinkButton ID="pic_crossPC" runat="server" CssClass="btn disabled" Visible="false"><i class="fa fa-times"></i></asp:LinkButton>
                                        <asp:ImageButton ID="Img_PC" runat="server" Visible="false" ImageUrl="~/images/FilesType/Excel.png" Width="25px" Height="25px" />
                                        <table id="tb_PC" runat="server" style="margin: auto">
                                            <tr>
                                                <td></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <%--<asp:Label ID="lb_rev_PC" runat="server" Text='<%#Eval("period_name") %>'></asp:Label>--%>
                                                </td>
                                            </tr>
                                        </table>
                                    </ItemTemplate>
                                </asp:TemplateField>

                            </Columns>
                        </asp:GridView>
                        </div>
                        <%-- /gv-scroll-area --%>

                    </div>
                </div>

                <div class="modal fade" id="EditDoc" role="dialog">
                    <div class="modal-dialog modal-sm">
                        <div class="modal-content">
                            <div class="modal-header theme-bg-color1 theme-text-color2">
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                <h4 class="modal-title"><i class="fa fa-pencil-square-o"></i>&nbsp;Edit / Add</h4>
                            </div>
                            <div class="modal-body">
                                <label id="toolno_modal" runat="server" style="color: purple; font-size: medium"></label>
                                <br />
                                <div class="btn-group-vertical" style="text-align: center !important;">
                                    <a id="pm_csh" runat="server" class="btn btn-primary btn_menu"><i class="fa fa-book"></i>&nbsp;PM Document : Add</a>
                                    <a id="doc_revise" runat="server" class="btn btn-primary btn_menu disabled"><i class="fa fa-book"></i>&nbsp;PM Document : Revise</a>
                                    <a id="set1PM" runat="server" href="#" class="btn btn-primary btn_menu"><i class="fa fa-calendar-check-o"></i>&nbsp;Schedule Plan : 1st PM</a>
                                    <a id="editplan" runat="server" href="#" class="btn btn-primary btn_menu disabled"><i class=" fa fa-calendar-plus-o"></i>&nbsp;Schedule Plan : Edit</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </asp:Panel>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="GridView1" />
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

        // ===================================================================
        // ข้อ 3 : ย้ายปุ่ม pager จากในตาราง GridView มาไว้บน toolbar (zone กลาง)
        // ===================================================================
        function movePager() {
            var $gv = $('#<%= GridView1.ClientID %>');
            var $pagerBar = $('#gv-pager-bar');

            // หาแถว pager (แถวที่มี td[colspan] และมี a/span อยู่ข้างใน)
            var $pagerTr = $gv.find('tr').filter(function () {
                return $(this).find('td[colspan]').length > 0 &&
                    $(this).find('a, span').length > 0;
            }).last();

            $pagerBar.empty();

            if ($pagerTr.length > 0) {
                var $links = $pagerTr.find('a, span').clone(true, true);
                $pagerBar.append($links);
                $pagerTr.addClass('gvPagerHidden'); // ซ่อนแถว pager เดิม
            } else {
                $pagerBar.append('<span style="background:#fff;color:#999;border-color:#ddd;">หน้า 1 / 1</span>');
            }
        }

        // ===================================================================
        // ข้อ 1 : ปรับความสูง scroll-area ให้ไม่เกินหน้าจอ
        // ===================================================================
        function adjustGridHeight() {
            var toolbarBottom = $('.gv-toolbar').length
                ? ($('.gv-toolbar').offset().top + $('.gv-toolbar').outerHeight())
                : 300;
            var windowH = $(window).height();
            var bottomPad = 30; // กันขอบล่าง

            var newHeight = windowH - toolbarBottom - bottomPad;
            if (newHeight < 200) newHeight = 200;

            $('.gv-scroll-area').css('max-height', newHeight + 'px');
        }

        // ── Init ──
        $(window).on('load', function () {
            movePager();
            adjustGridHeight();
        });

        // ── Resize ──
        $(window).on('resize', function () {
            adjustGridHeight();
        });

        // ── หลัง UpdatePanel postback ──
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
            movePager();
            adjustGridHeight();
        });
    </script>

</asp:Content>