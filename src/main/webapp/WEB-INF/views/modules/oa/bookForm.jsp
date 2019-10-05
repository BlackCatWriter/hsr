<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>著作登记管理</title>
<meta name="decorator" content="default" />
<script src="${ctxStatic}/jQuery-File-Upload-9.9.3/js/vendor/jquery.ui.widget.js"></script>
<script src="${ctxStatic}/jQuery-File-Upload-9.9.3/js/jquery.iframe-transport.js"></script>
<script src="${ctxStatic}/jQuery-File-Upload-9.9.3/js/jquery.fileupload.js"></script>
<script src="${ctxStatic}/bootstrap/2.3.1/js/bootstrap.min.js"></script>
<link href="${ctxStatic}/common/dropzone.css" type="text/css" rel="stylesheet" />
<script src="${ctxStatic}/common/myuploadfunction.js"></script>
<script type="text/javascript">
	$(document)
			.ready(
					function() {
						$("#title").focus();
						$("#uploaded-files").hide();
						$("#inputForm")
								.validate(
										{
											submitHandler : function(form) {
												cleanSuggestWords();
												loading('正在提交，请稍等...');
												form.submit();
											},
											errorContainer : "#messageBox",
											errorPlacement : function(error,
													element) {
												$("#messageBox").text(
														"输入有误，请先更正。");
												if (element.is(":checkbox")
														|| element.is(":radio")
														|| element
																.parent()
																.is(
																		".input-append")
														|| element.parent().is(
																".customerTag")) {
													error.appendTo(element
															.parent().parent());
												} else {
													error.insertAfter(element);
												}
											},
											rules : {
												title : {
													remote : {
														url : "${ctx}/oa/book/checkTitle",
														type : "post",
														dataType : "json",
														data : {
															oldTitle : function() {
																return $(
																		"#oldTitle")
																		.val();
															}
														}
													},
												}
											},
											messages : {
												title : {
													remote : "著作题目已存在!"
												}
											}
										});
						jQuery.validator.addMethod("jl", function(value,
								element) {
							if (value == "") {
								return true;
							}
							var decimal = /^[0-9]+([\.][0-9]{0,3})?$/;
							return (decimal.test(value));
						}, "请输入正确的奖励金额(格式:xx.xx)");
					});
	function cleanSuggestWords() {
		$("#author1keyword").val('');
		$("#weightBelongkeyword").val('');
	}

	function rebookSubmit(reApply) {
		var taskId = $('#taskId').val();
		complete(taskId, [ {
			key : 'reApply',
			value : reApply,
			type : 'B'
		},{
			key : 'title',
			value : $('#title').val(),
			type : 'S'
		}, {
			key : 'author1',
			value : $('#author1Id').val(),
			type : 'S'
		}, {
			key : 'weightBelong',
			value : $('#weightBelongId').val(),
			type : 'S'
		}, {
			key : 'time',
			value : $('#time').val(),
			type : 'S'
		}, {
			key : 'number',
			value : $('#number').val(),
			type : 'S'
		}, {
			key : 'profession',
			value : $('#profession').val(),
			type : 'S'
		}, {
			key : 'file',
			value : $('#file').val(),
			type : 'S'
		} , {
			key : 'remarks',
			value : $('#remarks').val(),
			type : 'S'
		}, {
			key : 'jl',
			value : $('#jl').val(),
			type : 'S'
		}, {
			key : 'letters',
			value : $('#letters').val(),
			type : 'S'
		}, {
			key : 'role',
			value : $('#role').val(),
			type : 'S'
		}, {
			key : 'publisher',
			value : $('#publisher').val(),
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
				inputForm.action = "${ctx}/oa/book";
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
		<li class="active"><a href="${ctx}/oa/book/form">著作登记</a></li>
		<li><a href="${ctx}/oa/book/list">所有任务</a></li>
		<li><a href="${ctx}/oa/book/task">待办任务</a></li>
	</ul>
	<br />
	<form:form id="inputForm" modelAttribute="book" action="${ctx}/oa/book/save" method="post" class="form-horizontal">
		<form:hidden path="id" />
		<input type="hidden" id="taskId" value="${taskId}" />
		<input type="hidden" id="bookId" value="${bookId}" />
		<tags:message content="${message}" />
		<div class="control-group">
			<label class="control-label"><font color='red'>*</font>所属科室：</label>
			<div class="controls">
				<tags:treeselect id="office" name="office.id" value="${book.office.id}" labelName="office.name"
					labelValue="${book.office.name}" title="科室" url="/sys/office/treeData?type=2" cssClass="required"
					notAllowSelectParent="true" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label"><font color='red'>*</font>作者：</label>
			<div class="controls">
				<tags:nameSuggest value="${book.author1}" labelValue="${book.author1DisplayName}" cssClass="required"
					name="author1" id="author1" url="${ctx}/sys/user/users/"></tags:nameSuggest>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label"><font color='red'>*</font>权属：</label>
			<div class="controls">
				<tags:nameSuggest value="${book.weightBelong}" cssClass="required" labelValue="${book.weightBelongDisplayName}"
					name="weightBelong" id="weightBelong" url="${ctx}/sys/user/users/"></tags:nameSuggest>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">关联项目：</label>
			<div class="controls">
				<form:select path="project.id">
					<form:option value=""></form:option>
					<c:forEach items="${projectList}" var="project">
						<c:if test="${project.id eq selectedId}">
							<form:option value="${project.id}" selected="selected">${project.projectName }</form:option>
						</c:if>
						<c:if test="${project.id != selectedId}">
							<form:option value="${project.id}">${project.projectName }</form:option>
						</c:if>
					</c:forEach>
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label"><font color='red'>*</font>著作题目：</label>
			<div class="controls">
				<input id="oldTitle" name="oldTitle" type="hidden" value="${book.title}">
				<form:input id="title" path="title" htmlEscape="false" maxlength="200" class="input-xxlarge required" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label"><font color='red'>*</font>出版社：</label>
			<div class="controls">
				<form:input id="publisher" path="publisher" htmlEscape="false" maxlength="200" class="input-xxlarge required" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label"><font color='red'>*</font>书刊号：</label>
			<div class="controls">
				<form:input id="number" path="number" htmlEscape="false" maxlength="200" class="input-xxlarge required" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">年限：</label>
			<div class="controls">
				<form:input id="time" name="time" path="time" htmlEscape="false" maxlength="200"
					class="input-medium date" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">专业：</label>
			<div class="controls">
				<form:input id="profession" name="profession" path="profession" htmlEscape="false" maxlength="200"
					class="input-medium " />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">作者担任角色：</label>
			<div class="controls">
				<form:select id="role" path="role">
					<form:options items="${fns:getDictList('book_role_type')}" itemLabel="label" itemValue="value"
						htmlEscape="false" />
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">承担部分字数：</label>
			<div class="controls">
				<form:input id="letters" name="letters" path="letters" htmlEscape="false" maxlength="200"
					class="input-medium " />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">著作上传：</label>
			<div class="controls">
				<c:if test="${not empty taskId}">
					已上传文件：<a href="${ctx}/oa/book/get/${book.id}">${book.file}</a></c:if>
				<input id="file" name="file" type="hidden" value="" /> <input id="fileupload" type="file" name="files[]"
					data-url="${ctx}/oa/book/upload/book">
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
				<form:textarea path="remarks" rows="5" maxlength="20" />
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
			<c:if test="${empty taskId}">
					<input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存" />
			</c:if>
			<c:if test="${not empty taskId}">
				<input id="btnReSubmit" class="btn btn-primary" type="button" onclick="rebookSubmit(true)"
					value="重新申请" />&nbsp;
			<input id="btnRefuseSubmit" class="btn btn-primary" type="button" onclick="rebookSubmit(false)" value="放弃申请" />&nbsp;</c:if>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)" />
		</div>
	</form:form>
</body>
</html>