<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>科研成果申请一览</title>
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
		<shiro:hasPermission name="oa:achievement:edit"><li><a href="${ctx}/oa/achievement/form">新技术引进奖</a></li></shiro:hasPermission>
		<li class="active"><a href="${ctx}/oa/achievement/list">所有任务</a></li>
		<li><a href="${ctx}/oa/achievement/task">待办任务</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="achievement" action="${ctx}/oa/achievement/list" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<div>
			<label>申请编号：&nbsp;</label><form:input path="ids" htmlEscape="false" maxlength="50" class="input-medium" placeholder="多个用逗号或空格隔开"/>
			&nbsp;<label>只看本人：&nbsp;</label><form:checkbox id="selfOnly" path="selfOnly" />
		</div>
		<div style="margin-top:8px;">
			<label>创建时间：</label>
			<input id="createDateStart"  name="createDateStart"  type="text" readonly="readonly" maxlength="20" class="input-medium Wdate" style="width:163px;"
				value="<fmt:formatDate value="${achievement.createDateStart}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd'});"/>
				　--　
			<input id="createDateEnd" name="createDateEnd" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate" style="width:163px;"
				value="<fmt:formatDate value="${achievement.createDateEnd}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd'});"/>
			&nbsp;<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
		</div>
	</form:form>
	<tags:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead><tr>
			<th>申请编号</th>
			<th>创建人</th>
			<th>创建时间</th>
			<th>当前节点</th>
		</tr></thead>
		<tbody>
		<c:forEach items="${page.list}" var="achievement">
			<c:set var="task" value="${achievement.task }" />
			<c:set var="pi" value="${achievement.processInstance }" />
			<c:set var="hpi" value="${achievement.historicProcessInstance }" />
			<tr>
				<td>${achievement.id}</td>
				<td>${achievement.createBy.name}</td>
				<td>${achievement.createDate}</td>
				<c:if test="${not empty task}">
					<td>${task.name}</td>
				</c:if>
				<c:if test="${empty task}">
					<td>已结束</td>
				</c:if>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>
