<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>个人信息</title>
<link href="${ctxStatic}/jquery-jbox/2.3/Skins/Bootstrap/jbox.css" rel="stylesheet" />
<script src="${ctxStatic}/jquery-jbox/2.3/jquery.jBox-2.3.min.js" type="text/javascript"></script>
<script src="${ctxStatic}/jquery-jbox/2.3/i18n/jquery.jBox-zh-CN.min.js" type="text/javascript"></script>
	<script src="${ctxStatic}/bootstrap/2.3.1/js/bootstrap.min.js"></script>
	<link href="${ctxStatic}/bootstrap/2.3.1/css_default/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<script src="${ctxStatic}/common/portrait.js" type="text/javascript"></script>
	<link href="${ctxStatic}/common/portrait.css" type="text/css" rel="stylesheet" />
<meta name="decorator" content="default" />
<script type="text/javascript">
	$(document).ready(
			function() {
				changChild("${user.prefression}");
				$("#inputForm")
						.validate(
								{
									submitHandler : function(form) {
										loading('正在提交，请稍等...');
										form.submit();
									},
									errorContainer : "#messageBox",
									errorPlacement : function(error, element) {
										$("#messageBox").text("输入有误，请先更正。");
										if (element.is(":checkbox")
												|| element.is(":radio")
												|| element.parent().is(
														".input-append")) {
											error.appendTo(element.parent()
													.parent());
										} else {
											error.insertAfter(element);
										}
									}
								});
			});

	function changChild(tid) {
		if (!tid) {
			tid = "0";
		}
		$.post("${ctx}/sys/dict/childSelect", {
			"tid" : tid
		}, function(json) {
			$("#title").empty();
			for (var i = 0; i < json.length; i++) {
				if(json[i].value == "${user.title}"){
					$("#title").append(
							"<option selected value='"+json[i].value+"'>" + json[i].label
									+ "</option>");
				}
				else{
					$("#title").append(
							"<option value='"+json[i].value+"'>" + json[i].label
									+ "</option>");
				}
			}
		}, 'json');
	}

    function saveUserEducation(){
        top.$.jBox("<div style='padding:20px;'>"
			+"<div class='control-group'>" + "<div class='controls'>" + "<label class='control-label'>学校名称:&nbsp;</label>"  + "<input id='schoolName' name='schoolName' type='text' />" + "</div>" + "</div>"
            +"<div class='control-group'>" + "<div class='controls'>" + "<label class='control-label'>专业:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>" + "<input id='prefression' name='prefression' type='text' />" + "</div>" + "</div>"
            +"<div class='control-group'>" + "<div class='controls'>" + "<label class='control-label'>起始时间:&nbsp;</label>" + "<input id=\"startDate\" name=\"startDate\" type=\"text\"\ maxlength=\"20\" class=\"input-medium Wdate\" value=\"${startDate}\" onclick=\"WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});\"/>" + "</div>" + "</div>"
            +"<div class='control-group'>" + "<div class='controls'>" + "<label class='control-label'>结束时间:&nbsp;</label>"  + "<input id=\"endDate\" name=\"endDate\" type=\"text\"\ maxlength=\"20\" class=\"input-medium Wdate\" value=\"${endDate}\" onclick=\"WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});\"/>" + "</div>" + "</div>"
            +"<div class='control-group'>" + "<div class='controls'>" + "<label class='control-label'>学历:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>"+ "<select id='degree' name='degree'>" + "<c:forEach items='${fns:getDictList("degree")}' var='level'>" + "<option value=\"${level.value}\">${level.label}</option>" + "</c:forEach>" + "</select>" + "</div>" + "</div>"
            +"<div class='control-group'>" + "<div class='controls'>" + "<label class='control-label'>学位:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>"+ "<select id='educationalBackground' name='educationalBackground'>" + "<c:forEach items='${fns:getDictList("educational_background")}' var='level'>" + "<option value=\"${level.value}\">${level.label}</option>" + "</c:forEach>" + "</select>" + "</div>" + "</div>"
            +"<div class='control-group'>" + "<div class='controls'>" + "<label class='control-label'>导师:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>"+ "<input id='graduateAdvisor' name='graduateAdvisor' type='text' />" + "</div>" + "</div>" + "</div>"
			,{title: "填写学习经历",
                submit: function () {
                    var schoolName = top.$("#schoolName").val();
                    var prefression = top.$("#prefression").val();
                    var startDate = top.$("#startDate").val();
                    var endDate = top.$("#endDate").val();
                    var degree = top.$("#degree").val();
                    var educationalBackground = top.$("#educationalBackground").val();
                    var graduateAdvisor = top.$("#graduateAdvisor").val();

                    $.ajax({
                        type: "POST",
                        dataType: "json",
                        traditional: true,
                        url: "${ctx}/sys/user/saveEducation",
                        data: {"schoolName": schoolName,"prefression": prefression,"startDate": startDate,
							"endDate": endDate,"degree": degree,"educationalBackground": educationalBackground,"graduateAdvisor": graduateAdvisor},
                        success: function(data) {
                            top.$.jBox.tip('保存完成');
                            location.reload();
                        },
                        error: function() {
                            top.$.jBox.tip('操作失败!');
                        }
                    });
                }
            });
    }
    function saveUserWork(){
        top.$.jBox("<div style='padding:20px;'>"
            +"<div class='control-group'>" + "<div class='controls'>" + "<label class='control-label'>单位名称:&nbsp;</label>"  + "<input id='companyName' name='companyName' type='text' />" + "</div>" + "</div>"
            +"<div class='control-group'>" + "<div class='controls'>" + "<label class='control-label'>科室:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>"+ "<select id='officeId' name='officeId'>" + "<c:forEach items='${fns:getDictList("office")}' var='level'>" + "<option value=\"${level.value}\">${level.label}</option>" + "</c:forEach>" + "</select>" + "</div>" + "</div>"
            +"<div class='control-group'>" + "<div class='controls'>" + "<label class='control-label'>起始时间:&nbsp;</label>" + "<input id=\"startDate\" name=\"startDate\" type=\"text\"\ maxlength=\"20\" class=\"input-medium Wdate\" value=\"${startDate}\" onclick=\"WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});\"/>" + "</div>" + "</div>"
            +"<div class='control-group'>" + "<div class='controls'>" + "<label class='control-label'>结束时间:&nbsp;</label>"  + "<input id=\"endDate\" name=\"endDate\" type=\"text\"\ maxlength=\"20\" class=\"input-medium Wdate\" value=\"${endDate}\" onclick=\"WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});\"/>" + "</div>" + "</div>"
            +"<div class='control-group'>" + "<div class='controls'>" + "<label class='control-label'>教学职称:&nbsp;</label>"+ "<select id='title' name='title'>" + "<c:forEach items='${fns:getDictList("professional_title")}' var='level'>" + "<option value=\"${level.value}\">${level.label}</option>" + "</c:forEach>" + "</select>" + "</div>" + "</div>"
            +"<div class='control-group'>" + "<div class='controls'>" + "<label class='control-label'>职务:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>"+ "<select id='post' name='post'>" + "<c:forEach items='${fns:getDictList("acad_exercise_role")}' var='level'>" + "<option value=\"${level.value}\">${level.label}</option>" + "</c:forEach>" + "</select>" + "</div>" + "</div>"+ "</div>"
            ,{title: "填写工作经历",
                submit: function () {
                    var companyName = top.$("#companyName").val();
                    var officeId = top.$("#officeId").val();
                    var startDate = top.$("#startDate").val();
                    var endDate = top.$("#endDate").val();
                    var title = top.$("#title").val();
                    var post = top.$("#post").val();
                    $.ajax({
                        type: "POST",
                        dataType: "json",
                        traditional: true,
                        url: "${ctx}/sys/user/saveWork",
                        data: {"companyName": companyName,"officeId": officeId,"startDate": startDate,
                            "endDate": endDate,"title": title,"post": post},
                        success: function(data) {
                            top.$.jBox.tip('保存完成');
                            location.reload();
                        },
                        error: function() {
                            top.$.jBox.tip('操作失败!');
                        }
                    });
                }
            });
    }

