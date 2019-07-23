<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>绩效管理</title>
	<meta name="decorator" content="default"/>
		<%@include file="/WEB-INF/views/include/dialog.jsp" %>
	<style type="text/css">.sort{color:#0663A2;cursor:pointer;}</style>
	<script type="text/javascript">
	$(document).ready(function() {
	    $("#searchForm").validate({
	        submitHandler: function(form) {
	            loading('正在提交，请稍等...');
	            form.submit();
	        },
	        errorContainer: "#messageBox",
	        errorPlacement: function(error, element) {
	            $("#messageBox").text("输入有误，请先更正。");
	            if (element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-append")) {
	                error.appendTo(element.parent().parent());
	            } else {
	                error.insertAfter(element);
	            }
	        }
	    });
	});
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/cms/performance">个人绩效</a></li>
		<c:if test="${fns:isManager()}"> 
		<li><a href="${ctx}/cms/performance/dept">科室绩效</a></li>
		</c:if>
		<c:if test="${fns:isKJDept() or fns:isHosLeader()}"> 
		<li><a href="${ctx}/cms/performance/total">全院绩效</a></li>
		</c:if>
	</ul>
	<form:form id="searchForm" modelAttribute="performance" action="${ctx}/cms/performance/list" method="post" class="breadcrumb form-search">
		<!-- <label>归属科室：</label><tags:treeselect id="office" name="office.id" value="${performance.office.id}" labelName="office.name" labelValue="${performance.office.name}" 
				title="科室" url="/sys/office/treeData?type=2" cssClass="input-small" allowClear="true" notAllowSelectParent="true"/> -->
		<label>权属：</label>
			<c:if test="${not fns:isManager()}"> 
			<form:input type="hidden" path="weightBelong"/>
			<form:input type="text" path="weightBelongDisplayName" readonly="true"/>
			</c:if>
			<c:if test="${fns:isManager()}"> 
				<tags:nameSuggest value="${performance.weightBelong}" labelValue="${performance.weightBelongDisplayName}" cssClass="required"
					name="weightBelong" id="weightBelong" url="${ctx}/sys/user/users/"></tags:nameSuggest>&nbsp;
				</c:if>
		&nbsp;&nbsp;
		<div style="margin-top:8px;">
		<label>年份：</label>
		<input id="searchYear"  name="searchYear"  type="text" readonly="readonly" maxlength="20" class="input-medium Wdate required" style="width:163px;" value="${performance.searchYear}"
		onclick="WdatePicker({dateFmt:'yyyy'});"/>
		&nbsp;<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
	</div>
	</form:form>
	<div style="margin-top:8px;"/>
	<tags:message content="${message}"/>
	<div class="control-group">
			<label class="control-label">个人信息：</label>
			<div class="controls">
				<label>姓名：</label>
				<input value="${performance.weightBelongUser.name}" readonly="readonly"/>
				<label>所属科室：</label>
				<input value="${performance.weightBelongUser.office.name}" readonly="readonly"/>
				<label>职称：</label>
				<input value="${fns:getDictLabel(performance.weightBelongUser.title,'userTitle','')}" readonly="readonly"/>
			</div>
			<c:if test="${!empty performance.thesisList}">
		<label class="control-label">论文信息：</label>
		<div class="controls">
			<table id="contentTable" class="table table-striped table-bordered table-condensed">
				<thead>
					<tr>
						<th>论文题目</th>
						<th>杂志名称</th>
						<th>年卷期</th>
						<th>论文等级</th>
						<th>论文类别</th>
						<th>权重</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${performance.thesisList}" var="thesis">
						<tr>
							<td>${thesis.title}</td>
							<td>${thesis.mag_name}</td>
							<td>${thesis.annual_volume}</td>
							<td>${thesis.thesisLevel}</td>
							<td>${thesis.thesisCategory}</td>
							<td>${thesis.weight}</td>
							<td><a href="${ctx}/cms/thesis/form?id=${thesis.id}">查看</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		</c:if>
		<c:if test="${!empty performance.projectList}">
		<label class="control-label">项目信息：</label>
		<div class="controls">
			<table id="contentTable" class="table table-striped table-bordered table-condensed">
				<thead>
					<tr>
						<th>项目题目</th>
						<th>立项编号</th>
						<th>立项单位</th>
						<th>项目等级</th>
						<th>权重</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${performance.projectList}" var="project">
						<tr>
							<td>${project.projectName}</td>
							<td>${project.projectNo}</td>
							<td>${project.approvalOrg}</td>
							<td>${project.projectLevel}</td>
							<td>${project.weight}</td>
							<td><a href="${ctx}/cms/project/form?id=${project.id}">查看</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		
		</c:if>
		<c:if test="${!empty performance.newTecRewardList}">
		<label class="control-label">新技术引进奖信息：</label>
		<div class="controls">
			<table id="contentTable" class="table table-striped table-bordered table-condensed">
				<thead>
					<tr>
						<th>项目题目</th>
						<th>获奖等级</th>
						<th>获奖级别</th>
						<th>权重</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${performance.newTecRewardList}" var="reward">
						<tr>
							<td>${reward.rewardName}</td>
							<td>${reward.rewardGrade}</td>
							<td>${reward.rewardLevel}</td>
							<td>${reward.weight}</td>
							<td><a href="${ctx}/cms/reward/form?id=${reward.id}">查看</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		
		</c:if>
		<c:if test="${!empty performance.rewardList}">
		<label class="control-label">科技进步奖信息：</label>
		<div class="controls">
			<table id="contentTable" class="table table-striped table-bordered table-condensed">
				<thead>
					<tr>
						<th>项目题目</th>
						<th>获奖等级</th>
						<th>获奖级别</th>
						<th>权重</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${performance.rewardList}" var="reward">
						<tr>
							<td>${reward.rewardName}</td>
							<td>${reward.rewardGrade}</td>
							<td>${reward.rewardLevel}</td>
							<td>${reward.weight}</td>
							<td><a href="${ctx}/cms/reward/form?id=${reward.id}">查看</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		</c:if>
		<c:if test="${!empty performance.tecAdvrewardList}">
		<label class="control-label">院重大领先实用进步奖信息：</label>
		<div class="controls">
			<table id="contentTable" class="table table-striped table-bordered table-condensed">
				<thead>
					<tr>
						<th>项目题目</th>
						<th>获奖等级</th>
						<th>获奖级别</th>
						<th>权重</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${performance.tecAdvrewardList}" var="reward">
						<tr>
							<td>${reward.rewardName}</td>
							<td>${reward.rewardGrade}</td>
							<td>${reward.tecRewardGrade}</td>
							<td>${reward.weight}</td>
							<td><a href="${ctx}/cms/reward/form?id=${reward.id}">查看</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		</c:if>
		<c:if test="${!empty performance.bookList}">
		<label class="control-label">著作信息：</label>
		<div class="controls">
			<table id="contentTable" class="table table-striped table-bordered table-condensed">
				<thead>
					<tr>
						<th>题目</th>
						<th>出版社</th>
						<th>书刊号</th>
						<th>担任角色</th>
						<th>权重</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${performance.bookList}" var="book">
						<tr>
							<td>${book.title}</td>
							<td>${book.publisher}</td>
							<td>${book.number}</td>
							<td>${book.role}</td>
							<td>${book.weight}</td>
							<td><a href="${ctx}/cms/book/form?id=${book.id}">查看</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		</c:if>
		<c:if test="${!empty performance.patentList}">
		<label class="control-label">专利信息：</label>
		<div class="controls">
			<table id="contentTable" class="table table-striped table-bordered table-condensed">
				<thead>
					<tr>
						<th>题目</th>
						<th>专利号</th>
						<th>授权时间</th>
						<th>专利类型</th>
						<th>权重</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${performance.patentList}" var="patent">
						<tr>
							<td>${patent.title}</td>
							<td>${patent.number}</td>
							<td>${patent.time}</td>
							<td>${patent.patentCategory}</td>
							<td>${patent.weight}</td>
							<td><a href="${ctx}/cms/patent/form?id=${patent.id}">查看</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		</c:if>
		</div>
</body>
</html>