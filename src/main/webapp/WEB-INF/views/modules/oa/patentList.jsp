<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>专利申请一览</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
	function page(n, s) {
		$("#pageNo").val(n);
		$("#pageSize").val(s);
		$("#searchForm").submit();
		return false;
	}
</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/oa/patent/form">专利登记</a></li>
		<li class="active"><a href="${ctx}/oa/patent/list">所有任务</a></li>
		<li><a href="${ctx}/oa/patent/task">待办任务</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="patent" action="${ctx}/oa/patent/list" method="post"
		class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}" />
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}" />
		<div>
			<label>申请编号：&nbsp;</label>
			<form:input path="ids" htmlEscape="false" maxlength="50" class="input-medium" placeholder="多个用逗号或空格隔开" />
			<c:if test="${fns:isManager()}">&nbsp;<label>只看本人：&nbsp;</label>
				<form:checkbox id="selfOnly" path="selfOnly" />
			</c:if>
		</div>
		<div style="margin-top: 8px;">
			<label>发表时间：</label> <input id="searchYear" name="searchYear" type="text" readonly="readonly" maxlength="20"
				class="input-medium Wdate" style="width: 163px;" value="${patent.searchYear}"
				onclick="WdatePicker({dateFmt:'yyyy'});" /> &nbsp;<input id="btnSubmit" class="btn btn-primary" type="submit"
				value="查询" />
		</div>
	</form:form>
	<tags:message content="${message}" />
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>申请编号</th>
				<th>专利题目</th>
				<th>创建人</th>
				<th>创建时间</th>
				<th>当前节点</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${page.list}" var="patent">
				<c:set var="task" value="${patent.task }" />
				<c:set var="pi" value="${patent.processInstance }" />
				<c:set var="hpi" value="${patent.historicProcessInstance }" />
				<tr>
					<td>${patent.id}</td>
					<td>${patent.title}</td>
					<td>${patent.createBy.name}</td>
					<td>${patent.createDate}</td>
					<c:if test="${not empty task}">
						<td>${task.name}</td>
					</c:if>
					<c:if test="${empty task}">
						<td>已结束</td>
					</c:if>
				<c:if test="${patent.taskKey eq 'kjDeptAudit'}">
					<td><a href="${ctx}/oa/patent/editform?id=${patent.id}">编辑</a></td>
				</c:if>
				<c:if test="${patent.taskKey ne 'kjDeptAudit'}">
					<td></td>
				</c:if>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>
