<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>进修申请一览</title>
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
		<li><a href="${ctx}/oa/advstudy/form">进修申请</a></li>
		<li><a href="${ctx}/oa/advstudy/cost">进修经费报销</a></li>
		<li class="active"><a href="${ctx}/oa/advstudy/list">所有任务</a></li>
		<li><a href="${ctx}/oa/advstudy/task">待办任务</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="advstudy" action="${ctx}/oa/advstudy/list" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<div>
			<label>只看本人：&nbsp;</label><form:checkbox id="selfOnly" path="selfOnly" />
		</div>
		<div style="margin-top:8px;">
			<label>进修时间：</label>
			<input id="startDate"  name="startDate"  type="text" readonly="readonly" maxlength="20" class="input-medium Wdate" style="width:163px;"
				value="<fmt:formatDate value="${advstudy.startDate}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd'});"/>
				　--　
			<input id="endDate" name="endDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate" style="width:163px;"
				value="<fmt:formatDate value="${advstudy.endDate}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd'});"/>
			&nbsp;<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
		</div>
	</form:form>
	<tags:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead><tr>
			<th>创建人</th>
			<th>所属科室</th>
			<th>进修方向</th>
			<th>进修单位</th>
			<th>开始时间</th>
			<th>结束时间</th>
			<th>当前节点</th>
			<th>操作</th>
		</tr></thead>
		<tbody>
		<c:forEach items="${page.list}" var="advstudy">
			<c:set var="task" value="${advstudy.task }" />
			<c:set var="pi" value="${advstudy.processInstance }" />
			<c:set var="hpi" value="${advstudy.historicProcessInstance }" />
			<tr>
				<td>${advstudy.user.name}</td>
				<td>${advstudy.office.name}</td>
				<td>${advstudy.advstudyDirection}</td>
				<td>${advstudy.hostUnit}</td>
				<td><fmt:formatDate value="${advstudy.startDate}" pattern="yyyy-MM-dd" type="both"/></td>
				<td><fmt:formatDate value="${advstudy.endDate}" pattern="yyyy-MM-dd" type="both"/></td>
				<c:if test="${not empty task}">
					<td>${task.name}</td>
				</c:if>
				<c:if test="${empty task}">
					<td>已结束</td>
				</c:if>
				<c:if test="${advstudy.taskKey eq 'kjDeptAudit'}">
					<td><a href="${ctx}/oa/advstudy/editform?id=${advstudy.id}">编辑</a></td>
				</c:if>
				<c:if test="${advstudy.taskKey ne 'kjDeptAudit'}">
					<td></td>
				</c:if>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>
