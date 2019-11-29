<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>学术会议办理</title>
	<meta name="decorator" content="default"/>
	<script src="${ctxStatic}/jQuery-File-Upload-9.9.3/js/vendor/jquery.ui.widget.js"></script>
	<script src="${ctxStatic}/jQuery-File-Upload-9.9.3/js/jquery.iframe-transport.js"></script>
	<script src="${ctxStatic}/jQuery-File-Upload-9.9.3/js/jquery.fileupload.js"></script>
	<script src="${ctxStatic}/bootstrap/2.3.1/js/bootstrap.min.js"></script>
	<link href="${ctxStatic}/bootstrap/2.3.1/css_default/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<link href="${ctxStatic}/common/dropzone.css" type="text/css" rel="stylesheet" />
	<script src="${ctxStatic}/common/myuploadfunction.js"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			$(".handle").click(function(){
				var obj = $(this);
				var taskId = obj.data("tid");
				var academicId = obj.data("id");
				var tkey=obj.data("tkey");
				//科室领导审批
				
				if(tkey=="deptLeaderAudit") {
                    $.getJSON("${ctx}/oa/academic/detail/" + academicId , function(data){
						 var html= Mustache.render($("#auditTemplate").html(),data);
						 top.$.jBox(html, { title: "流程办理["+obj.data("tname") + "]",buttons:{"同意":"yes","驳回":"no","取消":"cancel"},submit: function (v, h, f) {
							 //同意
							 if(v=="yes") {
	                        	 complete(taskId, [{
	                                 key: 'kjDeptPass',
	                                 value: true,
	                                 type: 'B'
	                               }]);
							//驳回
							 } else if (v=="no") {
								 top.$.jBox("<div style='padding:10px;'><textarea id='kjDeptBackReason' style='width: 250px; height: 60px;'></textarea></div>", { title: "请填写打回理由", submit: function () {
									 var kjDeptBackReason=top.$("#kjDeptBackReason").val();
									 //必须填写驳回理由
									 if($.trim(kjDeptBackReason)=="") {
										 top.$.jBox.error('请填写打回理由', '错误');
										 return false;
									 } else {
											complete(taskId, [{
												key: 'kjDeptPass',
												value: false,
												type: 'B'
											}, {
												key: 'kjDeptBackReason',
												value: kjDeptBackReason,
												type: 'S'
											}]);
									 }
								 }
								});
							 }

						 }
						 });
					});
				}
				if(tkey=="kjDeptAudit") {
                    $.getJSON("${ctx}/oa/academic/detail/" + academicId , function(data){
						 var html= Mustache.render($("#auditTemplate").html(),data);
						 top.$.jBox(html, { title: "流程办理["+obj.data("tname") + "]",buttons:{"同意":"yes","驳回":"no","取消":"cancel"},submit: function (v, h, f) {
							 //同意
							 if(v=="yes") {saveAdditionalProperty(academicId, [],taskId, [{
													key: 'kjDeptPass',
													value: true,
													type: 'B'
												}]);
							//驳回
							 } else if (v=="no") {
								 top.$.jBox("<div style='padding:10px;'><textarea id='kjDeptBackReason' style='width: 250px; height: 60px;'></textarea></div>", { title: "请填写打回理由", submit: function () {
									 var kjDeptBackReason=top.$("#kjDeptBackReason").val();
									 //必须填写驳回理由
									 if($.trim(kjDeptBackReason)=="") {
										 top.$.jBox.error('请填写打回理由', '错误');
										 return false;
									 } else {
											complete(taskId, [{
												key: 'kjDeptPass',
												value: false,
												type: 'B'
											}, {
												key: 'kjDeptBackReason',
												value: kjDeptBackReason,
												type: 'S'
											}]);
									 }
								 }
								});
							 }

						 }
						 });
					});
				}
				
				
				if(tkey=="deptLeaderCostAudit") {
                    $.getJSON("${ctx}/oa/academic/detailcost/" + academicId , function(data){
						 var html= Mustache.render($("#auditcostTemplate").html(),data);
						 top.$.jBox(html, { title: "流程办理["+obj.data("tname") + "]",buttons:{"同意":"yes","驳回":"no","取消":"cancel"},submit: function (v, h, f) {
							 //同意
							 if(v=="yes") {
	                        	 complete(taskId, [{
	                                 key: 'kjDeptPass',
	                                 value: true,
	                                 type: 'B'
	                               }]);
							//驳回
							 } else if (v=="no") {
								 top.$.jBox("<div style='padding:10px;'><textarea id='kjDeptBackReason' style='width: 250px; height: 60px;'></textarea></div>", { title: "请填写打回理由", submit: function () {
									 var kjDeptBackReason=top.$("#kjDeptBackReason").val();
									 //必须填写驳回理由
									 if($.trim(kjDeptBackReason)=="") {
										 top.$.jBox.error('请填写打回理由', '错误');
										 return false;
									 } else {
											complete(taskId, [{
												key: 'kjDeptPass',
												value: false,
												type: 'B'
											}, {
												key: 'kjDeptBackReason',
												value: kjDeptBackReason,
												type: 'S'
											}]);
									 }
								 }
								});
							 }

						 }
						 });
					});
				}
				
				if(tkey=="kjDeptCostAudit") {
                    $.getJSON("${ctx}/oa/academic/detailcost/" + academicId , function(data){
						 var html= Mustache.render($("#auditcostTemplate").html(),data);
						 top.$.jBox(html, { title: "流程办理["+obj.data("tname") + "]",buttons:{"同意":"yes","驳回":"no","取消":"cancel"},submit: function (v, h, f) {
							 //同意
							 if(v=="yes") {saveCostAdditionalProperty(academicId, [],taskId, [{
													key: 'kjDeptPass',
													value: true,
													type: 'B'
												}]);
							//驳回
							 } else if (v=="no") {
								 top.$.jBox("<div style='padding:10px;'><textarea id='kjDeptBackReason' style='width: 250px; height: 60px;'></textarea></div>", { title: "请填写打回理由", submit: function () {
									 var kjDeptBackReason=top.$("#kjDeptBackReason").val();
									 //必须填写驳回理由
									 if($.trim(kjDeptBackReason)=="") {
										 top.$.jBox.error('请填写打回理由', '错误');
										 return false;
									 } else {
											complete(taskId, [{
												key: 'kjDeptPass',
												value: false,
												type: 'B'
											}, {
												key: 'kjDeptBackReason',
												value: kjDeptBackReason,
												type: 'S'
											}]);
									 }
								 }
								});
							 }

						 }
						 });
					});
				}
				//调整申请
				if(tkey=="modifyApply") {
					academicForm.action="${ctx}/oa/academic/formModify/" + academicId + "/" + taskId;
					academicForm.submit();
				}
				if(tkey=="modifyCostApply") {
					academicForm.action="${ctx}/oa/academic/costModify/" + academicId + "/" + taskId;
					academicForm.submit();
				}
			})
		});
		
		/**
		 * 完成属性保存
		 * @param {Object} academicId
		 */
		function saveAdditionalProperty(academicId, variables,taskId,taskVariables) {
			// 转换JSON为字符串
		    var keys = "", values = "", types = "";
			if (variables) {
				$.each(variables, function() {
					if (keys != "") {
						keys += "|";
						values += "|";
						types += "|";
					}
					keys += this.key;
					values += this.value;
					types += this.type;
				});
			}
			$.post('${ctx}/oa/academic/complete/' + academicId, {
		        keys: keys,
		        values: values,
		        types: types
		    }, function(resp) {
		        if (resp == 'success') {
		        	complete(taskId,taskVariables);
		        } else {
		        	top.$.jBox.tip('操作失败!');
		        }
		    });
		}
		 
			/**
			 * 完成属性保存
			 * @param {Object} academicId
			 */
			function saveCostAdditionalProperty(academicId, variables,taskId,taskVariables) {
				// 转换JSON为字符串
			    var keys = "", values = "", types = "";
				if (variables) {
					$.each(variables, function() {
						if (keys != "") {
							keys += "|";
							values += "|";
							types += "|";
						}
						keys += this.key;
						values += this.value;
						types += this.type;
					});
				}
				$.post('${ctx}/oa/academic/completecost/' + academicId, {
			        keys: keys,
			        values: values,
			        types: types
			    }, function(resp) {
			        if (resp == 'success') {
			        	complete(taskId,taskVariables);
			        } else {
			        	top.$.jBox.tip('操作失败!');
			        }
			    });
			}
		 
			/**
			 * 完成任务
			 * @param {Object} taskId
			 */
			function claim(taskId) {
				$.post('${ctx}/oa/workflow/claim/' + taskId,{}, function(resp) {
			        if (resp == 'success') {
			        	top.$.jBox.tip('签收完成');
			            location.reload();
			        } else {
			        	top.$.jBox.tip('签收失败!');
			        }
			    });
			}
		
		
		/**
		 * 完成任务
		 * @param {Object} taskId
		 */
		function complete(taskId, variables) {
			 // 转换JSON为字符串
		    var keys = "", values = "", types = "";
			if (variables) {
				$.each(variables, function() {
					if (keys != "") {
						keys += "|";
						values += "|";
						types += "|";
					}
					keys += this.key;
					if(this.value==""){
						values +=" ";
					}else{
						values += this.value;
					}
					types += this.type;
				});
			}
			var jsonData = JSON.stringify(variables);
            $.post('${ctx}/oa/workflow/complete/' + taskId, {
            	    keys: keys,
			        values: values,
			        types: types
		    }, function(resp) {
		        if (resp == 'success') {
		        	top.$.jBox.tip('任务完成');
		            location.reload();
		        } else {
		        	top.$.jBox.tip('操作失败!');
		        }
		    });
		}
	</script>
	<script type="text/template" id="auditTemplate">
		<div style="overflow-y:auto; height:400px;">
		<table class="table table-striped ">
			<tr>
				<td width="100px;">申请人：</td>
				<td>{{user.name}}</td>
			</tr>
			<tr>
				<td>会议名称：</td>
				<td>{{academicName}}</td>
			</tr>
			<tr>
				<td>会议地点：</td>
				<td>{{place}}</td>
			</tr>
			<tr>
				<td>主办单位：</td>
				<td>{{hostUnit}}</td>
			</tr>
			<tr>
				<td>会议级别：</td>
				<td>{{academicLevel}}</td>
			</tr>
			<tr>
				<td>备注：</td>
				<td><textarea id='remarks' style='width: 250px; height: 60px;'></textarea></td>
			</tr>
		</table>
		</div>
	</script>
	<script type="text/template" id="auditcostTemplate">
		<div style="overflow-y:auto; height:400px;">
		<table class="table table-striped ">
			<tr>
				<td width="100px;">报销金额：</td>
				<td>{{bxFee}}</td>
			</tr>
			<tr>
				<td>备注：</td>
				<td>{{remarks}}</td>
			</tr>
		</table>
		</div>
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/oa/academic/form">学术会议</a></li>
		<li><a href="${ctx}/oa/academic/cost">学术活动经费报销</a></li>
		<li><a href="${ctx}/oa/academic/list">所有任务</a></li>
		<li class="active"><a href="${ctx}/oa/academic/task">待办任务</a></li>
	</ul>
	<form:form id="academicForm" modelAttribute="academic" action="" method="post" class="breadcrumb form-search">
	</form:form>
	<tags:message content="${message}"/>
	<div><b>申请待办任务</b></div>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
			<tr>
				<th>申请人</th>
				<th>所属科室</th>
				<th>会议名称</th>
				<th>会议开始日期</th>
				<th>会议结束日期</th>
				<th>当前节点</th>
				<%--<th>流程状态</th>--%>
				<th>操作</th>
			</tr>
		<tbody>
			<c:forEach items="${academic}" var="academic">
				<c:set var="task" value="${academic.task}" />
				<c:set var="pi" value="${academic.processInstance}" />
				<tr id="${academic.id }" tid="${academic.id}">
					<td>${academic.user.name}</td>
					<td>${academic.office.name}</td>
					<td>${academic.academicName}</td>
					<td><fmt:formatDate value="${academic.startDate}" pattern="yyyy-MM-dd" type="both"/></td>
					<td><fmt:formatDate value="${academic.endDate}" pattern="yyyy-MM-dd" type="both"/></td>
					<td>${task.name}</td>
					<%--<td>${pi.suspended ? "已挂起" : "正常" }；<b title='流程版本号'>V: ${academic.processDefinition.version}</b></td>--%>
					<td>
						<%-- 此处用tkey记录当前节点的名称 --%>
						<a class="handle" href="#" data-tkey="${task.taskDefinitionKey}" data-tname="${task.name}"  data-id="${academic.id}"  data-tid="${task.id}">办理</a>
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	&nbsp;&nbsp;
	&nbsp;&nbsp;
	<div style="bordered;min-hight:200px"><b>经费报销待办任务</b>
	</div>
	<table id="costTable" class="table table-striped table-bordered table-condensed">
			<tr>
				<th>申请人</th>
				<th>所属科室</th>
				<th>会议名称</th>
				<th>会议报销金额</th>
				<th>报销上传附件</th>
				<th>当前节点</th>
				<%--<th>流程状态</th>--%>
				<th>操作</th>
			</tr>
		<tbody>
			<c:forEach items="${costresults}" var="academic">
				<c:set var="task" value="${academic.academiccost.task}" />
				<c:set var="academiccost" value="${academic.academiccost}" />
				<c:set var="pi" value="${academic.academiccost.processInstance}" />
				<tr id="${academic.id}" tid="${academic.id}">
					<td>${academic.user.name}</td>
					<td>${academic.office.name}</td>
					<td>${academic.academicName}</td>
					<td>${academic.academiccost.bxFee}</td>
					<td><a href="${ctx}/cms/academiccost/get/${academic.academiccost.id}">${academic.academiccost.file}</a></td>
					<td>${task.name}</td>
					<%--<td>${pi.suspended ? "已挂起" : "正常" }；<b title='流程版本号'>V: ${academiccost.processDefinition.version}</b></td>--%>
					<td>
						<%-- 此处用tkey记录当前节点的名称 --%>
						<a class="handle" href="#" data-tkey="${task.taskDefinitionKey}" data-tname="${task.name}"  data-id="${academiccost.id}"  data-tid="${task.id}">办理</a>
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</body>
</html>
