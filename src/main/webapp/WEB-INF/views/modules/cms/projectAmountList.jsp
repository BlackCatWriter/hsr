<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>经费年度统计</title>
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
    $("#btnExport").click(function() {
        top.$.jBox.confirm("确认要导出经费数据吗？", "系统提示",
        function(v, h, f) {
            if (v == "ok") {
                $("#searchForm").attr("action", "${ctx}/cms/account/exportAccountYear");
                $("#searchForm").submit();
            }
        },
        {
            buttonsFocus: 1
        });
        top.$('.jbox-body .jbox-icon').css('top', '55px');
    });
});
function page(n, s) {
    $("#pageNo").val(n);
    $("#pageSize").val(s);
    $("#searchForm").attr("action", "${ctx}/cms/account/projectAccountByYear");
    $("#searchForm").submit();
    return false;
}
</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/cms/account/projectAccountByYear">经费年度统计</a></li>
	</ul>
	<form:form id="searchForm" action="${ctx}/cms/account/projectAccountByYear" method="post"
		class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}" />
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}" />
		<label>项目名称：</label>
		<select name="project_name" class="span2">
			<option value=""></option>
			<c:forEach items="${projectList}" var="project">
				<c:if test="${project.projectName eq paramMap.project_name}">
					<option value="${project.projectName}" selected="selected">${project.projectName }</option>
				</c:if>
				<c:if test="${project.projectName != paramMap.project_name}">
					<option value="${project.projectName}" >${project.projectName }</option>
				</c:if>
			</c:forEach>
		</select>
        <label>立项号：&nbsp;</label><input type="text" value="${paramMap.project_no}" placeholder="" name="project_no" class="input-medium"/>
        <label>年份：</label>
        <input id="year"  name="year"  type="text" readonly="readonly" maxlength="20" class="input-medium Wdate required"
               style="width:163px;" value="${paramMap.year}" onclick="WdatePicker({dateFmt:'yyyy'});"/>
        <input id="btnSubmit" class="btn btn-primary" type="submit" value="查询" onclick="page();" /> &nbsp;
        <input id="btnExport" class="btn btn-primary" type="button" value="导出" />
		<%--<form:select path="project_name">
			<option value="" label="" />
			<form:options items="${projectList}" itemLabel="projectName" itemValue="projectName" htmlEscape="false" />
		</form:select>&nbsp;--%>
		<%--<label>立项号：&nbsp;</label><form:input path="project_no" htmlEscape="false" maxlength="50" class="input-medium"/>--%>
		&nbsp;&nbsp;
		<%--<div style="margin-top: 8px;">
                <input id="btnSubmit" class="btn btn-primary" type="submit" value="查询" onclick="page();" /> &nbsp;<input id="btnExport"
				class="btn btn-primary" type="button" value="导出" />
		</div>--%>
	</form:form>
	<div style="margin-top: 8px;"></div>
	<tags:message content="${message}" />
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>立项号</th>
				<th>项目名称</th>
				<th>年度</th>
				<th>课题总计预算</th>
				<th>课题累计支出</th>
				<th>经费余额</th>
				<th>备注</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${page.list}" var="amount">
				<tr>
					<td>${amount.project_no}</td>
					<td>${amount.project_name}</td>
					<td>${amount.year}</td>
					<td>${amount.budget}</td>
					<td>${amount.expend}</td>
					<td>${amount.balance}</td>
					<td></td>
				</tr>
			</c:forEach>
			<tr style="font-weight: bold">
				<td colspan="3" style="text-align:right;vertical-align:middle;">合计</td>
				<td>${totleMap.budget}</td>
				<td>${totleMap.expend}</td>
				<td>${totleMap.balance}</td>
			</tr>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>