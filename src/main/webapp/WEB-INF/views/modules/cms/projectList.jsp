<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>项目管理</title>
	<meta name="decorator" content="default"/>
		<%@include file="/WEB-INF/views/include/dialog.jsp" %>
	<style type="text/css">.sort{color:#0663A2;cursor:pointer;}</style>
	<script type="text/javascript">
	$(document).ready(function() {
		$("#btnExport").click(function(){
			top.$.jBox.confirm("确认要导出附件数据吗？","系统提示",function(v,h,f){
				if(v=="ok"){
					$("#searchForm").attr("action","${ctx}/cms/project/export");
					$("#searchForm").submit();
				}
			},{buttonsFocus:1});
			top.$('.jbox-body .jbox-icon').css('top','55px');
		});
		$("#btnImport").click(function(){
			$.jBox($("#importBox").html(), {title:"导入数据", buttons:{"关闭":true}, 
				bottomText:"导入文件不能超过5M，仅允许导入“xls”或“xlsx”格式文件！"});
		});
	});
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
		    $("#searchForm").attr("action", "${ctx}/cms/project/list");
			$("#searchForm").submit();
        	return false;
        }
	</script>
</head>
<body>
	<div id="importBox" class="hide">
		<form id="importForm" action="${ctx}/cms/project/import" method="post" enctype="multipart/form-data"
			style="padding-left:20px;text-align:center;" class="form-search" onsubmit="loading('正在导入，请稍等...');"><br/>
			<input id="uploadFile" name="file" type="file" style="width:330px"/><br/><br/>　　
			<input id="btnImportSubmit" class="btn btn-primary" type="submit" value="   导    入   "/>
			<a href="${ctx}/cms/project/import/template">下载模板</a>
		</form>
	</div>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/cms/project">项目列表</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="project" action="${ctx}/cms/project/list" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<label>项目题目：</label><form:input path="projectName" htmlEscape="false" maxlength="50" class="input-medium"/>&nbsp;
		<label>立项号：&nbsp;</label><form:input path="projectNo" htmlEscape="false" maxlength="50" class="input-medium"/>
		&nbsp;&nbsp;
		<label>归属科室：</label><tags:treeselect id="office" name="office.id" value="${project.office.id}" labelName="office.name" labelValue="${project.office.name}" 
				title="科室" url="/sys/office/treeData?type=2" cssClass="input-small" allowClear="true" notAllowSelectParent="true"/>
		<div style="margin-top:8px;">
		<label>状态：</label><form:select path="status">
					<form:option  label="" value="" htmlEscape="false"/>
					<form:options items="${fns:getProjectStatus()}" itemLabel="displayName" itemValue="label" htmlEscape="false"/>
				</form:select>&nbsp;
		<label>项目等级：</label><form:select path="level">
			<form:option  label="" value="" htmlEscape="false"/>
				<form:options items="${fns:getDictList('project_level')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
			</form:select>&nbsp;
		</div>
		<div style="margin-top:8px;">
		<label>日期范围：&nbsp;</label><input id="beginDate" name="beginDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
				value="${beginDate}" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
			<label>&nbsp;--&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label><input id="endDate" name="endDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
				value="${endDate}" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>&nbsp;
		&nbsp;&nbsp;
				<input id="btnSubmit" class="btn btn-primary" type="button" onclick="page();" value="查询"/>
		&nbsp;<input id="btnExport" class="btn btn-primary" type="button" value="导出"/>
				<c:if test="${fns:isKJDept()}">
		&nbsp;<input id="btnImport" class="btn btn-primary" type="button" value="导入"/>
		</c:if>
		</div>
	</form:form>
	<div style="margin-top:8px;" ></div>
	<tags:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>立项号</th>
				<th>所属科室</th>
				<th>项目题目</th>
				<th>项目等级</th>
				<th>第一责任人</th>
				<th>第二责任人</th>
				<th>第三责任人</th>
				<th>权属</th>
				<th>权重</th>
				<th>关联论文</th>
				<th>关联科技进步奖</th>
				<th>状态</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="project">
			<tr>
				<td>${project.projectNo}</td>
				<td><a href="javascript:"
						onclick="$('#officeId').val('${project.office.id}');$('#officeName').val('${project.office.name}');$('#searchForm').submit();return false;">${project.office.name}</a></td>
				<td>${project.projectName}</td>
				<td>${project.level}</td>
				<td>${project.author1DisplayName}</td>
				<td>${project.author2DisplayName}</td>
				<td>${project.author3DisplayName}</td>
				<td>${project.weightBelongDisplayName}</td>
				<td>${project.weight}</td>
				<td>${project.thesissize}</td>
				<td>${project.rewardsize}</td>
				<td>${project.status.displayName}</td>
				<td>
    				<a href="${ctx}/cms/project/form?id=${project.id}">查看</a>
				</td>
				
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>