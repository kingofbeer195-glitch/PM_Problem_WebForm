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

        /// <summary>ค้นหาใหม่ → กลับไปหน้า 1</summary>
        protected void bind_row()
        {
            CurrentPage = 1;
            Load_data();
        }

        /// <summary>โหลดข้อมูลหน้าปัจจุบัน + Pager + Record count + Status Card (query ครั้งเดียว)</summary>
        protected void Load_data()
        {
            int start = ((CurrentPage - 1) * PageSize) + 1;
            DataSet ds = Query_list(start, CurrentPage * PageSize);

            int total = Convert.ToInt32(ds.Tables[1].Rows[0]["cnt"]);
            int totalPage = (total == 0) ? 1 : (int)Math.Ceiling(total / (double)PageSize);

            // หน้าเกินจำนวนจริง (เช่น ข้อมูลลดลงระหว่างใช้งาน) → ไปหน้าสุดท้าย
            if (CurrentPage > totalPage)
            {
                CurrentPage = totalPage;
                start = ((CurrentPage - 1) * PageSize) + 1;
                ds = Query_list(start, CurrentPage * PageSize);
            }

            ViewState["Total_row"] = total;
            ViewState["Total_Page"] = totalPage;

            gv1.DataSource = ds.Tables[2];
            gv1.DataBind();
            if (gv1.HeaderRow != null)
                gv1.HeaderRow.TableSection = TableRowSection.TableHeader;

            Build_pager(totalPage);

            lblRecordCount.Text = (total == 0)
                ? "ไม่พบข้อมูล"
                : string.Format("Showing <b>{0:#,0}</b> – <b>{1:#,0}</b> of <b>{2:#,0}</b> entries", start, Math.Min(CurrentPage * PageSize, total), total);

            Bind_statusCards(ds.Tables[0]);
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
        private void Bind_statusCards(DataTable statusCount)
        {
            Dictionary<string, int> counts = new Dictionary<string, int>();
            int all = 0;
            foreach (DataRow r in statusCount.Rows)
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
            DropDownList[] ddls = { ddl_type, ddl_status, ddl_action, ddl_shift, ddl_resp_name, ddl_Issue,
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

        // =====================================================================
        //  Query
        //  - Filter ทั้งหมดส่งเป็น SqlParameter (ไม่ต่อ string จาก input ผู้ใช้)
        //  - อ่าน View PM_Tool_History "ครั้งเดียว" ลง #base (เฉพาะ column ที่ใช้)
        //    แล้วนับ Status Card / นับ Total / ดึงหน้าที่แสดง จาก #base
        //    (เดิมอ่าน View 3 รอบ : Count, Data, Status Card)
        // =====================================================================

        /// <summary>Column ที่หน้านี้ใช้จริง (Grid + Excel) — ไม่ดึง prob_detail, comment ฯลฯ</summary>
        private const string ListColumns =
            " A.PM_problem_id, A.PM_problem_name, A.typeProblem, A.pro_type1, A.priority, A.isOnplan," +
            " A.action_id, A.action_name, A.PIC, A.rep_group, A.Follow_up, A.plan_finish, A.actual_finish," +
            " A.tool_id, A.tool_no, A.toolSub_id, A.toolSub_Name, A.model_name, A.check_date, A.shift," +
            " A.TSS_sub, A.TSS_Main, A.owner_group, A.proType2, A.proType3, A.part, A.touch_status, A.risk_status ";

        private class ListFilter
        {
            public string BaseSql = "";     // ใช้ตอนอ่าน View → #base (ทุก filter ยกเว้น Status dropdown/Card)
            public string StatusSql = "";   // ใช้กับ #base (Status dropdown/Card)
            public List<SqlParameter> Params = new List<SqlParameter>();

            public void Add(string sql, string name, SqlDbType type, object value)
            {
                BaseSql += sql;
                SqlParameter p = new SqlParameter(name, type);
                p.Value = value;
                Params.Add(p);
            }
        }

        private static string T(TextBox t) { return (t.Text ?? "").Trim(); }

        private static bool TryInt(string s, out int n) { return int.TryParse((s ?? "").Trim(), out n); }

        private static bool TryDate(string s, out DateTime d)
        {
            string[] fm = { "dd-MMM-yyyy", "d-MMM-yyyy", "yyyy-MM-dd", "dd/MM/yyyy" };
            return DateTime.TryParseExact((s ?? "").Trim(), fm, System.Globalization.CultureInfo.InvariantCulture,
                                          System.Globalization.DateTimeStyles.None, out d);
        }

        private ListFilter Build_filter()
        {
            ListFilter f = new ListFilter();
            int n, n2;
            DateTime d1, d2;

            // ----- เงื่อนไขคงที่จาก URL -----
            if (TryInt(Request.QueryString["tool_id"], out n))
                f.Add(" AND A.tool_id = @qs_tool_id", "@qs_tool_id", SqlDbType.Int, n);
            if (Request.QueryString["tool_id"] != null && TryInt(Request.QueryString["toolSub_id"], out n))
                f.Add(" AND A.toolSub_id = @qs_toolSub_id", "@qs_toolSub_id", SqlDbType.Int, n);
            if (TryInt(Request.QueryString["month"], out n))
                f.Add(" AND MONTH(A.check_date) = @qs_month", "@qs_month", SqlDbType.Int, n);
            if (!string.IsNullOrEmpty(Request.QueryString["group"]))
                f.Add(" AND A.rep_group = @qs_group", "@qs_group", SqlDbType.NVarChar, Request.QueryString["group"]);
            string qsStatus = Request.QueryString["status"];
            if (qsStatus == "3")
                f.BaseSql += " AND A.isOnplan IN (3,4,5,6)";
            else if (TryInt(qsStatus, out n))
                f.Add(" AND A.isOnplan = @qs_status", "@qs_status", SqlDbType.Int, n);

            // ----- Filter หลัก -----
            if (T(txt_problem) != "")
                f.Add(" AND A.PM_problem_name LIKE @prob_no", "@prob_no", SqlDbType.VarChar, "%" + T(txt_problem) + "%");
            if (T(txt_tool_no) != "")
                f.Add(" AND A.tool_no LIKE @tool_no", "@tool_no", SqlDbType.NVarChar, "%" + T(txt_tool_no) + "%");
            if (TryInt(ddl_year.SelectedValue, out n))
            {
                // ช่วงวันที่แทน YEAR() → เทียบได้ตรงกับ Problem Date filter
                f.Add(" AND CONVERT(datetime, A.check_date, 106) >= @year_from", "@year_from", SqlDbType.DateTime, new DateTime(n, 1, 1));
                f.Add(" AND CONVERT(datetime, A.check_date, 106) < @year_to", "@year_to", SqlDbType.DateTime, new DateTime(n + 1, 1, 1));
            }
            if (TryInt(ddl_symbol.SelectedValue, out n))
                f.Add(" AND A.pro_type1 = @symbol", "@symbol", SqlDbType.Int, n);
            if (ddl_priority.SelectedValue != "")
                f.Add(" AND A.priority = @priority", "@priority", SqlDbType.VarChar, ddl_priority.SelectedValue);
            if (ddl_resp.SelectedValue != "")
                f.Add(" AND A.rep_group = @rep_group", "@rep_group", SqlDbType.NVarChar, ddl_resp.SelectedItem.Text);

            // ----- Filter อื่นๆ -----
            if (TryInt(ddl_type.SelectedValue, out n))
                f.Add(" AND A.typeProblem = @type", "@type", SqlDbType.Int, n);
            if (TryInt(ddl_action.SelectedValue, out n))
                f.Add(" AND A.action_id = @action", "@action", SqlDbType.Int, n);

            if (TryDate(T(txt_problem1), out d1))
                f.Add(" AND CONVERT(datetime, A.check_date, 106) >= @prob_from", "@prob_from", SqlDbType.DateTime, d1);
            if (TryDate(T(txt_problem2), out d2))
                f.Add(" AND CONVERT(datetime, A.check_date, 106) < @prob_to", "@prob_to", SqlDbType.DateTime, d2.AddDays(1));

            if (TryInt(ddl_shift.SelectedValue, out n))
                f.Add(" AND A.shift = @shift", "@shift", SqlDbType.Int, n);

            // Follow Up : เดิมเทียบเป็น string ('01-Nov-2026' < '30-Oct-2026') → ผลผิด → เทียบเป็นวันที่
            bool hasF1 = TryDate(T(txt_follow_up), out d1), hasF2 = TryDate(T(txt_follow_up2), out d2);
            if (hasF1 && hasF2)
            {
                f.Add(" AND CONVERT(date, A.Follow_up, 106) >= @fu_from", "@fu_from", SqlDbType.Date, d1);
                f.Add(" AND CONVERT(date, A.Follow_up, 106) <= @fu_to", "@fu_to", SqlDbType.Date, d2);
            }
            else if (hasF1 || hasF2)
                f.Add(" AND CONVERT(date, A.Follow_up, 106) = @fu_on", "@fu_on", SqlDbType.Date, hasF1 ? d1 : d2);

            bool hasM1 = TryInt(T(txt_tss_main1), out n), hasM2 = TryInt(T(txt_tss_main2), out n2);
            if (hasM1 && hasM2)
            {
                f.Add(" AND A.TSS_Main BETWEEN @tssm_from AND @tssm_to", "@tssm_from", SqlDbType.Int, n);
                f.Params.Add(new SqlParameter("@tssm_to", SqlDbType.Int) { Value = n2 });
            }
            else if (hasM1 || hasM2)
                f.Add(" AND A.TSS_Main = @tssm", "@tssm", SqlDbType.Int, hasM1 ? n : n2);

            bool hasS1 = TryInt(T(txt_tss_sub1), out n), hasS2 = TryInt(T(txt_tss_sub2), out n2);
            if (hasS1 && hasS2)
            {
                f.Add(" AND A.TSS_sub BETWEEN @tsss_from AND @tsss_to", "@tsss_from", SqlDbType.Int, n);
                f.Params.Add(new SqlParameter("@tsss_to", SqlDbType.Int) { Value = n2 });
            }
            else if (hasS1 || hasS2)
                f.Add(" AND A.TSS_sub = @tsss", "@tsss", SqlDbType.Int, hasS1 ? n : n2);

            if (ddl_resp_name.SelectedValue != "")
                f.Add(" AND A.emp_id = @emp_id", "@emp_id", SqlDbType.VarChar, ddl_resp_name.SelectedValue);
            if (ddl_Issue.SelectedValue != "")
                f.Add(" AND A.check_by = @check_by", "@check_by", SqlDbType.NVarChar, ddl_Issue.SelectedValue);
            if (ddl_tool_owner.SelectedValue != "")
                f.Add(" AND A.owner_group = @owner", "@owner", SqlDbType.NVarChar, ddl_tool_owner.SelectedItem.Text);
            if (T(txt_no_of_tool) != "")
                f.Add(" AND A.toolSub_Name LIKE @no_of_tool", "@no_of_tool", SqlDbType.NVarChar, "%" + T(txt_no_of_tool) + "%");
            if (TryInt(ddl_model.SelectedValue, out n))
                f.Add(" AND A.model_id = @model", "@model", SqlDbType.Int, n);

            if (TryInt(ddl_Pro_type1.SelectedValue, out n))
                f.Add(" AND A.pro_type1 = @p1", "@p1", SqlDbType.Int, n);
            if (TryInt(ddl_Pro_type2.SelectedValue, out n))
                f.Add(" AND A.pro_type2 = @p2", "@p2", SqlDbType.Int, n);
            if (TryInt(ddl_Pro_type3.SelectedValue, out n))
                f.Add(" AND A.pro_type3 = @p3", "@p3", SqlDbType.Int, n);
            if (TryInt(ddl_part_equi.SelectedValue, out n))
                f.Add(" AND A.part_equi = @part", "@part", SqlDbType.Int, n);
            if (ddl_touch.SelectedValue != "")
                f.Add(" AND A.touch_status = @touch", "@touch", SqlDbType.NVarChar, ddl_touch.SelectedValue);
            if (ddl_risk.SelectedValue != "")
                f.Add(" AND A.risk_status = @risk", "@risk", SqlDbType.NVarChar, ddl_risk.SelectedValue);

            // ----- Status (dropdown / Card) : ใช้กับ #base เพื่อให้ Status Card ยังนับทุก Status ได้ -----
            if (TryInt(ddl_status.SelectedValue, out n))
            {
                f.StatusSql = " AND isOnplan = @status";
                f.Params.Add(new SqlParameter("@status", SqlDbType.Int) { Value = n });
            }
            return f;
        }

        /// <summary>
        /// Tables[0] = จำนวนต่อ Status (สำหรับ Card), Tables[1] = Total, Tables[2] = แถวของหน้าที่ขอ
        /// </summary>
        private DataSet Query_list(int rowStart, int rowEnd)
        {
            ListFilter f = Build_filter();

            string sql =
                "SET NOCOUNT ON; " +
                "SELECT " + ListColumns + " INTO #base FROM PM_Tool_History A WHERE A.PM_problem_id IS NOT NULL " + f.BaseSql + "; " +
                "SELECT isOnplan, COUNT(*) AS cnt FROM #base GROUP BY isOnplan; " +
                "SELECT COUNT(*) AS cnt FROM #base WHERE 1 = 1 " + f.StatusSql + "; " +
                "SELECT * FROM (SELECT ROW_NUMBER() OVER (ORDER BY PM_problem_id DESC) AS MyRowNumber, * FROM #base WHERE 1 = 1 " + f.StatusSql + ") X " +
                "WHERE MyRowNumber BETWEEN @row_start AND @row_end ORDER BY MyRowNumber; " +
                "DROP TABLE #base;";

            DataSet ds = new DataSet();
            using (SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Sql"].ConnectionString))
            using (SqlCommand cmd = new SqlCommand(sql, cn))
            {
                cmd.CommandTimeout = 120;
                cmd.Parameters.AddRange(f.Params.ToArray());
                cmd.Parameters.Add("@row_start", SqlDbType.Int).Value = rowStart;
                cmd.Parameters.Add("@row_end", SqlDbType.Int).Value = rowEnd;
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    da.Fill(ds);
                }
            }
            return ds;
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


            // ดึงทุกแถวตาม Filter ปัจจุบัน (Tables[2])
            DataTable excel = Query_list(1, int.MaxValue).Tables[2];

           
            //if (dc.dt.Rows.Count > 500)
            //    return;
           

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
