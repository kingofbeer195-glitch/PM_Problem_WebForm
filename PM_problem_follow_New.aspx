<%@ Page Title="PM Report Person" Language="C#" AutoEventWireup="true"
    CodeFile="PM_problem_follow_New.aspx.cs"
    Inherits="jig_tool.PM_problem_follow_New"
    MaintainScrollPositionOnPostback="true" ViewStateMode="Enabled"
    EnableEventValidation="false" %>


<!DOCTYPE html>
<html lang="en">

<head runat="server">

    <title>PM Follow Problem</title>
    <link rel="icon" href="icon/problem.png" />

    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <%--<link href="css/bootstrap_sum.css" rel="stylesheet" />--%>

    <link href="css/w3v4.10.css" rel="stylesheet" />
    <link rel="stylesheet" href="Content/bootstrap.css" />
    <link href="chosen/chosen.css" rel="stylesheet" />
    <link href="css/ProcessForm.css" rel="stylesheet" />
    <link href="css/font-awesome4.7.0.min.css" rel="stylesheet" />

    <link rel="stylesheet" href="Content/bootstrap.css" />
    <link href="DateTimePicker/2-bootstrap-datetimepicker.min.css" rel="stylesheet" />
    <link href="DateTimePicker/3-bootstrap-datetimepicker-standalone.css" rel="stylesheet" />


    <script src="Scripts/jquery-1.9.1.js"></script>
    <script src="Scripts/bootstrap.min.js"></script>
    <script src="chosen/chosen.jquery.js"></script>
    <script src="JS/mine/btn_folderFiles.js"></script>
    <script src="DateTimePicker/1-moment.min.js"></script>
    <script src="DateTimePicker/4-bootstrap-datetimepicker.min.js"></script>



    <style type="text/css">
        /*strong*/
        .theme-bg-color1 {
            background-color: #0072B5 !important;
        }

        /*light*/
        .theme-bg-color2 {
            background-color: #dce5ef !important;
        }

        .theme-text-color1 {
            color: #0072B5 !important;
        }

        .theme-text-color2 {
            color: #dce5ef !important;
        }

        .theme-text-color3 {
            color: #004166 !important;
        }

        .text-bold {
            font-weight: bold !important;
        }
    </style>

    <%--UpdateProgress--%>    
    <style type="text/css">
        .overlay {
            position: fixed;
            z-index: 98;
            top: 0px;
            left: 0px;
            right: 0px;
            bottom: 0px;
            background-color: #aaa;
            filter: alpha(opacity=80);
            opacity: 0.8;
        }

        .overlayContent {
            z-index: 99;
            margin: 250px auto;
            width: 80px;
            height: 80px;
        }

            .overlayContent h2 {
                font-size: 18px;
                font-weight: bold;
                color: #000;
            }

            .overlayContent img {
                width: 80px;
                height: 80px;
            }
    </style>

    <style type="text/css">
        .form-control {
            height: 26px !important;
            vertical-align: middle !important;
            padding: 3px 6px;
            font-size: small;
        }

        .input-group-addon {
            height: 26px !important;
            vertical-align: middle !important;
            padding: 3px 6px;
            font-size: 15px;
            border-radius: 6px;
        }

        .btn-default {
            border: 1px solid gray;
        }

        select.form-control {
            text-align: center !important;
        }

        .form-control-1 {
            height: 40px !important;
            padding: 8px 10px !important;
        }


        .btn {
            height: 26px;
            vertical-align: middle !important;
            padding: 3px 6px;
            font-size: small;
        }

        .btn2 {
            height: 40px;
            vertical-align: middle !important;
            padding: 6px 12px;
            font-size: large;
        }

        .sticky {
            position: -webkit-sticky;
            position: sticky;
            top: 0;
            padding: 5px;
        }

        .pic {
            max-width: 100%;
            max-height: 100%;
            /*width:100%;*/
        }

        .table3 tr td {
            border: none !important;
        }

        .col-info1 {
            text-align: right !important;
        }

        .h100 {
            height: 140px !important;
            width: 120px !important;
        }

        .h40 {
            height: 35px !important;
        }

        select {
            text-align: center !important
        }

        .ProgStatus1 {
            background-color: #00ace6;
            color: aliceblue;
        }

        .ProgStatus2 {
            background-color: #ef7a16;
            color: aliceblue;
        }

        .tableStat tr td {
            padding: 0px 0px 0px 0px;
        }

        .fixPo {
            position: fixed;
            /*margin-top: 20px !important;*/
            border-radius: 30px !important;
            z-index: 2;
        }

        .buttonMenu {
            width: 100%;
            height: 90%;
        }

        .modal-sm4 {
            width: 430px !important;
            margin-top: 15%;
        }

        .red-border {
            border-color: #ff6666 !important;
            background-color: #FBE3E4 !important;
            outline: 0 !important;
            -webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,.075), 0 0 8px rgba(255, 80, 80, .6) !important;
            box-shadow: inset 0 1px 1px rgba(0,0,0,.075), 0 0 8px rgba(255, 255, 128, .6) !important;
        }

        .tb_media tr td {
            text-align: center !important;
        }

        .pic2 {
            max-height: 700px;
            max-width: 90%;
            /*width:100%;*/
        }


        .border-red {
            border-color: red !important;
            border-width: 2px !important;
            background-color: #FBE3E4 !important;
            outline: 0 !important;
            /*-webkit-box-shadow:  !important;*/
            /*box-shadow: inset !important;*/
        }

        .btn-acknowledge {
            background-color: #797979 !important;
            color: white !important;
            cursor: not-allowed !important;
        }

        .btn-enable {
            background-color: #a7b2b8 !important;
            color: white !important;
        }

        .table-header th {
            text-align: center !important;
        }

        .ProblemRankStyle1 {
            align-content: space-evenly;
            text-align: center;
            font-weight: 600;
            /*color:#373434;*/
        }

        .topic-header {
            font-size: 12px;
            padding-bottom: 2px;
            padding-top: 2px;
            align-content: center;
            min-height: 25px !important;
        }
    </style>

    <style>
        .tooltip {
            position: relative;
            display: inline-block;
            border-bottom: 1px dotted black;
        }

            .tooltip .tooltiptext {
                visibility: hidden;
                width: 120px;
                background-color: black;
                color: #fff;
                text-align: center;
                border-radius: 6px;
                padding: 5px 0;
                /* Position the tooltip */
                position: absolute;
                z-index: 1;
            }

            .tooltip:hover .tooltiptext {
                visibility: visible;
            }
    </style>

    <style>
        /* Check Box Style */
        .Checkbox_Style {
            display: block;
            position: relative;
            padding-left: 35px;
            margin-bottom: 12px;
            cursor: pointer;
            font-size: 18px;
            -webkit-user-select: none;
            -moz-user-select: none;
            -ms-user-select: none;
            user-select: none;
        }

            /* Hide the browser's default checkbox */
            .Checkbox_Style input {
                position: absolute;
                opacity: 0;
                cursor: pointer;
                height: 0;
                width: 0;
            }

        /* Create a custom checkbox */
        .checkmark {
            position: absolute;
            top: 0;
            left: 0;
            height: 25px;
            width: 25px;
            background-color: #eee;
        }

        /* On mouse-over, add a grey background color */
        .Checkbox_Style:hover input ~ .checkmark {
            background-color: #ccc;
        }

        /* When the checkbox is checked, add a blue background */
        .Checkbox_Style input:checked ~ .checkmark {
            background-color: #2196F3;
        }

        /* Create the checkmark/indicator (hidden when not checked) */
        .checkmark:after {
            content: "";
            position: absolute;
            display: none;
        }

        /* Show the checkmark when checked */
        .Checkbox_Style input:checked ~ .checkmark:after {
            display: block;
        }

        /* Style the checkmark/indicator */
        .Checkbox_Style .checkmark:after {
            left: 9px;
            top: 5px;
            width: 5px;
            height: 10px;
            border: solid white;
            border-width: 0 3px 3px 0;
            -webkit-transform: rotate(45deg);
            -ms-transform: rotate(45deg);
            transform: rotate(45deg);
        }

        .success .e-chkbox-medium .e-chk-inact .e-chk-image,
        .success .e-chkbox-medium .e-chk-act .e-chk-image {
            background: #17ad37;
            color: white;
        }

        .success .e-chkbox-medium .e-chk-inact,
        .success .e-chkbox-medium .e-chk-act {
            border-color: transparent;
        }

        .danger .e-chkbox-medium .e-chk-inact .e-chk-image,
        .danger .e-chkbox-medium .e-chk-act .e-chk-image {
            background: #d84315;
            color: white;
        }

        .danger .e-chkbox-medium .e-chk-inact,
        .danger .e-chkbox-medium .e-chk-act {
            border-color: transparent;
        }

        .ChkBoxClass input {
            width: 25px;
            height: 25px;
        }
    </style>


    <script>
        $(document).ready(function () {
            SetTooltip();
            Set_datePicker();
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(SetTooltip);
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(Set_datePicker);
        });

        function SetTooltip() {
            $('[data-toggle="tooltip"]').tooltip();
        }
        function Set_datePicker() {

            $('.date').datetimepicker({
                format: 'DD-MMM-YYYY hh:mm:ss',
            });
        }

    </script>


    <%-- ===================================================================
         Status Bar (Process Flow) : stepper แบบใหม่
         - done    : ขั้นตอนที่ผ่านแล้ว (เขียว + check)
         - active  : ขั้นตอนปัจจุบัน (กดได้ ถ้ามีสิทธิ์) / Delay = สีแดง
         - pending : ขั้นตอนที่ยังไม่ถึง (เทา)
         class "step active" ยังถูกกำหนดจาก code-behind (Check_Process) เหมือนเดิม
         =================================================================== --%>
    <script>
        function Set_ProcessStep() {
            var $steps = $('#steps .step');
            if ($steps.length === 0) return;

            var status = $('input[id$="hd_status"]').first().val();
            var $wrap = $('#steps').removeClass('is-close is-cancel');
            var foundActive = false;

            $steps.each(function () {
                var $s = $(this).removeClass('done pending delay');
                if ($s.is('.active')) {
                    foundActive = true;
                    if ($s.attr('data-desc') === 'Delay') $s.addClass('delay');
                    return;
                }
                if (foundActive) {
                    $s.addClass('pending');
                } else {
                    $s.addClass('done');
                    // แทนเลขด้วยเครื่องหมาย check (ขั้นตอนที่ผ่านแล้ว)
                    if ($s.find('.step-check').length === 0)
                        $s.children('.btn-process').html('<i class="fa fa-check step-check"></i>');
                }
            });

            if (status === '7') $wrap.addClass('is-close');
            if (status === '8') {
                // Cancel : ไม่มีขั้นตอนปัจจุบัน → แสดงเป็นเทาทั้งหมด
                $wrap.addClass('is-cancel');
                $steps.removeClass('done').addClass('pending');
            }
        }

        $(document).ready(function () {
            Set_ProcessStep();
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(Set_ProcessStep);
        });
    </script>

    <style>
        .steps-card {
            background: #fff;
            border: 1px solid #D3DDE8;
            border-radius: 10px;
            padding: 14px 10px 10px;
            margin: 10px 0 12px;
            box-shadow: 0 1px 2px rgba(0, 0, 0, .04);
            position: relative;
        }

        #steps {
            display: flex;
            align-items: flex-start;
            width: 100%;
            counter-reset: none;
        }

        .step {
            --step-c: #97A7B8;
            position: relative;
            flex: 1 1 0;
            min-width: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
        }

            /* เส้นเชื่อมระหว่างขั้นตอน */
            .step + .step::before {
                content: '';
                position: absolute;
                top: 18px;
                left: calc(-50% + 22px);
                right: calc(50% + 22px);
                height: 4px;
                border-radius: 2px;
                background: #C9D4E0;
                z-index: 0;
            }

            .step.done + .step::before {
                background: #4CAF50;
            }

            .step.done + .step.active::before {
                background: linear-gradient(to right, #4CAF50, var(--step-c));
            }

            /* วงกลม : LinkButton (btn-process) */
            .step .btn-process {
                position: relative;
                z-index: 1;
                display: flex;
                align-items: center;
                justify-content: center;
                width: 40px;
                height: 40px;
                padding: 0;
                border-radius: 50%;
                border: 3px solid var(--step-c);
                background: #fff;
                color: var(--step-c);
                font-size: 16px;
                font-weight: 700;
                text-decoration: none !important;
                transition: transform .15s, box-shadow .15s;
            }

            /* ชื่อขั้นตอน */
            .step::after {
                content: attr(data-desc);
                display: block;
                margin-top: 7px;
                padding: 0 4px;
                font-size: 12px;
                font-weight: 600;
                line-height: 1.25;
                color: #66768A;
                overflow-wrap: anywhere;
            }

            .step.done {
                --step-c: #4CAF50;
            }

                .step.done .btn-process {
                    background: #4CAF50;
                    color: #fff;
                }

                .step.done::after {
                    color: #3D7F40;
                }

            .step.active {
                --step-c: #0072B5;
            }

                .step.active .btn-process {
                    width: 46px;
                    height: 46px;
                    margin-top: -3px;
                    font-size: 18px;
                    box-shadow: 0 0 0 6px rgba(0, 114, 181, .15);
                }

                    .step.active .btn-process:not(.aspNetDisabled):hover {
                        transform: scale(1.08);
                        background: var(--step-c);
                        color: #fff;
                        cursor: pointer;
                    }

                .step.active::after {
                    color: var(--step-c);
                    font-size: 13px;
                }

                /* ป้าย "ขั้นตอนปัจจุบัน" */
                .step.active .btn-process::after {
                    content: 'NOW';
                    position: absolute;
                    top: -16px;
                    left: 50%;
                    transform: translateX(-50%);
                    padding: 0 6px;
                    border-radius: 8px;
                    background: var(--step-c);
                    color: #fff;
                    font-size: 9px;
                    font-weight: 700;
                    letter-spacing: .5px;
                    line-height: 14px;
                }

                .step.active.delay {
                    --step-c: #D9534F;
                }

                    .step.active.delay .btn-process {
                        box-shadow: 0 0 0 6px rgba(217, 83, 79, .18);
                        animation: stepPulse 1.6s infinite;
                    }

        @keyframes stepPulse {
            0%, 100% { box-shadow: 0 0 0 4px rgba(217, 83, 79, .18); }
            50% { box-shadow: 0 0 0 9px rgba(217, 83, 79, .08); }
        }

        /* Close : ทุกขั้นตอนผ่านแล้ว */
        #steps.is-close .step:last-child .btn-process {
            box-shadow: 0 0 0 6px rgba(76, 175, 80, .18);
        }

        /* Cancel */
        #steps.is-cancel {
            opacity: .55;
        }

        .steps-card .cancel-tag {
            display: none;
        }

        #steps.is-cancel + .cancel-tag {
            display: block;
            position: absolute;
            top: 8px;
            right: 12px;
            padding: 2px 10px;
            border-radius: 10px;
            background: #6C757D;
            color: #fff;
            font-size: 12px;
            font-weight: 700;
        }

        @media (max-width: 900px) {
            .step .btn-process { width: 32px; height: 32px; font-size: 13px; border-width: 2px; }
            .step.active .btn-process { width: 38px; height: 38px; }
            .step + .step::before { top: 14px; left: calc(-50% + 18px); right: calc(50% + 18px); height: 3px; }
            .step::after { font-size: 10.5px; }
            .step.active::after { font-size: 11px; }
        }
    </style>

    <style>
        .grid-container {
            display: grid;
            grid-template-columns: 80px 140px 200px 120px auto;
            grid-template-rows: 30px;
        }

            .grid-container > div {
            }

        .grid-container1 {
            display: grid;
            grid-template-columns: 100%;
            grid-template-rows: 100px;
        }

            .grid-container1 > div {
                text-align: -webkit-center;
                align-content: space-evenly;
            }

        .grid-container2 {
            display: grid;
            grid-template-columns: 57% 18% 25%;
            grid-template-rows: 380px;
            border-bottom: 1px solid;
            border-color: #aaa;
        }

            .grid-container2 > div {
            }

        .grid-container3 {
            display: grid;
            grid-template-columns: 100%;
            grid-template-rows: 22% 19% 19% 19% 19%;
        }

            .grid-container3 > div {
                margin-top: 5px;
                margin-bottom: 5px;
            }

        .grid-container4 {
            display: grid;
            grid-template-columns: 30% 30% 40%;
            grid-template-rows: 100%;
            /*border:1px Solid;*/
            border-left: 10px solid;
            /*border-radius : 5px;*/
            border-color: #337ab7;
            margin-left: 5px;
            border-bottom: 1px solid #c2c2c2;
        }

            .grid-container4 > div {
                /*margin-left : 5px;*/
                /*margin-top : 5px;*/
                padding: 5px;
            }

        .grid-container5 {
            display: grid;
            grid-template-columns: 100%;
            grid-template-rows: 10% 45% 5% 30%;
            margin-top: 5px;
        }

            .grid-container5 > div {
            }

        .grid-container6 {
            display: grid;
            grid-template-columns: 95% 5%;
            grid-template-rows: 100%;
            margin-top: 5px;
            margin-left: 10px;
            /*border:1px dashed;*/
            border-bottom: 1px solid #c2c2c2;
        }

            .grid-container6 > div {
            }

        .grid-container6_1 {
            display: grid;
            grid-template-columns: 29% 27% 30% 14%;
            grid-template-rows: 100%;
            /*border:1px solid;*/
            border-left: 5px solid;
            /*border-radius : 5px;*/
            border-color: #337ab7;
        }

            .grid-container6_1 > div {
                margin-left: 5px;
            }

        .grid-container7 {
            display: grid;
            grid-template-columns: 62% 38%;
            grid-template-rows: 100%;
            margin-top: 5px;
            margin-left: 10px;
        }

            .grid-container7 > div {
            }

        .grid-container7_1 {
            display: grid;
            grid-template-columns: 45% 27% 27%;
            grid-template-rows: 100%;
            /*border:1px solid;*/
            border-left: 5px solid;
            /*border-radius : 5px;*/
            border-color: #337ab7;
            border-bottom: 1px solid #c2c2c2;
        }

            .grid-container7_1 > div {
                margin-left: 5px;
            }

        .grid-container8 {
            display: grid;
            grid-template-columns: 58% 42%;
            grid-template-rows: 100%;
            margin-top: 5px;
            margin-left: 10px;
        }

            .grid-container8 > div {
            }

        .grid-container8_1 {
            display: grid;
            grid-template-columns: 31% 38% 31%;
            grid-template-rows: 100%;
            /*border:1px solid;*/
            border-left: 5px solid;
            /*border-radius : 5px;*/
            border-color: #337ab7;
            border-bottom: 1px solid #c2c2c2;
        }

            .grid-container8_1 > div {
                margin-left: 5px;
            }

        .grid-container9 {
            display: grid;
            grid-template-columns: 88% 12%;
            grid-template-rows: 100%;
            margin-top: 5px;
            margin-left: 10px;
            /*border:1px dashed;*/
            border-bottom: 1px solid #c2c2c2;
        }

            .grid-container9 > div {
            }

        .grid-container9_1 {
            display: grid;
            grid-template-columns: 26% 13% 26% 13% 22%;
            grid-template-rows: 100%;
            /*border:1px solid;*/
            border-left: 5px solid;
            /*border-radius : 5px;*/
            border-color: #337ab7;
        }

            .grid-container9_1 > div {
                margin-left: 5px;
            }

        .grid-container10 {
            display: grid;
            grid-template-columns: 75% 25%;
            grid-template-rows: 200px;
            border-bottom: 1px solid;
            border-color: #aaa;
        }

            .grid-container10 > div {
            }

        .grid-container11 {
            display: grid;
            grid-template-columns: 100%;
            grid-template-rows: 20% 80%;
            border-right: 1px solid;
            border-color: #aaa;
        }

            .grid-container11 > div {
            }

        .grid-container11_1 {
            display: grid;
            grid-template-columns: 14% 81% 5%;
            grid-template-rows: 100%;
            border-bottom: 1px solid;
            border-color: #aaa;
        }

            .grid-container11_1 > div {
                padding: 2px;
            }

        .grid-container12 {
            display: grid;
            grid-template-columns: 50% 50%;
            grid-template-rows: 100%;
        }

            .grid-container12 > div {
            }

        .grid-container12_Problem {
            display: grid;
            grid-template-columns: 100%;
            grid-template-rows: 20% 20% 20% 40%;
            border-right: 1px solid;
            border-color: #aaa;
            margin-top: 2px;
            margin-left: 5px;
        }

            .grid-container12_Problem > div {
                /*margin-left : 5px;*/
                /*margin-top : 2px;*/
            }

        .grid-container12_Problem1 {
            display: grid;
            grid-template-columns: 18% 82%;
            grid-template-rows: 100%;
            /*border : 1px dashed;*/
        }

            .grid-container12_Problem1 > div {
                /*margin-left : 10px;*/
                /*margin-top : 2px;*/
                align-content: center;
                /*text-align: end;*/
                font-weight: 600;
            }

        .grid-container12_Action {
            display: grid;
            grid-template-columns: 100%;
            grid-template-rows: 20% 20% 60%;
            /*border-right:1px solid;*/
            /*border-color:#aaa;*/
            margin-top: 2px;
            margin-left: 5px;
        }

            .grid-container12_Action > div {
                /*margin-left : 5px;*/
                /*margin-top : 2px;*/
            }

        .grid-container13 {
            display: grid;
            grid-template-columns: 100%;
            grid-template-rows: 20% 15% 15% 15% 15% 15%;
            margin-right: 5px;
            margin-left: 5px;
            /*border-right:1px solid;*/
            /*border-color:#aaa;*/
            /*margin-top:2px;*/
            /*margin-left:5px;*/
        }

            .grid-container13 > div {
                /*margin-left : 5px;*/
                /*margin-top : 2px;*/
            }

        .grid-container13_1 {
            display: grid;
            grid-template-columns: 50% 50%;
            grid-template-rows: 100%;
            /*border-right:1px solid;*/
            /*border-color:#aaa;*/
            /*margin-top:2px;*/
            /*margin-left:5px;*/
        }

            .grid-container13_1 > div {
                margin-right: 2px;
                /*margin-top : 2px;*/
            }

        .grid-Update_Modal1 {
            display: grid;
            grid-template-columns: 15% 85%;
            grid-template-rows: 100%;
            /*border-right:1px solid;*/
            /*border-color:#aaa;*/
            /*margin-top:2px;*/
            /*margin-left:5px;*/
        }

            .grid-Update_Modal1 > div {
                /*margin-right : 2px;*/
                /*margin-top : 2px;*/
            }

        .grid-Update_Modal2 {
            display: grid;
            grid-template-columns: 50% 50%;
            grid-template-rows: 15% 85%;
            /*border-right:1px solid;*/
            /*border-color:#aaa;*/
            /*margin-top:2px;*/
            /*margin-left:5px;*/
        }

            .grid-Update_Modal2 > div {
                /*padding:5px;*/
            }

        .grid-Update_Modal3 {
            display: grid;
            grid-template-columns: 22% 37% 4% 37%;
            grid-template-rows: 30px;
            /*border-right:1px solid;*/
            /*border-color:#aaa;*/
            /*margin-top:2px;*/
            /*margin-left:5px;*/
            align-items: center;
        }

            .grid-Update_Modal3 > div {
                /*padding:5px;*/
                /*border:1px solid;*/
            }

        .grid-Update_Modal4 {
            display: grid;
            grid-template-columns: 14% 41% 4% 41%;
            grid-template-rows: 30px;
            /*border-right:1px solid;*/
            /*border-color:#aaa;*/
            /*margin-top:2px;*/
            /*margin-left:5px;*/
            align-items: center;
        }

            .grid-Update_Modal4 > div {
                /*padding:5px;*/
                /*border:1px solid;*/
            }

        .grid-NewProblem_Modal1 {
            display: grid;
            grid-template-columns: 5% 95%;
            grid-template-rows: 35px;
            /*border-right:1px solid;*/
            /*border-color:#aaa;*/
            /*margin-top:2px;*/
            /*margin-left:5px;*/
            align-items: center;
            border-bottom: 1px solid;
            border-color: #aaa;
        }

            .grid-NewProblem_Modal1 > div {
                /*padding:5px;*/
                /* border:1px solid;
                border-color:#aaa;*/
            }

        .grid-NewProblem_Modal2 {
            display: grid;
            grid-template-columns: 5% 25% 70%;
            grid-template-rows: 35px;
            /*border-right:1px solid;*/
            /*border-color:#aaa;*/
            /*margin-top:2px;*/
            /*margin-left:5px;*/
            align-items: center;
            border-bottom: 1px solid;
            border-color: #aaa;
        }

            .grid-NewProblem_Modal2 > div {
                /*padding:5px;*/
                /* border:1px solid;
                border-color:#aaa;*/
            }

        .grid-NewProblem_Modal3 {
            display: grid;
            grid-template-columns: 5% 25% 70%;
            grid-template-rows: 50px;
            /*border-right:1px solid;*/
            /*border-color:#aaa;*/
            /*margin-top:2px;*/
            /*margin-left:5px;*/
            align-items: center;
            border-bottom: 1px solid;
            border-color: #aaa;
        }

            .grid-NewProblem_Modal3 > div {
                /*padding:5px;*/
                /* border:1px solid;
                border-color:#aaa;*/
            }

        .grid-NewProblem_Modal4 {
            display: grid;
            grid-template-columns: 5% 25% 70%;
            grid-template-rows: 100px;
            /*border-right:1px solid;*/
            /*border-color:#aaa;*/
            /*margin-top:2px;*/
            /*margin-left:5px;*/
            align-items: center;
            border-bottom: 1px solid;
            border-color: #aaa;
        }

            .grid-NewProblem_Modal4 > div {
                /*padding:5px;*/
                /* border:1px solid;
                border-color:#aaa;*/
            }

        .grid-CheckClose_Modal1 {
            display: grid;
            grid-template-columns: 60% 40%;
            grid-template-rows: 300px;
            /*border-right:1px solid;*/
        }

            .grid-CheckClose_Modal1 > div {
            }

        .grid-CheckClose_Modal2 {
            display: grid;
            grid-template-columns: 100%;
            grid-template-rows: 12% 14% 14% 14% 14% 45%;
            /*align-items: center;*/
            border-right: 1px solid;
            border-color: #aaa;
        }

            .grid-CheckClose_Modal2 > div {
                /*padding:5px;*/
            }

        .grid-CheckClose_Modal3 {
            display: grid;
            grid-template-columns: 32% 68%;
            grid-template-rows: 100%;
            margin-right: 5px;
        }

            .grid-CheckClose_Modal3 > div {
                /*padding-right:5px;*/
            }

        .grid-CheckClose_Modal4 {
            display: grid;
            grid-template-columns: 32% 15% 25% 28%;
            grid-template-rows: 100%;
            margin-right: 5px;
        }

            .grid-CheckClose_Modal4 > div {
            }

        .container {
            max-width: 250px;
            padding: 15px;
        }
    </style>


    <%-- ===================================================================
         Layout ใหม่ (override style เดิม) : ยืดตามขนาดหน้าจอ, ไม่ fix ความสูง
         ≥ 1400px : Info | Problem Rank | Picture  (3 คอลัมน์)
         1000-1399 : Info | Rank + Picture (ซ้อน)
         < 1000    : 1 คอลัมน์
         =================================================================== --%>
    <style>
        :root {
            --c-primary: #0072B5;
            --c-primary-dark: #005A8F;
            --c-primary-soft: #D8E8F6;
            --c-accent: #F5B041;
            --c-border: #BCCADB;
            --c-line: #D6E0EB;
            --c-text: #1F2D3D;
            --c-muted: #55667A;
            --c-bg: #E2E9F1;
        }

        body {
            background: var(--c-bg) !important;
            color: var(--c-text);
            font-family: 'Segoe UI', Tahoma, 'Leelawadee UI', sans-serif;
            font-size: 13px;
        }

        .theme-bg-color1 { background-color: var(--c-primary) !important; }
        .theme-text-color1 { color: var(--c-primary) !important; }

        .modal-content { border-radius: 8px; overflow: hidden; }

        /* ---------- Header + Toolbar (ติดด้านบนตอน scroll) ---------- */
        .pd-top {
            position: sticky;
            top: 0;
            z-index: 50;
            background: var(--c-bg);
            box-shadow: 0 2px 6px rgba(0, 0, 0, .06);
        }

        .pd-header {
            display: flex;
            align-items: center;
            gap: 10px;
            height: 48px;
            padding: 0 18px;
            background: var(--c-primary);
            color: #fff;
        }

            .pd-header .pd-title {
                font-size: 18px;
                font-weight: 700;
                margin: 0;
                color: #fff !important;
            }

            .pd-header .fa {
                color: var(--c-accent);
                font-size: 18px;
            }

        .pd-wrap {
            padding: 0 18px 24px;
        }

        /* Toolbar : Back / History / Upload Picture / Drawing */
        .grid-container.pd-toolbar {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 8px;
            margin: 0 -18px 0;
            padding: 8px 18px;
            grid-template-columns: none;
            grid-template-rows: none;
        }

            .grid-container.pd-toolbar > div {
                width: auto;
            }

            .pd-toolbar a {
                text-decoration: none !important;
            }

        .pm-btn,
        .pd-toolbar .btn,
        .pd-toolbar .btn-group > .btn {
            display: inline-flex !important;
            align-items: center;
            gap: 6px;
            width: auto !important;
            height: 32px !important;
            padding: 0 14px !important;
            border-radius: 6px !important;
            border: 1px solid var(--c-border) !important;
            background: #fff !important;
            color: var(--c-text) !important;
            font-size: 13px !important;
            font-weight: 600;
            white-space: nowrap;
            box-shadow: none !important;
        }

            .pm-btn:hover,
            .pd-toolbar .btn:hover {
                background: var(--c-primary-soft) !important;
                border-color: var(--c-primary) !important;
            }

            .pm-btn.back {
                background: var(--c-primary) !important;
                border-color: var(--c-primary) !important;
                color: #fff !important;
            }

                .pm-btn.back:hover {
                    background: var(--c-primary-dark) !important;
                }

        .pd-toolbar .dropdown-menu > li > a {
            padding: 7px 16px;
        }

        /* ---------- Card หลัก (Problem No) ---------- */
        .panel.panel-primary {
            border: 1px solid var(--c-border);
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 1px 2px rgba(0, 0, 0, .04);
            background: #fff;
        }

            .panel.panel-primary > .panel-heading {
                display: flex;
                align-items: center;
                gap: 8px;
                padding: 10px 16px;
                background: var(--c-primary-soft);
                border-bottom: 1px solid var(--c-border);
                color: var(--c-primary-dark);
            }

                .panel.panel-primary > .panel-heading span[id$="lb_problem"] {
                    font-size: 18px !important;
                    font-weight: 700;
                }

                .panel.panel-primary > .panel-heading a {
                    color: #C0392B !important;
                }

        .section-title {
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 0;
            padding: 8px 12px;
            font-size: 13px;
            font-weight: 700;
            color: var(--c-primary-dark);
            font-family: inherit !important;
        }

        /* style เดิมกำหนด grid-template-rows เป็น % / 100% → พอ wrap แล้วช่องทับกัน
           ให้ทุก grid สูงตามเนื้อหา */
        .grid-container2, .grid-container3, .grid-container4, .grid-container6, .grid-container6_1,
        .grid-container7, .grid-container7_1, .grid-container8_1, .grid-container9, .grid-container9_1,
        .grid-container10, .grid-container11, .grid-container11_1, .grid-container12,
        .grid-container12_Problem1, .grid-container13_1 {
            grid-template-rows: none !important;
            grid-auto-rows: auto;
        }

        .grid-container3 {
            align-content: start;
        }

        .pd-wrap select.form-control,
        .pd-wrap select:not(.h100) {
            text-align: left !important;
            text-align-last: left;
        }

        /* ---------- ส่วนบน : Info | Rank | Picture ---------- */
        .grid-container2 {
            grid-template-columns: minmax(0, 1fr) 220px minmax(240px, 22%);
            grid-template-rows: auto;
            border-bottom: 1px solid var(--c-line);
        }

            .grid-container2 > div {
                min-width: 0;
            }

            /* col-lg-3 ของ bootstrap ใน grid ทำให้กว้างแค่ 25% ของช่อง */
            .grid-container2 > .col-lg-3 {
                width: auto !important;
                float: none !important;
                padding: 10px 12px !important;
                border-left: 1px solid var(--c-line);
            }

        .grid-container3 {
            grid-template-rows: auto;
            row-gap: 0;
        }

            .grid-container3 > div {
                margin: 0;
            }

        /* แถวข้อมูลแต่ละกลุ่ม */
        .grid-container4,
        .grid-container6,
        .grid-container7,
        .grid-container9 {
            display: grid;
            grid-template-columns: minmax(0, 1fr) auto;
            align-items: end;
            gap: 0 6px;
            margin: 0 !important;
            padding: 8px 12px;
            border: 0 !important;
            border-bottom: 1px solid var(--c-line) !important;
        }

        .grid-container4 {
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 0 12px;
            background: #F1F5FA;
        }

            .grid-container4 > div {
                padding: 0;
                margin: 0 !important;
            }

        .grid-container9_1,
        .grid-container6_1,
        .grid-container7_1,
        .grid-container8_1 {
            display: grid;
            gap: 0 10px;
            border: 0 !important;
        }

        .grid-container9_1 { grid-template-columns: 1.3fr .7fr 1.1fr .9fr 1.2fr; }
        .grid-container6_1 { grid-template-columns: 1.2fr 1fr 1.1fr .7fr; }
        .grid-container7_1 { grid-template-columns: 1.2fr 1fr 1fr; }
        .grid-container8_1 { grid-template-columns: repeat(3, minmax(0, 1fr)); }

            .grid-container9_1 > div,
            .grid-container6_1 > div,
            .grid-container7_1 > div,
            .grid-container8_1 > div {
                margin: 0 !important;
                min-width: 0;
            }

            .grid-container9_1 .form-inline,
            .grid-container6_1 .form-inline,
            .grid-container7_1 .form-inline,
            .grid-container8_1 .form-inline {
                display: flex;
                flex-direction: column;
            }

                .grid-container9_1 .form-inline br,
                .grid-container6_1 .form-inline br,
                .grid-container7_1 .form-inline br,
                .grid-container8_1 .form-inline br {
                    display: none;
                }

        /* Label หัวข้อ */
        .topic-header,
        .grid-container4 a[onclick],
        .grid-container4 > div > a:first-child {
            display: block;
            min-height: 0 !important;
            margin: 0 0 3px !important;
            padding: 0 !important;
            font-size: 11.5px !important;
            font-weight: 600 !important;
            color: var(--c-muted) !important;
            text-transform: uppercase;
            letter-spacing: .3px;
            white-space: nowrap;
        }

        .grid-container4 > div {
            display: grid;
            grid-template-columns: minmax(0, 1fr) auto;
            align-items: center;
            gap: 3px 6px;
        }

            .grid-container4 > div > a:first-child {
                grid-column: 1 / -1;
            }

            .grid-container4 > div > select,
            .grid-container4 > div > .form-control {
                grid-column: 1;
                width: 100% !important;
            }

            .grid-container4 > div > a.btn {
                grid-column: 2;
                grid-row: 2;
            }

            .grid-container4 > div:first-child > select {
                grid-column: 1 / -1;
            }

        /* Input / Select */
        .form-control,
        .grid-container4 select {
            height: 32px !important;
            border-radius: 6px !important;
            border-color: var(--c-border) !important;
            box-shadow: none !important;
            font-size: 13px !important;
        }

            .form-control[disabled],
            .form-control.disabled,
            select[disabled] {
                background-color: #EBF0F6 !important;
                color: var(--c-text) !important;
                opacity: 1 !important;
                cursor: default;
            }

        .h40 {
            height: 32px !important;
        }

        select.ProgStatus1,
        select.ProgStatus2 {
            padding: 0 8px;
            font-weight: 600;
            border: 0;
        }

        select.ProgStatus1[disabled] { background-color: #17A2B8 !important; color: #fff !important; }
        select.ProgStatus2[disabled] { background-color: #E67E22 !important; color: #fff !important; }

        .input-group-addon {
            height: 32px !important;
            border-radius: 0 6px 6px 0 !important;
            border-color: var(--c-border) !important;
            background: var(--c-primary-soft) !important;
        }

        .input-group .form-control:first-child {
            border-radius: 6px 0 0 6px !important;
        }

        .input-group {
            width: 100% !important;
        }

        /* ปุ่มแก้ไข (ฟันเฟือง) */
        .btn.btn-info {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 30px;
            height: 30px !important;
            padding: 0 !important;
            border-radius: 6px;
            border: 1px solid var(--c-border);
            background: #fff;
            color: var(--c-primary-dark);
        }

            .btn.btn-info:hover {
                background: var(--c-primary);
                border-color: var(--c-primary);
                color: #fff;
            }

        a.aspNetDisabled,
        .btn.aspNetDisabled {
            opacity: .35;
            pointer-events: none;
        }

        /* วงกลม Status Bar ที่ disabled (ไม่มีสิทธิ์กด) ยังต้องแสดงสีเต็ม */
        .step a.btn-process.aspNetDisabled {
            opacity: 1;
        }

        /* Tool Detail button */
        .grid-container9 > div:last-child {
            margin: 0 !important;
        }

            .grid-container9 > div:last-child .btn {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                height: 32px !important;
                width: auto !important;
                padding: 0 12px;
                border-radius: 6px;
                background: var(--c-primary);
                border-color: var(--c-primary);
            }

                .grid-container9 > div:last-child .btn br {
                    display: none;
                }

                .grid-container9 > div:last-child .btn lable {
                    font-size: 13px !important;
                }

        /* ---------- Problem Rank ---------- */
        .grid-container5 {
            display: flex !important;
            flex-direction: column;
            gap: 10px;
            padding: 12px;
            border: 0 !important;
            border-left: 1px solid var(--c-line) !important;
            margin: 0 !important;
        }

        .rank-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 11.5px;
            font-weight: 600;
            color: var(--c-muted);
            text-transform: uppercase;
            letter-spacing: .3px;
        }

        .rank-box {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 6px;
            border: 1px solid var(--c-border);
            border-radius: 10px;
            background: #F1F5FA;
        }

            .rank-box select.h100 {
                width: 110px !important;
                height: 110px !important;
                border: 0;
                border-radius: 10px;
                font-weight: 700;
                text-align: center;
                text-align-last: center;
                -webkit-appearance: none;
                -moz-appearance: none;
                appearance: none;
            }

        .rank-legend {
            margin: 0;
            padding: 8px 10px;
            list-style: none;
            border-radius: 8px;
            background: var(--c-primary-soft);
            font-size: 11.5px;
            line-height: 1.6;
        }

            .rank-legend b {
                display: inline-block;
                width: 16px;
            }

        /* ---------- Picture ---------- */
        .grid-container2 > .col-lg-3 .btn {
            height: 32px !important;
            border-radius: 6px;
            margin-bottom: 8px;
        }

        div[id$="divPicNG"],
        div[id$="divPicOK"] {
            margin: 0 !important;
            max-height: 340px;
            overflow: auto;
        }

            div[id$="divPicNG"] label,
            div[id$="divPicOK"] label {
                font-size: 11.5px;
                font-weight: 600;
                color: var(--c-muted);
                text-transform: uppercase;
            }

            div[id$="divPicNG"] img,
            div[id$="divPicOK"] img {
                max-width: 100%;
                border-radius: 6px;
                border: 1px solid var(--c-border);
            }

        /* ---------- Problem / Action Detail ---------- */
        .grid-container10 {
            grid-template-columns: minmax(0, 1fr) minmax(260px, 26%);
            grid-template-rows: auto;
            border-bottom: 1px solid var(--c-line);
        }

        .grid-container11 {
            grid-template-rows: auto auto;
            border-right: 1px solid var(--c-line);
        }

        .grid-container11_1 {
            grid-template-columns: auto minmax(0, 1fr) auto;
            align-items: center;
            gap: 10px;
            padding: 10px 12px;
            border-bottom: 1px solid var(--c-line);
        }

            .grid-container11_1 > div:first-child {
                border-left: 4px solid #FFAF00 !important;
                padding-left: 8px !important;
            }

                .grid-container11_1 > div:first-child label {
                    margin: 0;
                    font-weight: 700;
                    white-space: nowrap;
                }

            .grid-container11_1 input.h40 {
                height: 38px !important;
                font-size: 15px !important;
                font-weight: 600;
            }

        .grid-container12 {
            grid-template-columns: minmax(0, 1fr) minmax(0, 1fr);
        }

        .grid-container12_Problem,
        .grid-container12_Action {
            display: flex !important;
            flex-direction: column;
            gap: 6px;
            margin: 0 !important;
            padding: 10px 12px;
        }

        .grid-container12_Problem {
            border-right: 1px solid var(--c-line) !important;
        }

            .grid-container12_Problem > div.fa,
            .grid-container12_Action > div.fa {
                display: flex;
                align-items: center;
                justify-content: space-between;
                font-family: inherit !important;
                font-weight: 700;
                color: var(--c-primary-dark);
            }

                .grid-container12_Problem > div.fa::before,
                .grid-container12_Action > div.fa::before {
                    font-family: FontAwesome;
                    margin-right: 6px;
                    color: var(--c-accent);
                }

        /* Spec / Actual / Result / Detail : label + value */
        .grid-container12_Problem1 {
            grid-template-columns: 86px minmax(0, 1fr);
            border: 1px solid var(--c-border);
            border-radius: 6px;
            overflow: hidden;
        }

            .grid-container12_Problem1 > div:first-child {
                padding: 6px 8px;
                border: 0 !important;
                background: #DFE8F2 !important;
                color: var(--c-muted);
                font-size: 12px;
                text-align: left !important;
            }

            .grid-container12_Problem1 > div:last-child {
                background: #fff !important;
                padding: 2px 6px;
            }

            .grid-container12_Problem1 input,
            .grid-container12_Problem1 textarea {
                width: 100% !important;
                border: 0 !important;
                background: transparent !important;
                font-weight: 600;
                color: var(--c-text);
            }

            .grid-container12_Problem1 textarea {
                min-height: 64px;
                resize: vertical;
                font-weight: 400;
            }

            /* แถบสีบอกประเภท */
            .grid-container12_Problem1.kv-spec > div:first-child { box-shadow: inset 4px 0 #4CAF50; }
            .grid-container12_Problem1.kv-actual > div:first-child { box-shadow: inset 4px 0 #E67E22; }
            .grid-container12_Problem1.kv-result > div:first-child { box-shadow: inset 4px 0 #0072B5; }
            .grid-container12_Problem1.kv-detail > div:first-child { box-shadow: inset 4px 0 #97A7B8; }

        /* Problem Analyze */
        .grid-container13 {
            display: flex !important;
            flex-direction: column;
            gap: 8px;
            margin: 0 !important;
            padding: 10px 12px;
        }

            .grid-container13 > div:first-child {
                font-weight: 700;
                color: var(--c-primary-dark);
            }

        .grid-container13_1 {
            grid-template-columns: 42% 58%;
            align-items: center;
        }

            .grid-container13_1 label {
                margin: 0;
                padding-right: 6px;
                font-size: 12px !important;
                color: var(--c-muted);
            }

        /* ---------- Troubleshooting History ---------- */
        .pd-history {
            padding: 12px;
        }

            .pd-history > .fa {
                display: flex !important;
                align-items: center;
                gap: 6px;
                margin: 0 0 8px !important;
                font-family: inherit !important;
                font-size: 14px !important;
                color: var(--c-primary-dark);
            }

                .pd-history > .fa::before {
                    font-family: FontAwesome;
                    color: var(--c-accent);
                }

            .pd-history > .row {
                margin: 0 !important;
                width: 100% !important;
            }

            .pd-history .table {
                border: 0;
            }

                .pd-history .table > tbody > tr > td {
                    border: 0;
                    padding: 0;
                }

            .pd-history table[id$="gv_problemDetail"] {
                width: 100% !important;
                margin-bottom: 10px;
                border: 1px solid var(--c-border);
                border-radius: 8px;
                border-collapse: separate;
                overflow: hidden;
            }

                .pd-history table[id$="gv_problemDetail"] th {
                    background: var(--c-primary) !important;
                    color: #fff !important;
                    font-weight: 600;
                    border: 0 !important;
                    padding: 8px !important;
                }

                .pd-history table[id$="gv_problemDetail"] td {
                    border: 0 !important;
                    border-bottom: 1px solid var(--c-line) !important;
                    padding: 7px 8px !important;
                    vertical-align: middle;
                    background: #fff;
                }

                .pd-history table[id$="gv_problemDetail"] tr:nth-child(even) td {
                    background: #F1F5FA !important;
                }

            .pd-history textarea {
                width: 100% !important;
                min-height: 90px;
                padding: 8px 10px;
                border: 1px solid var(--c-border);
                border-radius: 8px;
                background: #FFFBEA !important;
                font-size: 14px !important;
            }

        .pd-save {
            display: flex;
            justify-content: center;
            margin: 6px 0 2px !important;
        }

            .pd-save .btn {
                height: 38px !important;
                padding: 0 28px !important;
                border-radius: 8px;
                border: 0;
                background: var(--c-primary);
                font-size: 15px !important;
                font-weight: 600;
            }

                .pd-save .btn:hover {
                    background: var(--c-primary-dark);
                }

        /* ---------- Responsive ---------- */
        @media (max-width: 1399px) {
            .grid-container2 {
                grid-template-columns: minmax(0, 1fr) minmax(230px, 26%);
            }

                .grid-container2 > .col-lg-3 {
                    grid-column: 2;
                    border-top: 1px solid var(--c-line);
                }

            .grid-container5 {
                grid-column: 2;
                grid-row: 1;
            }

            .grid-container3 {
                grid-row: 1 / span 2;
            }

            .grid-container9_1 { grid-template-columns: repeat(3, minmax(0, 1fr)); row-gap: 6px; }
        }

        @media (max-width: 999px) {
            .grid-container2,
            .grid-container10,
            .grid-container12 {
                grid-template-columns: minmax(0, 1fr);
            }

                .grid-container2 > .col-lg-3,
                .grid-container5,
                .grid-container3 {
                    grid-column: 1;
                    grid-row: auto;
                    border-left: 0 !important;
                }

            .grid-container5 {
                flex-direction: row !important;
                flex-wrap: wrap;
                align-items: center;
            }

            .grid-container4,
            .grid-container6_1,
            .grid-container7_1,
            .grid-container8_1,
            .grid-container9_1 {
                grid-template-columns: repeat(2, minmax(0, 1fr));
                row-gap: 6px;
            }

            .grid-container11,
            .grid-container12_Problem {
                border-right: 0 !important;
            }
        }
    </style>
    <%-- ===== Dropdown / ปุ่ม Gear / Excel icon ===== --%>
    <style>
        /* ---------- Dropdown ---------- */
        .pd-wrap select:not(.h100) {
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;
            height: 32px !important;
            padding: 0 30px 0 10px !important;
            border: 1px solid var(--c-border) !important;
            border-radius: 6px !important;
            background-color: #fff;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 12 8'%3E%3Cpath d='M1 1.5l5 5 5-5' fill='none' stroke='%230072B5' stroke-width='1.8' stroke-linecap='round' stroke-linejoin='round'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 10px center;
            background-size: 11px 8px;
            color: var(--c-text);
            font-size: 13px !important;
            line-height: 30px;
            cursor: pointer;
            box-shadow: none !important;
            transition: border-color .15s, box-shadow .15s;
        }

            .pd-wrap select:not(.h100):hover:not([disabled]) {
                border-color: var(--c-primary) !important;
            }

            .pd-wrap select:not(.h100):focus {
                outline: 0;
                border-color: var(--c-primary) !important;
                box-shadow: 0 0 0 3px rgba(0, 114, 181, .15) !important;
            }

            /* อ่านอย่างเดียว : ไม่แสดงลูกศร ดูเป็นช่องข้อมูล */
            .pd-wrap select:not(.h100)[disabled] {
                background-image: none;
                padding-right: 10px !important;
                background-color: #EBF0F6 !important;
                color: var(--c-text) !important;
                cursor: default;
                opacity: 1;
            }

            /* Action / Type of Problem (สีพื้น) */
            .pd-wrap select.ProgStatus1,
            .pd-wrap select.ProgStatus2 {
                border: 0 !important;
                color: #fff !important;
                font-weight: 600;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 12 8'%3E%3Cpath d='M1 1.5l5 5 5-5' fill='none' stroke='%23ffffff' stroke-width='1.8' stroke-linecap='round' stroke-linejoin='round'/%3E%3C/svg%3E");
            }

            .pd-wrap select.ProgStatus1 { background-color: #17A2B8 !important; }
            .pd-wrap select.ProgStatus2 { background-color: #E67E22 !important; }

            .pd-wrap select.ProgStatus1[disabled],
            .pd-wrap select.ProgStatus2[disabled] {
                color: #fff !important;
                background-image: none;
            }

            .pd-wrap select.ProgStatus1[disabled] { background-color: #17A2B8 !important; }
            .pd-wrap select.ProgStatus2[disabled] { background-color: #E67E22 !important; }

            .pd-wrap select:not(.h100) option {
                color: #1F2D3D;
                background: #fff;
            }

        /* Problem Rank (A/B/C) */
        .rank-box select.h100 {
            cursor: default;
            box-shadow: inset 0 0 0 1px rgba(0, 0, 0, .06);
        }

            .rank-box select.h100:not([disabled]) {
                cursor: pointer;
            }

        /* ---------- Dropdown + Excel icon (Period Check) ---------- */
        .dd-with-icon {
            display: flex;
            align-items: center;
            gap: 6px;
            width: 100%;
        }

            .dd-with-icon > select {
                flex: 1 1 auto;
                min-width: 0;
                width: auto !important;
            }

        .icon-btn {
            display: inline-flex;
            flex: 0 0 auto;
            align-items: center;
            justify-content: center;
            width: 32px;
            height: 32px;
            border: 1px solid var(--c-border);
            border-radius: 6px;
            background: #fff;
        }

            .icon-btn:hover {
                border-color: #1D6F42;
                background: #EAF5EE;
            }

            .icon-btn img {
                display: block;
            }

        /* ---------- ปุ่ม Gear : กึ่งกลางแนวตั้งของช่อง Dropdown ---------- */
        .btn.btn-info {
            width: 32px !important;
            height: 32px !important;
        }

        .gear-cell {
            align-self: end !important;
            display: flex;
            align-items: center;
            height: 32px;
            padding: 0 !important;
        }

        /* แถว Status / Action / Type of Problem */
        .grid-container4 {
            align-items: start;
        }

            .grid-container4 > div > a.btn {
                align-self: center;
            }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="pd-header">
            <span class="fa fa-wrench"></span>
            <asp:Label ID="lbl_header_jig" runat="server" CssClass="pd-title" Text="PM Problem Detail"></asp:Label>
        </div>

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
                <asp:Panel ID="Panel1" runat="server">
                    <div class="pd-wrap">
                        <div>

                            <%--PM Problem--%>
                            <asp:HiddenField ID="hd_pmProblem_name" runat="server" />
                            <asp:HiddenField ID="hd_pmProblem_id" runat="server" />
                            <asp:HiddenField ID="hd_status" runat="server" />

                            <asp:Label ID="lb_test_m" runat="server"></asp:Label>
                            <%--button link : Menu--%>
                            <div class="grid-container pd-toolbar pd-top">
                                <%--Back Menu--%>
                                <div>
                                    <asp:Label ID="Label1" runat="server" Text=""></asp:Label>
                                    <asp:LinkButton ID="LinkButton1" runat="server" CssClass="pm-btn back" OnClick="btn_back_Click" OnClientClick=""><span class="glyphicon glyphicon-arrow-left"></span>Back</asp:LinkButton>
                                </div>

                                <%--History Menu--%>
                                <div>
                                    <a id="PeriodCheck_link" runat="server" href="#" target="_blank">
                                        <div id="div_PeriodCheck_link" runat="server" class="pm-btn">
                                            <lable><span class="glyphicon glyphicon-modal-window"></span>&nbsp;History</lable>
                                        </div>
                                    </a>
                                </div>

                                <%--Upload Picture Menu--%>
                                <div>
                                    <asp:LinkButton runat="server"
                                        ID="btn_uploadPic_problem"
                                        CssClass="btn btn-default"
                                        ToolTip="แก้ไข" Width="90%"
                                        OnClick="btn_uploadPic_problem_Click">
                                        <span class="glyphicon glyphicon-picture"></span>
                                        &nbsp;Upload Picture Problem
                                    </asp:LinkButton>
                                    <div runat="server" id="div_show_pic"></div>
                                </div>
                               
                                <%-- PDF menu (dropdown) --%>
                                <div class="btn-group">
                                  <button type="button" class="btn btn-default dropdown-toggle" 
                                      data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="width:90%;">
                                    Drawing <span class="caret"></span>
                                  </button>
                                  <ul class="dropdown-menu">
                                    <li>
                                      <asp:LinkButton ID="btnPdfUpload" runat="server" OnClick="btnPdfUpload_Click">Upload Drawing</asp:LinkButton>
                                    </li>
                                    <li>
                                      <asp:LinkButton ID="btnPdfOpen"   runat="server" OnClick="btnPdfOpen_Click">Open Drawing</asp:LinkButton>
                                    </li>
                                   <%-- <li>
                                      <asp:LinkButton ID="btnPdfDownload" runat="server" OnClick="btnPdfDownload_Click">Download Drawing</asp:LinkButton>
                                    </li>--%>
                                  </ul>
                                </div>

                                <%--Take Picture Menu--%>
                                <%--<div class="buttonMenu">
                                    <asp:LinkButton ID="btn_takePicture" runat="server" CssClass="btn btn-default disabled">
                                        <span class="glyphicon glyphicon-camera"></span>&nbsp;Take Picture
                                    </asp:LinkButton>
                                </div>--%>
                            </div>

                            <%--Process Flow of Problem--%>
                            <div class="steps-card">
                                <div id="steps">
                                    <div class="step" data-desc="New Problem" id="NewProblem_Process" runat="server">
                                        <asp:LinkButton runat="server" ID="btn_NewProblem_Process"
                                            Text="1"
                                            CssClass="btn-process" Enabled="false"
                                            ToolTip="ขั้นตอนตรวจสอบ New PM Problem"
                                            OnClick="btn_Newproblem_Process_Click" ValidationGroup="New_Problem">
                                        </asp:LinkButton>
                                    </div>
                                    <div class="step" data-desc="Acknowledge" id="Acknowledge_Process" runat="server">
                                        <asp:LinkButton runat="server" ID="btn_Acknowledge_Process"
                                            Text="2"
                                            CssClass="btn-process" Enabled="false"
                                            ToolTip="Acknowledge Process"
                                            OnClick="btn_acknowledge_Click">
                                        </asp:LinkButton>
                                    </div>
                                    <div class="step" data-desc="On Plan" id="Onplan" runat="server">
                                        <asp:LinkButton runat="server" ID="btn_Onplan"
                                            Text="3"
                                            CssClass="btn-process"
                                            ToolTip="New On Plan Process" Enabled="false"
                                            OnClick="btn_OnPlan_Click">
                                        </asp:LinkButton>
                                    </div>
                                    <div class="step" data-desc="Send for check" id="sen_for_check" runat="server">
                                        <asp:LinkButton runat="server" ID="btn_sen_for_check"
                                            Text="4"
                                            CssClass="btn-process"
                                            ToolTip="Send for check Process" Enabled="false"
                                            OnClick="btn_sen_for_check_Click">
                                        </asp:LinkButton>
                                    </div>
                                    <div class="step" data-desc="Tool Owner[J3] Check" id="Tool_Owner" runat="server">
                                        <asp:LinkButton runat="server" ID="btn_Tool_Owner"
                                            Text="5"
                                            CssClass="btn-process" OnClick="btn_Tool_Owner_Click"
                                            ToolTip="J3 Tool Owner Process" Enabled="false">
                                        </asp:LinkButton>
                                    </div>
                                    <div class="step" data-desc="ENG4[J3] Check" id="ENG4_J3" runat="server">
                                        <asp:LinkButton runat="server" ID="btn_ENG4_J3"
                                            Text="6"
                                            CssClass="btn-process" Enabled="false"
                                            OnClick="btn_ENG4_J3_Click"
                                            ToolTip="J3 PM Process">
                                        </asp:LinkButton>
                                    </div>
                                    <div class="step" data-desc="ENG4[Mgr] Check" id="ENG4_Mgr" runat="server">
                                        <asp:LinkButton runat="server" ID="btn_ENG4_Mgr"
                                            Text="7"
                                            CssClass="btn-process" Enabled="false"
                                            OnClick="btn_ENG4_Mgr_Click"
                                            ToolTip="Mgr.Approve Process">
                                        </asp:LinkButton>
                                    </div>
                                    <div class="step" data-desc="Close" id="close" runat="server">
                                        <asp:LinkButton runat="server" ID="btn_close"
                                            Text="8" Enabled="false"
                                            CssClass="btn-process"
                                            ToolTip="PM Problem Close">
                                        </asp:LinkButton>
                                    </div>
                                </div>
                                <span class="cancel-tag"><i class="fa fa-ban"></i> Cancelled</span>
                            </div>

                            <%--Header PM Problem No--%>
                            <div class="panel panel-primary" style="margin-top: 10px">

                                <%--Header PM Problem No--%>
                                <div class="panel-heading">

                                    <asp:Label runat="server" ID="lb_problem" Font-Size="20px"></asp:Label>
                                    <%--Link to PM Problem Sheet--%>
                                    <asp:LinkButton runat="server" ID="btn_detail" ToolTip="Show Problem Report" OnClick="btn_detail_Click" Style="color: white; margin-left: 5px; vertical-align: baseline;">
                                        <span class="fa fa-file-pdf-o fa-lg"></span>
                                    </asp:LinkButton>
                                </div>

                                <%--PM Problem Detail--%>
                                <div class="grid-container2">
                                    <div class="grid-container3" style="">
                                        <%--Status / Action / Type of Problem--%>
                                        <div class="grid-container4">
                                            <%--Status : Drop Down--%>
                                            <div style="margin-top: 5px;">
                                                <asp:LinkButton runat="server" ToolTip="สถานะปัจจุบันของปัญหา"
                                                    OnClick="btn_StatusMeaning_Click"
                                                    Style="font-weight: bold; color: black;">
                                                    Status :
                                                </asp:LinkButton>
                                                <asp:DropDownList ID="ddl_isOnplan" runat="server" Font-Size="15px"
                                                    CssClass="form-control h40"
                                                    DataSourceID="sql_promStatus"
                                                    DataValueField="perm_status_id"
                                                    DataTextField="perm_status_name">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="sql_promStatus" runat="server" ConnectionString="<%$ ConnectionStrings:jig_tool_systemConnectionString %>"
                                                    SelectCommand="select * from  jtPM_permStatus_master "></asp:SqlDataSource>

                                            </div>
                                            <%--Action : Drop Down--%>
                                            <div>
                                                <asp:LinkButton runat="server" ToolTip="วิธีการแก้ไขปัญหา"
                                                    OnClick="btn_ActionMeaning_Click"
                                                    Style="font-weight: bold; color: black;">
                                                    Action :
                                                </asp:LinkButton>
                                                <asp:LinkButton runat="server" ID="btn_UpdateAction" CssClass="btn btn-info" ToolTip="แก้ไข Action" OnClick="btn_UpdateAction_Click">
                                                    <span class="glyphicon glyphicon-cog"></span>
                                                </asp:LinkButton>
                                                <asp:DropDownList ID="ddl_Action" runat="server"
                                                    Font-Size="15px" DataSourceID="sql_action"
                                                    AppendDataBoundItems="true"
                                                    DataValueField="action_id" DataTextField="action_name" Enabled="false"
                                                    CssClass="ProgStatus1 h40"
                                                    Style="width: 100%; border-radius: 4px;">
                                                    <asp:ListItem Value="0">-</asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                            <%--Type of Problem : Drop Down--%>
                                            <div>
                                                <asp:LinkButton runat="server" ToolTip="ประเภทของปัญหา"
                                                    OnClick="btn_ProblemTypeMeaning_Click"
                                                    Style="font-weight: bold; color: black;">
                                                    Type of Problem :
                                                </asp:LinkButton>
                                                <asp:LinkButton runat="server" ID="btn_UpdateTypeProblem" CssClass="btn btn-info" ToolTip="แก้ไขประเภทของปัญหา" OnClick="btn_update_TypeProblem_Click">
                                                    <span class="glyphicon glyphicon-cog"></span>
                                                </asp:LinkButton>
                                                <asp:DropDownList runat="server" Font-Size="15px"
                                                    ID="ddl_Pro_type1"
                                                    DataSourceID="sql_type1"
                                                    DataTextField="SYM_NAME"
                                                    DataValueField="symbol_id" Enabled="false"
                                                    CssClass="ProgStatus2 h40" AppendDataBoundItems="true"
                                                    Style="border-radius: 4px;">
                                                    <asp:ListItem Value="">-</asp:ListItem>
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="sql_type1" runat="server" ConnectionString="<%$ ConnectionStrings:jig_tool_systemConnectionString %>"
                                                    SelectCommand="select  id_no as symbol_id ,CONVERT(nvarchar,ROW_NUMBER() OVER(ORDER BY id_no ASC))+'. '+ symbol_name as SYM_NAME ,type from jtPM_symbol_master where type in (1,99) "></asp:SqlDataSource>
                                            </div>
                                        </div>

                                        <%--@@@ Tool Detail--%>
                                        <div class="grid-container9">
                                            <div class="grid-container9_1">
                                                <%--@@@ Tool Number--%>
                                                <div class="form-inline">
                                                    <label title="หมายเลข Jig tool" class="form-control-static topic-header">Tool No :</label>
                                                    <br />
                                                    <asp:HiddenField ID="hd_toolID" runat="server" />
                                                    <asp:HiddenField ID="hd_tool_name" runat="server" />

                                                    <asp:TextBox runat="server" ID="txt_toolno" CssClass="form-control"
                                                        Style="width: 99%;"
                                                        Enabled="false">
                                                    </asp:TextBox>
                                                </div>

                                                <%--@@@ Tool of Tool--%>
                                                <div class="form-inline">
                                                    <label title="สำดับของ Jig Tool" class="form-control-static topic-header">No of Tool :</label>
                                                    <br />
                                                    <asp:TextBox runat="server" ID="txt_toolsub_id" CssClass="form-control disabled"
                                                        Text=""
                                                        Style="width: 99%;"
                                                        Enabled="false">
                                                    </asp:TextBox>
                                                </div>

                                                <%--@@@ Fix Asset--%>
                                                <div class="form-inline">
                                                    <label title="หมายเลข Fix Asset" class="form-control-static topic-header">Fix Asset :</label>
                                                    <br />
                                                    <asp:TextBox runat="server" ID="txt_Fixasset" CssClass="form-control disabled"
                                                        Text=""
                                                        Style="width: 99%;"
                                                        Enabled="false">
                                                    </asp:TextBox>
                                                </div>

                                                <%--@@@ Model--%>
                                                <div class="form-inline">
                                                    <label title="ใช้ที่ Product" class="form-control-static topic-header">Model :</label>
                                                    <br />
                                                    <asp:TextBox runat="server" ID="txt_Model" CssClass="form-control disabled"
                                                        Text=""
                                                        Style="width: 99%;"
                                                        Enabled="false">
                                                    </asp:TextBox>
                                                </div>

                                                <%--@@@ Location--%>
                                                <div class="form-inline">
                                                    <label title="บริเวณที่ใช้งาน" class="form-control-static topic-header">Location :</label>
                                                    <br />
                                                    <asp:TextBox runat="server" ID="txt_Location" CssClass="form-control disabled"
                                                        Style="width: 99%;"
                                                        Enabled="false">
                                                    </asp:TextBox>
                                                </div>
                                            </div>
                                            <%--Tool Detail button--%>
                                            <div style="align-content: center; margin-left: 10px;">
                                                <a id="ToolDetail_link" runat="server" href="#" target="_blank">
                                                    <div class="btn  btn-primary" style="height: 70%; width: 95%; text-align: center">
                                                        <lable style="font-size: smaller">
                                                            <span class="glyphicon glyphicon-search"></span>
                                                            &nbsp;
                                                            <br />
                                                            Tool Detail
                                                        </lable>
                                                    </div>
                                                </a>
                                            </div>
                                        </div>

                                        <%--@@@ Issue Name , Type of Problem , Problem Date , Shift--%>
                                        <div class="grid-container6" style="">
                                            <div class="grid-container6_1" style="">
                                                <%--@@@ Type PM Problem--%>
                                                <div class="form-inline">
                                                    <label title="กระบวนการที่เกิดปัญหา" class="form-control-static topic-header">Type :</label>
                                                    <br />
                                                    <div class="dd-with-icon">
                                                        <asp:DropDownList ID="ddl_type" runat="server" CssClass="form-control"
                                                            Enabled="false"
                                                            AppendDataBoundItems="true"
                                                            DataSourceID="sql_ddl_type"
                                                            DataTextField="pm_docName"
                                                            DataValueField="pm_docID">
                                                            <asp:ListItem Value="">-selected-</asp:ListItem>
                                                        </asp:DropDownList>
                                                        <asp:LinkButton ID="btn_download_report" runat="server" CssClass="icon-btn" ToolTip="Download Period Check (Excel)" OnClick="btn_download_report_Click">
                                                            <asp:Image ID="excelReport" runat="server" ImageUrl="~/images/009-xls.png" Width="20px" Height="20px" />
                                                        </asp:LinkButton>
                                                    </div>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="ddl_type" ErrorMessage="please select type." Display="Dynamic" ForeColor="Red" ValidationGroup="New_Problem"></asp:RequiredFieldValidator>

                                                    <asp:SqlDataSource ID="sql_ddl_type" runat="server"
                                                        ConnectionString="<%$ ConnectionStrings:jig_tool_systemConnectionString  %>"
                                                        SelectCommand="select * from jtPM_master_doc where active = 1 order by pm_docID"></asp:SqlDataSource>
                                                </div>

                                                <%--@@@ Issue Name--%>
                                                <div class="form-inline">
                                                    <label title="Member ที่ขึ้นสภาพปัญหา" class="form-control-static topic-header">Issue Name : </label>
                                                    <br />
                                                    <asp:HiddenField ID="hd_issue_id" runat="server" />
                                                    <asp:HiddenField ID="hd_GroupIssue" runat="server" />
                                                    <asp:HiddenField ID="hd_GroupIssue_id" runat="server" />
                                                    <asp:TextBox runat="server" ID="txt_issue" CssClass="form-control disabled"
                                                        Style="width: 98%;"
                                                        Enabled="false">
                                                    </asp:TextBox>
                                                </div>

                                                <%--@@@ Problem Date--%>
                                                <div class="form-inline">
                                                    <label title="วันที่เกิดปัญหา" class="form-control-static topic-header">Problem Date : </label>
                                                    <br />
                                                    <div class='input-group disabled' style="width:98%;">
                                                        <asp:TextBox ID="txt_problemDate" runat="server" CssClass="form-control disabled" Width="" Enabled="false"></asp:TextBox>
                                                        <span class="input-group-addon">
                                                            <span class="glyphicon glyphicon-calendar"></span>
                                                        </span>
                                                    </div>
                                                    <%--&nbsp;&nbsp;--%>
                                                </div>

                                                <%--@@@ Shift--%>
                                                <div class="form-inline">
                                                    <label title="Shift ที่เกิดปัญหา" class="form-control-static topic-header">Shift : </label>
                                                    <br />
                                                    <asp:DropDownList ID="ddl_shift" runat="server" Font-Size="Medium" Enabled="false" CssClass="form-control" Style="width:98%;">
                                                        <asp:ListItem Value="">-</asp:ListItem>
                                                        <asp:ListItem Value="1">Day</asp:ListItem>
                                                        <asp:ListItem Value="2">Night</asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>
                                            </div>

                                            <%--@@@ Button แก้ไข--%>
                                            <div class="gear-cell">
                                                <asp:LinkButton runat="server" ID="btn_Update_Type_Issue" CssClass="btn btn-info" ToolTip="แก้ไข" OnClick="btn_Update_Type_Issue_Click">
                                                    <span class="glyphicon glyphicon-cog"></span>
                                                </asp:LinkButton>
                                            </div>

                                            <%--  problem Appove--%>
                                            <asp:HiddenField ID="hd_issue" runat="server" />
                                            <asp:HiddenField ID="hd_issue_date" runat="server" />
                                            <asp:HiddenField ID="hd_leder_appove" runat="server" />
                                            <asp:HiddenField ID="hd_leder_date" runat="server" />
                                            <asp:HiddenField ID="hd_toolOwner_appove" runat="server" />
                                            <asp:HiddenField ID="hd_toolOwner_date" runat="server" />
                                            <asp:HiddenField ID="hd_mgr_appove" runat="server" />
                                            <asp:HiddenField ID="hd_mgr_date" runat="server" />

                                        </div>

                                        <%--@@@ Resp.Name , Resp.Group , Tool Owner--%>
                                        <div class="grid-container7">
                                            <div class="grid-container7_1">
                                                <%--@@@ Resp.Name--%>
                                                <div class="form-inline">
                                                    <label title="ผู้รับผิดชอบแก้ไขปัญหา" class="form-control-static topic-header">Resp. Name : </label>
                                                    <br />
                                                    <asp:DropDownList ID="ddl_pic1" runat="server"
                                                        CssClass="form-control" Enabled="false"
                                                        Style="width:98%;">
                                                    </asp:DropDownList>
                                                </div>
                                                <%--@@@ Resp.Group--%>
                                                <div class="form-inline">
                                                    <label title="ทีมที่รับผิดชอบแก้ไขปัญหา" class="form-control-static topic-header">Resp. Group : </label>
                                                    <asp:DropDownList ID="ddl_group"
                                                        runat="server"
                                                        CssClass="form-control" Enabled="false" Style="width:98%;">
                                                    </asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server" ControlToValidate="ddl_group" ErrorMessage="please select resp name." Display="Dynamic" ForeColor="Red" ValidationGroup="New_Problem"></asp:RequiredFieldValidator>

                                                    <asp:Label ID="lb_error_1" runat="server" ForeColor="Red"></asp:Label>
                                                </div>
                                                <%--@@@ Tool Owner--%>
                                                <div class="form-inline">
                                                    <label title="ทีมที่รับผิดชอบดูแล Tool" class="form-control-static topic-header">Tool Owner :</label>
                                                    <br />
                                                    <asp:DropDownList ID="ddl_owner" runat="server"
                                                        CssClass="form-control" Enabled="false" Style="width:98%;">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <%--@@@ Button แก้ไข--%>
                                            <div class="gear-cell">
                                                <asp:LinkButton runat="server" ID="btn_Update_Resp" CssClass="btn btn-info" ToolTip="แก้ไข" OnClick="btn_Update_Resp_Click"><span class="glyphicon glyphicon-cog"></span></asp:LinkButton>
                                            </div>
                                        </div>

                                        <%--@@@ Follow Up date , Plan Finish , Actual Finish--%>
                                        <div class="grid-container7">
                                            <div class="grid-container8_1">
                                                <%--Follow Up date--%>
                                                <div class="form-inline">
                                                    <label title="วันที่ติดตามความคืบหน้าปัญหา" class="form-control-static topic-header">Follow Up Date :</label>
                                                    <div class="input-group">
                                                        <asp:TextBox ID="txt_follow_up" runat="server"
                                                            Enabled="false"
                                                            CssClass="form-control disabled"
                                                            Width="">
                                                        </asp:TextBox>
                                                        <span class="input-group-addon">
                                                            <span class="glyphicon glyphicon-calendar"></span>
                                                        </span>
                                                    </div>
                                                </div>
                                                <%--Plan Finish--%>
                                                <div class="form-inline">
                                                    <label title="แผนเสร็จสิ้น" class="form-control-static topic-header">Plan Finish : </label>
                                                    <asp:HiddenField runat="server" ID="lb_plan"></asp:HiddenField>
                                                    <div class='input-group' style="width:98%;">
                                                        <asp:TextBox ID="txt_planFinish" runat="server"
                                                            Enabled="false"
                                                            CssClass="form-control disabled"
                                                            Width="">
                                                        </asp:TextBox>
                                                        <span class="input-group-addon">
                                                            <span class="glyphicon glyphicon-calendar"></span>
                                                        </span>
                                                    </div>
                                                </div>
                                                <%--Actual Finish--%>
                                                <div class="form-inline">
                                                    <label title="วันที่แล้วเสร็จ" class="form-control-static topic-header">Actual Finish : </label>
                                                    <div class="input-group">
                                                        <asp:TextBox ID="txt_actualFinish" runat="server"
                                                            Enabled="false"
                                                            CssClass="form-control disabled"
                                                            Width="">
                                                        </asp:TextBox>
                                                        <span class="input-group-addon">
                                                            <span class="glyphicon glyphicon-calendar"></span>
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                            <%--@@@ Button แก้ไข--%>
                                            <div class="gear-cell">
                                                &nbsp;
                                                <asp:LinkButton runat="server" ID="btn_Update_FollowUp_date" CssClass="btn btn-info" ToolTip="แก้ไข" OnClick="btn_Update_FollowUp_date_Click"><span class="glyphicon glyphicon-cog"></span></asp:LinkButton>
                                            </div>

                                        </div>

                                    </div>

                                    <%--Problem Rank--%>
                                    <div class="grid-container5">
                                        <div class="rank-head">
                                            <span>Problem Rank</span>
                                            <asp:LinkButton runat="server" ID="btn_UpdateProblemRank" CssClass="btn btn-info" ToolTip="แก้ไข Problem Rank" OnClick=" btn_update_ProblemRank_Click">
                                                <span class="glyphicon glyphicon-cog"></span>
                                            </asp:LinkButton>
                                        </div>
                                        <div class="rank-box">
                                            <asp:DropDownList ID="ddl_priority" runat="server" CssClass="h100" Enabled="false" BackColor="#ff9999" Font-Size="58px" onChange="auto_planFinist(this)">
                                                <asp:ListItem Value="">-</asp:ListItem>
                                                <asp:ListItem Value="A">A</asp:ListItem>
                                                <asp:ListItem Value="B">B</asp:ListItem>
                                                <asp:ListItem Value="C">C</asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="ddl_priority" ErrorMessage="please select rank." Display="Dynamic" ForeColor="Red" ValidationGroup="New_Problem"></asp:RequiredFieldValidator>
                                        </div>
                                        <%--Problem Rank Detail--%>
                                        <ul class="rank-legend">
                                            <li><b>A</b> Calibration / Urgent action</li>
                                            <li><b>B</b> Action / Use lead time for action</li>
                                            <li><b>C</b> Accept use / Monitoring</li>
                                        </ul>
                                    </div>

                                    <%--Picture--%>
                                    <div class="col-lg-3" style="padding-top: 5px;">

                                        <asp:LinkButton ID="btn_uploadPic" runat="server"
                                            OnClick="btn_uploadPic_Click"
                                            CssClass="btn btn-default">
                                            <span class="glyphicon glyphicon-picture"></span>
                                            &nbsp;Upload Picture Other
                                        </asp:LinkButton>

                                        <table style="width: 100%">
                                            <tr>
                                                <td>
                                                    <div id="divPicNG" class="row" runat="server">
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div id="divPicOK" class="row" runat="server">
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>

                                <%--Problem Detail , Action Detail--%>
                                <div class="grid-container10">
                                    <div class="grid-container11">
                                        <%--Problem Detail--%>
                                        <div class="grid-container11_1">
                                            <div style="align-content: center; border-left: 10px solid; border-left-color: #FFAF00">
                                                <label>Problem Detail : </label>
                                            </div>
                                            <div>
                                                <asp:TextBox ID="txt_probTopic" runat="server"
                                                    CssClass="form-control h40"
                                                    Font-Size="Large"
                                                    BackColor="#FCF5D8">
                                                </asp:TextBox>
                                            </div>
                                            <%--@@@ Button แก้ไข--%>
                                            <div style="padding-left: 5px; align-self: center;">
                                                <asp:LinkButton runat="server"
                                                    ID="btn_UpdateProblemDetail"
                                                    CssClass="btn btn-info"
                                                    ToolTip="แก้ไข"
                                                    OnClick="btn_UpdateProblemDetail_Click">
                                                    <span class="glyphicon glyphicon-cog"></span>
                                                </asp:LinkButton>
                                            </div>
                                        </div>

                                        <div class="grid-container12">
                                            <%--Problem Detail เพิ่มเติม--%>
                                            <div class="grid-container12_Problem">
                                                <div class="fa fa-info-circle">
                                                    รายละเอียดปัญหาเพิ่มเติม                                           
                                                    <asp:LinkButton runat="server"
                                                        ID="LinkButton8"
                                                        CssClass="btn btn-info"
                                                        ToolTip="แก้ไข"
                                                        OnClick="btn_UpdateProblem_moredetail_Click">
                                                        <span class="glyphicon glyphicon-cog"></span>
                                                    </asp:LinkButton>
                                                </div>
                                                <%--Spec Detail--%>
                                                <div class="grid-container12_Problem1 kv-spec">
                                                    <div title="ค่ามาตรฐานสำหรับอ้างอิงการตรวจสอบ">Spec :</div>
                                                    <div>
                                                        <asp:TextBox ID="lb_spec" runat="server" Style="border: none; background-color: unset"></asp:TextBox>
                                                    </div>
                                                    <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ControlToValidate="lb_spec" ErrorMessage="please input spec." Display="Dynamic" ForeColor="Red" ValidationGroup="New_Problem"></asp:RequiredFieldValidator>--%>
                                                </div>

                                                <%--Data Actual--%>
                                                <div class="grid-container12_Problem1 kv-actual">
                                                    <div title="ค่าที่ได้จริงจากการตรวจสอบ">Actual :</div>
                                                    <div>
                                                        <asp:TextBox ID="lb_actual" runat="server" Style="border: none; background-color: unset"></asp:TextBox>
                                                        <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ControlToValidate="lb_actual" ErrorMessage="please input actual." Display="Dynamic" ForeColor="Red" ValidationGroup="New_Problem"></asp:RequiredFieldValidator>--%>
                                                    </div>
                                                </div>

                                                <%--Detail Problem เพิ่มเติม--%>
                                                <div class="grid-container12_Problem1 kv-detail">
                                                    <div title="รายละเอียดของปัญหาเพิ่มเติม">Detail :</div>
                                                    <div>
                                                        <asp:TextBox ID="lb_detailProblem" runat="server"
                                                            TextMode="MultiLine"
                                                            Width="95%"
                                                            Height="95%" Disabled="true"
                                                            Style="border: none; background-color: unset">
                                                        </asp:TextBox>
                                                        <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ControlToValidate="lb_detailProblem" ErrorMessage="please input problem detail." Display="Dynamic" ForeColor="Red" ValidationGroup="New_Problem"></asp:RequiredFieldValidator>--%>
                                                    </div>
                                                </div>

                                            </div>

                                            <%--Action Detail เพิ่มเติม--%>
                                            <div class="grid-container12_Action">
                                                <div class="fa fa-info-circle">
                                                    รายละเอียดการแก้ไขปัญหา 
                                                    <asp:LinkButton runat="server"
                                                        ID="LinkButton9"
                                                        CssClass="btn btn-info"
                                                        ToolTip="แก้ไข"
                                                        OnClick="btn_UpdateAction_moredetail_Click">
                                                        <span class="glyphicon glyphicon-cog"></span>
                                                    </asp:LinkButton>
                                                </div>
                                                <%--Data Result--%>
                                                <div class="grid-container12_Problem1 kv-result">
                                                    <div title="ค่าที่ได้หลังจากแก้ไขแล้ว">Result :</div>
                                                    <div>
                                                        <asp:TextBox ID="lb_result_spec" runat="server" Style="border: none; background-color: unset"></asp:TextBox>
                                                    </div>
                                                </div>

                                                <%--Detail Problem เพิ่มเติม--%>
                                                <div class="grid-container12_Problem1 kv-detail">
                                                    <div title="รายละเอียดการแก้ไขปัญหาเพิ่มเติม">Detail :</div>
                                                    <div>
                                                        <asp:TextBox runat="server" ID="lb_result_detail"
                                                            TextMode="MultiLine"
                                                            Width="95%"
                                                            Height="95%" Disabled="true"
                                                            Style="border: none; background-color: unset">
                                                        </asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="grid-container13">
                                        <div>Problem Analyze</div>

                                        <%--Main Problem Condition--%>
                                        <div class="grid-container13_1">
                                            <div style="text-align: right; align-content: center;">
                                                <label title="สภาพของปัญหาหลัก" style="font-size: small;">
                                                    Main Problem:
                                                </label>
                                            </div>
                                            <div>
                                                <asp:DropDownList runat="server" ID="ddl_Pro_type2"
                                                    DataSourceID="sql_type2"
                                                    DataTextField="SYM_NAME"
                                                    DataValueField="symbol_id"
                                                    CssClass="form-control " AppendDataBoundItems="true">
                                                    <asp:ListItem Value="">-</asp:ListItem>
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="sql_type2" runat="server" ConnectionString="<%$ ConnectionStrings:jig_tool_systemConnectionString %>"
                                                    SelectCommand="select  id_no as symbol_id ,CONVERT(nvarchar,ROW_NUMBER() OVER(ORDER BY id_no ASC))+'. '+ symbol_name as SYM_NAME ,type from jtPM_symbol_master where type in (2,99)"></asp:SqlDataSource>
                                            </div>
                                        </div>

                                        <%--Sub Problem Condition--%>
                                        <div class="grid-container13_1">
                                            <div style="text-align: right; align-content: center;">
                                                <label title="สภาพของปัญหารอง" style="font-size: small;">
                                                    Sub Problem:
                                                </label>
                                            </div>
                                            <div>
                                                <asp:DropDownList runat="server" ID="ddl_Pro_type3"
                                                    DataSourceID="sql_type3"
                                                    DataTextField="SYM_NAME"
                                                    DataValueField="symbol_id"
                                                    CssClass="form-control " AppendDataBoundItems="true">
                                                    <asp:ListItem Value="">-</asp:ListItem>
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="sql_type3" runat="server" ConnectionString="<%$ ConnectionStrings:jig_tool_systemConnectionString %>"
                                                    SelectCommand="select  id_no as symbol_id ,CONVERT(nvarchar,ROW_NUMBER() OVER(ORDER BY id_no ASC))+'. '+ symbol_name as SYM_NAME ,type from jtPM_symbol_master where type in (3,99)"></asp:SqlDataSource>
                                            </div>
                                        </div>

                                        <%--Part & Equipment--%>
                                        <div class="grid-container13_1">
                                            <div style="text-align: right; align-content: center;">
                                                <label title="ชิ้นส่วน,อุปกรณ์ที่เป็นปัญหา" style="font-size: small;">
                                                    Part,Equipment:
                                                </label>
                                            </div>
                                            <div>
                                                <asp:DropDownList runat="server" ID="ddl_part_equi"
                                                    DataSourceID="sql_equi"
                                                    DataTextField="EQUI"
                                                    DataValueField="equi_id"
                                                    CssClass="form-control " AppendDataBoundItems="true">
                                                    <asp:ListItem Value="">-</asp:ListItem>
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="sql_equi" runat="server" ConnectionString="<%$ ConnectionStrings:jig_tool_systemConnectionString %>"
                                                    SelectCommand="select *, CONVERT(varchar,equi_id)+'. '+equi_name as EQUI from jtPM_equipment_master"></asp:SqlDataSource>
                                            </div>
                                        </div>

                                        <%--สัมผัสกับชิ้นงานหรือไม่--%>
                                        <div class="grid-container13_1">
                                            <div style="text-align: right; align-content: center;">
                                                <label style="font-size: smaller;">
                                                    สัมผัสกับชิ้นงานหรือไม่ : 
                                                </label>
                                            </div>
                                            <div>
                                                <asp:DropDownList runat="server" ID="ddl_touch" CssClass="form-control">
                                                    <asp:ListItem Value="">-</asp:ListItem>
                                                    <asp:ListItem Value="Yes">Yes</asp:ListItem>
                                                    <asp:ListItem Value="No">No</asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                        </div>

                                        <%--เสี่ยงต่อการเกิดอุบัติเหตุ:--%>
                                        <div class="grid-container13_1">
                                            <div style="text-align: right; align-content: center;">
                                                <label style="font-size: smaller;">
                                                    เสี่ยงต่อการเกิดอุบัติเหตุ:
                                                </label>
                                            </div>
                                            <div>
                                                <asp:DropDownList runat="server" ID="ddl_risk" CssClass="form-control">
                                                    <asp:ListItem Value="">-</asp:ListItem>
                                                    <asp:ListItem Value="Yes">Yes</asp:ListItem>
                                                    <asp:ListItem Value="No">No</asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                        </div>
                                    </div>
                                </div>


                                <%--Comment History PM Problem--%>
                                <div class="pd-history">
                                <div title="ประวัติการแก้ไขปัญหา PM" class="fa fa-history">
                                    Troubleshooting History of PM Problem
                                </div>
                                <div class="row" style="margin-left: 10px; width: 98%;">
                                    <table class=" table table-bordered table-condensed">
                                        <tr>
                                            <td style="text-align: center !important">
                                                <asp:GridView runat="server" ID="gv_problemDetail"
                                                    CssClass="table table-bordered table-condensed table-responsive"
                                                    ShowFooter="true"
                                                    OnRowCancelingEdit="gv_problemDetail_RowCancelingEdit"
                                                    OnRowEditing="gv_problemDetail_RowEditing"
                                                    OnRowUpdating="gv_problemDetail_RowUpdating"
                                                    OnRowDataBound="gv_problemDetail_RowDataBound" Width="100%"
                                                    AutoGenerateColumns="false">
                                                    <HeaderStyle BackColor="#337ab7" ForeColor="White" CssClass="table-header" />
                                                    <AlternatingRowStyle BackColor="#d0e3f2" />
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="Detail" ItemStyle-HorizontalAlign="Left">
                                                            <ItemTemplate>
                                                                <asp:HiddenField runat="server" ID="hd_detail_id" Value='<%#Eval("detail_id") %>' />
                                                                <asp:Label ID="lb_detail" runat="server" Text='<%#Eval("prob_detail") %>'></asp:Label>
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                <asp:TextBox runat="server" ID="txt_edit" Text='<%#Eval("prob_detail") %>' CssClass="form-control"></asp:TextBox>
                                                            </EditItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="PIC" ItemStyle-Width="15%">
                                                            <ItemTemplate>
                                                                <asp:HiddenField runat="server" ID="hd_empID" Value='<%#Eval("emp_id") %>' />
                                                                <asp:Label ID="lb_picAdd" runat="server" Text='<%#Eval("add_by") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Date" ItemStyle-Width="15%">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lb_date" runat="server" Text='<%#Eval("date") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Action" ItemStyle-Width="15%">
                                                            <ItemTemplate>
                                                                <%--<asp:LinkButton runat="server" ID="btn_Edit" CommandName="Edit" CommandArgument='<%#Eval("detail_id") %>' CssClass="btn"><span class="glyphicon glyphicon-edit"></span></asp:LinkButton>--%>
                                                                <asp:LinkButton runat="server" ID="btn_delete" OnClick="btn_delete_Click" CssClass="btn" OnClientClick="return confirm('Are you sure?');"><span class="glyphicon glyphicon-trash"></span></asp:LinkButton>
                                                            </ItemTemplate>
                                                            <EditItemTemplate>
                                                                <asp:LinkButton runat="server" ID="edit_save" CssClass="btn-success"><span class="glyphicon glyphicon-save"></span></asp:LinkButton>
                                                                <asp:LinkButton runat="server" ID="edit_cancel" CssClass="btn-danger" CommandName="Cancel"><span class="glyphicon glyphicon-ban-circle"></span></asp:LinkButton>
                                                            </EditItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </asp:GridView>
                                            </td>
                                        </tr>

                                        <tr>
                                            <td>
                                                <asp:Label ID="Error" runat="server" ForeColor="Red" Text="กรุณาอย่าใส่สัญญาลักษ์ single close (') ในข้อความ"></asp:Label>
                                                <asp:TextBox placeholder="บันทึกความคืบหน้า / การแก้ไขปัญหา..." ID="txt_detail" runat="server" TextMode="MultiLine" Width="100%"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator14" runat="server" ControlToValidate="txt_detail" Display="Dynamic" ForeColor="Red" ValidationGroup="submit"></asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:Label ID="lb_test" runat="server" ForeColor="Red"></asp:Label>
                                </div>
                                <div class="row pd-save">
                                    <asp:LinkButton ID="btn_summit" runat="server" CssClass="btn btn-primary btn-lg" OnClick="btn_summit_Click" ValidationGroup="submit">Save&nbsp;<span class="glyphicon glyphicon-floppy-saved"></span></asp:LinkButton>
                                </div>
                                </div>
                            </div>


                        </div>
                        <asp:Label ID="test1" runat="server" ForeColor="Red"></asp:Label>
                        <asp:Label ID="lb_text" runat="server" ForeColor="Red"></asp:Label>
                    </div>
                    <hr />
                </asp:Panel>

            </ContentTemplate>
            <Triggers>
                <%--<asp:PostBackTrigger ControlID="" />--%>
            </Triggers>

        </asp:UpdatePanel>


        <%--<<<<<<<<<<<<<<<<< Modal Show Picture Problem >>>>>>>>>>>>>>>>>>>>>>>>>>>>>--%>
        <div class="modal fade" id="UploadPicture_modal2" role="dialog">
            <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                <ContentTemplate>
                    <div class="modal-dialog" style="width: 90% !important; margin-top: 5%;">
                        <div class="modal-content">
                            <div class="modal-header ">
                                <button type="button" class="close" data-dismiss="modal" onclick="location.href=location.href" style="font-size: large !important">&times;</button>
                            </div>
                            <div class="modal-body">
                                <div style="text-align: center !important">
                                    <asp:Image ID="img_modal" runat="server" CssClass="pic2" />
                                </div>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>

        <%--  //modal Upload Picture Other_modal--%>
        <div class="modal fade" id="UploadPicture_modal" role="dialog" data-keyboard="false" data-backdrop="static">

            <div class="modal-dialog modal-sm4">
                <div class="modal-content">
                    <div class="modal-header theme-bg-color1 theme-text-color2">
                        <button type="button" class="close" data-dismiss="modal" onclick="location.href=location.href">&times;</button>
                        <h4 class="modal-title"><i class="fa fa-pencil-square-o"></i>&nbsp;Upload Pictrue</h4>
                    </div>
                    <div class="modal-body">
                        <div>
                            <div class=" form-inline" id="div_OK" runat="server">
                                <asp:RadioButton ID="re_NG" Text=" Picture NG" ForeColor="Red" GroupName="ScanOnStartupRadio" runat="server" AutoPostBack="false" Checked="false" />
                                &nbsp
                                        <asp:RadioButton ID="re_OK" Text=" Picture OK" ForeColor="Green" GroupName="ScanOnStartupRadio" runat="server" AutoPostBack="false" Checked="false" />
                                &nbsp
                                        <asp:Label runat="server" ForeColor="Red" Text=" 'Please select pictrue type' "></asp:Label>
                            </div>
                            <div class="form-inline">
                                <%--<asp:Label ID="lb_problem_no" runat="server" Text="Problem No :"></asp:Label>--%>
                                <asp:Label ID="lb_link" ForeColor="Red" runat="server"></asp:Label>
                            </div>
                            <div class="form-inline">

                                <asp:FileUpload CssClass="form-control" runat="server" ID="UploadImages" AllowMultiple="true" Height="40px" />
                                <asp:LinkButton ID="btn_UploadPicture" runat="server" CssClass="btn btn2 btn-info" OnClientClick="if(CheckRadio() == false) return(false);" OnClick="btn_UploadPicture_Click"><span class="glyphicon glyphicon-upload"></span>&nbsp;Upload</asp:LinkButton>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%--  //modal Upload Picture Problem _modal--%>
        <div class="modal fade" id="modal_UploadPic_problem" role="dialog" data-keyboard="false" data-backdrop="static">
            <div class="modal-dialog modal-sm4">
                <div class="modal-content">
                    <div class="modal-header theme-bg-color1 theme-text-color2">
                        <button type="button" class="close" data-dismiss="modal" onclick="location.href=location.href">&times;</button>
                        <h4 class="modal-title"><i class="fa fa-pencil-square-o"></i>&nbsp;Upload Pictrue</h4>
                    </div>
                    <div class="modal-body">
                        <div>
                            <div class=" form-inline" id="div7" runat="server">
                                <asp:Label runat="server" Text="1.Picture 1:จุด ,บริเวณที่เกิดปัญหา"></asp:Label>
                            </div>
                            <div class="form-inline">
                                <asp:FileUpload CssClass="form-control" runat="server" ID="UploadPicProblem1" AllowMultiple="true" Height="40px" />
                                <%--<ajaxToolkit:AsyncFileUpload runat="server" ID="FileUpload1" />--%>
                            </div>
                            &nbsp;&nbsp;
                                    <div class=" form-inline" id="div_Pic2" runat="server">
                                        <asp:Label runat="server" Text="2. Picture 2 : รายละเอียดสภาพปัญหา"></asp:Label>
                                    </div>
                            <div class="form-inline">
                                <asp:FileUpload CssClass="form-control" runat="server" ID="UploadPicProblem2" AllowMultiple="true" Height="40px" />
                            </div>
                            &nbsp;&nbsp;  
                             <div class=" form-inline" id="div11" runat="server">
                                 <asp:Label runat="server" Text="3.Picture 3:รูปภาพหลังการแก้ไขปัญหาเสร็จสิ้น "></asp:Label>
                             </div>
                            <div class="form-inline">
                                <asp:FileUpload CssClass="form-control" runat="server" ID="UploadAction" AllowMultiple="true" Height="40px" />
                            </div>
                            &nbsp;&nbsp;
                            <div class="form-inline">
                                <asp:LinkButton ID="btn_UploadPicture_Problem" runat="server" CssClass="btn btn2 btn-info" OnClick="btn_UploadPicture_Problem_Click"><span class="glyphicon glyphicon-upload"></span>&nbsp;Upload</asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <%-- <%--<<<<<<<<<<< Modal Progressive Status Process >>>>>>>>>>>--%>

        <%--Modal New Problem Process--%>
        <div class="modal fade" id="modal_NewProblemProcess" role="dialog" style="height: 100%">
            <asp:UpdateProgress ID="UpdateProgress13" runat="server" AssociatedUpdatePanelID="UpdatePanel13">
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

            <asp:UpdatePanel ID="UpdatePanel13" runat="server">
                <ContentTemplate>
                    <div class="modal-dialog" style="width: 50% !important; margin-top: 5%;">
                        <div class="modal-content">
                            <div class="modal-header " style="background-color: #337ab7; color: white">
                                <button type="button" class="close" data-dismiss="modal" onclick="location.href=location.href" style="font-size: large !important">&times;</button>
                                <div>
                                    <h4 runat="server" id="h7">ตรวจสอบข้อมูลเบื้องต้น New PM Problem </h4>
                                </div>
                            </div>
                            <div class="modal-body">
                                <%--Check Box : PM Problem Sheet--%>
                                <div class="grid-NewProblem_Modal1">
                                    <asp:CheckBox ID="CB_ProblemSheet" runat="server"
                                        CssClass="ChkBoxClass"
                                        ToolTip="ตรวจสอบเอกสาร PM Problem"
                                        AutoPostBack="true"></asp:CheckBox>
                                    <div style="margin-left: 5px;">
                                        <label title="ตรวจสอบเอกสาร PM Problem"
                                            style="vertical-align: bottom;">
                                            PM Problem Sheet :</label>
                                        <%--Link to PM Problem Sheet--%>
                                        <asp:LinkButton runat="server" ID="LinkButton13" OnClick="btn_detail_Click" Style="margin-left: 5px; vertical-align: baseline;">
                                            <span class="fa fa-file-pdf-o fa-lg"></span>
                                        </asp:LinkButton>
                                    </div>
                                </div>
                                <%--Check Box : Type of Problem--%>
                                <div class="grid-NewProblem_Modal2">
                                    <asp:CheckBox ID="CB_TypeofProblem" runat="server"
                                        CssClass="ChkBoxClass"
                                        ToolTip="ตรวจสอบประเภทของปัญหา"
                                        AutoPostBack="true"></asp:CheckBox>

                                    <div style="margin-left: 5px;">
                                        <label title="ตรวจสอบประเภทของปัญหา"
                                            style="vertical-align: bottom;">
                                            Type of Problem :</label>
                                    </div>

                                    <table>
                                        <tr>
                                            <th>
                                                <asp:TextBox ID="txt_TypeofProblem" runat="server"
                                                    CssClass="form-control h40"
                                                    Font-Size="Medium"
                                                    BackColor="#FCF5D8"
                                                    Style="width: 60%; height: 90% !important; margin-left: -15px; align-self: center;">
                                                </asp:TextBox>
                                            </th>
                                            <th>
                                                <asp:LinkButton runat="server"
                                                    ID="btn_ProblemTypeMeaning"
                                                    ToolTip="ความหมาย"
                                                    OnClick="btn_ProblemTypeMeaning_Click"
                                                    Style="margin-left: -165px;">
                                                    <span class="fa fa-info-circle fa-2x"></span>
                                                </asp:LinkButton>
                                            </th>
                                        </tr>
                                    </table>
                                </div>
                                <%--Check Box : Problem Detail--%>
                                <div class="grid-NewProblem_Modal3">
                                    <asp:CheckBox ID="CB_ProblemDetail" runat="server"
                                        CssClass="ChkBoxClass"
                                        ToolTip="ตรวจสอบสภาพปัญหา"
                                        AutoPostBack="true"></asp:CheckBox>

                                    <div style="margin-left: 5px;">
                                        <label title="ตรวจสอบสภาพปัญหา"
                                            style="vertical-align: bottom;">
                                            Problem Detail :</label>
                                    </div>
                                    <asp:TextBox ID="txt_ProblemDetail" runat="server"
                                        CssClass="form-control h40"
                                        TextMode="MultiLine"
                                        Font-Size="Medium"
                                        BackColor="#FCF5D8"
                                        Style="width: 95%; height: 90% !important; margin-left: -15px; align-self: center;">
                                    </asp:TextBox>
                                </div>
                                <%--Check Box : Problem Rank--%>
                                <div class="grid-NewProblem_Modal2">
                                    <asp:CheckBox ID="CB_ProblemRank" runat="server"
                                        CssClass="ChkBoxClass"
                                        ToolTip="ตรวจสอบ PM Problem Rank"
                                        AutoPostBack="true"></asp:CheckBox>

                                    <div style="margin-left: 5px;">
                                        <label title="ตรวจสอบ PM Problem Rank"
                                            style="vertical-align: bottom;">
                                            Problem Rank :</label>
                                    </div>
                                    <table>
                                        <tr>
                                            <th>
                                                <asp:TextBox ID="txt_ProblemRank" runat="server"
                                                    CssClass="form-control h40"
                                                    Font-Size="Medium"
                                                    BackColor="#FCF5D8"
                                                    Style="width: 10%; height: 90% !important; margin-left: -15px; align-self: center;">
                                                </asp:TextBox>
                                            </th>
                                            <th>
                                                <asp:LinkButton runat="server"
                                                    ID="btn_ProblemRankMeaning"
                                                    ToolTip="ความหมาย"
                                                    OnClick="btn_ProblemRankMeaning_Click"
                                                    Style="margin-left: -365px;">
                                                    <span class="fa fa-info-circle fa-2x"></span>
                                                </asp:LinkButton>
                                            </th>

                                        </tr>
                                    </table>
                                </div>
                                <div class="grid-NewProblem_Modal2">
                                    <asp:CheckBox ID="CB_Resp" runat="server"
                                        CssClass="ChkBoxClass"
                                        ToolTip="ตรวจสอบ Resp. Group"
                                        AutoPostBack="true"></asp:CheckBox>

                                    <div style="margin-left: 5px;">
                                        <label title="Group ที่รับผิดชอบ"
                                            style="vertical-align: bottom;">
                                            Resp. Group:</label>
                                    </div>
                                    <table>
                                        <tr>
                                            <th>
                                                <asp:TextBox ID="txt_resp_group_New" runat="server"
                                                    CssClass="form-control h40"
                                                    Font-Size="Medium"
                                                    BackColor="#FCF5D8"
                                                    Style="width: 10%; height: 90% !important; margin-left: -15px; align-self: center;">
                                                </asp:TextBox>
                                            </th>
                                        </tr>
                                    </table>
                                </div>
                                <%--Check Box : Data Spec--%>
                                <div class="grid-NewProblem_Modal2">
                                    <asp:CheckBox ID="CB_DataSpec" runat="server"
                                        CssClass="ChkBoxClass"
                                        ToolTip="Spec สำหรับการตรวจสอบ"
                                        AutoPostBack="true"></asp:CheckBox>

                                    <div style="margin-left: 5px;">
                                        <label title="Spec สำหรับการตรวจสอบ"
                                            style="vertical-align: bottom;">
                                            Spec :</label>
                                    </div>
                                    <asp:TextBox ID="txt_DataSpec" runat="server"
                                        CssClass="form-control h40"
                                        Font-Size="Medium"
                                        BackColor="#FCF5D8"
                                        Style="width: 40%; height: 90% !important; margin-left: -15px; align-self: center;">
                                    </asp:TextBox>
                                </div>
                                <%--Check Box : Data Actual--%>
                                <div class="grid-NewProblem_Modal2">
                                    <asp:CheckBox ID="CB_DataActual" runat="server"
                                        CssClass="ChkBoxClass"
                                        ToolTip="ค่าที่ตรวจสอบได้"
                                        AutoPostBack="true"></asp:CheckBox>

                                    <div style="margin-left: 5px;">
                                        <label title="ค่าที่ตรวจสอบได้"
                                            style="vertical-align: bottom;">
                                            Actual :</label>
                                    </div>
                                    <asp:TextBox ID="txt_DataActual" runat="server"
                                        CssClass="form-control h40"
                                        Font-Size="Medium"
                                        BackColor="#FCF5D8"
                                        Style="width: 40%; height: 90% !important; margin-left: -15px; align-self: center;">
                                    </asp:TextBox>
                                </div>
                                <%--Check Box : Problem More Detail--%>
                                <div class="grid-NewProblem_Modal4">
                                    <asp:CheckBox ID="CB_PBmoreDetail" runat="server"
                                        CssClass="ChkBoxClass"
                                        ToolTip="ตรวจสอบข้อมูลของปัญหาเพิ่มเติม"
                                        AutoPostBack="true"></asp:CheckBox>

                                    <div title="ตรวจสอบข้อมูลของปัญหาเพิ่มเติม" style="margin-left: 5px;">
                                        <label style="vertical-align: bottom;">Detail :</label>
                                    </div>
                                    <asp:TextBox ID="txt_PBmoreDetail" runat="server"
                                        CssClass="form-control h40"
                                        TextMode="MultiLine"
                                        Font-Size="Medium"
                                        BackColor="#FCF5D8"
                                        Style="width: 95%; height: 90% !important; margin-left: -15px; align-self: center;">
                                    </asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer" style="text-align: center;">
                                <asp:LinkButton ID="btn_sendMail_newProblem" runat="server"
                                    CssClass="btn fa fa-paper-plane"
                                    BackColor="#078c10"
                                    ForeColor="White"
                                    Style="align-content: center;" ValidationGroup="Send_New_Problem"
                                    OnClick="btn_sendMail_newProblem_Click" OnClientClick="if(check_checkbox() == false) return confirm('!!กรุณาตรวจสอบข้อมูลให้ครบก่อนกดส่ง ');"><%-- alert('!!กรุณาตรวจสอบข้อมูลให้ครบก่อนกดส่ง '))--%>
                                    Send Mail
                                </asp:LinkButton>
                                <asp:LinkButton ID="btn_sendMail_newProblem_cancel" runat="server"
                                    CssClass="btn " BackColor="#ec4f43"
                                    ForeColor="White"
                                    OnClick="btn_cancel_Click"
                                    OnClientClick="return confirm('Are you sure?');">
                                    Cancel
                                </asp:LinkButton>
                            </div>
                        </div>
                    </div>

                    <script>
                        function check_checkbox() {
                            var CB_ProblemSheet = $('#CB_ProblemSheet').is(':checked');
                            var CB_TypeofProblem = $('#CB_TypeofProblem').is(':checked');
                            var CB_ProblemDetail = $('#CB_ProblemDetail').is(':checked');
                            var CB_ProblemRank = $('#CB_ProblemRank').is(':checked');
                            var CB_Resp = $('#CB_Resp').is(':checked');
                            var CB_DataSpec = $('#CB_DataSpec').is(':checked');
                            var CB_DataActual = $('#CB_DataActual').is(':checked');
                            var CB_PBmoreDetail = $('#CB_PBmoreDetail').is(':checked');

                            if (CB_ProblemSheet == false) {
                                // CB_ProblemSheet.classList.add("border-red");
                                return false;
                            }
                            if (CB_TypeofProblem == false) {
                                //  CB_TypeofProblem.classList.add("border-red");
                                return false;
                            }
                            if (CB_ProblemDetail == false) {
                                //  CB_ProblemDetail.classList.add("border-red");
                                return false;
                            }
                            if (CB_ProblemRank == false) {
                                //  CB_ProblemRank.classList.add("border-red");
                                return false;
                            }
                            if (CB_Resp == false) {
                                //   CB_Resp.classList.add("border-red");
                                return false;
                            }
                            if (CB_DataSpec == false) {
                                //  CB_DataSpec.classList.add("border-red");
                                return false;
                            }
                            if (CB_DataActual == false) {
                                //   CB_DataActual.classList.add("border-red");
                                return false;
                            }
                            if (CB_PBmoreDetail == false) {
                                //  CB_PBmoreDetail.classList.add("border-red");
                                return false;
                            }
                            return true;
                        }
                    </script>
                </ContentTemplate>
                <Triggers>
                </Triggers>
            </asp:UpdatePanel>
        </div>

        <%--Modal Acknowledge--%>
        <div class="modal fade" id="AcknowledgeModal" role="dialog">
            <asp:UpdateProgress ID="UpdateProgress4" runat="server" AssociatedUpdatePanelID="UpdatePanel4">
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

            <asp:UpdatePanel ID="UpdatePanel4" runat="server">
                <ContentTemplate>
                    <div class="modal-dialog" style="width: 60% !important; margin-top: 5%;">
                        <div class="modal-content ">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" style="font-size: large !important" onclick="location.href=location.href">&times;</button>
                                <div>
                                    <h4>ข้อมูลเบื้องต้นสำหรับการรับทราบปัญหา [Acknowledge:PM Problem]</h4>
                                </div>
                            </div>
                            <div class="modal-body">
                                <div class="row">
                                    <div class="col-lg-4" style="width: 30% !important;">
                                        <div class="form-inline">
                                            <label class="form-control-static" title="การแก้ไขปัญหา">Action : </label>
                                            <asp:LinkButton runat="server"
                                                ID="LinkButton20"
                                                ToolTip="ความหมาย"
                                                OnClick="btn_ActionMeaning_Click"
                                                Style="">
                                                <span class="fa fa-info-circle"></span>
                                            </asp:LinkButton>

                                            <asp:DropDownList ID="ddl_action1" runat="server"
                                                Font-Size="Large" DataSourceID="sql_action"
                                                AppendDataBoundItems="true" DataValueField="action_id"
                                                DataTextField="action_name"
                                                CssClass="form-control">
                                                <asp:ListItem Value="0">-</asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:SqlDataSource ID="sql_action" runat="server"
                                                ConnectionString="<%$ ConnectionStrings:jig_tool_systemConnectionString %>"
                                                SelectCommand="select action_id,action_name from  jtPM_actionStatus_master order by action_id"></asp:SqlDataSource>
                                        </div>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server"
                                            ControlToValidate="ddl_action"
                                            ErrorMessage="please select Action."
                                            Display="Dynamic" ForeColor="Red"
                                            ValidationGroup="Acknowledge">
                                        </asp:RequiredFieldValidator>
                                    </div>
                                </div>

                                <div class="row" style="margin-bottom: 10px  !important;">
                                    <div class="col-lg-4" style="width: 30% !important;">
                                        <div class="form-inline">
                                            <label class="form-control-static" title="ผู้รับผิดชอบแก้ไขปัญหา">Resp. Name : </label>
                                            <%--&nbsp--%>
                                            <asp:DropDownList ID="ddl_pic" runat="server"
                                                CssClass="form-control">
                                            </asp:DropDownList>
                                        </div>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                                            ControlToValidate="ddl_pic"
                                            ErrorMessage="please select PIC."
                                            Display="Dynamic" ForeColor="Red"
                                            ValidationGroup="Acknowledge">
                                        </asp:RequiredFieldValidator>
                                    </div>
                                    <div class="col-lg-4" style="width: 30% !important;">
                                        <div class="form-inline">
                                            <label class="form-control-static" title="วันที่ต้องติดดามความคืบหน้าครั้งต่อไป">Follow Up Date :</label>
                                            <div class="input-group date">
                                                <asp:TextBox ID="txt_follow" runat="server" CssClass="form-control date" Width="80px"></asp:TextBox>
                                                <span class="input-group-addon">
                                                    <span class="glyphicon glyphicon-calendar"></span>
                                                </span>
                                            </div>
                                        </div>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server"
                                            ControlToValidate="txt_follow"
                                            ErrorMessage="please Add Follow Up."
                                            Display="Dynamic" ForeColor="Red"
                                            ValidationGroup="Acknowledge">
                                        </asp:RequiredFieldValidator>
                                    </div>
                                    <div class="col-lg-4" style="width: 30% !important;">
                                        <div class="form-inline">
                                            <label class="form-control-static" title="วันที่คลาดว่าจะแล้วเสร็จ">Plan Finish : </label>
                                            &nbsp;
                                              <div class='input-group date'>
                                                  <asp:TextBox ID="txt_plan_finish" runat="server"
                                                      CssClass="form-control date"
                                                      Width="110px">
                                                  </asp:TextBox>
                                                  <span class="input-group-addon">
                                                      <span class="glyphicon glyphicon-calendar"></span>
                                                  </span>
                                              </div>
                                        </div>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                                            ControlToValidate="txt_plan_finish"
                                            ErrorMessage="please select plan finish."
                                            Display="Dynamic" ForeColor="Red"
                                            ValidationGroup="Acknowledge">
                                        </asp:RequiredFieldValidator>
                                    </div>
                                    <asp:HiddenField ID="hd_problem_no" runat="server" />
                                    <asp:Label ID="lb_test1" runat="server"></asp:Label>
                                </div>
                                <asp:GridView ID="gv3" runat="server" CssClass="table table-condensed table-bordered"
                                    EmptyDataText="No Data" AutoGenerateColumns="false">
                                    <HeaderStyle BackColor="#3073ac" ForeColor="White" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="Problem No.">
                                            <ItemTemplate>
                                                <asp:HiddenField runat="server" ID="hd_checkBy" Value='<%#Eval("check_by") %>' />
                                                <asp:HiddenField ID="hd_problem_id" runat="server" Value='<%#Eval("PM_problem_id") %>' />
                                                <asp:Label ID="lb_problem_no" runat="server" Text='<%#Eval("PM_problem_name")%>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Tool No.">
                                            <ItemTemplate>
                                                <asp:HiddenField ID="hd_tool_id" runat="server" Value='<%#Eval("tool_id") %>' />
                                                <asp:Label ID="lb_tool_no" runat="server" Text='<%#Eval("tool_no") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Model">
                                            <ItemTemplate>
                                                <asp:Label ID="lb_model_name" runat="server" Text='<%#Eval("model_name") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Problem Date">
                                            <ItemTemplate>
                                                <asp:Label ID="lb_problem_date" runat="server" Text='<%#Eval("check_date") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Resp. Group">
                                            <ItemTemplate>
                                                <asp:Label ID="lb_resp_group" runat="server" Text='<%#Eval("rep_group") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Ref.">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btn_ref" runat="server"
                                                    class="fa fa-file-pdf-o"
                                                    OnClick="btn_ref_Click">
                                                    <%--<img src="images/xls.png" width="25" />--%>
                                                </asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>

                            </div>
                            <div class="modal-footer">
                                <asp:LinkButton ID="btn_acknowledge_save" runat="server" CssClass="btn " BackColor="#078c10" ForeColor="White" OnClick="btn_acknowledge_save_Click" ValidationGroup="Acknowledge" OnClientClick=" return confirm('Are you sure?');">Acknowledge</asp:LinkButton>
                                <asp:LinkButton ID="btn_cancel" runat="server" CssClass="btn " BackColor="#ec4f43" ForeColor="White" OnClick="btn_cancel_Click" OnClientClick="return confirm('Are you sure?');">Cancel</asp:LinkButton>
                            </div>
                        </div>
                    </div>


                </ContentTemplate>
                <Triggers>
                    <asp:PostBackTrigger ControlID="txt_follow" />
                    <asp:PostBackTrigger ControlID="gv3" />
                    <asp:PostBackTrigger ControlID="btn_acknowledge_save" />
                </Triggers>
            </asp:UpdatePanel>


        </div>

        <%--modal Update Data for Close PM Problem --%>
        <div class="modal fade" id="modal_RequestClose" role="dialog" data-keyboard="false" aria-hidden="true" data-backdrop="static">
            <%--    <asp:UpdateProgress ID="UpdateProgress2" runat="server" AssociatedUpdatePanelID="UpdatePanel3">
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
            </asp:UpdateProgress>--%>
            <%--<asp:UpdatePanel ID="UpdatePanel22" runat="server">
                <ContentTemplate>--%>
            <div class="modal-dialog modal-sm4" style="width: 60% !important;">
                <div class="modal-content">
                    <div class="modal-header theme-bg-color1 theme-text-color2">
                        <button type="button" class="close" data-dismiss="modal" onclick="location.href=location.href">&times;</button>
                        <h4 class="modal-title"><i class="fa fa-pencil-square-o"></i>&nbsp;Update Data for Close PM Problem</h4>
                    </div>
                    <div class="modal-body">
                        <div class="grid-CheckClose_Modal1">
                            <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                                <ContentTemplate>
                                    <asp:Panel ID="Panel2" runat="server">

                                        <%--Data Input--%>
                                        <div class="grid-CheckClose_Modal2" style="">
                                            <%--PM Problem Sheet--%>
                                            <div class="grid-CheckClose_Modal3" style="align-items: self-end;">
                                                <label title="เอกสาร PM Problem"
                                                    style="text-align: end; font-size: small; margin-right: 5px;">
                                                    PM Problem Sheet :
                                                </label>
                                                <%--Link to PM Problem Sheet--%>
                                                <asp:LinkButton runat="server" ID="LinkButton17" OnClick="btn_detail_Click" Style="margin-left: 5px; vertical-align: baseline;">
                                                    <span class="fa fa-file-pdf-o fa-lg"></span>
                                                </asp:LinkButton>
                                            </div>
                                            <%--Action--%>
                                            <div class="grid-CheckClose_Modal3" style="align-items: self-end;">
                                                <label title="ประเภทการแก้ไขปัญหา" style="text-align: end; font-size: small; margin-right: 5px;">
                                                    Action :
                                                </label>
                                                <table>
                                                    <tr>
                                                        <th>
                                                            <asp:DropDownList ID="ddl_action_update" runat="server"
                                                                Font-Size="15px" DataSourceID="sql_action"
                                                                AppendDataBoundItems="true"
                                                                DataValueField="action_id" DataTextField="action_name"
                                                                CssClass="form-control ProgStatus1 h40"
                                                                Style="width: 90%">
                                                                <asp:ListItem Value="0">-</asp:ListItem>
                                                            </asp:DropDownList>
                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ControlToValidate="ddl_action_update" Display="Dynamic" ForeColor="Red" ValidationGroup="update_onplan"></asp:RequiredFieldValidator>

                                                        </th>
                                                        <th>
                                                            <asp:LinkButton runat="server"
                                                                ID="btn_ActionMeaning"
                                                                ToolTip="ความหมาย"
                                                                OnClick="btn_ActionMeaning_Click">
                                                                <span class="fa fa-info-circle fa-2x"></span>
                                                            </asp:LinkButton>
                                                        </th>
                                                    </tr>
                                                </table>
                                            </div>
                                            <%--Data Resp.Group , Resp.Name--%>
                                            <div class="grid-CheckClose_Modal4" style="align-items: self-end;">
                                                <label title="Group ที่รับผิดชอบแก้ไขปัญหา" style="text-align: end; font-size: small; margin-right: 5px;">
                                                    Resp.Group : 
                                                </label>
                                                <asp:DropDownList ID="ddl_resp_group_update"
                                                    OnSelectedIndexChanged="ddl_resp_group_update_SelectedIndexChanged"
                                                    DataSourceID="sql_resp_group_update"
                                                    DataTextField="group_name" AutoPostBack="true"
                                                    DataValueField="group_id"
                                                    runat="server"
                                                    CssClass="form-control">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="sql_resp_group_update" runat="server" ConnectionString="<%$ ConnectionStrings:jig_tool_systemConnectionString %>"
                                                    SelectCommand=" select* from user_master.dbo.eng_group_master where active = 1  and dept in(3,5)"></asp:SqlDataSource>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ControlToValidate="ddl_resp_group_update" Display="Dynamic" ForeColor="Red" ValidationGroup="update_onplan"></asp:RequiredFieldValidator>

                                                <label title="ผู้รับผิดชอบแก้ไขปัญหา" style="text-align: end; font-size: small; margin-right: 5px;">
                                                    Resp.Name :
                                                </label>
                                                <asp:DropDownList ID="ddl_resp_name_update"
                                                    runat="server"
                                                    CssClass="form-control">
                                                </asp:DropDownList>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ControlToValidate="ddl_resp_name_update" Display="Dynamic" ForeColor="Red" ValidationGroup="update_onplan"></asp:RequiredFieldValidator>

                                            </div>
                                            <%--Data Actual Finish--%>
                                            <div class="grid-CheckClose_Modal3" style="align-items: self-end;">
                                                <label title="วันที่แล้วเสร็จ" style="text-align: end; font-size: small; margin-right: 5px;">
                                                    Actual Finish :
                                                </label>
                                                <div class='input-group '>
                                                    <asp:TextBox ID="txt_actualFinish_update" runat="server"
                                                        CssClass="form-control date">
                                                    </asp:TextBox>
                                                    <span class="input-group-addon">
                                                        <span class="glyphicon glyphicon-calendar"></span>
                                                    </span>
                                                </div>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator11" runat="server" ControlToValidate="txt_actualFinish_update" Display="Dynamic" ForeColor="Red" ValidationGroup="update_onplan"></asp:RequiredFieldValidator>

                                            </div>
                                            <%--Data Actual Finish--%>
                                            <div class="grid-CheckClose_Modal3" style="align-items: self-end;">
                                                <label title="Data ที่ได้หลังจากแก้ไข" style="text-align: end; font-size: small; margin-right: 5px;">
                                                    Data Result :
                                                </label>
                                                <asp:TextBox runat="server" ID="txt_result_spec" CssClass="form-control"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator12" runat="server" ControlToValidate="txt_result_spec" Display="Dynamic" ForeColor="Red" ValidationGroup="update_onplan"></asp:RequiredFieldValidator>
                                            </div>
                                            <%--Data More Detail--%>
                                            <div class="grid-CheckClose_Modal3" style="align-items: self-end;">
                                                <label title="ข้อมูลการแก้ไขปัญหาเพิ่มเติม" style="align-self: center; text-align: end; font-size: small; margin-right: 5px;">
                                                    Detail เพิ่มเติม :
                                                </label>
                                                <asp:TextBox placeholder="Detail : "
                                                    ID="txt_result_detail" runat="server"
                                                    TextMode="MultiLine"
                                                    Height="100"
                                                    Width="100%"
                                                    Font-Size="Large"
                                                    BackColor="#FCF5D8">
                                                </asp:TextBox>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator13" runat="server" ControlToValidate="txt_result_detail" Display="Dynamic" ForeColor="Red" ValidationGroup="update_onplan"></asp:RequiredFieldValidator>

                                            </div>
                                        </div>

                                    </asp:Panel>
                                </ContentTemplate>
                                <Triggers>
                                </Triggers>
                            </asp:UpdatePanel>

                            <%--Picture Upload--%>
                            <div style="margin-left: 5px;">
                                <div class=" form-inline" id="div_Pic1" runat="server">
                                    <asp:Label runat="server" Text="Picture Action : "></asp:Label>
                                </div>
                                <div class="form-inline">
                                    <asp:FileUpload CssClass="form-control" runat="server" accept=".png,.jpg" ID="UploadPic1" AllowMultiple="true" Height="40px" />
                                </div>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator15" runat="server" ControlToValidate="UploadPic1" Display="Dynamic" ForeColor="Red" ValidationGroup="update_onplan"></asp:RequiredFieldValidator>
                                &nbsp;&nbsp;      
                                            <asp:Label runat="server" ID="test"></asp:Label>
                            </div>

                        </div>
                    </div>
                    <div class="modal-footer" style="text-align: center;">
                        <asp:LinkButton ID="btn_RequestClose" runat="server"
                            CssClass="btn fa fa-paper-plane"
                            BackColor="#078c10"
                            ForeColor="White"
                            Style="align-content: center;"
                            OnClick="btn_RequestClose_Click"
                            ValidationGroup="update_onplan">
                            Save
                        </asp:LinkButton>
                        <asp:LinkButton ID="LinkButton19" runat="server"
                            CssClass="btn " BackColor="#ec4f43"
                            ForeColor="White"
                            OnClick="btn_cancel_Click"
                            OnClientClick="return confirm('Are you sure?');">
                            Cancel
                        </asp:LinkButton>
                    </div>
                </div>
            </div>
            <%-- </ContentTemplate>
            </asp:UpdatePanel>--%>
        </div>

        <%--Modal ยืนยันสำหรับการปิดปัญหา [Confirm Close PM Problem] --%>
        <div class="modal fade" id="modal_ConfirmClose" role="dialog" style="height: 100%">
            <asp:UpdateProgress ID="UpdateProgress17" runat="server" AssociatedUpdatePanelID="UpdatePanel17">
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

            <asp:UpdatePanel ID="UpdatePanel17" runat="server">
                <ContentTemplate>
                    <div class="modal-dialog" style="width: 50% !important; margin-top: 5%;">
                        <div class="modal-content">
                            <div class="modal-header " style="background-color: #337ab7; color: white">
                                <button type="button" class="close" onclick="location.href=location.href" data-dismiss="modal" style="font-size: large !important">&times;</button>
                                <div>
                                    <h4 runat="server" id="h11">ยืนยันสำหรับการปิดปัญหา [Confirm Close PM Problem] </h4>
                                </div>
                            </div>
                            <div class="modal-body">
                                <%--Check Box : PM Problem Sheet--%>
                                <div class="grid-NewProblem_Modal1">
                                    <asp:CheckBox ID="cb_sheet" runat="server"
                                        CssClass="ChkBoxClass"
                                        AutoPostBack="true"></asp:CheckBox>
                                    <%--<asp:CustomValidator    ID="CustomValidator" runat="server" ControlId="cb_sheet"   ForeColor="Red" ValidationGroup="cb_send_for_Check"></asp:CustomValidator>--%>
                                    <div style="margin-left: 5px;">
                                        <label style="vertical-align: bottom;">PM Problem Sheet :</label>
                                        <%--Link to PM Problem Sheet--%>
                                        <asp:LinkButton runat="server" ID="LinkButton18" OnClick="btn_detail_Click" Style="margin-left: 5px; vertical-align: baseline;">
                                            <span class="fa fa-file-pdf-o fa-lg"></span>
                                        </asp:LinkButton>
                                    </div>
                                </div>
                                <%--Check Box : Action of Problem--%>
                                <div class="grid-NewProblem_Modal2">
                                    <asp:CheckBox ID="cb_action" runat="server"
                                        CssClass="ChkBoxClass"
                                        AutoPostBack="true"></asp:CheckBox>
                                    <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator17" runat="server" ControlToValidate="cb_action" Display="Dynamic" ForeColor="Red" ValidationGroup="cb_send_for_Check"></asp:RequiredFieldValidator>--%>

                                    <div style="margin-left: 5px;">
                                        <label style="vertical-align: bottom;">Action :</label>
                                    </div>
                                    <asp:TextBox ID="txt_action" runat="server"
                                        CssClass="form-control" Enabled="false"
                                        Font-Size="Medium"
                                        BackColor="#FCF5D8"
                                        Style="width: 60%; height: 90% !important; margin-left: -15px; align-self: center;">
                                    </asp:TextBox>
                                </div>
                                <%--Check Box : Actual Finish--%>
                                <div class="grid-NewProblem_Modal2">
                                    <asp:CheckBox ID="cb_actual" runat="server"
                                        CssClass="ChkBoxClass"
                                        AutoPostBack="true"></asp:CheckBox>
                                    <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator18" runat="server" ControlToValidate="cb_actual" Display="Dynamic" ForeColor="Red" ValidationGroup="cb_send_for_Check"></asp:RequiredFieldValidator>--%>

                                    <div style="margin-left: 5px;">
                                        <label style="vertical-align: bottom;">Actual Finish :</label>
                                    </div>
                                    <asp:TextBox ID="txt_actual" runat="server"
                                        CssClass="form-control h40"
                                        Font-Size="Medium" Enabled="false"
                                        BackColor="#FCF5D8"
                                        Style="width: 60%; height: 90% !important; margin-left: -15px; align-self: center;">
                                    </asp:TextBox>
                                </div>
                                <%--Check Box : Data Result--%>
                                <div class="grid-NewProblem_Modal2">
                                    <asp:CheckBox ID="cb_result" runat="server"
                                        CssClass="ChkBoxClass"
                                        AutoPostBack="true"></asp:CheckBox>
                                    <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator25" runat="server" ControlToValidate="cb_result" Display="Dynamic" ForeColor="Red" ValidationGroup="cb_send_for_Check"></asp:RequiredFieldValidator>--%>

                                    <div style="margin-left: 5px;">
                                        <label style="vertical-align: bottom;">Data Result :</label>
                                    </div>
                                    <asp:TextBox ID="txt_result" runat="server"
                                        CssClass="form-control h40" Enabled="false"
                                        Font-Size="Medium"
                                        BackColor="#FCF5D8"
                                        Style="width: 60%; height: 90% !important; margin-left: -15px; align-self: center;">
                                    </asp:TextBox>
                                </div>
                                <%--Check Box : Action more Detail--%>
                                <div class="grid-NewProblem_Modal4">
                                    <asp:CheckBox ID="cb_detail" runat="server"
                                        CssClass="ChkBoxClass"
                                        AutoPostBack="true"></asp:CheckBox>
                                    <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator30" runat="server" ControlToValidate="cb_detail" Display="Dynamic" ForeColor="Red" ValidationGroup="cb_send_for_Check"></asp:RequiredFieldValidator>--%>

                                    <div style="margin-left: 5px;">
                                        <label style="vertical-align: bottom;">Detail :</label>
                                    </div>
                                    <asp:TextBox ID="txt_detail2" runat="server"
                                        CssClass="form-control h40" Enabled="false"
                                        TextMode="MultiLine"
                                        Font-Size="Medium"
                                        BackColor="#FCF5D8"
                                        Style="width: 95%; height: 90% !important; margin-left: -15px; align-self: center;">
                                    </asp:TextBox>
                                </div>
                                <%--Check Box : Confirm Close Problem--%>
                                <div class="grid-NewProblem_Modal1">
                                    <asp:CheckBox ID="cb_confirm" runat="server"
                                        CssClass="ChkBoxClass"
                                        AutoPostBack="true"></asp:CheckBox>
                                    <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator31" runat="server" ControlToValidate="cb_confirm" Display="Dynamic" ForeColor="Red" ValidationGroup="cb_send_for_Check"></asp:RequiredFieldValidator>--%>

                                    <div style="margin-left: 5px;">
                                        <label style="vertical-align: bottom;">Confirm Close PM Problem</label>
                                    </div>
                                </div>

                            </div>
                            <div class="modal-footer" style="text-align: center;">
                                <asp:LinkButton ID="btn_send_mail" runat="server"
                                    CssClass="btn fa fa-paper-plane"
                                    BackColor="#078c10"
                                    ForeColor="White" ValidationGroup="cb_send_for_Check"
                                    Style="align-content: center;" OnClick="btn_send_mail_Click"
                                    OnClientClick="return confirm('Are you sure?');">
                                    Send Mail
                                </asp:LinkButton>
                                <asp:LinkButton ID="LinkButton32" runat="server"
                                    CssClass="btn " BackColor="#ec4f43"
                                    ForeColor="White"
                                    OnClick="btn_cancel_Click"
                                    OnClientClick="return confirm('Are you sure?');">
                                    Cancel
                                </asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
                <Triggers>
                </Triggers>
            </asp:UpdatePanel>
        </div>

        <%--Modal Tool Owner[J3] Check --%>
        <div class="modal fade bd-example-modal-lg" id="Modal_Tool_Owner_Check" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
            <asp:UpdateProgress ID="UpdateProgress3" runat="server" AssociatedUpdatePanelID="UP_MD">
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
            <asp:UpdatePanel ID="UP_MD" runat="server">
                <ContentTemplate>
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <span style="font-size: 18px; font-weight: bold;">
                                    <i class="glyphicon glyphicon-send"></i>&nbsp; Problem Report: Send for Check
                                </span>
                            </div>
                            <div class="modal-body">


                                <asp:GridView ID="md_gv" runat="server" CssClass="table table-bordered table-condensed"
                                    EmptyDataText="No Data" AutoGenerateColumns="false" Width="100%">
                                    <EmptyDataRowStyle CssClass="danger text-danger jumbotron" />
                                    <HeaderStyle CssClass=" theme-bg-color1 theme-text-color2" ForeColor="White" Wrap="false" HorizontalAlign="Center" Font-Size="Small" />
                                    <RowStyle HorizontalAlign="Center" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="Send for Check">
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chb_send" runat="server" CssClass="custom-checkbox" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Problem No.">
                                            <ItemTemplate>
                                                <asp:HiddenField ID="HiddenField1" runat="server" Value='<%#Eval("PM_problem_id") %>' />
                                                <asp:Label ID="Label2" runat="server" Text='<%#Eval("PM_problem_name") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Tool No.">
                                            <ItemTemplate>
                                                <asp:Label ID="Label3" runat="server" Text='<%#Eval("tool_no") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Ref.">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="LinkButton2" runat="server" CssClass="fa fa-file-pdf-o" OnClick="btn_ref_Click">
                                                </asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                            <div class="modal-footer">
                                <asp:LinkButton ID="btn_Tool_Owner_save" runat="server" CssClass="btn btn-success" OnClick="btn_Tool_Owner_save_Click">
                                    <i class="glyphicon glyphicon-send"></i>&nbsp Save
                                </asp:LinkButton>
                                <asp:LinkButton ID="LinkButton3" runat="server" CssClass="btn btn-danger" OnClientClick="return confirm('Are you sure?');">
                                    <i class="glyphicon glyphicon-floppy-remove"></i>&nbsp Cancel
                                </asp:LinkButton>
                            </div>
                        </div>
                    </div>

                </ContentTemplate>
                <Triggers>
                    <asp:PostBackTrigger ControlID="md_gv" />
                    <asp:PostBackTrigger ControlID="LinkButton3" />
                    <asp:PostBackTrigger ControlID="btn_Tool_Owner_save" />
                </Triggers>
            </asp:UpdatePanel>

        </div>

        <%--Modal ENG4[J3] Check --%>
        <div class="modal fade bd-example-modal-lg" id="Modal_ENG4_J3_Check" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
            <asp:UpdateProgress ID="UpdateProgress5" runat="server" AssociatedUpdatePanelID="UpdatePanel5">
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

            <asp:UpdatePanel ID="UpdatePanel5" runat="server">
                <ContentTemplate>
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <span style="font-size: 18px; font-weight: bold;">
                                    <i class="glyphicon glyphicon-send"></i>&nbsp; Problem Report: Send for Check
                                </span>
                            </div>
                            <div class="modal-body">

                                <asp:GridView ID="gv_ENG4_J3" runat="server" CssClass="table table-bordered table-condensed"
                                    EmptyDataText="No Data" AutoGenerateColumns="false" Width="100%">
                                    <EmptyDataRowStyle CssClass="danger text-danger jumbotron" />
                                    <HeaderStyle CssClass=" theme-bg-color1 theme-text-color2" ForeColor="White" Wrap="false" HorizontalAlign="Center" Font-Size="Small" />
                                    <RowStyle HorizontalAlign="Center" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="Send for Check">
                                            <ItemTemplate>
                                                <asp:CheckBox ID="cb_ENG4_send" runat="server" CssClass="custom-checkbox" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Problem No.">
                                            <ItemTemplate>
                                                <asp:HiddenField ID="HiddenField2" runat="server" Value='<%#Eval("PM_problem_id") %>' />
                                                <asp:Label ID="Label4" runat="server" Text='<%#Eval("PM_problem_name") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Tool No.">
                                            <ItemTemplate>
                                                <asp:Label ID="Label5" runat="server" Text='<%#Eval("tool_no") %>'></asp:Label>
                                                <asp:HiddenField ID="hd_resp_group_id" runat="server" Value='<%#Eval("group_resp") %>' />
                                                <asp:HiddenField ID="hd_resp_group_name" runat="server" Value='<%#Eval("rep_group") %>' />
                                                <asp:HiddenField ID="hd_resp_name" runat="server" Value='<%#Eval("PIC") %>' />
                                                <asp:HiddenField ID="hd_owner_group" runat="server" Value='<%#Eval("item_group")%>' />
                                                <asp:HiddenField ID="hd_owner_group_id" runat="server" Value='<%#Eval("owner_group_id")%>' />
                                                <asp:HiddenField ID="hd_item" runat="server" Value='<%#Eval("count_item") %>' />
                                                <asp:HiddenField ID="hd_GroupCheck" runat="server" Value='<%#Eval("groupN_check") %>' />
                                                <asp:HiddenField ID="HiddenField3" runat="server" Value='<%#Eval("check_by") %>' />
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Ref.">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="LinkButton5" runat="server" CssClass="fa fa-file-pdf-o" OnClick="btn_ref_Click">
                                                </asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                            <div class="modal-footer">
                                <asp:LinkButton ID="btn_save_ENG4_J3" runat="server" CssClass="btn btn-success" OnClick="btn_save_ENG4_J3_Click">
                                    <i class="glyphicon glyphicon-send"></i>&nbsp Save
                                </asp:LinkButton>
                                <asp:LinkButton ID="LinkButton7" runat="server" CssClass="btn btn-danger" OnClientClick="return location.href=location.href;">
                                    <i class="glyphicon glyphicon-floppy-remove"></i>&nbsp Cancel
                                </asp:LinkButton>
                            </div>
                        </div>
                    </div>

                </ContentTemplate>
                <Triggers>
                    <asp:PostBackTrigger ControlID="md_gv" />
                    <asp:PostBackTrigger ControlID="btn_save_ENG4_J3" />
                    <asp:PostBackTrigger ControlID="btn_cancel" />
                    <%--<asp:PostBackTrigger ControlID="ddl_tool_owner" />--%>
                </Triggers>
            </asp:UpdatePanel>

        </div>

        <%--Modal ENG4[Mgr] Check --%>
        <div class="modal fade bd-example-modal-lg" id="Modal_ENG4_Mgr_Check" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
            <asp:UpdateProgress ID="UpdateProgress18" runat="server" AssociatedUpdatePanelID="UpdatePanel6">
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

            <asp:UpdatePanel ID="UpdatePanel6" runat="server">
                <ContentTemplate>
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <span style="font-size: 18px; font-weight: bold;">
                                    <i class="glyphicon glyphicon-send"></i>&nbsp; Problem Report: Send for Check
                                </span>
                            </div>
                            <div class="modal-body">

                                <asp:GridView ID="gv_ENG4_Mgr" runat="server" CssClass="table table-bordered table-condensed"
                                    EmptyDataText="No Data" AutoGenerateColumns="false" Width="100%">
                                    <EmptyDataRowStyle CssClass="danger text-danger jumbotron" />
                                    <HeaderStyle CssClass=" theme-bg-color1 theme-text-color2" ForeColor="White" Wrap="false" HorizontalAlign="Center" Font-Size="Small" />
                                    <RowStyle HorizontalAlign="Center" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="Send for Check">
                                            <ItemTemplate>
                                                <asp:CheckBox ID="cb_Mgr_send" runat="server" CssClass="custom-checkbox" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Problem No.">
                                            <ItemTemplate>
                                                <asp:HiddenField ID="HiddenField4" runat="server" Value='<%#Eval("PM_problem_id") %>' />
                                                <asp:Label ID="Label6" runat="server" Text='<%#Eval("PM_problem_name") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Tool No.">
                                            <ItemTemplate>
                                                <asp:Label ID="Label7" runat="server" Text='<%#Eval("tool_no") %>'></asp:Label>
                                                <asp:HiddenField ID="HiddenField5" runat="server" Value='<%#Eval("group_resp") %>' />
                                                <asp:HiddenField ID="HiddenField6" runat="server" Value='<%#Eval("rep_group") %>' />
                                                <asp:HiddenField ID="HiddenField7" runat="server" Value='<%#Eval("PIC") %>' />
                                                <asp:HiddenField ID="HiddenField8" runat="server" Value='<%#Eval("item_group")%>' />
                                                <asp:HiddenField ID="HiddenField9" runat="server" Value='<%#Eval("owner_group_id")%>' />
                                                <asp:HiddenField ID="HiddenField10" runat="server" Value='<%#Eval("count_item") %>' />
                                                <asp:HiddenField ID="HiddenField11" runat="server" Value='<%#Eval("groupN_check") %>' />
                                                <asp:HiddenField ID="HiddenField12" runat="server" Value='<%#Eval("check_by") %>' />
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Ref.">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="LinkButton11" runat="server" CssClass="btn" OnClick="btn_ref_Click">
                                                    <img src="images/xls.png" width="25" />
                                                </asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                            <div class="modal-footer">
                                <asp:LinkButton ID="btn_save_ENG4_Mgr" runat="server" CssClass="btn btn-success" OnClick="btn_save_ENG4_Mgr_Click">
                                    <i class="glyphicon glyphicon-send"></i>&nbsp Save
                                </asp:LinkButton>
                                <asp:LinkButton ID="LinkButton15" runat="server" CssClass="btn btn-danger" OnClientClick="return location.href=location.href;">
                                    <i class="glyphicon glyphicon-floppy-remove"></i>&nbsp Cancel
                                </asp:LinkButton>
                            </div>
                        </div>
                    </div>

                </ContentTemplate>
                <Triggers>
                    <asp:PostBackTrigger ControlID="gv_ENG4_Mgr" />
                    <asp:PostBackTrigger ControlID="btn_save_ENG4_Mgr" />
                    <asp:PostBackTrigger ControlID="LinkButton15" />
                </Triggers>
            </asp:UpdatePanel>

        </div>

        <%--<<<<<<<<<<< END >>>>>>>>>>>--%>
        <%--<<<<<<<<<<< Modal Update Data Promblem >>>>>>>>>>>--%>

        <%--Modal Update Action--%>
        <div class="modal fade" id="modal_UpdateAction" role="dialog" style="height: 100%">
            <asp:UpdateProgress ID="UpdateProgress7" runat="server" AssociatedUpdatePanelID="UpdatePanel7">
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

            <asp:UpdatePanel ID="UpdatePanel7" runat="server">
                <ContentTemplate>
                    <div class="modal-dialog" style="width: 30% !important; margin-top: 5%;">
                        <div class="modal-content">
                            <div class="modal-header ">
                                <button type="button" class="close" data-dismiss="modal" onclick="location.href=location.href" style="font-size: large !important">&times;</button>
                                <div>
                                    <h4 runat="server" id="h1">Update Action </h4>
                                </div>
                            </div>
                            <div class="modal-body">
                                <div runat="server" id="Div1">
                                    <div class="grid-Update_Modal1">
                                        <a style="font-size: larger; font-weight: bold; align-content: center; text-align: end;">Old :
                                        </a>
                                        <asp:TextBox ID="txt_ActionCurrent" runat="server"
                                            Font-Size="15px" Enabled="false"
                                            CssClass="form-control  h40">
                                        </asp:TextBox>

                                    </div>

                                    <div class="grid-Update_Modal1">
                                        <a style="font-size: larger; font-weight: bold; align-content: center; text-align: end;">New :
                                        </a>
                                        <asp:DropDownList ID="ddl_ActionNew" runat="server"
                                            Font-Size="15px" DataSourceID="sql_action"
                                            AppendDataBoundItems="true"
                                            DataValueField="action_id" DataTextField="action_name"
                                            CssClass="form-control ProgStatus1 h40">
                                            <asp:ListItem Value="">-</asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator27" runat="server" ControlToValidate="ddl_ActionNew" Display="Dynamic" ForeColor="Red" ValidationGroup="update_Action"></asp:RequiredFieldValidator>

                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:LinkButton ID="btn_save_UpdateAction" runat="server" CssClass="btn " BackColor="#078c10" ForeColor="White" OnClick="btn_save_UpdateAction_Click" ValidationGroup="update_Action" OnClientClick="WebForm_OnSubmit(); return confirm('Are you sure?');">Save</asp:LinkButton>
                                <asp:LinkButton ID="LinkButton10" runat="server" CssClass="btn " BackColor="#ec4f43" ForeColor="White" OnClick="btn_cancel_Click" OnClientClick="return confirm('Are you sure?');">Cancel</asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
                <Triggers>
                </Triggers>
            </asp:UpdatePanel>
        </div>

        <%--Modal Update Type of Problem--%>
        <div class="modal fade" id="modal_UpdateTypeproblem" role="dialog" style="height: 100%">
            <asp:UpdateProgress ID="UpdateProgress8" runat="server" AssociatedUpdatePanelID="UpdatePanel8">
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

            <asp:UpdatePanel ID="UpdatePanel8" runat="server">
                <ContentTemplate>
                    <div class="modal-dialog" style="width: 30% !important; margin-top: 5%;">
                        <div class="modal-content">
                            <div class="modal-header ">
                                <button type="button" class="close" data-dismiss="modal" onclick="location.href=location.href" style="font-size: large !important">&times;</button>
                                <div>
                                    <h4 runat="server" id="h2">Update Type of Problem </h4>
                                </div>
                            </div>
                            <div class="modal-body">
                                <div runat="server" id="Div2">
                                    <div class="grid-Update_Modal1">
                                        <a style="font-size: larger; font-weight: bold; align-content: center; text-align: end;">Old :
                                        </a>
                                        <asp:TextBox runat="server" Font-Size="15px"
                                            ID="txt_TypeproblemCurrent" Enabled="false"
                                            CssClass="form-control  h40">
                                        </asp:TextBox>
                                    </div>
                                    <div class="grid-Update_Modal1">
                                        <a style="font-size: larger; font-weight: bold; align-content: center; text-align: end;">New :
                                        </a>
                                        <asp:DropDownList runat="server" Font-Size="15px"
                                            ID="ddl_TypeproblemNew"
                                            DataSourceID="sql_type1"
                                            DataTextField="SYM_NAME"
                                            DataValueField="symbol_id"
                                            CssClass="form-control ProgStatus2 h40" AppendDataBoundItems="true">
                                            <asp:ListItem Value="">-</asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator28" runat="server" ControlToValidate="ddl_TypeproblemNew" Display="Dynamic" ForeColor="Red" ValidationGroup="update_TypeproblemNew"></asp:RequiredFieldValidator>

                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:LinkButton ID="btn_save_UpdateTypeproblem" runat="server" CssClass="btn " BackColor="#078c10" ForeColor="White" OnClick="btn_save_UpdateTypeproblem_Click" ValidationGroup="update_TypeproblemNew" OnClientClick="WebForm_OnSubmit(); return confirm('Are you sure?');">Save</asp:LinkButton>
                                <asp:LinkButton ID="LinkButton12" runat="server" CssClass="btn " BackColor="#ec4f43" ForeColor="White" OnClick="btn_cancel_Click" OnClientClick="return confirm('Are you sure?');">Cancel</asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
                <Triggers>
                </Triggers>
            </asp:UpdatePanel>
        </div>

        <%--Modal Update Problem Rank--%>
        <div class="modal fade" id="modal_UpdateProblemRank" role="dialog" style="height: 100%">
            <asp:UpdateProgress ID="UpdateProgress9" runat="server" AssociatedUpdatePanelID="UpdatePanel9">
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

            <asp:UpdatePanel ID="UpdatePanel9" runat="server">
                <ContentTemplate>
                    <div class="modal-dialog" style="width: 30% !important; margin-top: 5%;">
                        <div class="modal-content">
                            <div class="modal-header ">
                                <button type="button" class="close" data-dismiss="modal" onclick="location.href=location.href" style="font-size: large !important">&times;</button>
                                <div>
                                    <h4 runat="server" id="h3">Update Problem Rank </h4>
                                </div>
                            </div>
                            <div class="modal-body">
                                <div runat="server" id="Div3">
                                    <div class="grid-Update_Modal2">
                                        <a style="font-size: larger; font-weight: bold;">Old
                                        </a>
                                        <a style="font-size: larger; font-weight: bold;">New
                                        </a>
                                        <asp:TextBox ID="txt_ProblemRankCurrent" runat="server"
                                            CssClass="form-control h100" BackColor="#ff9999" Enabled="false" Font-Size="58px">
                                        </asp:TextBox>

                                        <asp:DropDownList ID="ddl_ProblemRankNew" runat="server" CssClass="form-control h100" BackColor="#ff9999" Font-Size="58px" onChange="auto_planFinist(this)">
                                            <asp:ListItem Value="">-</asp:ListItem>
                                            <asp:ListItem Value="A">A</asp:ListItem>
                                            <asp:ListItem Value="B">B</asp:ListItem>
                                            <asp:ListItem Value="C">C</asp:ListItem>
                                        </asp:DropDownList>

                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator29" runat="server" ControlToValidate="ddl_ProblemRankNew" Display="Dynamic" ForeColor="Red" ValidationGroup="update_ProblemRankNew"></asp:RequiredFieldValidator>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:LinkButton ID="btn_save_UpdateProblemRank" runat="server" CssClass="btn " BackColor="#078c10" ForeColor="White" ValidationGroup="update_ProblemRankNew" OnClick="btn_save_UpdateProblemRank_Click" OnClientClick="WebForm_OnSubmit(); return confirm('Are you sure?');">Save</asp:LinkButton>
                                <asp:LinkButton ID="LinkButton14" runat="server" CssClass="btn " BackColor="#ec4f43" ForeColor="White" OnClick="btn_cancel_Click" OnClientClick="return confirm('Are you sure?');">Cancel</asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
                <Triggers>
                </Triggers>
            </asp:UpdatePanel>

        </div>

        <%--Modal Type , Issue Name , Problem Date , Shift--%>
        <div class="modal fade" id="modal_Update_Type_Issue" role="dialog" style="height: 100%">
            <asp:UpdateProgress ID="UpdateProgress10" runat="server" AssociatedUpdatePanelID="UpdatePanel10">
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

            <asp:UpdatePanel ID="UpdatePanel10" runat="server">
                <ContentTemplate>
                    <div class="modal-dialog" style="width: 40% !important; margin-top: 5%;">
                        <div class="modal-content">
                            <div class="modal-header ">
                                <button type="button" class="close" onclick="location.href=location.href" data-dismiss="modal" style="font-size: large !important">&times;</button>
                                <div>
                                    <h4 runat="server" id="h4">Update Type,Problem Date,Shift </h4>
                                </div>
                            </div>
                            <div class="modal-body">
                                <div runat="server" id="Div4">
                                    <%--Head Topic Old/New--%>
                                    <div class="grid-Update_Modal3">
                                        <div></div>
                                        <div style="align-self: self-end; text-align: center;">Old</div>
                                        <div></div>
                                        <div style="align-self: self-end; text-align: center;">New</div>
                                    </div>
                                    <%--Type--%>
                                    <div class="grid-Update_Modal3">
                                        <div style="text-align: right">Type :</div>
                                        <asp:TextBox ID="txt_type_old" runat="server"
                                            CssClass="form-control"
                                            Style="width: 100%;" Enabled="false">
                                        </asp:TextBox>

                                        <div class="glyphicon glyphicon-circle-arrow-right" style="text-align: center;"></div>
                                        <asp:DropDownList ID="ddl_type_new" runat="server" CssClass="form-control"
                                            Style="width: 100%;"
                                            AppendDataBoundItems="true"
                                            DataSourceID="sql_ddl_type"
                                            DataTextField="pm_docName"
                                            DataValueField="pm_docID">
                                            <asp:ListItem Value="">-selected-</asp:ListItem>
                                        </asp:DropDownList>
                                        <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator26" runat="server" ControlToValidate="ddl_type_new" Display="Dynamic" ForeColor="Red" ValidationGroup="update_Type_Issue"></asp:RequiredFieldValidator>--%>
                                    </div>

                                    <%--Problem Date--%>
                                    <div class="grid-Update_Modal3">
                                        <div style="text-align: right">Problem Date :</div>
                                        <asp:TextBox ID="txt_problemDate_old" runat="server" CssClass="form-control disabled"
                                            Width="100%" Enabled="false">
                                        </asp:TextBox>
                                        <div class="glyphicon glyphicon-circle-arrow-right" style="text-align: center;"></div>

                                        <div class='input-group date'>
                                            <asp:TextBox ID="txt_problemDate_new" runat="server" CssClass="form-control disabled" Width="100%">
                                            </asp:TextBox>
                                            <span class="input-group-addon">
                                                <span class="glyphicon glyphicon-calendar"></span>
                                            </span>
                                        </div>
                                        <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator24" runat="server" ControlToValidate="txt_problemDate_new" Display="Dynamic" ForeColor="Red" ValidationGroup="update_Type_Issue"></asp:RequiredFieldValidator>--%>
                                    </div>
                                    <%--Shift--%>
                                    <div class="grid-Update_Modal3">
                                        <div style="text-align: right">Shift :</div>
                                        <asp:TextBox ID="txt_shift_old" runat="server" CssClass="form-control disabled"
                                            Width="100%" Enabled="false">
                                        </asp:TextBox>
                                        <div class="glyphicon glyphicon-circle-arrow-right" style="text-align: center;"></div>
                                        <asp:DropDownList ID="ddl_shift_new" runat="server" CssClass="form-control disabled"
                                            Width="100%">
                                            <asp:ListItem Value="">-</asp:ListItem>
                                            <asp:ListItem Value="1">Day</asp:ListItem>
                                            <asp:ListItem Value="2">Night</asp:ListItem>
                                        </asp:DropDownList>
                                        <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator23" runat="server" ControlToValidate="ddl_shift_new" Display="Dynamic" ForeColor="Red" ValidationGroup="update_Type_Issue"></asp:RequiredFieldValidator>--%>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:LinkButton ID="btn_save_Type_Issue" runat="server" CssClass="btn " BackColor="#078c10" ForeColor="White" OnClick="btn_save_Type_Issue_Click" ValidationGroup="update_Type_Issue" OnClientClick="WebForm_OnSubmit(); return confirm('Are you sure?');">Save</asp:LinkButton>
                                <asp:LinkButton ID="LinkButton16" runat="server" CssClass="btn " BackColor="#ec4f43" ForeColor="White" OnClick="btn_cancel_Click" OnClientClick="return confirm('Are you sure?');">Cancel</asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
                <Triggers>
                </Triggers>
            </asp:UpdatePanel>
        </div>

        <%--Modal Resp.Name , Resp.Group--%>
        <div class="modal fade" id="modal_Update_Resp" role="dialog" style="height: 100%">
            <asp:UpdateProgress ID="UpdateProgress11" runat="server" AssociatedUpdatePanelID="UpdatePanel11">
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

            <asp:UpdatePanel ID="UpdatePanel11" runat="server">
                <ContentTemplate>
                    <div class="modal-dialog" style="width: 40% !important; margin-top: 5%;">
                        <div class="modal-content">
                            <div class="modal-header ">
                                <button type="button" class="close" data-dismiss="modal" onclick="location.href=location.href" style="font-size: large !important">&times;</button>
                                <div>
                                    <h4 runat="server" id="h5">Update Resp.Name,Resp.Group </h4>
                                </div>
                            </div>
                            <div class="modal-body">
                                <div runat="server" id="Div5">
                                    <%--Head Topic Old/New--%>
                                    <div class="grid-Update_Modal3">
                                        <div></div>
                                        <div style="align-self: self-end; text-align: center;">Old</div>
                                        <div></div>
                                        <div style="align-self: self-end; text-align: center;">New</div>
                                    </div>
                                    <%--Resp.Group--%>
                                    <div class="grid-Update_Modal3">
                                        <div style="text-align: right">Resp.Group :</div>
                                        <asp:TextBox ID="txt_resp_group_old"
                                            runat="server" Enabled="false"
                                            CssClass="form-control">
                                        </asp:TextBox>
                                        <div class="glyphicon glyphicon-circle-arrow-right" style="text-align: center;"></div>

                                        <asp:DropDownList ID="ddl_resp_group_new" AutoPostBack="true"
                                            OnSelectedIndexChanged="ddl_resp_group_new_SelectedIndexChanged"
                                            DataSourceID="Sql_resp_group_new"
                                            DataValueField="group_id"
                                            DataTextField="group_name" AppendDataBoundItems="true"
                                            runat="server"
                                            CssClass="form-control">
                                            <asp:ListItem Value="">-</asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:SqlDataSource ID="Sql_resp_group_new" runat="server" ConnectionString="<%$ ConnectionStrings:jig_tool_systemConnectionString %>"
                                            SelectCommand=" select* from user_master.dbo.eng_group_master where active = 1  and dept in(3,5)"></asp:SqlDataSource>

                                        <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator21" runat="server" ControlToValidate="ddl_resp_group_new" Display="Dynamic" ForeColor="Red" ValidationGroup="update_Resp"></asp:RequiredFieldValidator>--%>
                                    </div>
                                    <%--Resp.Name--%>
                                    <div class="grid-Update_Modal3">
                                        <div style="text-align: right">Resp.Name :</div>
                                        <asp:TextBox ID="txt_resp_name_old" runat="server"
                                            CssClass="form-control" Enabled="false"
                                            Width="100%">
                                        </asp:TextBox>
                                        <div class="glyphicon glyphicon-circle-arrow-right" style="text-align: center;"></div>
                                        <asp:DropDownList ID="ddl_resp_name_new" runat="server"
                                            CssClass="form-control"
                                            Width="100%">
                                        </asp:DropDownList>
                                        <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator22" runat="server" ControlToValidate="ddl_resp_name_new" Display="Dynamic" ForeColor="Red" ValidationGroup="update_Resp"></asp:RequiredFieldValidator>--%>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:LinkButton ID="btn_save_Update_Resp" runat="server" CssClass="btn " BackColor="#078c10" ForeColor="White" ValidationGroup="update_Resp" OnClick="btn_save_Update_Resp_Click" OnClientClick="WebForm_OnSubmit(); return confirm('Are you sure?');">Save</asp:LinkButton>
                                <asp:LinkButton ID="LinkButton4" runat="server" CssClass="btn " BackColor="#ec4f43" ForeColor="White" OnClick="btn_cancel_Click" OnClientClick="return confirm('Are you sure?');">Cancel</asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
                <Triggers>
                </Triggers>
            </asp:UpdatePanel>
        </div>

        <%--Modal Follow Up date , Plan Finish , Actual Finish--%>
        <div class="modal fade" id="modal_Update_FollowUp_date" role="dialog" style="height: 100%">
            <asp:UpdateProgress ID="UpdateProgress12" runat="server" AssociatedUpdatePanelID="UpdatePanel12">
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

            <asp:UpdatePanel ID="UpdatePanel12" runat="server">
                <ContentTemplate>
                    <div class="modal-dialog" style="width: 42% !important; margin-top: 5%;">
                        <div class="modal-content">
                            <div class="modal-header ">
                                <button type="button" class="close" data-dismiss="modal" onclick="location.href=location.href" style="font-size: large !important">&times;</button>
                                <div>
                                    <h4 runat="server" id="h6">Update Follow Up date , Plan Finish , Actual Finish </h4>
                                </div>
                            </div>
                            <div class="modal-body">
                                <div runat="server" id="Div6">
                                    <%--Head Topic Old/New--%>
                                    <div class="grid-Update_Modal3">
                                        <div></div>
                                        <div style="align-self: self-end; text-align: center;">Old</div>
                                        <div></div>
                                        <div style="align-self: self-end; text-align: center;">New</div>
                                    </div>
                                    <%--Follow Up Date--%>
                                    <div class="grid-Update_Modal3">
                                        <div style="text-align: right">Follow Up Date :</div>
                                        <div class='input-group date'>
                                            <asp:TextBox ID="txt_followDate_old" runat="server"
                                                CssClass="form-control date" Enabled="false"
                                                Width="100%">
                                            </asp:TextBox>
                                            <span class="input-group-addon">
                                                <span class="glyphicon glyphicon-calendar"></span>
                                            </span>
                                        </div>

                                        <div class="glyphicon glyphicon-circle-arrow-right" style="text-align: center;"></div>
                                        <div class='input-group date'>
                                            <asp:TextBox ID="txt_followDate_new" runat="server"
                                                CssClass="form-control date"
                                                Width="100%">
                                            </asp:TextBox>
                                            <span class="input-group-addon">
                                                <span class="glyphicon glyphicon-calendar"></span>
                                            </span>
                                        </div>
                                        <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator16" runat="server" ControlToValidate="txt_followDate_new" Display="Dynamic" ForeColor="Red" ValidationGroup="update_followUp_date"></asp:RequiredFieldValidator>--%>
                                    </div>
                                    <%--Plan Finish--%>
                                    <div class="grid-Update_Modal3">
                                        <div style="text-align: right">Plan finish :</div>
                                        <div class='input-group date'>
                                            <asp:TextBox ID="txt_planFinish_old" runat="server"
                                                CssClass="form-control date" Enabled="false"
                                                Width="100%">
                                            </asp:TextBox>
                                            <span class="input-group-addon">
                                                <span class="glyphicon glyphicon-calendar"></span>
                                            </span>
                                        </div>
                                        <div class="glyphicon glyphicon-circle-arrow-right" style="text-align: center;"></div>
                                        <div class='input-group date'>
                                            <asp:TextBox ID="txt_planFinish_new" runat="server"
                                                CssClass="form-control date"
                                                Width="100%">
                                            </asp:TextBox>
                                            <span class="input-group-addon">
                                                <span class="glyphicon glyphicon-calendar"></span>
                                            </span>
                                        </div>
                                        <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator17" runat="server" ControlToValidate="txt_planFinish_new" Display="Dynamic" ForeColor="Red" ValidationGroup="update_followUp_date"></asp:RequiredFieldValidator>--%>
                                    </div>
                                    <%--Actual Finish--%>
                                    <div class="grid-Update_Modal3">
                                        <div style="text-align: right">Actual finish :</div>
                                        <div class='input-group date'>
                                            <asp:TextBox ID="txt_actualFinish_old" runat="server"
                                                Enabled="false"
                                                CssClass="form-control date"
                                                Width="100%">
                                            </asp:TextBox>
                                            <span class="input-group-addon">
                                                <span class="glyphicon glyphicon-calendar"></span>
                                            </span>
                                        </div>
                                        <div class="glyphicon glyphicon-circle-arrow-right" style="text-align: center;"></div>
                                        <div class='input-group date'>
                                            <asp:TextBox ID="txt_actualFinish_new" runat="server"
                                                CssClass="form-control date"
                                                Width="100%">
                                            </asp:TextBox>
                                            <span class="input-group-addon">
                                                <span class="glyphicon glyphicon-calendar"></span>
                                            </span>
                                        </div>
                                        <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator18" runat="server" ControlToValidate="txt_actualFinish_new" Display="Dynamic" ForeColor="Red" ValidationGroup="update_followUp_date"></asp:RequiredFieldValidator>--%>
                                    </div>
                                    <%--Text Comment--%>
                                    <div style="margin-top: 10px;">
                                        <asp:TextBox runat="server" ID="txt_detail_followDate"
                                            CssClass="form-control h100"
                                            placeholder="Detail : "
                                            TextMode="MultiLine"
                                            Height="100%"
                                            Style="width: 100% !important"
                                            Font-Size="Large"
                                            BackColor="#FCF5D8">
                                        </asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator19" runat="server" ControlToValidate="txt_detail_followDate" Display="Dynamic" ForeColor="Red" ValidationGroup="update_followUp_date"></asp:RequiredFieldValidator>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:LinkButton ID="btn_save_Update_FollowUp_date" runat="server" CssClass="btn " BackColor="#078c10" ForeColor="White" OnClick="btn_save_Update_FollowUp_date_Click" ValidationGroup="update_followUp_date" OnClientClick="WebForm_OnSubmit(); return confirm('Are you sure?');">Save</asp:LinkButton>
                                <asp:LinkButton ID="LinkButton6" runat="server" CssClass="btn " BackColor="#ec4f43" ForeColor="White" OnClick="btn_cancel_Click" OnClientClick="return confirm('Are you sure?');">Cancel</asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
                <Triggers>
                </Triggers>
            </asp:UpdatePanel>
        </div>

        <%--Modal Update Problem Detail--%>
        <div class="modal fade" id="modal_UpdateProblemDetail" role="dialog" style="height: 100%">
            <asp:UpdateProgress ID="UpdateProgress14" runat="server" AssociatedUpdatePanelID="UpdatePanel14">
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

            <asp:UpdatePanel ID="UpdatePanel14" runat="server">
                <ContentTemplate>
                    <div class="modal-dialog" style="width: 50% !important; margin-top: 5%;">
                        <div class="modal-content">
                            <div class="modal-header ">
                                <button type="button" class="close" data-dismiss="modal" onclick="location.href=location.href" style="font-size: large !important">&times;</button>
                                <div>
                                    <h4 runat="server" id="h8">Update Problem Detail </h4>
                                </div>
                            </div>
                            <div class="modal-body">
                                <div runat="server" id="Div8">
                                    <div class="grid-Update_Modal1">
                                        <a style="font-size: larger; font-weight: bold; align-content: center; text-align: end;">Old :
                                        </a>
                                        <asp:TextBox ID="txt_proDetal_old" runat="server"
                                            CssClass="form-control h40" Enabled="false" Text="-"
                                            Font-Size="Large"
                                            BackColor="#FCF5D8">
                                        </asp:TextBox>
                                    </div>

                                    <div class="grid-Update_Modal1">
                                        <a style="font-size: larger; font-weight: bold; align-content: center; text-align: end;">New :
                                        </a>
                                        <asp:TextBox ID="txt_proDetal_new" runat="server"
                                            CssClass="form-control h40"
                                            Font-Size="Large"
                                            BackColor="#FCF5D8">
                                        </asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator20" runat="server" ControlToValidate="txt_proDetal_new" Display="Dynamic" ForeColor="Red" ValidationGroup="update_problemDetail"></asp:RequiredFieldValidator>

                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:LinkButton ID="btn_save_UpdateProblemDetail" runat="server" CssClass="btn " BackColor="#078c10" ForeColor="White" OnClick="btn_save_UpdateProblemDetail_Click" ValidationGroup="update_problemDetail" OnClientClick="WebForm_OnSubmit(); return confirm('Are you sure?');">Save</asp:LinkButton>
                                <asp:LinkButton ID="LinkButton27" runat="server" CssClass="btn " BackColor="#ec4f43" ForeColor="White" OnClick="btn_cancel_Click" OnClientClick="return confirm('Are you sure?');">Cancel</asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
                <Triggers>
                </Triggers>
            </asp:UpdatePanel>
        </div>

        <%--Modal Update Problem More Detail รายละเอียดปัญหาเพิ่มเติม--%>
        <div class="modal fade" id="modal_UpdateProblem_moredetail" role="dialog" style="height: 100%">
            <asp:UpdateProgress ID="UpdateProgress15" runat="server" AssociatedUpdatePanelID="UpdatePanel15">
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

            <asp:UpdatePanel ID="UpdatePanel15" runat="server">
                <ContentTemplate>
                    <div class="modal-dialog" style="width: 50% !important; margin-top: 5%;">
                        <div class="modal-content">
                            <div class="modal-header ">
                                <button type="button" class="close" data-dismiss="modal" onclick="location.href=location.href" style="font-size: large !important">&times;</button>
                                <div>
                                    <h4 runat="server" id="h9">Update Spec , Data Actual , Problem Detail </h4>
                                </div>
                            </div>
                            <div class="modal-body" style="height: 300px;">
                                <div runat="server" id="Div9">
                                    <%--Head Topic Old/New--%>
                                    <div class="grid-Update_Modal4" style="">
                                        <div></div>
                                        <div style="align-self: self-end; text-align: center;">Old</div>
                                        <div></div>
                                        <div style="align-self: self-end; text-align: center;">New</div>
                                    </div>
                                    <%--Spec--%>
                                    <div class="grid-Update_Modal4" style="margin-top: 5px;">
                                        <div style="text-align: right">Spec :</div>
                                        <asp:TextBox ID="txt_spec_old" runat="server"
                                            CssClass="form-control h40" Text="-"
                                            Font-Size="Large"
                                            BackColor="#FCF5D8">
                                        </asp:TextBox>
                                        <div class="glyphicon glyphicon-circle-arrow-right" style="text-align: center;"></div>
                                        <asp:TextBox ID="txt_spec_new" runat="server"
                                            CssClass="form-control h40"
                                            Font-Size="Large"
                                            BackColor="#FCF5D8">
                                        </asp:TextBox>
                                        <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator11" runat="server" ControlToValidate="txt_spec_new" Display="Dynamic" ForeColor="Red" ValidationGroup="update_detail"></asp:RequiredFieldValidator>--%>
                                    </div>
                                    <%--Data Actual--%>
                                    <div class="grid-Update_Modal4" style="margin-top: 10px;">
                                        <div style="text-align: right">Actual :</div>
                                        <asp:TextBox ID="txt_actual_old" runat="server"
                                            CssClass="form-control h40" Text="-"
                                            Font-Size="Large"
                                            BackColor="#FCF5D8">
                                        </asp:TextBox>
                                        <div class="glyphicon glyphicon-circle-arrow-right" style="text-align: center;"></div>
                                        <asp:TextBox ID="txt_actual_new" runat="server"
                                            CssClass="form-control h40"
                                            Font-Size="Large"
                                            BackColor="#FCF5D8">
                                        </asp:TextBox>
                                        <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator12" runat="server" ControlToValidate="txt_actual_new" Display="Dynamic" ForeColor="Red" ValidationGroup="update_detail"></asp:RequiredFieldValidator>--%>
                                    </div>
                                    <%--รายละเอียดปัญหาเพิ่มเติม Problem More Detail--%>
                                    <div class="grid-Update_Modal4" style="margin-top: 10px;">
                                        <div style="text-align: right">Detail :</div>
                                        <asp:TextBox runat="server" ID="txt_detail_old"
                                            CssClass="form-control h100" Text="-"
                                            placeholder="Detail : "
                                            TextMode="MultiLine"
                                            Font-Size="Large"
                                            Style="width: 100% !important; align-self: start;"
                                            BackColor="#FCF5D8">
                                        </asp:TextBox>
                                        <div class="glyphicon glyphicon-circle-arrow-right" style="text-align: center;"></div>
                                        <asp:TextBox runat="server" ID="txt_detail_new"
                                            CssClass="form-control h100"
                                            placeholder="Detail : "
                                            TextMode="MultiLine"
                                            Style="width: 100% !important; align-self: start;"
                                            Font-Size="Large"
                                            BackColor="#FCF5D8">
                                        </asp:TextBox>
                                        <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator13" runat="server" ControlToValidate="txt_detail_new" Display="Dynamic" ForeColor="Red" ValidationGroup="update_detail"></asp:RequiredFieldValidator>--%>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:LinkButton ID="btn_save_UpdateProblem_moredetail" runat="server" CssClass="btn " BackColor="#078c10" ForeColor="White" OnClick="btn_save_UpdateProblem_moredetail_Click" OnClientClick="WebForm_OnSubmit(); return confirm('Are you sure?');">Save</asp:LinkButton>
                                <asp:LinkButton ID="LinkButton28" runat="server" CssClass="btn " BackColor="#ec4f43" ForeColor="White" OnClick="btn_cancel_Click" OnClientClick="return confirm('Are you sure?');">Cancel</asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
                <Triggers>
                </Triggers>
            </asp:UpdatePanel>
        </div>

        <%--Modal Update Action More Detail รายละเอียดการแก้ไขปัญหาเพิ่มเติม--%>
        <div class="modal fade" id="modal_UpdateAction_moredetail" role="dialog" style="height: 100%">
            <asp:UpdateProgress ID="UpdateProgress16" runat="server" AssociatedUpdatePanelID="UpdatePanel16">
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

            <asp:UpdatePanel ID="UpdatePanel16" runat="server">
                <ContentTemplate>
                    <div class="modal-dialog" style="width: 50% !important; margin-top: 5%;">
                        <div class="modal-content">
                            <div class="modal-header ">
                                <button type="button" class="close" data-dismiss="modal" onclick="location.href=location.href" style="font-size: large !important">&times;</button>
                                <div>
                                    <h4 runat="server" id="h10">Update Data Result , Action Detail </h4>
                                </div>
                            </div>
                            <div class="modal-body" style="height: 250px;">
                                <div runat="server" id="Div10">
                                    <%--Head Topic Old/New--%>
                                    <div class="grid-Update_Modal4" style="">
                                        <div></div>
                                        <div style="align-self: self-end; text-align: center;">Old</div>
                                        <div></div>
                                        <div style="align-self: self-end; text-align: center;">New</div>
                                    </div>
                                    <%--Result--%>
                                    <div class="grid-Update_Modal4" style="margin-top: 5px;">
                                        <div style="text-align: right">Result :</div>
                                        <asp:TextBox ID="txt_result_action_old" runat="server"
                                            CssClass="form-control h40" Text="-"
                                            Font-Size="Large"
                                            BackColor="#FCF5D8">
                                        </asp:TextBox>

                                        <div class="glyphicon glyphicon-circle-arrow-right" style="text-align: center;"></div>
                                        <asp:TextBox ID="txt_result_action_new" runat="server"
                                            CssClass="form-control h40"
                                            Font-Size="Large"
                                            BackColor="#FCF5D8">
                                        </asp:TextBox>
                                        <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator14" runat="server" ControlToValidate="txt_result_action_new" Display="Dynamic" ForeColor="Red" ValidationGroup="update_detail_action"></asp:RequiredFieldValidator>--%>
                                    </div>
                                    <%--รายละเอียดการแก้ไขปัญหาเพิ่มเติม Action More Detail--%>
                                    <div class="grid-Update_Modal4" style="margin-top: 10px;">
                                        <div style="text-align: right">Detail :</div>
                                        <asp:TextBox runat="server" ID="txt_detail_action_old"
                                            CssClass="form-control h100"
                                            placeholder="Detail : " Text="-"
                                            TextMode="MultiLine"
                                            Font-Size="Large"
                                            Style="width: 100% !important; align-self: start;"
                                            BackColor="#FCF5D8">
                                        </asp:TextBox>
                                        <div class="glyphicon glyphicon-circle-arrow-right" style="text-align: center;"></div>

                                        <asp:TextBox runat="server" ID="txt_detail_action_new"
                                            CssClass="form-control h100"
                                            placeholder="Detail : "
                                            TextMode="MultiLine"
                                            Style="width: 100% !important; align-self: start;"
                                            Font-Size="Large"
                                            BackColor="#FCF5D8">
                                        </asp:TextBox>
                                        <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator15" runat="server" ControlToValidate="txt_detail_action_new" Display="Dynamic" ForeColor="Red" ValidationGroup="update_detail_action"></asp:RequiredFieldValidator>--%>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:LinkButton ID="btn_save_UpdateAction_moredetail" runat="server" CssClass="btn " BackColor="#078c10" ForeColor="White" OnClick="btn_save_UpdateAction_moredetail_Click" ValidationGroup="update_detail_action" OnClientClick="WebForm_OnSubmit(); return confirm('Are you sure?');">Save</asp:LinkButton>
                                <asp:LinkButton ID="LinkButton30" runat="server" CssClass="btn " BackColor="#ec4f43" ForeColor="White" OnClick="btn_cancel_Click" OnClientClick="return confirm('Are you sure?');">Cancel</asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
                <Triggers>
                </Triggers>
            </asp:UpdatePanel>
        </div>

        <%--<<<<<<<<<<< END >>>>>>>>>>>--%>
        <%--Modal ความหมาย Status--%>
        <div class="modal fade" id="modal_StatusMeaning" role="dialog" style="height: 100%;">
            <asp:UpdatePanel ID="UpdatePanel21" runat="server">
                <ContentTemplate>
                    <div class="modal-dialog" style="width: 50% !important; margin-top: 5%;">
                        <div class="modal-content">
                            <div class="modal-header " style="background-color: #FFAF00;">
                                <button type="button" class="close" data-dismiss="modal" onclick="location.href=location.href" style="font-size: large !important">&times;</button>
                                <div>
                                    <h4 runat="server" id="h15" style="font-size: x-large;">Status : รายละเอียด,ความหมาย </h4>
                                </div>
                            </div>
                            <div class="modal-body" style="font-size: larger; height: 250px;">
                                1.New Problem : ปัญหาใหม่<br />
                                2.Acknowledge : ผู้รับผิดชอบรับทราบปัญหา<br />
                                3.On Plan : ดำเนินการแก้ไขปัญหา<br />
                                4.Delay : ดำเนินการแก้ไขปัญหา (ล่าช้า)<br />
                                5.Send for Check : ระหว่างการยืนยันการปิดปัญหา<br />
                                6.Tool Owner[J3] Check : หัวหน้าผู้รับผิดชอบ Jig Tool อนุมัติปิดปัญหา<br />
                                7.ENG4[J3] Check : หัวหน้า PM Team อนุมัติปิดปัญหา<br />
                                8.ENG4[Mgr] Check : Manager อนุมัติปิดปัญหา
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>

        <%--Modal ความหมาย Action Type--%>
        <div class="modal fade" id="modal_ActionMeaning" role="dialog" style="height: 100%;">
            <asp:UpdatePanel ID="UpdatePanel20" runat="server">
                <ContentTemplate>
                    <div class="modal-dialog" style="width: 50% !important; margin-top: 5%;">
                        <div class="modal-content">
                            <div class="modal-header " style="background-color: #FFAF00;">
                                <button type="button" class="close" data-dismiss="modal" onclick="location.href=location.href" style="font-size: large !important">&times;</button>
                                <div>
                                    <h4 runat="server" id="h14" style="font-size: x-large;">Action : รายละเอียด,ความหมาย </h4>
                                </div>
                            </div>
                            <div class="modal-body" style="font-size: larger; height: 420px;">
                                1.Accept Use : สภาพปัญหาไม่มีผลต่อการใช้งาน,ยืนยันใช้งานได้<br />
                                2.Apply Grease/Oil : เติม Gease,น้ำมัน<br />
                                3.Cleaning Tool : ทำความสะอาด Tool<br />
                                4.Change Spare Part : เปลี่ยน Spare Part (*Part ที่มี Stock ใน CPT)<br />
                                5.Monitoring : ติดตามสภาพปัญหา<br />
                                6.Order/Making New Part : สั่งซื้อ,สั่งทำชิ้นส่วนตัวใหม่<br />
                                7.Revise PM Manual : แก้ไขเอกสาร PM Manual<br />
                                8.Revise Spec : แก้ไข Spec
                                <br />
                                9.Re-Adjust : ปรับตั้ง Tool ใหม่<br />
                                10.Re-Installation Tool :  แก้ไขการติดตั้ง Tool
                                <br />
                                11.Re-Training : อบรมผู้มีส่วนเกี่ยวข้องใหม่
                                <br />
                                12.Re-Check : ตรวจสอบใหม่อีกครั้ง<br />
                                13.Change Spare Tool : เปลี่ยน Spare Tool เข้ามาใช้ 
                                <br />
                                14.Coding,System : แก้ไขโปรแกรม,แก้ไขระบบ<br />
                                15.Re-Setting Paramemter : ปรับตั้งค่าพารามิเตอร์ใหม่<br />
                                16.Other : อื่นๆ
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>

        <%--Modal ความหมายของ Problem Type--%>
        <div class="modal fade" id="modal_ProblemTypeMeaning" role="dialog" style="height: 100%">
            <asp:UpdatePanel ID="UpdatePanel18" runat="server">
                <ContentTemplate>
                    <div class="modal-dialog" style="width: 60% !important; margin-top: 5%;">
                        <div class="modal-content">
                            <div class="modal-header " style="background-color: #FFAF00;">
                                <button type="button" class="close" data-dismiss="modal" onclick="location.href=location.href" style="font-size: large !important">&times;</button>
                                <div>
                                    <h4 runat="server" id="h12" style="font-size: x-large;">Type of Problem : รายละเอียด,ความหมายของปัญหา </h4>
                                </div>
                            </div>
                            <div class="modal-body" style="font-size: larger; height: 440px;">
                                1.Calibration : ปัญหาจากการสอบเทียบ Jig Tool ก่อนเริ่มใช้งานหรือตามรอบ
                                <br />
                                2.Part Damage,Deformation : ชิ้นส่วนของ Jig Tool ได้รับความเสียหาย,เสียรูป
                                <br />
                                3.Screw Loose, I-Mark : Screw,Nut หลุด หลวม / I-Mark ไม่ตรง
                                <br />
                                4.Leak (Air,Oil,Chemical) : มีการรั่วไหวของลม,น้ำมัน หรือสารเคมี
                                <br />
                                5.Drawing/PM Manual Mistake : Drawing ไม่ตรงกับ Jig Tool / PM Manual ผิดพลาด,ไม่ครอบคลุม
                                <br />
                                6.Out Spec : ค่าที่ตรวจสอบได้เกินค่ามาตรฐานที่กำหนด
                                <br />
                                7.Rusty : พบสนิมในชิ้นส่วนของ Jig Tool
                                <br />
                                8.Abnormal Noise : พบเสียงผิดปกติ
                                <br />
                                9.Safety : ระบบความปลอดภัยของ Jig Tool มีปัญหา
                                <br />
                                10.Cable (Damaged,Not Connect) : สายไฟ,สายเคเบิ้ล ได้รับความเสียหาย / ไม่เชื่อมต่อกัน
                                <br />
                                11.Dirty/Gomikeba : พบสิ่งสกปรก , เศษฝุ่น , เศษ Part
                                <br />
                                12.System Mistake : ระบบ PM Problem System มีปัญหา
                                <br />
                                13.Missing Part : ชิ้นส่วน,ส่วนประกอบใน Jig tool สูญหาย
                                <br />
                                14.Label NG : Label ที่ติดที่ Jig Tool หลุดลอก , ชำรุด
                                <br />
                                15.Part Drop : พบชิ้นส่วน Part Product ตกหล่นที่ Jig Tool
                                <br />
                                16.Cancel : ยกเลิกการขึ้น PM Problem
                                <br />
                                17.Other : ปัญหาอื่นๆ
                                <br />
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>

        <%--Modal ความหมาย PM Problem Rank--%>
        <div class="modal fade" id="modal_ProblemRankMeaning" role="dialog" style="height: 30%;">
            <asp:UpdatePanel ID="UpdatePanel19" runat="server">
                <ContentTemplate>
                    <div class="modal-dialog" style="width: 50% !important; margin-top: 5%;">
                        <div class="modal-content">
                            <div class="modal-header " style="background-color: #FFAF00;">
                                <button type="button" class="close" data-dismiss="modal" onclick="location.href=location.href" style="font-size: large !important">&times;</button>
                                <div>
                                    <h4 runat="server" id="h13">PM Problem Rank : รายละเอียด,ความหมาย </h4>
                                </div>
                            </div>
                            <div class="modal-body" style="height: 380px;">
                                A : Calibration/Urgent Action : ปัญหาจากการสอบเทียบ,ปัญหาเร่งด่วนที่ต้องแก้ไข<br />
                                B : Action/Use Lead Time for Action : ปัญหาที่ต้องแก้ไข,ปัญหาที่ต้องใช้เวลาในการแก้ไข<br />
                                C : Accept Use/Monitoring : ยืนยันสภาพปัญหาสามารถใช้งานได้,เฝ้าติดตามสภาพปัญหา<br />
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>

        <%--Modal: Upload PDF--%>
        <div id="modal_UploadPdf" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="lblUploadPdfTitle">
          <div class="modal-dialog" role="document">
            <div class="modal-content">

              <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">×</button>
                <h4 class="modal-title" id="lblUploadPdfTitle">Upload PDF</h4>
              </div>

              <div class="modal-body">
                <%--<p class="text-muted" style="margin-bottom:8px;">
                  รองรับเฉพาะไฟล์ .PDF เท่านั้น
                </p>--%>

                <!-- 1.1.1 Browse -->
                <div class="form-group">
                  <label>เลือกไฟล์ (Browse):</label><br/>
                  <asp:FileUpload ID="UploadPdf" runat="server" accept="" />
                  <%--<asp:FileUpload ID="FileUpload1" runat="server" accept=".pdf" />--%>
                </div>

                <!-- 1.1.2 Drag & Drop -->
                <label>หรือ ลากไฟล์มาวาง:</label>
                <div id="dropPdfZone" class="drop-zone">
                  ลากไฟล์ที่ต้องการ Upload มาวางที่นี่
                </div>
                <small id="pdfFileName" class="text-info"></small>

                <style>
                    .drop-zone {
                        border: 2px dashed #aaa;
                        border-radius: 6px;
                        padding: 18px;
                        text-align: center;
                        color: #666;
                        margin-top: 6px;
                    }

                        .drop-zone.dragover {
                            border-color: #3c8dbc;
                            background: #f5faff;
                            color: #3c8dbc;
                        }
                </style>
              </div>

              <div class="modal-footer">
                <asp:Label ID="lbPdfError" runat="server" CssClass="text-danger pull-left" />
                <asp:Button ID="btnUploadPdfConfirm" runat="server" CssClass="btn btn-primary"
                            Text="Upload" OnClick="btnUploadPdfConfirm_Click" />
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
              </div>

            </div>
          </div>
        </div>

        <%--Drag & Drop JS: ผูกกับ FileUpload (UploadPdf)--%>
        <script>
            // อนุญาตเลือกหลายไฟล์ด้วย attribute multiple (ใส่ตอนโหลดเพจ)
            document.addEventListener('DOMContentLoaded', function () {
                var input = document.getElementById('<%= UploadPdf.ClientID %>');
                if (input) {
                    input.setAttribute('multiple', 'multiple');
                    input.removeAttribute('accept');
                    input.addEventListener('change', function () {
                        renderFileList(input.files);
                    });
                }
            });

            // Drag & Drop (รองรับหลายไฟล์)
            <%--(function () {
                var dz = document.getElementById('dropPdfZone');
                if (!dz) return;
                dz.addEventListener('dragover', function (e) { e.preventDefault(); dz.classList.add('dragover'); });
                dz.addEventListener('dragleave', function () { dz.classList.remove('dragover'); });
                dz.addEventListener('drop', function (e) {
                    e.preventDefault(); dz.classList.remove('dragover');
                    var files = e.dataTransfer.files; if (!files || !files.length) return;

                    // ตรวจทุกไฟล์ต้องเป็น .pdf
                    for (var i = 0; i < files.length; i++) {
                        if (!/\.pdf$/i.test(files[i].name)) { alert('รองรับเฉพาะไฟล์ .pdf'); return; }
                    }
                    var input = document.getElementById('<%= UploadPdf.ClientID %>');
                    if (input && input.files) { input.files = files; }

                    // แสดงชื่อไฟล์สั้น ๆ
                    var names = []; for (var j = 0; j < files.length; j++) names.push(files[j].name);
                    document.getElementById('pdfFileName').textContent = names.join(' , ');
                }, false);
            })();--%>

            (function () {
                var dz = document.getElementById('dropPdfZone');
                var input = document.getElementById('<%= UploadPdf.ClientID %>');
                var listEl = document.getElementById('pdfFileName');

                if (!dz || !input) return;

                ['dragenter', 'dragover'].forEach(function (evt) {
                    dz.addEventListener(evt, function (e) {
                        e.preventDefault(); e.stopPropagation();
                        dz.classList.add('dragover');
                    });
                });

                ['dragleave', 'drop'].forEach(function (evt) {
                    dz.addEventListener(evt, function (e) {
                        e.preventDefault(); e.stopPropagation();
                        if (evt === 'dragleave') dz.classList.remove('dragover');
                    });
                });

                dz.addEventListener('drop', function (e) {
                    dz.classList.remove('dragover');
                    var files = (e.dataTransfer && e.dataTransfer.files) ? e.dataTransfer.files : null;
                    if (!files || !files.length) return;

                    renderFileList(files);

                    // พยายามยัดไฟล์กลับเข้า input.files (Chrome/Edge/Firefox เวอร์ชันใหม่ทำได้)
                    try {
                        var dt = new DataTransfer();
                        for (var i = 0; i < files.length; i++) dt.items.add(files[i]);
                        input.files = dt.files;
                    } catch (err) {
                        console.warn('Cannot set input.files programmatically:', err);
                        // Fallback: ให้ผู้ใช้กดปุ่ม Browse เลือกไฟล์ซ้ำ หรือทำ XHR อัปโหลดทันที (ดูตัวเลือก B ด้านล่าง)
                    }
                });

                input.addEventListener('change', function () {
                    renderList(input.files);
                });

                function renderFileList(fileList) {
                    var container = document.getElementById('pdfFileName');
                    if (!container) return;
                    if (!fileList || !fileList.length) {
                        container.textContent = '(ยังไม่ได้เลือกไฟล์)';
                        return;
                    }
                    var html = '<ul>';
                    for (var i = 0; i < fileList.length; i++) {
                        var f = fileList[i];
                        html += '<li>' + escapeHtml(f.name) + ' — ' + formatBytes(f.size) +
                            (f.type ? (' — ' + f.type) : '') + '</li>';
                    }
                    html += '</ul>';
                    container.innerHTML = html;
                }

                function formatBytes(bytes) {
                    if (bytes === 0) return '0 B';
                    var k = 1024, sizes = ['B', 'KB', 'MB', 'GB', 'TB'];
                    var i = Math.floor(Math.log(bytes) / Math.log(k));
                    return (bytes / Math.pow(k, i)).toFixed(2) + ' ' + sizes[i];
                }

                function escapeHtml(str) {
                    return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
                }

            })();   

        </script>

        <%--===== End Modal =====--%>

        <%--===== Modal: รายชื่อไฟล์ PDF =====--%>
        <div id="modal_PdfList" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="lblPdfListTitle">
          <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">

              <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">×</button>
                <h4 class="modal-title" id="lblPdfListTitle">PDF Files</h4>
              </div>

              <div class="modal-body">

                <asp:Label ID="lbPdfListEmpty" runat="server" CssClass="text-muted" Visible="false">
                  ไม่พบไฟล์ PDF ในปัญหานี้
                </asp:Label>
            
                <%--<asp:GridView ID="gvPdf" runat="server" AutoGenerateColumns="false"
                              CssClass="table table-striped table-condensed"
                              OnRowCommand="gvPdf_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="Name" HeaderText="File name" />
                        <asp:BoundField DataField="SizeText" HeaderText="Size" />
                        <asp:BoundField DataField="Modified" HeaderText="Modified" />
                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkOpen" runat="server"
                                    CommandName="open" CommandArgument='<%# Eval("Name") %>'
                                    CssClass="btn btn-xs btn-primary">Open</asp:LinkButton>
                                <asp:LinkButton ID="lnkDownload" runat="server"
                                    CommandName="download" CommandArgument='<%# Eval("Name") %>'
                                    CssClass="btn btn-xs btn-default">Download</asp:LinkButton>
                                                              
                                <asp:LinkButton ID="lnkDelete" runat="server"
                                    CommandName="del"      
                                    CommandArgument='<%# Eval("Name") %>'
                                    OnClientClick="return confirm('ลบไฟล์นี้แน่ใจหรือไม่?');"
                                    CssClass="btn btn-xs btn-danger">Delete</asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>--%>

                  
                <asp:GridView ID="gvPdf" runat="server" AutoGenerateColumns="False"
                    OnRowCommand="gvPdf_RowCommand" CssClass="table table-striped table-sm">
                    <Columns>
                        <asp:BoundField DataField="Name" HeaderText="ชื่อไฟล์" />
                        <asp:BoundField DataField="SizeText" HeaderText="ขนาด" />
                        <asp:BoundField DataField="Modified" HeaderText="แก้ไขล่าสุด" />

                        <%---- ปุ่ม Open เฉพาะไฟล์ที่เปิดได้ ----%>
                        <asp:TemplateField HeaderText="Open">
                            <ItemTemplate>
                                <asp:LinkButton runat="server" ID="btnOpen" Text="Open"
                                    CommandName="open"
                                    CommandArgument='<%# Eval("Name") %>'
                                    
                                    CssClass="btn btn-link btn-sm" />
                            </ItemTemplate>

                            <%--Visible='<%# (bool)Eval("CanOpen") %>'--%>

                        </asp:TemplateField>

                        <%---- ปุ่ม Download สำหรับทุกไฟล์ ----%>
                        <asp:TemplateField HeaderText="Download">
                            <ItemTemplate>
                                <asp:LinkButton runat="server" ID="btnDownload" Text="Download"
                                    CommandName="download"
                                    CommandArgument='<%# Eval("Name") %>'
                                    CssClass="btn btn-link btn-sm" />
                            </ItemTemplate>
                        </asp:TemplateField>

                        <%--- (ถ้ามีสิทธิ์) ลบไฟล์ ----%>
                        <asp:TemplateField HeaderText="Delete">
                            <ItemTemplate>
                                <asp:LinkButton runat="server" ID="btnDel" Text="Delete"
                                    CommandName="del"
                                    CommandArgument='<%# Eval("Name") %>'
                                    OnClientClick="return confirm('Delete this file?');"
                                    CssClass="btn btn-link text-danger btn-sm" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>


              </div>

              <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
              </div>

            </div>
          </div>
        </div>
        <%--===== End Modal =====--%>

        <%--**************JavaScipt*******************--%>

        <%--Check ค่าว่าง--%>
        <script>
            function WebForm_OnSubmit() {
                if (typeof (ValidatorOnSubmit) == "function" && ValidatorOnSubmit() == false) {
                    for (var i in Page_Validators) {
                        try {
                            var control = document.getElementById(Page_Validators[i].controltovalidate);
                            if (!Page_Validators[i].isvalid) {
                                control.classList.add("red-border");
                            } else {
                                control.classList.remove("red-border");
                            }
                        } catch (e) { }
                    }
                    return false;
                }
                return true;
            }


            function CheckRadio() {
                var OK = $('#re_OK').is(':checked'); // document.getElementById("<%= re_OK.ClientID %>");
                var NG = $('#re_NG').is(':checked'); // document.getElementById("<%= re_NG.ClientID %>");
                var div = document.getElementById("<%= div_OK.ClientID %>");
                if (OK == false && NG == false) {
                    div.classList.add("border-red");
                    return false;
                }
                return true;
            }

        </script>

        <%--Check Status Close--%>
        <script type="text/javascript">                                                                    
            function auto_planFinist() {
                let status = document.getElementById("<%=ddl_isOnplan.ClientID %>").value;
                let rank = document.getElementById("<%=ddl_priority.ClientID%>").value;
                let date = document.getElementById("<%=txt_problemDate.ClientID%>").value;
                let plan = document.getElementById("<%=txt_planFinish.ClientID %>");
                let planold = document.getElementById("<%=lb_plan.ClientID %>").value;
                if (status == "7" || status == "8") {
                    alert("!! ไม่สามารถแก้ไขได้ เนื่องจาก Problem Close or Cancel"); return;
                }
                if (rank == "A") {
                    plan.value = date;
                } else {
                    plan.value = planold;
                }
            }
        </script>

    </form>
</body>
</html>
