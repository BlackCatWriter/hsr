<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>科研项目申请一览</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
        	return false;
        }
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/oa/project/list">科研项目管理</a></li>
		<li><a href="${ctx}/oa/project/task">待办任务</a></li>
		<shiro:hasPermission name="oa:project:edit"><li><a href="${ctx}/oa/project/form">申报</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="project" action="${ctx}/oa/project/list" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<div>
			<label>申请编号：&nbsp;</label><form:input path="ids" htmlEscape="false" maxlength="50" class="input-medium" placeholder="多个用逗号或空格隔开"/>
			&nbsp;<label>只看本人：&nbsp;</label><form:checkbox id="selfOnly" path="selfOnly" />
		</div>
		<div style="margin-top:8px;">
			<label>项目起止时间：</label>
			<input id="createDateStart"  name="createDateStart"  type="text" readonly="readonly" maxlength="20" class="input-medium Wdate" style="width:163px;"
				value="<fmt:formatDate value="${project.createDateStart}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd'});"/>
				　--　
			<input id="createDateEnd" name="createDateEnd" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate" style="width:163px;"
				value="<fmt:formatDate value="${project.createDateEnd}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd'});"/>
			&nbsp;<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
			&nbsp;<a href="${ctx}/oa/project/form" class="btn btn-primary">申报</a>
		</div>
	</form:form>
	<tags:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead><tr>
			<%--<th>申请编号</th>--%>
			<th>立项号</th>
			<th>科研项目题目</th>
			<th>项目追踪</th>
			<th>创建人</th>
			<th>创建时间</th>
			<th>当前节点</th>
			<th>操作</th>
		</tr></thead>
		<tbody>
		<c:forEach items="${page.list}" var="project">
			<c:set var="task" value="${project.task }" />
			<c:set var="pi" value="${project.processInstance }" />
			<c:set var="hpi" value="${project.historicProcessInstance }" />
			<tr>
				<%--<td>${project.id}</td>--%>
				<td>${project.projectNo}</td>
				<td><a href="${ctx}/cms/project/form?id=${project.id}">${project.projectName}</a></td>
				<td>${project.processStatus}</td>
				<td>${project.createBy.name}</td>
				<td>${project.createDate}</td>
				<c:choose>
					<c:when test="${not empty task}">
						<td>${task.name}</td>
					</c:when>
					<c:when test="${empty task && project.delFlag eq '2'}">
						<td>已结束</td>
					</c:when>
					<c:otherwise>
						<td>未开始</td>
					</c:otherwise>
				</c:choose>
				<%--<c:if test="${not empty task}">
					<td>${task.name}</td>
				</c:if>
				<c:if test="${empty task}">
					<td>已结束</td>
				</c:if>--%>
				<%--<c:if test="${project.taskKey eq 'kjDeptAudit'}">
					<td><a href="${ctx}/oa/project/editform?id=${project.id}">编辑</a></td>
				</c:if>
				<c:if test="${project.taskKey ne 'kjDeptAudit'}">
					<td></td>
				</c:if>--%>
				<c:choose>
					<c:when test="${(empty task && project.delFlag ne '2') || projectData.taskKey eq 'modifyApply'}">
						<td><a href="${ctx}/oa/project/editform?id=${project.id}">编辑</a></td>
					</c:when>
					<c:otherwise>
						<td><a href="${ctx}/cms/project/form?id=${project.id}">查看</a></td>
					</c:otherwise>
				</c:choose>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>
