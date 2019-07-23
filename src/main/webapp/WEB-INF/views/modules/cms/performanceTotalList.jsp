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
                $("#searchForm").attr("action", "${ctx}/cms/performance/totalExport");
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
		<li><a href="${ctx}/cms/performance/dept">科室绩效</a></li>
		</c:if>
		<c:if test="${fns:isKJDept() or fns:isHosLeader()}"> 
		<li class="active"><a href="${ctx}/cms/performance/total">全院绩效</a></li>
		</c:if>
	</ul>
	<form:form id="searchForm" modelAttribute="performance" action="${ctx}/cms/performance/total" method="post"
		class="breadcrumb form-search">
		<div style="margin-top: 8px;">
			<label>年份：</label> <input id="searchYear" name="searchYear" type="text" readonly="readonly" maxlength="20"
				class="input-medium Wdate required" style="width: 163px;" value="${performance.searchYear}"
				onclick="WdatePicker({dateFmt:'yyyy'});" /> &nbsp;<input id="btnSubmit" class="btn btn-primary" type="submit"
				value="查询" /> &nbsp;<input id="btnExport" class="btn btn-primary" type="button" value="导出" /> 
		</div>
	</form:form>
	<div style="margin-top: 8px;"></div>
	<tags:message content="${message}" />
	<div style="max-width:100%;overflow:auto;">
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>科室</th>
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
			<c:forEach items="${performance.deptModels}" var="deptModel">
				<tr>
					<td>${deptModel.office.name}</td>
					<td>${deptModel.countryCount}</td>
					<td>${deptModel.countryWeight}</td>
					<td>${deptModel.provinceCount}</td>
					<td>${deptModel.provinceWeight}</td>
					<td>${deptModel.otherProjectCount}</td>
					<td>${deptModel.otherProjectWeight}</td>
					<td>${deptModel.sciCount}</td>
					<td>${deptModel.sciWeight}</td>
					<td>${deptModel.chineseCount}</td>
					<td>${deptModel.chineseWeight}</td>
					<td>${deptModel.otherCount}</td>
					<td>${deptModel.otherWeight}</td>
					<td>${deptModel.newTecCount}</td>
					<td>${deptModel.newTecWeight}</td>
					<td>${deptModel.tecProCount}</td>
					<td>${deptModel.tecProWeight}</td>
					<td>${deptModel.tecAdvCount}</td>
					<td>${deptModel.tecAdvWeight}</td>
					<td>${deptModel.patentCount}</td>
					<td>${deptModel.patentWeight}</td>
					<td>${deptModel.bookCount}</td>
					<td>${deptModel.bookWeight}</td>
					<td>${deptModel.totalWeight}</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	</div>
</body>
</html>