</script>
	<script>
        $(function(){
            var img2 = new ImgUpload('.imgLog2',140,160,160);

            $(document).on('change',".imgLog2 input",function(e){
                //模拟后台返回url
                var url = window.URL.createObjectURL(e.target.files[0]);
                $(this).parent().css('background','url('+url+')0% 0% / cover')
                img2.setSpan(this)
            });

        })

	</script>

</head>
<body>
	<br />
	<form:form id="inputForm" modelAttribute="user" action="${ctx}/sys/user/infoSave" method="post" enctype="multipart/form-data" class="form-horizontal">
		<tags:message content="${message}" />
		<%--<div class="content">
			<img src="${ctxStatic}/images/header.png" class="img-rounded">
			<input id="file" name="file" type="hidden" />
			<input id="fileupload" type="file" name="files[]" multiple="multiple" data-url="${ctx}/oa/project/upload/project">
		</div>--%>
		<div class="box">
			<p>
			<div class="upload imgLog2" style="background: url('D:\works\gitworks\hsr\classes\artifacts\hsr_war_exploded\avatorImg/head_10000//lilu2.jpg');">
				<span><i class="glyphicon glyphicon-open"></i>上传头像</span>
			</div>
			</p>
		</div>

		<div class="control-group">
			<label class="control-label">归属医院:</label>
			<div class="controls">
				<label class="lbl">${user.company.name}</label>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">归属科室:</label>
			<div class="controls">
				<c:if test="${user.initInfo eq false}">
					<tags:treeselect id="office" name="office.id" value="${user.office.id}" labelName="office.name" labelValue=""
						title="科室" url="/sys/office/treeData?type=2" notAllowSelectParent="true" cssClass="required" />
				</c:if>
				<c:if test="${user.initInfo eq true }">
					<tags:treeselect id="office" name="office.id" value="${user.office.id}" labelName="office.name"
						labelValue="${user.office.name}" title="科室" url="/sys/office/treeData?type=2" notAllowSelectParent="true"
						cssClass="required" />
				</c:if>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">姓名:</label>
			<div class="controls">
				<form:input path="name" htmlEscape="false" maxlength="50" class="required" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">身份证:</label>
			<div class="controls">
				<form:input path="idCard" htmlEscape="false" maxlength="50" class="required" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">性别:</label>
			<div class="controls">
				<form:select path="sex">
					<form:options items="${fns:getDictList('sex')}" itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">出生年月:</label>
			<div class="controls">
				<input id="birthday" name="birthday" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="${user.birthday}" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">党派:</label>
			<div class="controls">
				<form:select path="party">
					<option value=""></option>
					<form:options items="${fns:getDictList('party')}" itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">民族:</label>
			<div class="controls">
				<form:select path="nation">
					<form:options items="${fns:getDictList('nation')}" itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select>
			</div>
		</div>

		<div class="control-group">
			<label class="control-label">学历:</label>
			<div class="controls">
				<form:select path="degree">
					<form:options items="${fns:getDictList('degree')}" itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">学位:</label>
			<div class="controls">
				<form:select path="educationalBackground">
					<option value=""></option>
					<form:options items="${fns:getDictList('educational_background')}" itemLabel="label" itemValue="value"
						htmlEscape="false" />
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">研究生导师:</label>
			<div class="controls">
				<form:select path="graduateAdvisor">
					<option value=""></option>
					<form:options items="${fns:getDictList('graduate_advisor')}" itemLabel="label" itemValue="value"
						htmlEscape="false" />
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">教学职称:</label>
			<div class="controls">
				<form:select path="professionalTitle">
					<option value=""></option>
					<form:options items="${fns:getDictList('professional_title')}" itemLabel="label" itemValue="value"
						htmlEscape="false" />
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">专业:</label>
			<div class="controls">
				<form:select path="prefression" onchange="changChild(this.value)">
					<form:options items="${fns:getDictList('prefression')}" itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select>
			</div>
			<br> <label class="control-label">职称:</label>
			<div class="controls">
				<form:select id="title" path="title">
					<form:options items="${fns:getDictList(userTitle)}" itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">职务:</label>
			<div class="controls">
				<form:select path="post">
					<option value=""></option>
					<form:options items="${fns:getDictList('acad_exercise_role')}" itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">邮箱:</label>
			<div class="controls">
				<form:input path="email" htmlEscape="false" maxlength="50" class="email" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">电话:</label>
			<div class="controls">
				<form:input path="phone" htmlEscape="false" maxlength="50" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">手机:</label>
			<div class="controls">
				<form:input path="mobile" htmlEscape="false" maxlength="50" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">籍贯:</label>
			<div class="controls">
				<form:input path="nativePlace" htmlEscape="false" maxlength="50" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">联系地址:</label>
			<div class="controls">
				<form:input path="contactAddress" htmlEscape="false" maxlength="50" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">学习经历:</label>
			<div class="controls">
				<table id="contentTable" class="table table-striped table-bordered table-condensed" style="width: 550px;">
					<tr>
						<th>起始时间</th>
						<th>结束时间</th>
						<th>学校名称</th>
						<th>专业</th>
						<th>学历/学位</th>
						<th>导师</th>
						<th>操作</th>
					</tr>
					<tbody>
					<c:forEach items="${user.uedList}" var="education">
						<tr>
							<td><fmt:formatDate value="${education.startDate}" pattern="yyyy-MM-dd" type="both"/></td>
							<td><fmt:formatDate value="${education.endDate}" pattern="yyyy-MM-dd" type="both"/></td>
							<td>${education.schoolName}</td>
							<td>${education.prefression}</td>
							<td>${fns:getDictLabel(education.degree, 'degree', '无')}/${fns:getDictLabel(education.educationalBackground, 'educational_background', '无')}</td>
							<td>${education.graduateAdvisor}</td>
							<td><a style='cursor:pointer' href="${ctx}/sys/user/deleteEducation?id=${education.id}" onclick="return confirmx('要删除该项吗？', this.href)">删除</a></td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
				<a onclick="saveUserEducation()" class="btn">追加</a>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">工作经历:</label>
			<div class="controls">
				<table id="contentTable1" class="table table-striped table-bordered table-condensed" style="width: 550px;">
					<tr>
						<th>起始时间</th>
						<th>结束时间</th>
						<th>单位名称</th>
						<th>所在科室</th>
						<th>职称</th>
						<th>职务</th>
						<th>操作</th>
					</tr>
					<tbody>
					<c:forEach items="${user.workList}" var="work">
						<tr>
							<td><fmt:formatDate value="${work.startDate}" pattern="yyyy-MM-dd" type="both"/></td>
							<td><fmt:formatDate value="${work.endDate}" pattern="yyyy-MM-dd" type="both"/></td>
							<td>${work.companyName}</td>
							<td>${work.office.name}</td>
							<td>${fns:getDictLabel(work.title, userTitle, '无')}</td>
							<td>${fns:getDictLabel(work.post, 'acad_exercise_role', '无')}</td>
							<td><a style='cursor:pointer' href="${ctx}/sys/user/deleteWork?id=${work.id}" onclick="return confirmx('要删除该项吗？', this.href)">删除</a></td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
				<a onclick="saveUserWork()" class="btn">追加</a>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">用户类型:</label>
			<div class="controls">
				<label class="lbl">${fns:getDictLabel(user.userType, 'sys_user_type', '无')}</label>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">用户角色:</label>
			<div class="controls">
				<label class="lbl">${user.roleNames}</label>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">最后登陆:</label>
			<div class="controls">
				<label class="lbl">IP: ${user.loginIp}&nbsp;&nbsp;&nbsp;&nbsp;时间：<fmt:formatDate value="${user.loginDate}"
						type="both" dateStyle="full" /></label>
			</div>
		</div>
		<div class="form-actions">
			<input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存" />
		</div>
	</form:form>
</body>
</html>