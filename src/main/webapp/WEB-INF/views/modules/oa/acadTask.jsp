<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>学会任职申请办理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			$(".handle").click(function(){
				var obj = $(this);
				var taskId = obj.data("tid");
				var acadId = obj.data("id");
				var tkey=obj.data("tkey");
				//科室领导审批
				if(tkey=="deptLeaderAudit") {
                    $.getJSON("${ctx}/oa/acad/detail/" + acadId , function(data){
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
                    $.getJSON("${ctx}/oa/acad/detail/" + acadId , function(data){
						 var html= Mustache.render($("#auditTemplate").html(),data);
						 top.$.jBox(html, { title: "流程办理["+obj.data("tname") + "]",buttons:{"同意":"yes","驳回":"no","取消":"cancel"},submit: function (v, h, f) {
							 //同意
							 if(v=="yes") {saveAdditionalProperty(acadId, [],taskId, [{
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
					acadForm.action="${ctx}/oa/acad/formModify/" + acadId + "/" + taskId;
					acadForm.submit();
				}
			})
		});
		
		/**
		 * 完成属性保存
		 * @param {Object} acadId
		 */
		function saveAdditionalProperty(acadId, variables,taskId,taskVariables) {
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
			$.post('${ctx}/oa/acad/complete/' + acadId, {
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
				<td>学会协会名称：</td>
				<td>{{acadName}}</td>
			</tr>
			<tr>
				<td>学会级别：</td>
				<td>{{acadLevel}}</td>
			</tr>
			<tr>
				<td>职务：</td>
				<td>{{role}}</td>
			</tr>
			<tr>
				<td>备注：</td>
				<td><textarea id='remarks' style='width: 250px; height: 60px;'></textarea></td>
			</tr>
		</table>
		</div>
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/oa/acad/form">学会协会任职登记</a></li>
		<li><a href="${ctx}/oa/acad/list">所有任务</a></li>
		<li class="active"><a href="${ctx}/oa/acad/task">待办任务</a></li>
	</ul>
	<form:form id="acadForm" modelAttribute="acad" action="" method="post" class="breadcrumb form-search">
	</form:form>
	<tags:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
			<tr>
				<th>学会名称</th>
				<th>申请人</th>
				<th>所属科室</th>
				<th>职称</th>
				<th>级别</th>
				<th>学会职务</th>
				<th>开始时间</th>
				<th>结束时间</th>
				<th>当前节点</th>
				<th>流程状态</th>
				<th>操作</th>
			</tr>
		<tbody>
			<c:forEach items="${acad}" var="acad">
				<c:set var="task" value="${acad.task}" />
				<c:set var="pi" value="${acad.processInstance}" />
				<tr id="${acad.id }" tid="${acad.id}">
					<td>${acad.acadName}</td>
					<td>${acad.user.name}</td>
					<td>${acad.office.name}</td>
					<td>${acad.worktitle}</td>
					<td>${fns:getDictLabel(acad.level, 'acad_level_type', '无')}</td>
					<td>${fns:getDictLabel(acad.exerciseRole, 'acad_exercise_role', '无')}</td>
					<td><fmt:formatDate value="${acad.startDate}" pattern="yyyy-MM-dd" type="both"/></td>
					<td><fmt:formatDate value="${acad.endDate}" pattern="yyyy-MM-dd" type="both"/></td>
					<td>${task.name}</td>
					<td>${pi.suspended ? "已挂起" : "正常" }；<b title='流程版本号'>V: ${acad.processDefinition.version}</b></td>
					<td>
						<%-- 此处用tkey记录当前节点的名称 --%>
						<a class="handle" href="#" data-tkey="${task.taskDefinitionKey}" data-tname="${task.name}"  data-id="${acad.id}"  data-tid="${task.id}">办理</a>
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</body>
</html>
