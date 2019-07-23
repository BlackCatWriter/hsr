<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>学术会议申请一览</title>
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
		<li><a href="${ctx}/oa/academic/form">学术会议</a></li>
		<li><a href="${ctx}/oa/academic/cost">学术活动经费报销</a></li>
		<li class="active"><a href="${ctx}/oa/academic/list">所有任务</a></li>
		<li><a href="${ctx}/oa/academic/task">待办任务</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="academic" action="${ctx}/oa/academic/list" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<div>
			<label>会议名称：&nbsp;</label><form:input path="academicName" htmlEscape="false" maxlength="50" class="input-medium"/>
			&nbsp;<label>会议级别：&nbsp;</label>
				<form:select path="level" >
					<form:options id="level" items="${fns:getDictList('academic_level_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			&nbsp;<label>只看本人：&nbsp;</label><form:checkbox id="selfOnly" path="selfOnly" />
		</div>
		<div style="margin-top:8px;">
			<label>会议时间：</label>
			<input id="startDate"  name="startDate"  type="text" readonly="readonly" maxlength="20" class="input-medium Wdate" style="width:163px;"
				value="<fmt:formatDate value="${academic.startDate}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd'});"/>
				　--　
			<input id="endDate" name="endDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate" style="width:163px;"
				value="<fmt:formatDate value="${academic.endDate}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd'});"/>
			&nbsp;<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
		</div>
	</form:form>
	<tags:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead><tr>
			<th>会议名称</th>
			<th>创建人</th>
			<th>所属科室</th>
			<th>会议地点</th>
			<th>主办单位</th>
			<th>参会形式</th>
			<th>开始时间</th>
			<th>结束时间</th>
			<th>当前节点</th>
			<th>操作</th>
		</tr></thead>
		<tbody>
		<c:forEach items="${page.list}" var="academic">
			<c:set var="task" value="${academic.task }" />
			<c:set var="pi" value="${academic.processInstance }" />
			<c:set var="hpi" value="${academic.historicProcessInstance }" />
			<tr>
				<td>${academic.academicName}</td>
				<td>${academic.user.name}</td>
				<td>${academic.office.name}</td>
				<td>${academic.place}</td>
				<td>${academic.hostUnit}</td>
				<td>${academic.exerciseRole}</td>
				<td><fmt:formatDate value="${academic.startDate}" pattern="yyyy-MM-dd" type="both"/></td>
				<td><fmt:formatDate value="${academic.endDate}" pattern="yyyy-MM-dd" type="both"/></td>
				<c:if test="${not empty task}">
					<td>${task.name}</td>
				</c:if>
				<c:if test="${empty task}">
					<td>已结束</td>
				</c:if>
				<c:if test="${academic.taskKey eq 'kjDeptAudit'}">
					<td><a href="${ctx}/oa/academic/editform?id=${academic.id}">编辑</a></td>
				</c:if>
				<c:if test="${academic.taskKey ne 'kjDeptAudit'}">
					<td></td>
				</c:if>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>
