<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>科研成果管理</title>
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
        top.$.jBox.confirm("确认要导出科研成果数据吗？", "系统提示",
        function(v, h, f) {
            if (v == "ok") {
                $("#searchForm").attr("action", "${ctx}/cms/achievement/export");
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
    $("#searchForm").attr("action", "${ctx}/cms/achievement/search");
    $("#searchForm").submit();
    return false;
}
</script>
</head>
<body>
	<div id="importBox" class="hide">
		<form id="importForm" action="${ctx}/cms/achievement/import" method="post" enctype="multipart/form-data"
			style="padding-left: 20px; text-align: center;" class="form-search" onsubmit="loading('正在导入，请稍等...');">
			<br /> <input id="uploadFile" name="file" type="file" style="width: 330px" /><br />
			<br /> <input id="btnImportSubmit" class="btn btn-primary" type="submit" value="   导    入   " /> <a
				href="${ctx}/cms/achievement/import/template">下载模板</a>
		</form>
	</div>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/cms/achievement">科研成果列表</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="achievement" action="${ctx}/cms/achievement/" method="post"
		class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}" />
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}" />
		<label>归属科室：</label>
		<tags:treeselect id="office" name="office.id" value="${achievement.office.id}" labelName="office.name"
			labelValue="${achievement.office.name}" title="科室" url="/sys/office/treeData?type=2" cssClass="input-small"
			allowClear="true" notAllowSelectParent="true" />
		<label>项目编号：</label>
		<form:input path="project.projectNo" htmlEscape="false" maxlength="50" class="input-medium" />&nbsp;
		&nbsp;&nbsp;
		<label>项目名称：</label>
		<form:input path="projectName" htmlEscape="false" maxlength="50" class="input-medium" />&nbsp;
		&nbsp;&nbsp;
		<label>权属：</label>
		<form:input path="weightBelong" htmlEscape="false" maxlength="50" class="input-medium" />&nbsp;
		&nbsp;&nbsp;
		<div style="margin-top: 8px;"></div>
			<label>奖励级别：</label>
			<form:select path="awardLevel">
				<form:options items="${fns:getDictList('award_level_type')}" itemLabel="label" itemValue="value" htmlEscape="false" />
			</form:select>
			&nbsp; &nbsp;&nbsp; <label>奖励等级：</label>
			<form:select path="jlLevel">
				<form:options items="${fns:getDictList('achievement_jl_level_type')}" itemLabel="label" itemValue="value"
					htmlEscape="false" />
			</form:select>
			&nbsp; &nbsp;&nbsp; <label>状态：</label>
			<form:select path="delFlag">
				<form:options items="${fns:getDictList('cms_del_flag')}" itemLabel="label" itemValue="value" htmlEscape="false" />
			</form:select>
			&nbsp; &nbsp;&nbsp;
			<div style="margin-top: 8px;">
				<label>日期范围：&nbsp;</label><input id="beginDate" name="beginDate" type="text" readonly="readonly" maxlength="20"
					class="input-medium Wdate" value="${beginDate}" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" />
				<label>&nbsp;--&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label><input id="endDate" name="endDate" type="text"
					readonly="readonly" maxlength="20" class="input-medium Wdate" value="${endDate}"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" />&nbsp; &nbsp;&nbsp; <input id="btnSubmit"
					class="btn btn-primary" type="submit" value="查询" onclick="page();" /> &nbsp;<input id="btnExport"
					class="btn btn-primary" type="button" value="导出" /> &nbsp;<input id="btnImport" class="btn btn-primary"
					type="button" value="导入" />
			</div>
	</form:form>
	<div style="margin-top: 8px;"></div>
		<tags:message content="${message}" />
		<table id="contentTable" class="table table-striped table-bordered table-condensed">
			<thead>
				<tr>
					<th>所属科室</th>
					<th>专业</th>
					<th>第一完成人</th>
					<th>第二完成人</th>
					<th>第三完成人</th>
					<th>权属</th>
					<th>项目编号</th>
					<th>项目名称</th>
					<th>奖励级别</th>
					<th>奖励等级</th>
					<th>奖励金额</th>
					<th>院配套奖励金额</th>
					<th>备注</th>
					<th>发布者</th>
					<th>创建时间</th>
					<th>状态</th>
					<th>操作</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${page.list}" var="achievement">
					<tr>
						<td><a href="javascript:"
							onclick="$('#officeId').val('${achievement.office.id}');$('#officeName').val('${achievement.office.name}');$('#searchForm').submit();return false;">${achievement.office.name}</a></td>
						<td>${achievement.major}</td>
						<td>${achievement.author1DisplayName}</td>
						<td>${achievement.author2DisplayName}</td>
						<td>${achievement.author3DisplayName}</td>
						<td>${achievement.weightBelongDisplayName}</td>
						<td>${achievement.project.projectNo}</td>
						<td>${achievement.projectName}</td>
						<td>${achievement.achievementAwardLevel}</td>
						<td>${achievement.achievementJlLevel}</td>
						<td>${achievement.jl}</td>
						<td>${achievement.yjl}</td>
						<td>${achievement.remarks}</td>
						<td>${achievement.createBy.name}</td>
						<td><fmt:formatDate value="${achievement.createDate}" type="both" /></td>
						<td>${fns:getDictLabel(achievement.delFlag, 'cms_del_flag', '无')}</td>
						<td><a href="${ctx}/cms/achievement/form?id=${achievement.id}">查看</a></td>

					</tr>
				</c:forEach>
			</tbody>
		</table>
		<div class="pagination">${page}</div>
</body>
</html>