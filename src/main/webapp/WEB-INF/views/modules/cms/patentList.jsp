<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>专利管理</title>
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
        top.$.jBox.confirm("确认要导出专利数据吗？", "系统提示",
        function(v, h, f) {
            if (v == "ok") {
                $("#searchForm").attr("action", "${ctx}/cms/patent/export");
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
    $("#searchForm").attr("action", "${ctx}/cms/patent/search");
    $("#searchForm").submit();
    return false;
}
</script>
</head>
<body>
	<div id="importBox" class="hide">
		<form id="importForm" action="${ctx}/cms/patent/import" method="post" enctype="multipart/form-data"
			style="padding-left: 20px; text-align: center;" class="form-search" onsubmit="loading('正在导入，请稍等...');">
			<br /> <input id="uploadFile" name="file" type="file" style="width: 330px" /><br />
			<br /> <input id="btnImportSubmit" class="btn btn-primary" type="submit" value="   导    入   " /> <a
				href="${ctx}/cms/patent/import/template">下载模板</a>
		</form>
	</div>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/cms/patent">专利列表</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="patent" action="${ctx}/cms/patent/search" method="post"
		class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}" />
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}" />
		<label>归属科室：</label>
		<tags:treeselect id="office" name="office.id" value="${patent.office.id}" labelName="office.name"
			labelValue="${patent.office.name}" title="科室" url="/sys/office/treeData?type=2" cssClass="input-small"
			allowClear="true" notAllowSelectParent="true" />
		<label>专利题目：</label>
		<form:input path="title" htmlEscape="false" maxlength="50" class="input-medium" />&nbsp;
		&nbsp;&nbsp;
		<label>专利类别：</label>
		<form:select path="category">
			<form:options items="${fns:getDictList('patent_category_type')}" itemLabel="label" itemValue="value"
				htmlEscape="false" />
		</form:select>
			&nbsp; &nbsp;&nbsp;
			<div style="margin-top: 8px;">
			<label>状态：</label>
			<form:select path="delFlag">
				<form:options items="${fns:getDictList('cms_del_flag')}" itemLabel="label" itemValue="value" htmlEscape="false" />
			</form:select>
				<label>发表时间：</label> <input id="searchYear" name="searchYear" type="text" readonly="readonly" maxlength="20"
					class="input-medium Wdate" style="width: 163px;" value="${patent.searchYear}"
					onclick="WdatePicker({dateFmt:'yyyy'});" /> &nbsp;<input id="btnSubmit" class="btn btn-primary" type="submit"
					value="查询" onclick="page();"/> &nbsp;<input id="btnExport" class="btn btn-primary" type="button" value="导出" />
				<c:if test="${fns:isKJDept()}"> &nbsp;<input
					id="btnImport" class="btn btn-primary" type="button" value="导入" /></c:if>
			</div>
	</form:form>
	<div style="margin-top: 8px;"></div>
		<tags:message content="${message}" />
		<table id="contentTable" class="table table-striped table-bordered table-condensed">
			<thead>
				<tr>
					<th>所属科室</th>
					<th>专利题目</th>
					<th>关联项目</th>
					<th>第一完成人</th>
					<th>第二完成人</th>
					<th>第三完成人</th>
					<th>其他完成人</th>
					<th>权属</th>
					<th>授权时间</th>
					<th>专利类别</th>
					<th>权重</th>
					<th>奖励金额</th>
					<th>备注</th>
					<th>发布者</th>
					<th>创建时间</th>
					<th>状态</th>
					<th>操作</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${page.list}" var="patent">
					<tr>
						<td><a href="javascript:"
							onclick="$('#officeId').val('${patent.office.id}');$('#officeName').val('${patent.office.name}');$('#searchForm').submit();return false;">${patent.office.name}</a></td>
						<td>${patent.title}</td>
						<th><a href="${ctx}/cms/project/form?id=${patent.project.id}">${patent.projectNo}</a></th>
						<td>${patent.author1DisplayName}</td>
						<td>${patent.author2DisplayName}</td>
						<td>${patent.author3DisplayName}</td>
						<td>${patent.otherAuthorDisplayName}</td>
						<td>${patent.weightBelongDisplayName}</td>
						<td>${patent.time}</td>
						<td>${patent.patentCategory}</td>
						<td>${patent.weight}</td>
						<td>${patent.jl}</td>
						<td>${patent.remarks}</td>
						<td>${patent.createBy.name}</td>
						<td><fmt:formatDate value="${patent.createDate}" type="both" /></td>
						<td>${fns:getDictLabel(patent.delFlag, 'cms_del_flag', '无')}</td>
						<td><a href="${ctx}/cms/patent/form?id=${patent.id}">查看</a></td>

					</tr>
				</c:forEach>
			</tbody>
		</table>
		<div class="pagination">${page}</div>
</body>
</html>