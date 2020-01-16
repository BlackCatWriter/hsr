<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>合同管理</title>
	<meta name="decorator" content="default"/>
	<script src="${ctxStatic}/word-export/FileSaver.js" type="text/javascript"></script>
	<script src="${ctxStatic}/word-export/jquery.wordexport.js" type="text/javascript"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			if(!$("#contentContract").val()){
                $("#contentContract").val('<p>\n' +
                    '\t&nbsp;</p>\n' +
                    '<p align="center" class="MsoNormal" style="margin-bottom:7.8pt;mso-para-margin-bottom:\n' +
                    '.5gd;text-align:center">\n' +
                    '\t<span class="inpt1"><span new="" style="font-size:22.0pt;\n' +
                    'font-family:黑体;mso-hansi-font-family:" times="">南京同仁医院<span lang="EN-US"><o:p></o:p></span></span></span></p>\n' +
                    '<p align="center" class="MsoNormal" style="margin-bottom:7.8pt;mso-para-margin-bottom:\n' +
                    '.5gd;text-align:center">\n' +
                    '\t<span class="inpt1"><span new="" style="font-size:22.0pt;\n' +
                    'font-family:黑体;mso-hansi-font-family:" times="">科研项目实施协议书</span></span><span class="inpt1"><span lang="EN-US" new="" style="font-size:14.0pt;font-family:黑体;mso-hansi-font-family:\n' +
                    '" times=""><o:p></o:p></span></span></p>\n' +
                    '<p align="left" class="MsoNormal" style="line-height: 14.25pt;">\n' +
                    '\t<span lang="EN-US" style="mso-bidi-font-size:10.5pt;\n' +
                    'font-family:宋体;mso-bidi-font-family:宋体;mso-font-kerning:0pt">&nbsp;</span></p>\n' +
                    '<p align="left" class="MsoNormal" style="margin-left: 24pt; text-indent: -24pt; line-height: 150%;">\n' +
                    '\t<span style="font-size:12.0pt;line-height:150%;font-family:宋体;\n' +
                    'mso-bidi-font-family:宋体;mso-font-kerning:0pt">甲方：</span><span style="font-size:\n' +
                    '12.0pt;line-height:150%;font-family:华文楷体;mso-bidi-font-family:宋体;mso-font-kerning:\n' +
                    '0pt">南京同仁医院</span><span lang="EN-US" style="font-size:12.0pt;line-height:150%;\n' +
                    'font-family:宋体;mso-bidi-font-family:宋体;mso-font-kerning:0pt"><o:p></o:p></span></p>\n' +
                    '<p align="left" class="MsoNormal" style="margin-left: 24pt; text-indent: -24pt; line-height: 150%;">\n' +
                    '\t<span style="font-size:12.0pt;line-height:150%;font-family:宋体;\n' +
                    'mso-bidi-font-family:宋体;mso-font-kerning:0pt">甲方代表：</span><span style="font-size:12.0pt;line-height:150%;font-family:华文楷体;mso-bidi-font-family:\n' +
                    '宋体;mso-font-kerning:0pt">南京同仁医院科教部</span><span lang="EN-US" style="font-size:\n' +
                    '12.0pt;line-height:150%;font-family:宋体;mso-bidi-font-family:宋体;mso-font-kerning:\n' +
                    '0pt"><o:p></o:p></span></p>\n' +
                    '<p align="left" class="MsoNormal" style="margin: 0cm 0cm 15.6pt 24pt; text-indent: -24pt; line-height: 150%;">\n' +
                    '\t<span style="font-size:12.0pt;line-height:150%;font-family:宋体;\n' +
                    'mso-bidi-font-family:宋体;mso-font-kerning:0pt">甲方代表人：<u><span lang="EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></u>（注明职务）<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '<p align="left" class="MsoNormal" style="margin: 0cm 0cm 7.8pt 24pt; text-indent: -24pt; line-height: 150%;">\n' +
                    '\t<span style="font-size:12.0pt;line-height:150%;font-family:宋体;\n' +
                    'mso-bidi-font-family:宋体;mso-font-kerning:0pt">乙方：<u><span lang="EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>（</u>科研项目组）<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '<p align="left" class="MsoNormal" style="margin: 0cm 0cm 15.6pt 24pt; text-indent: -24pt; line-height: 150%;">\n' +
                    '\t<span style="font-size:12.0pt;line-height:150%;font-family:宋体;\n' +
                    'mso-bidi-font-family:宋体;mso-font-kerning:0pt">乙方负责人：<u><span lang="EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></u>（注明职称）<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '<p align="left" class="MsoNormal" style="margin-left: 24pt; text-indent: -24pt; line-height: 25pt;">\n' +
                    '\t<span style="font-size:12.0pt;font-family:\n' +
                    '宋体;mso-bidi-font-family:宋体;mso-font-kerning:0pt">丙方：<u><span lang="EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></u>（科研项目承担部门）<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '<p align="left" class="MsoNormal" style="margin: 0cm 0cm 7.8pt 24pt; text-indent: -24pt; line-height: 25pt;">\n' +
                    '\t<span style="font-size:12.0pt;font-family:\n' +
                    '宋体;mso-bidi-font-family:宋体;mso-font-kerning:0pt">丙方负责人：<u><span lang="EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></u>（注明职务）<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '<p align="left" class="MsoNormal" style="margin: 0cm 0cm 7.8pt 24pt; text-indent: -24pt; line-height: 150%;">\n' +
                    '\t<span lang="EN-US" style="font-size:12.0pt;line-height:150%;\n' +
                    'font-family:宋体;mso-bidi-font-family:宋体;mso-font-kerning:0pt">&nbsp;</span></p>\n' +
                    '<p align="left" class="MsoNormal" style="text-indent: 24pt; line-height: 150%;">\n' +
                    '\t<span style="font-size:12.0pt;line-height:150%;font-family:宋体;mso-bidi-font-family:\n' +
                    '宋体;mso-font-kerning:0pt">为了保证顺利实施<u><span lang="EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></u>科研项目（下面简称&ldquo;本项目&rdquo;），甲、乙、丙三方经平等协商，自愿达成如下一致意见：<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '<p align="left" class="MsoNormal" style="text-indent: 24pt; line-height: 150%;">\n' +
                    '\t<span lang="EN-US" style="font-size:12.0pt;line-height:150%;font-family:宋体;mso-bidi-font-family:\n' +
                    '宋体;mso-font-kerning:0pt">1.</span><span style="font-size:12.0pt;line-height:\n' +
                    '150%;font-family:宋体;mso-bidi-font-family:宋体;mso-font-kerning:0pt">本项目权属甲方，项目的各项成果中均应标注&ldquo;南京同仁医院&rdquo;字样。上级课题项目的成果权属，按上级相应管理办法要求标注。<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '<p align="left" class="MsoNormal" style="text-indent: 24pt; line-height: 150%;">\n' +
                    '\t<span lang="EN-US" style="font-size:12.0pt;line-height:150%;font-family:宋体;mso-bidi-font-family:\n' +
                    '宋体;mso-font-kerning:0pt">2.</span><span style="font-size:12.0pt;line-height:\n' +
                    '150%;font-family:宋体;mso-bidi-font-family:宋体;mso-font-kerning:0pt">对本项目各项研究成果，乙方有关研究人员仅享受署名权。<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '<p align="left" class="MsoNormal" style="text-indent: 24pt; line-height: 150%;">\n' +
                    '\t<span lang="EN-US" style="font-size:12.0pt;line-height:150%;font-family:宋体;mso-bidi-font-family:\n' +
                    '宋体;mso-font-kerning:0pt">3.</span><span style="font-size:12.0pt;line-height:\n' +
                    '150%;font-family:宋体;mso-bidi-font-family:宋体;mso-font-kerning:0pt">本项目经费总金额<u><span lang="EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></u>万元，由<u><span lang="EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></u>拨付。项目费经核定在<u><span lang="EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></u>万元内，其中固定资产投资<u><span lang="EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></u>万元，乙方负责人按相关规定支配使用。<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '<p align="left" class="MsoNormal" style="text-indent: 24pt; line-height: 150%;">\n' +
                    '\t<span lang="EN-US" style="font-size:12.0pt;line-height:150%;font-family:宋体;mso-bidi-font-family:\n' +
                    '宋体;mso-font-kerning:0pt">4.</span><span style="font-size:12.0pt;line-height:\n' +
                    '150%;font-family:宋体;mso-bidi-font-family:宋体;mso-font-kerning:0pt">如果项目最终未能结题或结题质量低（由学术委员会或相关专家评定），甲方将追回研究经费，并按相关办法追究责任。<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '<p align="left" class="MsoNormal" style="text-indent: 24pt; line-height: 150%;">\n' +
                    '\t<span lang="EN-US" style="font-size:12.0pt;line-height:150%;font-family:宋体;mso-bidi-font-family:\n' +
                    '宋体;mso-font-kerning:0pt">5.</span><span style="font-size:12.0pt;line-height:\n' +
                    '150%;font-family:宋体;mso-bidi-font-family:宋体;mso-font-kerning:0pt">乙方在项目研究过程中，应接受甲方及其代表的监督、检查与指导。<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '<p align="left" class="MsoNormal" style="text-indent: 24pt; line-height: 150%;">\n' +
                    '\t<span lang="EN-US" style="font-size:12.0pt;line-height:150%;font-family:宋体;mso-bidi-font-family:\n' +
                    '宋体;mso-font-kerning:0pt">6.</span><span style="font-size:12.0pt;line-height:\n' +
                    '150%;font-family:宋体;mso-bidi-font-family:宋体;mso-font-kerning:0pt">丙方应积极支持乙方工作，组织具有相应资质、能力和经历的人员参与乙方的项目。还应积极督促乙方项目的进展情况<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '<p align="left" class="MsoNormal" style="text-indent: 24pt; line-height: 150%;">\n' +
                    '\t<span lang="EN-US" style="font-size:12.0pt;line-height:150%;font-family:宋体;mso-bidi-font-family:\n' +
                    '宋体;mso-font-kerning:0pt">7.</span><span style="font-size:12.0pt;line-height:\n' +
                    '150%;font-family:宋体;mso-bidi-font-family:宋体;mso-font-kerning:0pt">乙方的项目研究分<u><span lang="EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></u>个阶段。<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '<p align="left" class="MsoNormal" style="text-indent: 24pt; line-height: 150%;">\n' +
                    '\t<span style="font-size:12.0pt;line-height:150%;font-family:宋体;mso-bidi-font-family:\n' +
                    '宋体;mso-font-kerning:0pt">第一阶段（任务）：<u><span lang="EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></u>，于<u><span lang="EN-US">&nbsp;&nbsp;&nbsp;&nbsp; </span></u>年<u><span lang="EN-US">&nbsp;&nbsp; </span></u>月结束，成果为<u><span lang="EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></u>；<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '<p align="left" class="MsoNormal" style="text-indent: 24pt; line-height: 150%;">\n' +
                    '\t<span style="font-size:12.0pt;line-height:150%;font-family:宋体;mso-bidi-font-family:\n' +
                    '宋体;mso-font-kerning:0pt">第二阶段（任务）：<u><span lang="EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></u>，于<u><span lang="EN-US">&nbsp;&nbsp;&nbsp;&nbsp; </span></u>年<u><span lang="EN-US">&nbsp;&nbsp; </span></u>月结束，成果为<u><span lang="EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></u>；<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '<p align="left" class="MsoNormal" style="text-indent: 24pt; line-height: 150%;">\n' +
                    '\t<span style="font-size:12.0pt;line-height:150%;font-family:宋体;mso-bidi-font-family:\n' +
                    '宋体;mso-font-kerning:0pt">第三阶段（任务）：<u><span lang="EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></u>，于<u><span lang="EN-US">&nbsp;&nbsp;&nbsp;&nbsp; </span></u>年<u><span lang="EN-US">&nbsp;&nbsp; </span></u>月结束，成果为<u><span lang="EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></u>；<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '<p align="left" class="MsoNormal" style="text-indent: 24pt; line-height: 150%;">\n' +
                    '\t<span style="font-size:12.0pt;line-height:150%;font-family:宋体;mso-bidi-font-family:\n' +
                    '宋体;mso-font-kerning:0pt">第四阶段（任务）：<u><span lang="EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></u>，于<u><span lang="EN-US">&nbsp;&nbsp;&nbsp;&nbsp; </span></u>年<u><span lang="EN-US">&nbsp;&nbsp; </span></u>月结束，成果为<u><span lang="EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></u>；<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '<p align="left" class="MsoNormal" style="margin-left: 27pt; line-height: 150%;">\n' +
                    '\t<u><span lang="EN-US" style="font-size:12.0pt;line-height:150%;font-family:宋体;mso-bidi-font-family:\n' +
                    '宋体;mso-font-kerning:0pt">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></u><span style="font-size:12.0pt;line-height:150%;font-family:\n' +
                    '宋体;mso-bidi-font-family:宋体;mso-font-kerning:0pt">，<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '<p align="left" class="MsoNormal" style="line-height: 150%;">\n' +
                    '\t<u><span lang="EN-US" style="font-size:12.0pt;\n' +
                    'line-height:150%;font-family:宋体;mso-bidi-font-family:宋体;mso-font-kerning:0pt">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></u><span style="font-size:12.0pt;line-height:150%;font-family:宋体;mso-bidi-font-family:\n' +
                    '宋体;mso-font-kerning:0pt">；<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '<p align="left" class="MsoNormal" style="text-indent: 24pt; line-height: 150%;">\n' +
                    '\t<span style="font-size:12.0pt;line-height:150%;font-family:宋体;mso-bidi-font-family:\n' +
                    '宋体;mso-font-kerning:0pt">计划结题时间为<u><span lang="EN-US">&nbsp;&nbsp;&nbsp;&nbsp; </span></u>年<u><span lang="EN-US">&nbsp;&nbsp; </span></u>月，结题成果形式为<u><span lang="EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <o:p></o:p></span></u></span></p>\n' +
                    '<p align="left" class="MsoNormal" style="line-height: 150%;">\n' +
                    '\t<u><span lang="EN-US" style="font-size:12.0pt;\n' +
                    'line-height:150%;font-family:宋体;mso-bidi-font-family:宋体;mso-font-kerning:0pt">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></u><span style="font-size:12.0pt;line-height:150%;font-family:\n' +
                    '宋体;mso-bidi-font-family:宋体;mso-font-kerning:0pt">。<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '<p align="left" class="MsoNormal" style="text-indent: 24pt; line-height: 150%;">\n' +
                    '\t<span lang="EN-US" style="font-size:12.0pt;line-height:150%;font-family:宋体;mso-bidi-font-family:\n' +
                    '宋体;mso-font-kerning:0pt">8.</span><span style="font-size:12.0pt;line-height:\n' +
                    '150%;font-family:宋体;mso-bidi-font-family:宋体;mso-font-kerning:0pt">本项目的技术背景资料、可行性报告、技术论证报告、项目申请书及项目研究的支撑材料等，视为实施协议的组成部分，乙方及其组成人员负有保密的义务，必须认真做好保密工作，否则，由此造成的后果，项目组必须负责。<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '<p align="left" class="MsoNormal" style="text-indent: 24pt; line-height: 150%;">\n' +
                    '\t<span lang="EN-US" style="font-size:12.0pt;line-height:150%;font-family:宋体;mso-bidi-font-family:\n' +
                    '宋体;mso-font-kerning:0pt">9.</span><span style="font-size:12.0pt;line-height:\n' +
                    '150%;font-family:宋体;mso-bidi-font-family:宋体;mso-font-kerning:0pt">乙方若因不可抗因素调离项目组或医院，应按照相关规定办理科研项目移交手续，由丙方重新认定项目负责人，继续完成科研项目。<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '<p align="left" class="MsoNormal" style="text-indent: 24pt; line-height: 150%;">\n' +
                    '\t<span lang="EN-US" style="font-size:12.0pt;line-height:150%;font-family:宋体;mso-bidi-font-family:\n' +
                    '宋体;mso-font-kerning:0pt">10.</span><span style="font-size:12.0pt;line-height:\n' +
                    '150%;font-family:宋体;mso-bidi-font-family:宋体;mso-font-kerning:0pt">甲、乙、丙三方因项目实施和执行本协议发生争议，应通过协商解决，协商不成请求上级裁决。<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '<p align="left" class="MsoNormal" style="margin-top: 7.8pt; text-indent: 24pt; line-height: 150%;">\n' +
                    '\t<span style="font-size:12.0pt;line-height:150%;\n' +
                    'font-family:宋体;mso-bidi-font-family:宋体;mso-font-kerning:0pt">本协议一式<u><span lang="EN-US">&nbsp; </span>叁<span lang="EN-US">&nbsp; </span></u>份，甲方<u><span lang="EN-US">&nbsp; </span>壹<span lang="EN-US">&nbsp; </span></u>份、乙方<u><span lang="EN-US">&nbsp; </span>壹<span lang="EN-US">&nbsp; </span></u>份，丙方<u><span lang="EN-US">&nbsp; </span>壹<span lang="EN-US">&nbsp; </span></u>份，经甲方代表、乙方负责人、丙方负责人签名后，立即生效。<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '<p align="left" class="MsoNormal" style="margin: 7.8pt 0cm 0.0001pt 21.1pt; text-indent: -21.1pt; line-height: 150%;">\n' +
                    '\t<b><span style="mso-bidi-font-size:10.5pt;\n' +
                    'line-height:150%;font-family:宋体;mso-bidi-font-family:宋体;mso-font-kerning:0pt">附：项目预算表</span></b><b><span lang="EN-US" style="font-size:14.0pt;\n' +
                    'line-height:150%;font-family:宋体;mso-bidi-font-family:宋体;mso-font-kerning:0pt"><o:p></o:p></span></b></p>\n' +
                    '<p align="left" class="MsoNormal" style="margin-left: 24pt; text-indent: -24pt; line-height: 150%;">\n' +
                    '\t<span lang="EN-US" style="font-size:12.0pt;line-height:150%;\n' +
                    'font-family:宋体;mso-bidi-font-family:宋体;mso-font-kerning:0pt">&nbsp;</span></p>\n' +
                    '<p align="left" class="MsoNormal" style="margin-left: 28pt; text-indent: -28pt; line-height: 150%;">\n' +
                    '\t<span style="font-size:14.0pt;line-height:150%;font-family:宋体;\n' +
                    'mso-bidi-font-family:宋体;mso-font-kerning:0pt">甲方：<span lang="EN-US">&nbsp; </span>（章）<span lang="EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>丙方：</span><span lang="EN-US" style="font-size:12.0pt;line-height:150%;font-family:宋体;mso-bidi-font-family:\n' +
                    '宋体;mso-font-kerning:0pt"><o:p></o:p></span></p>\n' +
                    '<p align="left" class="MsoNormal" style="margin: 7.8pt 0cm 0.0001pt 28pt; text-indent: -28pt; line-height: 150%;">\n' +
                    '\t<span style="font-size:14.0pt;line-height:150%;font-family:宋体;mso-bidi-font-family:\n' +
                    '宋体;mso-font-kerning:0pt">甲方代表：<span lang="EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>乙方负责人：<span lang="EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>丙方负责人：<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '<p align="left" class="MsoNormal" style="margin: 7.8pt 0cm 0.0001pt 28pt; text-indent: -28pt; line-height: 150%;">\n' +
                    '\t<u><span lang="EN-US" style="font-size:14.0pt;line-height:150%;font-family:宋体;mso-bidi-font-family:\n' +
                    '宋体;mso-font-kerning:0pt">&nbsp;&nbsp;&nbsp; </span></u><span style="font-size:14.0pt;line-height:150%;font-family:宋体;mso-bidi-font-family:\n' +
                    '宋体;mso-font-kerning:0pt">年<u><span lang="EN-US">&nbsp; </span></u>月<u><span lang="EN-US">&nbsp; </span></u>日<span lang="EN-US">&nbsp;&nbsp;&nbsp;&nbsp; <u>&nbsp;&nbsp;&nbsp;&nbsp;</u></span>年<u><span lang="EN-US">&nbsp; </span></u>月<u><span lang="EN-US">&nbsp; </span></u>日<span lang="EN-US">&nbsp;&nbsp;&nbsp;&nbsp; <u>&nbsp;&nbsp;&nbsp;&nbsp;</u></span>年<u><span lang="EN-US">&nbsp; </span></u>月<u><span lang="EN-US">&nbsp; </span></u>日<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '<p align="center" class="MsoNormal" style="margin-top:7.8pt;margin-right:0cm;\n' +
                    'margin-bottom:0cm;margin-left:44.0pt;margin-bottom:.0001pt;mso-para-margin-top:\n' +
                    '.5gd;mso-para-margin-right:0cm;mso-para-margin-bottom:0cm;mso-para-margin-left:\n' +
                    '44.0pt;mso-para-margin-bottom:.0001pt;text-align:center;text-indent:-44.0pt;\n' +
                    'mso-char-indent-count:-2.0;line-height:150%;mso-pagination:widow-orphan">\n' +
                    '\t<span style="font-size:22.0pt;line-height:150%;font-family:华文中宋;mso-bidi-font-family:\n' +
                    '宋体;mso-font-kerning:0pt">项目预算表<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '<div align="center">\n' +
                    '\t<table border="0" cellpadding="0" cellspacing="0" class="MsoNormalTable" style="width:434.45pt;border-collapse:collapse;mso-yfti-tbllook:1184;\n' +
                    ' mso-padding-alt:0cm 5.4pt 0cm 5.4pt" width="579">\n' +
                    '\t\t<tbody>\n' +
                    '\t\t\t<tr style="mso-yfti-irow:0;mso-yfti-firstrow:yes;height:1.0cm">\n' +
                    '\t\t\t\t<td style="width: 173pt; border-width: 1pt; border-style: solid; border-color: windowtext; padding: 0cm 5.4pt; height: 1cm;" width="231">\n' +
                    '\t\t\t\t\t<p align="left" class="MsoNormal">\n' +
                    '\t\t\t\t\t\t<span style="font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;color:black;\n' +
                    '  mso-font-kerning:0pt">科目<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '\t\t\t\t</td>\n' +
                    '\t\t\t\t<td style="width: 112.6pt; border-top: 1pt solid windowtext; border-right: 1pt solid windowtext; border-bottom: 1pt solid windowtext; border-left: none; padding: 0cm 5.4pt; height: 1cm;" width="150">\n' +
                    '\t\t\t\t\t<p align="left" class="MsoNormal">\n' +
                    '\t\t\t\t\t\t<span style="font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;color:black;\n' +
                    '  mso-font-kerning:0pt">申请经费（万元）<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '\t\t\t\t</td>\n' +
                    '\t\t\t\t<td style="width: 148.85pt; border-top: 1pt solid windowtext; border-right: 1pt solid windowtext; border-bottom: 1pt solid windowtext; border-left: none; padding: 0cm 5.4pt; height: 1cm;" width="198">\n' +
                    '\t\t\t\t\t<p align="left" class="MsoNormal">\n' +
                    '\t\t\t\t\t\t<span style="font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;color:black;\n' +
                    '  mso-font-kerning:0pt">备注（计算依据与说明<span lang="EN-US">)<o:p></o:p></span></span></p>\n' +
                    '\t\t\t\t</td>\n' +
                    '\t\t\t</tr>\n' +
                    '\t\t\t<tr style="mso-yfti-irow:1;height:1.0cm">\n' +
                    '\t\t\t\t<td style="width: 173pt; border-right: 1pt solid windowtext; border-bottom: 1pt solid windowtext; border-left: 1pt solid windowtext; border-top: none; padding: 0cm 5.4pt; height: 1cm;" width="231">\n' +
                    '\t\t\t\t\t<p align="left" class="MsoNormal">\n' +
                    '\t\t\t\t\t\t<span style="font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;color:black;\n' +
                    '  mso-font-kerning:0pt">一、研究经费<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '\t\t\t\t</td>\n' +
                    '\t\t\t\t<td style="width:112.6pt;border-top:none;border-left:none;\n' +
                    '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;\n' +
                    '  mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;\n' +
                    '  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm" width="150">\n' +
                    '\t\t\t\t\t<p align="left" class="MsoNormal">\n' +
                    '\t\t\t\t\t\t<span style="font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;color:black;\n' +
                    '  mso-font-kerning:0pt">　<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '\t\t\t\t</td>\n' +
                    '\t\t\t\t<td style="width:148.85pt;border-top:none;border-left:none;\n' +
                    '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;\n' +
                    '  mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;\n' +
                    '  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm" width="198">\n' +
                    '\t\t\t\t\t<p align="left" class="MsoNormal">\n' +
                    '\t\t\t\t\t\t<span style="font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;color:black;\n' +
                    '  mso-font-kerning:0pt">　<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '\t\t\t\t</td>\n' +
                    '\t\t\t</tr>\n' +
                    '\t\t\t<tr style="mso-yfti-irow:2;height:1.0cm">\n' +
                    '\t\t\t\t<td style="width: 173pt; border-right: 1pt solid windowtext; border-bottom: 1pt solid windowtext; border-left: 1pt solid windowtext; border-top: none; padding: 0cm 5.4pt; height: 1cm;" width="231">\n' +
                    '\t\t\t\t\t<p align="left" class="MsoNormal">\n' +
                    '\t\t\t\t\t\t<span lang="EN-US" style="font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;\n' +
                    '  color:black;mso-font-kerning:0pt">1.</span><span style="font-size:12.0pt;\n' +
                    '  font-family:宋体;mso-bidi-font-family:宋体;color:black;mso-font-kerning:0pt">科研业务费<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '\t\t\t\t</td>\n' +
                    '\t\t\t\t<td style="width:112.6pt;border-top:none;border-left:none;\n' +
                    '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;\n' +
                    '  mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;\n' +
                    '  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm" width="150">\n' +
                    '\t\t\t\t\t<p align="left" class="MsoNormal">\n' +
                    '\t\t\t\t\t\t<span style="font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;color:black;\n' +
                    '  mso-font-kerning:0pt">　<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '\t\t\t\t</td>\n' +
                    '\t\t\t\t<td style="width:148.85pt;border-top:none;border-left:none;\n' +
                    '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;\n' +
                    '  mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;\n' +
                    '  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm" width="198">\n' +
                    '\t\t\t\t\t<p align="left" class="MsoNormal">\n' +
                    '\t\t\t\t\t\t<span style="font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;color:black;\n' +
                    '  mso-font-kerning:0pt">　<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '\t\t\t\t</td>\n' +
                    '\t\t\t</tr>\n' +
                    '\t\t\t<tr style="mso-yfti-irow:3;height:1.0cm">\n' +
                    '\t\t\t\t<td style="width: 173pt; border-right: 1pt solid windowtext; border-bottom: 1pt solid windowtext; border-left: 1pt solid windowtext; border-top: none; padding: 0cm 5.4pt; height: 1cm;" width="231">\n' +
                    '\t\t\t\t\t<p align="left" class="MsoNormal">\n' +
                    '\t\t\t\t\t\t<span lang="EN-US" style="font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;\n' +
                    '  color:black;mso-font-kerning:0pt">2.</span><span style="font-size:12.0pt;\n' +
                    '  font-family:宋体;mso-bidi-font-family:宋体;color:black;mso-font-kerning:0pt">实验材料费<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '\t\t\t\t</td>\n' +
                    '\t\t\t\t<td style="width:112.6pt;border-top:none;border-left:none;\n' +
                    '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;\n' +
                    '  mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;\n' +
                    '  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm" width="150">\n' +
                    '\t\t\t\t\t<p align="left" class="MsoNormal">\n' +
                    '\t\t\t\t\t\t<span style="font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;color:black;\n' +
                    '  mso-font-kerning:0pt">　<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '\t\t\t\t</td>\n' +
                    '\t\t\t\t<td style="width:148.85pt;border-top:none;border-left:none;\n' +
                    '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;\n' +
                    '  mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;\n' +
                    '  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm" width="198">\n' +
                    '\t\t\t\t\t<p align="left" class="MsoNormal">\n' +
                    '\t\t\t\t\t\t<span style="font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;color:black;\n' +
                    '  mso-font-kerning:0pt">　<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '\t\t\t\t</td>\n' +
                    '\t\t\t</tr>\n' +
                    '\t\t\t<tr style="mso-yfti-irow:4;height:1.0cm">\n' +
                    '\t\t\t\t<td style="width: 173pt; border-right: 1pt solid windowtext; border-bottom: 1pt solid windowtext; border-left: 1pt solid windowtext; border-top: none; padding: 0cm 5.4pt; height: 1cm;" width="231">\n' +
                    '\t\t\t\t\t<p align="left" class="MsoNormal">\n' +
                    '\t\t\t\t\t\t<span lang="EN-US" style="font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;\n' +
                    '  color:black;mso-font-kerning:0pt">3.</span><span style="font-size:12.0pt;\n' +
                    '  font-family:宋体;mso-bidi-font-family:宋体;color:black;mso-font-kerning:0pt">仪器设备费<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '\t\t\t\t</td>\n' +
                    '\t\t\t\t<td style="width:112.6pt;border-top:none;border-left:none;\n' +
                    '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;\n' +
                    '  mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;\n' +
                    '  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm" width="150">\n' +
                    '\t\t\t\t\t<p align="left" class="MsoNormal">\n' +
                    '\t\t\t\t\t\t<span style="font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;color:black;\n' +
                    '  mso-font-kerning:0pt">　<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '\t\t\t\t</td>\n' +
                    '\t\t\t\t<td style="width:148.85pt;border-top:none;border-left:none;\n' +
                    '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;\n' +
                    '  mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;\n' +
                    '  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm" width="198">\n' +
                    '\t\t\t\t\t<p align="left" class="MsoNormal">\n' +
                    '\t\t\t\t\t\t<span style="font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;color:black;\n' +
                    '  mso-font-kerning:0pt">　<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '\t\t\t\t</td>\n' +
                    '\t\t\t</tr>\n' +
                    '\t\t\t<tr style="mso-yfti-irow:5;height:1.0cm">\n' +
                    '\t\t\t\t<td style="width: 173pt; border-right: 1pt solid windowtext; border-bottom: 1pt solid windowtext; border-left: 1pt solid windowtext; border-top: none; padding: 0cm 5.4pt; height: 1cm;" width="231">\n' +
                    '\t\t\t\t\t<p align="left" class="MsoNormal">\n' +
                    '\t\t\t\t\t\t<span lang="EN-US" style="font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;\n' +
                    '  color:black;mso-font-kerning:0pt">4.</span><span style="font-size:12.0pt;\n' +
                    '  font-family:宋体;mso-bidi-font-family:宋体;color:black;mso-font-kerning:0pt">动物实验费<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '\t\t\t\t</td>\n' +
                    '\t\t\t\t<td style="width:112.6pt;border-top:none;border-left:none;\n' +
                    '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;\n' +
                    '  mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;\n' +
                    '  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm" width="150">\n' +
                    '\t\t\t\t\t&nbsp;</td>\n' +
                    '\t\t\t\t<td style="width:148.85pt;border-top:none;border-left:none;\n' +
                    '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;\n' +
                    '  mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;\n' +
                    '  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm" width="198">\n' +
                    '\t\t\t\t\t&nbsp;</td>\n' +
                    '\t\t\t</tr>\n' +
                    '\t\t\t<tr style="mso-yfti-irow:6;height:1.0cm">\n' +
                    '\t\t\t\t<td style="width: 173pt; border-right: 1pt solid windowtext; border-bottom: 1pt solid windowtext; border-left: 1pt solid windowtext; border-top: none; padding: 0cm 5.4pt; height: 1cm;" width="231">\n' +
                    '\t\t\t\t\t<p align="left" class="MsoNormal">\n' +
                    '\t\t\t\t\t\t<span lang="EN-US" style="font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;\n' +
                    '  color:black;mso-font-kerning:0pt">5.</span><span style="font-size:12.0pt;\n' +
                    '  font-family:宋体;mso-bidi-font-family:宋体;color:black;mso-font-kerning:0pt">协作费<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '\t\t\t\t</td>\n' +
                    '\t\t\t\t<td style="width:112.6pt;border-top:none;border-left:none;\n' +
                    '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;\n' +
                    '  mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;\n' +
                    '  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm" width="150">\n' +
                    '\t\t\t\t\t<p align="left" class="MsoNormal">\n' +
                    '\t\t\t\t\t\t<span style="font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;color:black;\n' +
                    '  mso-font-kerning:0pt">　<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '\t\t\t\t</td>\n' +
                    '\t\t\t\t<td style="width:148.85pt;border-top:none;border-left:none;\n' +
                    '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;\n' +
                    '  mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;\n' +
                    '  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm" width="198">\n' +
                    '\t\t\t\t\t<p align="left" class="MsoNormal">\n' +
                    '\t\t\t\t\t\t<span style="font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;color:black;\n' +
                    '  mso-font-kerning:0pt">　<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '\t\t\t\t</td>\n' +
                    '\t\t\t</tr>\n' +
                    '\t\t\t<tr style="mso-yfti-irow:7;height:1.0cm">\n' +
                    '\t\t\t\t<td style="width: 173pt; border-right: 1pt solid windowtext; border-bottom: 1pt solid windowtext; border-left: 1pt solid windowtext; border-top: none; padding: 0cm 5.4pt; height: 1cm;" width="231">\n' +
                    '\t\t\t\t\t<p align="left" class="MsoNormal">\n' +
                    '\t\t\t\t\t\t<span style="font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;color:black;\n' +
                    '  mso-font-kerning:0pt">二、合作与交流费<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '\t\t\t\t</td>\n' +
                    '\t\t\t\t<td style="width:112.6pt;border-top:none;border-left:none;\n' +
                    '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;\n' +
                    '  mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;\n' +
                    '  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm" width="150">\n' +
                    '\t\t\t\t\t<p align="left" class="MsoNormal">\n' +
                    '\t\t\t\t\t\t<span style="font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;color:black;\n' +
                    '  mso-font-kerning:0pt">　<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '\t\t\t\t</td>\n' +
                    '\t\t\t\t<td style="width:148.85pt;border-top:none;border-left:none;\n' +
                    '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;\n' +
                    '  mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;\n' +
                    '  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm" width="198">\n' +
                    '\t\t\t\t\t<p align="left" class="MsoNormal">\n' +
                    '\t\t\t\t\t\t<span style="font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;color:black;\n' +
                    '  mso-font-kerning:0pt">　<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '\t\t\t\t</td>\n' +
                    '\t\t\t</tr>\n' +
                    '\t\t\t<tr style="mso-yfti-irow:8;height:1.0cm">\n' +
                    '\t\t\t\t<td style="width: 173pt; border-right: 1pt solid windowtext; border-bottom: 1pt solid windowtext; border-left: 1pt solid windowtext; border-top: none; padding: 0cm 5.4pt; height: 1cm;" width="231">\n' +
                    '\t\t\t\t\t<p align="left" class="MsoNormal">\n' +
                    '\t\t\t\t\t\t<span lang="EN-US" style="font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;\n' +
                    '  color:black;mso-font-kerning:0pt">1.</span><span style="font-size:12.0pt;\n' +
                    '  font-family:宋体;mso-bidi-font-family:宋体;color:black;mso-font-kerning:0pt">会议<span lang="EN-US">/</span>会务费<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '\t\t\t\t</td>\n' +
                    '\t\t\t\t<td style="width:112.6pt;border-top:none;border-left:none;\n' +
                    '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;\n' +
                    '  mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;\n' +
                    '  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm" width="150">\n' +
                    '\t\t\t\t\t<p align="left" class="MsoNormal">\n' +
                    '\t\t\t\t\t\t<span style="font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;color:black;\n' +
                    '  mso-font-kerning:0pt">　<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '\t\t\t\t</td>\n' +
                    '\t\t\t\t<td style="width:148.85pt;border-top:none;border-left:none;\n' +
                    '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;\n' +
                    '  mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;\n' +
                    '  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm" width="198">\n' +
                    '\t\t\t\t\t<p align="left" class="MsoNormal">\n' +
                    '\t\t\t\t\t\t<span style="font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;color:black;\n' +
                    '  mso-font-kerning:0pt">　<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '\t\t\t\t</td>\n' +
                    '\t\t\t</tr>\n' +
                    '\t\t\t<tr style="mso-yfti-irow:9;height:1.0cm">\n' +
                    '\t\t\t\t<td style="width: 173pt; border-right: 1pt solid windowtext; border-bottom: 1pt solid windowtext; border-left: 1pt solid windowtext; border-top: none; padding: 0cm 5.4pt; height: 1cm;" width="231">\n' +
                    '\t\t\t\t\t<p align="left" class="MsoNormal">\n' +
                    '\t\t\t\t\t\t<span lang="EN-US" style="font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;\n' +
                    '  color:black;mso-font-kerning:0pt">2.</span><span style="font-size:12.0pt;\n' +
                    '  font-family:宋体;mso-bidi-font-family:宋体;color:black;mso-font-kerning:0pt">差旅费<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '\t\t\t\t</td>\n' +
                    '\t\t\t\t<td style="width:112.6pt;border-top:none;border-left:none;\n' +
                    '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;\n' +
                    '  mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;\n' +
                    '  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm" width="150">\n' +
                    '\t\t\t\t\t<p align="left" class="MsoNormal">\n' +
                    '\t\t\t\t\t\t<span style="font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;color:black;\n' +
                    '  mso-font-kerning:0pt">　<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '\t\t\t\t</td>\n' +
                    '\t\t\t\t<td style="width:148.85pt;border-top:none;border-left:none;\n' +
                    '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;\n' +
                    '  mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;\n' +
                    '  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm" width="198">\n' +
                    '\t\t\t\t\t<p align="left" class="MsoNormal">\n' +
                    '\t\t\t\t\t\t<span style="font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;color:black;\n' +
                    '  mso-font-kerning:0pt">　<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '\t\t\t\t</td>\n' +
                    '\t\t\t</tr>\n' +
                    '\t\t\t<tr style="mso-yfti-irow:10;height:1.0cm">\n' +
                    '\t\t\t\t<td style="width: 173pt; border-right: 1pt solid windowtext; border-bottom: 1pt solid windowtext; border-left: 1pt solid windowtext; border-top: none; padding: 0cm 5.4pt; height: 1cm;" width="231">\n' +
                    '\t\t\t\t\t<p align="left" class="MsoNormal">\n' +
                    '\t\t\t\t\t\t<span style="font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;color:black;\n' +
                    '  mso-font-kerning:0pt">三、劳务费<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '\t\t\t\t</td>\n' +
                    '\t\t\t\t<td style="width:112.6pt;border-top:none;border-left:none;\n' +
                    '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;\n' +
                    '  mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;\n' +
                    '  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm" width="150">\n' +
                    '\t\t\t\t\t<p align="left" class="MsoNormal">\n' +
                    '\t\t\t\t\t\t<span style="font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;color:black;\n' +
                    '  mso-font-kerning:0pt">　<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '\t\t\t\t</td>\n' +
                    '\t\t\t\t<td style="width:148.85pt;border-top:none;border-left:none;\n' +
                    '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;\n' +
                    '  mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;\n' +
                    '  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm" width="198">\n' +
                    '\t\t\t\t\t&nbsp;</td>\n' +
                    '\t\t\t</tr>\n' +
                    '\t\t\t<tr style="mso-yfti-irow:11;height:1.0cm">\n' +
                    '\t\t\t\t<td style="width: 173pt; border-right: 1pt solid windowtext; border-bottom: 1pt solid windowtext; border-left: 1pt solid windowtext; border-top: none; padding: 0cm 5.4pt; height: 1cm;" width="231">\n' +
                    '\t\t\t\t\t<p align="left" class="MsoNormal">\n' +
                    '\t\t\t\t\t\t<span style="font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;color:black;\n' +
                    '  mso-font-kerning:0pt">四、管理费<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '\t\t\t\t</td>\n' +
                    '\t\t\t\t<td style="width:112.6pt;border-top:none;border-left:none;\n' +
                    '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;\n' +
                    '  mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;\n' +
                    '  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm" width="150">\n' +
                    '\t\t\t\t\t<p align="left" class="MsoNormal">\n' +
                    '\t\t\t\t\t\t<span style="font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;color:black;\n' +
                    '  mso-font-kerning:0pt">　<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '\t\t\t\t</td>\n' +
                    '\t\t\t\t<td style="width:148.85pt;border-top:none;border-left:none;\n' +
                    '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;\n' +
                    '  mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;\n' +
                    '  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm" width="198">\n' +
                    '\t\t\t\t\t&nbsp;</td>\n' +
                    '\t\t\t</tr>\n' +
                    '\t\t\t<tr style="mso-yfti-irow:12;height:1.0cm">\n' +
                    '\t\t\t\t<td style="width: 173pt; border-right: 1pt solid windowtext; border-bottom: 1pt solid windowtext; border-left: 1pt solid windowtext; border-top: none; padding: 0cm 5.4pt; height: 1cm;" width="231">\n' +
                    '\t\t\t\t\t<p align="left" class="MsoNormal">\n' +
                    '\t\t\t\t\t\t<span style="font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;color:black;\n' +
                    '  mso-font-kerning:0pt">五、其他<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '\t\t\t\t</td>\n' +
                    '\t\t\t\t<td style="width:112.6pt;border-top:none;border-left:none;\n' +
                    '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;\n' +
                    '  mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;\n' +
                    '  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm" width="150">\n' +
                    '\t\t\t\t\t&nbsp;</td>\n' +
                    '\t\t\t\t<td style="width:148.85pt;border-top:none;border-left:none;\n' +
                    '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;\n' +
                    '  mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;\n' +
                    '  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm" width="198">\n' +
                    '\t\t\t\t\t&nbsp;</td>\n' +
                    '\t\t\t</tr>\n' +
                    '\t\t\t<tr style="mso-yfti-irow:13;mso-yfti-lastrow:yes;height:1.0cm">\n' +
                    '\t\t\t\t<td style="width: 173pt; border-right: 1pt solid windowtext; border-bottom: 1pt solid windowtext; border-left: 1pt solid windowtext; border-top: none; padding: 0cm 5.4pt; height: 1cm;" width="231">\n' +
                    '\t\t\t\t\t<p align="left" class="MsoNormal">\n' +
                    '\t\t\t\t\t\t<span style="font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;color:black;\n' +
                    '  mso-font-kerning:0pt">合计<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '\t\t\t\t</td>\n' +
                    '\t\t\t\t<td style="width:112.6pt;border-top:none;border-left:none;\n' +
                    '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;\n' +
                    '  mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;\n' +
                    '  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm" width="150">\n' +
                    '\t\t\t\t\t<p align="left" class="MsoNormal">\n' +
                    '\t\t\t\t\t\t<span style="font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;color:black;\n' +
                    '  mso-font-kerning:0pt">　<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '\t\t\t\t</td>\n' +
                    '\t\t\t\t<td style="width:148.85pt;border-top:none;border-left:none;\n' +
                    '  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;\n' +
                    '  mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;\n' +
                    '  padding:0cm 5.4pt 0cm 5.4pt;height:1.0cm" width="198">\n' +
                    '\t\t\t\t\t<p align="left" class="MsoNormal">\n' +
                    '\t\t\t\t\t\t<span style="font-size:12.0pt;font-family:宋体;mso-bidi-font-family:宋体;color:black;\n' +
                    '  mso-font-kerning:0pt">　<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '\t\t\t\t</td>\n' +
                    '\t\t\t</tr>\n' +
                    '\t\t</tbody>\n' +
                    '\t</table>\n' +
                    '</div>\n' +
                    '<p align="left" class="MsoNormal" style="margin: 7.8pt 0cm 0.0001pt 28pt; text-indent: -28pt; line-height: 150%;">\n' +
                    '\t<span lang="EN-US" style="font-size:14.0pt;line-height:150%;font-family:宋体;mso-bidi-font-family:\n' +
                    '宋体;mso-font-kerning:0pt">&nbsp;</span></p>\n' +
                    '<p align="left" class="MsoNormal" style="margin: 7.8pt 0cm 0.0001pt 28.05pt; text-indent: 21pt; line-height: 150%;">\n' +
                    '\t<span style="font-size:14.0pt;line-height:150%;font-family:宋体;mso-bidi-font-family:\n' +
                    '宋体;mso-font-kerning:0pt">乙方负责人：<span lang="EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>丙方负责人：<span lang="EN-US"><o:p></o:p></span></span></p>\n' +
                    '<p align="left" class="MsoNormal" style="text-indent: 49pt;">\n' +
                    '\t<u><span lang="EN-US" style="font-size:14.0pt;\n' +
                    'font-family:宋体;mso-bidi-font-family:宋体;mso-font-kerning:0pt">&nbsp;&nbsp;&nbsp; </span></u><span style="font-size:14.0pt;\n' +
                    'font-family:宋体;mso-bidi-font-family:宋体;mso-font-kerning:0pt">年<u><span lang="EN-US">&nbsp; </span></u>月<u><span lang="EN-US">&nbsp; </span></u>日<span lang="EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<u>&nbsp;&nbsp;&nbsp;&nbsp;</u></span>年<u><span lang="EN-US">&nbsp; </span></u>月<u><span lang="EN-US">&nbsp; </span></u>日</span><span lang="EN-US"><o:p></o:p></span></p>\n' +
                    '<p class="MsoNormal">\n' +
                    '\t<span lang="EN-US">&nbsp;</span></p>');
			}
			$("#inputForm").validate({
				submitHandler: function(form){
					if (CKEDITOR.instances.content.getData()==""){
						top.$.jBox.tip('请填写正文','warning');
					}else{
						loading('正在提交，请稍等...');
						form.submit();
					}
				},
				errorContainer: "#messageBox",
				errorPlacement: function(error, element) {
					$("#messageBox").text("输入有误，请先更正。");
					if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
						error.appendTo(element.parent().parent());
					} else {
						error.insertAfter(element);
					}
				}
			});

		});
		function exportWord() {
            $("#page-content").html($("#contentContract").val());
            $("#page-content").wordExport("合同书");
        }
        function rebookSubmit(reApply) {
            var taskId = $('#taskId').val();
            complete(taskId, [ {
                key : 'reApply',
                value : reApply,
                type : 'B'
            }, {
                key : 'remarks',
                value : $('#remarks').val(),
                type : 'S'
            }, {
                key : 'contentContract',
                value : $('#contentContract').val(),
                type : 'S'
            }]);
        }

        function complete(taskId, variables) {
            var keys = "", values = "", types = "";
            if (variables) {
                $.each(variables, function() {
                    if (keys != "") {
                        keys += "|";
                        values += "|";
                        types += "|";
                    }
                    keys += this.key;
                    values += this.value;
                    types += this.type;
                });
            }
            var jsonData = JSON.stringify(variables);
            $.post('${ctx}/oa/workflow/complete/' + taskId, {
                keys : keys,
                values : values,
                types : types
            }, function(resp) {
                if (resp == 'success') {
                    top.$.jBox.tip('任务完成');
                    inputForm.action = "${ctx}/oa/projectData";
                    inputForm.submit();
                } else {
                    top.$.jBox.tip('操作失败!');
                }
            });
        }
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/oa/projectData/list">合同列表</a></li>
		<li><a href="${ctx}/oa/projectData/task">待办任务</a></li>
		<li class="active"><a href="javascript:void(0);">合同详情</a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="projectData" action="${ctx}/oa/projectData/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<input type="hidden" id="taskId" value="${taskId}" />
		<input type="hidden" id="projectDataId" value="${projectDataId}" />
		<tags:message content="${message}"/>
		<div class="control-group">
			<label class="control-label">备注:</label>
			<div class="controls">
				<form:input path="remarks" htmlEscape="false" maxlength="200" class="input-xxlarge"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">合同内容:</label>
			<div class="controls">
				<form:textarea id="contentContract" htmlEscape="true" path="contentContract" rows="4" maxlength="200" class="input-xxlarge"/>
				<tags:ckeditor replace="contentContract" uploadPath="/oa/projectData" />
			</div>
		</div>
		<div style="display: none" id="page-content"></div>
		<div class="form-actions">
			<c:if test="${empty taskId}">
				<input id="btnSubmit" class="btn btn-primary" type="submit" value="保存提交" />
			</c:if>
			<c:if test="${not empty taskId}">
				<input id="btnReSubmit" class="btn btn-primary" type="button" onclick="rebookSubmit(true)"
					   value="重新申请" />&nbsp;
				<input id="btnRefuseSubmit" class="btn btn-primary" type="button" onclick="rebookSubmit(false)" value="放弃申请" />&nbsp;
			</c:if>
			<a class="btn btn-primary" onclick="CKEDITOR.tools.callFunction(10, this); return false;">预 览</a>
			<a class="btn btn-primary" onclick="CKEDITOR.tools.callFunction(28, this); return false;">打 印</a>
			<a class="btn btn-primary" onclick="exportWord()" >导 出</a>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>