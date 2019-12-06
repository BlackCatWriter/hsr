<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>项目内容</title>
	<meta name="decorator" content="default"/>
</head>
<body>
	<!-- <ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/cms/project/form?id=${project.id}">科研项目基本内容</a></li>
		<li><a href="${ctx}/cms/project/projectRealatedForm?id=${project.id}">关联项</a></li>
	</ul><br/> -->
	<form:form id="inputForm" modelAttribute="project" action="${ctx}/cms/project/save" method="post" class="form-horizontal">
		<c:set var="thesises" value="${project.thesis}" />
		<form:hidden path="id"/>
		<tags:message content="${message}"/>
		<div class="control-group">
			<label class="control-label">项目名称:</label>
			<div class="controls">
				<form:input path="projectName" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">第一责任人:</label>
			<div class="controls">
				<form:input path="author1DisplayName" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
				<div class="control-group">
			<label class="control-label">第二责任人:</label>
			<div class="controls">
				<form:input path="author2DisplayName" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">第三责任人:</label>
			<div class="controls">
				<form:input path="author3DisplayName"  htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">权属:</label>
			<div class="controls">
				<form:input path="weightBelongDisplayName" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">权重:</label>
			<div class="controls">
				<form:input path="weight" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">所属科室:</label>
			<div class="controls">
				<form:input path="office.name" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">专业:</label>
			<div class="controls">
				<form:input path="profession" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">附件链接:</label>
			<div class="controls">
				<c:set value="${ fn:split(project.file, ',') }" var="arr" />
				<c:forEach items="${ arr }" var="s">
					<a href="${ctx}/cms/project/get/${project.id}">${s}</a><br>
				</c:forEach>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">中期考核附件链接:</label>
			<div class="controls">
				<a href="${ctx}/cms/project/getMid/${project.id}">${project.midTermFile}</a>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">结题附件链接:</label>
			<div class="controls">
				<a href="${ctx}/cms/project/getEnd/${project.id}">${project.endFile}</a>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">立项号:</label>
			<div class="controls">
				<form:input value="${projectNo}" path="projectNo" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">立项单位:</label>
			<div class="controls">
				<form:input value="${approvalOrg}" path="approvalOrg" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">项目等级:</label>
			<div class="controls">
				<form:input value="${level}" path="level" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">开始时间:</label>
			<div class="controls">
				<form:input value="${startDate}" path="startDate" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">结束时间:</label>
			<div class="controls">
				<form:input value="${endDate}" path="endDate" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">关联论文:</label>
			<div class="controls">
					<c:forEach items="${project.thesis}" var="rthesis">
						<a href="${ctx}/cms/thesis/form?id=${rthesis.id}">${rthesis.title}；&nbsp;&nbsp;</a>
					</c:forEach>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">关联科技进步奖:</label>
			<div class="controls">
					<c:forEach items="${project.reward}" var="rreward">
						<a href="${ctx}/cms/reward/form?id=${rreward.id}">${rreward.rewardName}；&nbsp;&nbsp;</a>
					</c:forEach>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">关联新技术引进奖:</label>
			<div class="controls">
					<c:forEach items="${project.newTec}" var="rnewTec">
						<a href="${ctx}/cms/newTecReward/form?id=${rnewTec.id}">${rnewTec.rewardName}；&nbsp;&nbsp;</a>
					</c:forEach>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">关联院重大实用领先技术奖:</label>
			<div class="controls">
					<c:forEach items="${project.tecAdv}" var="rtecAdv">
						<a href="${ctx}/cms/tecAdvReward/form?id=${rtecAdv.id}">${rtecAdv.rewardName}；&nbsp;&nbsp;</a>
					</c:forEach>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">关联专利:</label>
			<div class="controls">
					<c:forEach items="${project.patent}" var="rpatent">
						<a href="${ctx}/cms/patent/form?id=${rpatent.id}">${rpatent.title}；&nbsp;&nbsp;</a>
					</c:forEach>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">关联著作:</label>
			<div class="controls">
					<c:forEach items="${project.book}" var="rbook">
						<a href="${ctx}/cms/book/form?id=${rbook.id}">${rbook.title}；&nbsp;&nbsp;</a>
					</c:forEach>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">下拨经费:</label>
			<div class="controls">
				<form:input value="${xb_fee}" path="xb_fee" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">配套经费:</label>
			<div class="controls">
				<form:input value="${pt_fee}" path="pt_fee" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>·
		</div>
		<div class="control-group">
			<label class="control-label">实到经费:</label>
			<div class="controls">
				<form:input value="${sd_fee}" path="sd_fee" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">使用经费:</label>
			<div class="controls">
				<form:input value="${sy_fee}" path="sy_fee" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="form-actions">
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>