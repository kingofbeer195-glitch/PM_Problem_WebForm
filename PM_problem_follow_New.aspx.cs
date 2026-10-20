using ClosedXML.Excel;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text.RegularExpressions;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Windows;

namespace jig_tool
{
    public partial class PM_problem_follow_New : System.Web.UI.Page
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
                    Assign_Session(emp_id);
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
            string url_problem = HttpContext.Current.Request.Url.PathAndQuery;
            Session["url_problem"] = url_problem;

            if (Session["emp_id"] == null)
            {
                Check_user();// CallForLogin();//  Response.Redirect("Default.aspx");
                return;

            }


            // Group
            GroupMaster_Controller Group_Con = new GroupMaster_Controller();
            DataTable dt_group = Group_Con.GetDataTable_N3N4(true);
            ddl_group.DataSource = dt_group;
            ddl_group.DataValueField = "group_id";
            ddl_group.DataTextField = "group_name";
            ddl_group.DataBind();

            GroupMaster_Controller Group_Con1 = new GroupMaster_Controller();
            DataTable dt_group1 = Group_Con1.GetDataTable_N3N4(true);
            ddl_owner.DataSource = dt_group1;
            ddl_owner.DataTextField = "group_name";
            ddl_owner.DataValueField = "group_id";
            ddl_owner.DataBind();



        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // ✅ ถ้ามีการร้องขอเปิด/ดาวน์โหลด PDF ให้สตรีมไฟล์แล้วจบเลย
            //HandlePdfRequestIfAny();
            HandleFileRequestIfAny();

            ViewState["isOnplan"] = "";
            if (!IsPostBack)
            {
                Bind_data();
                Check_Process();
                AssignLink();
                Check_admin(Session["admin"].ToString());
                //BindPdfListAndShow();
                BindDrawingListAndShow();
            }
            Bind_picture();

            // ✅ อัปเดตสถานะเมนู PDF ทุกครั้ง
            //TogglePdfMenu();
            ToggleDrawingMenu();


