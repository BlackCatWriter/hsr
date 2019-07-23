<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>学术活动经费报销</title>
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
			jQuery.validator.addMethod("bx_fee", function(value, element) {
				if(value==""){
					return true;
				}
				 var decimal =  /^[0-9]+([\.][0-9]{0,3})?$/;
				return (decimal.test(value));
			}, "请输入正确的报销金额(格式:xx.xx)");
		});
		
		function advstudyChange(advstudyId){
			location.href='${ctx}/oa/advstudy/cost?id=' + advstudyId;
		}
		
		function reacademiccostSubmit(reApply)
		{	
			var taskId=$('#taskId').val();
				 complete(taskId, [{
					key: 'reApply',
					value: reApply,
					type: 'B'
				},{
					key: 'bxFee',
					value: $('#bxFee').val(),
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
					inputForm.action = "${ctx}/oa/advstudy";
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
		<li><a href="${ctx}/oa/advstudy/form">进修申请</a></li> 
		<li class="active"><a href="${ctx}/oa/advstudy/cost">进修经费报销</a></li>
		<li><a href="${ctx}/oa/advstudy/list">所有任务</a></li>
		<li><a href="${ctx}/oa/advstudy/task">待办任务</a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="academiccost" action="${ctx}/oa/advstudy/savecost" method="post" class="form-horizontal">
		<input type="hidden" id="taskId" value="${taskId}" />
		<input type="hidden" id="academiccostId" value="${academiccostId}" />
		<tags:message content="${message}"/>
		<div class="control-group">
			<label class="control-label">进修方向：</label>
			<div class="controls">
				<form:select path="advstudy.id" class="required"  onchange="advstudyChange(this.value);">
				<form:option value=""></form:option>
				<c:forEach items="${advstudyList}" var="selectedacad">
					<c:if test="${selectedacad.id eq selectedId}">
						<form:option value="${selectedacad.id}" selected="selected">${selectedacad.advstudyDirection }</form:option>
					</c:if>
					<c:if test="${selectedacad.id != selectedId}">
						<form:option value="${selectedacad.id}">${selectedacad.advstudyDirection}</form:option>
					</c:if>
				</c:forEach>
				</form:select>
			</div>
		</div>		
		<tags:message content="${message}"/>
				<div class="control-group">
			<label class="control-label">所属科室:</label>
			<div class="controls">
				<form:input path="office.name" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">申请人:</label>
			<div class="controls">
				<form:input path="user.name" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">开始时间：</label>
			<div class="controls">
				<form:input id="startDate" path="startDate" type="text" readonly="true" class="Wdate"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">结束时间：</label>
			<div class="controls">
				<form:input id="endDate" path="endDate" type="text" readonly="true" class="Wdate"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">进修单位:</label>
			<div class="controls">
				<form:input path="hostUnit" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>	
		</div>
		<div class="control-group">
			<label class="control-label">报销金额:</label>
			<div class="controls">
				<form:input id= "bxFee" path="bxFee" htmlEscape="false" maxlength="200" class="number bx_fee"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">附件上传:</label>
			<c:if test="${not empty taskId }">
				<div class="controls">
						已上传文件：<a href="${ctx}/cms/academiccost/get/${academiccost.id}">${academiccost.file}</a>
				</div>
			</c:if>
			<div class="controls">
				<input id="file" name="file" type="hidden" value=""/>
				<input id="fileupload" type="file" name="files[]" data-url="${ctx}/cms/academiccost/upload/academiccost">
			</div>
		</div>
		<div class="control-group">
			<div class="controls">
				<div id="progress" class="progress">
    				<div class="bar" style="width: 0%;"></div>
				</div>
			</div>
			<div class="controls">
			<table id="uploaded-files" class="table">
			<tr>
			<th>文件名称</th>
			<th>文件大小</th>
			<th>文件类型</th>
			</tr>
			</table>
			</div>
		</div>
				<c:if test="${not empty taskId }">
			<div class="control-group">
				<label class="control-label">科教处意见：</label>
				<div class="controls">
					<textarea rows="5" maxlength="20" readonly="readonly">${kjDeptBackReason}</textarea>
				</div>
			</div>
		</c:if>
		<div class="form-actions">
			<c:if test="${empty taskId}"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</c:if>
			<c:if test="${not empty taskId}"><input id="btnReSubmit" class="btn btn-primary" type="button" onclick="reacademiccostSubmit(true)" value="重新申请"/>&nbsp;
			<input id="btnRefuseSubmit" class="btn btn-primary" type="button" onclick="reacademiccostSubmit(false)" value="放弃申请"/>&nbsp;</c:if>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>
