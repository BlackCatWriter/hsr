<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>学会任职申请一览</title>
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
		<li><a href="${ctx}/oa/acad/form">学会协会任职登记</a></li>
		<li class="active"><a href="${ctx}/oa/acad/list">所有任务</a></li>
		<li><a href="${ctx}/oa/acad/task">待办任务</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="acad" action="${ctx}/oa/acad/list" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<div>
			<label>学会名称：&nbsp;</label><form:input path="acadName" htmlEscape="false" maxlength="50" class="input-medium"/>
			&nbsp;<label>级别：&nbsp;</label>
				<form:select path="level" >
					<form:options id="level" items="${fns:getDictList('acad_level_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			&nbsp;<label>只看本人：&nbsp;</label><form:checkbox id="selfOnly" path="selfOnly" />
		</div>
		<div style="margin-top:8px;">
			<label>任职时间：</label>
			<input id="startDate"  name="startDate"  type="text" readonly="readonly" maxlength="20" class="input-medium Wdate" style="width:163px;"
				value="<fmt:formatDate value="${acad.startDate}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd'});"/>
				　--　
			<input id="endDate" name="endDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate" style="width:163px;"
				value="<fmt:formatDate value="${acad.endDate}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd'});"/>
			&nbsp;<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
		</div>
	</form:form>
	<tags:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead><tr>
			<th>学会名称</th>
			<th>创建人</th>
			<th>所属科室</th>
			<th>级别</th>
			<th>学会职务</th>
			<th>开始时间</th>
			<th>结束时间</th>
			<th>当前节点</th>
			<th>延期</th>
			<th>操作</th>
		</tr></thead>
		<tbody>
		<c:forEach items="${page.list}" var="acad">
			<c:set var="task" value="${acad.task }" />
			<c:set var="pi" value="${acad.processInstance }" />
			<c:set var="hpi" value="${acad.historicProcessInstance }" />
			<tr>
				<td>${acad.acadName}</td>
				<td>${acad.user.name}</td>
				<td>${acad.office.name}</td>
				<td>${fns:getDictLabel(acad.level, 'acad_level_type', '无')}</td>
				<td>${fns:getDictLabel(acad.exerciseRole, 'acad_exercise_role', '无')}</td>
				<td><fmt:formatDate value="${acad.startDate}" pattern="yyyy-MM-dd" type="both"/></td>
				<td><fmt:formatDate value="${acad.endDate}" pattern="yyyy-MM-dd" type="both"/></td>
				<c:if test="${not empty task}">
					<td>${task.name}</td>
				</c:if>
				<c:if test="${empty task}">
					<td>已结束</td>
				</c:if>
				<c:if test="${acad.isputoff}">
					<td><a href="${ctx}/oa/acad/putoff?id=${acad.id}">是</a>&nbsp;&nbsp;、<a href="${ctx}/oa/acad/setfinished?id=${acad.id}">否</a></td>
				</c:if>
				<c:if test="${!acad.isputoff && acad.isFinished eq '0'}">
					<td>任职未到期</td>
				</c:if>
				<c:if test="${acad.isFinished eq '1'}">
					<td>任职结束</td>
				</c:if>
				<c:if test="${acad.taskKey eq 'kjDeptAudit'}">
					<td><a href="${ctx}/oa/acad/editform?id=${acad.id}">编辑</a></td>
				</c:if>
				<c:if test="${acad.taskKey ne 'kjDeptAudit'}">
					<td></td>
				</c:if>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>
