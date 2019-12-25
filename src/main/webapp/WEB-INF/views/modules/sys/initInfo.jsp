<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>个人信息</title>
<link href="${ctxStatic}/jquery-jbox/2.3/Skins/Bootstrap/jbox.css" rel="stylesheet" />
<script src="${ctxStatic}/jquery-jbox/2.3/jquery.jBox-2.3.min.js" type="text/javascript"></script>
<script src="${ctxStatic}/jquery-jbox/2.3/i18n/jquery.jBox-zh-CN.min.js" type="text/javascript"></script>
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
</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/sys/user/initPwd">修改密码</a></li>
		<li class="active"><a href="${ctx}/sys/user/initInfo">个人信息</a></li>
	</ul>
	<br />
	<form:form id="inputForm" modelAttribute="user" action="${ctx}/sys/user/changeInfo" method="post" class="form-horizontal">
		<tags:message content="${message}" />
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
					<tags:treeselect id="office" name="office.id" value="${user.office.id}" labelName="office.name" labelValue="${user.office.name}" 
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
			<label class="control-label">学历:</label>
			<div class="controls">
				<form:select path="education">
					<form:options items="${fns:getDictList('education_type')}" itemLabel="label" itemValue="value" htmlEscape="false" />
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
				<form:input path="graduateAdvisor" htmlEscape="false" maxlength="50" />
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
				<form:select path="jobTitle">
					<form:options items="${fns:getDictList('job_title')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
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