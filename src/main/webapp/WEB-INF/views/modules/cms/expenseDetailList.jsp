<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>经费支出明细</title>
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
        top.$.jBox.confirm("确认要导出经费支出明细数据吗？", "系统提示",
        function(v, h, f) {
            if (v == "ok") {
                $("#searchForm").attr("action", "${ctx}/cms/account/exportExpenseDetail");
                $("#searchForm").submit();
            }
        },
        {
            buttonsFocus: 1
        });
        top.$('.jbox-body .jbox-icon').css('top', '55px');
    });
    $("#btnImport").click(function() {
        $.jBox($("#importBox").html(), {
            title: "导入数据",
            buttons: {
                "关闭": true
            },
            bottomText: "导入文件不能超过5M，仅允许导入“xls”或“xlsx”格式文件！"
        });
    });
});
function page(n, s) {
    $("#pageNo").val(n);
    $("#pageSize").val(s);
    $("#searchForm").attr("action", "${ctx}/cms/account/detailSearch");
    $("#searchForm").submit();
    return false;
}
</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/cms/expense">经费支出明细</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="expense" action="${ctx}/cms/account/detailSearch" method="post"
		class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}" />
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}" />
		<label>项目名：&nbsp;</label>
		<form:select path="project.id">
			<option value="" label="" />
			<form:options items="${projectList}" itemLabel="projectName" itemValue="id" htmlEscape="false" />
		</form:select>&nbsp;
		<label>立项号：&nbsp;</label><form:input path="project.projectNo" htmlEscape="false" maxlength="50" class="input-medium"/>
		&nbsp;&nbsp;
		<div style="margin-top: 8px;">
			<label>日期范围：&nbsp;</label><input id="beginDate" name="beginDate" type="text" readonly="readonly" maxlength="20"
				class="input-medium Wdate" value="${beginDate}" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" />
			<label>&nbsp;--&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label><input id="endDate" name="endDate" type="text"
				readonly="readonly" maxlength="20" class="input-medium Wdate" value="${endDate}"
				onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" />&nbsp; &nbsp;&nbsp; <input id="btnSubmit"
				class="btn btn-primary" type="submit" value="查询" onclick="page();" /> &nbsp;<input id="btnExport"
				class="btn btn-primary" type="button" value="导出" />
		</div>
	</form:form>
	<div style="margin-top: 8px;"></div>
	<tags:message content="${message}" />
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>立项号</th>
				<th>项目名</th>
				<th>经费类型</th>
				<th>使用人</th>
				<th>支出时间</th>
				<th>支出用途</th>
				<th>数额</th>
				<th>审核状态</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${page.list}" var="expense">
				<tr>
					<th><a href="${ctx}/cms/project/form?id=${expense.project.id}">${expense.projectNo}</a></th>
					<td>${expense.project.projectName}</td>
					<td>${expense.dicExpenseType}</td>
					<td>${expense.createBy.name}</td>
					<td>${expense.createDate}</td>
					<td>${expense.reason}</td>
					<td>${expense.amount}</td>
					<c:if test="${expense.delFlag eq '0'}">
						<td>审核中</td>
					</c:if>
					<c:if test="${expense.delFlag eq '1'}">
						<td>已驳回</td>
					</c:if>
					<c:if test="${expense.delFlag eq '2'}">
						<td>审核通过</td>
					</c:if>
					<td><a href="${ctx}/cms/expense/form?id=${expense.id}">查看</a></td>

				</tr>
			</c:forEach>
			<tr style="font-weight: bold">
				<td colspan="6" style="text-align:right;vertical-align:middle;">合计</td>
				<td>${totleMap.amount}</td>
				<td></td>
				<td></td>
			</tr>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>