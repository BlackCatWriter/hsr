<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>进修列表</title>
	<meta name="decorator" content="default"/>
		<%@include file="/WEB-INF/views/include/dialog.jsp" %>
	<style type="text/css">.sort{color:#0663A2;cursor:pointer;}</style>
	<script type="text/javascript">
	$(document).ready(function() {
		$("#btnExport").click(function(){
			top.$.jBox.confirm("确认要导出附件数据吗？","系统提示",function(v,h,f){
				if(v=="ok"){
					$("#searchForm").attr("action","${ctx}/cms/advstudy/export");
					$("#searchForm").submit();
				}
			},{buttonsFocus:1});
			top.$('.jbox-body .jbox-icon').css('top','55px');
		});
	});
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
        	return false;
        }
	</script>
</head>
<body>
	<!--  div id="importBox" class="hide">
		<form id="importForm" action="${ctx}/cms/advstudy/import" method="post" enctype="multipart/form-data"
			style="padding-left:20px;text-align:center;" class="form-search" onsubmit="loading('正在导入，请稍等...');"><br/>
			<input id="uploadFile" name="file" type="file" style="width:330px"/><br/><br/>　　
			<input id="btnImportSubmit" class="btn btn-primary" type="submit" value="   导    入   "/>
			<a href="${ctx}/cms/tecAdvReward/import/template">下载模板</a>
		</form>
	</div-->
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/cms/advstudy">进修列表</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="advstudy" action="${ctx}/cms/advstudy/search" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<label>归属科室：</label><tags:treeselect id="office" name="office.id" value="${advstudy.office.id}" labelName="office.name" labelValue="${advstudy.office.name}" 
				title="科室" url="/sys/office/treeData?type=2" cssClass="input-small" allowClear="true" notAllowSelectParent="true"/>
		<label>状态：</label><form:select path="delFlag">
					<form:options items="${fns:getDictList('cms_del_flag')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>&nbsp;
		&nbsp;&nbsp;
		<div style="margin-top:8px;">
		<label>日期范围：&nbsp;</label><input id="startDate" name="startDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
				value="${startDate}" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
			<label>&nbsp;--&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label><input id="endDate" name="endDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
				value="${endDate}" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>&nbsp;
		&nbsp;&nbsp;
		<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
				</div>
	</form:form>
	<div style="margin-top:8px;" />
	<tags:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>所属科室</th>
				<th>姓名</th>
				<th>职称</th>
				<th>进修方向</th>
				<th>进修单位</th>
				<th>开始时间</th>
				<th>结束时间</th>
				<th>报销经费</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="advstudy">
			<tr>
				<td><a href="javascript:" onclick="$('#officeId').val('${advstudy.office.id}');$('#officeName').val('${advstudy.office.name}');$('#searchForm').submit();return false;">${advstudy.office.name}</a></td>
				<td>${advstudy.applyuser}</td>
				<td>${advstudy.worktitle}</td>
				<td>${advstudy.advstudyDirection}</td>
				<td>${advstudy.hostUnit}</td>
				<td><fmt:formatDate value="${advstudy.startDate}" pattern="yyyy-MM-dd" type="both"/></td>
				<td><fmt:formatDate value="${advstudy.endDate}" pattern="yyyy-MM-dd" type="both"/></td>
				<td>${advstudy.academiccost.bxFee}</td>
				<td>
    				<a href="${ctx}/cms/advstudy/form?id=${advstudy.id}">查看</a>
				</td>
				
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>