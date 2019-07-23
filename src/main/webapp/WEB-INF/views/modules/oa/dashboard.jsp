<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>个人首页</title>
<meta name="decorator" content="default" />
<style type="text/css">
	td {overflow:hidden; white-space:nowrap; text-overflow:ellipsis;}
</style>
</head>
<body>
		<div class="accordion-group span10" style="min-height: 700px; max-height: 700px;width:40%;overflow:auto;">
						<div class="accordion-heading">
							<a class="accordion-toggle">通知信息</a>
						</div>
						<div style="margin-top: 8px;"></div>
						<table id="contentTable" class="table table-striped table-bordered table-condensed">
							<tbody>
								<c:forEach items="${dashboardModel.notices}" var="notice">
									<tr>
										<td style="max-width: 220px;"><a href="${ctx}/cms/notice/view?id=${notice.id}">${fns:abbr(notice.title,60)}</a></td>
										<td style="max-width: 75px;">${notice.updateDate}</td>
										<td>${notice.updateBy.name}</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
		</div>
		<div class="accordion-group span6" style="min-height: 350px; max-height: 350px; width:30%;overflow:auto;">
						<div class="accordion-heading">
							<a class="accordion-toggle">我的待办</a>
						</div>
						<div style="margin-top: 8px;"></div>
						<br>
						<table id="contentTable" class="table table-striped table-bordered table-condensed">
							<tbody>
								<c:forEach items="${dashboardModel.tasks}" var="task">
									<tr>
										<td style="max-width: 150px;">${fns:abbr(task.title,30)}</td>
										<td>${task.type}</td>
										<c:if test="${empty task.url }">
											<td><a href="${ctx}/oa/${task.typeInSys}/task">查看</a></td>
										</c:if>
										<c:if test="${not empty task.url }">
											<td><a href="${ctx}/${task.url}">查看</a></td>
										</c:if>
									</tr>
								</c:forEach>
							</tbody>
						</table>
		</div>
		<div>	
		<div class="accordion-group span6" style="min-height: 350px; max-height: 350px;width:30%;overflow:auto;">
							<div class="accordion-heading">
								<a class="accordion-toggle">已办事项追踪</a>
							</div>
							<div style="margin-top: 8px;"></div>
							<br>
							<table id="contentTable" class="table table-striped table-bordered table-condensed">
								<tbody>
									<c:forEach items="${dashboardModel.ownedTasks}" var="task">
										<tr>
											<td>${fns:abbr(task.title,30)}</td>
											<td>${task.type}</td>
											<c:if test="${empty task.url }">
												<td><a href="${ctx}/oa/${task.typeInSys}/list">查看</a></td>
											</c:if>
											<c:if test="${not empty task.url }">
												<td><a href="${ctx}/${task.url}">查看</a></td>
											</c:if>
										</tr>
									</c:forEach>
								</tbody>
							</table>
			</div>
		</div>
</body>
</html>