<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>通知管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
        	return false;
        }
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/cms/notice/">通知列表</a></li>
		<li><a href="<c:url value='${fns:getAdminPath()}/cms/notice/form?id=${article.id}'></c:url>">通知添加</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="article" action="${ctx}/cms/notice/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<label>标题：</label><form:input path="title" htmlEscape="false" maxlength="50" class="input-medium"/>&nbsp;
		<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>&nbsp;&nbsp;
	</form:form>
	<tags:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead><tr><th>标题</th><th>发布者</th><th>更新时间</th><th>操作</th></tr></thead>
		<tbody>
		<c:forEach items="${page.list}" var="article">
			<tr>
				<td><a href="${ctx}/cms/notice/form?id=${article.id}" title="${article.title}">${fns:abbr(article.title,40)}</a></td>
				<td>${article.createBy.name}</td>
				<td><fmt:formatDate value="${article.updateDate}" type="both"/></td>
				<td>
				<a href="${ctx}/cms/notice/form?id=${article.id}">修改</a>
				<a href="${ctx}/cms/notice/delete?id=${article.id}${article.delFlag ne 0?'&isRe=true':''}" onclick="return confirmx('确认要${article.delFlag ne 0?'发布':'删除'}该通知吗？', this.href)" >${article.delFlag ne 0?'发布':'删除'}</a>
				</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>