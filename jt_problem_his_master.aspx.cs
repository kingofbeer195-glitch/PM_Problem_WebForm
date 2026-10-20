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

            //ShowDebugSession();

            if (!IsPostBack)
            {
                ViewState["Total_row"] = 0;
                bind_row();
            }

            if (gv1.Rows.Count > 0)
                gv1.HeaderRow.TableSection = TableRowSection.TableHeader;

            RegisterPostBackControl();
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
        protected void bind_row()
        {
            if (Request.QueryString["tool_id"] != null)
            {
                //  Bind_data(1);  
                Set_totalRow(1);
            }
            else
            {
                //Bind_data(0);
                Set_totalRow(0);

            }
            ViewState["showItem"] = 20;
            ViewState["currentPage"] = 1;
            ViewState["Total_Page"] = 0;
            ViewState["status"] = "";
            Innit_control_page(Convert.ToDouble(ViewState["Total_row"]));
            Bind_data(0, 20);
            li_first.Attributes.Add("class", "disabled");
            li_back.Attributes.Add("class", "disabled");

        }
        private void RegisterPostBackControl()
        {
            ScriptManager.GetCurrent(this).RegisterPostBackControl(ddl_year);
            //ScriptManager.GetCurrent(this).RegisterPostBackControl(ddl_month);
            ScriptManager.GetCurrent(this).RegisterPostBackControl(ddl_shift);
            ScriptManager.GetCurrent(this).RegisterPostBackControl(ddl_type);
            ScriptManager.GetCurrent(this).RegisterPostBackControl(ddl_symbol);
            ScriptManager.GetCurrent(this).RegisterPostBackControl(ddl_priority);
            ScriptManager.GetCurrent(this).RegisterPostBackControl(ddl_status);
            ScriptManager.GetCurrent(this).RegisterPostBackControl(ddl_action);
            ScriptManager.GetCurrent(this).RegisterPostBackControl(ddl_model);
            ScriptManager.GetCurrent(this).RegisterPostBackControl(ddl_resp);
            ScriptManager.GetCurrent(this).RegisterPostBackControl(ddl_resp_name);
            ScriptManager.GetCurrent(this).RegisterPostBackControl(ddl_tool_owner); 
            ScriptManager.GetCurrent(this).RegisterPostBackControl(ddl_risk);
            ScriptManager.GetCurrent(this).RegisterPostBackControl(ddl_touch);
            ScriptManager.GetCurrent(this).RegisterPostBackControl(ddl_part_equi);
            ScriptManager.GetCurrent(this).RegisterPostBackControl(ddl_Pro_type1);
            ScriptManager.GetCurrent(this).RegisterPostBackControl(ddl_Pro_type2);
            ScriptManager.GetCurrent(this).RegisterPostBackControl(ddl_Pro_type3);
            //ScriptManager.GetCurrent(this).RegisterPostBackControl(ddl_Issue);
            
            
        }

        protected void btn_search_Click(object sender, EventArgs e)
        {
 
            ViewState["showItem"] = 20;
            ViewState["Total_row"] = 0;
            ViewState["currentPage"] = 1;
            ViewState["Total_Page"] = 0;
            ViewState["status"] = "";
            bind_row();
            //Set_totalRow(0);
            Innit_control_page(Convert.ToDouble(ViewState["Total_row"]));
            Bind_data(0, 20);
            li_first.Attributes.Add("class", "disabled");
            li_back.Attributes.Add("class", "disabled");
            li_next.Attributes.Remove("class");
            li_last.Attributes.Remove("class");

        }
        protected string Search_fuction()
        {
            string search = "";

            string status = Request.QueryString["status"];
            string month_id = Request.QueryString["month"];
            string group = Request.QueryString["group"];

          
            if (txt_problem.Text.Trim() != "")
            {
                search += " and A.PM_problem_name Like N'%" + txt_problem.Text.Trim() + "%'";
            }
            if (month_id != null)
            {
                search += " and MONTH(A.check_date) = '" + month_id + "' ";
            }
            if (txt_problem1.Text != "" && txt_problem2.Text != "")
            {
                search += " and CONVERT(datetime, A.check_date,106) between  '" + txt_problem1.Text + "' and '" + txt_problem2.Text + "' ";
            }
            if (ddl_year.SelectedValue != "")
            {
                search += " and year(A.check_date) = '" + ddl_year.SelectedValue + "'  ";
            }
          
            if (txt_follow_up.Text != "" || txt_follow_up2.Text != "")
            {
                search += " and A.Follow_up  between  '" + txt_follow_up.Text + "' and '"+ txt_follow_up2.Text + "' ";
            }

          

            if (txt_tss_main1.Text != "" || txt_tss_main2.Text != "")
            {
                search += " and A.TSS_Main between  '"+txt_tss_main1.Text.Trim()+"' and '"+txt_tss_main2.Text.Trim()+"' ";
            }

            if (txt_tss_sub1.Text != "" || txt_tss_sub2.Text != "")
            {
                search += " and A.TSS_sub between  '"+txt_tss_sub1.Text.Trim()+"' and '"+txt_tss_sub2.Text.Trim()+"' ";
            }

            if(ddl_shift.SelectedValue != "")
            {
                search += " and A.shift = " + ddl_shift.SelectedValue + "";
            }


            if (ddl_type.SelectedValue != "")
            {
                search += " and A.typeProblem = '" + ddl_type.SelectedValue + "'";
            }

            if(ddl_symbol.SelectedValue != "")
            {
                search += " and A.pro_type1 = '" + ddl_symbol.SelectedValue + "' "; ;
                //search += " and A.symbol = " + ddl_symbol.SelectedValue + "";
            }

            if (ddl_priority.SelectedValue != "")
            {
                search += " and A.priority = '" + ddl_priority.SelectedValue + "'";
            }

            if (status != null)
            {
                //  ddl_type.SelectedValue = type;
                switch (status)
                {
                    case "3":
                        search += " and A.isOnplan in(3,4,5,6) ";
                        break;
                    default:
                        search += " and A.isOnplan = '" + status + "'";
                        break;
                }
            }
           
            if (ddl_status.SelectedValue != "")
            {
                search += " and A.isOnplan = " + ddl_status.SelectedValue + "";
            }
            if (ddl_action.SelectedValue != "")
            {
                search += " and A.action_id = " + ddl_action.SelectedValue + "";
            }

            if (txt_follow_up.Text.Trim() != "")
            {
                search += " and A.Follow_up = '" + txt_follow_up.Text.Trim() + "'";
            }

            if(txt_tool_no.Text.Trim() != "")
            {
                search += " and A.tool_no Like N'%" + txt_tool_no.Text.Trim() + "%'";
            }
            if(txt_no_of_tool.Text.Trim() != "")
            {
                search += " and A.toolSub_Name Like N'%" + txt_no_of_tool.Text.Trim() + "%'";
            }

            if(ddl_model.SelectedValue != "")
            {
                search += " and A.model_id = " + ddl_model.SelectedValue + "";
            }
            if (group != null)
            {
                search += " and A.rep_group = '" + group + "'";
            }
            if (ddl_resp.SelectedValue != "")
            {
                search += " and A.rep_group = '" + ddl_resp.SelectedItem + "'";
            }

            if(ddl_resp_name.SelectedValue!= "")
            {
                search += " and A.emp_id = '" + ddl_resp_name.SelectedValue + "'";
            }
            if(ddl_tool_owner.SelectedValue != "")
            {
                search += " and A.owner_group = '" + ddl_tool_owner.SelectedItem + "'";
            }
            if (ddl_Pro_type1.SelectedValue != "")
            {
                search += " and A.pro_type1 = '" + ddl_Pro_type1.SelectedValue +"' "; ;
            }
            if (ddl_Pro_type2.SelectedValue != "")
            {
                search += " and A.pro_type2 = '" + ddl_Pro_type2.SelectedValue + "' "; ;
            }
            if (ddl_Pro_type3.SelectedValue != "")
            {
                search += " and A.pro_type3 = '" + ddl_Pro_type3.SelectedValue + "' "; ;
            }
            if (ddl_part_equi.SelectedValue != "")
            {
                search += " and A.part_equi = '"+ ddl_part_equi .SelectedValue+ "' ";
            }
            if (ddl_touch.SelectedValue != "")
            {
                search += " and A.touch_status = '"+ ddl_touch.SelectedValue.Trim()+ "' ";
            }
            if (ddl_risk.SelectedValue != "")
            {
                search += " and A.risk_status = '"+ ddl_risk .SelectedValue.Trim()+ "' ";
            }
            if (ddl_Issue.SelectedValue != "")
            {
                search += " and A.check_by  = '" + ddl_Issue.SelectedValue.Trim()+ "' ";
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
            if (tool_id != null && tool_id != "")
                where += " and A.tool_id = " + tool_id;
            if (toolSub_id != null && toolSub_id != "")
                where += " and A.toolSub_id = " + toolSub_id;
            return where;
        }
      
        protected void Innit_control_page(double totalRow)
        {
            double result = Math.Ceiling(totalRow / Convert.ToInt32(ViewState["showItem"]));
            int Page = Convert.ToInt32(result);
            ViewState["Total_Page"] = Page;

            switch (Page)
            {
                case 0:
                case 1:
                    li_first.Attributes.Add("class", "disabled");
                    li_back.Attributes.Add("class", "disabled");
                    li_next.Attributes.Add("class", "disabled");
                    li_last.Attributes.Add("class", "disabled");
                    break;
                default:
                    li_first.Attributes.Remove("class");
                    li_back.Attributes.Remove("class");
                    li_next.Attributes.Remove("class");
                    li_last.Attributes.Remove("class");
                    break;
            }
        }
        protected void Bind_data(int start, int end)
        {
            int isFixFil = 0;
            if (Request.QueryString["tool_id"] != null)
            {
                isFixFil = 1;
            }
            string str = Bind(isFixFil);
            str += "  AND MyRowNumber BETWEEN " + start + " AND " + end;
           // test.Text = str ;
            dc.QryDT(conn, str);
            gv1.DataSource = dc.dt;
            gv1.DataBind();

            if (gv1.Rows.Count > 0)
                gv1.HeaderRow.TableSection = TableRowSection.TableHeader;

        }
        protected string Bind(int isFixFil)
        {
            string search = Search_fuction();
            string where = (isFixFil == 1 ? Get_where_fix() : Get_where());
            string str = "";
            str += "  SELECT * FROM (select ROW_NUMBER() OVER (ORDER BY PM_problem_id  desc) AS MyRowNumber, *  ";
            str += "  from PM_Tool_History A where A.PM_problem_id is not null "+ where + search+" )  ";
            str += "  main where PM_problem_id is not null  "; //and isOnplan != 2
            return str;
        }
        protected void Set_totalRow(int isFixFil)
        {
            string str = "";
            string search = Search_fuction();
            string where = (isFixFil == 1 ? Get_where_fix() : Get_where());
            str += " select A.PM_problem_id  ";
            str += " from PM_Tool_History A where A.PM_problem_id is not null " + where+ search;
            str += " order by A.PM_problem_id desc ";
            
            dc.QryDT(conn, str);

            if (dc.dt.Rows.Count > 0)
                ViewState["Total_row"] = dc.dt.Rows.Count;
           // test.Text = ViewState["Total_row"].ToString()+ "</br>";

        }
        protected void first_Click(object sender, EventArgs e)
        {
            try
            {
                int showItem = (int)ViewState["showItem"];
                int currentPage = (int)ViewState["currentPage"];

                if (currentPage == 1)
                    return;
                li_first.Attributes.Add("class", "disabled");
                li_back.Attributes.Add("class", "disabled");
                li_next.Attributes.Remove("class");
                li_last.Attributes.Remove("class");
                Bind_data(0, showItem);
                ViewState["currentPage"] = 1;
            }
            catch (Exception ex)
            {
                test.Text = ex.Message;
            }
        }
        protected void back_Click(object sender, EventArgs e)
        {
            try
            {
                int showItem = (int)ViewState["showItem"];
                int currentPage = (int)ViewState["currentPage"];
                int backPage = currentPage - 1;
                int start = ((showItem * backPage) - showItem) + 1;
                int end = (showItem * backPage);

                if (currentPage < 2)
                {
                    return;
                }
                else if (currentPage == 2)
                {
                    li_first.Attributes.Add("class", "disabled");
                    li_back.Attributes.Add("class", "disabled");
                }
                else
                {
                    li_first.Attributes.Remove("class");
                    li_back.Attributes.Remove("class");
                    li_next.Attributes.Remove("class");
                    li_last.Attributes.Remove("class");
                }
                Bind_data(start, end);
                ViewState["currentPage"] = backPage;

            }
            catch (Exception ex)
            {
                test.Text = ex.Message;
            }
        }
        protected void next_Click(object sender, EventArgs e)
        {
            try
            {
                int showItem = (int)ViewState["showItem"];
                int currentPage = (int)ViewState["currentPage"];
                int nextPage = currentPage + 1;
                int start = (showItem * currentPage) + 1;
                int end = (showItem * nextPage);

                int Total_Page = (int)ViewState["Total_Page"];

                if (currentPage > (Total_Page - 1))
                {
                    return;
                }
                else if (currentPage == (Total_Page - 1))
                {

                    li_next.Attributes.Add("class", "disabled");
                    li_last.Attributes.Add("class", "disabled");
                }
                else
                {

                    li_first.Attributes.Remove("class");
                    li_back.Attributes.Remove("class");
                    li_next.Attributes.Remove("class");
                    li_last.Attributes.Remove("class");
                }

                Bind_data(start, end);
                ViewState["currentPage"] = nextPage;

            }
            catch (Exception ex)
            {
                test.Text = ex.Message;
            }
        }
        protected void last_Click(object sender, EventArgs e)
        {
            try
            {
                int showItem = (int)ViewState["showItem"];
                int currentPage = (int)ViewState["currentPage"];
                int Total_Page = (int)ViewState["Total_Page"];

                if (currentPage == Total_Page)
                    return;

                int lastPage = Total_Page;
                int beforeLastPage = lastPage - 1;

                int start = (showItem * beforeLastPage) + 1;
                int end = (showItem * lastPage);


                li_first.Attributes.Remove("class");
                li_back.Attributes.Remove("class");
                li_next.Attributes.Add("class", "disabled");
                li_last.Attributes.Add("class", "disabled");

                Bind_data(start, end);
                ViewState["currentPage"] = lastPage;

            }
            catch (Exception ex)
            {
                test.Text = ex.Message;
            }
        }

        protected void btn_detail_problem_Click(object sender, EventArgs e)
        {
            int yaer = Int32.Parse(ddl_year.SelectedValue.ToString());
            try
            {
                GridViewRow row = (sender as LinkButton).NamingContainer as GridViewRow;
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
        protected void gv1_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Label symbol = e.Row.FindControl("lb_symbol") as Label;
                if (symbol.Text == "")
                {
                    symbol.Visible = false;
                }

                Label lb_priority = e.Row.FindControl("lb_priority") as Label;
                switch (lb_priority.Text)
                {
                    case "A": lb_priority.CssClass = " btn prio_A"; break;
                    case "B": lb_priority.CssClass = " btn prio_B"; break;
                    case "C": lb_priority.CssClass = "btn prio_C"; break;
                    default: break;
                }

                Label lb_proType2 = e.Row.FindControl("lb_proType2") as Label;
                if (lb_proType2.Text != "")
                {
                    lb_proType2.CssClass = "btn status3";
                }

                Label lb_proType3 = e.Row.FindControl("lb_proType3") as Label;
                if (lb_proType3.Text != "")
                {
                    lb_proType3.CssClass = "btn status3";
                }

                Label lb_proType4 = e.Row.FindControl("lb_proType4") as Label;
                if (lb_proType4.Text != "")
                {
                    lb_proType4.CssClass = "btn status3";

                }

            
                HiddenField hd_action = e.Row.FindControl("hd_action") as HiddenField;
                if (hd_action.Value != "")
                    e.Row.Cells[7].CssClass = "action_" + hd_action.Value;


                HiddenField hd_symbol = e.Row.FindControl("hd_symbol") as HiddenField;
                Label lb_symbol = e.Row.FindControl("lb_symbol") as Label;
                if (hd_symbol.Value != "")
                    lb_symbol.CssClass = " btn disabled symbol_" + hd_symbol.Value;

                
                //HiddenField hd_proType1 = e.Row.FindControl("hd_proType1") as HiddenField;
                //Label lb_proType1 = e.Row.FindControl("lb_proType1") as Label;
                //if (hd_proType1.Value != "")
                //    lb_proType1.CssClass = " btn disabled symbol_" + hd_proType1.Value;


                HiddenField hd_status = e.Row.FindControl("hd_status") as HiddenField;
                Label lb_status = e.Row.FindControl("lb_status") as Label;
                switch (hd_status.Value)
                {
                    case "0": lb_status.Text = "Acknowledge"; e.Row.Cells[6].CssClass = "status"; break;
                    case "1": lb_status.Text = "On plan"; e.Row.Cells[6].CssClass = "status"; break;
                    case "2": lb_status.Text = "Delay"; e.Row.Cells[6].CssClass = "status3"; break;
                    case "3": lb_status.Text = "Send for check"; e.Row.Cells[6].CssClass = "status"; break;
                    case "4": lb_status.Text = "Tool Owner[J3] Check"; e.Row.Cells[6].CssClass = "status"; break;
                    case "5": lb_status.Text = "ENG4[J3] check"; e.Row.Cells[6].CssClass = "status"; break;
                    case "6": lb_status.Text = "ENG4[Mgr] Approve"; e.Row.Cells[6].CssClass = "status"; break;
                    case "7": lb_status.Text = "Close"; e.Row.Cells[6].CssClass = "status2"; break;
                    case "8": lb_status.Text = "Cancel"; e.Row.Cells[6].CssClass = "status2"; break;
                    case "9": lb_status.Text = "New Problem"; e.Row.Cells[6].CssClass = "status"; break;
                    default: break;
                }

                Label lb_shift = e.Row.FindControl("lb_shift") as Label;
                switch (lb_shift.Text)
                {
                    case "1": lb_shift.Text = "Day"; break;
                    case "2": lb_shift.Text = "Night"; break;
                    default: break;

                }
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

        protected void ddl_resp_SelectedIndexChanged(object sender, EventArgs e)
        {
            bind_row();

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

        protected void txt_problem_TextChanged(object sender, EventArgs e)
        {
            
            bind_row();
           
        }

        protected void ddl_year_SelectedIndexChanged(object sender, EventArgs e)
        {
            
            bind_row();
           
        }

        protected void ddl_month_SelectedIndexChanged(object sender, EventArgs e)
        {
           
            bind_row();
           

        }

        protected void txt_Date_TextChanged(object sender, EventArgs e)
        {
           
            bind_row();
            //Set_totalRow(0);
           
        }

        protected void ddl_shift_SelectedIndexChanged(object sender, EventArgs e)
        {
           
            bind_row();
            //Set_totalRow(0);
           
        }

        protected void ddl_type_SelectedIndexChanged(object sender, EventArgs e)
        {
            //Set_totalRow(0);
              bind_row();
        }

        protected void ddl_symbol_SelectedIndexChanged(object sender, EventArgs e)
        {
           
            bind_row();
            //Set_totalRow(0);
           
        }

        protected void ddl_priority_SelectedIndexChanged(object sender, EventArgs e)
        {
           
            bind_row();
            //Set_totalRow(0);

        }

        protected void ddl_status_SelectedIndexChanged(object sender, EventArgs e)
        {
           
            bind_row();
            //Set_totalRow(0);
          

        }

        protected void ddl_action_SelectedIndexChanged(object sender, EventArgs e)
        {
           
            bind_row();
            //Set_totalRow(0);
          
        }

        protected void txt_follow_up_TextChanged(object sender, EventArgs e)
        {
          
            bind_row();
            //Set_totalRow(0);
        
        }

        protected void txt_tool_no_TextChanged(object sender, EventArgs e)
        {
         
            bind_row();
           
        }

        protected void txt_no_of_tool_TextChanged(object sender, EventArgs e)
        {
          
            bind_row();
           
        }

        protected void ddl_model_SelectedIndexChanged(object sender, EventArgs e)
        {
          
            bind_row();
            //Set_totalRow(0);
          
        }

        protected void ddl_resp_name_SelectedIndexChanged(object sender, EventArgs e)
        {
          
            bind_row();
            //Set_totalRow(0);
           
        }

        protected void ddl_tool_owner_SelectedIndexChanged(object sender, EventArgs e)
        {
           
            bind_row();
            //Set_totalRow(0);
           
        }


        protected void txt_tss_sub_TextChanged(object sender, EventArgs e)
        {
           
            bind_row();
            //Set_totalRow(0);
           
        }

        protected void txt_tss_main_TextChanged(object sender, EventArgs e)
        {
           
            //Set_totalRow(0);
            bind_row();
       

        }


        protected void ddl_Pro_type1_SelectedIndexChanged(object sender, EventArgs e)
        {
           
            bind_row();
         
        }

        protected void ddl_Pro_type2_SelectedIndexChanged(object sender, EventArgs e)
        {
            
            //Set_totalRow(0);
            bind_row();
       
        }

        protected void ddl_Pro_type3_SelectedIndexChanged(object sender, EventArgs e)
        {
           
            bind_row();
       
        }

        protected void ddl_part_equi_SelectedIndexChanged(object sender, EventArgs e)
        {
         
            bind_row();
            //Set_totalRow(0);
          

        }

        protected void ddl_touch_SelectedIndexChanged(object sender, EventArgs e)
        {
          
            bind_row();
            //Set_totalRow(0);
        
        }

        protected void ddl_risk_SelectedIndexChanged(object sender, EventArgs e)
        {
          
            bind_row();
            //Set_totalRow(0);
           
        }

        protected void ddl_Issue_SelectedIndexChanged(object sender, EventArgs e)
        {
           
            bind_row();
            //Set_totalRow(0);
            Innit_control_page(Convert.ToDouble(ViewState["Total_row"]));
            Bind_data(0, 20);
            //li_first.Attributes.Add("class", "disabled");
            //li_back.Attributes.Add("class", "disabled");
        }
    }
}
