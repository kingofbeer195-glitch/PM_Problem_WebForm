<%@ page title="PM Report Person" language="C#" autoeventwireup="true"
    codefile="PM_problem_Deail.aspx.cs"
    inherits="jig_tool.PM_problem_Deail"
    maintainscrollpositiononpostback="true" viewstatemode="Enabled"
    enableeventvalidation="false" %>

<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <link href="css/bootstrap_sum.css" rel="stylesheet" />

    <link href="css/w3v4.10.css" rel="stylesheet" />
    <link rel="stylesheet" href="Content/bootstrap.css" />
    <link href="chosen/chosen.css" rel="stylesheet" />
    <link rel="stylesheet" href="Content/bootstrap.css" />
    <link href="DateTimePicker/2-bootstrap-datetimepicker.min.css" rel="stylesheet" />
    <link href="DateTimePicker/3-bootstrap-datetimepicker-standalone.css" rel="stylesheet" />

    <script src="Scripts/jquery-1.9.1.js"></script>
    <script src="Scripts/bootstrap.min.js"></script>
    <script src="chosen/chosen.jquery.js"></script>
    <script src="JS/mine/btn_folderFiles.js"></script>
    <script src="DateTimePicker/1-moment.min.js"></script>
    <script src="DateTimePicker/4-bootstrap-datetimepicker.min.js"></script>

    <title></title>

    <style>
        .border_all {
            border: 1px solid;
            border-color: #aaa;
        }

        /* LRB : Left Right Bottom*/
        .border_LRB {
            border-left: 1px solid;
            border-right: 1px solid;
            border-bottom: 1px solid;
            border-color: #aaa;
        }
        /* RB : Right Bottom*/
        .border_RB {
            border-right: 1px solid;
            border-bottom: 1px solid;
            border-color: #aaa;
        }
        /* LR : Left Right */
        .border_LR {
            border-right: 1px solid;
            border-left: 1px solid;
            border-color: #aaa;
        }
        /* R : Right */
        .border_R {
            border-right: 1px solid;
            border-color: #aaa;
        }
        /* B : Bottom */
        .border_B {
            border-bottom: 1px solid;
            border-color: #aaa;
        }
        /* TR : Top Right Botton*/
        .border_TRB {
            border-top: 1px solid;
            border-right: 1px solid;
            border-bottom: 1px solid;
            border-color: #aaa;
        }
        /* Text Align ชิดชวา ตรงกลาง*/
        .TextAlign_CR {
            text-align: end;
            align-content: space-evenly;
        }
        /* Text Align ตรงกลาง ตรงกลาง*/
        .TextAlign_CC {
            text-align: center;
            align-content: space-evenly;
        }
        /* Text Align ตรงกลาง ตรงกลาง*/
        .TextAlign_CL {
            text-align: left;
            align-content: space-evenly;
        }
        /* Text สีแดง หนา*/
        .Style_text1 {
            /*font-size: 16px ;*/
            color: #ff0000;
            font-weight: bold;
        }
        /* Text สีเทา ตัวเล็ก*/
        .Style_text2 {
            font-size: 12px;
            color: #aaa;
            /*font-weight: bold;*/
        }

        .style_picture1 {
            text-align-last: center;
        }
        .img1Css{
            max-width:300px;
            max-height:180px;
        }
        .img2Css{
            max-width:500px;
            max-height:250px;
        }
        .img3Css{
            max-width:340px;
            max-height:220px;
        }
    </style>

    <style>
        body {
            margin: 0px;
        }

        .grid-container1 {
            display: grid;
            grid-template-columns: 100%;
            grid-template-rows: 50px;
            /*column-gap: 5px;*/
            background-color: #337ab7;
            /*border : 1px solid;*/
        }

            .grid-container1 > div {
            }

        .grid-container2 {
            display: grid;
            grid-template-columns: 100%;
            grid-template-rows: 40px;
            margin-top: 5px;
        }

            .grid-container2 > div {
            }

        .grid-container3 {
            display: grid;
            grid-template-columns: 180px 180px 180px 180px 180px;
            grid-template-rows: 100%;
            /*margin-top : 5px;*/
        }

            .grid-container3 > div {
            }

        .grid-container4 {
            display: grid;
            grid-template-columns: 100%;
            grid-template-rows: 180px 500px;
            /*border : 1px solid;*/
            margin: 10px;
        }

            .grid-container4 > div {
                /*border : 1px solid;*/
            }

        .grid-container5 {
            display: grid;
            grid-template-columns: 55% 45%;
            grid-template-rows: 100%;
            /*border : 1px solid;*/
        }

            .grid-container5 > div {
            }

        .grid-container6 {
            display: grid;
            grid-template-columns: 100%;
            grid-template-rows: 16% 16% 16% 16% 36%;
            /*border : 1px solid;*/
        }

            .grid-container6 > div {
            }

        .grid-container7 {
            display: grid;
            grid-template-columns: 15% 40% 15% 30%;
            grid-template-rows: 100%;
            /*border : 1px solid;*/
        }

            .grid-container7 > div {
            }

        .grid-container8 {
            display: grid;
            grid-template-columns: 15% 85%;
            grid-template-rows: 100%;
            /*border : 1px solid;*/
        }

            .grid-container8 > div {
            }

        .grid-container9 {
            display: grid;
            grid-template-columns: 15% 30% 15% 40%;
            grid-template-rows: 100%;
            /*border : 1px solid;*/
        }

            .grid-container9 > div {
            }

        .grid-container10 {
            display: grid;
            grid-template-columns: 15% 60% 25%;
            grid-template-rows: 100%;
            /*border : 1px solid;*/
        }

            .grid-container10 > div {
            }

        .grid-container11 {
            display: grid;
            grid-template-columns: 100%;
            grid-template-rows: 30% 70%;
            /*border : 1px solid;*/
        }

            .grid-container11 > div {
            }

        .grid-container12 {
            display: grid;
            grid-template-columns: 20% 45% 35%;
            grid-template-rows: 100%;
            /*border : 1px solid;*/
        }

            .grid-container12 > div {
            }

        .grid-container13 {
            display: grid;
            grid-template-columns: 70% 30%;
            grid-template-rows: 100%;
            /*border : 1px solid;*/
        }

            .grid-container13 > div {
            }

        .grid-container14 {
            display: grid;
            grid-template-columns: 20% Auto;
            grid-template-rows: 100%;
            /*border : 1px solid;*/
        }

            .grid-container14 > div {
            }

        .grid-container15 {
            display: grid;
            grid-template-columns: 100%;
            grid-template-rows: 16% 16% 32% 12% 24%;
            /*border : 1px solid;*/
        }

            .grid-container15 > div {
            }

        .grid-container16 {
            display: grid;
            grid-template-columns: 100%;
            grid-template-rows: 40% 60%;
            /*border : 1px solid;*/
        }

            .grid-container16 > div {
            }

        .grid-container17 {
            display: grid;
            grid-template-columns: 100%;
            grid-template-rows: 10% 90%;
            /*border : 1px solid;*/
        }

            .grid-container17 > div {
            }

        .grid-container18 {
            display: grid;
            grid-template-columns: 100%;
            grid-template-rows: 10% 15% 15% 60%;
            /*border : 1px solid;*/
        }

            .grid-container18 > div {
            }

        .grid-container19 {
            display: grid;
            grid-template-columns: 20% 80%;
            grid-template-rows: 100%;
            /*border : 1px solid;*/
        }

            .grid-container19 > div {
            }

        .grid-container20 {
            display: grid;
            grid-template-columns: 100%;
            grid-template-rows: 25% 50% 25%;
            /*border : 1px solid;*/
        }

            .grid-container20 > div {
            }

        .grid-container21 {
            display: grid;
            grid-template-columns: 100%;
            grid-template-rows: 16% 24% 60%;
            /*border : 1px solid;*/
        }

            .grid-container21 > div {
            }

        .grid-container22 {
            display: grid;
            grid-template-columns: 25% 25% 25% 25%;
            grid-template-rows: 20% 60% 20%;
            /*border : 1px solid;*/
        }

            .grid-container22 > div {
            }
    </style>

