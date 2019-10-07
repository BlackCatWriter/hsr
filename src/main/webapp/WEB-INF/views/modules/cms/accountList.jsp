<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>经费入账明细</title>
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
                $("#searchForm").attr("action", "${ctx}/cms/expense/export");
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
    $("#searchForm").attr("action", "${ctx}/cms/account/search");
    $("#searchForm").submit();
    return false;
}
</script>
</head>
<body>
	<div id="importBox" class="hide">
		<form id="importForm" action="${ctx}/cms/expense/import" method="post" enctype="multipart/form-data"
			style="padding-left: 20px; text-align: center;" class="form-search" onsubmit="loading('正在导入，请稍等...');">
			<br /> <input id="uploadFile" name="file" type="file" style="width: 330px" /><br /> <br /> <input
				id="btnImportSubmit" class="btn btn-primary" type="submit" value="   导    入   " /> <a
				href="${ctx}/cms/expense/import/template">下载模板</a>
		</form>
	</div>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/cms/account/search">经费入账明细</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="account" action="${ctx}/cms/account/search" method="post"
		class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}" />
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}" />
		<label>项目名：&nbsp;</label>
		<form:select path="project.id">
			<option value="" label="" />
			<form:options items="${projectList}" itemLabel="projectName" itemValue="id" htmlEscape="false" />
		</form:select>&nbsp;
		<label>立项号：&nbsp;</label><form:input path="project.projectNo" htmlEscape="false" maxlength="50" class="input-medium"/>
		&nbsp;&nbsp;<input id="btnSubmit"
			   		class="btn btn-primary" type="submit" value="查询" onclick="page();" /> &nbsp;<input id="btnExport"
					class="btn btn-primary" type="button" value="导出" />
	</form:form>
	<div style="margin-top: 8px;"></div>
	<tags:message content="${message}" />
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>立项号</th>
				<th>项目名</th>
				<th>拨款单位</th>
				<th>拨款批次</th>
				<th>下拨经费</th>
				<th>配套经费</th>
				<th>实到经费</th>
				<th>拨款日期</th>
				<th>备注</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${page.list}" var="account">
				<tr>
					<th><a href="${ctx}/cms/project/form?id=${account.project.id}">${account.projectNo}</a></th>
					<td>${account.project.projectName}</td>
					<td>${account.approp_depart}</td>
					<td>${account.approp_batch}</td>
					<td>${account.xb_fee}</td>
					<td>${account.sd_fee}</td>
					<td>${account.pt_fee}</td>
					<td>${account.approp_date}</td>
					<td>${account.remarks}</td>
				</tr>
			</c:forEach>
			<tr style="font-weight: bold">
				<td colspan="4" style="text-align:right;vertical-align:middle;">合计</td>
				<td>${totleMap.xb_fee}</td>
				<td>${totleMap.sd_fee}</td>
				<td>${totleMap.pt_fee}</td>
				<td></td>
				<td></td>
			</tr>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>