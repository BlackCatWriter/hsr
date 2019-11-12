<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>文章管理</title>
<meta name="decorator" content="default" />
<%@include file="/WEB-INF/views/include/dialog.jsp"%>
<style type="text/css">
.sort {
	color: #0663a2;
	cursor: pointer;
}
</style>
<script type="text/javascript">
$(document).ready(function() {
    $("#btnExport").click(function() {
        top.$.jBox.confirm("确认要导出论文数据吗？", "系统提示",
        function(v, h, f) {
            if (v == "ok") {
                $("#searchForm").attr("action", "${ctx}/cms/thesis/export");
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
    $("#searchForm").attr("action", "${ctx}/cms/thesis/search");
    $("#searchForm").submit();
    return false;
}
</script>
</head>
<body>
	<div id="importBox" class="hide">
		<form id="importForm" action="${ctx}/cms/thesis/import" method="post" enctype="multipart/form-data"
			style="padding-left: 20px; text-align: center;" class="form-search" onsubmit="loading('正在导入，请稍等...');">
			<br /> <input id="uploadFile" name="file" type="file" style="width: 330px" /><br /> <br /> <input
				id="btnImportSubmit" class="btn btn-primary" type="submit" value="   导    入   " /> <a
				href="${ctx}/cms/thesis/import/template">下载模板</a>
		</form>
	</div>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/cms/thesis">论文列表</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="thesis" action="${ctx}/cms/thesis/search" method="post"
		class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}" />
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}" />
		<label>归属科室：</label>
		<tags:treeselect id="office" name="office.id" value="${thesis.office.id}" labelName="office.name"
			labelValue="${thesis.office.name}" title="科室" url="/sys/office/treeData?type=2" cssClass="input-small"
			allowClear="true" notAllowSelectParent="true" />
		<label>论文题目：</label>
		<form:input path="title" htmlEscape="false" maxlength="50" class="input-medium" />&nbsp;
		&nbsp;&nbsp;
		<label>论文类别：</label>
		<form:select path="category">
			<form:options items="${fns:getDictList('thesis_category_type')}" itemLabel="label" itemValue="value"
				htmlEscape="false" />
		</form:select>&nbsp;
		&nbsp;&nbsp;
	<div style="margin-top: 8px;"></div>
		<label>论文等级：</label>
		<form:select path="level">
			<form:options items="${fns:getDictList('thesis_level_type')}" itemLabel="label" itemValue="value" htmlEscape="false" />
		</form:select>
			&nbsp; &nbsp;&nbsp; <label>状态：</label>
		<form:select path="delFlag">
			<form:options items="${fns:getDictList('cms_del_flag')}" itemLabel="label" itemValue="value" htmlEscape="false" />
		</form:select>
		<label>影响因子：</label>
		<form:input path="impact_factor" htmlEscape="false" maxlength="50" class="input-medium" />&nbsp;
			&nbsp; &nbsp;&nbsp;
			<div style="margin-top: 8px;">
			<label>发表时间：</label> <input id="searchYear" name="searchYear" type="text" readonly="readonly" maxlength="20"
				class="input-medium Wdate" style="width: 163px;" value="${thesis.searchYear}"
				onclick="WdatePicker({dateFmt:'yyyy'});" />
			&nbsp;&nbsp;&nbsp;
			<label>审批时间：</label> <input id="updateDate" name="updateDate" type="text" readonly="readonly" maxlength="20"
				class="input-medium Wdate"  value="${thesis.updateDate}"
				onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false})" /> 
			&nbsp;<input id="btnSubmit" class="btn btn-primary" type="button"
				onclick="page()" value="查询" /> &nbsp;<input id="btnExport" class="btn btn-primary" type="button" value="导出" />
				<c:if test="${fns:isKJDept()}">
			&nbsp;<input id="btnImport" class="btn btn-primary" type="button" value="导入" />
			</c:if>
		</div>
	</form:form>
	<div style="margin-top: 8px;"></div>
	<tags:message content="${message}" />
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>所属科室</th>
				<th>论文题目</th>
				<th>关联项目</th>
				<th>通讯作者</th>
				<th>第一作者</th>
				<th>第二作者</th>
				<th>第三作者</th>
				<th>权属</th>
				<th>杂志名称</th>
				<th>年卷期</th>
				<th>论文等级</th>
				<th>论文类别</th>
				<th>影响因子</th>
				<th>版面费</th>
				<th>权重</th>
				<th>状态更新时间</th>
				<th>状态</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${page.list}" var="thesis">
				<tr>
					<td><a href="javascript:"
						onclick="$('#officeId').val('${thesis.office.id}');$('#officeName').val('${thesis.office.name}');$('#searchForm').submit();return false;">${thesis.office.name}</a></td>
					<td>${thesis.title}</td>
					<th><a href="${ctx}/cms/project/form?id=${thesis.project.id}">${thesis.projectNo}</a></th>
					<td>${thesis.co_authorDisplayName}</td>
					<td>${thesis.author1DisplayName}</td>
					<td>${thesis.author2DisplayName}</td>
					<td>${thesis.author3DisplayName}</td>
					<td>${thesis.weightBelongDisplayName}</td>
					<td>${thesis.mag_name}</td>
					<td>${thesis.annual_volume}</td>
					<td>${thesis.thesisLevel}</td>
					<td>${thesis.thesisCategory}</td>
					<td>${thesis.impact_factor}</td>
					<td>${thesis.ybm_fee}</td>
					<td>${thesis.weight}</td>
					<td>${thesis.updateDate}</td>
					<td>${fns:getDictLabel(thesis.delFlag, 'cms_del_flag', '无')}</td>
					<td><a href="${ctx}/cms/thesis/form?id=${thesis.id}">查看</a></td>

				</tr>
			</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>