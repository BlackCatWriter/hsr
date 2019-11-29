<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>进修申请办理</title>
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
				var advstudyId = obj.data("id");
				var tkey=obj.data("tkey");
				//科室领导审批
				if(tkey=="deptLeaderAudit") {
                    $.getJSON("${ctx}/oa/advstudy/detail/" + advstudyId , function(data){
						 var html= Mustache.render($("#auditTemplate").html(),data);
						 top.$.jBox(html, { title: "流程办理["+obj.data("tname") + "]",buttons:{"同意":"yes","驳回":"no","取消":"cancel"},submit: function (v, h, f) {
							 //同意
							 if(v=="yes") {
	                        	 complete(taskId, [{
	                                 key: 'kjDeptPass',
	                                 value: true,
	                                 type: 'B'
	                               }]);
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
                    $.getJSON("${ctx}/oa/advstudy/detail/" + advstudyId , function(data){
						 var html= Mustache.render($("#auditTemplate").html(),data);
						 top.$.jBox(html, { title: "流程办理["+obj.data("tname") + "]",buttons:{"同意":"yes","驳回":"no","取消":"cancel"},submit: function (v, h, f) {
							 //同意
							 if(v=="yes") {saveAdditionalProperty(advstudyId, [],taskId, [{
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
                    $.getJSON("${ctx}/oa/advstudy/detailcost/" + advstudyId , function(data){
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
                    $.getJSON("${ctx}/oa/advstudy/detailcost/" + advstudyId , function(data){
						 var html= Mustache.render($("#auditcostTemplate").html(),data);
						 top.$.jBox(html, { title: "流程办理["+obj.data("tname") + "]",buttons:{"同意":"yes","驳回":"no","取消":"cancel"},submit: function (v, h, f) {
							 //同意
							 if(v=="yes") {saveCostAdditionalProperty(advstudyId, [],taskId, [{
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
					advstudyForm.action="${ctx}/oa/advstudy/formModify/" + advstudyId + "/" + taskId;
					advstudyForm.submit();
				}
				if(tkey=="modifyCostApply") {
					advstudyForm.action="${ctx}/oa/advstudy/costModify/" + advstudyId + "/" + taskId;
					advstudyForm.submit();
				}
			})
		});
		
		/**
		 * 完成属性保存
		 * @param {Object} advstudyId
		 */
		function saveAdditionalProperty(advstudyId, variables,taskId,taskVariables) {
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
			$.post('${ctx}/oa/advstudy/complete/' + advstudyId, {
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
			 * @param {Object} advstudyId
			 */
			function saveCostAdditionalProperty(advstudyId, variables,taskId,taskVariables) {
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
				$.post('${ctx}/oa/advstudy/completecost/' + advstudyId, {
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
				<td>进修方向：</td>
				<td>{{advstudyDirection}}</td>
			</tr>
			<tr>
				<td>进修单位：</td>
				<td>{{hostUnit}}</td>
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
		<li><a href="${ctx}/oa/advstudy/form">进修申请</a></li>
		<li><a href="${ctx}/oa/advstudy/cost">进修经费报销</a></li>
		<li><a href="${ctx}/oa/advstudy/list">所有任务</a></li>
		<li class="active"><a href="${ctx}/oa/advstudy/task">待办任务</a></li>
	</ul>
	<form:form id="advstudyForm" modelAttribute="advstudy" action="" method="post" class="breadcrumb form-search">
	</form:form>
	<tags:message content="${message}"/>
	<div><b>申请待办任务</b></div>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
			<tr>
				<th>申请人</th>
				<th>所属科室</th>
				<th>进修方向</th>
				<th>进修开始日期</th>
				<th>进修结束日期</th>
				<th>当前节点</th>
				<%--<th>流程状态</th>--%>
				<th>操作</th>
			</tr>
		<tbody>
			<c:forEach items="${advstudy}" var="advstudy">
				<c:set var="task" value="${advstudy.task}" />
				<c:set var="pi" value="${advstudy.processInstance}" />
				<tr id="${advstudy.id }" tid="${advstudy.id}">
					<td>${advstudy.user.name}</td>
					<td>${advstudy.office.name}</td>
					<td>${advstudy.advstudyDirection}</td>
					<td><fmt:formatDate value="${advstudy.startDate}" pattern="yyyy-MM-dd" type="both"/></td>
					<td><fmt:formatDate value="${advstudy.endDate}" pattern="yyyy-MM-dd" type="both"/></td>
					<td>${task.name}</td>
					<%--<td>${pi.suspended ? "已挂起" : "正常" }；<b title='流程版本号'>V: ${advstudy.processDefinition.version}</b></td>--%>
					<td>
							<%-- 此处用tkey记录当前节点的名称 --%>
							<a class="handle" href="#" data-tkey="${task.taskDefinitionKey}" data-tname="${task.name}"  data-id="${advstudy.id}"  data-tid="${task.id}">办理</a>

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
				<th>进修方向</th>
				<th>进修报销金额</th>
				<th>报销上传附件</th>
				<th>当前节点</th>
				<%--<th>流程状态</th>--%>
				<th>操作</th>
			</tr>
		<tbody>
			<c:forEach items="${costresults}" var="advstudy">
				<c:set var="task" value="${advstudy.academiccost.task}" />
				<c:set var="academiccost" value="${advstudy.academiccost}" />
				<c:set var="pi" value="${advstudy.academiccost.processInstance}" />
				<tr id="${advstudy.id}" tid="${advstudy.id}">
					<td>${advstudy.user.name}</td>
					<td>${advstudy.office.name}</td>
					<td>${advstudy.advstudyDirection}</td>
					<td>${advstudy.academiccost.bxFee}</td>
					<td><a href="${ctx}/cms/academiccost/get/${advstudy.academiccost.id}">${advstudy.academiccost.file}</a></td>
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
