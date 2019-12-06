<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>科研项目合同一览</title>
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
		<li class="active"><a href="${ctx}/oa/projectData/list">合同列表</a></li>
		<li><a href="${ctx}/oa/projectData/task">待办任务</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="projectData" action="${ctx}/oa/projectData/list" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<div style="margin-top:8px;">
			<label>立项号：&nbsp;</label><form:input path="project.projectNo" htmlEscape="false" maxlength="50" class="input-medium"/>
			&nbsp;<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
		</div>
	</form:form>
	<tags:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead><tr>
			<th>立项号</th>
			<th>创建人</th>
			<th>创建时间</th>
			<th>当前节点</th>
			<th>操作</th>
		</tr></thead>
		<tbody>
		<c:forEach items="${page.list}" var="projectData">
			<c:set var="task" value="${projectData.task }" />
			<c:set var="pi" value="${projectData.processInstance }" />
			<c:set var="hpi" value="${projectData.historicProcessInstance }" />
			<tr>
				<td>${projectData.projectNo}</td>
				<td>${projectData.createBy.name}</td>
				<td>${projectData.createDate}</td>
				<c:choose>
					<c:when test="${not empty task}">
						<td>${task.name}</td>
					</c:when>
					<c:when test="${empty task && projectData.delFlag eq '2'}">
						<td>已结束</td>
					</c:when>
					<c:otherwise>
						<td>未开始</td>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${(empty task && projectData.delFlag ne '2') || projectData.taskKey eq 'modifyApply'}">
						<td><a href="${ctx}/oa/projectData/editform?id=${projectData.id}">合同编辑</a></td>
					</c:when>
					<c:otherwise>
						<td><a href="${ctx}/oa/projectData/check?id=${projectData.id}">查看</a></td>
					</c:otherwise>
				</c:choose>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
	</body>
</html>
