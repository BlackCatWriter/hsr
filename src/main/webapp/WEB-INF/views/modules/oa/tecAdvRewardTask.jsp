<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>院重大实用领先技术奖登记办理</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
$(document).ready(function() {
    $("#rewardForm").validate({
        submitHandler: function(form) {
            loading('正在提交，请稍等...');
            form.submit();
        },
        errorContainer: "#messageBox",
        errorPlacement: function(error, element) {
            $("#messageBox").text("输入有误，请先更正。");
            if (element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-append")) {
                error.appendTo(element.parent().parent());
            } else {
                error.insertAfter(element);
            }
        }
    });
    $("#assignForm").validate({
        submitHandler: function(form) {
            loading('正在提交，请稍等...');
            form.submit();
        },
        errorContainer: "#messageBox",
        errorPlacement: function(error, element) {
            $("#messageBox").text("输入有误，请先更正。");
            if (element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-append")) {
                error.appendTo(element.parent().parent());
            } else {
                error.insertAfter(element);
            }
        }
    });
    $("#lxForm").validate({
        submitHandler: function(form) {
            loading('正在提交，请稍等...');
            form.submit();
        },
        errorContainer: "#messageBox",
        errorPlacement: function(error, element) {
            $("#messageBox").text("输入有误，请先更正。");
            if (element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-append")) {
                error.appendTo(element.parent().parent());
            } else {
                error.insertAfter(element);
            }
        }
    });

    $(".handle").click(function() {
        var obj = $(this);
        var taskId = obj.data("tid");
        var rewardId = obj.data("id");
        var tkey = obj.data("tkey");
        //科教科领导审批
        if(tkey=="deptLeaderAudit"){
          	 $.getJSON("${ctx}/oa/reward/detail/" + rewardId,
          	            function(data) {
          	                var html = Mustache.render($("#auditTemplate").html(), data);
          	                top.$.jBox(html, {
          	                    title: "流程办理[" + obj.data("tname") + "]",
          	                    buttons: {
          	                        "同意": "yes",
          	                        "驳回": "no",
          	                        "取消": "cancel"
          	                    },
          	                    submit: function(v, h, f) {
          	                        //同意
          	                        if (v == "yes") {
          	                        	complete(taskId, [{
                                              key: 'kjDeptPass',
                                              value: true,
                                              type: 'B'
                                          }]);
          	                     	} else if (v == "no") {
          	                            top.$.jBox("<div style='padding:10px;'><textarea id='kjDeptBackReason' style='width: 250px; height: 60px;'></textarea></div>", {
          	                                title: "请填写打回理由",
          	                                submit: function() {
          	                                    var kjDeptBackReason = top.$("#kjDeptBackReason").val();
          	                                    //必须填写驳回理由
          	                                    if ($.trim(kjDeptBackReason) == "") {
          	                                        top.$.jBox.error('请填写打回理由', '错误');
          	                                        return false;
          	                                    } else {
          	                                        complete(taskId, [{
          	                                            key: 'kjDeptPass',
          	                                            value: false,
          	                                            type: 'B'
          	                                        },
          	                                        {
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
        if (tkey == "kjDeptAudit") {
            $.getJSON("${ctx}/oa/tecAdvReward/detail/" + rewardId,
            function(data) {
                var html = Mustache.render($("#auditTemplate").html(), data);
                top.$.jBox(html, {
                    title: "流程办理[" + obj.data("tname") + "]",
                    buttons: {
                        "同意": "yes",
                        "驳回": "no",
                        "取消": "cancel"
                    },
                    submit: function(v, h, f) {
                        //同意
                        if (v == "yes") {
                                    complete( taskId, [{
                                        key: 'kjDeptPass',
                                        value: true,
                                        type: 'B'
                                    }]);

                            //驳回
                        } else if (v == "no") {
                            top.$.jBox("<div style='padding:10px;'><textarea id='kjDeptBackReason' style='width: 250px; height: 60px;'></textarea></div>", {
                                title: "请填写打回理由",
                                submit: function() {
                                    var kjDeptBackReason = top.$("#kjDeptBackReason").val();
                                    //必须填写驳回理由
                                    if ($.trim(kjDeptBackReason) == "") {
                                        top.$.jBox.error('请填写打回理由', '错误');
                                        return false;
                                    } else {
                                        complete(taskId, [{
                                            key: 'kjDeptPass',
                                            value: false,
                                            type: 'B'
                                        },
                                        {
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
        if (tkey == "lxAudit") {
            $.getJSON("${ctx}/oa/tecAdvReward/detail/" + rewardId+"?time="+new Date().getTime(),
            function(data) {
                var html = Mustache.render($("#lxAuditTemplate").html(), data);
                top.$.jBox(html, {
                    title: "流程办理[" + obj.data("tname") + "]",
                    buttons: {
                        "同意并追加信息": "yes",
                        "驳回": "no",
                        "取消": "cancel"
                    },
                    submit: function(v, h, f) {
                        //同意
                        if (v == "yes") {
                            top.$.jBox("<div style='padding:10px;'>" 
                            + "<div class='control-group'>" + "<div class='controls'>"+ "<label class='control-label'>获奖年份:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>" + "<input id=\"year\" name=\"year\" type=\"text\"\ maxlength=\"20\" class=\"input-medium Wdate\" value=\"${year}\" onclick=\"WdatePicker({dateFmt:'yyyy',isShowClear:false});\"/>" + "</div>" + "</div>" 
                            + "<div class='control-group'>" + "<div class='controls'>"+ "<label class='control-label'>奖励经费:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>"  + "<input id='xb_fee' name='xb_fee' type='text' class='number'/>" + "</div>" + "</div>" 
                            + "<div class='control-group'>" + "<div class='controls'>"+ "<label class='control-label'>权重:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>"+  "<input id='weight' name='weight' type='text' class='number'/>"+ "</div>"+ "</div>" 
                            + "<div class='control-group'>" + "<div class='controls'>"+ "<label class='control-label'>第一年病例数:</label>"  + "<input id='caseCountFirst' name='caseCountFirst' readonly='true' type='text' class='number'/>" + "</div>" + "</div>" 
                            + "<div class='control-group'>" + "<div class='controls'>"+ "<label class='control-label'>奖&nbsp励&nbsp;一:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>"  + "<input id='jlFirst' name='jlFirst' type='text' class='number'/>" + "</div>" + "</div>" 
                            + "<div class='control-group'>" + "<div class='controls'>"+ "<label class='control-label'>第二年病例数:</label>"  + "<input id='caseCountSecond' name='caseCountSecond' readonly='true' type='text' class='number'/>" + "</div>" + "</div>" 
                            + "<div class='control-group'>" + "<div class='controls'>"+ "<label class='control-label'>奖&nbsp励&nbsp;二:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>"  + "<input id='jlSecond' name='jlSecond' type='text' class='number'/>" + "</div>" + "</div>" 
                            + "<div class='control-group'>" + "<div class='controls'>"+ "<label class='control-label'>奖励级别:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>"+ "<select id='grade' name='grade'>" + "<c:forEach items='${fns:getDictList(\'reward_gradetech\')}' var='level'>" + "<option value=\"${level.value}\">${level.label}</option>" + "</c:forEach>" + "</select>" + "</div>" + "</div>" 
                            + "<div class='control-group'>" + "<div class='controls'>"+ "<label class='control-label'>奖励等级:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>"+ "<select id='level' name='level'>" + "<c:forEach items='${fns:getDictList(\'reward_level\')}' var='level'>" + "<option value=\"${level.value}\">${level.label}</option>" + "</c:forEach>" + "</select>" + "</div>" + "</div>" 
                            + "<div class='control-group'>" + "<label class='control-label'>备注:</label>" + "<div class='controls'>" + "<textarea id='remarks' style='width: 250px; height: 60px;'></textarea>" + "</div>" + "</div>" + "</div>", {
                                title: "[追加信息]",
                                submit: function() {
                                    var year = top.$("#year").val();
                                    var weight = $.trim(top.$("#weight").val());
                                    var xb_fee = $.trim(top.$("#xb_fee").val());
                                    var caseCountFirst = $.trim(top.$("#caseCountFirst").val());
                                    var caseCountSecond = $.trim(top.$("#caseCountSecond").val());
                                    var jlFirst = $.trim(top.$("#jlFirst").val());
                                    var jlSecond = $.trim(top.$("#jlSecond").val());
                                    var remarks = top.$("#remarks").val();
                                    var grade = top.$("#grade").val();
                                    var level = top.$("#level").val();
                                    var decimal = /^[0-9]+([\.][0-9]{0,3})?$/;
                                    if (xb_fee != '') {
                                        if (!decimal.test(xb_fee)) {
                                            top.$.jBox.tip('请输入正确的奖励金额');
                                            return false;
                                        }
                                    }
                                    if (weight != '') {
                                        if (!decimal.test(weight)) {
                                            top.$.jBox.tip('请输入数字');
                                            return false;
                                        }
                                    }
                                    if (caseCountFirst != '') {
                                        if (!decimal.test(caseCountFirst)) {
                                            top.$.jBox.tip('请输入数字');
                                            return false;
                                        }
                                    }
                                    if (caseCountSecond != '') {
                                        if (!decimal.test(caseCountSecond)) {
                                            top.$.jBox.tip('请输入数字');
                                            return false;
                                        }
                                    }
                                    if (jlFirst != '') {
                                        if (!decimal.test(jlFirst)) {
                                            top.$.jBox.tip('请输入正确的金额');
                                            return false;
                                        }
                                    }
                                    if (jlSecond != '') {
                                        if (!decimal.test(jlSecond)) {
                                            top.$.jBox.tip('请输入正确的金额');
                                            return false;
                                        }
                                    }
                                    saveAdditionalProperty(rewardId, [
                                    {
                                        key: 'year',
                                        value: year,
                                        type: 'S'
                                    },
                                    {
                                        key: 'grade',
                                        value: grade,
                                        type: 'S'
                                    },
                                    {
                                        key: 'level',
                                        value: level,
                                        type: 'S'
                                    },
                                    {
                                        key: 'xb_fee',
                                        value: xb_fee,
                                        type: 'S'
                                    },
                                    {
                                        key: 'weight',
                                        value: weight,
                                        type: 'S'
                                    },
                                    {
                                        key: 'caseCountFirst',
                                        value: caseCountFirst,
                                        type: 'S'
                                    },
                                    {
                                        key: 'caseCountSecond',
                                        value: caseCountSecond,
                                        type: 'S'
                                    },
                                    {
                                        key: 'jlFirst',
                                        value: jlFirst,
                                        type: 'S'
                                    },
                                    {
                                        key: 'jlSecond',
                                        value: jlSecond,
                                        type: 'S'
                                    },
                                    {
                                        key: 'remarks',
                                        value: remarks,
                                        type: 'S'
                                    },
                                    {
                                        key: 'lxSuccess',
                                        value: true,
                                        type: 'B'
                                    }], taskId, [{
                                        key: 'kjDeptPass',
                                        value: true,
                                        type: 'B'
                                    }]);
                                }
                            });
                            top.$("#year").val(data.year);
                            top.$("#xb_fee").val(data.xb_fee);
                            top.$("#weight").val(data.weight);
                            top.$("#caseCountFirst").val(data.caseCountFirst);
                            top.$("#caseCountSecond").val(data.caseCountSecond);
                            top.$("#jlFirst").val(data.jlFirst);
                            top.$("#jlSecond").val(data.jlSecond);
                            top.$("#grade").val(data.grade);
                            top.$("#level").val(data.level);
                            top.$("#remarks").val(data.remarks);
                            //驳回
                        } else if (v == "no") {
                            top.$.jBox("<div style='padding:10px;'><textarea id='kjDeptBackReason' style='width: 250px; height: 60px;'></textarea></div>", {
                                title: "请填写打回理由",
                                submit: function() {
                                    var kjDeptBackReason = top.$("#kjDeptBackReason").val();
                                    //必须填写驳回理由
                                    if ($.trim(kjDeptBackReason) == "") {
                                        top.$.jBox.error('请填写打回理由', '错误');
                                        return false;
                                    } else {
                                        complete(taskId, [{
                                            key: 'kjDeptPass',
                                            value: false,
                                            type: 'B'
                                        },
                                        {
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
        if (tkey == "modifyApply") {
        	redirectForm.action = "${ctx}/oa/tecAdvReward/formModify/" + rewardId + "/" + taskId;
        	redirectForm.submit();
        }
        //院内评审
        if (tkey == "hosAudit") {
        	redirectForm.action = "${ctx}/oa/tecAdvReward/formAudit/" + rewardId + "/" + taskId;
        	redirectForm.submit();
        }
        //院内专家审核
        if (tkey == "assignCheck") {
        	redirectForm.action = "${ctx}/oa/tecAdvReward/forAudit/" + rewardId;
        	redirectForm.submit();
        }
    });
});

function saveAdditionalProperty(rewardId, variables, taskId, taskVariables) {
    var keys = "",
    values = "",
    types = "";
    if (variables) {
        $.each(variables,
        function() {
            if (keys != "") {
                keys += "|";
                values += "|";
                types += "|";
            }
            keys += this.key;
            if (this.value == "") {
                values += " ";
            } else {
                values += this.value;
            }
            types += this.type;
        });
    }
    $.post('${ctx}/oa/tecAdvReward/complete/' + rewardId, {
        keys: keys,
        values: values,
        types: types
    },
    function(resp) {
        if (resp == 'success') {
            complete(taskId, taskVariables);
        } else {
            top.$.jBox.tip('操作失败!');
        }
    });
}

function assign() {
    $("#assignForm").attr("action", "${ctx}/oa/tecAdvReward/assign");
    $("#assignForm").submit();
}

function editStatus() {
    $("#lxForm").attr("action", "${ctx}/oa/tecAdvReward/editStatus");
    $("#lxForm").submit();
}

function complete(taskId, variables) {
    var keys = "",
    values = "",
    types = "";
    if (variables) {
        $.each(variables,
        function() {
            if (keys != "") {
                keys += "|";
                values += "|";
                types += "|";
            }
            keys += this.key;
            if (this.value == "") {
                values += " ";
            } else {
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
    },
    function(resp) {
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
				<td>院重大实用领先技术奖：</td>
				<td><a href="${ctx}/oa/tecAdvReward/get/{{id}}" target='_blank'>{{rewardName}}</a></td>
			</tr>
			<tr>
				<td>第一完成人：</td>
				<td>{{author1DisplayName}}</td>
			</tr>
			<tr>
				<td>第二完成人：</td>
				<td>{{author2DisplayName}}</td>
			</tr>
			<tr>
				<td>第三完成人：</td>
				<td>{{author3DisplayName}}</td>
			</tr>
			<tr>
				<td>权属：</td>
				<td>{{weightBelongDisplayName}}</td>
			</tr>
			<tr>
				<td>所属科室：</td>
				<td>{{officeName}}</td>
			</tr>
			<tr>
				<td>申请级别：</td>
				<td>{{tecRewardGrade}}</td>
			</tr>
			<tr>
				<td>申请等级：</td>
				<td>{{rewardLevel}}</td>
			</tr>
			<tr>
				<td>备注：</td>
				<td>{{remarks}}</td>
			</tr>
		</table>
		</div>
</script>

<script type="text/template" id="lxAuditTemplate">
		<div style="overflow-y:auto; height:400px;">
		<table class="table table-striped ">
			<tr>
				<td width="100px;">申请人：</td>
				<td>{{user.name}}</td>
			</tr>
			<tr>
				<td>院重大实用领先技术奖：</td>
				<td><a href="${ctx}/oa/tecAdvReward/get/{{id}}" target='_blank'>{{rewardName}}</a></td>
			</tr>
			<tr>
				<td>第一完成人：</td>
				<td>{{author1DisplayName}}</td>
			</tr>
			<tr>
				<td>第二完成人：</td>
				<td>{{author2DisplayName}}</td>
			</tr>
			<tr>
				<td>第三完成人：</td>
				<td>{{author3DisplayName}}</td>
			</tr>
			<tr>
				<td>权属：</td>
				<td>{{weightBelongDisplayName}}</td>
			</tr>
			<tr>
				<td>所属科室：</td>
				<td>{{officeName}}</td>
			</tr>
			<tr>
				<td>获奖年份：</td>
				<td>{{year}}</td>
			</tr>
			<tr>
				<td>奖励经费：</td>
				<td>{{xb_fee}}</td>
			</tr>
			<tr>
				<td>第一年病例数：</td>
				<td>{{caseCountFirst}}</td>
			</tr>
			<tr>
				<td>奖励1：</td>
				<td>{{jlFirst}}</td>
			</tr>
			<tr>
				<td>第二年病例数：</td>
				<td>{{caseCountSecond}}</td>
			</tr>
			<tr>
				<td>奖励2：</td>
				<td>{{jlSecond}}</td>
			</tr>
			<tr>
				<td>申请级别：</td>
				<td>{{tecRewardGrade}}</td>
			</tr>
			<tr>
				<td>申请等级：</td>
				<td>{{rewardLevel}}</td>
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
			<li><a href="${ctx}/oa/tecAdvReward/form">院重大实用领先技术奖登记</a></li>
		<li><a href="${ctx}/oa/tecAdvReward/list">所有任务</a></li>
		<li class="active"><a href="${ctx}/oa/tecAdvReward/task">待办任务</a></li>
	</ul>
	<tags:message content="${message}" />
	
		<c:if
			test="${!empty rewardModel.kjkAuditRewards or (empty rewardModel.hosAuditRewards and empty rewardModel.lxAuditRewards) }">
			<form:form id="rewardForm" modelAttribute="rewardModel" action="" method="post" class="breadcrumb">
			<table id="contentTable"
				class="table table-striped table-bordered table-condensed">
				<tr>
					<th>申请人</th>
					<th>申请时间</th>
					<th>院重大实用领先技术奖：</th>
					<th>当前节点</th>
					<th>任务创建时间</th>
					<th>流程状态</th>
					<th>操作</th>
				</tr>
				<tbody>
					<c:forEach items="${rewardModel.kjkAuditRewards}" var="reward">
						<c:set var="task" value="${reward.task}" />
						<c:set var="pi" value="${reward.processInstance}" />
						<tr id="${reward.id }">
							<td>${reward.user.name}</td>
							<td><fmt:formatDate value="${reward.createDate}"
									type="both" /></td>
							<c:if test="${empty reward.file}">
								<td>${reward.rewardName}</td>
							</c:if>
							<c:if test="${not empty reward.file}">
								<td><a href="${ctx}/oa/reward/get/${reward.id}" target='_blank'>${reward.rewardName}</a></td>
							</c:if>
							<td>${task.name}</td>
							<td><fmt:formatDate value="${task.createTime}" type="both" /></td>
							<td>${pi.suspended ? "已挂起" : "正常" }；<b title='流程版本号'>V:
									${reward.processDefinition.version}</b></td>
							<td><a class="handle" href="#"
								data-tkey="${task.taskDefinitionKey}" data-tname="${task.name}"
								data-id="${reward.id}" data-tid="${task.id}">办理</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			</form:form>
		</c:if>
		<c:if test="${!empty rewardModel.hosAuditRewards}">
		<form:form id="assignForm" modelAttribute="rewardModel" action="" method="post" class="breadcrumb">
			<div class="control-group">
				<label class="control-label">分发院内专家评审：</label>
				<div class="controls">
					<tags:namesSuggest value="${rewardModel.users}"
						cssClass="required" name="users" id="users"
						url="${ctx}/sys/user/users/"></tags:namesSuggest>
					&nbsp;<input id="btnStatus" class="btn" type="button"
						onclick="assign()" value="分发" />
				</div>
			</div>


			<table id="contentTable"
				class="table table-striped table-bordered table-condensed">
				<tr>
					<th></th>
					<th>申请人</th>
					<th>申请时间</th>
					<th>院重大实用领先技术奖：</th>
					<th>当前节点</th>
					<th>任务创建时间</th>
					<th>专家评审进度</th>
					<th>操作</th>
				</tr>
				<tbody>
					<c:forEach items="${rewardModel.hosAuditRewards}" var="reward">
						<c:set var="task" value="${reward.task}" />
						<c:set var="pi" value="${reward.processInstance}" />
						<tr id="${reward.id }">
							<td><form:checkbox class="required" path="hosRewardIds" value="${reward.id}" /></td>
							<td>${reward.user.name}</td>
							<td><fmt:formatDate value="${reward.createDate}"
									type="both" /></td>
							<c:if test="${empty reward.file}">
								<td>${reward.rewardName}</td>
							</c:if>
							<c:if test="${not empty reward.file}">
								<td><a href="${ctx}/oa/reward/get/${reward.id}" target='_blank'>${reward.rewardName}</a></td>
							</c:if>
							<td>${task.name}</td>
							<td><fmt:formatDate value="${task.createTime}" type="both" /></td>
							<td>${reward.checkedCount}/${reward.assignCount}</td>
							<td><a class="handle" href="#"
								data-tkey="${task.taskDefinitionKey}" data-tname="${task.name}"
								data-id="${reward.id}" data-tid="${task.id}">办理</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			</form:form>
		</c:if>
	
		<c:if test="${!empty rewardModel.lxAuditRewards}">
		<form:form id="lxForm" modelAttribute="rewardModel" action=""
		method="post" class="breadcrumb">
			<div class="control-group">
				<label class="control-label">项目追踪：</label>
				<div class="controls">
					<form:input path="rewardStatus" htmlEscape="false" maxlength="200" class="required"/>
					&nbsp;<input id="btnStatus" class="btn" type="button"
						onclick="editStatus()" value="修改" />
				</div>
			</div>

			<table id="contentTable"
				class="table table-striped table-bordered table-condensed">
				<tr>
					<th></th>
					<th>申请人</th>
					<th>申请时间</th>
					<th>院重大实用领先技术奖：</th>
					<th>当前节点</th>
					<th>任务创建时间</th>
					<th>项目进度追踪</th>
					<th>操作</th>
				</tr>
				<tbody>
					<c:forEach items="${rewardModel.lxAuditRewards}" var="reward">
						<c:set var="task" value="${reward.task}" />
						<c:set var="pi" value="${reward.processInstance}" />
						<tr id="${reward.id }">
							<td><form:checkbox class="required" path="lxRewardIds"
									value="${reward.id}" /></td>
							<td>${reward.user.name}</td>
							<td><fmt:formatDate value="${reward.createDate}"
									type="both" /></td>
							<c:if test="${empty reward.file}">
								<td>${reward.rewardName}</td>
							</c:if>
							<c:if test="${not empty reward.file}">
								<td><a href="${ctx}/oa/reward/get/${reward.id}" target='_blank'>${reward.rewardName}</a></td>
							</c:if>
							<td>${task.name}</td>
							<td><fmt:formatDate value="${task.createTime}" type="both" /></td>
							<td>${reward.processStatus}</td>
							<td><a class="handle" href="#"
								data-tkey="${task.taskDefinitionKey}" data-tname="${task.name}"
								data-id="${reward.id}" data-tid="${task.id}">办理</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			</form:form>
		</c:if>

		<c:if test="${!empty rewardModel.assignedReward}">
			<div class="control-group">
				<label class="control-label">待评审项目：</label>
			</div>
			<table id="contentTable"
				class="table table-striped table-bordered table-condensed">
				<tr>
					<th>申请人</th>
					<th>申请时间</th>
					<th>院重大实用领先技术奖：</th>
					<th>当前节点</th>
					<th>任务创建时间</th>
					<th>评审进度</th>
					<th>详细内容</th>
				</tr>
				<tbody>
					<c:forEach items="${rewardModel.assignedReward}" var="reward">
						<c:set var="task" value="${reward.task}" />
						<c:set var="pi" value="${reward.processInstance}" />
						<tr id="${reward.id }">
							<td>${reward.user.name}</td>
							<td><fmt:formatDate value="${reward.createDate}"
									type="both" /></td>
							<c:if test="${empty reward.file}">
								<td>${reward.rewardName}</td>
							</c:if>
							<c:if test="${not empty reward.file}">
								<td><a href="${ctx}/oa/reward/get/${reward.id}" target='_blank'>${reward.rewardName}</a></td>
							</c:if>
							<td>${task.name}</td>
							<td><fmt:formatDate value="${task.createTime}" type="both" /></td>
							<td>${reward.checkedCount}/${reward.assignCount}</td>
							<td><a class="handle" href="#" data-tkey="assignCheck"
								data-tname="${task.name}" data-id="${reward.id}"
								data-tid="${task.id}">审核</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</c:if>
		<form:form id="redirectForm"/>
</body>
</html>
