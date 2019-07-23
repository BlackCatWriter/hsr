<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>用户管理</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
	$(document)
			.ready(
					function() {
						$("#loginName").focus();
						$("#inputForm")
								.validate(
										{
											rules : {
												loginName : {
													remote : "${ctx}/sys/user/checkLoginName?oldLoginName="
															+ encodeURIComponent('${user.loginName}')
												}
											},
											messages : {
												loginName : {
													remote : "用户登录名已存在"
												},
												confirmNewPassword : {
													equalTo : "输入与上面相同的密码"
												}
											},
											submitHandler : function(form) {
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
																		".input-append")) {
													error.appendTo(element
															.parent().parent());
												} else {
													error.insertAfter(element);
												}
											}
										});
					});
</script>
</head>
<body>
	<div class="leaderboard">
		<hr>
	</div>
	<div class="row">
		<div class="span8">
			<h4>待办任务</h4>
			<br>
			<table id="contentTable" class="table table-striped table-bordered table-condensed">
			<tr>
				<th>待办事项</th>
				<th>标题</th>
				<th>来自于</th>
				<th>任务创建时间</th>
			</tr>
		<tbody>
			<c:forEach items="${thesis}" var="thesis">
				<c:set var="task" value="${thesis.task}" />
				<c:set var="pi" value="${thesis.processInstance}" />
				<tr id="${thesis.id }" tid="${task.id}">
					<td>${thesis.title}</td>
					<td>${thesis.user.name}</td>
					<td><fmt:formatDate value="${thesis.createDate}" type="both"/></td>
					<td>${task.name}</td>
					<td><fmt:formatDate value="${task.createTime}" type="both"/></td>
					<td>${pi.suspended ? "已挂起" : "正常" }；<b title='流程版本号'>V: ${thesis.processDefinition.version}</b></td>
					<td>
						<c:if test="${empty task.assignee}">
							<a class="claim" href="#" onclick="javescript:claim('${task.id}');">签收</a>
						</c:if>
						<c:if test="${not empty task.assignee}">
							<%-- 此处用tkey记录当前节点的名称 --%>
							<a class="handle" href="#" data-tkey="${task.taskDefinitionKey}" data-tname="${task.name}"  data-id="${thesis.id}"  data-tid="${task.id}">办理</a>
						</c:if>
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
				<a class="btn btn-success btn-large" href="#">查看更多</a>
			</p>
		</div>
		<div class="span8">
			<h4>文件下载</h4>
			<p>Donec id elit non mi porta gravida at eget metus. Fusce dapibus, tellus ac cursus commodo, tortor mauris
				condimentum nibh,ut fermentum massa justo sit amet risus. Etiam porta sem malesuada magna mollis euismod. Donec sed
				odio dui.</p>
			<p>
				<a class="btn btn-success btn-large" href="#">View apps</a>
			</p>
		</div>
	</div>
	<hr>
</body>
</html>