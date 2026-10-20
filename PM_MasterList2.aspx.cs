using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Runtime.Remoting.Messaging;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace jig_tool
{
    public partial class PM_MasterList : BasePage //System.Web.UI.Page
    {
        SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["sql"].ConnectionString);
        datacon dc = new datacon();

        public override void VerifyRenderingInServerForm(Control control)
        {
            /* Confirms that an HtmlForm control is rendered for the specified ASP.NET
               server control at run time. */
        }

        private void RegisterPostBackControl()
        {
            foreach (GridViewRow row in GridView1.Rows)
            {
                LinkButton Btn_Edit = row.FindControl("Btn_Edit") as LinkButton;
                ScriptManager.GetCurrent(this).RegisterAsyncPostBackControl(Btn_Edit);

                LinkButton Btn_ViewDetail = row.FindControl("Btn_ViewDetail") as LinkButton;
                ScriptManager.GetCurrent(this).RegisterPostBackControl(Btn_ViewDetail);
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // ===== Authentication Check =====
            // Mode 1: มี Session อยู่แล้ว → ผ่าน
            // Mode 2: มี emp_id จาก QueryString
            // Mode 3: มา SharedSession จาก ENG4_System

            string emp_id = Request.QueryString["emp_id"];
            if (!string.IsNullOrEmpty(emp_id) && Session["emp_id"] == null)
            {
                // Mode 2: set session จาก QueryString
                login_getUser getUser = new login_getUser();
                getUser.Get_forSession(emp_id);
                Session["user_id"] = getUser.USER_ID;
                Session["emp_id"] = getUser.EMP_ID;
                Session["user_name"] = getUser.USER_NAME;
                Session["positionId"] = getUser.POSITION_ID;
                Session["eng_group_id"] = getUser.ENG_GROUP_ID;
                Session["user_group"] = getUser.USER_GROUP;
                Session["admin"] = getUser.USER_ADMIN;
                Session["dept"] = getUser.USER_DEPT;
            }
            else if (Session["emp_id"] == null)
            {
                // Mode 3: เช็ค SharedSession
                var sharedSession = SharedSessionHelper.ValidateSession();
                if (sharedSession != null && !string.IsNullOrEmpty(sharedSession.EmpId))
                {
                    login_getUser getUser = new login_getUser();
                    getUser.Get_forSession(sharedSession.EmpId);
                    Session["user_id"] = getUser.USER_ID;
                    Session["emp_id"] = getUser.EMP_ID;
                    Session["user_name"] = getUser.USER_NAME;
                    Session["positionId"] = getUser.POSITION_ID;
                    Session["eng_group_id"] = getUser.ENG_GROUP_ID;
                    Session["user_group"] = getUser.USER_GROUP;
                    Session["admin"] = getUser.USER_ADMIN;
                    Session["dept"] = getUser.USER_DEPT;
                }
            }

            // ถ้ายังไม่มี session → redirect
            if (Session["emp_id"] == null)
            {
                Response.Redirect("Default.aspx", true);
                return;
            }
            // ===================================

            //ShowDebugSession(); //← ลบออก หรือ comment เมื่อ test เสร็จ

            SetPage();
            if (!IsPostBack)
            {
                GridView1.PageSize = int.Parse(ddl_pageSize.SelectedValue);
                Bind();
            }

            RegisterPostBackControl();

            //if (Session["emp_id"] == null)
            //{
            //    Response.Redirect("Default.aspx");
            //}

            //SetPage();
            //if (IsPostBack == false)
            //{
            //    // กำหนด PageSize เริ่มต้นจาก ddl_pageSize (ค่า default = 20)
            //    GridView1.PageSize = int.Parse(ddl_pageSize.SelectedValue);
            //    Bind();
            //}

            //RegisterPostBackControl();
        }

        protected void SetPage()
        {
            if (Request.QueryString["status"] != null)
            {
                string status = Request.QueryString["status"];
                if (status == "4")
                {
                    header1.Visible = false;
                    header2.Visible = true;
                    header3.Visible = false;
                }
                if (status == "5")
                {
                    header1.Visible = false;
                    header2.Visible = false;
                    header3.Visible = true;
                }
            }
            else
            {
                header1.Visible = true;
                header2.Visible = false;
                header3.Visible = false;
            }
        }

        protected string GetWhere()
        {
            string where = "";
            string tool_id = txtS_toolId.Text.Trim().Replace("T", "");
            if (tool_id != "")
            {
                where += " AND PM_STATUS.tool_id = " + tool_id + " ";
            }

            string tool_no = txtS_toolNo.Text.Trim();
            if (tool_no != "")
            {
                where += " AND TOOL_MASTER.tool_no LIKE '%" + tool_no + "%'";
            }

            if (ddl_rank.SelectedValue != "")
            {
                where += " and TOOL_MASTER.rank_id = '" + ddl_rank.SelectedValue + "' ";
            }

            //category
            if (ddl_cate.SelectedValue != "")
            {
                where += " and TOOL_MASTER.is_category = '" + ddl_cate.SelectedValue + "' ";
            }

            // Status Send for Check
            if (Request.QueryString["status"] != null)
            {
                string status = Request.QueryString["status"];
                if (status != "")
                {
                    where += " and PM_STATUS.PMCSH_status = " + status + " ";
                }
            }

            if (ddl_PMstatus.SelectedValue != "")
            {
                where += " and PM_STATUS.PMCSH_status = " + ddl_PMstatus.SelectedValue + " ";
            }

            if (ddl_model.SelectedValue != "")
            {
                string str2 = "";
                str2 += " select distinct t.model_id, ";
                str2 += " STUFF((SELECT distinct ', ' + CONVERT(varchar, t1.tool_id) ";
                str2 += " from toolSub_list t1 ";
                str2 += " where t.model_id = t1.model_id ";
                str2 += " FOR XML PATH(''), TYPE ";
                str2 += " ).value('.', 'NVARCHAR(MAX)') ";
                str2 += " ,1,2,'') tool_list ";
                str2 += " from toolSub_list t where t.model_id = " + ddl_model.SelectedValue;
                datacon dc2 = new datacon();
                dc2.QryDT(conn, str2);
                string tool_idList = dc2.dt.Rows[0]["tool_list"].ToString();

                where += " AND TOOL_MASTER.tool_id in (" + tool_idList + ")";
            }

            if (ddl_location1.SelectedValue != "" && ddl_location2.SelectedValue == "0")
            {
                string str2 = "";
                str2 += " select distinct t.location1_id, ";
                str2 += " STUFF((SELECT distinct ', ' + CONVERT(varchar, t1.tool_id) ";
                str2 += " from toolSub_list t1 ";
                str2 += " where t.location1_id = t1.location1_id ";
                str2 += " FOR XML PATH(''), TYPE ";
                str2 += " ).value('.', 'NVARCHAR(MAX)') ";
                str2 += " ,1,2,'') tool_list ";
                str2 += " from toolSub_list t where t.location1_id = " + ddl_location1.SelectedValue;

                datacon dc2 = new datacon();
                dc2.QryDT(conn, str2);
                string tool_idList = dc2.dt.Rows[0]["tool_list"].ToString();

                where += " AND TOOL_MASTER.tool_id in (" + tool_idList + ")";
            }
            else if (ddl_location1.SelectedValue != "" && ddl_location2.SelectedValue != "0")
            {
                string str2 = "";
                str2 += " select distinct t.location1_id,t.location2_id, ";
                str2 += " STUFF((SELECT distinct ', ' + CONVERT(varchar, t1.tool_id) ";
                str2 += " from toolSub_list t1 ";
                str2 += " where t.location1_id = t1.location1_id and t.location2_id = t1.location2_id ";
                str2 += " FOR XML PATH(''), TYPE ";
                str2 += " ).value('.', 'NVARCHAR(MAX)') ";
                str2 += " ,1,2,'') tool_list ";
                str2 += " from toolSub_list t where t.location1_id = " + ddl_location1.SelectedValue + " and t.location2_id = " + ddl_location2.SelectedValue + " ";

                datacon dc2 = new datacon();
                dc2.QryDT(conn, str2);
                if (dc2.dt.Rows.Count > 0)
                {
                    string tool_idList = dc2.dt.Rows[0]["tool_list"].ToString();
                    where += " AND TOOL_MASTER.tool_id in (" + tool_idList + ")";
                }
                else
                {
                }
            }

            return where;
        }

        protected string GetStr()
        {
            string where = GetWhere();
            string str = "";

            str += " SELECT * FROM ( ";
            // ===== ข้อ 4.1 : เรียงตาม TOOL_ID (desc) =====
            // เดิม: ROW_NUMBER() OVER (ORDER BY PM_STATUS.add_date desc)
            // ใหม่: ORDER BY PM_STATUS.tool_id desc
            str += " select ROW_NUMBER() OVER (ORDER BY PM_STATUS.tool_id desc) AS MyRowNumber ";
            str += " , PM_STATUS.tool_id as TOOL_ID ";
            str += " ,'T' + right('000' + cast(PM_STATUS.tool_id AS varchar(5)), 5) AS TOOL_ID_NAME ";
            str += " , TOOL_MASTER.tool_no as TOOL_NO ";
            str += " , TOOL_MASTER.tool_nameEN as TOOL_NAME ";
            str += " , PM_STATUS.pm_statusID as PM_STATUSID ";
            str += " , PM_STATUS.PMCSH_status as PMCSH_STATUS ";
            str += " , CSH_STATUS_MAS.pmCSH_statusName as PMCSH_STATUS_NAME ";
            str += " , REPLACE(CONVERT(varchar,PM_STATUS.add_date ,106),' ','-')+' '+CONVERT(varchar,PM_STATUS.add_date ,108) AS ADD_DATE ";
            str += " , TOOL_MASTER.rank_id as RANK_ID ";
            str += " , PDE_GROUP.group_name as GROUP_NAME ";
            str += " , PDE_GROUP.group_id as GROUP_ID ";
            str += " , c.qty as QTY ,CHECKSHEET_REV.REV as CheckSheet_REV ";
            str += " , Period_c.period_name ,CATEGORY_MASTER.category as category ";
            str += " from jtPM_status PM_STATUS ";
            str += " left join tool_master TOOL_MASTER on PM_STATUS.tool_id = TOOL_MASTER.tool_id ";
            str += " left join ( select tool_id ,COUNT(tool_id) as qty from toolSub_list group by tool_id) c on PM_STATUS.tool_id = c.tool_id ";
            str += " left join cptsvs528.user_master.dbo.eng_group_master PDE_GROUP ON TOOL_MASTER.classification = PDE_GROUP.group_id AND PDE_GROUP.dept IN (3,5) ";
            str += " left join jtPMCSH_master_status CSH_STATUS_MAS on PM_STATUS.PMCSH_status = CSH_STATUS_MAS.pmCSH_statusID ";
            str += " left join( ";
            str += " select A.pmStatus_id, CONVERT(varchar, period_amount) +' ' + period_unit + '/ Time' as period_name from ";
            str += " (select MIN(period_id) as period_id, pmStatus_id from jtPM_CheckListTool_AB A group by pmStatus_id) A ";
            str += " left join jtPM_period_master B on A.period_id = B.period_id ";
            str += " ) Period_c on PM_STATUS.pm_statusID = Period_c.pmStatus_id ";
            str += " left join jt_category_master CATEGORY_MASTER on TOOL_MASTER.is_category = CATEGORY_MASTER.id";
            str += " left join ( select MAX(rev) as REV,tool_id from jtPM_docRev where doc_id = 1 group by tool_id) CHECKSHEET_REV on CHECKSHEET_REV.tool_id= PM_STATUS.tool_id";
            str += " where PM_STATUS.tool_id is not null " + where;
            str += " ) main where main.tool_id is not null ";
            // เรียงผลลัพธ์ชั้นนอกอีกครั้งให้ TOOL_ID มากสุดอยู่บน
            str += " order by main.TOOL_ID desc ";

            //test.Text = str;
            return str;
        }

        // ===================================================================
        // Bind ใหม่ : ดึงข้อมูลทั้งหมดเข้า GridView แล้วใช้ paging ในตัวของ GridView
        // (แทนระบบ paging แบบ MyRowNumber BETWEEN start AND end เดิม)
        // ===================================================================
        protected void Bind()
        {
            string str = GetStr();
            dc.QryDT(conn, str);
            int totalCount = dc.dt.Rows.Count;

            GridView1.DataSource = dc.dt;
            GridView1.DataBind();
            

            if (GridView1.Rows.Count > 0)
                GridView1.HeaderRow.TableSection = TableRowSection.TableHeader;

            // ===== ข้อ 3 : แสดง "Showing 1 to 20 of 6677 entries" =====
            SetRecordCount(totalCount);

            RegisterPostBackControl();
        }

        // ===== ข้อ 3 : คำนวณข้อความ Record Count =====
        private void SetRecordCount(int totalRecords)
        {
            //int pageSize = GridView1.PageSize;
            int pageSize = int.Parse(ddl_pageSize.SelectedValue);
            int currentPage = GridView1.PageIndex + 1;

            int startRecord = (totalRecords == 0) ? 0 : (pageSize * (currentPage - 1)) + 1;
            int endRecord = pageSize * currentPage;
            if (endRecord > totalRecords) endRecord = totalRecords;

            lblRecordCount.Text = "Showing " + startRecord.ToString() + " to " + endRecord.ToString() + " of " + totalRecords.ToString() + " entries";
            //lblRecordCount.Text = "totalRecords : " + totalRecords.ToString();
        }

        // ===== ข้อ 1 : เปลี่ยนจำนวนรายการต่อหน้า (10/20/50) =====
        protected void ddl_pageSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridView1.PageSize = int.Parse(ddl_pageSize.SelectedValue);
            GridView1.PageIndex = 0; // reset กลับหน้าแรก
            Bind();
        }

        // ===== ข้อ 2 : เปลี่ยนหน้า (pager ในตัวของ GridView) =====
        protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridView1.PageIndex = e.NewPageIndex;
            Bind();
        }

        private void Bind_ddlLoca2(string ddl_location1)
        {
            if (ddl_location1 != "")
            {
                string str2 = " select 0 as location2_id, '-' as location2_name,0 as count union select location2_id,location2_name,1 as count from master_location2 where location1_id = " + ddl_location1 + " order by count, location2_name ";
                dc.QryDT(conn, str2);
                ddl_location2.DataSource = dc.dt;
                ddl_location2.DataTextField = "location2_name";
                ddl_location2.DataValueField = "location2_id";
                ddl_location2.DataBind();
            }
        }

        protected void BTNS_search_Click(object sender, EventArgs e)
        {
            GridView1.PageIndex = 0; // ค้นหาใหม่ กลับหน้าแรก
            Bind();
        }

        protected void Btn_ViewDetail_Click(object sender, EventArgs e)
        {
            GridViewRow row = (sender as LinkButton).NamingContainer as GridViewRow;
            HiddenField hd_tool_id = (HiddenField)row.FindControl("hd_tool_id");
            string tool_id = hiddenVar_handern(hd_tool_id.Value);

            Get_URL URL_Get = new Get_URL();
            string str = OnlyPage();

            Session["oldUrl_master"] = str;

            ClientScript.RegisterStartupScript(this.GetType(), "OpenWindow", "window.open('jt_details2.aspx?tool_id=" + tool_id + "', '_blank');", true);
        }

        protected void Btn_ViewCheckSheet_Click(object sender, EventArgs e)
        {
            GridViewRow row = (sender as ImageButton).NamingContainer as GridViewRow;
            HiddenField hd_tool_id = (HiddenField)row.FindControl("hd_tool_id");
            string tool_id = hiddenVar_handern(hd_tool_id.Value);

            ClientScript.RegisterStartupScript(this.GetType(), "OpenWindow", "window.open('PM_checksheet_Deail.aspx?tool_id=" + tool_id + "', '_blank');", true);
        }

        protected void Btn_Edit_Click(object sender, EventArgs e)
        {
            GridViewRow row = (sender as LinkButton).NamingContainer as GridViewRow;
            HiddenField hd_tool_id = (HiddenField)row.FindControl("hd_tool_id");
            string tool_id = hiddenVar_handern(hd_tool_id.Value);
            toolno_modal.InnerText = "Tool No. : " + row.Cells[3].Text;
            HiddenField hd_pmStatusId = (HiddenField)row.FindControl("hd_pmStatusId");
            string pmStatusId = hiddenVar_handern(hd_pmStatusId.Value);

            HiddenField hd_PMCSH_STATUS = (HiddenField)row.FindControl("hd_PMCSH_STATUS");

            int status = Convert.ToInt16(hd_PMCSH_STATUS.Value);

            pm_csh.Attributes.Remove("class");
            if (status >= 0 && status <= 6)
            {
                pm_csh.Attributes.Add("class", "btn btn-primary btn_menu");
                pm_csh.HRef = "PM_CSH_Check2.aspx?tool_id=" + tool_id + "&emp_id=" + Session["emp_id"] + "&pmStatusId=" + pmStatusId + "&emp_id=" + Session["emp_id"].ToString();
            }
            else
            {
                pm_csh.Attributes.Add("class", "btn btn-primary btn_menu disabled");
            }

            set1PM.Attributes.Remove("class");
            if (status == 6)
            {
                set1PM.Attributes.Add("class", "btn btn-primary btn_menu");
                set1PM.HRef = "PM_settingFirst.aspx?tool_id=" + tool_id;
            }
            else
            {
                set1PM.Attributes.Add("class", "btn btn-primary btn_menu disabled");
            }

            doc_revise.Attributes.Remove("class");

            if (status != 1 || status != 0)
            {
                doc_revise.Attributes.Add("class", "btn btn-primary btn_menu");
                doc_revise.HRef = "PM_CSH_Check2.aspx?tool_id=" + tool_id + "&pmStatusId=" + pmStatusId + "&emp_id=" + Session["emp_id"].ToString();
            }
            else
            {
                doc_revise.Attributes.Add("class", "btn btn-primary btn_menu disabled");
            }

            editplan.Attributes.Remove("class");
            string emp_id = Session["emp_id"].ToString();
            string sql = " select * from cptsvs528.user_master.dbo.sys_user_master where emp_id = '" + emp_id + "' and position_id <> 8 ";
            dc.QryDT(conn, sql);

            if (dc.dt.Rows.Count > 0)
            {
                if (status >= 6)
                {
                    editplan.Attributes.Add("class", "btn btn-primary btn_menu");
                    editplan.HRef = "PM_settingFirst.aspx?tool_id=" + tool_id + "&edit=1";
                }
                else
                {
                    editplan.Attributes.Add("class", "btn btn-primary btn_menu disabled");
                }
            }
            else
            {
                editplan.Attributes.Add("class", "btn btn-primary btn_menu disabled");
            }

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#EditDoc').modal('show');");
            sb.Append(@"</script>");
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "closemodal", sb.ToString(), false);
            return;
        }

        protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            try
            {
                if (e.Row.RowType == DataControlRowType.DataRow)
                {
                    HiddenField hd_PMCSH_STATUS = (HiddenField)e.Row.FindControl("hd_PMCSH_STATUS");
                    string PMCSH_STATUS = hd_PMCSH_STATUS.Value;
                    LinkButton lb_pmStatus = (LinkButton)e.Row.FindControl("lb_pmStatus");
                    lb_pmStatus.CssClass = "btn status" + PMCSH_STATUS;
                    lb_pmStatus.Enabled = false;

                    // Spacial
                    LinkButton pic_check = (LinkButton)e.Row.FindControl("pic_check");
                    pic_check.Visible = false;

                    LinkButton pic_cross = (LinkButton)e.Row.FindControl("pic_cross");
                    pic_cross.Visible = false;

                    // Rank
                    Label lb_Rank = (Label)e.Row.FindControl("lb_Rank");
                    System.Web.UI.HtmlControls.HtmlTable tb_pmmanual = (System.Web.UI.HtmlControls.HtmlTable)e.Row.FindControl("tb_pmmanual");
                    LinkButton pic_crossManual = (LinkButton)e.Row.FindControl("pic_crossManual");
                    if (lb_Rank.Text == "C")
                    {
                        tb_pmmanual.Visible = false;
                    }
                    else
                    {
                        tb_pmmanual.Visible = true;
                        pic_crossManual.Visible = false;
                    }

                    HiddenField hd_tool_id = (HiddenField)e.Row.FindControl("hd_tool_id");
                    string tool_id = hiddenVar_handern(hd_tool_id.Value);
                    // pm manual
                    // doc_id = 19 -> PM Manual (Excel)
                    string doc_id = "19";
                    string str = " select rev from jt_docRev where tool_id = " + tool_id + " and doc_id = " + doc_id + " order by rev desc ";
                    dc.QryDT(conn, str);

                    ImageButton Img_Excel = (ImageButton)e.Row.FindControl("Img_Excel");
                    Label lb_rev_excel = (Label)e.Row.FindControl("lb_rev_excel");
                    if (dc.dt.Rows.Count > 0)
                    {
                        Img_Excel.Visible = true;
                        lb_rev_excel.Visible = true;
                        lb_rev_excel.Text = dc.dt.Rows[0]["rev"].ToString();
                    }
                    else
                    {
                        Img_Excel.Visible = false;
                        lb_rev_excel.Visible = false;
                    }

                    // doc_id = 25 -> PM Manual (PDF)
                    doc_id = "25";
                    str = " select rev from jt_docRev where tool_id = " + tool_id + " and doc_id = " + doc_id + " order by rev desc ";
                    dc.QryDT(conn, str);
                    ImageButton Img_PDF = (ImageButton)e.Row.FindControl("Img_PDF");
                    Label lb_rev_pdf = (Label)e.Row.FindControl("lb_rev_pdf");

                    if (dc.dt.Rows.Count > 0)
                    {
                        Img_PDF.Visible = true;
                        lb_rev_pdf.Visible = true;
                        lb_rev_pdf.Text = dc.dt.Rows[0]["rev"].ToString();
                    }
                    else
                    {
                        Img_PDF.Visible = false;
                        lb_rev_pdf.Visible = true;
                        lb_rev_pdf.Text = "Skip";
                        lb_rev_pdf.Attributes.Add("style", "color:red");
                    }

                    LinkButton pic_waitCSH = (LinkButton)e.Row.FindControl("pic_waitCSH");
                    LinkButton pic_crossCSH = (LinkButton)e.Row.FindControl("pic_crossCSH");

                    System.Web.UI.HtmlControls.HtmlTable tb_checkSheet = (System.Web.UI.HtmlControls.HtmlTable)e.Row.FindControl("tb_checkSheet");
                    if (PMCSH_STATUS.ToString() == "0" || PMCSH_STATUS.ToString() == "1")
                    {
                        tb_checkSheet.Visible = false;
                        pic_waitCSH.Visible = true;
                    }
                    else
                    {
                        tb_checkSheet.Visible = true;
                        pic_waitCSH.Visible = false;
                    }
                    pic_crossCSH.Visible = false;

                    //*Doc PM check sheet*
                    HiddenField hd_checkSheet_rev = (HiddenField)e.Row.FindControl("hd_checkSheet_rev");
                    Label lb_rev_checksheet = (Label)e.Row.FindControl("lb_rev_checksheet");
                    string str_rev = " select B.PMCSH_status, A.rev,A.tool_id from jtPM_docRev A left join jtPM_status B on a.tool_id = B.tool_id where A.doc_id = 1 and A.tool_id = " + tool_id + " order by A.rev desc";
                    dc.QryDT(conn, str_rev);
                    DataTable tb_rev = dc.dt;

                    if (tb_rev.Rows.Count > 0)
                    {
                        if (PMCSH_STATUS.ToString() == "6" || PMCSH_STATUS.ToString() == "7")
                        {
                            lb_rev_checksheet.Text = tb_rev.Rows[0]["rev"].ToString(); //show rev ใหม่
                        }
                        else
                        {
                            lb_rev_checksheet.Text = tb_rev.Rows[1]["rev"].ToString(); //show rev ก่อนหน้า
                        }
                    }

                    LinkButton Btn_Edit = (LinkButton)e.Row.FindControl("Btn_Edit");
                    if (Session["user_group"] != null)
                    {
                        if (Session["user_group"].ToString() == "99")
                        {
                            Btn_Edit.Enabled = false;
                            Btn_Edit.CssClass = "btn btn-default btn-border disabled";
                        }
                    }
                    else
                    {
                        Btn_Edit.Enabled = false;
                        Btn_Edit.CssClass = "btn btn-default btn-border disabled";
                    }
                }
            }
            catch (Exception ex)
            {
                // test.Text = ex.Message;
                // test.Attributes.Add("style", "color:red");
            }
        }

        protected string hiddenVar_handern(string var)
        {
            string[] var2 = var.Split(',');
            return var2[0];
        }

        protected void Img_Excel_Click(object sender, ImageClickEventArgs e)
        {
            GridViewRow row = (sender as ImageButton).NamingContainer as GridViewRow;
            HiddenField hd_tool_id = (HiddenField)row.FindControl("hd_tool_id");
            string tool_id = hiddenVar_handern(hd_tool_id.Value);
            // doc_id = 19 -> PM Manual (Excel)
            string doc_id = "19";
            Label lb_rev_excel = (Label)row.FindControl("lb_rev_excel");
            DownloadPM_Manula(tool_id, doc_id, lb_rev_excel.Text);
        }

        protected void Img_PDF_Click(object sender, ImageClickEventArgs e)
        {
            GridViewRow row = (sender as ImageButton).NamingContainer as GridViewRow;
            HiddenField hd_tool_id = (HiddenField)row.FindControl("hd_tool_id");
            string tool_id = hiddenVar_handern(hd_tool_id.Value);
            // doc_id = 25 -> PM Manual (PDF)
            string doc_id = "25";
            Label lb_rev_pdf = (Label)row.FindControl("lb_rev_pdf");
            string rev = lb_rev_pdf.Text;

            // สร้าง URL ไปยังเพจในแอปเดียวกัน
            string url = ResolveUrl(
                "~/PdfViewer.aspx?tool_id=" + Server.UrlEncode(tool_id) +
                "&doc_id=" + Server.UrlEncode(doc_id) +
                "&rev=" + Server.UrlEncode(rev)
            );

            // เปิดในแท็บใหม่
            string script = "window.open('" + url + "', '_blank');";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "openPdfInline", script, true);
        }

        public partial class PdfViewer : System.Web.UI.Page
        {
            protected void Page_Load(object sender, EventArgs e)
            {
                string tool_id = Request.QueryString["tool_id"];
                string doc_id = Request.QueryString["doc_id"];
                string rev = Request.QueryString["rev"];

                if (string.IsNullOrEmpty(tool_id) || string.IsNullOrEmpty(doc_id) || string.IsNullOrEmpty(rev))
                {
                    Response.StatusCode = 400;
                    Response.Write("Bad request.");
                    Response.End();
                    return;
                }

                // --- ใช้คลาสเดิมของคุณเพื่อหาพาธไฟล์ ---
                JT_Get_Folder_Structure Folder_Structure = new JT_Get_Folder_Structure(tool_id);
                string filePath = Folder_Structure.Get_ToolDoc_fullPath(Convert.ToInt32(doc_id), rev, "");

                if (string.IsNullOrEmpty(filePath) || !System.IO.File.Exists(filePath))
                {
                    Response.StatusCode = 404;
                    Response.Write("PDF not found.");
                    Response.End();
                    return;
                }

                FileInfo fi = new FileInfo(filePath);

                // --- เขียนออกแบบ inline ---
                Response.Clear();
                Response.ClearContent();
                Response.ClearHeaders();

                Response.ContentType = "application/pdf";
                Response.AddHeader("Content-Disposition", "inline; filename=\"" + fi.Name + "\"");
                Response.AddHeader("Content-Length", fi.Length.ToString());

                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.Cache.SetNoStore();

                Response.TransmitFile(fi.FullName);
                Response.Flush();
                Response.End();
            }
        }

        protected void DownloadPM_Manula(string tool_id, string doc_id, string rev)
        {
            JT_Get_Folder_Structure Folder_Structure = new JT_Get_Folder_Structure(tool_id);
            string fileName = Folder_Structure.Get_ToolDoc_fullPath(Convert.ToInt32(doc_id), rev, "");

            FileInfo file_Info = new FileInfo(fileName);

            WebClient req = new WebClient();
            HttpResponse response = HttpContext.Current.Response;
            response.Clear();
            response.ClearContent();
            response.ClearHeaders();
            response.Buffer = true;
            response.AddHeader("Content-Disposition", "attachment;filename=\"" + file_Info.Name + " ");
            byte[] data = req.DownloadData(fileName);
            response.BinaryWrite(data);
            response.End();
        }

        protected void Img_checksheet_Click(object sender, ImageClickEventArgs e)
        {
            GridViewRow row = (sender as ImageButton).NamingContainer as GridViewRow;
            HiddenField hd_tool_id = (HiddenField)row.FindControl("hd_tool_id");
            string tool_id = hiddenVar_handern(hd_tool_id.Value);

            JT_Get_Folder_Structure Folder_Structure = new JT_Get_Folder_Structure(tool_id);
            string PMCSH_Folder = Folder_Structure.Get_PMCheckSheet_FolderPath();

            Label lb_rev_checksheet = (Label)row.FindControl("lb_rev_checksheet");

            string PMCSH_FILE = PMCSH_Folder + @"\" + GetFileName(tool_id, lb_rev_checksheet.Text);

            FileInfo file_Info = new FileInfo(PMCSH_FILE);

            WebClient req = new WebClient();
            HttpResponse response = HttpContext.Current.Response;
            response.Clear();
            response.ClearContent();
            response.ClearHeaders();
            response.Buffer = true;
            response.AddHeader("Content-Disposition", "attachment;filename=\"" + file_Info.Name + " ");
            byte[] data = req.DownloadData(PMCSH_FILE);
            response.BinaryWrite(data);
            response.End();
        }

        private string GetFileName(string tool_id, string Rev)
        {
            Get_Folder_Structure_JT Folder_Struture = new Get_Folder_Structure_JT(tool_id);
            string File_name = Folder_Struture.TOOL_NO + "_PM Check Sheet_Rev" + Rev + ".xlsx";
            return File_name;
        }

        public string OnlyPage()
        {
            Get_URL URL_Get = new Get_URL();
            return URL_Get.AbsolutePath().Replace(URL_Get.ApplicationPath(), "").Replace("/", "");
        }

        protected void ddl_location1_SelectedIndexChanged(object sender, EventArgs e)
        {
            Bind_ddlLoca2(ddl_location1.SelectedValue);
        }
    }
}
