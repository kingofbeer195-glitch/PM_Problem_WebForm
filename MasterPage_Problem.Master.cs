using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
namespace jig_tool
{
    public partial class MasterPage_Problem : System.Web.UI.MasterPage
    {
        SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["Sql"].ConnectionString);
        datacon dc = new datacon();
        public void Assign_Session(string emp_id)
        {
            login_getUser getUser = new login_getUser();
            getUser.Get_forSession(emp_id);
            Session["user_id"] = getUser.USER_ID;
            Session["emp_id"] = getUser.EMP_ID;
            Session["dept_id"] = getUser.USER_DEPT;
            Session["user_name"] = getUser.USER_NAME;
            Session["positionId"] = getUser.POSITION_ID;
            Session["eng_group_id"] = getUser.ENG_GROUP_ID;
            Session["user_group"] = getUser.USER_GROUP;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            string empID = Request.QueryString["emp_id"];

            if (Session["emp_id"] == null)
            {
                Response.Redirect("Default.aspx");
                //string baseUrl = "http://cptsvs528.canon-pt.co.th";
                //string AbsolutePath = HttpContext.Current.Request.Url.AbsolutePath;
                //if (AbsolutePath.ToLower().Contains("test"))
                //{
                //    Response.Redirect("" + baseUrl + "/User_master_test/login.aspx");
                //}
                //else
                //{
                //    Response.Redirect("" + baseUrl + "/User_master/login.aspx");
                //}
            }

            string emp_id = Session["emp_id"].ToString();
            Assign_Session(emp_id);

            string user_group = Session["user_group"].ToString();

            string str = "  select fname + ' ' + SUBSTRING(lname,1,1) + '.' as name,position_id,eng_group_id,user_dept from cptsvs528.user_master.dbo.sys_user_master where emp_id = '" + emp_id + "' ";
            dc.QryDT(conn, str);

            string eng_group_id = Session["eng_group_id"].ToString(); // dc.dt.Rows[0]["eng_group_id"].ToString();
            string position_id = Session["positionId"].ToString(); //dc.dt.Rows[0]["position_id"].ToString();

            hpl_userName.InnerHtml = dc.dt.Rows[0]["name"].ToString();


            string admin = (emp_id == "016148" || emp_id == "001566" ? "1" : "0");  //check Admin

            Set_button_show(eng_group_id, position_id, admin);

            A2.HRef = "javascript:window.open('','_self').close();";
            A31.HRef = "jt_problem_checkProcess.aspx?emp_id=" + emp_id + "&status=0"; //send for check
            A36.HRef = "jt_problem_checkProcess.aspx?emp_id=" + emp_id + "&status=1";  //Person Discharge
            A32.HRef = "jt_problem_eng3Check.aspx?tool_owner=" + eng_group_id + "";
            //A33.HRef = "jt_problem_eng4Check.aspx";
            //A34.HRef = "jt_problem_MgrCheck.aspx";
            A41.HRef = "jt_acknowledge_problem.aspx?emp_id=" + emp_id;
            A35.HRef = "http://cptsvs552.canon-pt.co.th/Dashboard/pm-problem";
            A27.HRef = "jt_his_new_problem.aspx?status=9";
            A4.HRef = "jt_his_new_problem.aspx?status=0" ;
            A30.HRef = "jt_his_problem_follow_up.aspx?status=0" ;
            A13.HRef = "jt_his_problem_follow_up.aspx?status=1";
            A28.HRef = "PM_problem_manual_new.aspx?emp_id=" + emp_id;
            A25.HRef = "jt_problem_his_master.aspx";

        }
        protected void Set_button_show(string group_id, string position_id, string admin)
        {
            #region /* // show button BY admin*/
            if (admin == "1")
            {
                A30.Visible = true;
               // A35.Visible = true;  // dasboard

            }
            else
            {
                A30.Visible = false;
              //  A35.Visible = false;
                }
            #endregion

            #region /*// check show button on PM Promblem Manu*/
            if (group_id == "5" || position_id == "7")  // Group PM and P'jead
            {
                A27.Visible = true;
                A4.Visible = true;
                A30.Visible = true;
                A13.Visible = true;
              
            }
           
            #endregion

        }
        protected void A39_Click(object sender, EventArgs e)
        {
            string folder = @"\\cptfile02\Pro\PRJ2016017\10_Tooling Management Control System\00_System\01_Flow_Manual\00_Flow\Excel\00_PM Problem Management System.xlsx";

            // string new_fullfile =  ;

            FileInfo file_Info = new FileInfo(folder);

            if (file_Info.Exists)
            {

                WebClient req = new WebClient();
                HttpResponse response = HttpContext.Current.Response;
                response.Clear();
                response.ClearContent();
                response.ClearHeaders();
                response.Buffer = true;
                response.AddHeader("Content-Disposition", "attachment;filename=\"" + file_Info.Name + " ");
                byte[] data = req.DownloadData(folder);
                response.BinaryWrite(data);
                response.End();

            }
        }
    }
}