<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>新技术引进奖办理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			$(".handle").click(function(){
				var obj = $(this);
				var taskId = obj.data("tid");
				var achievementId = obj.data("id");
				var tkey=obj.data("tkey");
				//科室领导审批
				if(tkey=="kjDeptAudit") {
                    $.getJSON("${ctx}/oa/achievement/detail/" + achievementId , function(data){
						 var html= Mustache.render($("#auditTemplate").html(),data);
						 top.$.jBox(html, { title: "流程办理["+obj.data("tname") + "]",buttons:{"同意并追加信息":"yes","驳回":"no","取消":"cancel"},submit: function (v, h, f) {
							 //同意
							 if(v=="yes") {
								 top.$.jBox("<div style='padding:10px;'>"+
										 "<div class='control-group'>"+
							 				"<label class='control-label'>奖励级别:</label>"+
							 				"<div class='controls'>"+
											"<select id='awardLevel' name='awardLevel'>"+
											"<c:forEach items='${fns:getDictList(\'award_level_type\')}' var='awardLevel'>"+
												"<option value='${awardLevel.value}'>${awardLevel.label}</option>"+
											"</c:forEach>"+
											"</select>"+
							 				"</div>"+
							 			"</div>"+
							 			"<div class='control-group'>"+
						 				"<label class='control-label'>奖励等级:</label>"+
						 				"<div class='controls'>"+
										"<select id='jlLevel' name='jlLevel'>"+
										
										"<c:forEach items='${fns:getDictList(\'achievement_jl_level_type\')}' var='jlLevel'>"+
											"<option value='${jlLevel.value}'>${jlLevel.label}</option>"+
										"</c:forEach>"+
										"</select>"+
						 				"</div>"+
						 			"</div>"+
								 			"<div class='control-group'>"+
								 				"<label class='control-label'>院配套奖励金额:</label>"+
								 				"<div class='controls'>"+
								 					"<input id='yjl' name='yjl' type='text' class='number'/>"+
								 				"</div>"+
								 			"</div>"+
								 			"<div class='control-group'>"+
								 				"<label class='control-label'>奖励金额:</label>"+
								 				"<div class='controls'>"+
								 					"<input id='jl' name='jl' type='text' class='number'/>"+
								 				"</div>"+
								 			"</div>"+
								 			"<div class='control-group'>"+
								 			"<label class='control-label'>备注:</label>"+
								 			"<div class='controls'>"+
								 			"<textarea id='remarks' style='width: 250px; height: 60px;'></textarea>"+
								 			"</div>"+
								 			"</div></div>",{ title: "[追加信息]", submit: function () {
								 				var yjl=top.$("#yjl").val();
												var jl = top.$("#jl").val();
												var awardLevel=top.$("#awardLevel").val();
												var remarks = top.$("#remarks").val();
												saveAdditionalProperty(achievementId, [{
													key: 'yjl',
													value: yjl,
													type: 'S'
												}, {
													key: 'jl',
													value: jl,
													type: 'S'
												}, {
													key: 'awardLevel',
													value: awardLevel,
													type: 'S'
												},{
													key: 'jlLevel',
													value: awardLevel,
													type: 'S'
												},{
													key: 'remarks',
													value: remarks,
													type: 'S'
												}],taskId, [{
													key: 'kjDeptPass',
													value: true,
													type: 'B'
												}]);
								 }
								 });
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
					achievementForm.action="${ctx}/oa/achievement/formModify/" + achievementId + "/" + taskId;
					achievementForm.submit();
				}
			})
		});
		
		/**
		 * 完成属性保存
		 * @param {Object} achievementId
		 */
		function saveAdditionalProperty(achievementId, variables,taskId,taskVariables) {
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
			$.post('${ctx}/oa/achievement/complete/' + achievementId, {
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
				<td>所属科室：</td>
				<td>{{officeName}}</td>
			</tr>
			<tr>
				<td>专业：</td>
				<td>{{major}}</td>
			</tr>
			<tr>
				<td>项目编号：</td>
				<td>{{project.projectNo}}</a></td>
			</tr>
			<tr>
				<td>项目名称：</td>
				<td>{{projectName}}</td>
			</tr>
			<tr>
				<td>第一责任人：</td>
				<td>{{author1DisplayName}}</td>
			</tr>
			<tr>
				<td>第二责任人：</td>
				<td>{{author2DisplayName}}</td>
			</tr>
			<tr>
				<td>第三责任人：</td>
				<td>{{author3DisplayName}}</td>
			</tr>
			<tr>
				<td>权属：</td>
				<td>{{weightBelongDisplayName}}</td>
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
		<shiro:hasPermission name="oa:achievement:edit"><li><a href="${ctx}/oa/achievement/form">新技术引进奖</a></li></shiro:hasPermission>
		<li><a href="${ctx}/oa/achievement/list">所有任务</a></li>
		<li class="active"><a href="${ctx}/oa/achievement/task">待办任务</a></li>
	</ul>
	<form:form id="achievementForm" modelAttribute="achievement" action="" method="post" class="breadcrumb form-search">
	</form:form>
	<tags:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
			<tr>
				<th>申请人</th>
				<th>申请时间</th>
				<th>当前节点</th>
				<th>任务创建时间</th>
				<th>流程状态</th>
				<th>操作</th>
			</tr>
		<tbody>
			<c:forEach items="${achievement}" var="achievement">
				<c:set var="task" value="${achievement.task}" />
				<c:set var="pi" value="${achievement.processInstance}" />
				<tr id="${achievement.id }" tid="${achievement.id}">
					<td>${achievement.user.name}</td>
					<td><fmt:formatDate value="${achievement.createDate}" type="both"/></td>
					<td>${task.name}</td>
					<td><fmt:formatDate value="${task.createTime}" type="both"/></td>
					<td>${pi.suspended ? "已挂起" : "正常" }；<b title='流程版本号'>V: ${achievement.processDefinition.version}</b></td>
					<td>
						<c:if test="${empty task.assignee}">
							<a class="claim" href="#" onclick="javescript:claim('${task.id}');">签收</a>
						</c:if>
						<c:if test="${not empty task.assignee}">
							<%-- 此处用tkey记录当前节点的名称 --%>
							<a class="handle" href="#" data-tkey="${task.taskDefinitionKey}" data-tname="${task.name}"  data-id="${achievement.id}"  data-tid="${task.id}">办理</a>
						</c:if>
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</body>
</html>
