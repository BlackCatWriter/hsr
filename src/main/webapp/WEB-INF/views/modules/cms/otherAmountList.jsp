<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>其它报销明细</title>
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
    $("#searchForm").attr("action", "${ctx}/cms/account/otherAccountDetail");
    $("#searchForm").submit();
    return false;
}
</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/cms/account/otherAccountDetail">其它报销明细</a></li>
	</ul>
	<form:form id="searchForm" action="${ctx}/cms/account/otherAccountDetail" method="post"
		class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}" />
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}" />
		<label>申请人：</label><input type="text" value="${paramMap.name}" placeholder="" name="name" class="input-medium"/>
        <label>学术主题：&nbsp;</label><input type="text" value="${paramMap.topic}" placeholder="" name="topic" class="input-medium"/>
        <input id="btnSubmit" class="btn btn-primary" type="submit" value="查询" onclick="page();" /> &nbsp;
        <input id="btnExport" class="btn btn-primary" type="button" value="导出" />
	</form:form>
	<div style="margin-top: 8px;"></div>
	<tags:message content="${message}" />
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>姓名</th>
				<th>所属科室</th>
				<th>学术主题</th>
				<th>报销金额</th>
				<th>报销时间</th>
				<th>备注</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${page.list}" var="amount">
				<tr>
					<td>${amount.name}</td>
					<td>${amount.dept_name}</td>
					<td>${amount.topic}</td>
					<td>${amount.bx_fee}</td>
					<td>${amount.update_date}</td>
					<td>${amount.remarks}</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>