</head>
<body>
    <form id="form1" runat="server">

        <%--Head Detail--%>
        <div class="grid-container1">
            <%--<img src="images/problem-solving.png" style="height: 32px; padding-left: 5px; padding-right: 2px; padding-bottom: 2px; opacity: 0.8;" />--%>
            <b style="padding-left: 10px; font-size: 32px; color: #FFFFFF; align-self: center;">PM PROBLEM DETAIL</b>
        </div>

        <%--Button Link--%>
        <div class="grid-container2" style="align-items: center !important; justify-items: end; margin-right: 30px">

            <asp:LinkButton ID="btn_download_report" runat="server" OnClick="btn_download_report_Click">
                <asp:Image ID="excelReport" runat="server" ImageUrl="~/images/009-xls.png" Width="30px" Height="30px" />
            </asp:LinkButton>


        <%-- ปุ่ม Export to PDF --%>
             
            <%--<asp:ImageButton ID="btnExportPdf" runat="server" 
                ImageUrl="~/images/pdf.png" Height="30px"
                OnClick="btnExportPdf_Click" 
                ToolTip="Export and Save as PDF" />--%>
         
        </div>
        

        <asp:Label ID="lb_test" runat="server"></asp:Label>

        <%--PM Problem Sheet overall--%>
        <div class="grid-container4">

            <%--ส่วนบนของเอกสาร : ข้อมูลพื้นฐานของ Tool และ ปัญหา--%>
            <div class="grid-container5">

                <%--ฝั่งซ้ายของข้อมูลของข้อมูลพื้นฐาน--%>
                <div class="grid-container6">

                    <%--หัวเอกสาร PM Problem Report--%>
                    <div class="border_all" style="background-color: #ED7D31; font-weight: 600; align-content: space-evenly; text-align-last: center;">
                        PM PROBLEM REPORT
                    </div>

                    <%-- หัวข้อ Tool No.และ Tool Rank--%>
                    <div class="grid-container7">
                        <div class="border_LRB TextAlign_CR" style="background-color: #D9D9D9;">Tool No.: </div>

                        <%-- Database : Tool No --%>
                        <div class="border_RB TextAlign_CC Style_text1" style="">
                            <asp:Label ID="lb_toolno" runat="server"></asp:Label>
                        </div>

                        <div class="border_RB TextAlign_CR" style="background-color: #D9D9D9;">Tool Rank : </div>

                        <%-- Database : Tool Rank --%>
                        <div class="border_RB TextAlign_CC Style_text1" style="">
                            <asp:Label ID="lb_ranktool" runat="server"></asp:Label>
                        </div>
                    </div>

                    <%--หัวข้อ Tool Name--%>
                    <div class="grid-container8">
                        <div class="border_LRB TextAlign_CR" style="background-color: #D9D9D9;">Tool Name : </div>

                        <%-- Database : Tool Name --%>
                        <div class="border_RB TextAlign_CC Style_text1" style="">
                            <asp:Label ID="lb_toolname" runat="server"></asp:Label>
                        </div>
                    </div>

                    <%--หัวข้อ Model , Location--%>
                    <div class="grid-container9">
                        <div class="border_LRB TextAlign_CR" style="background-color: #D9D9D9;">Model : </div>

                        <%-- Database : Model --%>
                        <div class="border_RB TextAlign_CC Style_text1" style="">
                            <asp:Label ID="lb_model" runat="server"></asp:Label>
                        </div>

                        <div class="border_RB TextAlign_CR" style="background-color: #D9D9D9;">Location : </div>

                        <%-- Database : Location --%>
                        <div class="border_RB TextAlign_CC Style_text1" style="">
                            <asp:Label ID="lb_location" runat="server"></asp:Label>
                        </div>
                    </div>

                    <%--หัวเอกสาร Problem Detail , Plan Finish--%>
                    <div class="grid-container10">
                        <div class="border_LRB TextAlign_CR" style="background-color: #D9D9D9;">Problem : </div>

                        <%-- Database : Problem Detail --%>
                        <div class="border_RB TextAlign_CC Style_text1" style="">
                            <asp:Label ID="lb_problem" runat="server"></asp:Label>
                        </div>

                        <div class="grid-container11">
                            <div class="border_RB TextAlign_CC" style="background-color: #D9D9D9;">Plan Finish</div>

                            <%-- Database : Plan Finish --%>
                            <div class="border_RB TextAlign_CC Style_text1" style="">
                                <asp:Label ID="lb_Planfinish" runat="server"></asp:Label>
                            </div>
                        </div>
                    </div>

                </div>

                <%--ฝั่งขวาของข้อมูลของข้อมูลพื้นฐาน--%>
                <div class="grid-container13">
                    <div class="grid-container6">

                        <%-- หัวข้อ Issue by , Problem No--%>
                        <div class="grid-container12">
                            <div class="border_TRB TextAlign_CR" style="background-color: #D9D9D9;">Issue By :</div>

                            <%-- Database : Issue By --%>
                            <div class="border_TRB TextAlign_CC Style_text1" style="">
                                <asp:Label ID="lb_issueby" runat="server"></asp:Label>
                            </div>

                            <div class="border_TRB TextAlign_CR" style="background-color: #D9D9D9;">PM Problem No. :</div>
                        </div>

                        <%--Date : --%>
                        <div class="grid-container14">
                            <div class="border_RB TextAlign_CR" style="background-color: #D9D9D9;">Date :</div>

                            <%-- Database : Issue Date --%>
                            <div class="border_RB TextAlign_CC Style_text1" style="">
                                <asp:Label ID="lb_problemdate" runat="server"></asp:Label>
                            </div>
                        </div>

                        <%--No of Tool : --%>
                        <div class="grid-container14">
                            <div class="border_RB TextAlign_CR" style="background-color: #D9D9D9;">No of Tool :</div>

                            <%-- Database : sub tool id --%>
                            <div class="border_RB TextAlign_CC Style_text1" style="">
                                <asp:Label ID="lb_toolsubid" runat="server"></asp:Label>
                            </div>
                        </div>

                        <%--Fix Asset : --%>
                        <div class="grid-container14">
                            <div class="border_RB TextAlign_CR" style="background-color: #D9D9D9;">Fix Asset :</div>

                            <%-- Database : Fix Asset --%>
                            <div class="border_RB TextAlign_CC Style_text1" style="">
                                <asp:Label ID="lb_fixasset" runat="server"></asp:Label>
                            </div>
                        </div>

                        <%--Action : --%>
                        <div class="grid-container14">
                            <div class="border_RB TextAlign_CR" style="background-color: #D9D9D9;">Action :</div>

                            <%-- Database : Action --%>
                            <div class="border_RB TextAlign_CC Style_text1" style="">
                                <asp:Label ID="lb_action" runat="server"></asp:Label>
                            </div>
                        </div>
                    </div>

                    <%--Problem No , Problem Rank , Actual Finish--%>
                    <div class="grid-container15">

                        <%-- Database : Problem No --%>
                        <div class="border_TRB TextAlign_CC Style_text1" style="">
                            <asp:Label ID="lb_problemno" runat="server"><u></asp:Label>
                        </div>

                        <%--Problem Rank--%>
                        <div class="border_RB TextAlign_CC" style="background-color: #D9D9D9;">Problem Rank</div>

                        <%-- Database : Problem Rank --%>
                        <div class="border_RB TextAlign_CC Style_text1" style="background-color: #ffd800; font-size: 42px;">
                            <asp:Label ID="lb_problemrank" runat="server"></asp:Label>
                        </div>

                        <%--Actual Finish--%>
                        <div class="border_RB TextAlign_CC" style="background-color: #D9D9D9;">Actual Finish </div>

                        <%-- Database : Actual Finish --%>
                        <div class="border_RB TextAlign_CC Style_text1" style="">
                            <asp:Label ID="lb_finishdate" runat="server"></asp:Label>
                        </div>
                    </div>

                </div>
            </div>

            <%--Detail Problem & Action--%>
            <div class="grid-container5">

                <%--Problem Detail--%>
                <div class="grid-container16">
                    <div class="grid-container5">

                        <%--Picture Problem 1--%>
                        <div class="grid-container17">
                            <div class="border_LR TextAlign_CL Style_text2" style="">Picture Problem 1 </div>
                            <div class="border_LRB style_picture1" style="align-content: center; text-align-last: center;">
                                <asp:Image ID="img_pic1" runat="server" CssClass="img1Css" style="" />
                                <%--<asp:Image ID="Image1" runat="server" CssClass="img1Css" style="height: -webkit-fill-available;" />--%>
                            </div>
                        </div>

                        <%--Problem Detail--%>
                        <div class="grid-container18">
                            <div class="border_R TextAlign_CL Style_text2" style="">Problem Detail </div>
                            <%--Spec Detail--%>
                            <div class="grid-container19">
                                <div class="TextAlign_CR" style="background-color: #A9D08E">Spec :</div>
                                <div class="border_R TextAlign_CL" style="background-color: #C6E0B4; padding-left: 5px;">
                                    <asp:Label ID="lb_spec" runat="server"></asp:Label>
                                </div>
                            </div>

                            <%--Actual Detail--%>
                            <div class="grid-container19">
                                <div class="TextAlign_CR" style="background-color: #F8CBAD">Actual :</div>
                                <div class="border_R TextAlign_CL" style="background-color: #FCE4D6; padding-left: 5px;">
                                    <asp:Label ID="lb_actual" runat="server"></asp:Label>
                                </div>
                            </div>

                            <%--Problem Detail--%>
                            <div class="grid-container19">
                                <div class="border_B TextAlign_CR" style="background-color: #EDEDED">Detail :</div>
                                <div class="border_RB TextAlign_CL" style="padding-left: 5px;">
                                    <asp:Label ID="lb_problemdetail" runat="server"></asp:Label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%--Picture Problem 2--%>
                    <div class="grid-container17">
                        <div class="border_LR TextAlign_CL Style_text2" style="">Picture Problem 2 </div>
                        <div class="border_LRB style_picture1" style="align-content: center; text-align-last: center;">
                            <%--<asp:Image ID="img_pic2" runat="server" style="height: -webkit-fill-available;" />--%>
                            <asp:Image ID="img_pic2" runat="server" Cssclass= "img2Css" style="" />
                        </div>
                    </div>

                </div>

                <%--Action Detail--%>
                <div class="grid-container20">
                    <%--Action Detail--%>
                    <div class="grid-container21">
                        <%--หัว Topic Action Detail--%>
                        <div class="border_R TextAlign_CL Style_text2" style="">Action Detail</div>
                        <%--Data result--%>
                        <div class="grid-container19">
                            <div class="TextAlign_CR" style="background-color: #F8CBAD">Result :</div>
                            <div class="border_R TextAlign_CL" style="background-color: #FCE4D6; padding-left: 5px;">
                                <asp:Label ID="lb_result_spec" runat="server"></asp:Label>
                            </div>
                        </div>

                        <%--Action Detail--%>
                        <div class="grid-container19">
                            <div class="border_B TextAlign_CR" style="background-color: #EDEDED">Detail :</div>
                            <div class="border_RB TextAlign_CL" style="padding-left: 5px;">
                                <asp:Label ID="lb_result_detail" runat="server"></asp:Label>
                            </div>
                        </div>
                    </div>

                    <%--Picture Action--%>
                    <div class="grid-container17">
                        <div class="border_R TextAlign_CL Style_text2" style="">Picture Action </div>
                        <div class="border_RB style_picture1" style="align-content: center; text-align-last: center;">
                            <%--<asp:Image ID="img_pic_action" runat="server" style="height: -webkit-fill-available;" />--%>
                            <asp:Image ID="img_pic_action" runat="server" CssClass="img3Css" style="" />
                        </div>
                    </div>

                    <%-- Sign table--%>
                    <div class="grid-container22">
                        <div class="border_RB TextAlign_CC" style="background-color: #D9D9D9;">Approval</div>
                        <div class="border_RB TextAlign_CC" style="background-color: #D9D9D9;">Checker</div>
                        <div class="border_RB TextAlign_CC" style="background-color: #D9D9D9;">Leader Tool Owner</div>
                        <div class="border_RB TextAlign_CC" style="background-color: #D9D9D9;">Person incharge</div>
                        <div class="border_RB TextAlign_CC" style="">
                            <asp:Label ID="lb_approve" runat="server"></asp:Label>
                        </div>
                        <div class="border_RB TextAlign_CC" style="">
                            <asp:Label ID="lb_checker" runat="server"></asp:Label>
                        </div>
                        <div class="border_RB TextAlign_CC" style="">
                            <asp:Label ID="lb_toolowner" runat="server"></asp:Label>
                        </div>
                        <div class="border_RB TextAlign_CC" style="">
                            <asp:Label ID="lb_pic" runat="server"></asp:Label>
                        </div>
                        <div class="border_RB TextAlign_CC" style="">
                            <asp:Label ID="lb_approvedate" runat="server"></asp:Label>
                        </div>
                        <div class="border_RB TextAlign_CC" style="">
                            <asp:Label ID="lb_checkdate" runat="server"></asp:Label>
                        </div>
                        <div class="border_RB TextAlign_CC" style="">
                            <asp:Label ID="lb_toolownwedate" runat="server"></asp:Label>
                        </div>
                        <div class="border_RB TextAlign_CC" style="">
                            <asp:Label ID="lb_picdate" runat="server"></asp:Label>
                        </div>
                    </div>

                </div>
            </div>

        </div>
        <div>
            <asp:GridView runat="server" id="gv_test"></asp:GridView>
        </div>

    </form>
</body>
</html>
