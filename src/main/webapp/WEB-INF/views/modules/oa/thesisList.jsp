<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>经费申请一览</title>
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
		<shiro:hasPermission name="oa:thesis:edit"><li><a href="${ctx}/oa/thesis/form">论文登记</a></li></shiro:hasPermission>
		<li class="active"><a href="${ctx}/oa/thesis/list">所有任务</a></li>
		<li><a href="${ctx}/oa/thesis/task">待办任务</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="thesis" action="${ctx}/oa/thesis/list" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<div>
			<label>论文题目：&nbsp;</label><form:input path="title" htmlEscape="false" maxlength="50" class="input-medium"/>
			<c:if test="${fns:isManager()}">&nbsp;<label>只看本人：&nbsp;</label><form:checkbox id="selfOnly" path="selfOnly" /></c:if>
		</div>
		<div style="margin-top:8px;">
			<label>发表时间：</label>
			<input id="searchYear"  name="searchYear"  type="text" readonly="readonly" maxlength="20" class="input-medium Wdate" style="width:163px;"
				value="${thesis.searchYear}"
					onclick="WdatePicker({dateFmt:'yyyy'});"/>
			&nbsp;<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
		</div>
	</form:form>
	<tags:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead><tr>
			<th>申请编号</th>
			<th>论文题目</th>
			<th>创建人</th>
			<th>创建时间</th>
			<th>当前节点</th>
			<th>操作</th>
		</tr></thead>
		<tbody>
		<c:forEach items="${page.list}" var="thesis">
			<c:set var="task" value="${thesis.task }" />
			<c:set var="pi" value="${thesis.processInstance }" />
			<c:set var="hpi" value="${thesis.historicProcessInstance }" />
			<tr>
				<td>${thesis.id}</td>
				<td>${thesis.title}</td>
				<td>${thesis.createBy.name}</td>
				<td>${thesis.createDate}</td>
				<c:if test="${not empty task}">
					<td>${task.name}</td>
				</c:if>
				<c:if test="${empty task}">
					<td>已结束</td>
				</c:if>
				<c:if test="${thesis.taskKey eq 'kjDeptAudit'}">
					<td><a href="${ctx}/oa/thesis/editform?id=${thesis.id}">编辑</a></td>
				</c:if>
				<c:if test="${thesis.taskKey ne 'kjDeptAudit'}">
					<td></td>
				</c:if>
				
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>
