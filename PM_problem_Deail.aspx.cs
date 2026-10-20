using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Spire.Xls;
using System.Drawing;
using System.IO;
using System.Net;
using System.Net.Mail;
using ClosedXML.Excel;
using System.Threading;



namespace jig_tool
{
    public partial class PM_problem_Deail : System.Web.UI.Page
    {
        SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["Sql"].ConnectionString);
        datacon dc = new datacon();

        System.Text.StringBuilder sb = new System.Text.StringBuilder();

        #region USER MANAGE
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
            Session["dept"] = getUser.USER_DEPT;
           
        }
        protected void Check_user()
        {
            if (Session["emp_id"] == null)
            {
                if (Request.QueryString["emp_id"] != null)
                {
                    string emp_id = Request.QueryString["emp_id"].ToString();
                   // Assign_Session(emp_id);
                }
                else
                {                                      
                    Response.Redirect("Default.aspx");
                }
            }
        }
        #endregion
        private Boolean Is_TestSystem()
        {
            string application_name = HttpContext.Current.Request.ApplicationPath;
            if (application_name.ToUpper().Contains("TEST"))
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        public void Page_Init(object sender, EventArgs e)
        {
           
            if (Session["emp_id"] == null)
            {
                Check_user();// CallForLogin();//  Response.Redirect("Default.aspx");
                return; 
            }

        }
       
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Bind_data();
                    
                Check_admin(Session["admin"].ToString());
               
            }
           
            //Bind_picture();

            this.RegisterPostBackControl();

        }
        protected void AssignLink()
        {
            string tool_id = GetTool_id(1);
            Session["oldUrl_master"] = null;
           // ToolDetail_link.HRef = "jt_details2.aspx?tool_id=" + tool_id;

            string toolSub_id = GetTool_id(2);
         //   PeriodCheck_link.HRef = "jt_his_master.aspx?tool_id=" + tool_id + "&toolSub_id=" + toolSub_id + "";
        } private void RegisterPostBackControl()
        {
            //ScriptManager.GetCurrent(this).RegisterPostBackControl(ddl_resp_group_update);
            //foreach (GridViewRow row in gv_problemDetail.Rows)
            //{
            //    LinkButton edit_save = row.FindControl("edit_save") as LinkButton;
            //    ScriptManager.GetCurrent(this).RegisterPostBackControl(edit_save);
            //}

        }
        protected void Check_admin(string admin)
        {
          
        }

        // ******* Bind Data Problem *******//
        protected void Bind_data()
        {
            string pm_problem_name = Request.QueryString["pm_problem_name"].ToString();

            string tool_id = GetTool_id(1);
            ToolMater_GetData ToolMaster = new ToolMater_GetData(tool_id);
           
            if (ToolMaster.IsHaveData)
            {
                string Tool_id = ToolMaster.TOOL_ID;
               // hd_toolID.Value = Tool_id;
                string Tool_no = ToolMaster.TOOL_NO;
                lb_toolno.Text = Tool_no;

                string Tool_Name = ToolMaster.TOOL_NAMEEN;
                lb_toolname.Text = Tool_Name;

                string Tool_Rank = ToolMaster.RANK_ID;
                lb_ranktool.Text = Tool_Rank;

               

                //ToolSub_Controller TM_S = new ToolSub_Controller();
                //ToolSub_Model TMS_MODEL = TM_S.Get_ToolSub(tool_id, Tool_Sub, true);


               


                PMProblem_GetDate PM_Problem_DB = new PMProblem_GetDate(pm_problem_name, Tool_Rank);

                string Tool_Sub = PM_Problem_DB.toolSub_id;
                lb_toolsubid.Text = "No." + Tool_Sub;

                string tool_model = PM_Problem_DB.model_name;
                lb_model.Text = tool_model;

                string tool_location = PM_Problem_DB.location;
                lb_location.Text = tool_location;

                if (PM_Problem_DB.IsHaveData)
                {
                    string tool_fix = PM_Problem_DB.FixAcces;
                    lb_fixasset.Text = tool_fix;

                    string prob_topic = PM_Problem_DB.prob_topic;
                    if (prob_topic == "")
                    {
                        string CheckListC1_name = PM_Problem_DB.CheckListC1_name;
                        string CheckListC2_name = PM_Problem_DB.CheckListC2_name;
                        string probTopic = CheckListC1_name + (CheckListC2_name == "" ? "" : " : " + CheckListC2_name);
                        lb_problem.Text = probTopic;
                    }
                    else
                    {
                        lb_problem.Text = PM_Problem_DB.prob_topic;
                       
                    }
                    
                    string plan_finish = PM_Problem_DB.plan_finish;
                    lb_Planfinish.Text = plan_finish;

                    string issue_pic = PM_Problem_DB.check_name;
                    lb_issueby.Text = issue_pic;

                    string check_date = PM_Problem_DB.check_date;
                    lb_problemdate.Text = check_date;

                    string action = PM_Problem_DB.action;
                    if(action != "")
                    lb_action.Text = GET_ACTION(action);

                    string pmProblem = PM_Problem_DB.PM_problem_name;
                    lb_problemno.Text = pmProblem;
                    
                    ViewState["pmProblem"] = pmProblem;

                    string priority = PM_Problem_DB.priority;
                    lb_problemrank.Text = priority;
               
                    string actual_finish = PM_Problem_DB.actual_finish;
                    lb_finishdate.Text = actual_finish;
                   
                    string spec = PM_Problem_DB.spec_checkList;
                    lb_spec.Text = spec;

                    string actual_spec = PM_Problem_DB.actual_spec_checkList;
                    lb_actual.Text = actual_spec;
     
                    string prob_detail = PM_Problem_DB.prob_detail;
                    lb_problemdetail.Text = prob_detail;

                    string result_spec = PM_Problem_DB.result_spec_checkList;
                    lb_result_spec.Text = result_spec;

                    string result_prob_detail = PM_Problem_DB.result_prob_detail;
                    lb_result_detail.Text = result_prob_detail;

                    string pic = PM_Problem_DB.pic;
                   
                    //GET User Appove
                    Get_user_info pic_info = new Get_user_info();
                    DataTable User = GET_USER(pmProblem);

                    //Person
                    if (pic != "")
                    {
                        string pic_issue = pic_info.Get_NameTH_format(pic, "", false);
                        
                        lb_pic.Text = (actual_finish == "" ? "" : pic_issue);

                        if (actual_finish != "")
                        lb_picdate.Text = Convert.ToDateTime(actual_finish).ToString("dd-MMM-yyyy");
                    }

                    //Mgr
                    if (User != null)
                    {
                        if (User.Rows[0]["Mgr_by"].ToString() != "")
                        {
                            string mgr = pic_info.Get_NameTH_format(User.Rows[0]["Mgr_by"].ToString(), "", false);
                            lb_approve.Text = mgr; 

                            lb_approvedate.Text = Convert.ToDateTime(User.Rows[0]["Mgr_date"]).ToString("dd-MMM-yyyy");
                        }

                        //Leder
                        if (User.Rows[0]["Leader_eng4_by"].ToString() != "")
                        {
                            string leder = pic_info.Get_NameTH_format(User.Rows[0]["Leader_eng4_by"].ToString(), "", false);
                            lb_checker.Text = leder;

                            lb_checkdate.Text = Convert.ToDateTime(User.Rows[0]["Leader_eng4_date"]).ToString("dd-MMM-yyyy");
                        }

                        //tool_owner 
                        if (User.Rows[0]["Leader_eng3_by"].ToString() != "")
                        {
                            string tool_owner = pic_info.Get_NameTH_format(User.Rows[0]["Leader_eng3_by"].ToString(), "", false);
                            lb_toolowner.Text = tool_owner;
         
                            lb_toolownwedate.Text = Convert.ToDateTime(User.Rows[0]["Leader_eng3_date"]).ToString("dd-MMM-yyyy");
                           
                        }
                    }

                   

                }

                GET_PICTURE();

            }

        }
        protected DataTable GET_USER(string PM_problem_name)
        {
            string str = " select Leader_eng3_by,Leader_eng3_date,Leader_eng4_by,Leader_eng4_date,Mgr_by,Mgr_date from jtPM_ProblemCheck_approve where PM_problem_name = '" + PM_problem_name + "'";
          dc.QryDT(conn, str);
            if(dc.dt.Rows.Count > 0)
            {
                return dc.dt;
            }
            else
            {
                return null;
            }
        }
        protected string GET_ACTION(string id)
        {

            string str = "select  action_name from  jtPM_actionStatus_master where action_id ="+id;
            dc.QryDT(conn, str);
           
            return (dc.dt.Rows.Count == 0 ?"-": dc.dt.Rows[0][0].ToString()) ; 
        }
        protected void GET_PICTURE()
        {

            ViewState["pic1"] = "";
            ViewState["pic2"] = "";
            ViewState["pic_action"] = "";

            string pm_problem_no = ViewState["pmProblem"].ToString(); 
            string[] str_split = pm_problem_no.Split('-');
            string year = str_split[1];
            string thisYear = DateTime.Now.Year.ToString();
            year = thisYear.Substring(0, 2) + year;

            string FolderPath = String.Format(@"\\cptfile02\Pro\PRJ2015009\01_PM History\02_PM Problem\{0}\{1}\Pictrue\", year, pm_problem_no);
            //string FolderShow = String.Format(@"img_problem/{0}/", year);
            string FolderShow = String.Format("img_problem/{0}/{1}/Pictrue/", year, pm_problem_no);
            //lb_test.Text = FolderPath + " : " + FolderShow;

            string[] pic1 = Directory.GetFiles(FolderPath, "PIC1_NG.jpg", SearchOption.TopDirectoryOnly);
            string[] pic2 = Directory.GetFiles(FolderPath, "PIC2_NG.jpg", SearchOption.TopDirectoryOnly);
            string[] pic3 = Directory.GetFiles(FolderPath, "PIC1_OK.jpg", SearchOption.TopDirectoryOnly);
            if (pic1.Length > 0) 
            {
                img_pic1.ImageUrl = FolderShow + "PIC1_NG.jpg";
                ViewState["pic1"] = FolderPath + "PIC1_NG.jpg";
            }

            if (pic2.Length > 0)
            {
                img_pic2.ImageUrl = FolderShow + "PIC2_NG.jpg";
                ViewState["pic2"] = FolderPath + "PIC2_NG.jpg";
            }
               

            if (pic3.Length > 0)
            {
               // int row = pic3.Length-1;
                //FileInfo f = new FileInfo(pic3[row]);
                img_pic_action.ImageUrl = FolderShow + "PIC1_OK.jpg";
                ViewState["pic_action"] = FolderPath + "PIC1_OK.jpg";
            }
               
        }
        protected string GetTool_id(int no)
        {
            string tool_id = Request.QueryString["tool_id"].ToString();
            string pm_problem_name = Request.QueryString["pm_problem_name"].ToString();
            string str = " select tool_id,toolSub_id from [dbo].[jtPM_problem] a left join [dbo].[jtPM_PeriodCheck_his] b on a.PRC_Grop_id = b.PRC_Grop_id and SUBSTRING(PM_problem_name,5,2) =  SUBSTRING(PRC_Grop_name,5,2) where PM_problem_name = '" + pm_problem_name + "' and tool_id =" + tool_id;
            dc.QryDT(conn, str);

            if (no == 1)
            {
                return tool_id; //(dc.dt.Rows[0]["tool_id"].ToString();
            }
            else if (no == 2)
            {
                return dc.dt.Rows[0]["toolSub_id"].ToString();
            }
            else
            {
                return "";
            }
        }

        protected DataTable Create_Excel()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add(new DataColumn("tool_no", typeof(string)));
            dt.Columns.Add(new DataColumn("tool_rank", typeof(string)));
            dt.Columns.Add(new DataColumn("tool_name", typeof(string)));
            dt.Columns.Add(new DataColumn("no_of_tool", typeof(string)));
            dt.Columns.Add(new DataColumn("fix_asset", typeof(string)));
            dt.Columns.Add(new DataColumn("model", typeof(string)));
            dt.Columns.Add(new DataColumn("location", typeof(string)));
            dt.Columns.Add(new DataColumn("problem_no", typeof(string)));
            dt.Columns.Add(new DataColumn("problem_rank", typeof(string)));
            dt.Columns.Add(new DataColumn("problem_topic", typeof(string)));
            dt.Columns.Add(new DataColumn("problem_spec", typeof(string)));
            dt.Columns.Add(new DataColumn("problem_actual", typeof(string)));
            dt.Columns.Add(new DataColumn("problem_detail", typeof(string)));
            dt.Columns.Add(new DataColumn("action_topic", typeof(string)));
            dt.Columns.Add(new DataColumn("action_resuit", typeof(string)));
            dt.Columns.Add(new DataColumn("action_detail", typeof(string)));
            dt.Columns.Add(new DataColumn("issue_name", typeof(string)));
            dt.Columns.Add(new DataColumn("problem_date", typeof(string)));
            dt.Columns.Add(new DataColumn("plan_finish", typeof(string)));
            dt.Columns.Add(new DataColumn("actual_finish", typeof(string)));
            dt.Columns.Add(new DataColumn("rsp_name", typeof(string)));
            dt.Columns.Add(new DataColumn("rsp_date", typeof(string)));
            dt.Columns.Add(new DataColumn("leader_name", typeof(string)));
            dt.Columns.Add(new DataColumn("leader_date", typeof(string)));
            dt.Columns.Add(new DataColumn("tool_owner_name", typeof(string)));
            dt.Columns.Add(new DataColumn("tool_owner_date", typeof(string)));
            dt.Columns.Add(new DataColumn("mgr_name", typeof(string)));
            dt.Columns.Add(new DataColumn("mgr_date", typeof(string)));
            dt.Columns.Add(new DataColumn("picture_problem1", typeof(string)));
            dt.Columns.Add(new DataColumn("picture_problem2", typeof(string)));
            dt.Columns.Add(new DataColumn("picture_action", typeof(string)));
            return dt;
        }
        protected DataTable Excel()
        {
            DataTable tb_excel = Create_Excel();
            DataRow dr = null;

            dr = tb_excel.NewRow();
            dr["tool_no"] = lb_toolno.Text;        
            dr["tool_name"] = lb_toolname.Text;         
            dr["tool_rank"] = lb_ranktool.Text;
            dr["no_of_tool"] = lb_toolsubid.Text;    
            dr["model"] = lb_model.Text;
            dr["location"] = lb_location.Text;
            dr["fix_asset"] = lb_fixasset.Text;
            dr["problem_topic"] = lb_problem.Text;
            dr["plan_finish"] = lb_Planfinish.Text;
            dr["problem_date"] = lb_problemdate.Text;
            dr["action_topic"] = lb_action.Text;
            dr["problem_no"] = lb_problemno.Text;
            dr["problem_rank"] = lb_problemrank.Text;
            dr["actual_finish"] = lb_finishdate.Text;
            dr["problem_spec"] = lb_spec.Text;
            dr["problem_actual"] = lb_actual.Text; 
            dr["problem_detail"] = lb_problemdetail.Text;
            dr["action_resuit"] = lb_result_spec.Text;  
            dr["action_detail"] = lb_result_detail.Text;
            dr["issue_name"] = lb_issueby.Text;
            dr["rsp_name"] = lb_pic.Text;
            dr["rsp_date"] = lb_picdate.Text.ToString();
            dr["mgr_name"] = lb_approve.Text;
            dr["mgr_date"] = lb_approvedate.Text.ToString();
            dr["leader_name"] = lb_checker.Text;
            dr["leader_date"] = lb_checkdate.Text.ToString();
            dr["tool_owner_name"] = lb_toolowner.Text;
            dr["tool_owner_date"] = lb_toolownwedate.Text;
            dr["picture_problem1"] = ViewState["pic1"].ToString();
            dr["picture_problem2"] = ViewState["pic2"].ToString();
            dr["picture_action"] = ViewState["pic_action"].ToString();
            tb_excel.Rows.Add(dr);
            return tb_excel;
           
        }
        protected void Gen_Excel_Download()
        {
            string fomart = @"\\cptfile02\Pro\PRJ2016017\10_Tooling Management Control System\00_System\Template\PM_Problem_Format_Rev04.xlsx";

            DataTable tb_excel = Excel();
            //gv_test.DataSource = tb_excel;
            // gv_test.DataBind();
            var workbook = new XLWorkbook(fomart);
            var worksheet = workbook.Worksheet("Form_report");
            if (tb_excel.Rows.Count > 0)
            {
                worksheet.Cell("Y1").Value = tb_excel.Rows[0]["issue_name"].ToString();
                worksheet.Cell("AH1").Value = tb_excel.Rows[0]["problem_no"].ToString();
                worksheet.Cell("D2").Value = tb_excel.Rows[0]["tool_no"].ToString();
                worksheet.Cell("Q2").Value = tb_excel.Rows[0]["tool_rank"].ToString();
                worksheet.Cell("Y2").Value = tb_excel.Rows[0]["problem_date"].ToString();
                worksheet.Cell("D3").Value = tb_excel.Rows[0]["tool_name"].ToString();
                worksheet.Cell("Y3").Value = tb_excel.Rows[0]["no_of_tool"].ToString();
                worksheet.Cell("AH3").Value = tb_excel.Rows[0]["problem_rank"].ToString();
                worksheet.Cell("D4").Value = tb_excel.Rows[0]["model"].ToString();
                worksheet.Cell("N4").Value = tb_excel.Rows[0]["location"].ToString();
                worksheet.Cell("Y4").Value = tb_excel.Rows[0]["fix_asset"].ToString();
                worksheet.Cell("D5").Value = tb_excel.Rows[0]["problem_topic"].ToString();
                worksheet.Cell("R6").Value = tb_excel.Rows[0]["plan_finish"].ToString();
                worksheet.Cell("Y5").Value = tb_excel.Rows[0]["action_topic"].ToString();
                worksheet.Cell("AH6").Value = tb_excel.Rows[0]["actual_finish"].ToString();
                worksheet.Cell("M8").Value = tb_excel.Rows[0]["problem_spec"].ToString();
                worksheet.Cell("M9").Value = tb_excel.Rows[0]["problem_actual"].ToString();
                worksheet.Cell("M10").Value = tb_excel.Rows[0]["problem_detail"].ToString();

                worksheet.Cell("X8").Value = tb_excel.Rows[0]["action_resuit"].ToString();
                worksheet.Cell("X9").Value = tb_excel.Rows[0]["action_detail"].ToString();
                
                worksheet.Cell("AH28").Value = tb_excel.Rows[0]["rsp_name"].ToString();
                worksheet.Cell("AH30").Value = tb_excel.Rows[0]["rsp_date"].ToString();
                
                worksheet.Cell("AD28").Value = tb_excel.Rows[0]["tool_owner_name"].ToString();
                worksheet.Cell("AD30").Value = tb_excel.Rows[0]["tool_owner_date"].ToString();
                
                worksheet.Cell("Z28").Value = tb_excel.Rows[0]["leader_name"].ToString();
                worksheet.Cell("Z30").Value = tb_excel.Rows[0]["leader_date"].ToString();

                worksheet.Cell("V28").Value = tb_excel.Rows[0]["mgr_name"].ToString();
                worksheet.Cell("V30").Value = tb_excel.Rows[0]["mgr_date"].ToString();


                ////Picture
                int MAX_WIDTH = 220;
                int MAX_HEIGHT = 220;

                string pic1 = tb_excel.Rows[0]["picture_problem1"].ToString();
                if(pic1 != "")
                {
                    var image_pic1 = worksheet.AddPicture(pic1);
                    Double xRatio = (double)image_pic1.Width / MAX_WIDTH;
                    Double yRatio = (double)image_pic1.Height / MAX_HEIGHT;
                    Double ratio = Math.Max(xRatio, yRatio);
                    int nnx = (int)Math.Floor(image_pic1.Width / ratio);
                    int nny = (int)Math.Floor(image_pic1.Height / ratio);

                    double cellWidth = 270;
                    double cellHeight = 226;
                    //double pixelWidth = (cellWidth * 7 + 5);
                    //double pixelHeight = (cellHeight * 0.75);
                    //double leftMargin = ((pixelWidth - nnx) / 2);
                    //double topMargin = ((pixelHeight - nny) / 2);
                    double leftMargin = ((cellWidth - nnx) / 2);
                    double topMargin = ((cellHeight - nny) / 2);

                    if (leftMargin < 0)
                    {
                        leftMargin = leftMargin*-1;
                    }
                    if (topMargin < 0)
                    {
                        topMargin = topMargin * -1;
                    }

                    //worksheet.Cell("M8").Value = "P_W:" + nnx.ToString() + " , Left Margin :" + leftMargin.ToString();
                    //worksheet.Cell("M9").Value = "P_H:" + nny.ToString() + " , Top Margin :" + topMargin.ToString();

                    image_pic1.MoveTo(worksheet.Cell("A8"), Convert.ToInt32(leftMargin), Convert.ToInt32(topMargin)).WithSize(nnx, nny);

                }

                MAX_WIDTH = 450;
                MAX_HEIGHT = 280;

                string pic2 = tb_excel.Rows[0]["picture_problem2"].ToString();
                if(pic2 != "")
                {
                    var image_pic2 = worksheet.AddPicture(pic2);
                    Double xRatio = (double)image_pic2.Width / MAX_WIDTH;
                    Double yRatio = (double)image_pic2.Height / MAX_HEIGHT;
                    Double ratio = Math.Max(xRatio, yRatio);
                    int nnx = (int)Math.Floor(image_pic2.Width / ratio);
                    int nny = (int)Math.Floor(image_pic2.Height / ratio);

                    double cellWidth = 513;
                    double cellHeight = 322;
                    //double pixelWidth = (cellWidth * 7 + 5);
                    //double pixelHeight = (cellHeight * 0.75);
                    double leftMargin = ((cellWidth - nnx) / 2);
                    double topMargin = ((cellHeight - nny) / 2);

                    if (leftMargin < 0)
                    {
                        leftMargin = leftMargin * -1;
                    }
                    if (topMargin < 0)
                    {
                        topMargin = topMargin * -1;
                    }

                    //worksheet.Cell("M8").Value = "P_W:" + nnx.ToString() + " , Left Margin :" + leftMargin.ToString();
                    //worksheet.Cell("M9").Value = "P_H:" + nny.ToString() + " , Top Margin :" + topMargin.ToString();

                    image_pic2.MoveTo(worksheet.Cell("B19"),Convert.ToInt32(leftMargin), Convert.ToInt32(topMargin)).WithSize(nnx, nny);
                    //image_pic2.MoveTo(worksheet.Cell("B19")).WithSize(nnx, nny);
                }                                                        

                MAX_WIDTH = 360;
                MAX_HEIGHT = 250;

                string pic_action = tb_excel.Rows[0]["picture_action"].ToString();

                if (pic_action != "")
                {
                    var image_pic = worksheet.AddPicture(pic_action);
                    Double xRatio = (double)image_pic.Width / MAX_WIDTH;
                    Double yRatio = (double)image_pic.Height / MAX_HEIGHT;
                    Double ratio = Math.Max(xRatio, yRatio);
                    int nnx = (int)Math.Floor(image_pic.Width / ratio);
                    int nny = (int)Math.Floor(image_pic.Height / ratio);

                    double cellWidth = 378;
                    double cellHeight = 268;
                    //double pixelWidth = (cellWidth * 7 + 5);
                    //double pixelHeight = (cellHeight * 0.75);
                    double leftMargin = ((cellWidth - nnx) / 2);
                    double topMargin = ((cellHeight - nny) / 2);

                    if (leftMargin < 0)
                    {
                        leftMargin = leftMargin * -1;
                    }
                    if (topMargin < 0)
                    {
                        topMargin = topMargin * -1;
                    }

                    image_pic.MoveTo(worksheet.Cell("W16"), Convert.ToInt32(leftMargin), Convert.ToInt32(topMargin)).WithSize(nnx, nny);

                }

            }

           // worksheet.Columns().AdjustToContents();
            Response.Clear();
            Response.Buffer = true;
            Response.Charset = "";
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.AddHeader("content-disposition", "attachment;filename="+ tb_excel.Rows[0]["problem_no"].ToString() + ".xlsx");
            using (MemoryStream MyMemoryStream = new MemoryStream())
            {
                workbook.SaveAs(MyMemoryStream);
                MyMemoryStream.WriteTo(Response.OutputStream);
                Response.Flush();
                Response.End();

            }


        }
        protected void btn_download_report_Click(object sender, EventArgs e)
        {           
            Gen_Excel_Download();
        }

        protected void btnExportPdf_Click(object sender, System.Web.UI.ImageClickEventArgs e)
        {
            // --- ส่วนที่ 1: สร้างข้อมูล Excel โดยใช้ Spire.XLS ---
            string fomart = @"\\cptfile02\Pro\PRJ2016017\10_Tooling Management Control System\00_System\Template\PM_Problem_Format_Rev04.xlsx";
            DataTable tb_excel = Excel();

            Workbook workbook = new Workbook();
            workbook.LoadFromFile(fomart);
            Worksheet sheet = workbook.Worksheets["Form_report"];

            if (tb_excel.Rows.Count > 0)
            {
                // --- แก้ไขตรงนี้: เปลี่ยน .Cell เป็น .Range ---
                sheet.Range["Y1"].Value = tb_excel.Rows[0]["issue_name"].ToString();
                sheet.Range["AH1"].Value = tb_excel.Rows[0]["problem_no"].ToString();
                sheet.Range["D2"].Value = tb_excel.Rows[0]["tool_no"].ToString();
                sheet.Range["Q2"].Value = tb_excel.Rows[0]["tool_rank"].ToString();
                sheet.Range["Y2"].Value = tb_excel.Rows[0]["problem_date"].ToString();
                sheet.Range["D3"].Value = tb_excel.Rows[0]["tool_name"].ToString();
                sheet.Range["Y3"].Value = tb_excel.Rows[0]["no_of_tool"].ToString();
                sheet.Range["AH3"].Value = tb_excel.Rows[0]["problem_rank"].ToString();
                sheet.Range["D4"].Value = tb_excel.Rows[0]["model"].ToString();
                sheet.Range["N4"].Value = tb_excel.Rows[0]["location"].ToString();
                sheet.Range["Y4"].Value = tb_excel.Rows[0]["fix_asset"].ToString();
                sheet.Range["D5"].Value = tb_excel.Rows[0]["problem_topic"].ToString();
                sheet.Range["R6"].Value = tb_excel.Rows[0]["plan_finish"].ToString();
                sheet.Range["Y5"].Value = tb_excel.Rows[0]["action_topic"].ToString();
                sheet.Range["AH6"].Value = tb_excel.Rows[0]["actual_finish"].ToString();
                sheet.Range["M8"].Value = tb_excel.Rows[0]["problem_spec"].ToString();
                sheet.Range["M9"].Value = tb_excel.Rows[0]["problem_actual"].ToString();
                sheet.Range["M10"].Value = tb_excel.Rows[0]["problem_detail"].ToString();
                sheet.Range["X8"].Value = tb_excel.Rows[0]["action_resuit"].ToString();
                sheet.Range["X9"].Value = tb_excel.Rows[0]["action_detail"].ToString();
                sheet.Range["AH28"].Value = tb_excel.Rows[0]["rsp_name"].ToString();
                sheet.Range["AH30"].Value = tb_excel.Rows[0]["rsp_date"].ToString();
                sheet.Range["AD28"].Value = tb_excel.Rows[0]["tool_owner_name"].ToString();
                sheet.Range["AD30"].Value = tb_excel.Rows[0]["tool_owner_date"].ToString();
                sheet.Range["Z28"].Value = tb_excel.Rows[0]["leader_name"].ToString();
                sheet.Range["Z30"].Value = tb_excel.Rows[0]["leader_date"].ToString();
                sheet.Range["V28"].Value = tb_excel.Rows[0]["mgr_name"].ToString();
                sheet.Range["V30"].Value = tb_excel.Rows[0]["mgr_date"].ToString();
                // --- สิ้นสุดการแก้ไข ---


                ////Picture
                // --- แก้ไขตรงนี้: เปลี่ยนวิธีการเพิ่มรูปภาพเป็นแบบของ Spire.XLS ---
                string pic1 = tb_excel.Rows[0]["picture_problem1"].ToString();
                //if (pic1 != "" && File.Exists(pic1))
                if (!string.IsNullOrEmpty(pic1) && File.Exists(pic1))
                {
                    //Image image_pic1 = Image.FromFile(pic1);
                    //// Cell A8 คือ Row 8, Column 1
                    //ExcelPicture picture = sheet.Pictures.Add(8, 1, image_pic1);
                    //picture.Width = 270;
                    //picture.Height = 226;

                    // ส่ง Path ของไฟล์เข้าไปตรงๆ Library จะจัดการเปิดและปิดไฟล์เอง
                    ExcelPicture picture = sheet.Pictures.Add(8, 1, pic1);

                    // กำหนดขนาดหลังจากเพิ่มรูปแล้ว
                    picture.Width = 270;
                    picture.Height = 226;
                }

                string pic2 = tb_excel.Rows[0]["picture_problem2"].ToString();
                //if (pic2 != "" && File.Exists(pic2))
                if (!string.IsNullOrEmpty(pic2) && File.Exists(pic2))
                {
                    //Image image_pic2 = Image.FromFile(pic2);
                    //// Cell B19 คือ Row 19, Column 2
                    //ExcelPicture picture = sheet.Pictures.Add(19, 2, image_pic2);
                    //picture.Width = 513;
                    //picture.Height = 322;

                    ExcelPicture picture = sheet.Pictures.Add(19, 2, pic2);
                    picture.Width = 513;
                    picture.Height = 322;
                }

                string pic_action = tb_excel.Rows[0]["picture_action"].ToString();
                //if (pic_action != "" && File.Exists(pic_action))
                if (!string.IsNullOrEmpty(pic_action) && File.Exists(pic_action))
                {
                    //Image image_pic_action = Image.FromFile(pic_action);
                    //// Cell W16 คือ Row 16, Column 23
                    //ExcelPicture picture = sheet.Pictures.Add(16, 23, image_pic_action);
                    //picture.Width = 378;
                    //picture.Height = 268;

                    ExcelPicture picture = sheet.Pictures.Add(16, 23, pic_action);
                    picture.Width = 378;
                    picture.Height = 268;
                }
                // --- สิ้นสุดการแก้ไข ---
            }

            // --- ส่วนที่ 2: กำหนดค่าและแปลงไฟล์ (ส่วนนี้ถูกต้องแล้ว) ---
            //string saveFolderPath = "D:\\PM_Reports\\PDF\\";
            //if (!Directory.Exists(saveFolderPath))
            //{
            //    Directory.CreateDirectory(saveFolderPath);
            //}

            //string problemNo = tb_excel.Rows[0]["problem_no"].ToString();
            //string fileName = string.Format("{0}_{1}.pdf", problemNo, DateTime.Now.ToString("yyyyMMdd_HHmmss"));
            //string fullPath = Path.Combine(saveFolderPath, fileName);

            //// แปลงและบันทึกไฟล์เป็น PDF
            //workbook.SaveToFile(fullPath, FileFormat.PDF);

            //// แจ้งผลลัพธ์ให้ผู้ใช้ทราบ
            //string jsFullPath = fullPath.Replace("\\", "\\\\");
            //string script = string.Format("alert('บันทึกไฟล์ PDF สำเร็จที่: {0}');", jsFullPath);
            //ClientScript.RegisterStartupScript(this.GetType(), "alert", script, true);

            try
            {
                // สร้างชื่อไฟล์สำหรับดาวน์โหลด
                string problemNo = tb_excel.Rows[0]["problem_no"].ToString();
                string downloadFileName = string.Format("{0}_{1}.pdf", problemNo, DateTime.Now.ToString("yyyyMMdd_HHmmss"));

                // บันทึกไฟล์ PDF ลงใน MemoryStream แทนการบันทึกลงดิสก์
                using (MemoryStream pdfStream = new MemoryStream())
                {
                    workbook.SaveToStream(pdfStream, FileFormat.PDF);

                    // เตรียม Response เพื่อส่งไฟล์กลับไปให้ Browser
                    Response.Clear();
                    Response.ContentType = "application/pdf";
                    Response.AddHeader("Content-Disposition", string.Format("attachment; filename={0}", downloadFileName));

                    // เขียนข้อมูลจาก MemoryStream ลงใน Response
                    Response.BinaryWrite(pdfStream.ToArray());

                    // จบการทำงานของ Response เพื่อให้ไฟล์ถูกส่งไปทันที (สำคัญมาก)
                    Response.End();
                }
            }
            catch (Exception ex)
            {
                // หากเกิด Error ให้แสดงข้อความ (ส่วนนี้จะแสดงผลบนหน้าเว็บเปล่าๆ)
                Response.Write("เกิดข้อผิดพลาดในการสร้างไฟล์ PDF: " + ex.Message);
            }
        }


    }

   
}