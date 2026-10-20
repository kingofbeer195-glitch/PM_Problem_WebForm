using ClosedXML.Excel;
using Spire.Xls;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace jig_tool
{
    public partial class jt_problem_his_master : BasePage //System.Web.UI.Page
    {
        SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["Sql"].ConnectionString);
        datacon dc = new datacon();
        private object modcls;
        public override void VerifyRenderingInServerForm(Control control)
        {
            /* Confirms that an HtmlForm control is rendered for the specified ASP.NET
               server control at run time. */
        }
        public void Page_Init(object sender, EventArgs e)
        {
            // ===== Authentication =====
            string emp_id = Request.QueryString["emp_id"];

            if (!string.IsNullOrEmpty(emp_id) && Session["emp_id"] == null)
            {
                // Mode 1: emp_id จาก QueryString
                Assign_Session(emp_id);
            }
            else if (Session["emp_id"] == null)
            {
                // Mode 2: SharedSession จาก ENG4_System
                var sharedSession = SharedSessionHelper.ValidateSession();
                if (sharedSession != null && !string.IsNullOrEmpty(sharedSession.EmpId))
                    Assign_Session(sharedSession.EmpId);
            }
            // ==========================

            // สร้าง ddl_year เหมือนเดิม
            System.Data.DataTable dt = new System.Data.DataTable();
            DataRow dr = null;
            dt.Columns.Add(new DataColumn("year_id", typeof(string)));
            dt.Columns.Add(new DataColumn("year_name", typeof(string)));

            int j = 0;
            int year = DateTime.Now.Year;
            for (int l = 0; l < 2; l++)
            {
                dr = dt.NewRow();
                dr["year_id"] = year - j;
                dr["year_name"] = year - j;
                dt.Rows.Add(dr);
                j++;
            }

            ddl_year.DataSource = dt;
            ddl_year.DataTextField = "year_name";
            ddl_year.DataValueField = "year_id";
            ddl_year.DataBind();
            ddl_year.Items.Insert(0, "");
            ddl_year.SelectedValue = year.ToString();
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            // ถ้าไม่มี session → redirect
            if (Session["emp_id"] == null)
            {
                Response.Redirect("Default.aspx", true);
                return;
            }

            if (!IsPostBack)
            {
                ViewState["Total_row"] = 0;
                bind_row();
            }

            if (gv1.HeaderRow != null)
                gv1.HeaderRow.TableSection = TableRowSection.TableHeader;

            // หมายเหตุ : ไม่ใช้ RegisterPostBackControl แล้ว (ไม่มี DataTables)
            // Filter / Pager ทำงานแบบ partial postback ใน UpdatePanel ได้เลย
        }
        public void Assign_Session(string emp_id)
        {
            login_getUser getUser = new login_getUser();
            getUser.Get_forSession(emp_id);
            Session["user_id"] = getUser.USER_ID;
            Session["emp_id"] = getUser.EMP_ID;
            Session["user_name"] = getUser.USER_NAME;
            Session["positionId"] = getUser.POSITION_ID;
            Session["eng_group_id"] = getUser.ENG_GROUP_ID;
            Session["user_group"] = getUser.USER_GROUP;
            Session["admin"] = getUser.USER_ADMIN;
            //Label1.Text = "test";
        }
        // =====================================================================
        //  Status master (ใช้ร่วมกัน : Status Card / Pill ในตาราง)
        // =====================================================================
        private static readonly string[][] StatusList = new string[][]
        {
            new string[] { "9", "New Problem" },
            new string[] { "0", "Acknowledge" },
            new string[] { "1", "On plan" },
            new string[] { "2", "Delay" },
            new string[] { "3", "Send for check" },
            new string[] { "4", "Tool Owner[J3] Check" },
            new string[] { "5", "ENG4[J3] check" },
            new string[] { "6", "ENG4[Mgr] Approve" },
            new string[] { "7", "Close" },
            new string[] { "8", "Cancel" }
        };

        protected static string StatusName(string id)
        {
            foreach (string[] s in StatusList)
                if (s[0] == id) return s[1];
            return id;
        }

        // =====================================================================
        //  Paging (อ้างอิง PM_MasterList2 : เลือกจำนวนรายการ/หน้า + ปุ่มเลขหน้า)
        //  ดึงข้อมูลเฉพาะหน้าที่แสดงจาก SQL (ROW_NUMBER) เหมือนเดิม
        // =====================================================================
        private int PageSize
        {
            get
            {
                int n;
                return (int.TryParse(ddl_pageSize.SelectedValue, out n) && n > 0) ? n : 20;
            }
        }

        private int CurrentPage
        {
            get { return ViewState["currentPage"] == null ? 1 : (int)ViewState["currentPage"]; }
            set { ViewState["currentPage"] = value; }
        }

        private int IsFixFilter()
        {
            return Request.QueryString["tool_id"] != null ? 1 : 0;
        }

        /// <summary>ค้นหาใหม่ → กลับไปหน้า 1</summary>
        protected void bind_row()
        {
            CurrentPage = 1;
            Load_data();
        }

        /// <summary>โหลดข้อมูลหน้าปัจจุบัน + Pager + Record count + Status Card</summary>
        protected void Load_data()
        {
            int isFixFil = IsFixFilter();

            Set_totalRow(isFixFil);
            int total = Convert.ToInt32(ViewState["Total_row"]);
            int totalPage = (total == 0) ? 1 : (int)Math.Ceiling(total / (double)PageSize);
            ViewState["Total_Page"] = totalPage;

            if (CurrentPage > totalPage) CurrentPage = totalPage;
            if (CurrentPage < 1) CurrentPage = 1;

            int start = ((CurrentPage - 1) * PageSize) + 1;
            int end = CurrentPage * PageSize;

            Bind_data(start, end);
            Build_pager(totalPage);

            lblRecordCount.Text = (total == 0)
                ? "ไม่พบข้อมูล"
                : string.Format("Showing <b>{0:#,0}</b> – <b>{1:#,0}</b> of <b>{2:#,0}</b> entries", start, Math.Min(end, total), total);

            Bind_statusCards(isFixFil);
            Set_advCount();
        }

        private void Build_pager(int totalPage)
        {
            int cur = CurrentPage;
            int from = Math.Max(1, cur - 2);
            int to = Math.Min(totalPage, cur + 2);

            List<object> pages = new List<object>();
            if (from > 1)
            {
                pages.Add(new { Page = 1, Current = false });
                if (from > 2) pages.Add(new { Page = -1, Current = false }); // ...
            }
            for (int i = from; i <= to; i++)
                pages.Add(new { Page = i, Current = (i == cur) });
            if (to < totalPage)
            {
                if (to < totalPage - 1) pages.Add(new { Page = -1, Current = false }); // ...
                pages.Add(new { Page = totalPage, Current = false });
            }

            rptPager.DataSource = pages;
            rptPager.DataBind();

            first.Enabled = back.Enabled = (cur > 1);
            next.Enabled = last.Enabled = (cur < totalPage);
        }

        protected void Pager_Command(object sender, CommandEventArgs e)
        {
            int totalPage = ViewState["Total_Page"] == null ? 1 : (int)ViewState["Total_Page"];
            switch (e.CommandArgument.ToString())
            {
                case "first": CurrentPage = 1; break;
                case "prev": CurrentPage = CurrentPage - 1; break;
                case "next": CurrentPage = CurrentPage + 1; break;
                case "last": CurrentPage = totalPage; break;
            }
            Load_data();
        }

        protected void rptPager_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int page;
            if (e.CommandName == "page" && int.TryParse(e.CommandArgument.ToString(), out page))
            {
                CurrentPage = page;
                Load_data();
            }
        }

        protected void ddl_pageSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            bind_row();
        }

        // =====================================================================
        //  Status Card : จำนวนตาม Filter ปัจจุบัน (ไม่รวม Filter Status)
        //  กด Card → Filter Status นั้น, กดซ้ำ → ยกเลิก (All)
        // =====================================================================
        private void Bind_statusCards(int isFixFil)
        {
            string where = (isFixFil == 1 ? Get_where_fix() : Get_where());
            string str = " select A.isOnplan, count(*) as cnt from PM_Tool_History A where A.PM_problem_id is not null "
                       + where + Search_fuction(false) + " group by A.isOnplan ";
            dc.QryDT(conn, str);

            Dictionary<string, int> counts = new Dictionary<string, int>();
            int all = 0;
            foreach (DataRow r in dc.dt.Rows)
            {
                string k = r["isOnplan"].ToString();
                int c = Convert.ToInt32(r["cnt"]);
                counts[k] = (counts.ContainsKey(k) ? counts[k] : 0) + c;
                all += c;
            }

            string sel = ddl_status.SelectedValue;
            List<object> cards = new List<object>();
            cards.Add(new { Key = "", Name = "All", Count = all, Css = "st-card st-all" + (sel == "" ? " active" : "") });
            foreach (string[] s in StatusList)
            {
                int c = counts.ContainsKey(s[0]) ? counts[s[0]] : 0;
                cards.Add(new
                {
                    Key = s[0],
                    Name = s[1],
                    Count = c,
                    Css = "st-card st-" + s[0] + (sel == s[0] ? " active" : "") + (c == 0 ? " zero" : "")
                });
            }
            rptStatus.DataSource = cards;
            rptStatus.DataBind();
        }

        protected void rptStatus_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string key = e.CommandArgument.ToString();
            if (key != "" && ddl_status.SelectedValue == key)
                key = ""; // กด Card เดิมซ้ำ = ยกเลิก filter

            ddl_status.ClearSelection();
            ListItem li = ddl_status.Items.FindByValue(key);
            if (li == null)
            {
                li = new ListItem(StatusName(key), key);
                ddl_status.Items.Add(li);
            }
            li.Selected = true;

            bind_row();
        }

        // =====================================================================
        //  Filter
        // =====================================================================
        protected void btn_search_Click(object sender, EventArgs e)
        {
            bind_row();
        }

        protected void btn_clear_Click(object sender, EventArgs e)
        {
            TextBox[] txts = { txt_problem, txt_tool_no, txt_no_of_tool, txt_problem1, txt_problem2,
                               txt_follow_up, txt_follow_up2, txt_tss_main1, txt_tss_main2, txt_tss_sub1, txt_tss_sub2 };
            foreach (TextBox t in txts) t.Text = "";

            DropDownList[] ddls = { ddl_priority, ddl_resp, ddl_type, ddl_status, ddl_symbol, ddl_action, ddl_shift,
                                    ddl_resp_name, ddl_Issue, ddl_tool_owner, ddl_model, ddl_Pro_type1, ddl_Pro_type2,
                                    ddl_Pro_type3, ddl_part_equi, ddl_touch, ddl_risk };
            foreach (DropDownList d in ddls) d.ClearSelection();

            ddl_year.ClearSelection();
            ListItem y = ddl_year.Items.FindByValue(DateTime.Now.Year.ToString());
            if (y != null) y.Selected = true;

            bind_row();
        }

        /// <summary>ทุก Filter ใช้ event เดียวกัน : ค้นหาใหม่และกลับไปหน้า 1</summary>
        protected void Filter_Changed(object sender, EventArgs e)
        {
            bind_row();
        }

        /// <summary>แสดงจำนวน Filter อื่นๆ ที่ถูกเลือกอยู่ บนปุ่ม Filter</summary>
        private void Set_advCount()
        {
            int n = 0;
            DropDownList[] ddls = { ddl_type, ddl_status, ddl_symbol, ddl_action, ddl_shift, ddl_resp_name, ddl_Issue,
                                    ddl_tool_owner, ddl_model, ddl_Pro_type1, ddl_Pro_type2, ddl_Pro_type3,
                                    ddl_part_equi, ddl_touch, ddl_risk };
            foreach (DropDownList d in ddls) if (d.SelectedValue != "") n++;

            if (txt_problem1.Text.Trim() != "" || txt_problem2.Text.Trim() != "") n++;
            if (txt_follow_up.Text.Trim() != "" || txt_follow_up2.Text.Trim() != "") n++;
            if (txt_tss_main1.Text.Trim() != "" || txt_tss_main2.Text.Trim() != "") n++;
            if (txt_tss_sub1.Text.Trim() != "" || txt_tss_sub2.Text.Trim() != "") n++;
            if (txt_no_of_tool.Text.Trim() != "") n++;

            lbl_advCount.Text = n.ToString();
            lbl_advCount.Visible = n > 0;
        }

        /// <summary>กัน ' ใน text ที่ผู้ใช้พิมพ์ (SQL ต่อ string)</summary>
        private static string Q(string s)
        {
            return (s ?? "").Trim().Replace("'", "''");
        }

        protected string Search_fuction()
        {
            return Search_fuction(true);
        }

        protected string Search_fuction(bool includeStatus)
        {
            string search = "";

            string status = Request.QueryString["status"];
            string month_id = Request.QueryString["month"];
            string group = Request.QueryString["group"];

            // ----- Filter หลัก -----
            if (txt_problem.Text.Trim() != "")
            {
                search += " and A.PM_problem_name Like N'%" + Q(txt_problem.Text) + "%'";
            }
            if (txt_tool_no.Text.Trim() != "")
            {
                // Tool : ค้นได้หลาย column (Tool No / No of Tool / Model)
                string t = Q(txt_tool_no.Text);
                search += " and (A.tool_no Like N'%" + t + "%' or A.toolSub_Name Like N'%" + t + "%' or A.model_name Like N'%" + t + "%')";
            }
            if (ddl_year.SelectedValue != "")
            {
                search += " and year(A.check_date) = '" + Q(ddl_year.SelectedValue) + "'  ";
            }
            if (ddl_priority.SelectedValue != "")
            {
                search += " and A.priority = '" + Q(ddl_priority.SelectedValue) + "'";
            }
            if (group != null)
            {
                search += " and A.rep_group = '" + Q(group) + "'";
            }
            if (ddl_resp.SelectedValue != "")
            {
                search += " and A.rep_group = '" + Q(ddl_resp.SelectedItem.Text) + "'";
            }

            // ----- Filter อื่นๆ -----
            if (month_id != null)
            {
                search += " and MONTH(A.check_date) = '" + Q(month_id) + "' ";
            }

            string p1 = Q(txt_problem1.Text), p2 = Q(txt_problem2.Text);
            // From / To ใส่อย่างใดอย่างหนึ่งก็ได้ (To รวมทั้งวัน)
            if (p1 != "")
                search += " and CONVERT(datetime, A.check_date,106) >= CONVERT(datetime, '" + p1 + "', 106) ";
            if (p2 != "")
                search += " and CONVERT(datetime, A.check_date,106) < DATEADD(day, 1, CONVERT(datetime, '" + p2 + "', 106)) ";

            string f1 = Q(txt_follow_up.Text), f2 = Q(txt_follow_up2.Text);
            if (f1 != "" && f2 != "")
                search += " and A.Follow_up  between  '" + f1 + "' and '" + f2 + "' ";
            else if (f1 != "" || f2 != "")
                search += " and A.Follow_up = '" + (f1 != "" ? f1 : f2) + "'";

            string m1 = Q(txt_tss_main1.Text), m2 = Q(txt_tss_main2.Text);
            if (m1 != "" && m2 != "")
                search += " and A.TSS_Main between  '" + m1 + "' and '" + m2 + "' ";
            else if (m1 != "" || m2 != "")
                search += " and A.TSS_Main = '" + (m1 != "" ? m1 : m2) + "' ";

            string s1 = Q(txt_tss_sub1.Text), s2 = Q(txt_tss_sub2.Text);
            if (s1 != "" && s2 != "")
                search += " and A.TSS_sub between  '" + s1 + "' and '" + s2 + "' ";
            else if (s1 != "" || s2 != "")
                search += " and A.TSS_sub = '" + (s1 != "" ? s1 : s2) + "' ";

            if (ddl_shift.SelectedValue != "")
            {
                search += " and A.shift = " + Q(ddl_shift.SelectedValue) + "";
            }
            if (ddl_type.SelectedValue != "")
            {
                search += " and A.typeProblem = '" + Q(ddl_type.SelectedValue) + "'";
            }
            if (ddl_symbol.SelectedValue != "")
            {
                search += " and A.pro_type1 = '" + Q(ddl_symbol.SelectedValue) + "' ";
            }

            if (includeStatus)
            {
                if (status != null)
                {
                    switch (status)
                    {
                        case "3":
                            search += " and A.isOnplan in(3,4,5,6) ";
                            break;
                        default:
                            search += " and A.isOnplan = '" + Q(status) + "'";
                            break;
                    }
                }
                if (ddl_status.SelectedValue != "")
                {
                    search += " and A.isOnplan = " + Q(ddl_status.SelectedValue) + "";
                }
            }
            else if (status != null)
            {
                // status จาก URL เป็นเงื่อนไขคงที่ของหน้า → ใช้กับการนับ Status Card ด้วย
                search += (status == "3") ? " and A.isOnplan in(3,4,5,6) " : " and A.isOnplan = '" + Q(status) + "'";
            }

            if (ddl_action.SelectedValue != "")
            {
                search += " and A.action_id = " + Q(ddl_action.SelectedValue) + "";
            }
            if (txt_no_of_tool.Text.Trim() != "")
            {
                search += " and A.toolSub_Name Like N'%" + Q(txt_no_of_tool.Text) + "%'";
            }
            if (ddl_model.SelectedValue != "")
            {
                search += " and A.model_id = " + Q(ddl_model.SelectedValue) + "";
            }
            if (ddl_resp_name.SelectedValue != "")
            {
                search += " and A.emp_id = '" + Q(ddl_resp_name.SelectedValue) + "'";
            }
            if (ddl_tool_owner.SelectedValue != "")
            {
                search += " and A.owner_group = '" + Q(ddl_tool_owner.SelectedItem.Text) + "'";
            }
            if (ddl_Pro_type1.SelectedValue != "")
            {
                search += " and A.pro_type1 = '" + Q(ddl_Pro_type1.SelectedValue) + "' ";
            }
            if (ddl_Pro_type2.SelectedValue != "")
            {
                search += " and A.pro_type2 = '" + Q(ddl_Pro_type2.SelectedValue) + "' ";
            }
            if (ddl_Pro_type3.SelectedValue != "")
            {
                search += " and A.pro_type3 = '" + Q(ddl_Pro_type3.SelectedValue) + "' ";
            }
            if (ddl_part_equi.SelectedValue != "")
            {
                search += " and A.part_equi = '" + Q(ddl_part_equi.SelectedValue) + "' ";
            }
            if (ddl_touch.SelectedValue != "")
            {
                search += " and A.touch_status = '" + Q(ddl_touch.SelectedValue) + "' ";
            }
            if (ddl_risk.SelectedValue != "")
            {
                search += " and A.risk_status = '" + Q(ddl_risk.SelectedValue) + "' ";
            }
            if (ddl_Issue.SelectedValue != "")
            {
                search += " and A.check_by  = '" + Q(ddl_Issue.SelectedValue) + "' ";
            }
            return search;
        }

        protected string Get_where()
        {
            string where = " ";
            return where;
        }

        protected string Get_where_fix()
        {
            string tool_id = Request.QueryString["tool_id"];
            string toolSub_id = Request.QueryString["toolSub_id"];

            string where = "";
            int n;
            if (int.TryParse(tool_id, out n))
                where += " and A.tool_id = " + n;
            if (int.TryParse(toolSub_id, out n))
                where += " and A.toolSub_id = " + n;
            return where;
        }

        protected void Bind_data(int start, int end)
        {
            string str = Bind(IsFixFilter());
            str += "  AND MyRowNumber BETWEEN " + start + " AND " + end;
            dc.QryDT(conn, str);
            gv1.DataSource = dc.dt;
            gv1.DataBind();

            if (gv1.HeaderRow != null)
                gv1.HeaderRow.TableSection = TableRowSection.TableHeader;
        }

        protected string Bind(int isFixFil)
        {
            string search = Search_fuction();
            string where = (isFixFil == 1 ? Get_where_fix() : Get_where());
            string str = "";
            str += "  SELECT * FROM (select ROW_NUMBER() OVER (ORDER BY PM_problem_id  desc) AS MyRowNumber, *  ";
            str += "  from PM_Tool_History A where A.PM_problem_id is not null " + where + search + " )  ";
            str += "  main where PM_problem_id is not null  ";
            return str;
        }

        protected void Set_totalRow(int isFixFil)
        {
            string search = Search_fuction();
            string where = (isFixFil == 1 ? Get_where_fix() : Get_where());
            string str = " select count(*) as cnt from PM_Tool_History A where A.PM_problem_id is not null " + where + search;

            dc.QryDT(conn, str);
            ViewState["Total_row"] = (dc.dt.Rows.Count > 0) ? Convert.ToInt32(dc.dt.Rows[0]["cnt"]) : 0;
        }

        protected void btn_detail_problem_Click(object sender, EventArgs e)
        {
            try
            {
                GridViewRow row = (sender as LinkButton).NamingContainer as GridViewRow;

                // ปีของ Problem (จากข้อมูลในแถว) ใช้เลือกหน้า follow เก่า/ใหม่
                // ถ้าไม่มี ใช้ปีที่เลือกใน Filter หรือปีปัจจุบัน (เดิม Parse ddl_year ตรงๆ → error เมื่อไม่เลือกปี)
                int yaer;
                HiddenField hd_prob_year = (HiddenField)row.FindControl("hd_prob_year");
                if (!int.TryParse(hd_prob_year.Value, out yaer) && !int.TryParse(ddl_year.SelectedValue, out yaer))
                    yaer = DateTime.Now.Year;

                HiddenField hd_problem_id = (HiddenField)row.FindControl("hd_problem_id");
                HiddenField hd_tool_id = (HiddenField)row.FindControl("hd_tool_id");

                string problem_id = hiddenVar_handern(hd_problem_id.Value);
                
                Label lb_probNo = (Label)row.FindControl("lb_probNo");

                string url = "";
                if (Session["emp_id"] != null)
                {
                    string emp_id = Session["emp_id"].ToString();
                    if(yaer < 2025)
                    {
                        url = "PM_problem_follow.aspx?emp_id=" + emp_id + "&pm_problem_id=" + problem_id + "&pm_problem_name=" + lb_probNo.Text + "&tool_id=" + hd_tool_id.Value;

                    }
                    else
                    {
                        url = "PM_problem_follow_New.aspx?emp_id=" + emp_id + "&pm_problem_id=" + problem_id + "&pm_problem_name=" + lb_probNo.Text + "&tool_id=" + hd_tool_id.Value;
                    }
                }
                else
                {
                    url = "PM_problem_follow.aspx?pm_problem_id=" + problem_id;
                }
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                sb.Append(@"<script type='text/javascript'>");
                sb.Append("window.open('" + url + "','_blank');");
                sb.Append(@"</script>");
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "closemodal", sb.ToString(), false);
            }
            catch (Exception ex)
            {
                test.Text = ex.Message;
            }
        }
        protected string hiddenVar_handern(string var)
        {
            string[] var2 = var.Split(',');
            return var2[0];
        }
        private static string FormatDate(string raw, string format)
        {
            DateTime d;
            if (!string.IsNullOrEmpty(raw) && DateTime.TryParse(raw, out d))
                return d.ToString(format, System.Globalization.CultureInfo.InvariantCulture);
            return raw;
        }

        protected void gv1_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType != DataControlRowType.DataRow)
                return;

            // ----- Symbol -----
            HiddenField hd_symbol = e.Row.FindControl("hd_symbol") as HiddenField;
            Label lb_symbol = e.Row.FindControl("lb_symbol") as Label;
            if (hd_symbol.Value == "")
                lb_symbol.Visible = false;
            else
                lb_symbol.CssClass = "chip symbol_" + hd_symbol.Value;

            // ----- Priority -----
            Label lb_priority = e.Row.FindControl("lb_priority") as Label;
            switch (lb_priority.Text)
            {
                case "A":
                case "B":
                case "C":
                    lb_priority.CssClass = "prio-badge prio_" + lb_priority.Text; break;
                default: break;
            }

            // ----- Status (Pill สีเดียวกับ Status Card) -----
            HiddenField hd_status = e.Row.FindControl("hd_status") as HiddenField;
            Label lb_status = e.Row.FindControl("lb_status") as Label;
            if (hd_status.Value != "")
            {
                lb_status.Text = StatusName(hd_status.Value);
                lb_status.CssClass = "pill st-pill st-" + hd_status.Value;
            }

            // ----- Action (สีพื้น cell จาก Color_History_Status.css) -----
            HiddenField hd_action = e.Row.FindControl("hd_action") as HiddenField;
            TableCell actionCell = hd_action.Parent as TableCell;
            if (hd_action.Value != "" && actionCell != null)
                actionCell.CssClass += " action_" + hd_action.Value;

            // ----- Tool : ซ่อนส่วนที่ไม่มีข้อมูล -----
            Label lb_noOfTool = e.Row.FindControl("lb_noOfTool") as Label;
            Label lb_model = e.Row.FindControl("lb_model") as Label;
            if (lb_noOfTool.Text == "" && lb_model.Text == "")
                e.Row.FindControl("div_toolSub").Visible = false;

            // ----- Problem Date + Shift -----
            Label lb_prob_date = e.Row.FindControl("lb_prob_date") as Label;
            HiddenField hd_prob_year = e.Row.FindControl("hd_prob_year") as HiddenField;
            DateTime probDate;
            if (DateTime.TryParse(lb_prob_date.Text, out probDate))
            {
                hd_prob_year.Value = probDate.Year.ToString();
                lb_prob_date.ToolTip = probDate.ToString("dd-MMM-yyyy HH:mm", System.Globalization.CultureInfo.InvariantCulture);
                lb_prob_date.Text = probDate.ToString("dd-MMM-yyyy", System.Globalization.CultureInfo.InvariantCulture);
            }

            Label lb_shift = e.Row.FindControl("lb_shift") as Label;
            switch (lb_shift.Text)
            {
                case "1": lb_shift.Text = "<i class='fa fa-sun-o'></i> Day"; lb_shift.CssClass = "shift-tag day"; break;
                case "2": lb_shift.Text = "<i class='fa fa-moon-o'></i> Night"; lb_shift.CssClass = "shift-tag night"; break;
                default: break;
            }

            // ----- วันที่อื่นๆ ให้อยู่รูปแบบเดียวกัน -----
            Label lb_follow_up = e.Row.FindControl("lb_follow_up") as Label;
            Label lb_planFinish = e.Row.FindControl("lb_planFinish") as Label;
            Label lb_actualFinish = e.Row.FindControl("lb_actualFinish") as Label;
            lb_follow_up.Text = FormatDate(lb_follow_up.Text, "dd-MMM-yyyy");
            lb_planFinish.Text = FormatDate(lb_planFinish.Text, "dd-MMM-yyyy");
            lb_actualFinish.Text = FormatDate(lb_actualFinish.Text, "dd-MMM-yyyy");

            // ----- P2 - P4 -----
            string[] chipIds = { "lb_proType2", "lb_proType3", "lb_proType4" };
            foreach (string id in chipIds)
            {
                Label lb = e.Row.FindControl(id) as Label;
                if (lb.Text != "") lb.CssClass = "chip chip-p";
            }

            // ----- P5 / P6 (Yes / No) -----
            string[] ynIds = { "lb_proType5", "lb_proType6" };
            foreach (string id in ynIds)
            {
                Label lb = e.Row.FindControl(id) as Label;
                string v = lb.Text.Trim().ToLower();
                if (v == "yes") lb.CssClass = "pill yn-yes";
                else if (v == "no") lb.CssClass = "pill yn-no";
            }
        }

        protected void xls_Click(object sender, EventArgs e)
        {
            string fomart = @"\\cptfile02\Pro\PRJ2016017\10_Tooling Management Control System\00_System\Template\Dashboard_PM_Problem\Dashboard_PM_Problem.xlsm";

           // string new_folder = @"\\cptfile02\Pro\PRJ2016017\10_Tooling Management Control System\00_System\Template\Dashboard_PM_Problem\Dashboard_PM_Problem_test.xlsx";

            //if (Directory.Exists(new_folder) == false)
            //{
            //    Directory.CreateDirectory(new_folder);
            //}
            //File.Copy(fomart,new_folder);


            gv1.AllowPaging = false;
            Bind_data(0, Convert.ToInt32(ViewState["Total_row"]));

           
            //if (dc.dt.Rows.Count > 500)
            //    return;
           
            DataTable excel = dc.dt;

            var workbook = new XLWorkbook(fomart);
            var worksheet = workbook.Worksheet("Data");

           
            for (int i = 1; i < 21; i++)
            {
                worksheet.Cell(1, i).Style.Font.Bold = true;
                worksheet.Cell(1, i).Style.Fill.BackgroundColor = XLColor.FromHtml("#0072b5");
                worksheet.Cell(1, i).Style.Font.FontColor = XLColor.White;
                worksheet.Cell(1, i).Style.Font.FontSize = 12;
                worksheet.Cell(1, i).Style.Font.FontName = "Arial";
                worksheet.Row(1).Height = 24;

                worksheet.Cell(1, i).Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                worksheet.Cell(1, i).Style.Border.OutsideBorderColor = XLColor.FromHtml("#0072b5");

            }

           
            for (int i = 2; i < excel.Rows.Count + 2; i++)
            {
                //string symbol_color = "";
                //string priority_color = "";
                //if (excel.Rows[i - 2]["symbol"].ToString() == "1")
                //{
                //     symbol_color = "#ff0000";
                //}
                //else if (excel.Rows[i - 2]["symbol"].ToString() == "2")
                //{
                //    symbol_color = " #9a57cd";
                //}
                //else if (excel.Rows[i - 2]["symbol"].ToString() == "3" || excel.Rows[i - 2]["symbol"].ToString() == "4" || excel.Rows[i - 2]["symbol"].ToString() == "5")
                //{
                //    symbol_color = "#8faadc";
                //}
                //else if (excel.Rows[i - 2]["symbol"].ToString() == "6" || excel.Rows[i - 2]["symbol"].ToString() == "7" || excel.Rows[i - 2]["symbol"].ToString() == "8" || excel.Rows[i - 2]["symbol"].ToString() == "9" || excel.Rows[i - 2]["symbol"].ToString() == "11")
                //{
                //    symbol_color = "#ffd966";
                //}
                //else if (excel.Rows[i - 2]["symbol"].ToString() == "10")
                //{
                //    symbol_color = "#7f7f7f";
                //}
                //else if (excel.Rows[i - 2]["symbol"].ToString() == "12")
                //{
                //    symbol_color = "#f4b183";
                //}
                //else if (excel.Rows[i - 2]["symbol"].ToString() == "13")
                //{
                //    symbol_color = "#4472c4";
                //}
               
                //if(excel.Rows[i - 2]["priority"].ToString() == "A")
                //{
                //    priority_color = "#ff0000";
                //}
                //else if(excel.Rows[i - 2]["priority"].ToString() == "B")
                //{
                //    priority_color = "#926aa6";
                //}
                //else if(excel.Rows[i - 2]["priority"].ToString() == "C")
                //{
                //    priority_color = "#f5df4d";
                //}
              

                worksheet.Cell(i, 1).Value = i-1;
                worksheet.Cell(i, 1).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                worksheet.Cell(i, 2).Value = excel.Rows[i - 2]["PM_problem_name"].ToString();
                worksheet.Cell(i, 3).Value = excel.Rows[i - 2]["typeProblem"].ToString();
                worksheet.Cell(i, 4).Value = excel.Rows[i - 2]["pro_type1"].ToString();
                worksheet.Cell(i, 4).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                //worksheet.Cell(i, 4).Style.Fill.BackgroundColor = XLColor.FromHtml(symbol_color);
                worksheet.Cell(i, 5).Value = excel.Rows[i - 2]["priority"].ToString();
                worksheet.Cell(i, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
               // worksheet.Cell(i, 5).Style.Fill.BackgroundColor = XLColor.FromHtml(priority_color);
                string status_plan = "";
                switch (excel.Rows[i - 2]["isOnplan"].ToString())
                {
                    case "0": status_plan = "Acknowledge";  break;
                    case "1": status_plan = "On plan";  break;
                    case "2": status_plan = "Delay";  break;
                    case "3": status_plan = "Send for check";  break;
                    case "4": status_plan = "Tool Owner[J3] Check";  break;
                    case "5": status_plan = "ENG4[J3] check"; break;
                    case "6": status_plan = "ENG4[Mgr] Approve"; break;
                    case "7": status_plan = "Close";  break;
                    case "8": status_plan = "Cancel";  break;
                    case "9": status_plan = "New Problem";  break;
                    default: break;

                }

                worksheet.Cell(i, 6).Value = status_plan; // excel.Rows[i - 2]["isOnplan"].ToString();
                worksheet.Cell(i, 6).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                worksheet.Cell(i, 7).Value = excel.Rows[i - 2]["action_name"].ToString();
                worksheet.Cell(i, 7).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                worksheet.Cell(i, 8).Value = excel.Rows[i - 2]["Follow_up"].ToString();
                worksheet.Cell(i, 9).Value = excel.Rows[i - 2]["plan_finish"].ToString();
                worksheet.Cell(i, 9).Style.NumberFormat.Format = "dd-MMM-yyyy";
                worksheet.Cell(i, 10).Value = excel.Rows[i - 2]["actual_finish"].ToString();
                worksheet.Cell(i, 10).Style.NumberFormat.Format = "dd-MMM-yyyy";
                worksheet.Cell(i, 11).Value = excel.Rows[i - 2]["tool_no"].ToString();
                worksheet.Cell(i, 12).Value = excel.Rows[i - 2]["toolSub_Name"].ToString();
                worksheet.Cell(i, 13).Value = excel.Rows[i - 2]["model_name"].ToString();
                worksheet.Cell(i, 14).Value = excel.Rows[i - 2]["check_date"].ToString();
                worksheet.Cell(i, 14).Style.NumberFormat.Format = "dd-MMM-yyyy hh:mm:ss";
                string shift = "";
               switch(excel.Rows[i - 2]["shift"].ToString())
                {
                    case "1": shift = "Day"; break;
                    case "2": shift = "Night"; break;
                    default: break;
                }
                worksheet.Cell(i, 15).Value = shift; // excel.Rows[i - 2]["shift"].ToString();
                worksheet.Cell(i, 15).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                worksheet.Cell(i, 16).Value = excel.Rows[i - 2]["TSS_sub"].ToString();
                worksheet.Cell(i, 17).Value = excel.Rows[i - 2]["TSS_Main"].ToString();
                worksheet.Cell(i, 18).Value = excel.Rows[i - 2]["owner_group"].ToString();
                worksheet.Cell(i, 18).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                worksheet.Cell(i, 19).Value = excel.Rows[i - 2]["PIC"].ToString();
                worksheet.Cell(i, 19).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                worksheet.Cell(i, 20).Value = excel.Rows[i - 2]["rep_group"];
                worksheet.Cell(i, 20).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                worksheet.Cell(i, 21).Value = excel.Rows[i - 2]["proType2"];
                worksheet.Cell(i, 21).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                worksheet.Cell(i, 22).Value = excel.Rows[i - 2]["proType3"];
                worksheet.Cell(i, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                worksheet.Cell(i, 23).Value = excel.Rows[i - 2]["part"];
                worksheet.Cell(i, 23).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                worksheet.Cell(i, 24).Value = excel.Rows[i - 2]["touch_status"];
                worksheet.Cell(i, 24).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                worksheet.Cell(i, 25).Value = excel.Rows[i - 2]["risk_status"];
                worksheet.Cell(i, 25).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

                worksheet.Row(i).Style.Font.FontName = "Arial";
                worksheet.Row(i).Height = 18;
 
            }

            worksheet.Columns().AdjustToContents();
            Response.Clear();
            Response.Buffer = true;
            Response.Charset = "";
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.AddHeader("content-disposition", "attachment;filename=History_List.xlsm");
            using (MemoryStream MyMemoryStream = new MemoryStream())
            {
                workbook.SaveAs(MyMemoryStream);
                MyMemoryStream.WriteTo(Response.OutputStream);
                Response.Flush();
                Response.End();

            }


        }

        private void Bind_ddlPIC(string eng_group_id)
        {
            string str2 = " select '-Select-' as name ,0 as position_id,0 as eng_group_id,0 as user_dept,'' as emp_id , 0 as order_ " +
                          " union select 'Pakapol S.' as name ,8 as position_id,5 as eng_group_id,5 as user_dept,'018710' as emp_id , 1 as order_ " +
                          " union select REPLACE(REPLACE(fname,'Ms.',''),'Mr.','') + ' ' + SUBSTRING(lname,1,1) + '.' as name,position_id,eng_group_id,user_dept ,emp_id, 1 as order_ from cptsvs528.user_master.dbo.sys_user_master a where eng_group_id =" + eng_group_id + " and user_dept in (3,5) and position_id <> 7 and status = 1 and position_id <> 9 order by order_ ";
            dc.QryDT(conn, str2);
            ddl_resp_name.DataSource = dc.dt;
            ddl_resp_name.DataTextField = "name";
            ddl_resp_name.DataValueField = "emp_id";
            ddl_resp_name.DataBind();

          

        }

    }
}