            //test1.Text = GetDwgFolderForCurrentProblem();
            //DebugPrintPdfList();

        }
        protected void AssignLink()
        {
            string tool_id = GetTool_id(1);
            Session["oldUrl_master"] = null;
            ToolDetail_link.HRef = "jt_details2.aspx?tool_id=" + tool_id;

            string toolSub_id = GetTool_id(2);
            PeriodCheck_link.HRef = "jt_his_master.aspx?tool_id=" + tool_id + "&toolSub_id=" + toolSub_id + "";
        }

        protected void Check_admin(string admin)
        {
            if (admin == "")
            {
                ddl_isOnplan.Enabled = false;
            }
            else
            {
                string status_process = ViewState["isOnplan"].ToString();
                switch (status_process)
                {
                    case "7": //Close
                        btn_UpdateAction.Enabled = false;  //Action :
                        btn_UpdateTypeProblem.Enabled = false; // Type of Problem : 
                        btn_UpdateProblemRank.Enabled = false; //Problem Rank
                        btn_Update_Type_Issue.Enabled = false;
                        btn_Update_Resp.Enabled = false;
                        btn_Update_FollowUp_date.Enabled = false;
                        btn_UpdateProblemDetail.Enabled = false;
                        LinkButton8.Enabled = false;  //รายละเอียดปัญหาเพิ่มเติม
                        LinkButton9.Enabled = false;  //รายละเอียดการแก้ไขปัญหา
                        ddl_Pro_type2.Enabled = false;
                        ddl_Pro_type3.Enabled = false;
                        ddl_part_equi.Enabled = false;
                        ddl_touch.Enabled = false;
                        ddl_risk.Enabled = false;
                        // btn_uploadPic_problem.Enabled = false;
                        // btn_uploadPic.Enabled = false; 

                        break;
                    default:
                        break;

                }
            }
        }
        protected void Check_Process()
        {
            string status_process = ViewState["isOnplan"].ToString();// ddl_isOnplan.SelectedValue.ToString();
            string user_group_id = Session["eng_group_id"].ToString();
            string group_issue = hd_GroupIssue_id.Value.ToString();
            switch (status_process)
            {
                case "0":  //Acknowledge
                    Acknowledge_Process.Attributes.Add("class", "step active");
                    btn_Acknowledge_Process.Enabled = true;
                    break;
                case "1":  //On plan
                    Onplan.Attributes.Add("class", "step active");
                    btn_Onplan.Enabled = true;
                    break;
                case "2": //Delay
                    Onplan.Attributes.Add("class", "step active");
                    Onplan.Attributes.Add("data-desc", "Delay");
                    btn_Onplan.Enabled = true;
                    break;
                case "3": //Send for Check
                    sen_for_check.Attributes.Add("class", "step active");
                    btn_sen_for_check.Enabled = true;

                    break;
                case "4": //Tool Owner[J3] Check
                    Tool_Owner.Attributes.Add("class", "step active");
                    btn_Tool_Owner.Enabled = true;
                    break;
                case "5": //ENG4[J3] Check
                    ENG4_J3.Attributes.Add("class", "step active");
                    btn_ENG4_J3.Enabled = true;
                    break;
                case "6": //ENG4[Mgr] Approve
                    ENG4_Mgr.Attributes.Add("class", "step active");
                    btn_ENG4_Mgr.Enabled = true;
                    break;
                case "7": //Close
                    close.Attributes.Add("class", "step");
                    btn_close.Enabled = true;
                    break;
                case "9": // New Problem
                    NewProblem_Process.Attributes.Add("class", "step active");
                    btn_NewProblem_Process.Enabled = true;
                    break;
                default:
                    break;

            }

        }

        // ******* Bind Data Problem *******//
        protected void Bind_data()
        {
            string pm_problem_name = Request.QueryString["pm_problem_name"].ToString();

            string tool_id = GetTool_id(1);
            // string tool_sub = GetTool_id(2);
            ToolMater_GetData ToolMaster = new ToolMater_GetData(tool_id);

            txt_detail.Text = "";

            if (ToolMaster.IsHaveData)
            {
                string Tool_id = ToolMaster.TOOL_ID;
                hd_toolID.Value = Tool_id;

                string tool_name = ToolMaster.TOOL_NAMEEN;
                hd_tool_name.Value = tool_name;

                string Tool_Rank = ToolMaster.RANK_ID;

                PMProblem_GetDate PM_Problem_DB = new PMProblem_GetDate(pm_problem_name, Tool_Rank);

                lb_problem.Text = "Problem No : " + PM_Problem_DB.PM_problem_name;


                if (PM_Problem_DB.IsHaveData)
                {
                    string Tool_no = PM_Problem_DB.tool_no;
                    txt_toolno.Text = Tool_no;

                    string tool_sub = PM_Problem_DB.toolSub_id;
                    txt_toolsub_id.Text = "No." + tool_sub;

                    string fix_acces = PM_Problem_DB.FixAcces;
                    txt_Fixasset.Text = fix_acces;

                    string model = PM_Problem_DB.model_name;
                    txt_Model.Text = model;

                    string location = PM_Problem_DB.location;
                    txt_Location.Text = location;

                    string isOnplan = PM_Problem_DB.isOnplan;

                    if (isOnplan != "")
                    {
                        ddl_isOnplan.SelectedValue = isOnplan;
                        hd_status.Value = isOnplan;
                        ViewState["isOnplan"] = isOnplan;
                    }

                    ViewState["manual_status"] = (PM_Problem_DB.manual_status == null ? "0" : PM_Problem_DB.manual_status);

                    if (PM_Problem_DB.PRC_Grop_name != null)
                        ViewState["PRC_Grop_name"] = PM_Problem_DB.PRC_Grop_name;

                    string action = PM_Problem_DB.action;
                    if (action != "")
                    {
                        ddl_Action.SelectedValue = action;
                    }

                    string symbol = PM_Problem_DB.symbol;

                    string pro_type1 = PM_Problem_DB.pro_type1;
                    if (pro_type1 != "")
                    {
                        ddl_Pro_type1.SelectedValue = pro_type1;
                    }

                    string pro_type2 = PM_Problem_DB.pro_type2;
                    ddl_Pro_type2.SelectedValue = pro_type2;

                    string pro_type3 = PM_Problem_DB.pro_type3;
                    ddl_Pro_type3.SelectedValue = pro_type3;

                    string part_equi = PM_Problem_DB.part_equi;
                    ddl_part_equi.SelectedValue = part_equi;

                    string TypeProblem = PM_Problem_DB.TypeProblem;
                    ddl_type.SelectedValue = TypeProblem;

                    string touch = PM_Problem_DB.touch_status;
                    ddl_touch.SelectedValue = touch.Trim();

                    string risk = PM_Problem_DB.risk_status;
                    ddl_risk.SelectedValue = risk.Trim();

                    string priority = PM_Problem_DB.priority;
                    if (priority != "")
                        ddl_priority.SelectedValue = priority;

                    string pmProblem = PM_Problem_DB.PM_problem_name;
                    string[] group_check = Get_group_Issue(pmProblem);
                    hd_pmProblem_name.Value = pmProblem;
                    hd_GroupIssue.Value = group_check[0].ToString();
                    hd_GroupIssue_id.Value = group_check[1].ToString();


                    string pmProblem_id = PM_Problem_DB.PM_problem_id;
                    hd_pmProblem_id.Value = pmProblem_id;


                    string check_date = DateTime.Parse(PM_Problem_DB.check_date).ToString("dd-MMM-yyyy");
                    txt_problemDate.Text = check_date;

                    string issue_pic = PM_Problem_DB.check_name;
                    txt_issue.Text = issue_pic;


                    string issue_pic_id = PM_Problem_DB.check_by;
                    hd_issue_id.Value = issue_pic_id;

                    string Shift = PM_Problem_DB.Shift;
                    ddl_shift.SelectedValue = Shift;

                    // string TSS_sub = PM_Problem_DB.TSS_sub;
                    // txt_tss_sub.Text = (TSS_sub == "" ? "0" : TSS_sub);

                    // string TSS_Main = PM_Problem_DB.TSS_main;
                    //txt_tss_main.Text = (TSS_Main == "" ? "0" : TSS_Main);

                    // string TSS_comment = PM_Problem_DB.TSS_comment;
                    // txt_tss_comment.InnerText = (TSS_comment == "" ? "0" : TSS_comment);

                    string pic = PM_Problem_DB.pic;

                    string Resp_Group = PM_Problem_DB.group_resp;
                    if (Resp_Group != "")
                    {
                        ddl_group.SelectedValue = Resp_Group;
                        //ddl_resp_group_update.SelectedValue = Resp_Group;
                    }

                    Get_user_info pic_info = new Get_user_info();
                    if (pic != "" && pic != "NULL")
                    {
                        string pic_group = pic_info.Get_group(pic, "");

                        if (pic_group != "")
                        {
                            Bind_ddlPIC(pic_group);
                            ddl_pic1.SelectedValue = pic;
                            ddl_resp_name_update.SelectedValue = pic;
                        }

                        string str2 = "select '-Select-' as name ,0 as position_id,0 as eng_group_id,0 as user_dept,'' as emp_id , 0 as order_ union select REPLACE(REPLACE(fname,'Ms.',''),'Mr.','') + ' ' + SUBSTRING(lname,1,1) + '.' as name,position_id,eng_group_id,user_dept ,emp_id, 1 as order_ from user_master.dbo.sys_user_master a where  user_dept in (3,5) and position_id <> 7 and status = 1 and position_id <> 9 order by order_ ";
                        dc.QryDT(conn, str2);
                        //  lb_test.Text = dc.dt.Rows.Count.ToString();

                        if (dc.dt.Rows.Count > 0)
                        {
                            ddl_pic1.DataSource = dc.dt;
                            ddl_pic1.DataTextField = "name";
                            ddl_pic1.DataValueField = "emp_id";
                            ddl_pic1.DataBind();
                        }


                    }
                    else
                    {
                        //Resp. Group  (group_resp)
                        if (PM_Problem_DB.group_resp != "")
                        {
                            ddl_group.SelectedValue = PM_Problem_DB.group_resp;
                        }

                        string select = " select * from user_master.dbo.sys_user_master where emp_id = '" + Session["emp_id"].ToString() + "'";
                        dc.QryDT(conn, select);
                        DataTable tb_group = dc.dt;

                        if (dc.dt.Rows.Count > 0)
                        {
                            if (Session["eng_group_id"].ToString() != "5")
                            {
                                if (PM_Problem_DB.group_resp.ToString() == dc.dt.Rows[0]["eng_group_id"].ToString() && (Session["positionId"].ToString() == "9" || Session["positionId"].ToString() == "2" || Session["positionId"].ToString() == "3"))
                                {
                                    //btn_acknowledge.Visible = true;
                                }
                            }
                            else
                            {
                                if (Session["positionId"].ToString() == "1" || Session["positionId"].ToString() == "2" || Session["positionId"].ToString() == "3")   //J2,J3 PM group
                                {
                                    // btn_acknowledge.Visible = true;
                                }
                            }
                        }

                    }

                    string group = PM_Problem_DB.group_resp;

                    string owner = PM_Problem_DB.group_owner;
                    if (owner != "")
                    {
                        ddl_owner.SelectedValue = owner;
                    }

                    string plan_finish = "";
                    if (PM_Problem_DB.plan_finish != "")
                    {
                        plan_finish = DateTime.Parse(PM_Problem_DB.plan_finish).ToString("dd-MMM-yyyy");
                        txt_planFinish.Text = plan_finish;
                        lb_plan.Value = plan_finish;
                    }
;
                    string actual_finish = "";
                    if (PM_Problem_DB.actual_finish != "")
                    {
                        actual_finish = DateTime.Parse(PM_Problem_DB.actual_finish).ToString("dd-MMM-yyyy");
                        txt_actualFinish.Text = actual_finish;
                    }

                    string follow_up = "";
                    if (PM_Problem_DB.Follow_up != "")
                    {
                        follow_up = DateTime.Parse(PM_Problem_DB.Follow_up).ToString("dd-MMM-yyyy");
                        txt_follow_up.Text = follow_up;
                    }

                    //    txt_follow_up.Text = follow_up;

                    // problem Topic 
                    if (PM_Problem_DB.prob_topic == "")
                    {
                        string CheckListC1_name = PM_Problem_DB.CheckListC1_name;
                        string CheckListC2_name = PM_Problem_DB.CheckListC2_name;
                        string probTopic = CheckListC1_name + (CheckListC2_name == "" ? "" : " : " + CheckListC2_name);
                        ViewState["db_probTopic"] = probTopic;
                        txt_probTopic.Text = probTopic;
                    }
                    else
                    {
                        txt_probTopic.Text = PM_Problem_DB.prob_topic;
                        ViewState["db_probTopic"] = PM_Problem_DB.prob_topic;
                    }

                    // Problem Detail
                    string spec = PM_Problem_DB.spec_checkList;
                    if (spec != "")
                        lb_spec.Text = spec.ToString();

                    string actual_spec = PM_Problem_DB.actual_spec_checkList;
                    if (actual_spec != "")
                        lb_actual.Text = actual_spec.ToString();

                    string prob_detail = PM_Problem_DB.prob_detail;
                    if (prob_detail != "")
                        lb_detailProblem.Text = prob_detail.ToString();

                    string result_spec = PM_Problem_DB.result_spec_checkList;
                    if (result_spec != "")
                        lb_result_spec.Text = result_spec.ToString();

                    string result_prob_detail = PM_Problem_DB.result_prob_detail;
                    if (result_prob_detail != "")
                        lb_result_detail.Text = result_prob_detail.ToString();


                    //GET User Appove
                    DataTable User = GET_USER(pmProblem);


                    //Person
                    if (pic != "")
                    {
                        string pic_issue = pic_info.Get_NameTH_format(pic, "", false);
                        hd_issue.Value = pic_issue;
                        if (actual_finish != "")
                            hd_issue_date.Value = Convert.ToDateTime(actual_finish).ToString("dd-MMM-yyyy");
                    }

                    //Mgr
                    if (User != null)
                    {
                        if (User.Rows[0]["Mgr_by"].ToString() != "")
                        {
                            string mgr = pic_info.Get_NameTH_format(User.Rows[0]["Mgr_by"].ToString(), "", false);
                            hd_mgr_appove.Value = mgr;

                            hd_mgr_date.Value = Convert.ToDateTime(User.Rows[0]["Mgr_date"]).ToString("dd-MMM-yyyy");
                        }

                        //Leder
                        if (User.Rows[0]["Leader_eng4_by"].ToString() != "")
                        {
                            string leder = pic_info.Get_NameTH_format(User.Rows[0]["Leader_eng4_by"].ToString(), "", false);
                            hd_leder_appove.Value = leder;

                            hd_leder_date.Value = Convert.ToDateTime(User.Rows[0]["Leader_eng4_date"]).ToString("dd-MMM-yyyy");
                        }

                        //tool_owner 
                        if (User.Rows[0]["Leader_eng3_by"].ToString() != "")
                        {
                            string tool_owner = pic_info.Get_NameTH_format(User.Rows[0]["Leader_eng3_by"].ToString(), "", false);
                            hd_toolOwner_appove.Value = tool_owner;

                            hd_toolOwner_date.Value = Convert.ToDateTime(User.Rows[0]["Leader_eng3_date"]).ToString("dd-MMM-yyyy");

                        }
                    }

                }


                Brid_problem_detail();
            }

        }

        protected DataTable GET_USER(string PM_problem_name)
        {
            string str = " select Leader_eng3_by,Leader_eng3_date,Leader_eng4_by,Leader_eng4_date,Mgr_by,Mgr_date from jtPM_ProblemCheck_approve where PM_problem_name = '" + PM_problem_name + "'";
            dc.QryDT(conn, str);
            if (dc.dt.Rows.Count > 0)
            {
                return dc.dt;
            }
            else
            {
                return null;
            }
        }

        // **** Get Show Pictrue Promblem ****//
        protected void Bind_picture()
        {
            string pm_problem_no = hd_pmProblem_name.Value.ToString();
            string[] str_split = pm_problem_no.Split('-');
            string year = str_split[1];

            string thisYear = DateTime.Now.Year.ToString();
            year = thisYear.Substring(0, 2) + year;

            string FolderPath = String.Format(@"\\cptfile02\Pro\PRJ2015009\01_PM History\02_PM Problem\{0}\{1}\Pictrue", year, pm_problem_no);
            string FolderShow = String.Format(@"img_problem/{0}/{1}/Pictrue", year, pm_problem_no);

            Bind_pictrue(FolderPath, FolderShow);
        }
        protected void Bind_pictrue(string FolderPath, string FolderShow)
        {
            try
            {
                test1.Text = "";
                if (!Directory.Exists(FolderPath))
                {
                    Directory.CreateDirectory(FolderPath);
                }

                string[] files = Directory.GetFiles(FolderPath, "*NG.jpg", SearchOption.TopDirectoryOnly);
                string[] file = Directory.GetFiles(FolderPath, "*OK.jpg", SearchOption.TopDirectoryOnly);

                // Get the HttpFileCollection
                int howManyCol = 2;
                int count = files.Length;
                int howManyColOK = 2;
                int countOK = file.Length;
                // test1.Text = count + "</br>" + countOK; return;
                ///Get pictrue Problem "NG"
                #region
                divPicNG.Controls.Clear();

                if (count > 0)
                {
                    int howManyRow = count / howManyCol;
                    int isPlus = count % howManyCol;
                    if (isPlus > 0)
                        howManyRow = howManyRow + 1;

                    divPicNG.Controls.Add(new LiteralControl("<table>"));
                    divPicNG.Controls.Add(new LiteralControl("<tr><label>Picture NG</label></tr>"));
                    for (int i = 0; i < howManyRow; i++)
                    {
                        divPicNG.Controls.Add(new LiteralControl("<tr>"));

                        for (int j = 0; j < howManyCol; j++)
                        {
                            int row = (howManyCol * i) + j;
                            if (row < count)
                            {

                                FileInfo f = new FileInfo(files[row]);
                                divPicNG.Controls.Add(new LiteralControl("<td>"));
                                divPicNG.Controls.Add(new LiteralControl("<div class='media'>"));
                                divPicNG.Controls.Add(new LiteralControl("<div class='media-left media-middle'>"));
                                ImageButton img_view = new ImageButton();
                                img_view.ImageUrl = FolderShow + "/" + f.Name;// f.Name.ToString();
                                img_view.ID = "imgNG" + row.ToString();
                                img_view.Width = 130;

                                img_view.CssClass = "media-object";
                                img_view.Click += new ImageClickEventHandler(Img_view_Click);
                                divPicNG.Controls.Add(img_view);

                                //divPicNG.Controls.Add(new LiteralControl("<a href= '" + files[row] + "' target= '_blank '>"));
                                //divPicNG.Controls.Add(new LiteralControl("<img src='" + files[row] + "' class='media-object' style='width: 130px'>"));
                                //divPicNG.Controls.Add(new LiteralControl("</a>"));

                                divPicNG.Controls.Add(new LiteralControl("</div>"));
                                divPicNG.Controls.Add(new LiteralControl("<div class='media-body'>"));

                                LinkButton btnNG = new LinkButton();
                                btnNG.Text = "X";
                                btnNG.CssClass = "btn btn-danger";

                                btnNG.ID = "btn_" + f.Name.Replace(f.Extension, "").Replace(" ", "ddd");
                                btnNG.Click += new EventHandler(DeletePic_Click);
                                btnNG.OnClientClick = "if ( !confirm('Are you sure?')) return false;";
                                //ScriptManager.GetCurrent(this).RegisterPostBackControl(btn);
                                divPicNG.Controls.Add(btnNG);

                                divPicNG.Controls.Add(new LiteralControl("</div>"));
                                divPicNG.Controls.Add(new LiteralControl("</div>"));
                                divPicNG.Controls.Add(new LiteralControl("</td>"));
                            }
                        }
                        divPicNG.Controls.Add(new LiteralControl("</tr>"));
                    }

                    if (count < countOK)
                    {
                        divPicNG.Controls.Add(new LiteralControl("<td></td>"));
                    }
                    divPicNG.Controls.Add(new LiteralControl("</table>"));
                }
                #endregion

                ///Get pictrue problem "OK"
                #region

                divPicOK.Controls.Clear();

                if (countOK > 0)
                {
                    int howManyRowOK = countOK / howManyColOK;
                    int isPlusOK = countOK % howManyColOK;
                    if (isPlusOK > 0)
                        howManyRowOK = howManyRowOK + 1;

                    divPicOK.Controls.Add(new LiteralControl("<table>"));
                    divPicOK.Controls.Add(new LiteralControl("<tr><label>Picture OK</label></tr>"));
                    for (int i = 0; i < howManyColOK; i++)
                    {
                        divPicOK.Controls.Add(new LiteralControl("<tr>"));
                        for (int j = 0; j < howManyColOK; j++)
                        {
                            int row = (howManyColOK * i) + j;
                            if (row < countOK)
                            {

                                FileInfo f = new FileInfo(file[row]);
                                divPicOK.Controls.Add(new LiteralControl("<td>"));
                                divPicOK.Controls.Add(new LiteralControl("<div class='media'>"));
                                divPicOK.Controls.Add(new LiteralControl("<div class='media-left media-middle'>"));
                                ImageButton img_viewOK = new ImageButton();
                                img_viewOK.ImageUrl = FolderShow + "/" + f.Name;// f.Name.ToString();
                                img_viewOK.ID = "imgOK" + row.ToString();
                                img_viewOK.Width = 130;
                                img_viewOK.CssClass = "media-object";
                                img_viewOK.Click += new ImageClickEventHandler(Img_view_Click);
                                divPicOK.Controls.Add(img_viewOK);
                                //divPicOK.Controls.Add(new LiteralControl("<a href= '" + files[row] + "' target= '_blank '>"));
                                //divPicOK.Controls.Add(new LiteralControl("<img src='" + files[row] + "' class='media-object' style='width: 130px'>"));
                                //divPicNG.Controls.Add(new LiteralControl("</a>"));
                                divPicOK.Controls.Add(new LiteralControl("</div>"));
                                divPicOK.Controls.Add(new LiteralControl("<div class='media-body'>"));

                                LinkButton btnOK = new LinkButton();
                                btnOK.Text = "X";
                                btnOK.CssClass = "btn btn-danger";

                                btnOK.ID = "btn_" + f.Name.Replace(f.Extension, "").Replace(" ", "ddd");
                                btnOK.Click += new EventHandler(DeletePic_Click);
                                btnOK.OnClientClick = "if ( !confirm('Are you sure?')) return false;";
                                //ScriptManager.GetCurrent(this).RegisterPostBackControl(btn);
                                divPicOK.Controls.Add(btnOK);

                                divPicOK.Controls.Add(new LiteralControl("</div>"));
                                divPicOK.Controls.Add(new LiteralControl("</div>"));
                                divPicOK.Controls.Add(new LiteralControl("</td>"));
                            }
                        }


                        if (count > countOK)
                        {
                            divPicOK.Controls.Add(new LiteralControl("<td></td>"));
                        }
                        divPicOK.Controls.Add(new LiteralControl("</tr>"));
                    }
                    divPicOK.Controls.Add(new LiteralControl("</table>"));


                }

                #endregion

            }
            catch (Exception ex)
            {
                test1.Text = ex.Message;
            }
        }
        protected void Img_view_Click(object sender, ImageClickEventArgs e)
        {

            ImageButton button = (ImageButton)sender;

            img_modal.ImageUrl = button.ImageUrl;

            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#UploadPicture_modal2').modal('show')");
            sb.Append(@"</script>");
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "closemodal", sb.ToString(), false);

            return;

        }
        protected void DeletePic_Click(object sender, EventArgs e)
        {

            try
            {
                string pm_problem_no = hd_pmProblem_name.Value.ToString();
                string[] str_split = pm_problem_no.Split('-');
                string year = str_split[1];

                string thisYear = DateTime.Now.Year.ToString();
                year = thisYear.Substring(0, 2) + year;

                string FolderPath = String.Format(@"\\cptfile02\Pro\PRJ2015009\01_PM History\02_PM Problem\{0}\{1}\Pictrue", year, pm_problem_no);

                string FolderShow = String.Format(@"img_problem/{0}/{1}/Pictrue", year, pm_problem_no);

                LinkButton button = sender as LinkButton;
                string id = button.ID;
                string file_name = id.Replace("btn_", "");

                string[] file = Directory.GetFiles(FolderPath, "*" + file_name + "*", SearchOption.TopDirectoryOnly);
                if (file.Length == 1)
                    File.Delete(file[0]);

                Bind_pictrue(FolderPath, FolderShow);
            }
            catch (Exception ex)
            {
                test1.Text = ex.Message;
            }
        }
        public string RemoveSpecialChars(string str)
        {
            // Create  a string array and add the special characters you want to remove
            string[] chars = new string[] { ",", ".", "/", "!", "@", "#", "$", "%", "^", "&", "*", "'", "\"", ";", "-", "(", ")", ":", "|", "[", "]", " " };
            //Iterate the number of times based on the String array length.
            for (int i = 0; i < chars.Length; i++)
            {
                if (str.Contains(chars[i]))
                {
                    str = str.Replace(chars[i], "");
                }
            }
            return str;
        }


        //******************* Get Data Common *******************//
        protected string GetTool_id(int no)
        {
            string tool_id = Request.QueryString["tool_id"].ToString();
            string pm_problem_name = Request.QueryString["pm_problem_name"].ToString();
            string str = " select tool_id,toolSub_id from [dbo].[jtPM_problem] a left join [dbo].[jtPM_PeriodCheck_his] b on a.PRC_Grop_id = b.PRC_Grop_id and SUBSTRING(PM_problem_name,5,2) =  SUBSTRING(PRC_Grop_name,5,2) where PM_problem_name = '" + pm_problem_name.Trim() + "' and tool_id =" + tool_id;
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
        protected string[] Get_group_Issue(string Problem_no)
        {

            string str = "select groupN_check ,group_check from PM_Tool_History A where A.PM_problem_id is not null and A.PM_problem_name = N'" + Problem_no + "' ";
            dc.QryDT(conn, str);
            string[] group = { dc.dt.Rows[0][0].ToString(), dc.dt.Rows[0][1].ToString() };
            return group;

        }
        private void Bind_ddlPIC(string eng_group_id)
        {
            string str2 = " select '-Select-' as name ,0 as position_id,0 as eng_group_id,0 as user_dept,'' as emp_id , 0 as order_ union select REPLACE(REPLACE(fname,'Ms.',''),'Mr.','') + ' ' + SUBSTRING(lname,1,1) + '.' as name,position_id,eng_group_id,user_dept ,emp_id, 1 as order_ from user_master.dbo.sys_user_master a where eng_group_id =" + eng_group_id + " and user_dept in (3,5) and position_id <> 7 and status = 1 and position_id <> 9 order by order_ ";
            dc.QryDT(conn, str2);
            ddl_pic.DataSource = dc.dt;
            ddl_pic.DataTextField = "name";
            ddl_pic.DataValueField = "emp_id";
            ddl_pic.DataBind();

            string emp_id = Request.QueryString["emp_id"];
            for (int i = 0; i < dc.dt.Rows.Count; i++)
            {
                if (emp_id == dc.dt.Rows[i]["emp_id"].ToString())
                {
                    //btn_acknowledge.Visible = true;
                }
            }

        }
        protected void btn_summit_Click(object sender, EventArgs e)
        {
            try
            {
                // Save_picture();
            }
            catch (Exception ex)
            {

            }
            Boolean Iserror = CheckInvalid();


            if (Iserror == false)
            {
                // Tool Master Data
                string tool_id = GetTool_id(1);
                ToolMater_GetData ToolMaster = new ToolMater_GetData(tool_id);
                string Tool_Rank = ToolMaster.RANK_ID;

                string PM_problem_name = Request.QueryString["PM_problem_name"].ToString();
                string PM_problem_id = Request.QueryString["pm_problem_id"].ToString();
                PMProblem_GetDate Old_data = new PMProblem_GetDate(PM_problem_name, Tool_Rank);

                string update = "";
                string isOnplan = ddl_isOnplan.SelectedValue;
                if (isOnplan != Old_data.isOnplan)
                {
                    update += "  , isOnplan = " + isOnplan + "";
                }

                string Pro_type2 = ddl_Pro_type2.SelectedValue;
                if (Pro_type2 != Old_data.pro_type2)
                {
                    update += "  , pro_type2 = '" + Pro_type2 + "'";
                }

                string Pro_type3 = ddl_Pro_type3.SelectedValue;
                if (Pro_type3 != Old_data.pro_type3)
                {
                    update += "  , pro_type3 = '" + Pro_type3 + "'";
                }

                string Part_equi = ddl_part_equi.SelectedValue;
                if (Part_equi != Old_data.part_equi)
                {
                    update += "  , part_equi = '" + Part_equi + "'";
                }

                //string tss_sub = txt_tss_sub.Text;
                //if (tss_sub != Old_data.TSS_sub)
                //{
                //    if (System.Text.RegularExpressions.Regex.IsMatch(tss_sub, "[^0-9]"))
                //    {
                //        lb_error2.InnerText = "Please enter TSS-Sub only numbers.";
                //        txt_tss_sub.Text = txt_tss_sub.Text.Remove(txt_tss_sub.Text.Length - txt_tss_sub.Text.Length);
                //        return;
                //    }
                //    else
                //    {
                //        if (tss_sub != "")
                //        {
                //            update += " , TSS_sub = " + tss_sub + "";

                //        }
                //        else
                //        {
                //            update += " , TSS_sub = NULL ";
                //        }
                //    }
                //}

                //string tss_main = txt_tss_main.Text;
                //if (tss_main != Old_data.TSS_main)
                //{
                //    if (System.Text.RegularExpressions.Regex.IsMatch(txt_tss_main.Text, "[^0-9]"))
                //    {
                //        lb_error2.InnerText = "Please enter TSS-Main only numbers.";
                //        txt_tss_main.Text = txt_tss_main.Text.Remove(txt_tss_main.Text.Length - txt_tss_main.Text.Length);
                //        return;
                //    }
                //    else
                //    {
                //        if (tss_main != "")
                //        {
                //            update += ", TSS_Main = " + tss_main + "";

                //        }
                //        else
                //        {
                //            update += ", TSS_Main = NULL ";
                //        }

                //    }
                //}

                string touch = ddl_touch.SelectedValue.ToString();
                if (touch != Old_data.touch_status)
                {
                    update += "  , touch_status = N'" + touch + "'";
                }

                string risk = ddl_risk.SelectedValue.ToString();
                if (risk != Old_data.risk_status)
                {
                    update += "  , risk_status = N'" + risk + "'";
                }

                string detail = txt_replace(txt_detail.Text.Trim());

                try
                {
                    string sql_str = "";

                    if (update != "")  //|| detail != ""
                    {
                        ////Update Promblem
                        sql_str += Update_jtPM_problem(update);
                    }

                    if (detail != "")
                    {
                        ////Insert detail promblem
                        sql_str += Insert_detail(detail);

                    }

                    if (sql_str != "")
                    {
                        // test1.Text += sql_str ; return;
                        dc.RunCommand(conn, sql_str);
                    }

                    Bind_data();

                }
                catch (Exception ex)
                {
                    sendMail_error("JigTool", "PM_problem_follow_New.aspx", "btn_summit_Click>>IN To Database  ", ex.Message);
                }

                try
                {
                    Excel_WriteProblem(hd_pmProblem_name.Value.ToString(), txt_probTopic.Text);
                }
                catch (Exception ex)
                {
                    sendMail_error("JigTool", "PM_problem_follow_New.aspx", "btn_summit_Click>>Excel_WriteProblem ", ex.Message);
                }

                alert_completed_reload();

            }
            else
            {

            }
        }
        protected void btn_detail_Click(object sender, EventArgs e)
        {
            string PM_problem_name = Request.QueryString["PM_problem_name"].ToString();
            string PM_problem_id = Request.QueryString["pm_problem_id"].ToString();
            string tool_id = Request.QueryString["tool_id"].ToString();
            string url = "PM_problem_Deail.aspx?pm_problem_id=" + PM_problem_id + "&pm_problem_name=" + PM_problem_name + "&tool_id=" + tool_id;
            sb.Append(@"<script type='text/javascript'>");
            sb.Append("window.open('" + url + "','_blank');");
            sb.Append(@"</script>");
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "closemodal", sb.ToString(), false);


        }


        // ******* GridView History PM Problem Detail **********//
        protected void Brid_problem_detail()
        {

            string year = DateTime.Now.Year.ToString();
            string PM_problem_id = Request.QueryString["pm_problem_id"].ToString();
            string pm_problem_name = Request.QueryString["pm_problem_name"].ToString();
            string str = "";

            str += "   select A.detail_id,A.PM_Problem_id,A.prob_detail ,CONVERT(varchar,A.add_date,106) as date ,  ";
            str += "   A.emp_id,REPLACE(REPLACE(B.fname, 'Mr.', ''), 'Ms.', '') + ' ' + SUBSTRING(B.lname, 1, 1) + '.' AS add_by  ";
            str += "   ,C.PM_problem_name ";
            str += "   from jtPM_detail_problem_his A  ";
            str += "   left join user_master.dbo.sys_user_master B on A.emp_id = B.emp_id  ";
            str += "   left join jtPM_problem C on A.PM_Problem_id = C.PM_problem_id  and C.PM_problem_name = A.PM_problem_name ";
            str += "   where A.PM_Problem_id = " + PM_problem_id + "  and  A.PM_problem_name ='" + pm_problem_name + "'  order by A.add_date OPTION(RECOMPILE) ";

            dc.QryDT(conn, str);

            if (dc.dt.Rows.Count > 0)
            {
                gv_problemDetail.DataSource = dc.dt;
                gv_problemDetail.DataBind();
            }

        }
        protected void gv_problemDetail_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            string emp_id = Session["emp_id"].ToString();
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                LinkButton btn_delete = (LinkButton)e.Row.FindControl("btn_delete");

                if (emp_id == "016148" || emp_id == "001566")
                {
                    btn_delete.CssClass = "btn";
                }
                else
                {
                    btn_delete.CssClass = "btn disabled";
                }
            }
        }
        protected void gv_problemDetail_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gv_problemDetail.EditIndex = -1;
            Brid_problem_detail();
        }
        protected void gv_problemDetail_RowEditing(object sender, GridViewEditEventArgs e)
        {
            Brid_problem_detail();
            gv_problemDetail.EditIndex = e.NewEditIndex;

        }
        protected void gv_problemDetail_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            Label lb_detail = (Label)gv_problemDetail.Rows[e.RowIndex].FindControl("lb_detail");
            TextBox txt_edit = (TextBox)gv_problemDetail.Rows[e.RowIndex].FindControl("txt_edit");
            HiddenField hd_detail_id = (HiddenField)gv_problemDetail.Rows[e.RowIndex].FindControl("hd_detail_id");

            lb_test.Text = txt_edit.Text + "//" + hd_detail_id.Value;
            gv_problemDetail.EditIndex = -1;
            Brid_problem_detail();
        }
        protected void btn_delete_Click(object sender, EventArgs e)
        {
            GridViewRow row = (sender as LinkButton).NamingContainer as GridViewRow;
            HiddenField hd_detail_id = (HiddenField)row.FindControl("hd_detail_id");
            if (hd_detail_id.Value != "")
            {
                string delete = " DELETE FROM [dbo].[jtPM_detail_problem_his] WHERE detail_id = " + hd_detail_id.Value.ToString();
                dc.RunCommand(conn, delete);

                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                sb.Append(@"<script type='text/javascript'>");
                sb.Append("alert('Completed.');");
                sb.Append(@"</script>");
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "closemodal", sb.ToString(), false);
                Bind_data();
                return;
            }
        }
        protected DataTable Create_gvDetail()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add(new DataColumn("detail_id", typeof(string)));
            dt.Columns.Add(new DataColumn("lb_detail", typeof(string)));
            dt.Columns.Add(new DataColumn("lb_picAdd", typeof(string)));
            dt.Columns.Add(new DataColumn("lb_date", typeof(string)));

            return dt;
        }
        protected void update_detail(string hd_id, string txt_detail)
        {
            string update = "";
            //string str = "select* from jtPM_detail_problem_his where detail_id = " + hd_id;
            //dc.QryDT(conn, str);
            //if (dc.dt.Rows.Count > 0)
            //{
            update = "update jtPM_detail_problem_his set [prob_detail] = '" + txt_detail + "' where detail_id = " + hd_id;

            // }
            if (update != "")
            {
                dc.RunCommand(conn, update);
            }
        }
        protected void btn_Edit_Click(object sender, EventArgs e)
        {
            GridViewRow row = (sender as LinkButton).NamingContainer as GridViewRow;
            // DataTable tb_detail = Brid_problem_detail();
            gv_problemDetail.EditIndex = row.RowIndex;
            gv_problemDetail.ShowFooter = false;


            //DataTable tb = Create_gvDetail();
            //DataRow dr = null;

            //for (int i = 0; i < gv_problemDetail.Rows.Count; i++)
            //{dr = tb.NewRow();
            //    if (i != row.RowIndex)
            //    {

            //        HiddenField hd_detail_id = (HiddenField)gv_problemDetail.Rows[i].FindControl("hd_detail_id");
            //        Label lb_detail = (Label)gv_problemDetail.Rows[i].FindControl("lb_detail");
            //        Label lb_picAdd = (Label)gv_problemDetail.Rows[i].FindControl("lb_picAdd");
            //        Label lb_date = (Label)gv_problemDetail.Rows[i].FindControl("lb_date");

            //        dr["detail_id"] = hd_detail_id.Value;
            //        dr["lb_detail"] = lb_detail.Text;
            //        dr["lb_picAdd"] = lb_picAdd.Text;
            //        dr["lb_date"] = lb_date.Text;

            //    }
            //    tb.Rows.Add(dr);
            //}
            //Label lb_detail = (Label)gv_problemDetail.Rows[row.RowIndex].FindControl("lb_detail");
            //string txtEdit = lb_detail.Text;// tb_detail.Rows[row.RowIndex]["prob_detail"].ToString();
            //lb_test.Text = txtEdit;
            //TextBox txt_edit = (TextBox)gv_problemDetail.Rows[row.RowIndex].FindControl("txt_edit");
            ////txt_edit.Text = "";
        }


        // ************** Create Excel File **********************//
        protected void GET_PICTURE(string PRC_problem_name)
        {

            ViewState["pic1"] = "";
            ViewState["pic2"] = "";
            ViewState["pic_action"] = "";

            string pm_problem_no = PRC_problem_name;
            string[] str_split = pm_problem_no.Split('-');
            string year = str_split[1];
            string thisYear = DateTime.Now.Year.ToString();
            year = thisYear.Substring(0, 2) + year;

            string FolderPath = String.Format(@"\\cptfile02\Pro\PRJ2015009\01_PM History\02_PM Problem\{0}\{1}\Pictrue\", year, pm_problem_no);
            //string FolderShow = String.Format(@"img_problem/{0}/", year);
            string FolderShow = String.Format(@"img_problem/{0}/{1}/Pictrue/", year, pm_problem_no);

            string[] pic1 = Directory.GetFiles(FolderPath, "PIC1_NG.jpg", SearchOption.TopDirectoryOnly);
            string[] pic2 = Directory.GetFiles(FolderPath, "PIC2_NG.jpg", SearchOption.TopDirectoryOnly);
            string[] pic3 = Directory.GetFiles(FolderPath, "PIC1_OK.jpg", SearchOption.TopDirectoryOnly);

            if (pic1.Length > 0)
            {
                // img_pic1.ImageUrl = FolderShow + "PIC1_NG.jpg";
                ViewState["pic1"] = FolderPath + "PIC1_NG.jpg";
            }

            if (pic2.Length > 0)
            {
                // img_pic2.ImageUrl = FolderShow + "PIC2_NG.jpg";
                ViewState["pic2"] = FolderPath + "PIC2_NG.jpg";
            }


            if (pic3.Length > 0)
            {
                // int row = pic3.Length-1;
                //FileInfo f = new FileInfo(pic3[row]);
                // img_pic_action.ImageUrl = FolderShow + "PIC1_OK.jpg";
                ViewState["pic_action"] = FolderPath + "PIC1_OK.jpg";
            }

        }
        protected void Excel_Write(string new_fullfile, string PRC_problem_name)
        {
            // DataTable tb_excel = null;
            //gv_test.DataSource = tb_excel;
            // gv_test.DataBind();
            var workbook = new XLWorkbook(new_fullfile);
            var worksheet = workbook.Worksheet("Form_report");


            worksheet.Cell("Y1").Value = txt_issue.Text.ToString();
            worksheet.Cell("AH1").Value = PRC_problem_name;// hd_pmProblem_name.Value.ToString();
            worksheet.Cell("D2").Value = txt_toolno.Text.Trim();
            //worksheet.Cell("Q2").Value = tb_excel.Rows[0]["tool_rank"].ToString();
            worksheet.Cell("Y2").Value = txt_problemDate.Text.ToString();
            worksheet.Cell("D3").Value = hd_tool_name.Value.ToString();
            worksheet.Cell("Y3").Value = txt_toolsub_id.Text.ToString();
            worksheet.Cell("AH3").Value = ddl_priority.SelectedItem.ToString();
            worksheet.Cell("D4").Value = txt_Model.Text.ToString();
            worksheet.Cell("N4").Value = txt_Location.Text.ToString();
            worksheet.Cell("Y4").Value = txt_Fixasset.Text.ToString();
            worksheet.Cell("D5").Value = txt_probTopic.Text.ToString();
            worksheet.Cell("R6").Value = (txt_planFinish.Text == "" ? "" : txt_planFinish.Text);
            worksheet.Cell("Y5").Value = lb_actual.Text.ToString();
            worksheet.Cell("AH6").Value = (txt_actualFinish.Text == "" ? "" : txt_actualFinish.Text);
            worksheet.Cell("M8").Value = lb_spec.Text.ToString();
            worksheet.Cell("M9").Value = lb_actual.Text.ToString();
            worksheet.Cell("M10").Value = lb_detailProblem.Text.ToString();
            worksheet.Cell("X8").Value = lb_result_spec.Text.ToString();
            worksheet.Cell("X9").Value = lb_result_detail.Text.ToString();

            string issue_date = hd_issue_date.Value.ToString();

            worksheet.Cell("AH28").Value = hd_issue.Value.ToString();// (ddl_pic1.SelectedItem.ToString() == "" ? "" : ddl_pic1.SelectedItem.ToString());
            worksheet.Cell("AH30").Value = issue_date;

            string toolOwner_appove = hd_toolOwner_appove.Value.ToString();

            string toolOwner_date = hd_toolOwner_date.Value.ToString();
            worksheet.Cell("AD28").Value = toolOwner_appove;
            worksheet.Cell("AD30").Value = toolOwner_date;


            string leader_appove = hd_leder_appove.Value.ToString();
            string leader_date = hd_leder_date.Value.ToString();
            worksheet.Cell("Z28").Value = leader_appove;
            worksheet.Cell("Z30").Value = leader_date;

            string mgr_appove = hd_mgr_appove.Value.ToString();
            string mgr_date = hd_mgr_date.Value.ToString();
            worksheet.Cell("V28").Value = mgr_appove;
            worksheet.Cell("V30").Value = mgr_date;

            ////Picture
            int MAX_WIDTH = 220;
            int MAX_HEIGHT = 220;

            string pic1 = ViewState["pic1"].ToString();
            if (pic1 != "")
            {
                var image_pic1 = worksheet.AddPicture(pic1);
                Double xRatio = (double)image_pic1.Width / MAX_WIDTH;
                Double yRatio = (double)image_pic1.Height / MAX_HEIGHT;
                Double ratio = Math.Max(xRatio, yRatio);
                int nnx = (int)Math.Floor(image_pic1.Width / ratio);
                int nny = (int)Math.Floor(image_pic1.Height / ratio);

                double cellWidth = 270;
                double cellHeight = 226;
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
                image_pic1.MoveTo(worksheet.Cell("A8"), Convert.ToInt32(leftMargin), Convert.ToInt32(topMargin)).WithSize(nnx, nny);

            }

            MAX_WIDTH = 450;
            MAX_HEIGHT = 280;

            string pic2 = ViewState["pic2"].ToString();
            if (pic2 != "")
            {
                var image_pic2 = worksheet.AddPicture(pic2);
                Double xRatio = (double)image_pic2.Width / MAX_WIDTH;
                Double yRatio = (double)image_pic2.Height / MAX_HEIGHT;
                Double ratio = Math.Max(xRatio, yRatio);
                int nnx = (int)Math.Floor(image_pic2.Width / ratio);
                int nny = (int)Math.Floor(image_pic2.Height / ratio);

                double cellWidth = 513;
                double cellHeight = 322;
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

                image_pic2.MoveTo(worksheet.Cell("B19"), Convert.ToInt32(leftMargin), Convert.ToInt32(topMargin)).WithSize(nnx, nny);

            }

            MAX_WIDTH = 360;
            MAX_HEIGHT = 250;

            string pic_action = ViewState["pic_action"].ToString();

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

            workbook.Save();

        }
        protected void Excel_WriteProblem(string PRC_problem_name, string result)
        {
            string year = txt_problemDate.Text.Substring(7, 4);
            // string PM_PROBLEM_TEMPLATE = @"\\cptfile02\Pro\PRJ2015009\01_PM History\02_PM Problem\" + year + "\\" + PRC_problem_name + "\\Temp\\" + PRC_problem_name + ".xlsx";
            string PM_PROBLEM_TEMPLATE = @"\\cptfile02\Pro\PRJ2016017\10_Tooling Management Control System\00_System\Template\PM_Problem_Format_Rev04.xlsx";

            string year_folder = @"\\cptfile02\Pro\PRJ2015009\01_PM History\02_PM Problem\" + year;

            if (Directory.Exists(year_folder) == false)
            {
                Directory.CreateDirectory(year_folder);
            }

            string destination_folder = year_folder + @"\" + PRC_problem_name;
            if (Directory.Exists(destination_folder) == false)
            {
                Directory.CreateDirectory(destination_folder);
            }

            string new_fullfile = destination_folder + @"\" + PRC_problem_name + ".xlsx";

            File.Copy(PM_PROBLEM_TEMPLATE, new_fullfile, true);

            //string new_fullfile_backup = destination_folder + @"\" + PRC_problem_name + "_Backup.xlsx";  
            GET_PICTURE(PRC_problem_name);
            // Write the problem file 

            Excel_Write(new_fullfile, PRC_problem_name);
            return;
            //WriteExcelProblem(new_fullfile, PRC_problem_name, result);

            // problem file backup
            //WriteExcelProblem(new_fullfile_backup, PRC_problem_name, result);

        }

        private Boolean CheckInvalid()
        {
            Boolean Iserror = false;
            // isOnPlan
            Boolean Iserror_isOnPlan = CheckInvalid_isOnPlan(ddl_isOnplan);
            Iserror = Iserror || Iserror_isOnPlan;

            //On plan
            if (ddl_isOnplan.SelectedValue == "1")
            {
                Boolean iserror_resp_name = CheckValid_DropDownList(ddl_pic1);
                Iserror = Iserror || iserror_resp_name;
            }

            //Delay
            if (ddl_isOnplan.SelectedValue == "2")
            {
                Boolean iserror_resp_name = CheckValid_DropDownList(ddl_pic1);
                Iserror = Iserror || iserror_resp_name;
            }

            return Iserror;
        }
        private Boolean CheckValid_DropDownList(DropDownList ddl)
        {
            if (ddl.SelectedValue == "")
            {
                ddl.CssClass = " form-control h40 red-border";
                //error_acknowledge.Text = "Please click Acknowledge button.";
                return true;
            }
            else
            {
                ddl.CssClass = "form-control h40";
                return false;
            }
        }
        private Boolean CheckInvalid_isOnPlan(DropDownList var)
        {
            if (var.SelectedValue == "")
            {
                var.CssClass = "form-control h40 red-border";
                return true;
            }
            else
            {
                var.CssClass = "form-control h40";
                return false;
            }
        }


        //protected void Get_Acknowledge()
        //{
        //    string problem_name = hd_pmProblem_name.Value.ToString();

        //    string select = "";
        //    select += " select pic, user_name+' ' + SUBSTRING(lname, 1, 1) + '.' as name,  ";
        //    select += " format(acknowledge_date, 'dd-MMM-yyyy') as date_ ";
        //    select += " from jtPM_problem a ";
        //    select += " left join user_master.dbo.sys_user_master s on a.acknowledge_by = s.emp_id ";
        //    select += " where PM_problem_name = N'" + problem_name + "' and a.acknowledge_by is not null ";

        //    //txt_tss_comment.InnerText = select;
        //    //return;
        //    dc.QryDT(conn, select);

        //    if (dc.dt.Rows.Count > 0)
        //    {
        //        gv_acknowledge.DataSource = dc.dt;
        //        gv_acknowledge.DataBind();

        //    }

        //}


        //--------Download Problem Sheet ------//
        protected void btn_download_report_Click(object sender, EventArgs e)
        {
            string problem_name = hd_pmProblem_name.Value.ToString();
            string select = "select PM_problem_id,PM_problem_name, PRC_Grop_name from PM_Tool_History  where PM_problem_name = '" + problem_name + "'";

            dc.QryDT(conn, select);
            string PRC_Group_name = dc.dt.Rows[0]["PRC_Grop_name"].ToString();
            DateTime enteredDate = DateTime.Parse(txt_problemDate.Text);
            string year = enteredDate.Year.ToString();
            //string year = txt_problemDate.Text.Substring(7, 4);
            string folder = @"\\cptfile02\Pro\PRJ2015009\01_PM History\01_PM Check Sheet\" + year + @"\" + PRC_Group_name;
            string full_path = folder + @"\" + PRC_Group_name + ".xlsx";

            FileInfo file_in = new FileInfo(full_path);

            if (file_in.Exists)
            {
                WebClient req = new WebClient();
                HttpResponse response = HttpContext.Current.Response;
                response.Clear();
                response.ClearContent();
                response.ClearContent();
                response.Buffer = true;
                response.AddHeader("Content-Disposition", "attachment;filename=\"" + file_in.Name + " ");
                byte[] data = req.DownloadData(full_path);
                response.BinaryWrite(data);
                response.End();
            }

            //lb_text.Text = select;

        }

        //--------Download Problem Sheet Status 'Acknowledge' ------//
        static DataTable ConvertListToDataTable(List<string[]> list)
        {
            DataTable table = new DataTable();

            int columns = 0;
            foreach (var array in list)
            {
                if (array.Length > columns)
                {
                    columns = array.Length;
                }
            }


            for (int i = 0; i < columns; i++)
            {
                table.Columns.Add();
            }

            foreach (var array in list)
            {
                table.Rows.Add(array);
            }

            return table;
        }
        protected void btn_cancel_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.RawUrl);
        }

        //------------------- Button 'Back' --------------------//
        protected void btn_back_Click(object sender, EventArgs e)
        {
            if (Request.QueryString["prom"] != null)
            {
                //   lb_test.Text = "problem list";
                Response.Redirect("jt_problem_his_master.aspx");
            }
            else
            {
                // Response.Redirect(" window.close();");
                //// lb_test.Text = "win close ";
                sb.Append(@"<script type='text/javascript'>");
                sb.Append("window.close();");
                sb.Append(@"</script>");
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "closemodal", sb.ToString(), false);
            }
        }


        //******************** SEND E-MAIL ********************//
        public string Get_Name(string emp_id)
        {
            string name = "";
            string str = "select REPLACE(REPLACE(fname,'Ms.',''),'Mr.','') + ' ' + SUBSTRING(lname,1,1) + '.' as name from user_master.dbo.sys_user_master where emp_id = '" + emp_id + "'";
            dc.QryDT(conn, str);
            if (dc.dt.Rows.Count > 0)
            {
                name = dc.dt.Rows[0][0].ToString();
            }

            return name;
        }
        protected string getNameMail_byGroup(string Group_name)
        {
            string Group = "";
            switch (Group_name)
            {
                //ENG3
                case "M":
                    Group = "ENG3-Mechanic";
                    break;
                case "E":
                    Group = "ENG3-Electric";
                    break;
                case "S":
                    Group = "ENG3-System";
                    break;
                case "Laser":
                    Group = "ENG3-Laser";
                    break;
                case "FLW":
                    Group = "ENG3-Laser";
                    break;
                case "MMC":
                    Group = "ENG3-Man Machine";
                    break;
                //ENG4
                case "AGV":
                    Group = "ENG4 AGV";
                    break;
                case "PM":
                    Group = "ENG4 PM";
                    break;
                case "Chie_tech":
                    Group = "ENG4 Chie_tech";
                    break;

            }

            return Group;

        }
        protected string Get_dept_ID(string group_name)
        {
            string dept_id = "";
            switch (group_name)
            {
                case "M":
                    dept_id = "3"; break;
                case "S":
                    dept_id = "3"; break;
                case "E":
                    dept_id = "3"; break;
                case "MMC":
                    dept_id = "3"; break;
                case "Laser":
                    dept_id = "3"; break;
                case "PM":
                    dept_id = "5"; break;
                case "AGV":
                    dept_id = "5"; break;
                case "Chie_tech":
                    dept_id = "5"; break;
            }
            return dept_id;
        }
        //-------------------- status New problem -------------------------//
        protected void SendEmail_NewProblem(DataTable dt)
        {
            Get_mail_PDE get_mail = new Get_mail_PDE();
            MailMessage mail = new MailMessage();
            mail.From = new MailAddress("engineer_pde@mail.canon");

            string EMP_ID = Session["emp_id"].ToString();
            string dept_id = "";
            string Issue = "";
            string url = "";

            DataTable dt_pic = new DataTable();
            DataTable dt_cc = new DataTable();
            DataTable dt_cc_PM = new DataTable();
            DataTable dt_leader = new DataTable();
            DataTable dt_CheckBy = new DataTable();
            DataTable dt_owner = new DataTable();
            DataTable dt_Issue = new DataTable();
            DataTable dt_resp = new DataTable();
            DataTable dt_Ast = new DataTable();

            if (Is_TestSystem())
            {
                url = "http://cptsvs552.canon-pt.co.th/jig_tool_system_test/PM_problem_follow_New.aspx?";
            }
            else
            {
                url = "http://cptsvs552.canon-pt.co.th/jig_tool_system/PM_problem_follow_New.aspx?";

                for (int i = 0; i < dt.Rows.Count; i++)
                {

                    if (dt.Rows[i][4].ToString() != "")
                    {
                        ////E-mail To (resp. group) j2up by group
                        dt_pic = get_mail.GetMailJ2_ByGroup(dt.Rows[i][4].ToString());

                        if (dt_pic.Rows.Count > 0)
                        {
                            for (int l = 0; l < dt_pic.Rows.Count; l++)
                            {
                                //lb_test.Text += "j2up resp group TO --> " + l + ". " + dt_pic.Rows[l]["email"].ToString() + "<br/>";
                                mail.To.Add(dt_pic.Rows[l]["email"].ToString());
                            }
                        }

                        ////E-mail CC (resp. group) Ast.mgr  by dept
                        dept_id = Get_dept_ID(dt.Rows[i][4].ToString());

                        dt_Ast = get_mail.GetMail_Ast(dept_id);
                        if (dt_Ast.Rows.Count > 0)
                        {
                            for (int l = 0; l < dt_Ast.Rows.Count; l++)
                            {
                                //lb_test.Text +=  " CC Ast --> " + l + ". " + dt_Ast.Rows[l]["email"].ToString() + "<br/>";
                                mail.CC.Add(dt_Ast.Rows[l]["email"].ToString());
                            }
                        }

                        ////GetMail Tool Owner
                        dt_owner = get_mail.GetMailJ2_ByGroup(dt.Rows[i][3].ToString());

                        if (dt_owner.Rows.Count > 0)
                        {
                            for (int t = 0; t < dt_owner.Rows.Count; t++)
                            {
                                // lb_test.Text += " Owner CC --> " + t + " . " + dt_owner.Rows[t]["email"].ToString() + "<br />";
                                mail.CC.Add(dt_owner.Rows[t]["email"].ToString());
                            }
                        }
                        ////GetMail - Rasp.Name
                        //#region
                        //string mail_rasp = get_mail.GetMail_ByMember(dt.Rows[i][7].ToString());

                        //if (mail_rasp != "")
                        //{
                        //    mail.To.Add(mail_rasp);
                        //    // lb_test.Text += " Person To -->  . " + mail_rasp + "<br />";
                        //}
                        //#endregion 
                    }

                    if (Issue.Trim() != dt.Rows[i][6].ToString())
                    {
                        #region
                        //GetMail  Issue 
                        string emailIssue = get_mail.GetMail_ByMember(dt.Rows[i][6].ToString());
                        if (emailIssue != "")
                        {
                            mail.CC.Add(emailIssue);
                            //lb_test.Text += "  Issue CC -->  . " + emailIssue + "<br />";
                        }
                        #endregion                      
                    }

                }



                if (dt.Rows[0][4].ToString() == "AGV")
                {
                    dt_cc_PM = get_mail.GetMailJ2_ByGroup("AGV");
                    if (dt_cc_PM.Rows.Count > 0)
                    {
                        for (int n = 0; n < dt_cc_PM.Rows.Count; n++)
                        {
                            // lb_test.Text += " PM *CC -->" + n + ". " + dt_cc_PM.Rows[n]["email"].ToString() + "<br />";
                            mail.CC.Add(dt_cc_PM.Rows[n]["email"].ToString());
                        }
                    }

                }
                else
                {
                    ////E-mail CC J2 up PM 
                    dt_cc_PM = get_mail.GetMail_PM("1");

                    if (dt_cc_PM.Rows.Count > 0)
                    {
                        for (int n = 0; n < dt_cc_PM.Rows.Count; n++)
                        {
                            // lb_test.Text += " PM *CC -->" + n + ". " + dt_cc_PM.Rows[n]["email"].ToString() + "<br />";
                            mail.CC.Add(dt_cc_PM.Rows[n]["email"].ToString());
                        }
                    }
                }


            }


            mail.Bcc.Add("kanokorn@mail.canon");
            mail.Bcc.Add("anirut@mail.canon");

            SmtpClient client = new SmtpClient();
            client.Port = 25;
            client.DeliveryMethod = SmtpDeliveryMethod.Network;
            client.Host = "150.61.249.70";

            mail.Subject = "[Acknowledge] New Problem ";

            string mail_content = "";

            //mail_content += "ขณะนี้กำลังอยู่ในกระบวนการทดสอบระบบ กรุณาอย่าตกใจ หากได้รับ E-Mail ^^";
            mail_content += Environment.NewLine;
            mail_content += "Dear. " + getNameMail_byGroup(dt.Rows[0][4].ToString());
            mail_content += Environment.NewLine + Environment.NewLine + Environment.NewLine;
            mail_content += "There is a new problem Issue. Please acknowledgment on the System.";
            mail_content += Environment.NewLine;
            mail_content += "      Problem : " + dt.Rows.Count + " Item";
            mail_content += Environment.NewLine;

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                mail_content += "              " + dt.Rows[i][0].ToString() + "   Date : " + dt.Rows[i][7].ToString() + "  Resp.Group : " + dt.Rows[i][4].ToString();
                mail_content += Environment.NewLine;

            }

            mail_content += Environment.NewLine + Environment.NewLine + Environment.NewLine;
            mail_content += "           *Problem History System : " + url + "pm_problem_id=" + dt.Rows[0][1].ToString() + "&pm_problem_name=" + dt.Rows[0][0].ToString() + "&tool_id=" + dt.Rows[0][8].ToString();
            mail_content += Environment.NewLine;
            mail_content += "           ** You can check detail problem on system link";

            mail_content += Environment.NewLine + Environment.NewLine;

            string signature;
            signature = Environment.NewLine + Environment.NewLine;
            signature += "************************************************";
            signature += Environment.NewLine;
            signature += "This auto-email was sent from Jig Tool system.";
            signature += Environment.NewLine;
            signature += "Best regard.";
            signature += Environment.NewLine;
            signature += "--------------------- Original Message Ends --------------------";
            signature += Environment.NewLine;
            signature += "************************************************";

            mail.Body = mail_content + signature;

            client.Send(mail);
            System.Diagnostics.Debug.WriteLine(mail_content + signature);
            //lb_test_modal.Text = mail_content + signature;

        }
        //-------------------- status Acknowledge -------------------------//
        protected void SendEmail_Acknowledge(DataTable dt)
        {
            Get_mail_PDE get_mail = new Get_mail_PDE();
            MailMessage mail = new MailMessage();
            mail.From = new MailAddress("engineer_pde@mail.canon");

            string EMP_ID = Session["emp_id"].ToString();
            string test_mail = "";
            string url = "";

            DataTable dt_pic = new DataTable();
            DataTable dt_cc = new DataTable();
            DataTable dt_cc_PM = new DataTable();
            DataTable dt_acknowledge = new DataTable();
            DataTable dt_CheckBy = new DataTable();
            DataTable dt_owner = new DataTable();

            if (Is_TestSystem())
            {
                url = "http://cptsvs552.canon-pt.co.th/jig_tool_system_test/PM_problem_follow_New.aspx?";
            }
            else
            {
                url = "http://cptsvs552.canon-pt.co.th/jig_tool_system/PM_problem_follow_New.aspx?";


                ////GetMail  Issue 
                if (dt.Rows[0][7].ToString().Trim() != "" && dt.Rows[0][7].ToString().Trim() != null)
                {
                    string select_emailIssue = get_mail.GetMail_ByMember(dt.Rows[0][7].ToString());// "select REPLACE(REPLACE(fname,'Ms.',''),'Mr.','') + ' ' + SUBSTRING(lname,1,1) + '.' as name,email from user_master.dbo.sys_user_master where emp_id = '" + dt.Rows[0][8].ToString().Trim() + "'";

                    if (select_emailIssue != "")
                    {
                        mail.CC.Add(select_emailIssue);
                        // test_mail += "  Issue To -->  . " + select_emailIssue + "<br />";

                    }
                }

                //GetMail  Person resp.name
                string select_emailPerson = get_mail.GetMail_ByMember(dt.Rows[0][5].ToString()); //  "select REPLACE(REPLACE(fname,'Ms.',''),'Mr.','') + ' ' + SUBSTRING(lname,1,1) + '.' as name,email from user_master.dbo.sys_user_master where emp_id = '" + dt.Rows[0][7].ToString().Trim() + "'";


                if (select_emailPerson != "")
                {
                    mail.To.Add(select_emailPerson);
                    //test_mail += "  Person  To -->  . " + select_emailPerson + "<br />";

                }

                ////E-mail CC J2 up PM 
                dt_cc_PM = get_mail.GetMail_PM("1");

                if (dt_cc_PM.Rows.Count > 0)
                {
                    for (int n = 0; n < dt_cc_PM.Rows.Count; n++)
                    {
                        // test_mail += " PM *CC -->" + n + ". " + dt_cc_PM.Rows[n]["email"].ToString() + "<br />";
                        mail.CC.Add(dt_cc_PM.Rows[n]["email"].ToString());
                    }
                }
            }

            mail.Bcc.Add("kanokorn@mail.canon");
            mail.Bcc.Add("anirut@mail.canon");

            //  lb_text.Text += test_mail;

            ///Get Name Acknower
            #region
            string select_email = "select REPLACE(REPLACE(fname,'Ms.',''),'Mr.','') + ' ' + SUBSTRING(lname,1,1) + '.' as name,email from user_master.dbo.sys_user_master where emp_id = '" + EMP_ID + "'";
            dc.QryDT(conn, select_email);
            dt_acknowledge = dc.dt;
            #endregion


            SmtpClient client = new SmtpClient();
            client.Port = 25;
            client.DeliveryMethod = SmtpDeliveryMethod.Network;
            client.Host = "150.61.249.70";

            mail.Subject = "[Follow Up]  " + dt.Rows[0][1].ToString();

            string mail_content = "";

            //mail_content += "ขณะนี้กำลังอยู่ในกระบวนการทดสอบระบบ กรุณาอย่าตกใจ หากได้รับ E-Mail ^^";
            mail_content += Environment.NewLine;

            mail_content += "Dear Resp.Person : " + dt.Rows[0][6].ToString();
            mail_content += Environment.NewLine + Environment.NewLine + Environment.NewLine;
            mail_content += "There is a new problem Issue. Please follow up Problem.";
            mail_content += Environment.NewLine;
            mail_content += "      Problem :    " + dt.Rows[0][1].ToString();
            mail_content += Environment.NewLine;

            mail_content += "           Tool No :   " + dt.Rows[0][2].ToString(); ;
            mail_content += Environment.NewLine;
            mail_content += "           Plan Finish :   " + dt.Rows[0][3].ToString();
            mail_content += Environment.NewLine;
            mail_content += "           Assign by :     " + dt_acknowledge.Rows[0]["name"].ToString() + "   Date : " + DateTime.Now.ToString("dd-MMM-yyyy");
            mail_content += Environment.NewLine;
            mail_content += Environment.NewLine;

            mail_content += Environment.NewLine + Environment.NewLine + Environment.NewLine;
            mail_content += "           *Problem History System : " + url + "pm_problem_id=" + dt.Rows[0][0].ToString() + "&pm_problem_name=" + dt.Rows[0][1].ToString() + "&tool_id=" + dt.Rows[0][8].ToString();
            mail_content += Environment.NewLine;
            mail_content += "           ** You can check detail problem on system link";

            mail_content += Environment.NewLine + Environment.NewLine;


            string signature;
            signature = Environment.NewLine + Environment.NewLine;
            signature += "************************************************";
            signature += Environment.NewLine;
            signature += "This auto-email was sent from Jig Tool system.";
            signature += Environment.NewLine;
            signature += "Best regard.";
            signature += Environment.NewLine;
            signature += "--------------------- Original Message Ends --------------------";
            signature += Environment.NewLine;
            signature += "************************************************";

            mail.Body = mail_content + signature;

            client.Send(mail);
            System.Diagnostics.Debug.WriteLine(mail_content + signature);
            //lb_test_modal.Text = mail_content + signature;
        }
        //-------------------- status on plan -------------------------//
        protected void SendEmail_PersonIncharge(DataTable dt)
        {
            Get_mail_PDE get_mail = new Get_mail_PDE();
            MailMessage mail = new MailMessage();
            mail.From = new MailAddress("engineer_pde@mail.canon");

            string test_mail = "";
            string url = "";
            DataTable dt_respName = new DataTable();
            DataTable dt_owner = new DataTable();
            DataTable dt_cc_PM = new DataTable();

            for (int i = 0; i < dt.Rows.Count; i++)
            {

                if (Is_TestSystem())
                {
                    url = "http://cptsvs552.canon-pt.co.th/jig_tool_system_test/PM_problem_follow_New.aspx?";
                }
                else
                {
                    url = "http://cptsvs552.canon-pt.co.th/jig_tool_system/PM_problem_follow_New.aspx?";

                    ////GetMail - Issue.Name
                    #region
                    string select_email = get_mail.GetMail_ByMember(dt.Rows[i][3].ToString());
                    if (select_email != "")
                    {
                        mail.To.Add(select_email);
                        // test_mail += "To Person Issue.Name -->  . " + select_email + " <br />";
                    }

                    ////GetMail - resp.Name
                    string resp_name = get_mail.GetMail_ByMember(dt.Rows[i][4].ToString());
                    if (resp_name != "")
                    {
                        mail.CC.Add(resp_name);
                        // test_mail += "CC Person resp.Name -->  . " + resp_name + " <br />";
                    }

                    ////GetMail Tool Owner j2 up by group
                    dt_owner = get_mail.GetMailJ2_ByGroup(dt.Rows[i][5].ToString());  //GetMailTo(dt.Rows[i][3].ToString());

                    if (dt_owner.Rows.Count > 0)
                    {
                        for (int t = 0; t < dt_owner.Rows.Count; t++)
                        {
                            // test_mail += " Owner CC --> " + t + " . " + dt_owner.Rows[t]["email"].ToString() + "<br />";
                            mail.CC.Add(dt_owner.Rows[t]["email"].ToString());
                        }
                    }

                    if (dt.Rows[i][5].ToString() == "AGV")
                    {
                        dt_cc_PM = get_mail.GetMailJ2_ByGroup("AGV");
                        if (dt_cc_PM.Rows.Count > 0)
                        {
                            for (int n = 0; n < dt_cc_PM.Rows.Count; n++)
                            {
                                // test_mail += " PM *CC -->" + n + ". " + dt_cc_PM.Rows[n]["email"].ToString() + "<br />";
                                mail.CC.Add(dt_cc_PM.Rows[n]["email"].ToString());
                            }
                        }
                    }
                    else
                    {
                        ////E-mail CC J2 up PM 
                        dt_cc_PM = get_mail.GetMail_PM("1");
                        if (dt_cc_PM.Rows.Count > 0)
                        {
                            for (int n = 0; n < dt_cc_PM.Rows.Count; n++)
                            {
                                // test_mail += " PM *CC -->" + n + ". " + dt_cc_PM.Rows[n]["email"].ToString() + "<br />";
                                mail.CC.Add(dt_cc_PM.Rows[n]["email"].ToString());
                            }
                        }
                    }
                    #endregion
                }

                //lb_test.Text += test_mail;
                //return;

                mail.To.Add("kanokorn@mail.canon");
                mail.Bcc.Add("anirut@mail.canon");
                SmtpClient client = new SmtpClient();
                client.Port = 25;
                client.DeliveryMethod = SmtpDeliveryMethod.Network;
                client.Host = "150.61.249.70";

                mail.Subject = "Please Check&Confirm for Close PM Problem";

                string mail_content = "";
                //mail_content += "ขณะนี้กำลังอยู่ในกระบวนการทดสอบระบบ กรุณาอย่าตกใจ หากได้รับ E-Mail ^^";
                mail_content += Environment.NewLine;
                mail_content += "Dear Issue Person";
                mail_content += Environment.NewLine;
                mail_content += Environment.NewLine;
                mail_content += ">> Please Check & Confirm for Close PM Problem";
                //mail_content += Environment.NewLine;
                //mail_content += "      Group : " + dt.Rows[i][3].ToString() + "";
                mail_content += Environment.NewLine;
                mail_content += "      Problem : " + dt.Rows.Count + " Item";
                mail_content += Environment.NewLine;

                mail_content += "      Problem No : " + dt.Rows[0][1].ToString() + "   Actual Finish : " + dt.Rows[0][6].ToString();
                mail_content += Environment.NewLine + Environment.NewLine;
                mail_content += "  *Problem History System : " + url + "pm_problem_id=" + dt.Rows[0][0].ToString() + "&pm_problem_name=" + dt.Rows[0][1].ToString() + "&tool_id=" + dt.Rows[0][2].ToString();


                mail_content += Environment.NewLine;
                mail_content += Environment.NewLine;
                mail_content += "  **You can check detail problem on system link.";

                string signature;
                signature = Environment.NewLine + Environment.NewLine;
                signature += "************************************************";
                signature += Environment.NewLine;
                signature += "This auto-email was sent from Jig Tool system.";
                signature += Environment.NewLine;
                signature += "Best regard.";
                signature += Environment.NewLine;
                signature += "--------------------- Original Message Ends --------------------";
                signature += Environment.NewLine;
                signature += "************************************************";

                mail.Body = mail_content + signature;

                // lb_test.Text += mail_content + signature;
                client.Send(mail);
                System.Diagnostics.Debug.WriteLine(mail_content + signature);
            }
        }
        //----------------- status send for check ---------------------//
        protected void SendEmail_IssuePerson(DataTable dt)
        {
            Get_mail_PDE get_mail = new Get_mail_PDE();
            MailMessage mail = new MailMessage();
            mail.From = new MailAddress("engineer_pde@mail.canon");

            string resp_group_old = "";
            string test_mail = "";
            string dept_id = "";
            string url = "";

            DataTable dt_respName = new DataTable();
            DataTable dt_owner = new DataTable();
            DataTable dt_cc_PM = new DataTable();
            DataTable dt_J3 = new DataTable();
            DataTable dt_Ast = new DataTable();
            DataTable dt_Admin = new DataTable();

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (Is_TestSystem())
                {
                    url = "http://cptsvs552.canon-pt.co.th/jig_tool_system_test/PM_problem_follow_New.aspx?";
                }
                else
                {
                    url = "http://cptsvs552.canon-pt.co.th/jig_tool_system/PM_problem_follow_New.aspx?";

                    #region
                    ////Get mail to Tool Owner J3       
                    //dt_J3 = get_mail.GetMail_J3(dt.Rows[i][6].ToString());
                    //if (dt_J3.Rows.Count > 0)
                    //{
                    //    for (int j = 0; j < dt_J3.Rows.Count; j++)
                    //    {
                    //        if (dt_J3.Rows[j]["email"].ToString() != "")
                    //        {
                    //            mail.To.Add(dt_J3.Rows[j]["email"].ToString());
                    //            // test_mail += " Tool Owner J3 -->  . " + dt_J3.Rows[j]["email"].ToString() + " <br />";

                    //        }
                    //    }
                    //}



                    ////GetMail - Rasp.Name

                    //string mail_rasp = get_mail.GetMail_ByMember(dt.Rows[i][4].ToString()); // "select email from user_master.dbo.sys_user_master where emp_id = '" + dt.Rows[i][6].ToString() + "'";
                    //if (mail_rasp != "")
                    //{
                    //    mail.CC.Add(mail_rasp);
                    //    //test_mail += " Person Rasp.Name -->  . " + mail_rasp + " <br />";
                    //}

                    /////GetMail Issue name
                    //string issue_name = get_mail.GetMail_ByMember(dt.Rows[i][3].ToString());
                    //if (issue_name != "")
                    //{
                    //    mail.CC.Add(issue_name);
                    //    // test_mail += " Person Issue.Name -->  . " + issue_name + " <br />";

                    //}

                    ////GetMail  Tool Owner [sr.J2 To J3]
                    dt_owner = get_mail.GetMailJ2_ByGroup(dt.Rows[i][6].ToString());

                    if (dt_owner.Rows.Count > 0)
                    {
                        for (int t = 0; t < dt_owner.Rows.Count; t++)
                        {
                            // test_mail += " sr.J2 To J3 CC --> " + t + " . " + dt_owner.Rows[t]["email"].ToString() + "<br />";
                            mail.CC.Add(dt_owner.Rows[t]["email"].ToString());
                        }
                    }


                    //if (dt.Rows[i][6].ToString() == "AGV")
                    //{
                    //    dt_cc_PM = get_mail.GetMailJ2_ByGroup("AGV");
                    //    if (dt_cc_PM.Rows.Count > 0)
                    //    {
                    //        for (int n = 0; n < dt_cc_PM.Rows.Count; n++)
                    //        {
                    //             test_mail += " AGV *CC -->" + n + ". " + dt_cc_PM.Rows[n]["email"].ToString() + "<br />";
                    //          //  mail.CC.Add(dt_cc_PM.Rows[n]["email"].ToString());
                    //        }
                    //    }
                    //}
                    //else
                    //{
                    //    ////E-mail CC J2 up PM 
                    //    dt_cc_PM = get_mail.GetMail_PM("1");
                    //    if (dt_cc_PM.Rows.Count > 0)
                    //    {
                    //        for (int n = 0; n < dt_cc_PM.Rows.Count; n++)
                    //        {
                    //             test_mail += " PM *CC -->" + n + ". " + dt_cc_PM.Rows[n]["email"].ToString() + "<br />";
                    //           // mail.CC.Add(dt_cc_PM.Rows[n]["email"].ToString());
                    //        }
                    //    }
                    //}

                    ////E-mail Admin PDE
                    dt_Admin = get_mail.GetMail_AdminPDE();
                    if (dt_Admin.Rows.Count > 0)
                    {
                        for (int n = 0; n < dt_Admin.Rows.Count; n++)
                        {
                            mail.Bcc.Add(dt_Admin.Rows[n]["email"].ToString());
                            // test_mail += " Admin *BCC -->" + n + ". " + dt_Admin.Rows[n]["email"].ToString() + "<br />";
                        }
                    }
                    #endregion

                }



                lb_test.Text = test_mail; return;

                SmtpClient client = new SmtpClient();
                client.Port = 25;
                client.DeliveryMethod = SmtpDeliveryMethod.Network;
                client.Host = "150.61.249.70";

                mail.Subject = "[Close Problem] J3 of Tool owner Check for Close Problem";

                string mail_content = "";

                // mail_content += "ขณะนี้กำลังอยู่ในกระบวนการทดสอบระบบ กรุณาอย่าตกใจ หากได้รับ E-Mail ^^";
                mail_content += Environment.NewLine;
                mail_content += "Dear J3 of Tool owner "; // + dt.Rows[i][3].ToString() + "";
                mail_content += Environment.NewLine + Environment.NewLine + Environment.NewLine;
                mail_content += ">> Please Check for Close Problem";
                mail_content += Environment.NewLine;
                mail_content += "      Problem : " + dt.Rows.Count + " Item";
                mail_content += Environment.NewLine + Environment.NewLine;
                mail_content += " *Approval System : http://cptsvs552.canon-pt.co.th/personal_system/ApproveStatus.aspx";
                mail_content += Environment.NewLine + Environment.NewLine;
                mail_content += "   Approval System Manual";
                mail_content += Environment.NewLine;
                mail_content += "   1.ขั้นตอนเบื้องต้น :  http://cptsvs552.canon-pt.co.th/Dashboard_system/Manual_Detail.aspx?id=38";
                mail_content += Environment.NewLine;
                mail_content += "   2.ขั้นตอนการ Approve  : http://cptsvs552.canon-pt.co.th/Dashboard_system/Manual_Detail.aspx?id=43";

                //mail_content += "  *Problem History System : " + url + "pm_problem_id=" + dt.Rows[0][0].ToString() + "&pm_problem_name=" + dt.Rows[0][1].ToString() + "&tool_id=" + dt.Rows[0][2].ToString();
                mail_content += Environment.NewLine;
                mail_content += "  **You can check detail problem on system link.";

                string signature;
                signature = Environment.NewLine + Environment.NewLine;
                signature += "************************************************";
                signature += Environment.NewLine;
                signature += "This auto-email was sent from Jig Tool system.";
                signature += Environment.NewLine;
                signature += "Best regard.";
                signature += Environment.NewLine;
                signature += "--------------------- Original Message Ends --------------------";
                signature += Environment.NewLine;
                signature += "************************************************";

                mail.Body = mail_content + signature;

                //lb_test.Text += mail_content + signature;
                client.Send(mail);
                System.Diagnostics.Debug.WriteLine(mail_content + signature);


            }

        }
        //------------------- status Tool Owner[J3] Check ----------------//
        protected void SendEmail_ENG3_Check(DataTable dt)
        {
            Get_mail_PDE get_mail = new Get_mail_PDE();
            MailMessage mail = new MailMessage();
            mail.From = new MailAddress("engineer_pde@mail.canon");

            string issue = "";
            string resp_name = "";
            string url = "";

            DataTable dt_group_check;

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (Is_TestSystem())
                {
                    url = "http://cptsvs552.canon-pt.co.th/jig_tool_system_test/PM_problem_follow_New.aspx?";
                }
                else
                {
                    url = "http://cptsvs552.canon-pt.co.th/jig_tool_system/PM_problem_follow_New.aspx?";

                    //// To email J3 ของ issue person
                    dt_group_check = get_mail.GetMail_J3(dt.Rows[i][3].ToString());
                    if (dt_group_check.Rows.Count > 0)
                    {
                        for (int j = 0; j < dt_group_check.Rows.Count; j++)
                        {
                            mail.To.Add(dt_group_check.Rows[j]["email"].ToString());
                            // lb_test.Text += "To J3 group " + dt.Rows[i][0].ToString() + "-->" + dt_group_check.Rows[j]["email"].ToString()+"</br>";
                        }
                    }
                    //// cc issue name 
                    issue = get_mail.GetMail_ByMember(dt.Rows[i][4].ToString());
                    if (issue != "")
                    {
                        mail.CC.Add(issue);
                        //lb_test.Text += "CC Issue -->" + issue;
                    }

                    //// cc person resp.
                    resp_name = get_mail.GetMail_ByMember(dt.Rows[i][5].ToString());
                    if (resp_name != "")
                    {
                        mail.CC.Add(resp_name);
                        //  lb_test.Text += "CC Issue -->" + resp_name;
                    }
                }

                mail.Bcc.Add("anirut@mail.canon");
                mail.Bcc.Add("kanokorn@mail.canon");
                SmtpClient client = new SmtpClient();
                client.Port = 25;
                client.DeliveryMethod = SmtpDeliveryMethod.Network;
                client.Host = "150.61.249.70";

                mail.Subject = "[Close Problem] J3 Check for Close Problem";

                string mail_content = "";
                //mail_content += "ขณะนี้กำลังอยู่ในกระบวนการทดสอบระบบ กรุณาอย่าตกใจ หากได้รับ E-Mail ^^";
                mail_content += Environment.NewLine;
                mail_content += "Dear J3 of Group " + dt.Rows[i][3].ToString() + "";
                mail_content += Environment.NewLine + Environment.NewLine;
                mail_content += ">> Please Check for Close Problem";
                mail_content += Environment.NewLine;
                mail_content += "      Problem No: " + dt.Rows[0][1].ToString() + " ";
                mail_content += Environment.NewLine + Environment.NewLine;
                mail_content += "  *Problem History System : " + url + "pm_problem_id=" + dt.Rows[0][0].ToString() + "&pm_problem_name=" + dt.Rows[0][1].ToString() + "&tool_id=" + dt.Rows[0][2].ToString();
                mail_content += Environment.NewLine;
                mail_content += "  **You can check detail problem on system link.";

                string signature;
                signature = Environment.NewLine + Environment.NewLine;
                signature += "************************************************";
                signature += Environment.NewLine;
                signature += "This auto-email was sent from Jig Tool system.";
                signature += Environment.NewLine;
                signature += "Best regard.";
                signature += Environment.NewLine;
                signature += "--------------------- Original Message Ends --------------------";
                signature += Environment.NewLine;
                signature += "************************************************";

                mail.Body = mail_content + signature;

                //lb_test.Text += mail_content + signature;
                client.Send(mail);
                System.Diagnostics.Debug.WriteLine(mail_content + signature);

            }



        }
        //------------------- status ENG4 [J3] Check ----------------//
        protected void SendEmail_ENG4_Check(DataTable dt)
        {
            Get_mail_PDE get_mail = new Get_mail_PDE();
            MailMessage mail = new MailMessage();
            mail.From = new MailAddress("engineer_pde@mail.canon");

            string url = "";
            string Issue_group_old = "";
            string issue_name = "";
            string resp_name = "";
            DataTable mgr_group_issue;

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (Is_TestSystem())
                {
                    url = "http://cptsvs552.canon-pt.co.th/jig_tool_system_test/PM_problem_follow_New.aspx?";
                }
                else
                {
                    url = "http://cptsvs552.canon-pt.co.th/jig_tool_system/PM_problem_follow_New.aspx?";

                    //mgr. group issue
                    string dept_id = Get_dept_ID(dt.Rows[i][3].ToString().Trim());
                    mgr_group_issue = get_mail.GetMail_Mgr(dept_id);

                    // lb_test.Text += "depr -- >" + dt.Rows[i][3].ToString() ;
                    if (mgr_group_issue.Rows.Count > 0)
                    {
                        for (int j = 0; j < mgr_group_issue.Rows.Count; j++)
                        {
                            mail.To.Add(mgr_group_issue.Rows[j]["email"].ToString());
                            //lb_test.Text += "  Mgr-->" + mgr_group_issue.Rows[j]["email"].ToString();
                        }
                    }

                    //Issue Name
                    issue_name = get_mail.GetMail_ByMember(dt.Rows[i][4].ToString());
                    if (issue_name != "")
                    {
                        mail.CC.Add(issue_name);
                        //lb_test.Text += " Issue ---> " + issue_name;
                    }

                    //resp. name
                    resp_name = get_mail.GetMail_ByMember(dt.Rows[i][5].ToString());
                    if (resp_name != "")
                    {
                        mail.CC.Add(resp_name);
                        // lb_test.Text += "  resp ---> " + resp_name;
                    }
                }

                mail.CC.Add("kanokorn@mail.canon");
                mail.CC.Add("anirut@mail.canon");

                SmtpClient client = new SmtpClient();
                client.Port = 25;
                client.DeliveryMethod = SmtpDeliveryMethod.Network;
                client.Host = "150.61.249.70";

                mail.Subject = "[Close Problem] Mgr. Approve for Close Problem";

                string mail_content = "";
                // mail_content += "ขณะนี้กำลังอยู่ในกระบวนการทดสอบระบบ กรุณาอย่าตกใจ หากได้รับ E-Mail ^^";
                mail_content += Environment.NewLine;
                mail_content += "Dear Manager of Group " + dt.Rows[i][3].ToString() + "";
                mail_content += Environment.NewLine + Environment.NewLine + Environment.NewLine;
                mail_content += ">> Please Approve for Close Problem";
                mail_content += Environment.NewLine;
                mail_content += "      Problem  No: " + dt.Rows[0][1].ToString() + " ";
                mail_content += Environment.NewLine + Environment.NewLine;
                mail_content += "  *Problem History System : " + url + "pm_problem_id=" + dt.Rows[0][0].ToString() + "&pm_problem_name=" + dt.Rows[0][1].ToString() + "&tool_id=" + dt.Rows[0][2].ToString();
                mail_content += Environment.NewLine;
                mail_content += "  **You can check detail problem on system link.";


                string signature;
                signature = Environment.NewLine + Environment.NewLine;
                signature += "************************************************";
                signature += Environment.NewLine;
                signature += "This auto-email was sent from Jig Tool system.";
                signature += Environment.NewLine;
                signature += "Best regard.";
                signature += Environment.NewLine;
                signature += "--------------------- Original Message Ends --------------------";
                signature += Environment.NewLine;
                signature += "************************************************";

                mail.Body = mail_content + signature;

                //lb_test.Text += mail_content + signature;
                client.Send(mail);
                System.Diagnostics.Debug.WriteLine(mail_content + signature);

            }


        }
        //------------------- status ENG4 [Mgr] Check ----------------//
        protected void SendEmail_Close(DataTable dt)
        {
            Get_mail_PDE get_mail = new Get_mail_PDE();
            MailMessage mail = new MailMessage();
            mail.From = new MailAddress("engineer_pde@mail.canon");

            string url = "";

            DataTable dt_owner = new DataTable();
            DataTable dt_resp = new DataTable();
            DataTable dt_issue = new DataTable();
            DataTable dt_J2PM = new DataTable();

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (Is_TestSystem())
                {
                    url = "http://cptsvs552.canon-pt.co.th/jig_tool_system_test/PM_problem_follow_New.aspx?";
                }
                else
                {
                    url = "http://cptsvs552.canon-pt.co.th/jig_tool_system/PM_problem_follow_New.aspx?";

                    if (dt.Rows[i][4].ToString() != "")  //Member Issue
                    {
                        string issue = get_mail.GetMail_ByMember(dt.Rows[i][4].ToString());
                        mail.To.Add(issue);
                        //lb_test.Text += "Issue --> "+ issue + "</br>";
                    }


                    if (dt.Rows[i][6].ToString() != "") //J2  up Group owner
                    {
                        dt_owner = get_mail.GetMailJ2_ByGroup(dt.Rows[i][6].ToString());

                        for (int j = 0; j < dt_owner.Rows.Count; j++)
                        {
                            mail.CC.Add(dt_owner.Rows[j]["email"].ToString());
                            // lb_test.Text += "Owner --> "+dt_owner.Rows[j]["email"].ToString() + "</br>";
                        }

                    }
                    if (dt.Rows[i][5].ToString() != "") //J2  up Group resp 
                    {
                        dt_resp = get_mail.GetMailJ2_ByGroup(dt.Rows[i][5].ToString());

                        for (int j = 0; j < dt_resp.Rows.Count; j++)
                        {
                            mail.CC.Add(dt_resp.Rows[j]["email"].ToString());
                            // lb_test.Text += "resp group --> "+ dt_resp.Rows[j]["email"].ToString()+"</br>";
                        }

                    }
                    if (dt.Rows[i][3].ToString() != "") //J2  up Group issue
                    {
                        dt_issue = get_mail.GetMailJ2_ByGroup(dt.Rows[i][3].ToString());
                        for (int j = 0; j < dt_issue.Rows.Count; j++)
                        {
                            mail.CC.Add(dt_issue.Rows[j]["email"].ToString());
                            //lb_test.Text += "issue group --> "+ dt_issue.Rows[j]["email"].ToString()+"</br>";
                        }

                    }
                }
            }

            if (dt.Rows[0][6].ToString() != "AGV")
            {
                //J2 PM
                dt_J2PM = get_mail.GetMail_PM("1");
                for (int k = 0; k < dt_J2PM.Rows.Count; k++)
                {
                    mail.CC.Add(dt_J2PM.Rows[k]["email"].ToString());
                    //lb_test.Text += "J2 PM--> " + dt_J2PM.Rows[k]["email"].ToString() + "</br>";
                }
            }




            mail.CC.Add("kanokorn@mail.canon");
            //  mail.CC.Add("anirut@mail.canon");
            SmtpClient client = new SmtpClient();
            client.Port = 25;
            client.DeliveryMethod = SmtpDeliveryMethod.Network;
            client.Host = "150.61.249.70";

            mail.Subject = "[Close Problem] PM Problem is Close";

            string mail_content = "";
            // mail_content += "ขณะนี้กำลังอยู่ในกระบวนการทดสอบระบบ กรุณาอย่าตกใจ หากได้รับ E-Mail ^^";
            mail_content += Environment.NewLine;
            mail_content += "Dear All ";
            mail_content += Environment.NewLine + Environment.NewLine;
            mail_content += ">>PM Problem Close : " + dt.Rows.Count.ToString() + " Item" + Environment.NewLine;
            mail_content += Environment.NewLine;
            mail_content += "      Problem No.  " + dt.Rows[0][1].ToString() + "  Resp Name : " + Get_Name(dt.Rows[0][4].ToString()) + "";

            mail_content += Environment.NewLine + Environment.NewLine;
            mail_content += "  *Problem History System : " + url + "pm_problem_id=" + dt.Rows[0][0].ToString() + "&pm_problem_name=" + dt.Rows[0][1].ToString() + "&tool_id=" + dt.Rows[0][2].ToString();
            mail_content += Environment.NewLine;
            mail_content += "  **You can check detail problem on system link.";



            string signature;
            signature = Environment.NewLine + Environment.NewLine;
            signature += "************************************************";
            signature += Environment.NewLine;
            signature += "This auto-email was sent from Jig Tool system.";
            signature += Environment.NewLine;
            signature += "Best regard.";
            signature += Environment.NewLine;
            signature += "--------------------- Original Message Ends --------------------";
            signature += Environment.NewLine;
            signature += "************************************************";

            mail.Body = mail_content + signature;

            //lb_test.Text += mail_content + signature;
            client.Send(mail);
            System.Diagnostics.Debug.WriteLine(mail_content + signature);


        }


        //********Modal Upload Pictrue Other*********//
        protected void btn_uploadPic_Click(object sender, EventArgs e)
        {
            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#UploadPicture_modal').modal('show')");
            sb.Append(@"</script>");
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "closemodal", sb.ToString(), false);
            return;
        }
        protected void btn_UploadPicture_Click(object sender, EventArgs e)
        {
            string pm_problem_no = hd_pmProblem_name.Value.ToString();

            string[] str_split = pm_problem_no.Split('-');
            string year = str_split[1];
            string img_type = "";
            int num = 0;
            string thisYear = DateTime.Now.Year.ToString();
            year = thisYear.Substring(0, 2) + year;

            string FolderPath = String.Format(@"\\cptfile02\Pro\PRJ2015009\01_PM History\02_PM Problem\{0}\{1}\Pictrue", year, pm_problem_no);
            if (!Directory.Exists(FolderPath))
            {
                Directory.CreateDirectory(FolderPath);
            }
            if (re_NG.Checked == true)
            {
                img_type = "NG";
            }
            if (re_OK.Checked == true)
            {
                img_type = "OK";
            }

            if (!Directory.Exists(FolderPath))
            {
                Directory.CreateDirectory(FolderPath);
            }

            try
            {

                HttpFileCollection hfc = Request.Files;
                string[] files = Directory.GetFiles(FolderPath, "*.jpg", SearchOption.TopDirectoryOnly);
                int count_flie = files.Length;
                #region
                if (this.UploadImages.HasFile)
                {
                    num = count_flie + 1;
                    string pic_name = pm_problem_no + "_" + num + "_" + img_type;
                    //lb_test.Text = FolderPath + @"\" + pic_name + ".jpg";
                    UploadImages.SaveAs(FolderPath + @"\" + pic_name + ".jpg");
                    alert_completed_reload();
                }

            }
            catch (Exception ex)
            {
                lb_test.Text += ex.Message;
            }

        }

        //********Modal Upload Pictrue Problem*********//
        protected void btn_uploadPic_problem_Click(object sender, EventArgs e)
        {
            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#modal_UploadPic_problem').modal('show')");
            sb.Append(@"</script>");
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "closemodal", sb.ToString(), false);
            return;
        }
        protected void btn_UploadPicture_Problem_Click(object sender, EventArgs e)
        {
            string pm_problem_no = hd_pmProblem_name.Value.ToString();
            string year = DateTime.Now.Year.ToString();
            string FolderPath = String.Format(@"\\cptfile02\Pro\PRJ2015009\01_PM History\02_PM Problem\{0}\{1}\Pictrue\", year, pm_problem_no);
            //lb_test.Text += FolderPath;
            if (!Directory.Exists(FolderPath))
            {
                Directory.CreateDirectory(FolderPath);
            }

            try
            {

                if (this.UploadPicProblem1.HasFile)
                {
                    UploadPicProblem1.SaveAs(FolderPath + "PIC1_NG.jpg");
                    //  lb_test.Text += FolderPath + "PIC1_NG.jpg";
                }

                if (this.UploadPicProblem2.HasFile)
                {
                    UploadPicProblem2.SaveAs(FolderPath + "PIC2_NG.jpg");
                    // lb_test.Text += FolderPath + "PIC2_NG.jpg";
                }
                if (this.UploadAction.HasFile)
                {
                    UploadAction.SaveAs(FolderPath + "PIC1_OK.jpg");
                    // lb_test.Text += FolderPath + "PIC2_NG.jpg";
                }

                alert_completed_reload();

            }
            catch (Exception ex)
            {
                alert_Messend(ex.Message);
            }

        }

        //************ START Modal Status Process**************** //
        //------- status New Problem ---//
        protected void btn_ProblemRankMeaning_Click(object sender, EventArgs e)
        {

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#modal_ProblemRankMeaning').modal('show')");
            sb.Append(@"</script>");
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "closemodal", sb.ToString(), false);
            return;
        }

        protected void btn_Newproblem_Process_Click(object sender, EventArgs e)
        {

            if (ddl_type.SelectedItem.Text != "")
                txt_TypeofProblem.Text = ddl_Pro_type1.SelectedItem.Text.ToString();

            if (txt_probTopic.Text != "")
                txt_ProblemDetail.Text = txt_probTopic.Text.ToString();

            if (ddl_priority.SelectedItem.Text != "")
                txt_ProblemRank.Text = ddl_priority.SelectedItem.Text.ToString();

            if (ddl_group.SelectedItem.Text != "")
                txt_resp_group_New.Text = ddl_group.SelectedItem.Text.ToString();

            if (lb_spec.Text != "")
                txt_DataSpec.Text = lb_spec.Text.ToString();

            if (lb_actual.Text != "")
                txt_DataActual.Text = lb_actual.Text.ToString();

            if (lb_detailProblem.Text != "")
                txt_PBmoreDetail.Text = lb_detailProblem.Text.ToString();

            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#modal_NewProblemProcess').modal('show')");
            sb.Append(@"</script>");
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "closemodal", sb.ToString(), false);
            Bind_data();
            return;
        }
        protected void btn_sendMail_newProblem_Click(object sender, EventArgs e)
        {

            if (CB_ProblemSheet.Checked == false)
                return;
            if (CB_TypeofProblem.Checked == false)
                return;
            if (CB_ProblemDetail.Checked == false)
                return;
            if (CB_ProblemRank.Checked == false)
                return;
            if (CB_DataSpec.Checked == false)
                return;
            if (CB_DataActual.Checked == false)
                return;
            if (CB_PBmoreDetail.Checked == false)
                return;
            if (CB_Resp.Checked == false)
                return;



            List<string[]> list = new List<string[]>();

            string sql_update = "";

            string detail = " Send New Problem : Acknowledge ";
            string update = " ,isOnplan = '0' ";
            sql_update += Update_jtPM_problem(update);
            sql_update += Insert_detail(detail);

            string pm_name = hd_pmProblem_name.Value.ToString();
            string pm_id = hd_pmProblem_id.Value.ToString();
            string tool_no = txt_toolno.Text.ToString();
            string owner_id = ddl_owner.SelectedItem.ToString();
            string issue_id = hd_issue_id.Value.ToString();
            string tool_id = hd_toolID.Value.ToString();
            string problem_result = lb_detailProblem.Text.Trim();
            try
            {
                list.Add(new string[] { pm_name, pm_id, tool_no, owner_id, ddl_group.SelectedItem.ToString(), txt_issue.Text.ToString(), issue_id, txt_problemDate.Text.ToString(), tool_id });
                DataTable dt = ConvertListToDataTable(list);
                // lb_test.Text = hd_pmProblem_name.Value.ToString() + "/" + hd_pmProblem_id.Value.ToString() + "/" + txt_toolno.Text.ToString() + "/" + ddl_owner.SelectedItem.ToString() + "/" + ddl_group.SelectedItem.ToString() + "/" + txt_issue.Text.ToString() + "/" + hd_issue_id.Value.ToString() + "/" + txt_problemDate.Text.ToString()+"/"+ hd_toolID.Value.ToString()+"/TABLE" + dt.Rows.Count.ToString(); return;
                // lb_test.Text += sql_update; return;

                dc.RunCommand(conn, sql_update);

                Excel_WriteProblem(pm_name, problem_result);
                SendEmail_NewProblem(dt);
                alert_completed_reload();

            }
            catch (Exception ex)
            {
                alert_Messend(ex.Message.ToString());
            }
            //**script completed**

        }

        //------- status Acknowledge -----//
        protected void btn_acknowledge_Click(object sender, EventArgs e)
        {
            string PM_problem_name = hd_pmProblem_name.Value.ToString();
            string select = "";

            if (Session["eng_group_id"].ToString() != ddl_group.SelectedValue.ToString() && Session["admin"].ToString() == "")
            {
                alert_Messend("Sorry!! You do not Resp.Group ");
                return;
            }

            Bind_ddlPIC(ddl_group.SelectedValue);

            if (ddl_Action.SelectedValue.ToString() != "")
                ddl_action1.SelectedValue = ddl_Action.SelectedValue.ToString();

            if (ddl_pic1.SelectedValue.ToString() != "")
                ddl_pic.SelectedValue = ddl_pic1.SelectedValue.ToString();

            if (txt_follow_up.Text != "")
                txt_follow.Text = txt_follow_up.Text.ToString();

            if (txt_planFinish.Text != "")
                txt_plan_finish.Text = txt_planFinish.Text.ToString();

            hd_problem_no.Value = PM_problem_name;




            select += " select PM_problem_id, PM_problem_name, PRC_Grop_name, model_name, check_date, rep_group , tool_id, tool_no,check_by from PM_Tool_History ";
            select += " where PM_problem_name = N'" + PM_problem_name + "'";

            dc.QryDT(conn, select);

            gv3.DataSource = dc.dt;
            gv3.DataBind();

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#AcknowledgeModal').modal('show'); ");
            sb.Append(@"</script>");
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "NotPostBackModal", sb.ToString(), false);
            Bind_data();
            return;


        }
        protected void btn_ref_Click(object sender, EventArgs e)
        {
            //GridViewRow row = (sender as LinkButton).NamingContainer as GridViewRow;

            //Label lb_problem_no = (Label)row.FindControl("lb_problem_no");
            //HiddenField hd_problem_id = (HiddenField)row.FindControl("hd_problem_id");
            //HiddenField hd_tool_id = (HiddenField)row.FindControl("hd_tool_id");

            //string url = "PM_problem_Deail.aspx?pm_problem_id=" + hd_problem_id.Value.ToString() + "&pm_problem_name=" + lb_problem_no.Text.Trim() + "&tool_id=" + hd_tool_id.Value.ToString();
            //sb.Append(@"<script type='text/javascript'>");
            //sb.Append("window.open('" + url + "','_blank');");
            //sb.Append(@"</script>");
            //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "closemodal", sb.ToString(), false);
            string PM_problem_name = Request.QueryString["PM_problem_name"].ToString();
            string PM_problem_id = Request.QueryString["pm_problem_id"].ToString();
            string tool_id = Request.QueryString["tool_id"].ToString();
            string url = "PM_problem_Deail.aspx?pm_problem_id=" + PM_problem_id + "&pm_problem_name=" + PM_problem_name + "&tool_id=" + tool_id;
            sb.Append(@"<script type='text/javascript'>");
            sb.Append("window.open('" + url + "','_blank');");
            sb.Append(@"</script>");
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "closemodal", sb.ToString(), false);

        }
        protected void btn_acknowledge_save_Click(object sender, EventArgs e)
        {
            List<string[]> list = new List<string[]>();
            string pic = ddl_pic.SelectedValue.ToString().Trim();
            string pic_name = ddl_pic.SelectedItem.Text.ToString();
            string plan_finish = txt_plan_finish.Text.Substring(0, 11);
            string follow_up = txt_follow.Text.Trim();
            string action = ddl_action1.SelectedValue.ToString();
            string PM_problem_name = hd_problem_no.Value;
            string emp_id = Session["emp_id"].ToString();
            string problem_result = lb_detailProblem.Text.Trim();

            string update = "";
            string sql_update = "";

            HiddenField hd_problem_id = (HiddenField)gv3.Rows[0].FindControl("hd_problem_id");
            HiddenField hd_tool_id = (HiddenField)gv3.Rows[0].FindControl("hd_tool_id");
            HiddenField hd_checkBy = (HiddenField)gv3.Rows[0].FindControl("hd_checkBy");
            Label lb_problem_no = (Label)gv3.Rows[0].FindControl("lb_problem_no");
            Label lb_tool_no = (Label)gv3.Rows[0].FindControl("lb_tool_no");
            Label lb_resp_group = (Label)gv3.Rows[0].FindControl("lb_resp_group");

            list.Add(new string[] { hd_problem_id.Value.ToString(), lb_problem_no.Text, lb_tool_no.Text, plan_finish, lb_resp_group.Text, pic, pic_name, hd_checkBy.Value.ToString(), hd_tool_id.Value.ToString() });

            DataTable dt = ConvertListToDataTable(list);

            string detail = " Acknowledge PM Problem ";

            update += " , pic = '" + pic + "' ";
            update += " , plan_finish = '" + plan_finish + "'";
            update += " , isOnplan = '1' ";
            update += " , action_id = '" + action + "' ";
            update += " , acknowledge_date = '" + DateTime.Now.ToString("dd-MMM-yyyy").Trim() + "' ";
            update += " , acknowledge_by = '" + emp_id.Trim() + "' ";
            update += " , Follow_up = '" + follow_up.Trim() + "' ";

            sql_update += Update_jtPM_problem(update);
            sql_update += Insert_detail(detail);


            try
            {

                //   lb_text.Text = sql_update; return;

                dc.RunCommand(conn, sql_update);
                Excel_WriteProblem(PM_problem_name, problem_result);
                SendEmail_Acknowledge(dt);
                alert_completed_reload();

            }
            catch (Exception ex)
            {
                sendMail_error("JigTool", "PM_problem_follow_New.aspx", "btn_acknowledge_save_Click>>IN To Database  ", ex.Message);

            }

            return;

        }

        //------- status ON Plan ------//
        protected void btn_OnPlan_Click(object sender, EventArgs e)
        {
            if (Session["eng_group_id"].ToString() != ddl_group.SelectedValue.ToString() && Session["admin"].ToString() == "")
            {
                alert_Messend("Sory!! You are not responsible. "); return;
            }

            if (ddl_Action.SelectedValue.ToString() != "")
                ddl_action_update.SelectedValue = ddl_Action.SelectedValue;

            if (ddl_group.SelectedValue.ToString() != "")
            {
                ddl_resp_group_update.SelectedValue = ddl_group.SelectedValue;
            }
            else
            {
                ddl_resp_group_update.SelectedValue = "0";
            }

            Get_ddl_resp_group_update(ddl_resp_group_update.SelectedValue.ToString(), ddl_resp_name_update);

            if (ddl_pic1.SelectedValue.ToString() != "")
                ddl_resp_name_update.SelectedValue = ddl_pic1.SelectedValue;

            if (txt_actualFinish.Text != "")
                txt_actualFinish_update.Text = txt_actualFinish.Text;

            //if (lb_actual.Text != "")
            //    txt_result_spec.Text = lb_actual.Text.ToString();

            if (lb_detailProblem.Text != "")
                lb_detailProblem.Text = lb_detailProblem.Text.ToString();

            if (lb_result_spec.Text != "")
                txt_result_spec.Text = lb_result_spec.Text.ToString();

            if (lb_result_detail.Text != "")
                txt_result_detail.Text = lb_result_detail.Text.ToString();


            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#modal_RequestClose').modal('show')");
            sb.Append(@"</script>");
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "closemodal", sb.ToString(), false);
            return;
        }
        protected void ddl_resp_group_update_SelectedIndexChanged(object sender, EventArgs e)
        {
            string group_id = (ddl_resp_group_update.SelectedValue.ToString() == "" ? "0" : ddl_resp_group_update.SelectedValue.ToString());
            Get_ddl_resp_group_update(group_id, ddl_resp_name_update);
        }
        protected void btn_RequestClose_Click(object sender, EventArgs e)
        {
            List<string[]> list = new List<string[]>();
            string detail = "";
            string sql_update = "";
            string update = "";
            string PM_problem_name = hd_problem_no.Value;
            string problem_result = lb_detailProblem.Text.Trim();

            if (ddl_action_update.SelectedValue.ToString() != "")
                update += " , action_id  = '" + ddl_action_update.SelectedValue.ToString() + "' ";

            if (ddl_resp_group_update.SelectedValue.ToString() != "")
                update += ", group_resp = '" + ddl_resp_group_update.SelectedValue + "' ";

            if (ddl_resp_name_update.SelectedValue.ToString() != "")
                update += ", pic = '" + ddl_resp_name_update.SelectedValue + "' ";

            if (txt_actualFinish_update.Text != "")
                update += " , isOnplan = '3',actual_finish = '" + txt_actualFinish_update.Text.Trim() + "' ";

            if (txt_result_spec.Text != "")
                update += ", result_spec_checkList = '" + txt_replace(txt_result_spec.Text.Trim()) + "' ";

            if (txt_result_detail.Text != "")
                update += ", result_prob_detail = '" + txt_replace(txt_result_detail.Text.Trim()) + "' ";

            detail += " Update Data for Close PM Problem ";

            list.Add(new string[] { hd_pmProblem_id.Value.ToString(), hd_pmProblem_name.Value.ToString(), hd_toolID.Value.ToString(), hd_issue_id.Value.ToString(), ddl_resp_name_update.SelectedValue.ToString(), ddl_owner.SelectedItem.ToString(), txt_actualFinish_update.Text });

            DataTable dt = ConvertListToDataTable(list);

            sql_update += Update_jtPM_problem(update);
            sql_update += Insert_detail(detail);

            try
            {

                Upload_Picture();

                //  test.Text += "**"+ sql_update; 
                //  return; 
                dc.RunCommand(conn, sql_update);
                Excel_WriteProblem(PM_problem_name, problem_result);
                SendEmail_PersonIncharge(dt);
                alert_completed_reload();

            }
            catch (Exception ex)
            {
                alert_Messend(ex.Message.ToString());
            }
        }
        protected void Upload_Picture()
        {
            string pm_problem_no = hd_pmProblem_name.Value.ToString();
            // string[] str_split = pm_problem_no.Split('-');
            // string year = str_split[1];   
            // string img_type = "";
            //// int num = 0;
            // string thisYear = DateTime.Now.Year.ToString();
            //year = thisYear.Substring(0, 2) + year;
            string year = DateTime.Now.Year.ToString();
            //FileUpload fileUpload = new FileUpload("UploadPic1");
            string FolderPath = String.Format(@"\\cptfile02\Pro\PRJ2015009\01_PM History\02_PM Problem\{0}\{1}\Pictrue\", year, pm_problem_no);

            try
            {
                if (!Directory.Exists(FolderPath))
                {
                    Directory.CreateDirectory(FolderPath);
                }

                if (UploadPic1.HasFile)
                {

                    UploadPic1.SaveAs(FolderPath + "PIC1_OK.jpg");
                    //est.Text += FolderPath + @"PIC1_OK.jpg"; return;
                }


            }
            catch (Exception ex)
            {
                test1.Text += ex.Message;
            }
        }

        //------- status Send for Check -----//
        protected void btn_sen_for_check_Click(object sender, EventArgs e)
        {
            string user_group_id = Session["eng_group_id"].ToString();
            string group_issue = hd_GroupIssue_id.Value.ToString();

            if (check_use() == false)
            {
                alert_Messend("Sory!! You are not responsible. "); return;
            }

            if (user_group_id != group_issue)
            {
                alert_Messend("Sory!! You are not Group Issue. "); return;
            }

            Bind_data();

            if (ddl_Action.SelectedValue.ToString() != "")
                txt_action.Text = ddl_Action.SelectedItem.ToString();
            if (txt_actualFinish.Text != "")
                txt_actual.Text = txt_actualFinish.Text;
            if (lb_result_spec.Text != "")
                txt_result.Text = lb_result_spec.Text.ToString();
            if (lb_result_detail.Text != "")
                txt_detail2.Text = lb_result_detail.Text;

            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#modal_ConfirmClose').modal('show')");
            sb.Append(@"</script>");
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "closemodal", sb.ToString(), false);
            return;
        }
        protected Boolean check_use()
        {
            Boolean status = false;
            switch (Session["positionId"].ToString())
            {
                case "1": status = true; break; //ENG
                case "2": status = true; break; // Sr.ENG
                case "3": status = true; break; //Chief.ENG
                case "7": status = true; break; //Manager
                case "9": status = true; break; //Ast.Manager
                case "15": status = true; break; //Sr.Technician
                default: status = false; break;

            }
            if (Session["emp_id"].ToString() == ddl_pic1.SelectedValue.ToString())
                status = true;

            if (Session["admin"].ToString() != "") status = true;

            return status;
        }
        protected void btn_send_mail_Click(object sender, EventArgs e)
        {
            List<string[]> list = new List<string[]>();

            if (!cb_sheet.Checked) return;
            if (!cb_action.Checked) return;
            if (!cb_actual.Checked) return;
            if (!cb_result.Checked) return;
            if (!cb_detail.Checked) return;
            if (!cb_confirm.Checked) return;

            string detail = "";
            string sql_update = "";
            string update = "";

            list.Add(new string[] { hd_pmProblem_id.Value.ToString(), hd_pmProblem_name.Value.ToString(), hd_toolID.Value.ToString(), hd_issue_id.Value.ToString(), ddl_pic1.SelectedValue.ToString(), ddl_group.SelectedItem.ToString(), ddl_owner.SelectedItem.ToString() });

            DataTable dt = ConvertListToDataTable(list);

            detail += " ยืนยันสำหรับการปิดปัญหา [Confirm Close PM Problem] ";
            update += " ,isOnplan = '4' ";

            sql_update += Update_jtPM_problem(update);
            sql_update += Insert_detail(detail);

            try
            {

                // lb_test.Text += sql_update;
                // return;
                dc.RunCommand(conn, sql_update);
                SendEmail_IssuePerson(dt);
                alert_completed_reload();

            }
            catch (Exception ex)
            {
                alert_Messend(ex.Message.ToString());
            }

        }

        //------- status Tool Owner[J3] check ---//
        protected void btn_Tool_Owner_Click(object sender, EventArgs e)
        {


            if ((Session["positionId"].ToString() != "2" && Session["positionId"].ToString() != "1" && Session["positionId"].ToString() != "3") && Session["admin"].ToString() == "")
            {
                alert_Messend("Sorry!! Only for Tool Owner approval ");
                return;
            }

            if (Session["eng_group_id"].ToString() != ddl_owner.SelectedValue.ToString())
            {
                alert_Messend("Sorry!! You do not Tool Owner ");
                return;
            }

            md_gv.DataSource = Get_Data_Check("4");
            md_gv.DataBind();

            if (md_gv.Rows.Count > 0)
                md_gv.HeaderRow.TableSection = TableRowSection.TableHeader;

            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#Modal_Tool_Owner_Check').modal('show')");
            sb.Append(@"</script>");
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "closemodal", sb.ToString(), false);
            return;
            // ClientScript.RegisterStartupScript(this.GetType(), "Popup", "$('#Modal_Tool_Owner_Check').modal('show')", true);
        }
        protected void btn_Tool_Owner_save_Click(object sender, EventArgs e)
        {
            List<string[]> list = new List<string[]>();
            string detail = "";
            string sql_update = "";
            string update = "";

            for (int i = 0; i < md_gv.Rows.Count; i++)
            {

                System.Web.UI.WebControls.CheckBox chb_send = md_gv.Rows[i].FindControl("chb_send") as System.Web.UI.WebControls.CheckBox;

                if (chb_send.Checked == true)
                {
                    list.Add(new string[] { hd_pmProblem_id.Value.ToString(), hd_pmProblem_name.Value.ToString(), hd_toolID.Value.ToString(), hd_GroupIssue.Value.ToString(), hd_issue_id.Value.ToString(), ddl_pic1.SelectedValue.ToString() });

                    update += " ,isOnplan = 5 ";
                    detail += " Check & Approve for close PM Problem by Leader Tool Owner ";
                    sql_update += Update_jtPM_problem(update);
                    sql_update += Insert_detail(detail);
                    sql_update += J3_ToolOwner_Appvoe();

                    DataTable dt = ConvertListToDataTable(list);

                    try
                    {
                        // lb_test.Text += sql_update;return;
                        dc.RunCommand(conn, sql_update);
                        SendEmail_ENG3_Check(dt);
                        alert_completed_reload();
                    }
                    catch (Exception ex)
                    {
                        alert_Messend(ex.Message.ToString());
                    }

                }
            }
        }

        //------- status ENG4 [J3] check ---//
        protected void btn_ENG4_J3_Click(object sender, EventArgs e)
        {
            if (Session["positionId"].ToString() != "3" && Session["admin"].ToString() == "")
            {
                alert_Messend("Sorry!! Only for leader approval ");
                return;
            }

            gv_ENG4_J3.DataSource = Get_Data_Check("5");
            gv_ENG4_J3.DataBind();

            if (gv_ENG4_J3.Rows.Count > 0)
                gv_ENG4_J3.HeaderRow.TableSection = TableRowSection.TableHeader;

            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#Modal_ENG4_J3_Check').modal('show')");
            sb.Append(@"</script>");
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "closemodal", sb.ToString(), false);
            return;
        }
        protected void btn_save_ENG4_J3_Click(object sender, EventArgs e)
        {
            List<string[]> list = new List<string[]>();
            string detail = "";
            string sql_update = "";
            string update = "";

            for (int i = 0; i < gv_ENG4_J3.Rows.Count; i++)
            {

                System.Web.UI.WebControls.CheckBox cb_ENG4_send = gv_ENG4_J3.Rows[i].FindControl("cb_ENG4_send") as System.Web.UI.WebControls.CheckBox;

                if (cb_ENG4_send.Checked == true)
                {
                    list.Add(new string[] { hd_pmProblem_id.Value.ToString(), hd_pmProblem_name.Value.ToString(), hd_toolID.Value.ToString(), hd_GroupIssue.Value.ToString(), hd_issue_id.Value.ToString(), ddl_pic1.SelectedValue.ToString() });

                    update += " ,isOnplan = 6 ";
                    detail += " Check & Approve for close PM Problem by Leader PM ";
                    sql_update += Update_jtPM_problem(update);
                    sql_update += Insert_detail(detail);
                    sql_update += ENG4_J3_Appvoe();

                    DataTable dt = ConvertListToDataTable(list);

                    try
                    {
                        //  lb_test.Text += sql_update;return;

                        dc.RunCommand(conn, sql_update);
                        SendEmail_ENG4_Check(dt);
                        alert_completed_reload();
                    }
                    catch (Exception ex)
                    {
                        alert_Messend(ex.Message.ToString());
                    }

                }
            }

        }

        //------- status ENG4 [Mgr] check ---//
        protected void btn_ENG4_Mgr_Click(object sender, EventArgs e)
        {
            if (Session["positionId"].ToString() != "7" && Session["admin"].ToString() == "")
            {
                alert_Messend("Sorry!! Only for manager approval ");
                return;
            }

            gv_ENG4_Mgr.DataSource = Get_Data_Check("7");//6
            gv_ENG4_Mgr.DataBind();

            if (gv_ENG4_Mgr.Rows.Count > 0)
                gv_ENG4_Mgr.HeaderRow.TableSection = TableRowSection.TableHeader;

            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#Modal_ENG4_Mgr_Check').modal('show')");
            sb.Append(@"</script>");
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "closemodal", sb.ToString(), false);
            return;
        }
        protected void btn_save_ENG4_Mgr_Click(object sender, EventArgs e)
        {
            List<string[]> list = new List<string[]>();
            string detail = "";
            string sql_update = "";
            string update = "";

            for (int i = 0; i < gv_ENG4_Mgr.Rows.Count; i++)
            {

                System.Web.UI.WebControls.CheckBox cb_Mgr_send = gv_ENG4_Mgr.Rows[i].FindControl("cb_Mgr_send") as System.Web.UI.WebControls.CheckBox;

                if (cb_Mgr_send.Checked == true)
                {
                    list.Add(new string[] { hd_pmProblem_id.Value.ToString(), hd_pmProblem_name.Value.ToString(), hd_toolID.Value.ToString(), hd_GroupIssue.Value.ToString(), hd_issue_id.Value.ToString(), ddl_group.SelectedItem.ToString(), ddl_owner.SelectedItem.ToString() });

                    update += " ,isOnplan = 7 ";
                    detail += " Approve close PM Problem ";
                    sql_update += Update_jtPM_problem(update);
                    sql_update += Insert_detail(detail);
                    sql_update += Mgr_Appove();

                    DataTable dt = ConvertListToDataTable(list);

                    try
                    {
                        //  lb_test.Text += sql_update;return;

                        dc.RunCommand(conn, sql_update);
                        SendEmail_Close(dt);
                        alert_completed_reload();
                    }
                    catch (Exception ex)
                    {
                        alert_Messend(ex.Message.ToString());
                    }

                }
            }
        }

        //******************* END Modal Status Process************************** //
        #endregion


        //**** modal  ความหมาย ****//
        protected void btn_ProblemTypeMeaning_Click(object sender, EventArgs e)
        {

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#modal_ProblemTypeMeaning').modal('show')");
            sb.Append(@"</script>");
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "closemodal", sb.ToString(), false);
            return;
        }
        protected void btn_ActionMeaning_Click(object sender, EventArgs e)
        {

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#modal_ActionMeaning').modal('show')");
            sb.Append(@"</script>");
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "closemodal", sb.ToString(), false);
            return;
        }
        protected void btn_StatusMeaning_Click(object sender, EventArgs e)
        {

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#modal_StatusMeaning').modal('show')");
            sb.Append(@"</script>");
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "closemodal", sb.ToString(), false);
            return;
        }

        #region
        //********************** START modal INPUT Detail ************************//

        //Update Spec , Data Actual , Problem Detail
        protected void btn_UpdateProblem_moredetail_Click(object sender, EventArgs e)
        {
            if (lb_spec.Text != "")
                txt_spec_old.Text = lb_spec.Text.Trim();
            if (lb_actual.Text != "")
                txt_actual_old.Text = lb_actual.Text.Trim();
            if (lb_detailProblem.Text != "")
                txt_detail_old.Text = lb_detailProblem.Text.Trim();


            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#modal_UpdateProblem_moredetail').modal('show')");
            sb.Append(@"</script>");
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "closemodal", sb.ToString(), false);
            Bind_data();
            return;
        }
        protected void btn_save_UpdateProblem_moredetail_Click(object sender, EventArgs e)
        {
            string detail = "";
            string sql_update = "";
            string update = "";

            if ((txt_spec_new.Text.Trim() != "") && (txt_spec_old.Text != txt_spec_new.Text.Trim()))
            {
                update += " ,spec_checkList = '" + txt_replace(txt_spec_new.Text.Trim()) + "' ";
                detail += " Update Spec : " + txt_replace(txt_spec_old.Text) + " --> " + txt_replace(txt_spec_new.Text.Trim()) + " , ";
            }

            if ((txt_actual_old.Text != txt_actual_new.Text.Trim()) && (txt_actual_new.Text.Trim() != ""))
            {
                update += " , actual_spec_checkList = '" + txt_replace(txt_actual_new.Text.Trim()) + "' ";
                detail += " Update Data Actual : " + txt_replace(txt_actual_old.Text) + " --> " + txt_replace(txt_actual_new.Text.Trim()) + " , ";
            }

            if ((txt_detail_old.Text != txt_detail_new.Text.Trim()) && (txt_detail_new.Text.Trim() != ""))
            {
                update += ", prob_detail = '" + txt_replace(txt_detail_new.Text.Trim()) + "' ";
                detail += " Update Problem Detail : " + txt_replace(txt_detail_old.Text) + " --> " + txt_replace(txt_detail_new.Text.Trim()) + " , ";
            }


            if (update == "" && detail == "")
                return;

            sql_update += Update_jtPM_problem(update);
            sql_update += Insert_detail(detail);

            try
            {
                // lb_test.Text = sql_update; return;
                dc.RunCommand(conn, sql_update);
                alert_completed_reload();

            }
            catch (Exception ex)
            {
                alert_Messend(ex.Message.ToString());
            }
        }

        //Update Data Result , Action Detail
        protected void btn_UpdateAction_moredetail_Click(object sender, EventArgs e)
        {
            if (lb_result_spec.Text != "")
                txt_result_action_old.Text = lb_result_spec.Text.Trim();
            if (lb_result_detail.Text != "")
                txt_detail_action_old.Text = lb_result_detail.Text.Trim();

            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#modal_UpdateAction_moredetail').modal('show')");
            sb.Append(@"</script>");
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "closemodal", sb.ToString(), false);
            Bind_data();
            return;
        }
        protected void btn_save_UpdateAction_moredetail_Click(object sender, EventArgs e)
        {
            string detail = "";
            string sql_update = "";
            string update = "";

            if ((txt_result_action_new.Text.Trim() != "") && (txt_result_action_old.Text != txt_result_action_new.Text.Trim()))
            {
                update += ", result_spec_checkList = N'" + txt_replace(txt_result_action_new.Text.Trim()) + "' ";
                detail += " Update Data Result :" + txt_replace(txt_result_action_old.Text) + " --> " + txt_replace(txt_result_action_new.Text.Trim()) + " , ";
            }

            if ((txt_detail_action_new.Text.Trim() != "") && (txt_detail_action_old.Text != txt_detail_action_new.Text.Trim()))
            {
                update += ", result_prob_detail = N'" + txt_replace(txt_detail_action_new.Text.Trim()) + "' ";
                detail += " Update Action Detail :" + txt_replace(txt_detail_action_old.Text) + " --> " + txt_replace(txt_detail_action_new.Text.Trim()) + " , ";
            }

            if (update == "" && detail == "")
                return;

            sql_update += Update_jtPM_problem(update);
            sql_update += Insert_detail(detail);

            try
            {
                // lb_test.Text = ; return;update
                dc.RunCommand(conn, sql_update);
                alert_completed_reload();

            }
            catch (Exception ex)
            {
                alert_Messend(ex.Message.ToString());
            }
        }

        //Update Problem Detail
        protected void btn_UpdateProblemDetail_Click(object sender, EventArgs e)
        {
            if (txt_probTopic.Text != "")
                txt_proDetal_old.Text = txt_probTopic.Text.Trim();

            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#modal_UpdateProblemDetail').modal('show')");
            sb.Append(@"</script>");
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "closemodal", sb.ToString(), false);
            Bind_data();
            return;
        }
        protected void btn_save_UpdateProblemDetail_Click(object sender, EventArgs e)
        {
            string detail = "";
            string sql_update = "";
            string update = "";

            update += ", prob_topic = '" + txt_replace(txt_proDetal_new.Text.Trim()) + "' ";
            detail += " Update Action Detail :" + txt_replace(txt_proDetal_old.Text) + " --> " + txt_replace(txt_proDetal_new.Text.Trim()) + " , ";

            sql_update += Update_jtPM_problem(update);
            sql_update += Insert_detail(detail);

            try
            {
                //  lb_test.Text = ; return;update
                dc.RunCommand(conn, sql_update);
                alert_completed_reload();
            }
            catch (Exception ex)
            {
                alert_Messend(ex.Message.ToString());
            }
        }

        // Update Resp.Name,Resp.Group
        protected void btn_Update_Resp_Click(object sender, EventArgs e)
        {
            if (ddl_pic1.SelectedValue.ToString() != "")
                txt_resp_name_old.Text = ddl_pic1.SelectedItem.ToString();


            if (ddl_group.SelectedItem.ToString() != "")
                txt_resp_group_old.Text = ddl_group.SelectedItem.ToString();

            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#modal_Update_Resp').modal('show')");
            sb.Append(@"</script>");
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "closemodal", sb.ToString(), false);

            return;
        }
        protected void ddl_resp_group_new_SelectedIndexChanged(object sender, EventArgs e)
        {
            string group_id = (ddl_resp_group_new.SelectedValue.ToString() == "" ? "0" : ddl_resp_group_new.SelectedValue.ToString());

            Get_ddl_resp_group_update(group_id, ddl_resp_name_new);
        }
        protected void btn_save_Update_Resp_Click(object sender, EventArgs e)
        {

            string detail = "";
            string sql_update = "";
            string update = "";

            if (txt_resp_group_old.Text != ddl_resp_group_new.SelectedItem.ToString())
            {
                update += ", group_resp = '" + ddl_resp_group_new.SelectedValue + "' ";
                detail += " Update Resp.Name :" + txt_resp_group_old.Text + " --> " + ddl_resp_group_new.SelectedItem.ToString() + " , ";
            }
            if (txt_resp_name_old.Text != ddl_resp_name_new.SelectedItem.ToString())
            {
                update += ", pic = '" + ddl_resp_name_new.SelectedValue + "' ";
                detail += " and Resp.Group : " + txt_resp_name_old.Text + " --> " + ddl_resp_name_new.SelectedItem.ToString() + " , ";

            }

            sql_update += Update_jtPM_problem(update);
            sql_update += Insert_detail(detail);

            try
            {
                //  lb_test.Text = sql_update; return;
                dc.RunCommand(conn, sql_update);
                alert_completed_reload();

            }
            catch (Exception ex)
            {
                alert_Messend(ex.Message.ToString());
            }
        }

        //Update Follow Up date , Plan Finish , Actual Finish
        protected void btn_Update_FollowUp_date_Click(object sender, EventArgs e)
        {
            if (txt_follow_up.Text != "")
                txt_followDate_old.Text = txt_follow_up.Text.Trim();
            if (txt_planFinish.Text != "")
                txt_planFinish_old.Text = txt_planFinish.Text.Trim();
            if (txt_actualFinish.Text != "")
                txt_actualFinish_old.Text = txt_actualFinish.Text.Trim();

            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#modal_Update_FollowUp_date').modal('show')");
            sb.Append(@"</script>");
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "closemodal", sb.ToString(), false);
            Bind_data();
            return;
        }
        protected void btn_save_Update_FollowUp_date_Click(object sender, EventArgs e)
        {
            string detail = "";
            string update = "";
            string sql_update = "";

            if (txt_followDate_new.Text != "")
            {
                if (convetDate_format(txt_followDate_old.Text) != convetDate_format(txt_followDate_new.Text))
                {
                    update += " ,Follow_up = '" + txt_replace(txt_followDate_new.Text.Trim()) + "' ";
                    detail += " Update Follow Up date " + convetDate_format(txt_followDate_old.Text) + " --> " + convetDate_format(txt_followDate_new.Text.Trim()) + " , ";
                }
            }
            if (txt_planFinish_new.Text != "")
            {
                if (convetDate_format(txt_planFinish_old.Text) != convetDate_format(txt_planFinish_new.Text))
                {
                    update += " ,plan_finish = '" + txt_replace(txt_planFinish_new.Text.Trim()) + "' ";
                    detail += " Update Plan Finish  " + convetDate_format(txt_planFinish_old.Text) + " --> " + convetDate_format(txt_planFinish_new.Text.Trim()) + " , ";

                }
            }

            if (txt_actualFinish_new.Text != "")
            {
                if (convetDate_format(txt_actualFinish_old.Text) != convetDate_format(txt_actualFinish_new.Text))
                {
                    update += " ,actual_finish = '" + txt_replace(txt_actualFinish_new.Text.Trim()) + "' ";
                    detail += " Update Actual Finish " + convetDate_format(txt_actualFinish_old.Text) + " --> " + convetDate_format(txt_actualFinish_new.Text) + " , ";

                }
            }

            detail += " (Detail) : " + txt_detail_followDate.Text.Trim();

            sql_update += Update_jtPM_problem(update);
            sql_update += Insert_detail(detail);

            try
            {
                //lb_test.Text = sql_update; return;
                dc.RunCommand(conn, sql_update);
                alert_completed_reload();

            }
            catch (Exception ex)
            {
                alert_Messend(ex.Message.ToString());
            }
        }

        //Update Type,Issue Name,Problem Date,Shift
        protected void btn_Update_Type_Issue_Click(object sender, EventArgs e)
        {
            string manual_status = ViewState["manual_status"].ToString();
            //type
            if (ddl_type.SelectedItem.ToString() != "")
                txt_type_old.Text = ddl_type.SelectedItem.ToString();

            //problem date
            if (txt_problemDate.Text != "")
                txt_problemDate_old.Text = txt_problemDate.Text.Trim();

            if (txt_problemDate.Text != "" && manual_status == "0")
            {
                txt_problemDate_new.Text = txt_problemDate_old.Text;
                txt_problemDate_new.Enabled = false;
            }

            //shift
            if (ddl_shift.SelectedItem.ToString() != "")
                txt_shift_old.Text = ddl_shift.SelectedItem.ToString();


            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#modal_Update_Type_Issue').modal('show')");
            sb.Append(@"</script>");
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "closemodal", sb.ToString(), false);
            Bind_data();
            return;
        }
        protected void btn_save_Type_Issue_Click(object sender, EventArgs e)
        {
            string detail = "";
            string sql_update = "";
            string manual_status = ViewState["manual_status"].ToString();
            string PRC_Grop_name = ViewState["PRC_Grop_name"].ToString();
            lb_test.Text = "AAAAA";

            if (txt_type_old.Text != ddl_type_new.SelectedItem.ToString())
                detail += " Update Type " + txt_type_old.Text + " --> " + ddl_type_new.SelectedItem.ToString() + " , ";

            if (convetDate_format(txt_problemDate_old.Text.Trim()) != convetDate_format(txt_problemDate_new.Text.Trim()))
                detail += " Update Problem Date " + txt_problemDate_old.Text.Trim() + " --> " + txt_problemDate_new.Text.Trim() + " , ";

            if (txt_shift_old.Text.Trim() != ddl_shift_new.SelectedItem.ToString())
                detail += " Update Shift " + txt_shift_old.Text + " --> " + ddl_shift_new.SelectedItem.ToString() + " , ";

            //update check date  Problem manual
            if ((manual_status == "1") && (convetDate_format(txt_problemDate_old.Text.Trim()) != convetDate_format(txt_problemDate_new.Text.Trim())))
                sql_update += " update jtPM_PeriodCheck_his set check_date = '" + txt_problemDate_new.Text.Trim() + "'  where PRC_Grop_name = '" + PRC_Grop_name + "' ";

            string update = " , PM_DOC =   = " + ddl_type_new.SelectedValue.ToString() + " ,shift = '" + ddl_shift_new.SelectedValue.ToString() + "'";

            sql_update += Update_jtPM_problem(update);
            sql_update += Insert_detail(detail);

            try
            {
                //lb_test.Text = sql_update; return;
                dc.RunCommand(conn, sql_update);
                alert_completed_reload();

            }
            catch (Exception ex)
            {
                alert_Messend(ex.Message.ToString());
            }
        }

        //Update Action
        protected void btn_UpdateAction_Click(object sender, EventArgs e)
        {
            if (ddl_Action.SelectedItem.ToString() != "")
                txt_ActionCurrent.Text = ddl_Action.SelectedItem.ToString();


            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#modal_UpdateAction').modal('show')");
            sb.Append(@"</script>");
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "closemodal", sb.ToString(), false);
            Bind_data();
            return;
        }
        protected void btn_save_UpdateAction_Click(object sender, EventArgs e)
        {
            string detail = "Update Action  " + txt_ActionCurrent.Text + " --> " + ddl_ActionNew.SelectedItem.ToString() + " ";
            string sql_update = "";
            string update = "  , action_id  = '" + ddl_ActionNew.SelectedValue.ToString() + "'";
            sql_update += Update_jtPM_problem(update);
            sql_update += Insert_detail(detail);

            try
            {
                // lb_test.Text = sql_update; return;
                dc.RunCommand(conn, sql_update);
                alert_completed_reload();

            }
            catch (Exception ex)
            {
                alert_Messend(ex.Message.ToString());
            }
        }

        //Update Type of Problem
        protected void btn_update_TypeProblem_Click(object sender, EventArgs e)
        {
            if (ddl_Pro_type1.SelectedItem.ToString() != "")
                txt_TypeproblemCurrent.Text = ddl_Pro_type1.SelectedItem.ToString();

            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#modal_UpdateTypeproblem').modal('show')");
            sb.Append(@"</script>");
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "closemodal", sb.ToString(), false);
            Bind_data();
            return;
        }
        protected void btn_save_UpdateTypeproblem_Click(object sender, EventArgs e)
        {

            string detail = "Update Type of Problem  " + txt_TypeproblemCurrent.Text + " --> " + ddl_TypeproblemNew.SelectedItem.ToString() + " ";
            string sql_update = "";
            string update = "  , pro_type1 = '" + ddl_TypeproblemNew.SelectedValue.ToString() + "' ";
            sql_update += Update_jtPM_problem(update);
            sql_update += Insert_detail(detail);

            try
            {
                // lb_test.Text = sql_update; return;
                dc.RunCommand(conn, sql_update);
                alert_completed_reload();

            }
            catch (Exception ex)
            {
                alert_Messend(ex.Message.ToString());
            }
        }

        //Update Problem Rank
        protected void btn_update_ProblemRank_Click(object sender, EventArgs e)
        {
            if (ddl_priority.SelectedItem.ToString() != "")
                txt_ProblemRankCurrent.Text = ddl_priority.SelectedItem.ToString();

            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#modal_UpdateProblemRank').modal('show')");
            sb.Append(@"</script>");
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "closemodal", sb.ToString(), false);
            Bind_data();
            return;
        }
        protected void btn_save_UpdateProblemRank_Click(object sender, EventArgs e)
        {
            string detail = "Update Problem Rank  " + txt_ProblemRankCurrent.Text + " --> " + ddl_ProblemRankNew.SelectedItem.ToString() + " ";
            string sql_update = "";
            string update = "  , priority = '" + ddl_ProblemRankNew.SelectedValue.ToString() + "' ";
            sql_update += Update_jtPM_problem(update);
            sql_update += Insert_detail(detail);

            try
            {
                //  lb_test.Text = sql_update; return;
                dc.RunCommand(conn, sql_update);
                alert_completed_reload();

            }
            catch (Exception ex)
            {
                alert_Messend(ex.Message.ToString());
            }


        }

        //**************************** END modal INPUT Detail ******************************//
        #endregion


        //****************************Common*************************************//
        //--Get Resp Name by group--//
        protected void Get_ddl_resp_group_update(string eng_group_id, DropDownList ddl)
        {
            string str2 = " select '-Select-' as name ,0 as position_id,0 as eng_group_id,0 as user_dept,'' as emp_id , 0 as order_ union select REPLACE(REPLACE(fname,'Ms.',''),'Mr.','') + ' ' + SUBSTRING(lname,1,1) + '.' as name,position_id,eng_group_id,user_dept ,emp_id, 1 as order_ from user_master.dbo.sys_user_master a where eng_group_id =" + eng_group_id + " and user_dept in (3,5) and position_id <> 7 and status = 1 and position_id <> 9 order by order_ ";
            dc.QryDT(conn, str2);

            ddl.DataSource = dc.dt;
            ddl.DataTextField = "name";
            ddl.DataValueField = "emp_id";
            ddl.DataBind();
        }
        protected string Insert_detail(string detail)
        {
            string PM_problem_id = Request.QueryString["pm_problem_id"].ToString();
            string PM_problem_name = Request.QueryString["pm_problem_name"].ToString();
            string sql_str = "";

            sql_str += " INSERT INTO [jtPM_detail_problem_his] ([PM_Problem_id],[prob_detail],[emp_id],[add_date],[PM_Problem_name]) ";
            sql_str += " VALUES ( " + PM_problem_id + ", '" + detail + "','" + Session["emp_id"] + "',GETDATE(),'" + PM_problem_name + "')";

            return sql_str;
        }
        protected string Update_jtPM_problem(string update)
        {
            string PM_problem_id = Request.QueryString["pm_problem_id"].ToString();
            string PM_problem_name = Request.QueryString["pm_problem_name"].ToString();

            string sql_str = "";
            sql_str += " update jtPM_problem set PM_problem_name = '" + PM_problem_name + "' " + update + " where PM_problem_name = '" + PM_problem_name + "'  ";

            return sql_str;
        }
        protected string J3_ToolOwner_Appvoe()
        {
            string PM_problem_id = Request.QueryString["pm_problem_id"].ToString();
            string PM_problem_name = Request.QueryString["pm_problem_name"].ToString();
            string update = "";
            string select = "select * from jtPM_ProblemCheck_approve where PM_problem_name = N'" + PM_problem_name + "'";

            dc.QryDT(conn, select);

            if (dc.dt.Rows.Count > 0)
            {
                update += " update jtPM_ProblemCheck_approve set ";
                update += " Leader_eng3_by = N'" + Session["emp_id"].ToString() + "'";
                update += " , Leader_eng3_date = '" + DateTime.Today.ToString("dd-MMM-yy") + "'";
                update += " where PM_problem_name = N'" + PM_problem_name + "'";
            }
            else
            {

                update += " insert into jtPM_ProblemCheck_approve ";
                update += " ( PM_problem_id ";
                update += " , PM_problem_name ";
                update += " , Leader_eng3_by ";
                update += " , Leader_eng3_date ) ";
                update += " values ";
                update += " ( " + PM_problem_id + "";
                update += " , N'" + PM_problem_name + "'";
                update += " , N'" + Session["emp_id"].ToString() + "'";
                update += " , '" + DateTime.Today.ToString("dd-MMM-yy") + "' ) ";
            }

            return update;
        }
        protected string ENG4_J3_Appvoe()
        {
            string PM_problem_id = Request.QueryString["pm_problem_id"].ToString();
            string PM_problem_name = Request.QueryString["pm_problem_name"].ToString();
            string update = "";
            string select = "select * from jtPM_ProblemCheck_approve where PM_problem_name = N'" + PM_problem_name + "'";
            dc.QryDT(conn, select);

            if (dc.dt.Rows.Count > 0)
            {
                update += " update jtPM_ProblemCheck_approve set ";
                update += " Leader_eng4_by = N'" + Session["emp_id"].ToString() + "'";
                update += " , Leader_eng4_date = '" + DateTime.Today.ToString("dd-MMM-yy") + "'";
                update += " where PM_problem_name = N'" + PM_problem_name + "'";
            }
            else
            {

                update += " insert into jtPM_ProblemCheck_approve ";
                update += " ( PM_problem_id ";
                update += " , PM_problem_name ";
                update += " , Leader_eng4_by ";
                update += " , Leader_eng4_date ) ";
                update += " values ";
                update += " ( " + PM_problem_id + "";
                update += " , N'" + PM_problem_name + "' ";
                update += " , N'" + Session["emp_id"].ToString() + "'";
                update += " , '" + DateTime.Today.ToString() + "' ) ";
            }
            return update;
        }
        protected string Mgr_Appove()
        {
            string PM_problem_id = Request.QueryString["pm_problem_id"].ToString();
            string PM_problem_name = Request.QueryString["pm_problem_name"].ToString();
            string update = "";

            string select = "select * from jtPM_ProblemCheck_approve where PM_problem_name = N'" + PM_problem_name + "'";
            dc.QryDT(conn, select);

            if (dc.dt.Rows.Count > 0)
            {
                update += " update jtPM_ProblemCheck_approve set ";
                update += " Mgr_by = N'" + Session["emp_id"].ToString() + "'";
                update += " , Mgr_date = '" + DateTime.Today.ToString("dd-MMM-yy") + "'";
                update += " where PM_problem_name = N'" + PM_problem_name + "'";
            }
            else
            {

                update += " insert into jtPM_ProblemCheck_approve ";
                update += " ( PM_problem_id ";
                update += " , PM_problem_name ";
                update += " , Mgr_by ";
                update += " , Mgr_date ) ";
                update += " values ";
                update += " ( " + PM_problem_id + "";
                update += " , N'" + PM_problem_name + "'";
                update += " , N'" + Session["emp_id"].ToString() + "'";
                update += " , '" + DateTime.Today.ToString("dd-MMM-yy") + "' ) ";

            }
            return update;
        }
        protected string convetDate_format(string date)
        {
            string date_new = Convert.ToDateTime(date).ToString("dd-MMM-yyyy");
            return date_new;
        }
        protected DataTable Get_Data_Check(string status)
        {
            string select = "";
            select += " select * from PM_Tool_History A ";
            select += " left join( ";
            select += " select COUNT(PM_problem_id) as count_item , rep_group as item_group from PM_Tool_History A ";
            select += " where A.PM_problem_id is not null and A.isOnplan = " + status + "  ";
            select += " group by rep_group ";
            select += " ) B on A.rep_group = B.item_group ";
            select += " where A.PM_problem_id is not null and A.isOnplan = " + status + "  and A.PM_problem_name = N'" + hd_pmProblem_name.Value.Trim() + "' order by A.isOnplan desc  ";
            dc.QryDT(conn, select);
            return dc.dt;
        }

        //--Email--//
        protected void sendMail_error(string system, string page, string function, string error_ms)
        {

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["Sql"].ConnectionString);
            datacon dc = new datacon();
            //
            // TODO: Add constructor logic here
            //
            MailMessage mail = new MailMessage();
            mail.From = new MailAddress("engineer_pde@mail.canon");

            string email = "kanokorn@mail.canon";
            mail.To.Add(email);

            SmtpClient client = new SmtpClient();
            client.Port = 25;
            client.DeliveryMethod = SmtpDeliveryMethod.Network;
            client.Host = "150.61.249.70";

            mail.Subject = "[System Error!!!]";

            string mail_content = " Dear System member";

            mail_content += Environment.NewLine + Environment.NewLine + Environment.NewLine;
            mail_content += "System  : " + system;
            mail_content += Environment.NewLine;
            mail_content += "Page  : " + page;
            mail_content += Environment.NewLine;
            mail_content += "Function  : " + function;
            mail_content += Environment.NewLine;
            mail_content += "Error message  : " + error_ms;
            mail_content += Environment.NewLine;
            mail_content += "Emp_ID  : " + Session["emp_id"].ToString() + "   " + Session["user_name"].ToString();
            mail_content += Environment.NewLine;
            mail.Body = mail_content;
            client.Send(mail);


        }
        //**Script alert **//
        protected void alert_Messend(string Message)
        {
            sb.Append(@"<script type='text/javascript'>");
            sb.Append("alert('" + Message + "') ;window.location.href = window.location.href;");
            sb.Append(@"</script>");
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "closemodal", sb.ToString(), false);
            return;
        }
        protected void alert_completed_reload()
        {

            sb.Append(@"<script type='text/javascript'>");
            sb.Append(" alert('Completed.') ;window.location.href = window.location.href;");  //;
            sb.Append(@"</script>");
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "closemodal", sb.ToString(), false);
            return;
        }
        public string txt_replace(string text)
        {
            string txt_new = text.Replace("'", "''");
            return txt_new;
        }


        // ===================== [ CONST & UTILS ] =====================
        //private const string PDF_FOLDER = @"\\cptfile02\Pro\PRJ2015009\01_PM History\02_PM Problem\test"; // ที่จัดเก็บ PDF

        private string GetLatestPdfFullPath()
        {
            try
            {
                var folder = GetPdfFolderForCurrentProblem();
                if (string.IsNullOrEmpty(folder) || !Directory.Exists(folder)) return string.Empty;

                var files = Directory.GetFiles(folder, "*.pdf", SearchOption.TopDirectoryOnly);
                if (files.Length == 0) return string.Empty;

                return files.OrderByDescending(f => System.IO.File.GetLastWriteTime(f)).First();
            }
            catch { return string.Empty; }
        }
        private void TogglePdfMenu()
        {

            //bool hasFile = false;
            //try
            //{
            //    var folder = GetDwgFolderForCurrentProblem();
            //    hasFile = Directory.Exists(folder) &&
            //              Directory.GetFiles(folder, "*.pdf", SearchOption.TopDirectoryOnly).Length > 0;
            //}
            //catch { hasFile = false; }

            //btnPdfOpen.Visible = hasFile;
            //btnPdfDownload.Visible = hasFile;
            ToggleDrawingMenu();

        }
        // ===== [ MENU VISIBILITY ] =====
        private void ToggleDrawingMenu()
        {

            bool hasAny = false;
            try
            {
                var folder = GetDwgFolderForCurrentProblem();
                hasAny = Directory.Exists(folder) &&
                         Directory.EnumerateFiles(folder, "*.*", SearchOption.TopDirectoryOnly).Any();
            }
            catch { hasAny = false; }
            btnPdfOpen.Visible = hasAny;

            // ปุ่ม "Open" โชว์เมื่อมีไฟล์เปิดได้จริง
            // ปุ่ม Download จะอยู่ในแต่ละแถวของกริด (ดาวน์โหลดได้ทุกไฟล์)
        }

        // ===================== [ INLINE PDF STREAMER ] =====================
        // เรียกตอนต้น Page_Load เพื่อตอบ PDF กลับออกไปเป็น inline/attachment
        private void HandlePdfRequestIfAny()
        {

            //string mode = Request.QueryString["pdf"];   // "open" | "download"
            //if (string.IsNullOrEmpty(mode)) return;

            //string raw = Request.QueryString["name"] ?? "";
            //string decoded = HttpUtility.UrlDecode(raw) ?? "";
            //string safeName = Path.GetFileName(decoded); // กัน path traversal

            //string folder = GetDwgFolderForCurrentProblem(); // ✅ ชี้ไป DWG อย่างเดียว
            //if (string.IsNullOrEmpty(folder)) { Response.StatusCode = 404; Response.End(); return; }

            //string full = Path.Combine(folder, safeName);
            //if (!System.IO.File.Exists(full))
            //{
            //    Response.StatusCode = 404; Response.End(); return;
            //}

            //Response.Clear();
            //Response.Buffer = true;
            //Response.ContentType = "application/pdf";
            //Response.AddHeader("Content-Disposition",
            //        (mode == "download"
            //                ? string.Format("attachment; filename=\"{0}\"", safeName)
            //                : string.Format("inline; filename=\"{0}\"", safeName)));

            //Response.TransmitFile(full);  // เสถียรกับไฟล์ใหญ่
            //Response.End();

            HandleFileRequestIfAny();

        }
        // ===== [ GENERIC FILE STREAMER ] =====
        private void HandleFileRequestIfAny()
        {
            string mode = Request.QueryString["file"]; // "open" | "download"
            if (string.IsNullOrEmpty(mode)) return;

            string raw = Request.QueryString["name"] ?? "";
            string decoded = HttpUtility.UrlDecode(raw) ?? "";
            string safeName = Path.GetFileName(decoded); // กัน path traversal
            string folder = GetDwgFolderForCurrentProblem(); // ใช้ DWG โฟลเดอร์เดิม
            if (string.IsNullOrEmpty(folder) || !Directory.Exists(folder))
            { Response.StatusCode = 404; Response.End(); return; }

            string full = Path.Combine(folder, safeName);
            if (!System.IO.File.Exists(full))
            { Response.StatusCode = 404; Response.End(); return; }

            string ext = Path.GetExtension(full) ?? "";
            string mime = GetMimeTypeByExtension(ext);

            Response.Clear();
            Response.Buffer = true;
            Response.ContentType = mime;

            //bool wantOpen = string.Equals(mode, "open", StringComparison.OrdinalIgnoreCase);
            bool canOpen = IsInlinePreviewable(ext);
            bool wantOpen = string.Equals(mode, "open", StringComparison.OrdinalIgnoreCase);
            AddContentDisposition(Response, (wantOpen && canOpen), safeName);


            //if (string.Equals(mode, "open", StringComparison.OrdinalIgnoreCase) && canOpen)
            //{
            //    // เปิด inline เฉพาะชนิดที่ browser แสดงได้จริง
            //    Response.AddHeader("Content-Disposition", "inline; filename=\"" + safeName + "\"");
            //}
            //else
            //{
            //    // โหลดเสมอ (รวมถึงกรณีขอ open แต่ชนิดเปิดไม่ได้)
            //    Response.AddHeader("Content-Disposition", "attachment; filename=\"" + safeName + "\"");
            //}

            Response.TransmitFile(full);
            Response.End();
        }

        // ===================== [ MENU EVENTS ] =====================
        protected void btnPdfUpload_Click(object sender, EventArgs e)
        {
            // เปิดโมดัล Upload PDF
            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            sb.Append(@"<script type='text/javascript'>");
            sb.Append("$('#modal_UploadPdf').modal('show')");
            sb.Append(@"</script>");
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "showModalPdf", sb.ToString(), false);
        }
        protected void btnPdfOpen_Click(object sender, EventArgs e)
        {
            //BindPdfListAndShow();  // โชว์ลิสต์ให้เลือกไฟล์แล้วค่อย Open
            BindDrawingListAndShow(); // โชว์ลิสต์ไฟล์ทั้งหมดใน DWG
        }

        //protected void btnPdfDownload_Click(object sender, EventArgs e)
        //{
        //    BindPdfListAndShow();  // ใช้ลิสต์เดียวกัน (มีปุ่ม Download แยกในแต่ละแถว)
        //}

        //protected void btnUploadPdfConfirm_Click(object sender, EventArgs e)
        //{

        //    lbPdfError.Text = "";
        //    try
        //    {
        //        HttpFileCollection hfc = Request.Files;
        //        var targetFolder = GetDwgFolderForCurrentProblem(); // โฟลเดอร์ DWG

        //        if (string.IsNullOrEmpty(targetFolder))
        //        {
        //            lbPdfError.Text = "ไม่พบเลขปัญหา (Problem No).";
        //            btnPdfUpload_Click(sender, e);
        //            return;
        //        }

        //        // ✅ สร้าง DWG ถ้าไม่มี
        //        if (!Directory.Exists(targetFolder))
        //            Directory.CreateDirectory(targetFolder);

        //        int saved = 0;
        //        for (int i = 0; i < hfc.Count; i++)
        //        {
        //            var posted = hfc[i];
        //            if (posted == null || posted.ContentLength <= 0) continue;

        //            // รับเฉพาะไฟล์จาก control UploadPdf
        //            if (!string.Equals(hfc.GetKey(i), UploadPdf.UniqueID, StringComparison.OrdinalIgnoreCase)) continue;

        //            string fileName = Path.GetFileName(posted.FileName);
        //            string ext = Path.GetExtension(fileName);
        //            if (!ext.Equals(".pdf", StringComparison.OrdinalIgnoreCase)) continue;

        //            string fullPath = Path.Combine(targetFolder, fileName);
        //            posted.SaveAs(fullPath);
        //            saved++;
        //        }

        //        if (saved == 0)
        //        {
        //            lbPdfError.Text = "กรุณาเลือกไฟล์ .PDF อย่างน้อย 1 ไฟล์";
        //            btnPdfUpload_Click(sender, e);
        //            return;
        //        }

        //        // ✅ หลัง upload: อัปเดตเมนู + โชว์ลิสต์ทันที (ไม่ reload ทั้งหน้า)
        //        TogglePdfMenu();
        //        BindPdfListAndShow();
        //    }
        //    catch (Exception ex)
        //    {
        //        lbPdfError.Text = ex.Message;
        //        btnPdfUpload_Click(sender, e);
        //    }
        //}
        // ===== [ UPLOAD - ALLOW ALL EXTENSIONS ] =====
        protected void btnUploadPdfConfirm_Click(object sender, EventArgs e)
        {
            lbPdfError.Text = "";
            try
            {
                HttpFileCollection hfc = Request.Files;
                var targetFolder = GetDwgFolderForCurrentProblem(); // โฟลเดอร์ DWG เดิม
                if (string.IsNullOrEmpty(targetFolder))
                {
                    lbPdfError.Text = "ไม่พบเลขปัญหา (Problem No).";
                    btnPdfUpload_Click(sender, e);
                    return;
                }
                if (!Directory.Exists(targetFolder)) Directory.CreateDirectory(targetFolder);

                int saved = 0;
                for (int i = 0; i < hfc.Count; i++)
                {
                    var posted = hfc[i];
                    if (posted == null || posted.ContentLength <= 0) continue;
                    if (!string.Equals(hfc.GetKey(i), UploadPdf.UniqueID, StringComparison.OrdinalIgnoreCase)) continue;

                    string fileName = Path.GetFileName(posted.FileName); // กัน path traversal
                    string fullPath = Path.Combine(targetFolder, fileName);

                    // (ทางเลือก) ป้องกันชนชื่อ: ถ้ามีอยู่แล้ว เติม (1), (2), ...
                    fullPath = EnsureUniqueFilePath(fullPath);

                    posted.SaveAs(fullPath);
                    saved++;
                }

                if (saved == 0)
                {
                    lbPdfError.Text = "กรุณาเลือกไฟล์อย่างน้อย 1 ไฟล์ (รองรับทุกนามสกุล)";
                    btnPdfUpload_Click(sender, e);
                    return;
                }

                // อัปเดตเมนู + เปิดลิสต์ทันที
                ToggleDrawingMenu();
                BindDrawingListAndShow();
            }
            catch (Exception ex)
            {
                lbPdfError.Text = ex.Message;
                btnPdfUpload_Click(sender, e);
            }
        }

        // ช่วยกันชื่อซ้ำ
        private static string EnsureUniqueFilePath(string path)
        {
            if (!System.IO.File.Exists(path)) return path;
            string dir = Path.GetDirectoryName(path);
            string name = Path.GetFileNameWithoutExtension(path);
            string ext = Path.GetExtension(path);
            int idx = 1;
            string candidate;
            do
            {
                candidate = Path.Combine(dir, name + " (" + (idx++) + ")" + ext);
            } while (System.IO.File.Exists(candidate));
            return candidate;
        }
        private string GetPdfFolderForCurrentProblem()
        {
            // โฟลเดอร์ PDF ของปัญหาปัจจุบัน: \\...\02_PM Problem\YYYY\{PM_no}

            // ใช้ hidden ถ้ามี ไม่งั้น fallback มาที่ QueryString (ตอนเปิด/ดาวน์โหลดไฟล์ผ่าน query จะได้ทำงาน)
            string pmNo = !string.IsNullOrWhiteSpace(hd_pmProblem_name.Value)
                            ? hd_pmProblem_name.Value
                            : (Request.QueryString["pm_problem_name"] ?? "").Trim();

            if (string.IsNullOrWhiteSpace(pmNo)) return string.Empty;

            // แยกปี 2 หลักจาก PM No ส่วนกลาง แล้วเติมคำนำหน้า 2 หลักของปีปัจจุบัน (เหมือนฝั่งรูปภาพในเพจ) 
            string[] parts = pmNo.Split('-'); // e.g. ["PM2","26","00091"]
            string yy = (parts.Length > 1 ? parts[1] : DateTime.Now.ToString("yy"));
            string thisYear = DateTime.Now.Year.ToString();    // e.g. "2026"
            string yyyy = thisYear.Substring(0, 2) + yy;       // "20" + "26" => "2026"

            string baseFolder = @"\\cptfile02\Pro\PRJ2015009\01_PM History\02_PM Problem";
            return Path.Combine(baseFolder, yyyy, pmNo);


        }
        private string GetDwgFolderForCurrentProblem()
        {
            /// \\cptfile02\Pro\PRJ2015009\01_PM History\02_PM Problem\YYYY\PM_NO\DWG
            // ใช้ PM No จาก hidden field หรือจาก QueryString (รองรับกรณีเปิดตรงจากลิงก์)

            string pmNo = !string.IsNullOrWhiteSpace(hd_pmProblem_name.Value)
                                ? hd_pmProblem_name.Value.Trim()
                                : (Request.QueryString["pm_problem_name"] ?? "").Trim();
            if (string.IsNullOrWhiteSpace(pmNo)) return string.Empty;

            string[] parts = pmNo.Split('-');
            string yy = (parts.Length > 1 ? parts[1] : DateTime.Now.ToString("yy"));
            string thisYear = DateTime.Now.Year.ToString();   // e.g. "2026"
            string yyyy = thisYear.Substring(0, 2) + yy;      // "20" + "26" => "2026"

            string baseFolder = @"\\cptfile02\Pro\PRJ2015009\01_PM History\02_PM Problem";
            return System.IO.Path.Combine(baseFolder, yyyy, pmNo, "DWG");

        }

        private DataTable BuildPdfList()
        {

            //DataTable dt = new DataTable();
            //dt.Columns.Add("Name", typeof(string));
            //dt.Columns.Add("SizeText", typeof(string));
            //dt.Columns.Add("Modified", typeof(string));

            //string folder = GetDwgFolderForCurrentProblem(); // โฟลเดอร์ DWG
            //if (string.IsNullOrEmpty(folder) || !Directory.Exists(folder)) return dt;

            //foreach (var p in Directory.EnumerateFiles(folder, "*.pdf", SearchOption.TopDirectoryOnly))
            //{
            //    var fi = new FileInfo(p);

            //    var r = dt.NewRow();
            //    r["Name"] = fi.Name;

            //    // ✅ ใช้ interpolated string จริง ไม่ใช่ text เฉย ๆ
            //    r["SizeText"] = (fi.Length < 1024 * 1024)
            //        ? string.Format("{0} KB", Math.Ceiling(fi.Length / 1024.0))
            //        : string.Format("{0:0.##} MB", (fi.Length / 1024.0 / 1024.0));

            //    r["Modified"] = fi.LastWriteTime.ToString("dd-MMM-yyyy HH:mm");
            //    dt.Rows.Add(r);
            //}

            //if (dt.Rows.Count > 0)
            //{
            //    // เรียงตามวันแก้ไขล่าสุด
            //    var view = dt.DefaultView;
            //    view.Sort = "Modified DESC";
            //    dt = view.ToTable();
            //}
            //return dt;
            return BuildDrawingFileList();

        }
        // ===== [ BUILD FILE LIST UNDER DWG ] =====
        private DataTable BuildDrawingFileList()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("Name", typeof(string));
            dt.Columns.Add("SizeText", typeof(string));
            dt.Columns.Add("Modified", typeof(string));
            dt.Columns.Add("CanOpen", typeof(bool));
            dt.Columns.Add("Mime", typeof(string));

            string folder = GetDwgFolderForCurrentProblem(); // โฟลเดอร์ DWG เดิม
            if (string.IsNullOrEmpty(folder) || !Directory.Exists(folder)) return dt;

            foreach (var p in Directory.EnumerateFiles(folder, "*.*", SearchOption.TopDirectoryOnly))
            {
                var fi = new FileInfo(p);
                string ext = fi.Extension ?? "";
                string mime = GetMimeTypeByExtension(ext);
                bool canOpen = IsInlinePreviewable(ext);

                var r = dt.NewRow();
                r["Name"] = fi.Name;
                r["SizeText"] = (fi.Length < 1024 * 1024)
                                ? string.Format("{0} KB", Math.Ceiling(fi.Length / 1024.0))
                                : string.Format("{0:0.##} MB", (fi.Length / 1024.0 / 1024.0));
                r["Modified"] = fi.LastWriteTime.ToString("dd-MMM-yyyy HH:mm");
                r["CanOpen"] = canOpen;
                r["Mime"] = mime;
                dt.Rows.Add(r);
            }

            if (dt.Rows.Count > 0)
            {
                var view = dt.DefaultView;
                view.Sort = "Modified DESC";
                dt = view.ToTable();
            }
            return dt;
        }
        private void BindPdfListAndShow()
        {
            //var dt = BuildPdfList();           // อ่านจาก DWG (ของคุณแก้แล้ว)
            var dt = BuildDrawingFileList();
            gvPdf.DataSource = dt;
            gvPdf.DataBind();

            lbPdfListEmpty.Visible = (dt.Rows.Count == 0);

            var sb = new System.Text.StringBuilder();
            sb.Append("<script type='text/javascript'>$('#modal_PdfList').modal('show');</script>");
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "showPdfList", sb.ToString(), false);
        }
        // ===== [ BIND & SHOW LIST ] =====
        private void BindDrawingListAndShow()
        {
            var dt = BuildDrawingFileList();
            gvPdf.DataSource = dt;
            gvPdf.DataBind();
            lbPdfListEmpty.Visible = (dt.Rows.Count == 0);

            var sb = new System.Text.StringBuilder();
            sb.Append("<script type='text/javascript'>$('#modal_PdfList').modal('show');</script>");
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "showFileList", sb.ToString(), false);
        }
        //protected void gvPdf_RowCommand(object sender, GridViewCommandEventArgs e)
        //{
        //    string fileName = Convert.ToString(e.CommandArgument ?? "").Trim();
        //    if (string.IsNullOrEmpty(fileName)) return;

        //    if (e.CommandName.Equals("open", StringComparison.OrdinalIgnoreCase))
        //    {
        //        string url = BuildPdfUrl("open", fileName);
        //        ScriptManager.RegisterStartupScript(
        //            this, this.GetType(),
        //            "openPdf",
        //            "window.open('" + url + "', '_blank');",
        //            true
        //        );
        //    }
        //    else if (e.CommandName.Equals("download", StringComparison.OrdinalIgnoreCase))
        //    {
        //        string url = BuildPdfUrl("download", fileName);
        //        ScriptManager.RegisterStartupScript(
        //            this, this.GetType(),
        //            "downloadPdf",
        //            "window.location='" + url + "';",
        //            true
        //        );
        //    }
        //    else if (e.CommandName.Equals("del", StringComparison.OrdinalIgnoreCase))  // ← ใช้ del
        //    {
        //        try
        //        {
        //            string folder = GetDwgFolderForCurrentProblem();
        //            if (!string.IsNullOrEmpty(folder))
        //            {
        //                string safe = Path.GetFileName(fileName);
        //                string full = Path.Combine(folder, safe);
        //                if (System.IO.File.Exists(full)) System.IO.File.Delete(full);
        //                else alert_Messend("ไม่พบไฟล์: " + safe);
        //            }
        //            TogglePdfMenu();
        //            BindPdfListAndShow();   // rebind + เปิดโมดัลต่อ
        //        }
        //        catch (Exception ex)
        //        {
        //            alert_Messend(ex.Message);
        //        }
        //    }
        //}

        // ช่วยสร้าง URL ใหม่ โดยเก็บ QueryString เดิมไว้ครบ
        protected void gvPdf_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            string fileName = Convert.ToString(e.CommandArgument ?? "").Trim();
            if (string.IsNullOrEmpty(fileName)) return;

            if (e.CommandName.Equals("open", StringComparison.OrdinalIgnoreCase))
            {
                string url = BuildFileUrl("open", fileName);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "openFile",
                    "window.open('" + url + "', '_blank');", true);
            }
            else if (e.CommandName.Equals("download", StringComparison.OrdinalIgnoreCase))
            {
                string url = BuildFileUrl("download", fileName);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "downloadFile",
                    "window.location='" + url + "';", true);
            }
            else if (e.CommandName.Equals("del", StringComparison.OrdinalIgnoreCase))
            {
                try
                {
                    string folder = GetDwgFolderForCurrentProblem();
                    if (!string.IsNullOrEmpty(folder))
                    {
                        string safe = Path.GetFileName(fileName);
                        string full = Path.Combine(folder, safe);
                        if (System.IO.File.Exists(full)) System.IO.File.Delete(full);
                        else alert_Messend("ไม่พบไฟล์: " + safe);
                    }
                    ToggleDrawingMenu();
                    BindDrawingListAndShow(); // rebind
                }
                catch (Exception ex)
                {
                    alert_Messend(ex.Message);
                }
            }
        }
        protected void gvPdf_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType != DataControlRowType.DataRow) return;

            var btn = (LinkButton)e.Row.FindControl("btnOpen");
            var rv = e.Row.DataItem as DataRowView;
            bool canOpen = false;

            if (rv != null && rv.DataView != null && rv.DataView.Table != null)
            {
                // ถ้ามีคอลัมน์ CanOpen จริง -> ใช้ค่าได้
                if (rv.DataView.Table.Columns.Contains("CanOpen"))
                    canOpen = Convert.ToBoolean(rv["CanOpen"]);
                else
                    canOpen = false; // กันตก
            }
            btn.Visible = canOpen;
        }

        private string BuildPdfUrl(string mode, string fileName)
        {
            var uri = HttpContext.Current.Request.Url;                    // /PM_problem_follow_New.aspx?... (มี query เดิม)
            var q = HttpUtility.ParseQueryString(uri.Query ?? "");        // ดึง query เดิมทั้งหมด
            q.Set("pdf", mode);                                           // open | download
            q.Set("name", fileName);                                      // ใส่ชื่อไฟล์ (ไม่ต้อง encode ที่นี่ เดี๋ยว ParseQueryString ทำให้)
            return uri.AbsolutePath + "?" + q.ToString();                 // ประกอบกลับเป็น URL
        }
        // ===== [ BUILD FILE URL ] =====
        private string BuildFileUrl(string mode, string fileName)
        {
            var uri = HttpContext.Current.Request.Url; // เก็บ query เดิม
            var q = HttpUtility.ParseQueryString(uri.Query ?? "");
            q.Set("file", mode);  // "open" | "download"
            q.Set("name", fileName);
            return uri.AbsolutePath + "?" + q.ToString();
        }

        // ===== [ MIME MAP + PREVIEW CHECK ] =====
        private static readonly HashSet<string> InlinePreviewableExts = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
        {
            ".pdf", ".png", ".jpg", ".jpeg", ".gif", ".webp", ".svg", ".txt", ".csv"
            // หมายเหตุ: เพิ่มได้ตามต้องการ เช่น ".json", ".md"
        };
        private static string GetMimeTypeByExtension(string ext)
        {
            switch (ext.ToLowerInvariant())
            {
                case ".pdf": return "application/pdf";
                case ".png": return "image/png";
                case ".jpg":
                case ".jpeg": return "image/jpeg";
                case ".gif": return "image/gif";
                case ".webp": return "image/webp";
                case ".svg": return "image/svg+xml";
                case ".txt": return "text/plain; charset=utf-8";
                case ".csv": return "text/csv; charset=utf-8";
                default: return "application/octet-stream"; // ไม่รู้ชนิด -> ดาวน์โหลด
            }
        }
        private static bool IsInlinePreviewable(string ext)
        {
            return InlinePreviewableExts.Contains(ext);
        }
        private static void AddContentDisposition(HttpResponse resp, bool inline, string fileName)
        {
            // สร้าง fallback ชื่อ ASCII (ตัดอักษรนอก ASCII ออก/แทนที่)
            string asciiFallback = MakeAsciiFallback(fileName);
            string utf8Encoded = Uri.EscapeDataString(fileName); // percent-encode UTF-8

            string dispo = (inline ? "inline" : "attachment");
            // ใส่ทั้งสองแบบ: filename (fallback) + filename* (UTF-8)
            string headerValue = string.Format(
                "{0}; filename=\"{1}\"; filename*=UTF-8''{2}",
                dispo, asciiFallback, utf8Encoded);

            resp.AddHeader("Content-Disposition", headerValue);
        }
        private static string MakeAsciiFallback(string name)
        {
            // วิธีง่ายสุด: แทนที่อักขระที่ไม่ใช่ ASCII ด้วย '_'
            char[] arr = name.ToCharArray();
            for (int i = 0; i < arr.Length; i++)
            {
                if (arr[i] < 32 || arr[i] > 126) arr[i] = '_';
            }
            return new string(arr);
        }




        ///  Debug
        private void DebugPrintPdfList()
        {
            try
            {
                string folder = GetDwgFolderForCurrentProblem();
                if (string.IsNullOrEmpty(folder) || !Directory.Exists(folder))
                {
                    test1.Text = "DWG not found: " + folder;
                    return;
                }

                string[] files = Directory.GetFiles(folder, "*.pdf", SearchOption.TopDirectoryOnly);
                test1.Text = "DWG: " + folder + "<br/>PDF count: " + files.Length + "<br/>" +
                             string.Join("<br/>", files.Select(Path.GetFileName));
            }
            catch (Exception ex)
            {
                test1.Text = "ERR: " + ex.Message;
            }
        }

    }
}