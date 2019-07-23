<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>绩效管理</title>
<meta name="decorator" content="default" />
<%@include file="/WEB-INF/views/include/dialog.jsp"%>
<style type="text/css">
.sort {
	color: #0663A2;
	cursor: pointer;
}
</style>
<script type="text/javascript">
$(document).ready(function() {
    $("#searchForm").validate({
        submitHandler: function(form) {
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

    $("#btnExport").click(function() {
        top.$.jBox.confirm("确认要导出绩效数据吗？", "系统提示",
        function(v, h, f) {
            if (v == "ok") {
                $("#searchForm").attr("action", "${ctx}/cms/performance/deptExport");
                $("#searchForm").submit();
            }
        },
        {
            buttonsFocus: 1
        });
        top.$('.jbox-body .jbox-icon').css('top', '55px');
    });
});
</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/cms/performance">个人绩效</a></li>
		<c:if test="${fns:isManager()}"> 
		<li class="active"><a href="${ctx}/cms/performance/dept">科室绩效</a></li>
		</c:if>
		<c:if test="${fns:isKJDept() or fns:isHosLeader()}"> 
		<li><a href="${ctx}/cms/performance/total">全院绩效</a></li>
		</c:if>
	</ul>
	<form:form id="searchForm" modelAttribute="performance" action="${ctx}/cms/performance/dept" method="post"
		class="breadcrumb form-search">
		<label>归属科室：</label>
		<c:if test="${fns:isKJDept() or fns:isHosLeader()}"> 
		<tags:treeselect id="office" name="office.id" value="${performance.office.id}" labelName="office.name"
			labelValue="${performance.office.name}" title="科室" url="/sys/office/treeData?type=2" cssClass="input-small required"
			allowClear="true" notAllowSelectParent="true" />
			</c:if>
			<c:if test="${not fns:isKJDept() and not fns:isHosLeader() and fns:isDeptLeader()}"> 
			<form:input type="hidden" path="office.id"/>
			<form:input type="text" path="office.name" readonly="true"/>
			</c:if>
		&nbsp;&nbsp;
		<div style="margin-top: 8px;">
			<label>年份：</label> <input id="searchYear" name="searchYear" type="text" readonly="readonly" maxlength="20"
				class="input-medium Wdate required" style="width: 163px;" value="${performance.searchYear}"
				onclick="WdatePicker({dateFmt:'yyyy'});" /> &nbsp;<input id="btnSubmit" class="btn btn-primary" type="submit"
				value="查询" />
			&nbsp;<input id="btnExport" class="btn btn-primary" type="button" value="导出" />
		</div>
	</form:form>
	<div style="margin-top: 8px;"></div>
	<tags:message content="${message}" />
	<div style="max-width:100%;overflow:auto;">
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>姓名</th>
				<th>国家级项目数</th>
				<th>国家级项目权重</th>
				<th>省级项目数</th>
				<th>省级项目权重</th>
				<th>其他项目数</th>
				<th>其他项目权重</th>
				<th>SCI论文数</th>
				<th>SCI论文权重</th>
				<th>中华论文数</th>
				<th>中华论文权重</th>
				<th>其他论文数</th>
				<th>其他论文权重</th>
				<th>新技术引进奖个数</th>
				<th>新技术引进奖权重</th>
				<th>科技进步奖个数</th>
				<th>科技进步奖权重</th>
				<th>院重大实用领先技术奖个数</th>
				<th>院重大实用领先技术奖权重</th>
				<th>专利数</th>
				<th>专利权重</th>
				<th>著作数</th>
				<th>著作权重</th>
				<th>总权重</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${performance.userPerformance}" var="up">
				<tr>
					<td>${up.user.name}</td>
					<td>${up.countryCount}</td>
					<td>${up.countryWeight}</td>
					<td>${up.provinceCount}</td>
					<td>${up.provinceWeight}</td>
					<td>${up.otherProjectCount}</td>
					<td>${up.otherProjectWeight}</td>
					<td>${up.sciCount}</td>
					<td>${up.sciWeight}</td>
					<td>${up.chineseCount}</td>
					<td>${up.chineseWeight}</td>
					<td>${up.otherCount}</td>
					<td>${up.otherWeight}</td>
					<td>${up.newTecCount}</td>
					<td>${up.newTecWeight}</td>
					<td>${up.tecProCount}</td>
					<td>${up.tecProWeight}</td>
					<td>${up.tecAdvCount}</td>
					<td>${up.tecAdvWeight}</td>
					<td>${up.patentCount}</td>
					<td>${up.patentWeight}</td>
					<td>${up.bookCount}</td>
					<td>${up.bookWeight}</td>
					<td>${up.totalWeight}</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	</div>
</body>
</html>