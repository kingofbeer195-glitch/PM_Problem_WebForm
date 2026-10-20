<%@ Page Language="C#" AutoEventWireup="true"
    CodeFile="jt_problem_his_master.aspx.cs"
    Inherits="jig_tool.jt_problem_his_master"
    MasterPageFile="~/MasterPage_Problem.master"
    MaintainScrollPositionOnPostback="true"
    EnableEventValidation="false" %>

<asp:Content ID="Content1" runat="server" ContentPlaceHolderID="ContentPlaceHolder1">

    <link rel="stylesheet" href="Content/bootstrap.css" />
    <link href="CSS/Color_History_Status.css" rel="stylesheet" />
    <link href="CSS/Color_Priority.css" rel="stylesheet" />
    <link href="CSS/Color_symbol.css" rel="stylesheet" />
    <link rel="stylesheet" href="Content/font-awesome.css" />
    <link href="DateTimePicker/2-bootstrap-datetimepicker.min.css" rel="stylesheet" />
    <link href="DateTimePicker/3-bootstrap-datetimepicker-standalone.css" rel="stylesheet" />

    <script src="DateTimePicker/1-moment.min.js"></script>
    <script src="DateTimePicker/4-bootstrap-datetimepicker.min.js"></script>

    <%-- ======================================================================
         PM Problem Control List : UI ใหม่
         1. Filter หลัก (แสดงตลอด) + ปุ่ม Filter เปิด/ปิด Filter อื่นๆ
         2. Status Card (กดเพื่อ Filter Status)
         3. Table : Page / รายการ, ควบคอลัมน์ Tool และ Problem Date, Tooltip P2-P6
         ====================================================================== --%>
    <style type="text/css">
        :root {
            --c-primary: #5F6F52;
            --c-primary-dark: #4E5C43;
            --c-primary-soft: #EEF1E8;
            --c-accent: #B99470;
            --c-border: #DADFD3;
            --c-text: #2F3A28;
            --c-muted: #7A8473;
            --c-bg: #F6F7F3;
        }

        body {
            background: var(--c-bg);
        }

        .pm-page {
            padding: 0 16px 16px;
            color: var(--c-text);
            font-size: 13px;
        }

        /* ---------- Header ---------- */
        .pm-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 8px;
            margin-bottom: 10px;
        }

            .pm-head h1 {
                margin: 0;
                font-size: 20px;
                font-weight: 700;
                color: var(--c-primary-dark);
            }

                .pm-head h1 i {
                    color: var(--c-accent);
                    margin-right: 6px;
                }

        /* ---------- Buttons ---------- */
        .pm-btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            height: 32px;
            padding: 0 14px;
            border-radius: 6px;
            border: 1px solid var(--c-border);
            background: #fff;
            color: var(--c-text);
            font-size: 13px;
            font-weight: 600;
            text-decoration: none !important;
            cursor: pointer;
            white-space: nowrap;
            transition: background .15s, border-color .15s;
        }

            .pm-btn:hover {
                background: var(--c-primary-soft);
                color: var(--c-text);
            }

            .pm-btn.primary {
                background: var(--c-primary);
                border-color: var(--c-primary);
                color: #fff;
            }

                .pm-btn.primary:hover {
                    background: var(--c-primary-dark);
                    color: #fff;
                }

            .pm-btn.excel {
                background: #1D6F42;
                border-color: #1D6F42;
                color: #fff;
            }

                .pm-btn.excel:hover {
                    background: #175A35;
                    color: #fff;
                }

            .pm-btn.active {
                background: var(--c-primary-soft);
                border-color: var(--c-primary);
                color: var(--c-primary-dark);
            }

            .pm-btn .count-badge {
                display: inline-block;
                min-width: 18px;
                height: 18px;
                line-height: 18px;
                padding: 0 5px;
                border-radius: 9px;
                background: var(--c-accent);
                color: #fff;
                font-size: 11px;
                text-align: center;
            }

        /* ---------- Filter card ---------- */
        .pm-card {
            background: #fff;
            border: 1px solid var(--c-border);
            border-radius: 8px;
            box-shadow: 0 1px 2px rgba(0, 0, 0, .04);
        }

        .filter-main {
            display: flex;
            align-items: flex-end;
            flex-wrap: wrap;
            gap: 10px 12px;
            padding: 12px 14px;
        }

        .f-item {
            display: flex;
            flex-direction: column;
            gap: 3px;
            min-width: 130px;
        }

            .f-item.w-sm {
                min-width: 100px;
                width: 100px;
            }

            .f-item.w-md {
                width: 170px;
            }

            .f-item.w-lg {
                width: 230px;
            }

            .f-item label {
                margin: 0;
                font-size: 11.5px;
                font-weight: 600;
                color: var(--c-muted);
                text-transform: uppercase;
                letter-spacing: .3px;
                white-space: nowrap;
            }

            .f-item .hint {
                font-weight: 400;
                text-transform: none;
                letter-spacing: 0;
            }

        .pm-page .form-control {
            height: 32px !important;
            padding: 4px 8px;
            font-size: 13px;
            border-radius: 6px;
            border-color: var(--c-border);
            box-shadow: none;
        }

            .pm-page .form-control:focus {
                border-color: var(--c-primary);
                box-shadow: 0 0 0 2px rgba(95, 111, 82, .15);
            }

        .pm-page .input-group-addon {
            padding: 4px 9px;
            border-color: var(--c-border);
            background: var(--c-primary-soft);
        }

        .pm-page .input-group .form-control:first-child {
            border-radius: 6px 0 0 6px;
        }

        .pm-page .input-group-addon:last-child {
            border-radius: 0 6px 6px 0;
        }

        .f-actions {
            display: flex;
            gap: 6px;
            margin-left: auto;
            flex-wrap: wrap;
        }

        .input-icon {
            position: relative;
        }

            .input-icon i {
                position: absolute;
                left: 9px;
                top: 9px;
                color: var(--c-muted);
                font-size: 13px;
                pointer-events: none;
            }

            .input-icon .form-control {
                padding-left: 28px;
            }

        .range {
            display: flex;
            align-items: center;
            gap: 4px;
        }

            .range > span {
                color: var(--c-muted);
            }

        /* Filter อื่นๆ (ซ่อน/แสดง) */
        .filter-adv {
            display: none;
            border-top: 1px dashed var(--c-border);
            padding: 12px 14px 14px;
            background: #FBFCF9;
            border-radius: 0 0 8px 8px;
        }

            .filter-adv.show {
                display: block;
            }

        .adv-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(190px, 1fr));
            gap: 10px 14px;
        }

            .adv-grid .f-item {
                min-width: 0;
            }

            .adv-grid .span-2 {
                grid-column: span 2;
            }

        .adv-group-title {
            grid-column: 1 / -1;
            margin: 4px 0 -2px;
            font-size: 12px;
            font-weight: 700;
            color: var(--c-primary);
            border-bottom: 1px solid var(--c-border);
            padding-bottom: 3px;
        }

        /* ---------- Status Cards ---------- */
        .status-cards {
            display: flex;
            gap: 8px;
            overflow-x: auto;
            padding: 12px 0 10px;
        }

        .st-card {
            flex: 1 0 104px;
            max-width: 160px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            gap: 2px;
            padding: 8px 10px;
            background: #fff;
            border: 1px solid var(--c-border);
            border-top: 4px solid var(--st);
            border-radius: 8px;
            color: var(--c-text);
            text-decoration: none !important;
            cursor: pointer;
            transition: transform .12s, box-shadow .12s, background .12s;
        }

            .st-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 10px rgba(0, 0, 0, .08);
                color: var(--c-text);
            }

            .st-card .st-name {
                font-size: 11.5px;
                font-weight: 600;
                color: var(--c-muted);
                line-height: 1.25;
                min-height: 29px;
            }

            .st-card .st-count {
                font-size: 22px;
                font-weight: 700;
                color: var(--st);
                line-height: 1.1;
            }

            .st-card.active {
                background: var(--st);
                border-color: var(--st);
                box-shadow: 0 4px 12px rgba(0, 0, 0, .15);
            }

                .st-card.active .st-name,
                .st-card.active .st-count {
                    color: #fff;
                }

            .st-card.zero {
                opacity: .55;
            }

        /* สีของแต่ละ Status (ใช้ทั้ง Card และ Pill ในตาราง) */
        .st-all { --st: #5F6F52; }
        .st-9 { --st: #2F80ED; }
        .st-0 { --st: #17A2B8; }
        .st-1 { --st: #3A9D5D; }
        .st-2 { --st: #D9534F; }
        .st-3 { --st: #7E57C2; }
        .st-4 { --st: #5C6BC0; }
        .st-5 { --st: #3F7CAC; }
        .st-6 { --st: #B07D2B; }
        .st-7 { --st: #6C757D; }
        .st-8 { --st: #A0A0A0; }

        /* ---------- Table toolbar ---------- */
        .gv-toolbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 8px;
            padding: 7px 12px;
            border-bottom: 1px solid var(--c-border);
            background: #FAFBF8;
            border-radius: 8px 8px 0 0;
        }

        .gv-toolbar-left {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 12px;
            color: var(--c-muted);
            font-weight: 600;
        }

            .gv-toolbar-left select {
                height: 28px;
                padding: 2px 6px;
                font-size: 12px;
                border: 1px solid var(--c-border);
                border-radius: 5px;
                color: var(--c-text);
            }

        .gv-pager {
            display: flex;
            align-items: center;
            gap: 3px;
            flex-wrap: wrap;
        }

            .gv-pager a,
            .gv-pager span.pg {
                display: inline-block;
                min-width: 30px;
                height: 28px;
                line-height: 26px;
                padding: 0 8px;
                border: 1px solid var(--c-border);
                border-radius: 5px;
                background: #fff;
                color: var(--c-primary-dark);
                font-size: 12px;
                font-weight: 600;
                text-align: center;
                text-decoration: none !important;
            }

                .gv-pager a:hover {
                    background: var(--c-primary-soft);
                    border-color: var(--c-primary);
                }

                .gv-pager a.current {
                    background: var(--c-primary);
                    border-color: var(--c-primary);
                    color: #fff;
                    pointer-events: none;
                }

                .gv-pager a.aspNetDisabled {
                    color: #C4C4C4;
                    pointer-events: none;
                }

            .gv-pager span.dots {
                padding: 0 2px;
                color: var(--c-muted);
            }

        .gv-toolbar-right {
            font-size: 12px;
            color: var(--c-muted);
            font-weight: 600;
            white-space: nowrap;
        }

            .gv-toolbar-right b {
                color: var(--c-primary-dark);
            }

        /* ---------- Table ---------- */
        .gv-scroll-area {
            overflow: auto;
            max-height: calc(100vh - 380px);
            min-height: 220px;
            border-radius: 0 0 8px 8px;
        }

            .gv-scroll-area::-webkit-scrollbar { width: 9px; height: 9px; }
            .gv-scroll-area::-webkit-scrollbar-track { background: #F1F1F1; }
            .gv-scroll-area::-webkit-scrollbar-thumb { background: #B9C0B1; border-radius: 5px; }
            .gv-scroll-area::-webkit-scrollbar-thumb:hover { background: #8F9986; }

        table.pm-table {
            width: 100%;
            margin: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0;
            font-size: 12.5px;
            background: #fff;
        }

            table.pm-table > thead > tr > th {
                position: sticky;
                top: 0;
                z-index: 3;
                background: var(--c-primary) !important;
                color: #fff !important;
                font-weight: 600;
                font-size: 12px;
                text-align: center !important;
                vertical-align: middle !important;
                white-space: nowrap;
                padding: 8px 8px !important;
                border: 0 !important;
                border-right: 1px solid rgba(255, 255, 255, .15) !important;
            }

            table.pm-table > tbody > tr > td {
                vertical-align: middle !important;
                padding: 6px 8px !important;
                border: 0 !important;
                border-bottom: 1px solid #ECEFE8 !important;
                border-right: 1px solid #F3F5F0 !important;
                background: #fff;
                white-space: nowrap;
            }

            table.pm-table > tbody > tr:nth-child(even) > td {
                background: #FAFBF8;
            }

            table.pm-table > tbody > tr:hover > td {
                background: #F0F4EA;
            }

            /* ตรึงคอลัมน์ No + Problem No ไว้ด้านซ้าย */
            table.pm-table th.col-no,
            table.pm-table td.col-no {
                position: sticky;
                left: 0;
                width: 46px;
                min-width: 46px;
                z-index: 2;
            }

            table.pm-table th.col-prob,
            table.pm-table td.col-prob {
                position: sticky;
                left: 46px;
                min-width: 120px;
                z-index: 2;
                box-shadow: 2px 0 3px rgba(0, 0, 0, .06);
            }

            table.pm-table > thead > tr > th.col-no,
            table.pm-table > thead > tr > th.col-prob {
                z-index: 4;
            }

        .t-muted { color: var(--c-muted); }
        .t-center { text-align: center; }

        .prob-no {
            font-weight: 700;
            font-size: 13px;
            color: #262626;
            white-space: nowrap;
        }

        .btn-detail {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 30px;
            height: 28px;
            border: 1px solid var(--c-border);
            border-radius: 6px;
            background: #fff;
            color: var(--c-primary-dark);
        }

            .btn-detail:hover {
                background: var(--c-primary);
                border-color: var(--c-primary);
                color: #fff;
            }

        /* Tool (Tool No / No of Tool / Model) */
        .tool-cell {
            text-align: left;
            white-space: nowrap;
            line-height: 1.35;
        }

            .tool-cell .tool-no {
                font-weight: 700;
                color: #6A1B9A;
            }

            .tool-cell .tool-sub {
                font-size: 11.5px;
                color: var(--c-muted);
            }

                .tool-cell .tool-sub b {
                    color: var(--c-text);
                    font-weight: 600;
                }

        /* Problem Date / Shift */
        .date-cell {
            white-space: nowrap;
            line-height: 1.35;
        }

        .shift-tag {
            display: inline-block;
            margin-top: 2px;
            padding: 0 7px;
            border-radius: 9px;
            font-size: 11px;
            font-weight: 600;
        }

            .shift-tag.day { background: #FFF4D6; color: #9A6B00; }
            .shift-tag.night { background: #E4E7F6; color: #3A4380; }

        /* Badge / Pill */
        .pill {
            display: inline-block;
            padding: 2px 9px;
            border-radius: 11px;
            font-size: 11.5px;
            font-weight: 600;
            line-height: 1.5;
            white-space: nowrap;
        }

        .st-pill {
            background: var(--st);
            color: #fff;
        }

        .prio-badge {
            display: inline-block;
            width: 26px;
            height: 24px;
            line-height: 24px;
            border-radius: 6px;
            font-weight: 700;
            text-align: center;
        }

        .chip {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 5px;
            font-size: 11.5px;
            font-weight: 600;
            white-space: nowrap;
            pointer-events: none;
        }

        .chip-p {
            background: #F7E3A8;
            color: #5C4A00;
        }

        .yn-yes { background: #FDE2E1; color: #B42318; }
        .yn-no { background: #EEF1E8; color: #5F6F52; }

        .type-text {
            color: #B5651D;
            font-weight: 700;
        }

        /* Tooltip หัวคอลัมน์ P2-P6 */
        .th-tip {
            cursor: help;
            border-bottom: 1px dotted rgba(255, 255, 255, .7);
        }

            .th-tip i {
                font-size: 10px;
                opacity: .8;
                margin-left: 2px;
            }

        .tooltip-inner {
            max-width: 260px;
            text-align: left;
            font-size: 12px;
            padding: 6px 10px;
        }

        .empty-row td {
            padding: 30px !important;
            text-align: center;
            color: var(--c-muted);
            font-size: 14px;
        }

        /* ---------- Loading ---------- */
        .overlay {
            position: fixed;
            z-index: 2000;
            inset: 0;
            background: rgba(255, 255, 255, .55);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .overlay-box {
            padding: 14px 22px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, .15);
            font-size: 15px;
            font-weight: 600;
            color: var(--c-primary-dark);
        }
    </style>

    <asp:ScriptManager ID="ScriptManager1" EnablePageMethods="true" runat="server"></asp:ScriptManager>

    <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1" DisplayAfter="150">
        <ProgressTemplate>
            <div class="overlay">
                <div class="overlay-box"><i class="fa fa-spinner fa-spin"></i>&nbsp; Loading...</div>
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:HiddenField ID="hf_showAdv" runat="server" Value="0" />

            <div class="pm-page">

                <%-- ===================== Header ===================== --%>
                <div class="pm-head">
                    <h1><i class="fa fa-list-alt"></i>PM Problem Control List</h1>
                    <asp:LinkButton ID="xls" runat="server" CssClass="pm-btn excel" OnClick="xls_Click"><i class="fa fa-file-excel-o"></i>Export to Excel</asp:LinkButton>
                </div>

                <%-- ===================== Filter ===================== --%>
                <div class="pm-card">
                    <%-- 1.1 Filter หลัก (แสดงตลอดเวลา) --%>
                    <div class="filter-main">
                        <div class="f-item w-md">
                            <label>Problem No</label>
                            <div class="input-icon">
                                <i class="fa fa-search"></i>
                                <asp:TextBox ID="txt_problem" runat="server" CssClass="form-control" placeholder="เช่น PB-2026" OnTextChanged="Filter_Changed" AutoPostBack="true"></asp:TextBox>
                            </div>
                        </div>
                        <div class="f-item w-lg">
                            <label>Tool <span class="hint">(Tool No / No of Tool / Model)</span></label>
                            <div class="input-icon">
                                <i class="fa fa-wrench"></i>
                                <asp:TextBox ID="txt_tool_no" runat="server" CssClass="form-control" placeholder="ค้นหา Tool No, No of Tool, Model" OnTextChanged="Filter_Changed" AutoPostBack="true"></asp:TextBox>
                            </div>
                        </div>
                        <div class="f-item w-sm">
                            <label>Year</label>
                            <asp:DropDownList ID="ddl_year" runat="server" CssClass="form-control" AppendDataBoundItems="false" OnSelectedIndexChanged="Filter_Changed" AutoPostBack="true">
                            </asp:DropDownList>
                        </div>
                        <div class="f-item w-md">
                            <label>Priority</label>
                            <asp:DropDownList ID="ddl_priority" runat="server" CssClass="form-control" AppendDataBoundItems="true"
                                OnSelectedIndexChanged="Filter_Changed" AutoPostBack="true">
                                <asp:ListItem Value="">- All -</asp:ListItem>
                                <asp:ListItem Value="A">A : Calibration / Urgent action</asp:ListItem>
                                <asp:ListItem Value="B">B : Action / Use lead time for action</asp:ListItem>
                                <asp:ListItem Value="C">C : Accept use / Monitoring</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="f-item w-md">
                            <label>Resp. Group</label>
                            <asp:DropDownList ID="ddl_resp" runat="server" CssClass="form-control" DataSourceID="sql_resp" DataValueField="group_id" DataTextField="group_name"
                                AppendDataBoundItems="true" OnSelectedIndexChanged="Filter_Changed" AutoPostBack="true">
                                <asp:ListItem Value="">- All -</asp:ListItem>
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="sql_resp" runat="server"
                                ConnectionString="<%$ ConnectionStrings:User_ConnectionString %>"
                                SelectCommand="select * from user_master.dbo.eng_group_master where active = 1 and dept in(3,5) order by group_name "></asp:SqlDataSource>
                        </div>

                        <div class="f-actions">
                            <%-- 1.2 ปุ่ม Filter : เปิด-ปิด Filter อื่นๆ --%>
                            <button type="button" id="btnToggleAdv" class="pm-btn" onclick="toggleAdvFilter()">
                                <i class="fa fa-sliders"></i>Filter
                                <asp:Label ID="lbl_advCount" runat="server" CssClass="count-badge" Visible="false"></asp:Label>
                                <i class="fa fa-chevron-down" id="advArrow"></i>
                            </button>
                            <asp:LinkButton ID="btn_search" runat="server" OnClick="btn_search_Click" CssClass="pm-btn primary"><i class="fa fa-search"></i>Search</asp:LinkButton>
                            <asp:LinkButton ID="btn_clear" runat="server" OnClick="btn_clear_Click" CssClass="pm-btn"><i class="fa fa-eraser"></i>Clear</asp:LinkButton>
                        </div>
                    </div>

                    <%-- 1.2 Filter อื่นๆ (ซ่อน/แสดงด้วยปุ่ม Filter) --%>
                    <div class="filter-adv" id="filterAdv">
                        <div class="adv-grid">
                            <div class="adv-group-title">Problem</div>
                            <div class="f-item">
                                <label>Type</label>
                                <asp:DropDownList ID="ddl_type" runat="server" CssClass="form-control"
                                    AppendDataBoundItems="true" DataSourceID="sql_ddl_type"
                                    DataTextField="pm_docName" DataValueField="pm_docID"
                                    OnSelectedIndexChanged="Filter_Changed" AutoPostBack="true">
                                    <asp:ListItem Value="">- All -</asp:ListItem>
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="sql_ddl_type" runat="server"
                                    ConnectionString="<%$ ConnectionStrings:jig_tool_systemConnectionString  %>"
                                    SelectCommand="select * from jtPM_master_doc where active = 1 order by pm_docID"></asp:SqlDataSource>
                            </div>
                            <div class="f-item">
                                <label>Status</label>
                                <asp:DropDownList ID="ddl_status" runat="server" CssClass="form-control" AppendDataBoundItems="true"
                                    OnSelectedIndexChanged="Filter_Changed"
                                    DataSourceID="sql_promStatus" DataValueField="perm_status_id" DataTextField="perm_status_name"
                                    AutoPostBack="true">
                                    <asp:ListItem Value="">- All -</asp:ListItem>
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="sql_promStatus" runat="server" ConnectionString="<%$ ConnectionStrings:jig_tool_systemConnectionString %>"
                                    SelectCommand="select * from  jtPM_permStatus_master "></asp:SqlDataSource>
                            </div>
                            <div class="f-item">
                                <label>Symbol</label>
                                <asp:DropDownList runat="server" ID="ddl_symbol"
                                    DataSourceID="sql_type1" DataTextField="SYM_NAME" DataValueField="symbol_id"
                                    CssClass="form-control" AppendDataBoundItems="true" AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed">
                                    <asp:ListItem Value="">- All -</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="f-item">
                                <label>Action</label>
                                <asp:DropDownList ID="ddl_action" runat="server" CssClass="form-control" AppendDataBoundItems="true"
                                    OnSelectedIndexChanged="Filter_Changed"
                                    DataSourceID="SqlDataSource1" DataValueField="action_id" DataTextField="action_name"
                                    AutoPostBack="true">
                                    <asp:ListItem Value="">- All -</asp:ListItem>
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:jig_tool_systemConnectionString %>"
                                    SelectCommand="select action_id,action_name from  jtPM_actionStatus_master order by action_id"></asp:SqlDataSource>
                            </div>
                            <div class="f-item span-2">
                                <label>Problem Date</label>
                                <div class="range">
                                    <div class='input-group date' id='div3' runat="server">
                                        <asp:TextBox ID="txt_problem1" runat="server" CssClass="form-control" placeholder="From" AutoPostBack="true" OnTextChanged="Filter_Changed"></asp:TextBox>
                                        <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                                    </div>
                                    <span>–</span>
                                    <div class='input-group date' id='div4' runat="server">
                                        <asp:TextBox ID="txt_problem2" runat="server" CssClass="form-control" placeholder="To" AutoPostBack="true" OnTextChanged="Filter_Changed"></asp:TextBox>
                                        <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                                    </div>
                                </div>
                            </div>
                            <div class="f-item">
                                <label>Shift</label>
                                <asp:DropDownList ID="ddl_shift" runat="server" CssClass="form-control" AppendDataBoundItems="true" OnSelectedIndexChanged="Filter_Changed" AutoPostBack="true">
                                    <asp:ListItem Value="">- All -</asp:ListItem>
                                    <asp:ListItem Value="1">Day</asp:ListItem>
                                    <asp:ListItem Value="2">Night</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="f-item span-2">
                                <label>Follow Up</label>
                                <div class="range">
                                    <div class='input-group date' id='div1' runat="server">
                                        <asp:TextBox ID="txt_follow_up" runat="server" CssClass="form-control" placeholder="From" AutoPostBack="true" OnTextChanged="Filter_Changed"></asp:TextBox>
                                        <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                                    </div>
                                    <span>–</span>
                                    <div class='input-group date' id='div2' runat="server">
                                        <asp:TextBox ID="txt_follow_up2" runat="server" CssClass="form-control" placeholder="To" AutoPostBack="true" OnTextChanged="Filter_Changed"></asp:TextBox>
                                        <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                                    </div>
                                </div>
                            </div>

                            <div class="adv-group-title">Person</div>
                            <div class="f-item">
                                <label>Resp. Name</label>
                                <asp:DropDownList ID="ddl_resp_name" runat="server" CssClass="form-control"
                                    DataSourceID="sql_ddl_resp_name" DataValueField="emp_id" DataTextField="name"
                                    AppendDataBoundItems="true" OnSelectedIndexChanged="Filter_Changed" AutoPostBack="true">
                                    <asp:ListItem Value="">- All -</asp:ListItem>
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="sql_ddl_resp_name" runat="server"
                                    ConnectionString="<%$ ConnectionStrings:User_ConnectionString %>"
                                    SelectCommand=" select 'Pakapol S.' as name ,8 as position_id,5 as eng_group_id,5 as user_dept,'018710' as emp_id , 1 as order_
                                                    union
                                                    select REPLACE(REPLACE(fname,'Ms.',''),'Mr.','') + ' ' + SUBSTRING(lname,1,1) + '.' as name,position_id,eng_group_id,user_dept ,emp_id, 1 as order_
                                                    from user_master.dbo.sys_user_master a where user_dept in (3,5) and position_id <> 7 and status = 1 and position_id <> 9 order by name"></asp:SqlDataSource>
                            </div>
                            <div class="f-item">
                                <label>Issue Name</label>
                                <asp:DropDownList runat="server" ID="ddl_Issue" CssClass="form-control"
                                    AutoPostBack="true" DataSourceID="sql_ddl_resp_name"
                                    DataValueField="emp_id" DataTextField="name" AppendDataBoundItems="true"
                                    OnSelectedIndexChanged="Filter_Changed">
                                    <asp:ListItem Value="">- All -</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="f-item">
                                <label>Tool Owner</label>
                                <asp:DropDownList ID="ddl_tool_owner" runat="server" CssClass="form-control"
                                    DataSourceID="sql_tool_owner" DataValueField="group_id" DataTextField="group_name"
                                    AppendDataBoundItems="true" OnSelectedIndexChanged="Filter_Changed" AutoPostBack="true">
                                    <asp:ListItem Value="">- All -</asp:ListItem>
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="sql_tool_owner" runat="server"
                                    ConnectionString="<%$ ConnectionStrings:User_ConnectionString %>"
                                    SelectCommand="select * from user_master.dbo.eng_group_master where dept in (3,5) and active = 1"></asp:SqlDataSource>
                            </div>

                            <div class="adv-group-title">Tool</div>
                            <div class="f-item">
                                <label>No of Tool</label>
                                <asp:TextBox ID="txt_no_of_tool" runat="server" CssClass="form-control" OnTextChanged="Filter_Changed" AutoPostBack="true"></asp:TextBox>
                            </div>
                            <div class="f-item">
                                <label>Model</label>
                                <asp:DropDownList ID="ddl_model" runat="server" CssClass="form-control"
                                    DataSourceID="sql_model" DataValueField="model_id" DataTextField="model_name"
                                    AppendDataBoundItems="true" OnSelectedIndexChanged="Filter_Changed" AutoPostBack="true">
                                    <asp:ListItem Value="">- All -</asp:ListItem>
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="sql_model" runat="server"
                                    ConnectionString="<%$ ConnectionStrings:jig_tool_systemConnectionString %>"
                                    SelectCommand="select model_id, model_name from draw_master_model order by model_id"></asp:SqlDataSource>
                            </div>
                            <div class="f-item">
                                <label>TSS Main</label>
                                <div class="range">
                                    <asp:TextBox ID="txt_tss_main1" runat="server" CssClass="form-control" placeholder="From" OnTextChanged="Filter_Changed" AutoPostBack="true"></asp:TextBox>
                                    <span>–</span>
                                    <asp:TextBox ID="txt_tss_main2" runat="server" CssClass="form-control" placeholder="To" OnTextChanged="Filter_Changed" AutoPostBack="true"></asp:TextBox>
                                </div>
                            </div>
                            <div class="f-item">
                                <label>TSS Sub</label>
                                <div class="range">
                                    <asp:TextBox ID="txt_tss_sub1" runat="server" CssClass="form-control" placeholder="From" OnTextChanged="Filter_Changed" AutoPostBack="true"></asp:TextBox>
                                    <span>–</span>
                                    <asp:TextBox ID="txt_tss_sub2" runat="server" CssClass="form-control" placeholder="To" OnTextChanged="Filter_Changed" AutoPostBack="true"></asp:TextBox>
                                </div>
                            </div>

                            <div class="adv-group-title">Problem Detail (P1 – P6)</div>
                            <div class="f-item">
                                <label>P1 : Problem Type 1</label>
                                <asp:DropDownList runat="server" ID="ddl_Pro_type1"
                                    DataSourceID="sql_type1" DataTextField="SYM_NAME" DataValueField="symbol_id"
                                    CssClass="form-control" AppendDataBoundItems="true" AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed">
                                    <asp:ListItem Value="">- All -</asp:ListItem>
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="sql_type1" runat="server" ConnectionString="<%$ ConnectionStrings:jig_tool_systemConnectionString %>"
                                    SelectCommand="select  id_no as symbol_id ,CONVERT(nvarchar,ROW_NUMBER() OVER(ORDER BY id_no ASC))+'. '+ symbol_name as SYM_NAME ,type from jtPM_symbol_master where type in (1,99) "></asp:SqlDataSource>
                            </div>
                            <div class="f-item">
                                <label>P2 : Problem Type 2</label>
                                <asp:DropDownList runat="server" ID="ddl_Pro_type2"
                                    DataSourceID="sql_type2" DataTextField="SYM_NAME" DataValueField="symbol_id"
                                    CssClass="form-control" AppendDataBoundItems="true" AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed">
                                    <asp:ListItem Value="">- All -</asp:ListItem>
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="sql_type2" runat="server" ConnectionString="<%$ ConnectionStrings:jig_tool_systemConnectionString %>"
                                    SelectCommand="select  id_no as symbol_id ,CONVERT(nvarchar,ROW_NUMBER() OVER(ORDER BY id_no ASC))+'. '+ symbol_name as SYM_NAME ,type from jtPM_symbol_master where type in (2,99)"></asp:SqlDataSource>
                            </div>
                            <div class="f-item">
                                <label>P3 : Problem Type 3</label>
                                <asp:DropDownList runat="server" ID="ddl_Pro_type3"
                                    DataSourceID="sql_type3" DataTextField="SYM_NAME" DataValueField="symbol_id"
                                    CssClass="form-control" AppendDataBoundItems="true" AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed">
                                    <asp:ListItem Value="">- All -</asp:ListItem>
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="sql_type3" runat="server" ConnectionString="<%$ ConnectionStrings:jig_tool_systemConnectionString %>"
                                    SelectCommand="select  id_no as symbol_id ,CONVERT(nvarchar,ROW_NUMBER() OVER(ORDER BY id_no ASC))+'. '+ symbol_name as SYM_NAME ,type from jtPM_symbol_master where type in (3,99)"></asp:SqlDataSource>
                            </div>
                            <div class="f-item">
                                <label>P4 : Part , Equipment</label>
                                <asp:DropDownList runat="server" ID="ddl_part_equi"
                                    DataSourceID="sql_equi" DataTextField="EQUI" DataValueField="equi_id"
                                    CssClass="form-control" AppendDataBoundItems="true" AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed">
                                    <asp:ListItem Value="">- All -</asp:ListItem>
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="sql_equi" runat="server" ConnectionString="<%$ ConnectionStrings:jig_tool_systemConnectionString %>"
                                    SelectCommand="select *, CONVERT(varchar,equi_id)+'. '+equi_name as EQUI from jtPM_equipment_master"></asp:SqlDataSource>
                            </div>
                            <div class="f-item">
                                <label>P5 : สัมผัสกับชิ้นงานหรือไม่</label>
                                <asp:DropDownList runat="server" ID="ddl_touch" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed">
                                    <asp:ListItem Value="">- All -</asp:ListItem>
                                    <asp:ListItem Value="Yes">Yes</asp:ListItem>
                                    <asp:ListItem Value="No">No</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="f-item">
                                <label>P6 : เสี่ยงต่อการเกิดอุบัติเหตุ</label>
                                <asp:DropDownList runat="server" ID="ddl_risk" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed">
                                    <asp:ListItem Value="">- All -</asp:ListItem>
                                    <asp:ListItem Value="Yes">Yes</asp:ListItem>
                                    <asp:ListItem Value="No">No</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- ===================== 2. Status Cards ===================== --%>
                <div class="status-cards">
                    <asp:Repeater ID="rptStatus" runat="server" OnItemCommand="rptStatus_ItemCommand">
                        <ItemTemplate>
                            <asp:LinkButton ID="btn_statusCard" runat="server"
                                CommandName="status" CommandArgument='<%# Eval("Key") %>'
                                CssClass='<%# Eval("Css") %>' ToolTip='<%# Eval("Name") %>'>
                                <span class="st-name"><%# Eval("Name") %></span>
                                <span class="st-count"><%# Eval("Count", "{0:#,0}") %></span>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <%-- ===================== 3. Problem List ===================== --%>
                <div class="pm-card">
                    <div class="gv-toolbar">
                        <div class="gv-toolbar-left">
                            <span>แสดง</span>
                            <asp:DropDownList ID="ddl_pageSize" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddl_pageSize_SelectedIndexChanged">
                                <asp:ListItem Value="10">10</asp:ListItem>
                                <asp:ListItem Value="20" Selected="True">20</asp:ListItem>
                                <asp:ListItem Value="50">50</asp:ListItem>
                                <asp:ListItem Value="100">100</asp:ListItem>
                            </asp:DropDownList>
                            <span>รายการ / หน้า</span>
                        </div>

                        <div class="gv-pager">
                            <asp:LinkButton ID="first" runat="server" CommandArgument="first" OnCommand="Pager_Command" ToolTip="หน้าแรก"><i class="fa fa-angle-double-left"></i></asp:LinkButton>
                            <asp:LinkButton ID="back" runat="server" CommandArgument="prev" OnCommand="Pager_Command" ToolTip="ก่อนหน้า"><i class="fa fa-angle-left"></i></asp:LinkButton>
                            <asp:Repeater ID="rptPager" runat="server" OnItemCommand="rptPager_ItemCommand">
                                <ItemTemplate>
                                    <asp:PlaceHolder runat="server" Visible='<%# (int)Eval("Page") < 0 %>'><span class="dots">…</span></asp:PlaceHolder>
                                    <asp:LinkButton ID="btn_page" runat="server" Visible='<%# (int)Eval("Page") > 0 %>'
                                        CommandName="page" CommandArgument='<%# Eval("Page") %>'
                                        CssClass='<%# (bool)Eval("Current") ? "current" : "" %>'><%# Eval("Page") %></asp:LinkButton>
                                </ItemTemplate>
                            </asp:Repeater>
                            <asp:LinkButton ID="next" runat="server" CommandArgument="next" OnCommand="Pager_Command" ToolTip="ถัดไป"><i class="fa fa-angle-right"></i></asp:LinkButton>
                            <asp:LinkButton ID="last" runat="server" CommandArgument="last" OnCommand="Pager_Command" ToolTip="หน้าสุดท้าย"><i class="fa fa-angle-double-right"></i></asp:LinkButton>
                        </div>

                        <div class="gv-toolbar-right">
                            <asp:Label ID="lblRecordCount" runat="server"></asp:Label>
                        </div>
                    </div>

                    <div class="gv-scroll-area" id="gvScroll">
                        <asp:GridView ID="gv1" runat="server" CssClass="table pm-table"
                            OnRowDataBound="gv1_RowDataBound" GridLines="None"
                            ShowHeaderWhenEmpty="true"
                            EmptyDataText="ไม่พบข้อมูลตามเงื่อนไขที่เลือก" AutoGenerateColumns="false">
                            <EmptyDataRowStyle CssClass="empty-row" />
                            <Columns>
                                <asp:TemplateField HeaderText="No" HeaderStyle-CssClass="col-no" ItemStyle-CssClass="col-no t-center t-muted">
                                    <ItemTemplate>
                                        <asp:Label ID="lb_no" runat="server" Text='<%#Eval("MyRowNumber") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Problem No" HeaderStyle-CssClass="col-prob" ItemStyle-CssClass="col-prob">
                                    <ItemTemplate>
                                        <asp:HiddenField ID="hd_problem_id" runat="server" Value='<%#Eval("PM_problem_id") %>' />
                                        <asp:Label ID="lb_probNo" runat="server" CssClass="prob-no" Text='<%#Eval("PM_problem_name") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Detail" ItemStyle-CssClass="t-center">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btn_detail_problem" runat="server" CssClass="btn-detail" ToolTip="ดูรายละเอียด / Follow up" OnClick="btn_detail_problem_Click"><i class="fa fa-external-link"></i></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Type" ItemStyle-CssClass="t-center">
                                    <ItemTemplate>
                                        <asp:Label ID="lb_type" runat="server" CssClass="type-text" Text='<%#Eval("typeProblem") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Symbol" ItemStyle-CssClass="t-center">
                                    <ItemTemplate>
                                        <asp:HiddenField ID="hd_symbol" runat="server" Value='<%#Eval("pro_type1")%>' />
                                        <asp:Label ID="lb_symbol" runat="server" Text='<%#Eval("pro_type1") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Priority" ItemStyle-CssClass="t-center">
                                    <ItemTemplate>
                                        <asp:Label ID="lb_priority" runat="server" Text='<%#Eval("priority") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Status" ItemStyle-CssClass="t-center">
                                    <ItemTemplate>
                                        <asp:HiddenField ID="hd_status" runat="server" Value='<%#Eval("isOnplan") %>' />
                                        <asp:Label ID="lb_status" runat="server"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Action" ItemStyle-CssClass="t-center">
                                    <ItemTemplate>
                                        <asp:HiddenField ID="hd_action" runat="server" Value='<%#Eval("action_id") %>' />
                                        <asp:Label ID="lb_action" runat="server" Text='<%#Eval("action_name") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Tool">
                                    <ItemTemplate>
                                        <asp:HiddenField ID="hd_tool_id" runat="server" Value='<%#Eval("tool_id") %>' />
                                        <asp:HiddenField ID="hd_toolSub_id" runat="server" Value='<%#Eval("toolSub_id") %>' />
                                        <div class="tool-cell">
                                            <asp:Label ID="lb_tool_no" runat="server" CssClass="tool-no" Text='<%#Eval("tool_no") %>'></asp:Label>
                                            <div class="tool-sub" id="div_toolSub" runat="server">
                                                No. <b><asp:Label ID="lb_noOfTool" runat="server" Text='<%#Eval("toolSub_Name") %>'></asp:Label></b>
                                                &nbsp;·&nbsp; <asp:Label ID="lb_model" runat="server" Text='<%#Eval("model_name") %>'></asp:Label>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Problem Date" ItemStyle-CssClass="t-center">
                                    <ItemTemplate>
                                        <asp:HiddenField ID="hd_prob_year" runat="server" />
                                        <div class="date-cell">
                                            <asp:Label ID="lb_prob_date" runat="server" Text='<%#Eval("check_date") %>'></asp:Label><br />
                                            <asp:Label ID="lb_shift" runat="server" Text='<%#Eval("shift") %>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Resp.Name" ItemStyle-Wrap="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lb_resp" runat="server" Text='<%#Eval("PIC") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Resp.Group" ItemStyle-Wrap="false" ItemStyle-CssClass="t-center">
                                    <ItemTemplate>
                                        <asp:Label ID="lb_pic" runat="server" Text='<%#Eval("rep_group") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Follow Up" ItemStyle-Wrap="false" ItemStyle-CssClass="t-center">
                                    <ItemTemplate>
                                        <asp:Label ID="lb_follow_up" runat="server" Text='<%#Eval("Follow_up") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Plan Finish" ItemStyle-Wrap="false" ItemStyle-CssClass="t-center">
                                    <ItemTemplate>
                                        <asp:Label ID="lb_planFinish" runat="server" Text='<%#Eval("plan_finish") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Actual Finish" ItemStyle-Wrap="false" ItemStyle-CssClass="t-center">
                                    <ItemTemplate>
                                        <asp:Label ID="lb_actualFinish" runat="server" Text='<%#Eval("actual_finish") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="TSS Sub" ItemStyle-CssClass="t-center">
                                    <ItemTemplate>
                                        <asp:Label ID="lb_tssSub" runat="server" Text='<%#Eval("TSS_sub") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="TSS Main" ItemStyle-CssClass="t-center">
                                    <ItemTemplate>
                                        <asp:Label ID="lb_tssMain" runat="server" Text='<%#Eval("TSS_Main") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Tool Owner" ItemStyle-CssClass="t-center">
                                    <ItemTemplate>
                                        <asp:Label ID="lb_toolOwner" runat="server" Text='<%#Eval("owner_group") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <%-- 3.4 P2-P6 : ชี้ที่ Header แล้วแสดง Pop-up อธิบาย --%>
                                <asp:TemplateField ItemStyle-CssClass="t-center">
                                    <HeaderTemplate>
                                        <span class="th-tip" data-toggle="tooltip" data-placement="bottom" data-container="body" data-html="true"
                                            title="&lt;b&gt;P2 : Problem Type 2&lt;/b&gt;&lt;br/&gt;ประเภทปัญหาที่ 2">P2<i class="fa fa-info-circle"></i></span>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lb_proType2" runat="server" Text='<%#Eval("proType2") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField ItemStyle-CssClass="t-center">
                                    <HeaderTemplate>
                                        <span class="th-tip" data-toggle="tooltip" data-placement="bottom" data-container="body" data-html="true"
                                            title="&lt;b&gt;P3 : Problem Type 3&lt;/b&gt;&lt;br/&gt;ประเภทปัญหาที่ 3">P3<i class="fa fa-info-circle"></i></span>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lb_proType3" runat="server" Text='<%#Eval("proType3") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField ItemStyle-CssClass="t-center">
                                    <HeaderTemplate>
                                        <span class="th-tip" data-toggle="tooltip" data-placement="bottom" data-container="body" data-html="true"
                                            title="&lt;b&gt;P4 : Part , Equipment&lt;/b&gt;&lt;br/&gt;Part / อุปกรณ์ ที่เกิดปัญหา">P4<i class="fa fa-info-circle"></i></span>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lb_proType4" runat="server" Text='<%#Eval("part") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField ItemStyle-CssClass="t-center">
                                    <HeaderTemplate>
                                        <span class="th-tip" data-toggle="tooltip" data-placement="bottom" data-container="body" data-html="true"
                                            title="&lt;b&gt;P5 : Touch Work Piece&lt;/b&gt;&lt;br/&gt;สัมผัสกับชิ้นงานหรือไม่ (Yes / No)">P5<i class="fa fa-info-circle"></i></span>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lb_proType5" runat="server" Text='<%#Eval("touch_status") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField ItemStyle-CssClass="t-center">
                                    <HeaderTemplate>
                                        <span class="th-tip" data-toggle="tooltip" data-placement="left" data-container="body" data-html="true"
                                            title="&lt;b&gt;P6 : Accident Risk&lt;/b&gt;&lt;br/&gt;เสี่ยงต่อการเกิดอุบัติเหตุ (Yes / No)">P6<i class="fa fa-info-circle"></i></span>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lb_proType6" runat="server" Text='<%#Eval("risk_status") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>

                <asp:Label ID="test" runat="server" ForeColor="Red"></asp:Label>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="xls" />
        </Triggers>
    </asp:UpdatePanel>

    <script type="text/javascript">
        // ===== Date picker =====
        function Set_datePicker() {
            $('.date').datetimepicker({ format: 'DD-MMM-YYYY' });
        }

        // ===== Tooltip (P2-P6 header) =====
        function SetTooltip() {
            $('.tooltip').remove();
            $('[data-toggle="tooltip"]').tooltip();
        }

        // ===== 1.2 ปุ่ม Filter : เปิด-ปิด Filter อื่นๆ (จำสถานะไว้ใน HiddenField) =====
        function hfAdv() { return document.getElementById('<%= hf_showAdv.ClientID %>'); }

        function applyAdvFilter() {
            var show = hfAdv() && hfAdv().value === '1';
            var panel = document.getElementById('filterAdv');
            var btn = document.getElementById('btnToggleAdv');
            var arrow = document.getElementById('advArrow');
            if (!panel) return;
            panel.className = 'filter-adv' + (show ? ' show' : '');
            btn.className = 'pm-btn' + (show ? ' active' : '');
            arrow.className = 'fa ' + (show ? 'fa-chevron-up' : 'fa-chevron-down');
            fitGrid();
        }

        function toggleAdvFilter() {
            var hf = hfAdv();
            hf.value = hf.value === '1' ? '0' : '1';
            applyAdvFilter();
        }

        // ===== 3.1 ปรับความสูงตารางให้พอดีหน้าจอ =====
        function fitGrid() {
            var el = document.getElementById('gvScroll');
            if (!el) return;
            // ระยะจากบนสุดของเอกสารถึงตาราง -> ให้ตารางสูงพอดีกับหน้าจอที่เหลือ
            var docTop = el.getBoundingClientRect().top + (window.pageYOffset || document.documentElement.scrollTop || 0);
            var h = window.innerHeight - docTop - 18;
            el.style.maxHeight = Math.max(h, 260) + 'px';
        }

        function initPage() {
            Set_datePicker();
            SetTooltip();
            applyAdvFilter();
            fitGrid();
        }

        $(document).ready(function () {
            initPage();
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(initPage);
            $(window).on('resize', fitGrid);
        });
    </script>
</asp:Content>
