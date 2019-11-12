<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>著作管理</title>
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
        top.$.jBox.confirm("确认要导出著作数据吗？", "系统提示",
        function(v, h, f) {
            if (v == "ok") {
                $("#searchForm").attr("action", "${ctx}/cms/book/export");
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
    $("#searchForm").attr("action", "${ctx}/cms/book/search");
    $("#searchForm").submit();
    return false;
}
</script>
</head>
<body>
	<div id="importBox" class="hide">
		<form id="importForm" action="${ctx}/cms/book/import" method="post" enctype="multipart/form-data"
			style="padding-left: 20px; text-align: center;" class="form-search" onsubmit="loading('正在导入，请稍等...');">
			<br /> <input id="uploadFile" name="file" type="file" style="width: 330px" /><br />
			<br /> <input id="btnImportSubmit" class="btn btn-primary" type="submit" value="   导    入   " /> <a
				href="${ctx}/cms/book/import/template">下载模板</a>
		</form>
	</div>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/cms/book">著作列表</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="book" action="${ctx}/cms/book/search" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}" />
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}" />
		<label>归属科室：</label>
		<tags:treeselect id="office" name="office.id" value="${book.office.id}" labelName="office.name"
			labelValue="${book.office.name}" title="科室" url="/sys/office/treeData?type=2" cssClass="input-small"
			allowClear="true" notAllowSelectParent="true" />
		<label>著作题目：</label>
		<form:input path="title" htmlEscape="false" maxlength="50" class="input-medium" />&nbsp;
		&nbsp;&nbsp;
		<div style="margin-top: 8px;"></div>
			<label>状态：</label>
			<form:select path="delFlag">
				<form:options items="${fns:getDictList('cms_del_flag')}" itemLabel="label" itemValue="value" htmlEscape="false" />
			</form:select>
			&nbsp; &nbsp;&nbsp;
				<label>发表时间：</label> <input id="searchYear" name="searchYear" type="text" readonly="readonly" maxlength="20"
					class="input-medium Wdate" style="width: 163px;" value="${book.searchYear}"
					onclick="WdatePicker({dateFmt:'yyyy'});" /> &nbsp;
				<label>作者年龄：</label><input class="span2" name="age" type="text"
						onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^1-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}"
						 onafterpaste="if(this.value.length==1){this.value=this.value.replace(/[^1-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}">
				<input id="btnSubmit" class="btn btn-primary" type="submit"
					value="查询" onclick="page();"/> &nbsp;<input id="btnExport" class="btn btn-primary" type="button" value="导出" />
				<c:if test="${fns:isKJDept()}"> &nbsp;<input
					id="btnImport" class="btn btn-primary" type="button" value="导入" /></c:if>
	</form:form>
	<div style="margin-top: 8px;"></div>
		<tags:message content="${message}" />
		<table id="contentTable" class="table table-striped table-bordered table-condensed">
			<thead>
				<tr>
					<th>所属科室</th>
					<th>著作题目</th>
					<th>关联项目</th>
					<th>作者</th>
					<th>权属</th>
					<th>年限</th>
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
				<c:forEach items="${page.list}" var="book">
					<tr>
						<td><a href="javascript:"
							onclick="$('#officeId').val('${book.office.id}');$('#officeName').val('${book.office.name}');$('#searchForm').submit();return false;">${book.office.name}</a></td>
						<td>${book.title}</td>
						<th><a href="${ctx}/cms/project/form?id=${book.project.id}">${book.projectNo}</a></th>
						<td>${book.author1DisplayName}</td>
						<td>${book.weightBelongDisplayName}</td>
						<td>${book.time}</td>
						<td>${book.weight}</td>
						<td>${book.jl}</td>
						<td>${book.remarks}</td>
						<td>${book.createBy.name}</td>
						<td><fmt:formatDate value="${book.createDate}" type="both" /></td>
						<td>${fns:getDictLabel(book.delFlag, 'cms_del_flag', '无')}</td>
						<td><a href="${ctx}/cms/book/form?id=${book.id}">查看</a></td>

					</tr>
				</c:forEach>
			</tbody>
		</table>
		<div class="pagination">${page}</div>
</body>
</html>