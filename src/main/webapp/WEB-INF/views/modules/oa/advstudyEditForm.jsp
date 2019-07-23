<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>进修管理</title>
	<meta name="decorator" content="default"/>
	<script src="${ctxStatic}/jQuery-File-Upload-9.9.3/js/vendor/jquery.ui.widget.js"></script>
	<script src="${ctxStatic}/jQuery-File-Upload-9.9.3/js/jquery.iframe-transport.js"></script>
	<script src="${ctxStatic}/jQuery-File-Upload-9.9.3/js/jquery.fileupload.js"></script>
	<script src="${ctxStatic}/bootstrap/2.3.1/js/bootstrap.min.js"></script>
	<link href="${ctxStatic}/common/dropzone.css" type="text/css" rel="stylesheet" />
	<script src="${ctxStatic}/common/myuploadfunction.js"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#advstudyname").focus();
			$("#uploaded-files").hide();
			$("#inputForm").validate({
				submitHandler: function(form){
					cleanSuggestWords();
					loading('正在提交，请稍等...');
					form.submit();
				},
				errorContainer: "#messageBox",
				errorPlacement: function(error, element) {
					$("#messageBox").text("输入有误，请先更正。");
					if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")||element.parent().is(".customerTag")){
						error.appendTo(element.parent().parent());
					}else {
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
		function cleanSuggestWords(){ 
		    $("#bx_fee").val(''); 
		}
		
		function readvstudySubmit(reApply)
		{	
			var taskId=$('#taskId').val();
				 complete(taskId, [{
					key: 'reApply',
					value: reApply,
					type: 'B'
				},{
					key: 'advstudyDirection',
					value: $('#advstudyDirection').val(),
					type: 'S'
				},{
					key: 'hostUnit',
					value: $('#hostUnit').val(),
					type: 'S'
				},{
					key: 'startDate',
					value: $('#startDate').val(),
					type: 'S'
				},{
					key: 'endDate',
					value: $('#endDate').val(),
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
		        	redirectForm.action = "${ctx}/oa/advstudy";
		            redirectForm.submit();
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
		<li class="active"><a href="${ctx}/oa/advstudy/form">进修申请编辑</a></li>
		<li><a href="${ctx}/oa/advstudy/cost">进修经费报销</a></li>
		<li><a href="${ctx}/oa/advstudy/list">所有任务</a></li>
		<li><a href="${ctx}/oa/advstudy/task">待办任务</a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="advstudy" action="${ctx}/oa/advstudy/edit" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<input type="hidden" id="taskId" value="${taskId}"/>
		<input type="hidden" id="advstudyId" value="${advstudyId}"/>
		<tags:message content="${message}"/>
		<div class="control-group">
			<label class="control-label">所属科室：</label>
			<div class="controls">
				<tags:treeselect id="office" name="office.id" value="${advstudy.office.id}" labelName="office.name"
					labelValue="${advstudy.office.name}" title="科室" url="/sys/office/treeData?type=2" cssClass="required"
					notAllowSelectParent="true" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">姓名：</label>
			<div class="controls">
				<form:input path="applyuser" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">职称：</label>
			<div class="controls">
				<form:input path="worktitle" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>

		<div class="control-group">
			<label class="control-label">进修方向：</label>
			<div class="controls">
				<form:input path="advstudyDirection" id="advstudyDirection" htmlEscape="false" maxlength="200" class="required"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">进修单位：</label>
			<div class="controls">
				<form:input path="hostUnit" id="hostUnit" htmlEscape="false" maxlength="200" class="required"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">开始时间：</label>
			<div class="controls">
				<form:input id="startDate" path="startDate" type="text" readonly="readonly" maxlength="100" class="Wdate required"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
		</div>
		</div>
		<div class="control-group">
			<label class="control-label">结束时间：</label>
			<div class="controls">
				<form:input id="endDate" path="endDate" type="text" readonly="readonly" maxlength="100" class="Wdate required"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">报销经费：</label>
			<div class="controls">
				<form:input path="bxFee" id="bxFee" htmlEscape="false" maxlength="200" class="number bx_fee" readonly="true"/>
			</div>
		</div>
		
		<div class="control-group">
			<label class="control-label">附件上传：</label>
			<div class="controls">
					已上传文件：<a href="${ctx}/oa/advstudy/get/${advstudy.id}">${advstudy.file}</a>
				<input id="file" name="file" type="hidden" value="" /> <input id="fileupload" type="file" name="files[]"
					data-url="${ctx}/oa/advstudy/upload/advstudy">
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
		<div class="control-group">
			<label class="control-label">备注：</label>
			<div class="controls">
				<form:textarea path="remarks" rows="5" maxlength="20"/>
		</div>
		</div>
		<div class="form-actions">
			<input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存" />&nbsp;
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)" />
		</div>
	</form:form>
	<form:form id="redirectForm" />
</body>
</html>
