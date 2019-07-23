<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>新技术引进奖管理</title>
	<meta name="decorator" content="default"/>
	<script src="${ctxStatic}/jQuery-File-Upload-9.9.3/js/vendor/jquery.ui.widget.js"></script>
<script src="${ctxStatic}/jQuery-File-Upload-9.9.3/js/jquery.iframe-transport.js"></script>
<script src="${ctxStatic}/jQuery-File-Upload-9.9.3/js/jquery.fileupload.js"></script>
<script src="${ctxStatic}/bootstrap/2.3.1/js/bootstrap.min.js"></script>
	<link href="${ctxStatic}/bootstrap/2.3.1/css_default/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<link href="${ctxStatic}/common/dropzone.css" type="text/css" rel="stylesheet" />
	<script src="${ctxStatic}/common/myuploadfunction.js"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#name").focus();
			$("#uploaded-files").hide();
			$("#inputForm").validate({
				submitHandler: function(form){
					loading('正在提交，请稍等...');
					form.submit();
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
function reAchievementSubmit(reApply)
{	
	var taskId=$('#taskId').val();
		 complete(taskId, [{
			key: 'reApply',
			value: reApply,
			type: 'B'
		}, {
			key: 'office',
			value:$('#officeId').val(),
			type: 'S'
		},{
			key: 'major',
			value: $('#major').val(),
			type: 'S'
		},{
			key: 'author1',
			value: $('#author1Id').val(),
			type: 'S'
		},{
			key: 'author2',
			value: $('#author2Id').val(),
			type: 'S'
		},{
			key: 'author3',
			value: $('#author3Id').val(),
			type: 'S'
		},{
			key: 'weightBelong',
			value: $('#weightBelongId').val(),
			type: 'S'
		},{
			key: 'projectNo',
			value: $('#projectNo').val(),
			type: 'S'
		},{
			key: 'projectName',
			value: $('#projectName').val(),
			type: 'S'
		},{
			key: 'remarks',
			value: $('#remarks').val(),
			type: 'S'
		}]);
}

/**
 * 完成任务
 * @param {Object} taskId
 */
function complete(taskId, variables) {
	 // 转换JSON为字符串
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
    	    keys: keys,
	        values: values,
	        types: types
    }, function(resp) {
        if (resp == 'success') {
        	top.$.jBox.tip('任务完成');
        	inputForm.action="${ctx}/oa/achievement";
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
		<shiro:hasPermission name="oa:achievement:edit"><li class="active"><a href="${ctx}/oa/achievement/form">新技术引进奖</a></li></shiro:hasPermission>
		<li><a href="${ctx}/oa/achievement/list">所有任务</a></li>
		<li><a href="${ctx}/oa/achievement/task">待办任务</a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="achievement" action="${ctx}/oa/achievement/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<input type="hidden" id="taskId" value="${taskId}"/>
		<input type="hidden" id="achievementId" value="${achievementId}"/>
		<tags:message content="${message}"/>
		<div class="control-group">
			<label class="control-label">所属科室：</label>
			<div class="controls">
                <tags:treeselect id="office" name="office.id" value="${achievement.office.id}" labelName="office.name" labelValue="${achievement.office.name}"
					title="科室" url="/sys/office/treeData?type=2" cssClass="required" notAllowSelectParent="true"/>
			</div>
		</div>
				<div class="control-group">
			<label class="control-label">专业:</label>
			<div class="controls">
				<form:input path="major" htmlEscape="false" maxlength="200" class="input-xxlarge required"/>
			</div>
		</div>
				<div class="control-group">
			<label class="control-label">第一完成人：</label>
			<div class="controls">
				<tags:treeselect2 id="author1" name="author1" checked="true" value="${achievement.author1}" labelName="parent.name" labelValue="${author1}"
					title="第一完成人" url="/oa/achievement/treeData" extId="${achievement.office.id}" cssClass="required"/><span style="color:#aaa">请按作者先后顺序选择</span>
			</div>
		</div>
				<div class="control-group">
			<label class="control-label">第二完成人：</label>
			<div class="controls">
				<tags:treeselect2 id="author2" name="author2" checked="true" value="${achievement.author2}" labelName="parent.name" labelValue="${author2}"
					title="第二完成人" url="/oa/achievement/treeData" extId="${achievement.office.id}" cssClass="required"/><span style="color:#aaa">请按作者先后顺序选择</span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">第三完成人：</label>
			<div class="controls">
				<tags:treeselect2 id="author3" name="author3" checked="true" value="${achievement.author3}" labelName="parent.name" labelValue="${author3}"
					title="第三作者" url="/oa/achievement/treeData" extId="${achievement.office.id}" cssClass="required"/><span style="color:#aaa">请按作者先后顺序选择</span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">权属：</label>
			<div class="controls">
				<tags:treeselect id="weightBelong" name="weightBelong" value="${achievement.weightBelong}" labelName="parent.name" labelValue="${weightBelong}"
					title="权属" url="/oa/achievement/treeData" extId="${achievement.office.id}" cssClass="required"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">项目编号:</label>
			<div class="controls">
				<form:input path="project.projectNo" htmlEscape="false" maxlength="200" class="input-xxlarge required"/>
			</div>
		</div>
				<div class="control-group">
			<label class="control-label">项目名称：</label>
			<div class="controls">
				<form:input path="projectName" htmlEscape="false" maxlength="200" class="input-xxlarge required"/>
			</div>
		</div>
				<div class="control-group">
			<label class="control-label">备注：</label>
			<div class="controls">
				<form:textarea path="remarks" rows="5" maxlength="20"/>
			</div>
		</div>
		<div class="form-actions">
			<c:if test="${empty taskId}"><shiro:hasPermission name="oa:achievement:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission></c:if>
			<c:if test="${not empty taskId}"><input id="btnReSubmit" class="btn btn-primary" type="button" onclick="reAchievementSubmit(true)" value="重新申请"/>&nbsp;
			<input id="btnRefuseSubmit" class="btn btn-primary" type="button" onclick="reAchievementSubmit(false)" value="放弃申请"/>&nbsp;</c:if>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>
