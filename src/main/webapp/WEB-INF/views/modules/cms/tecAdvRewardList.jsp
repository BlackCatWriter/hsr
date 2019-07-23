<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>院重大实用领先技术奖管理</title>
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
        top.$.jBox.confirm("确认要导出附件数据吗？", "系统提示",
        function(v, h, f) {
            if (v == "ok") {
                $("#searchForm").attr("action", "${ctx}/cms/tecAdvReward/export");
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
    $("#searchForm").attr("action", "${ctx}/cms/tecAdvReward/search");
    $("#searchForm").submit();
    return false;
}
</script>
</head>
<body>
	<div id="importBox" class="hide">
		<form id="importForm" action="${ctx}/cms/tecAdvReward/import" method="post" enctype="multipart/form-data"
			style="padding-left: 20px; text-align: center;" class="form-search" onsubmit="loading('正在导入，请稍等...');">
			<br /> <input id="uploadFile" name="file" type="file" style="width: 330px" /><br />
			<br /> <input id="btnImportSubmit" class="btn btn-primary" type="submit" value="   导    入   " /> <a
				href="${ctx}/cms/tecAdvReward/import/template">下载模板</a>
		</form>
	</div>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/cms/tecAdvReward">项目列表</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="reward" action="${ctx}/cms/tecAdvReward/search" method="post"
		class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}" />
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}" />
		<label>项目题目：</label>
		<form:input path="rewardName" htmlEscape="false" maxlength="50" class="input-medium" />&nbsp;
		&nbsp;&nbsp;
		<label>立项号：&nbsp;</label><form:input path="project.projectNo" htmlEscape="false" maxlength="50" class="input-medium"/>
		<label>归属科室：</label>
		<tags:treeselect id="office" name="office.id" value="${reward.office.id}" labelName="office.name"
			labelValue="${reward.office.name}" title="科室" url="/sys/office/treeData?type=2" cssClass="input-small"
			allowClear="true" notAllowSelectParent="true" />
		&nbsp;&nbsp;
		<div style="margin-top: 8px;">
		<label>状态：</label>
		<form:select path="delFlag">
			<form:options items="${fns:getDictList('cms_del_flag')}" itemLabel="label" itemValue="value" htmlEscape="false" />
		</form:select>&nbsp;
			<label>获奖年限：&nbsp;</label><input id="year" name="year" type="text" readonly="readonly" maxlength="20"
				class="input-medium Wdate" value="${year}" onclick="WdatePicker({dateFmt:'yyyy'});" /> <input
				id="btnSubmit" class="btn btn-primary" type="submit" value="查询" /> &nbsp;<input id="btnExport"
				class="btn btn-primary" type="button" value="导出" /> 
				<c:if test="${fns:isKJDept()}">&nbsp;<input id="btnImport" class="btn btn-primary"
				type="button" value="导入" /></c:if>
		</div>
	</form:form>
	<div style="margin-top: 8px;" ></div>
	<tags:message content="${message}" />
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>立项单位</th>
				<th>关联项目</th>
				<th>项目题目</th>
				<th>第一责任人</th>
				<th>第二责任人</th>
				<th>第三责任人</th>
				<th>奖项等级</th>
				<th>奖项级别</th>
				<th>关联项目</th>
				<th>权属</th>
				<th>权重</th>
				<th>创建时间</th>
				<th>状态</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${page.list}" var="reward">
				<tr>
					<td><a href="javascript:"
						onclick="$('#officeId').val('${reward.office.id}');$('#officeName').val('${reward.office.name}');$('#searchForm').submit();return false;">${reward.office.name}</a></td>
					<td>${reward.rewardName}</td>
					<th><a href="${ctx}/cms/project/form?id=${reward.project.id}">${reward.projectNo}</a></th>
					<td>${reward.author1DisplayName}</td>
					<td>${reward.author2DisplayName}</td>
					<td>${reward.author3DisplayName}</td>
					<td>${fns:getDictLabel(reward.level, 'reward_level', '无')}</td>
					<td>${fns:getDictLabel(reward.grade, 'reward_gradetech', '无')}</td>
					<th>${reward.project.projectNo}</th>
					<td>${reward.weightBelongDisplayName}</td>
					<td>${reward.weight}</td>
					<td><fmt:formatDate value="${reward.createDate}" type="both" /></td>
					<td>${fns:getDictLabel(reward.delFlag, 'cms_del_flag', '无')}</td>
					<td><a href="${ctx}/cms/tecAdvReward/form?id=${reward.id}">查看</a></td>

				</tr>
			</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>