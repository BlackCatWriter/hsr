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
		<li><a href="${ctx}/oa/expense/projectlist">项目管理</a></li>
		<shiro:hasPermission name="oa:expense:edit"><li><a href="${ctx}/oa/expense/form">经费申请</a></li></shiro:hasPermission>
		<li class="active"><a href="${ctx}/oa/expense/list">所有任务</a></li>
		<li><a href="${ctx}/oa/expense/task">待办任务</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="expense" action="${ctx}/oa/expense/list" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<div>
			<label>申请编号：&nbsp;</label><form:input path="ids" htmlEscape="false" maxlength="50" class="input-medium" placeholder="多个用逗号或空格隔开"/>
			<label>立项号：&nbsp;</label><form:input path="project.projectNo" htmlEscape="false" maxlength="50" class="input-medium"/>
			<label>项目名：&nbsp;</label>
				<form:select path="project.id">
					<option value="" label=""/>
					<form:options items="${projectList}" itemLabel="projectName" itemValue="id" htmlEscape="false" />
				</form:select>
			&nbsp;<label>所有申请：&nbsp;</label><form:checkbox id="isRejected" path="isRejected" />
			&nbsp;<label>只看本人：&nbsp;</label><form:checkbox id="selfOnly" path="selfOnly" />
		</div>
		<div style="margin-top:8px;">
			<label>创建时间：</label>
			<input id="createDateStart"  name="createDateStart"  type="text" readonly="readonly" maxlength="20" class="input-medium Wdate" style="width:163px;"
				value="<fmt:formatDate value="${expense.createDateStart}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd'});"/>
				　--　
			<input id="createDateEnd" name="createDateEnd" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate" style="width:163px;"
				value="<fmt:formatDate value="${expense.createDateEnd}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd'});"/>
			&nbsp;<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
		</div>
	</form:form>
	<tags:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead><tr>
			<th>立项号</th>
			<th>项目名称</th>
			<th>创建人</th>
			<th>下拨经费</th>
			<th>配套经费</th>
			<th>使用经费</th>
			<th>申请金额</th>
			<th>申请原因</th>
			<th>审核状态</th>
			<th>当前节点</th>
		</tr></thead>
		<tbody>
		<c:forEach items="${page.list}" var="expense">
			<c:set var="task" value="${expense.task}" />
			<c:set var="pi" value="${expense.processInstance }" />
			<c:set var="hpi" value="${expense.historicProcessInstance }" />
			<tr>
				<td>${expense.project.projectNo}</td>
				<td>${expense.project.projectName}</td>
				<td>${expense.createBy.name}</td>
				<td>${expense.project.xb_fee}</td>
				<td>${expense.project.pt_fee}</td>
				<td>${expense.project.sy_fee}</td>
				<td>${expense.amount}</td>
				<td>${expense.reason}</td>
				<c:if test="${expense.delFlag eq '0'}">
					<td>审核中</td>
				</c:if>
				<c:if test="${expense.delFlag eq '1'}">
					<td>已驳回</td>
				</c:if>
				<c:if test="${expense.delFlag eq '2'}">
					<td>审核通过</td>
				</c:if>
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
