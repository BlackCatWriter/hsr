<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>文件上传下载</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
        	return false;
        }
		
		function createFolder(){
			top.$.jBox("<div style='padding:10px;'><input id='folderName' ></input></div>", {
	            title: "请填写文件夹名",
	            submit: function() {
	                var folderName = top.$("#folderName").val();
	                if ($.trim(folderName) == "") {
	                    top.$.jBox.error('请填写文件夹名', '错误');
	                    return false;
	                }else{
	                    $("#createdFolderName").val(folderName);
	                    $("#redirectForm").submit();
	                }
	            }
	        });
		}
		
		function deleteFiles(){
	        $("#searchForm").submit();
		}
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/oa/fileUpload/list">文件管理</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="files" action="${ctx}/oa/fileUpload/delete" method="post" class="breadcrumb form-search">
		<input type="hidden" id="currentPath" name="currentPath" value="${currentPath}"/>
		<div>
			<label>当前路径：&nbsp;</label>
			<c:forEach items="${paths}" var="path">
				/<a href="${ctx}/oa/fileUpload/list?targetPath=${path.path}">${path.name}</a>
			</c:forEach>
		</div>
	<tags:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<tbody>
		<c:forEach items="${files}" var="file">
			<tr>
				<td width="10">
					<input type="checkbox" name="fileNames" value="${file.absolutePath}">
				</td>
				<c:if test="${file.directory}">
					<td><i class="icon-folder-open icon-black"></i>&nbsp;&nbsp;<a href="${ctx}/oa/fileUpload/list?targetPath=${file.absolutePath}">${file.name}</a></td>
				</c:if>
				<c:if test="${file.file}">
					<td><i class="icon-circle-arrow-right"></i>&nbsp;&nbsp;<a href="${ctx}/oa/fileUpload/download?targetPath=${file.absolutePath}&currentPath=${currentPath}">${file.name}</a></td>
				</c:if>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	</form:form>
	<c:if test="${fns:isKJDept()}">
	<form id="fileForm" action="${ctx}/oa/fileUpload/upload" method="post" enctype="multipart/form-data">  
		<input type="button" onclick="createFolder();" value="创建文件夹"/>
		<input type="button" onclick="deleteFiles();" value="删除"/>
		<input type="hidden" id="currentPath" name="currentPath" value="${currentPath}"/>
		<input type="file" name="file" /> 
		<input type="submit" value="上传" />
	</form>
	<form:form id="redirectForm" modelAttribute="files" action="${ctx}/oa/fileUpload/createFolder" method="post" >
		<input type="hidden" id="createdFolderName" name="name"/>
		<input type="hidden" id="currentPath" name="currentPath" value="${currentPath}"/>
	</form:form>
	</c:if>
</body>
</html>
