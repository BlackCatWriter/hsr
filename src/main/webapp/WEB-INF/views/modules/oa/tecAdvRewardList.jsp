<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>院重大实用领先技术奖申请一览</title>
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
	<li><a href="${ctx}/oa/tecAdvReward/form">院重大实用领先技术奖登记</a></li>
		<li class="active"><a href="${ctx}/oa/tecAdvReward/list">所有任务</a></li>
		<li><a href="${ctx}/oa/tecAdvReward/task">待办任务</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="reward" action="${ctx}/oa/tecAdvReward/list" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<div>
			<label>申请编号：&nbsp;</label><form:input path="ids" htmlEscape="false" maxlength="50" class="input-medium" placeholder="多个用逗号或空格隔开"/>
			<label>立项号：&nbsp;</label><form:input path="project.projectNo" htmlEscape="false" maxlength="50" class="input-medium"/>
			&nbsp;<label>只看本人：&nbsp;</label><form:checkbox id="selfOnly" path="selfOnly" />
		</div>
		<div style="margin-top:8px;">
			<label>获奖年限：</label>
			<input id="year"  name="year"  type="text" readonly="readonly" maxlength="20" class="input-medium Wdate" style="width:163px;"
				value="<fmt:formatDate value="${reward.searchYear}" pattern="yyyy"/>"
					onclick="WdatePicker({dateFmt:'yyyy'});"/>
			&nbsp;<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
		</div>
	</form:form>
	<tags:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead><tr>
			<th>申请编号</th>
			<th>院重大实用领先技术奖题目</th>
			<th>创建人</th>
			<th>奖项等级</th>
			<th>奖项级别</th>
			<th>关联项目</th>
			<th>进度追踪</th>
			<th>创建时间</th>
			<th>当前节点</th>
			<th>操作</th>
		</tr></thead>
		<tbody>
		<c:forEach items="${page.list}" var="reward">
			<c:set var="task" value="${reward.task }" />
			<c:set var="pi" value="${reward.processInstance }" />
			<c:set var="hpi" value="${reward.historicProcessInstance }" />
			<tr>
				<td>${reward.id}</td>
				<c:if test="${empty reward.file}">
					<td>${reward.rewardName}</td>
				</c:if>
				<c:if test="${not empty reward.file}">
					<td><a href="${ctx}/oa/reward/get/${reward.id}" target='_blank'>${reward.rewardName}</a></td>
				</c:if>
				<td>${reward.createBy.name}</td>
				<td>${fns:getDictLabel(reward.level, 'reward_level', '无')}</td>
				<td>${fns:getDictLabel(reward.grade, 'reward_gradetech', '无')}</td>
				<th>${reward.project.projectNo}</th>
				<td>${reward.processStatus}</td>
				<td>${reward.createDate}</td>
				<c:if test="${not empty task}">
					<td>${task.name}</td>
				</c:if>
				<c:if test="${empty task}">
					<td>已结束</td>
				</c:if>
				<c:if test="${reward.taskKey eq 'kjDeptAudit'}">
					<td><a href="${ctx}/oa/tecAdvReward/editform?id=${reward.id}">编辑</a></td>
				</c:if>
				<c:if test="${reward.taskKey ne 'kjDeptAudit'}">
					<td></td>
				</c:if>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>
