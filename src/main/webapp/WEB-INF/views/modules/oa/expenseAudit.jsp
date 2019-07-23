<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>经费管理</title>
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
			$("#uploaded-files").hide();
			$("#name").focus();
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
		
	function pass(result){
		complete("${taskId}",[{
			key: 'deptLeaderPass',
			value: result,
			type: 'B'
		 },
         {
             key: 'expenseId',
             value: $('#expenseId').val(),
             type: 'S'
         },
         {
             key: 'projectId',
             value: $('#projectId').val(),
             type: 'S'
         },
         {
             key: 'amount',
             value:  $('#amount').val(),
             type: 'S'
		}]);
	}	
		
	function complete(taskId,variables) {
	    // 转换JSON为字符串
	    var keys = "",
	    values = "",
	    types = "";
	    if (variables) {
	        $.each(variables,
	        function() {
	            if (keys != "") {
	                keys += "|";
	                values += "|";
	                types += "|";
	            }
	            keys += this.key;
	            if (this.value == "") {
	                values += " ";
	            } else {
	                values += this.value;
	            }
	            types += this.type;
	        });
	    }
	    $.post('${ctx}/oa/expense/complete/' + taskId, {
	        keys: keys,
	        values: values,
	        types: types
	    },

	    function(resp) {
	        if (resp == 'success') {
	            top.$.jBox.tip('任务完成');
	            location.href = "${ctx}/oa/expense/task";
	        } else {
	            top.$.jBox.tip('操作失败!');
	        }
	    });
	}
		 
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/oa/expense/projectlist">项目管理</a></li>
		<shiro:hasPermission name="oa:expense:edit"><li class="active"><a href="${ctx}/oa/expense/audit/${expenseId}/${taskId}">经费审批</a></li></shiro:hasPermission>
		<li><a href="${ctx}/oa/expense/list">所有任务</a></li>
		<li><a href="${ctx}/oa/expense/task">待办任务</a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="expense" action="${ctx}/oa/expense/pass" method="post" class="form-horizontal">
		<tags:message content="${message}"/>
		<div class="hide">
			<label class="control-label">申请编号：</label>
			<div class="controls">
				<input id="expenseId" value="${expense.id}" readonly="readonly" />
			</div>
		</div>
		<div class="hide">
			<label class="control-label">项目编号：</label>
			<div class="controls">
				<input id="projectId" value="${expense.project.id}" readonly="readonly" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">项目名：</label>
			<div class="controls">
				<input id="projectName" value="${expense.project.projectName}" readonly="readonly" />
			</div>
		</div>		
		<div class="control-group">
			<label class="control-label">项目总经费：</label>
			<div class="controls">
				<input id="totalFee" value="${expenseModel.totalFee}" readonly="readonly" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">项目经费申请记录：</label>
			<div class="controls">
				<table id="contentTable" class="table table-striped table-bordered table-condensed width:50%">
				<tr>
					<th>申请人</th>
					<th>申请时间</th>
					<th>审核状态</th>
					<th>申请经费数</th>
					<th>申请原因</th>
				</tr>
				<tbody>
					<c:forEach items="${expenseModel.expenseList}" var="expense">
						<tr>
							<td>${expense.createBy.name}</td>
							<td><fmt:formatDate value="${expense.updateDate}" type="date" /></td>
							<c:if test="${expense.delFlag eq '0'}">
								<td>审核中</td>
							</c:if>
							<c:if test="${expense.delFlag eq '1'}">
								<td>已驳回</td>
							</c:if>
							<c:if test="${expense.delFlag eq '2'}">
								<td>审核通过</td>
							</c:if>
							<td>"${expense.amount}"</td>
							<td>"${expense.reason}"</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			
			</div>
		</div>
		<hr>
		<div class="control-group">
			<label class="control-label">项目使用经费：</label>
			<div class="controls">
				<input id="totalFee" value="${expenseModel.usedFee}" readonly="readonly" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">项目剩余经费：</label>
			<div class="controls">
				<input  id="remaindFee" value="${expenseModel.remaindFee}" readonly="readonly" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">申请原因：</label>
			<div class="controls">
				<form:textarea path="reason" rows="5" maxlength="20" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">数额：</label>
			<div class="controls">
				<form:input id="amount" path="amount" name="amount" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">附件下载:</label>
				<div class="controls">
						<a href="${ctx}/cms/project/get/${expense.id}">${expense.file}</a>
				</div>
		</div>
		<div class="form-actions">
			<input id="btnSubmit" class="btn btn-primary" type="button" onclick="pass(true)" value="通过"/>
			<input id="btnReject" class="btn " type="button"  onclick="pass(false)"  value="驳回"/>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>
