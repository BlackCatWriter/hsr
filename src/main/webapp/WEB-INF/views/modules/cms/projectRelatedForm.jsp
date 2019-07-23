<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>项目内容</title>
	<meta name="decorator" content="default"/>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/cms/project/form?id=${project.id}">科研项目基本内容</a></li>
		<li class="active"><a href="${ctx}/cms/project/projectRealatedForm?id=${project.id}">关联项</a></li>
	</ul>
	<br/>
	<p>关联论文</p>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>所属科室</th>
				<th>论文题目</th>
				<th>通讯作者</th>
				<th>第一作者</th>
				<th>第二作者</th>
				<th>第三作者</th>
				<th>权属</th>
				<th>杂志名称</th>
				<th>年卷期</th>
				<th>论文等级</th>
				<th>论文类别</th>
				<th>版面费</th>
				<th>权重</th>
				<th>报销金额</th>
				<th>奖励金额</th>
				<th>备注</th>
				<th>发布者</th>
				<th>创建时间</th>
				<th>状态</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${thesisList}" var="thesis">
			<tr>
				<td>${thesis.office.name}</td>
				<td>${thesis.title}</td>
				<td>${thesis.co_authorDisplayName}</td>
				<td>${thesis.author1DisplayName}</td>
				<td>${thesis.author2DisplayName}</td>
				<td>${thesis.author3DisplayName}</td>
				<td>${thesis.weightBelongDisplayName}</td>
				<td>${thesis.mag_name}</td>
				<td>${thesis.annual_volume}</td>
				<td>${thesis.thesisLevel}</td>
				<td>${thesis.thesisCategory}</td>
				<td>${thesis.ybm_fee}</td>
				<td>${thesis.weight}</td>
				<td>${thesis.bx_fee}</td>
				<td>${thesis.jl}</td>
				<td>${thesis.remarks}</td>
				<td>${thesis.createBy.name}</td>
				<td><fmt:formatDate value="${thesis.createDate}" type="both"/></td>
				<td>${fns:getDictLabel(thesis.delFlag, 'cms_del_flag', '无')}</td>
				<td>
    				<a href="${ctx}/cms/thesis/form?id=${thesis.id}">查看详细</a>
				</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<br/>
	<br/>
	<p>新技术引进奖</p>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>所属科室</th>
				<th>专业</th>
				<th>第一完成人</th>
				<th>第二完成人</th>
				<th>第三完成人</th>
				<th>权属</th>
				<th>项目编号</th>
				<th>项目名称</th>
				<th>奖励级别</th>
				<th>奖励等级</th>
				<th>奖励金额</th>
				<th>院配套奖励金额</th>
				<th>备注</th>
				<th>发布者</th>
				<th>创建时间</th>
				<th>状态</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${achievementList}" var="achievement">
			<tr>
				<td>${achievement.office.name}</td>
				<td>${achievement.major}</td>
				<td>${achievement.author1DisplayName}</td>
				<td>${achievement.author2DisplayName}</td>
				<td>${achievement.author3DisplayName}</td>
				<td>${achievement.weightBelongDisplayName}</td>
				<td>${achievement.project.projectNo}</td>
				<td>${achievement.projectName}</td>
				<td>${achievement.achievementAwardLevel}</td>
				<td>${achievement.achievementJlLevel}</td>
				<td>${achievement.jl}</td>
				<td>${achievement.yjl}</td>
				<td>${achievement.remarks}</td>
				<td>${achievement.createBy.name}</td>
				<td><fmt:formatDate value="${achievement.createDate}" type="both"/></td>
				<td>${fns:getDictLabel(achievement.delFlag, 'cms_del_flag', '无')}</td>
				<td>
    				<a href="${ctx}/cms/achievement/form?id=${achievement.id}">查看详细</a>
				</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	
	<br/>
	<p>申请经费记录</p>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>项目批准号</th>
				<th>经费类型</th>
				<th>申请人</th>
				<th>申请原因</th>
				<th>数额</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${expenseList}" var="expense">
			<tr>
				<td>${expense.project.id}</td>
				<td>${expense.dicExpenseType}</td>
				<th>${expense.createBy.name}</th>
				<td>${expense.reason}</td>
				<td>${expense.amount}</td>
				<td>
    				<a href="${ctx}/cms/expense/form?id=${expense.id}">查看详细</a>
				</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
</body>
</html>