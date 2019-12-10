<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>经费申请一览</title>
	<meta name="decorator" content="default"/>
	<script src="${ctxStatic}/jQuery-File-Upload-9.9.3/js/vendor/jquery.ui.widget.js"></script>
	<script src="${ctxStatic}/jQuery-File-Upload-9.9.3/js/jquery.iframe-transport.js"></script>
	<script src="${ctxStatic}/jQuery-File-Upload-9.9.3/js/jquery.fileupload.js"></script>
	<script src="${ctxStatic}/bootstrap/2.3.1/js/bootstrap.min.js"></script>
	<link href="${ctxStatic}/bootstrap/2.3.1/css_default/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<link href="${ctxStatic}/common/dropzone.css" type="text/css" rel="stylesheet" />
	<script src="${ctxStatic}/common/myuploadfunction.js"></script>
	<%@include file="/WEB-INF/views/include/dialog.jsp" %>
	<script type="text/javascript">
	function page(n, s) {
	    $("#pageNo").val(n);
	    $("#pageSize").val(s);
	    $("#searchForm").submit();
	    return false;
	}
	$(document).ready(function () {
	    $(".handle").click(function () {
	            var obj = $(this);
	            var projectId = obj.data("id");
	            //编辑项目的立项号，立项单位和经费
	            $.getJSON("${ctx}/oa/project/detail/" + projectId, function (data) {
	                    top.$.jBox("<div style='padding:10px;'>" +
	                        "<div class='control-group'>" +
	                        "<label class='control-label'>立项单位:</label>" +
	                        "<div class='controls'>" +
	                        "<input id='approvalOrg' name='approvalOrg' type='text' />" +
	                        "</div>" +
	                        "</div>" +
	                        "<div class='control-group'>" +
	                        "<label class='control-label'>立项号:</label>" +
	                        "<div class='controls'>" +
	                        "<input id='projectNo' name='projectNo' type='text' />" +
	                        "</div>" +
	                        "</div>" +
	                        "<div class='control-group'>" +
	                        "<label class='control-label'>下拨经费:</label>" +
	                        "<div class='controls'>" +
	                        "<input id='xb_fee' name='xb_fee' type='text' class='number'/>" +
	                        "</div>" +
	                        "</div>" +
	                        "<div class='control-group'>" +
	                        "<label class='control-label'>配套经费:</label>" +
	                        "<div class='controls'>" +
	                        "<input id='pt_fee' name='pt_fee' type='text' class='number'/>" +
	                        "</div>" +
	                        "</div>" +
	                        "<div class='control-group'>" +
	                        "<label class='control-label'>实到经费:</label>" +
	                        "<div class='controls'>" +
	                        "<input id='sd_fee' name='sd_fee' type='text' class='number'/>" +
	                        "</div>" +
	                        "</div>" +
	                        "<div class='control-group'>" +
	                        "<label class='control-label'>备注:</label>" +
	                        "<div class='controls'>" +
	                        "<textarea id='remarks' style='width: 250px; height: 60px;'></textarea>" +
	                        "</div>" +
	                        "</div>" +
	                        "</div>", {
	                            title: "[修改信息]",
	                            submit: function () {
	                                var projectNo = top.$("#projectNo").val();
	                                var approvalOrg = top.$("#approvalOrg").val();
	                                var xb_fee = top.$("#xb_fee").val();
	                                var xb_fee = $.trim(top.$("#xb_fee").val());
	                                var pt_fee = $.trim(top.$("#pt_fee").val());
	                                var sd_fee = $.trim(top.$("#sd_fee").val());
	                                var remarks = top.$("#remarks").val();
	                                var decimal = /^[0-9]+([\.][0-9]{0,3})?$/;
	                                if (xb_fee != '') {
	                                    if (!decimal.test(xb_fee)) {
	                                        top.$.jBox.tip('请输入正确的下拨金额');
	                                        return false;
	                                    }
	                                }
	                                if (sd_fee != '') {
	                                    if (!decimal.test(sd_fee)) {
	                                        top.$.jBox.tip('请输入正确的实到金额');
	                                        return false;
	                                    }
	                                }
	                                if (pt_fee != '') {
	                                    if (!decimal.test(pt_fee)) {
	                                        top.$.jBox.tip('请输入正确的配套金额');
	                                        return false;
	                                    }
	                                }
	                                saveAdditionalProperty(projectId, [
	                                {
	                                    key: 'projectNo',
	                                    value: projectNo,
	                                    type: 'S'
	                                }, {
	                                    key: 'approvalOrg',
	                                    value: approvalOrg,
	                                    type: 'S'
	                                }, {
	                                    key: 'xb_fee',
	                                    value: xb_fee,
	                                    type: 'S'
	                                }, {
	                                    key: 'sd_fee',
	                                    value: sd_fee,
	                                    type: 'S'
	                                }, {
	                                    key: 'pt_fee',
	                                    value: pt_fee,
	                                    type: 'S'
	                                }, {
	                                    key: 'remarks',
	                                    value: remarks,
	                                    type: 'S'
	                                }, {
	                                    key: 'editexpense',
	                                    value: true,
	                                    type: 'B'
	                                }]);
	                            }
	                        });
	                    top.$("#projectNo").val(data.projectNo);
	                    top.$("#approvalOrg").val(data.approvalOrg);
	                    top.$("#xb_fee").val(data.xb_fee);
	                    top.$("#sd_fee").val(data.sd_fee);
	                    top.$("#pt_fee").val(data.pt_fee);
		                });
		        });

				$("#btnImport").click(function(){
					$.jBox($("#importBox").html(), {title:"导入数据", buttons:{"关闭":true},
						bottomText:"导入文件不能超过5M，仅允许导入“xls”或“xlsx”格式文件！"});
				});
			});

	function uploadFiles(projectId,type){
        top.$.jBox(
        		"<div style='padding:10px;'>" +
                "<div class='control-group'>" +
                "<label class='control-label'>附件:</label>" +
                "<div class='controls'>" +
                "<input id='fileupload' type='file'	name='files[]' data-url='${ctx}/oa/project/upload/project'>" +
                "</div>" +

    			"<div class='controls'>"+
    			"<div id='progress' class='progress'>"+
    			"<div class='bar' style='width: 0%;'></div>"+
    			"</div>"+
    			"</div>"+
                "</div>" +
                "</div>", {
                    title: "[附件上传]",
                    submit: function () {
                        var fileupload = top.$("#fileupload").val();
                        $.post('${ctx}/oa/project/'+type+'/' + projectId, {
                	        keys: 'fileName',
                	        values: fileupload,
                	        types: 'S'
                	    }, function(resp) {
                	        if (resp == 'success') {
                	        	top.$.jBox.tip('保存完成');
                	            location.reload();
                	        } else {
                	        	top.$.jBox.tip('操作失败!');
                	        }
                	    });
                    }
                });
	}

    function saveExpensePlan(projectId){
        top.$.jBox(
            "<div style='padding:10px;'>" +
            "<c:forEach items='${fns:getDictList("oa_expense_type")}' var='dict'>" +
            "<input type=\"hidden\" name=\"expenseTypes\" value=\"${dict.value}\"/>" +
            "<div class=\"control-group\">" +
            "<label class=\"control-label\">${dict.label}：</label>" +
            "<div class=\"controls\">" +
            "<input name=\"ratios\" type=\"text\" class=\"required\" " +
            "onkeyup=\"if(this.value.length==1){this.value=this.value.replace(/[^1-9]/g,'')}else{this.value=this.value.replace(/\\D/g,'')}\""+
            "onafterpaste=\"if(this.value.length==1){this.value=this.value.replace(/[^1-9]/g,'')}else{this.value=this.value.replace(/\\D/g,'')}\">"+
            "<span class=\"add-on\">%</span>"+
            "</div>"+
            "</div>"+
            "</c:forEach>"+
        	"</div>", {
                title: "请先完成预算配置",
                submit: function () {
                    var _money=0;
                    top.$("input[name=ratios]").each(function(){
                        //累加求和
                        _money+=Number($(this).val());
                    });
                    if (_money > 100) {
                        top.$.jBox.tip('项目配置比例总和不得大于100！');
                        return false;
                    }
                    var expenseTypes = top.$("input[name=expenseTypes]").map(function(){return $(this).val()}).get();
                    var ratios = top.$("input[name=ratios]").map(function(){return $(this).val()}).get();
                    $.ajax({
                        type: "POST",
                        dataType: "json",
						traditional: true,
                        url: "${ctx}/cms/account/saveExpensePlan",
                        data: {"project_id": projectId,"expenseTypes": expenseTypes,"ratios": ratios},
                        error: function() {
                            top.$.jBox.tip('操作失败!');
                        },
                        success: function(data) {
                            top.$.jBox.tip('保存完成');
                            location.reload();
                        }
                    });
                }
            });
    }

	/**
	 * 完成属性保存
	 * @param {Object} projectId
	 */
	function saveAdditionalProperty(projectId, variables) {
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
		$.post('${ctx}/oa/project/complete/' + projectId, {
	        keys: keys,
	        values: values,
	        types: types
	    }, function(resp) {
	        if (resp == 'success') {
	        	top.$.jBox.tip('保存完成');
	            location.reload();
	        } else {
	        	top.$.jBox.tip('操作失败!');
	        }
	    });
	}
	</script>
</head>
<body>
	<div id="importBox" class="hide">
		<form id="importForm" action="${ctx}/cms/project/importProjectList" method="post" enctype="multipart/form-data"
			  style="padding-left:20px;text-align:center;" class="form-search" onsubmit="loading('正在导入，请稍等...');"><br/>
			<input id="uploadFile" name="file" type="file" style="width:330px"/><br/><br/>　　
			<input id="btnImportSubmit" class="btn btn-primary" type="submit" value="   导    入   "/>
			<a href="${ctx}/cms/project/import/template">下载模板</a>
		</form>
	</div>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/oa/expense/projectlist">项目管理</a></li>
		<shiro:hasPermission name="oa:expense:edit"><li><a href="${ctx}/oa/expense/form">经费申请</a></li></shiro:hasPermission>
		<li><a href="${ctx}/oa/expense/list">所有任务</a></li>
		<li><a href="${ctx}/oa/expense/task">待办任务</a></li>
	</ul>
	<tags:message content="${message}"/>
	<form:form id="searchForm" modelAttribute="project" action="${ctx}/oa/expense/projectlist" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<div>
			<label>申请编号：&nbsp;</label><form:input path="ids" htmlEscape="false" maxlength="50" class="input-medium" placeholder="多个用逗号或空格隔开"/>
			<label>立项号：&nbsp;</label><form:input path="projectNo" htmlEscape="false" maxlength="50" class="input-medium"/>
			&nbsp;<label>只看本人：&nbsp;</label><form:checkbox id="selfOnly" path="selfOnly" />
		</div>
		<div style="margin-top:8px;">
			<label>项目起止时间：</label>
			<input id="createDateStart"  name="createDateStart"  type="text" readonly="readonly" maxlength="20" class="input-medium Wdate" style="width:163px;"
				value="<fmt:formatDate value="${project.createDateStart}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd'});"/>
				　--　
			<input id="createDateEnd" name="createDateEnd" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate" style="width:163px;"
				value="<fmt:formatDate value="${project.createDateEnd}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd'});"/>
			&nbsp;<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
			&nbsp;<input id="btnImport" class="btn btn-primary" type="button" value="导入"/>
		</div>
	</form:form>
	<tags:message content="${message}"/>
	<form:form id="importForm" modelAttribute="project" action="${ctx}/oa/project/uploadFile" method="post" >
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead><tr>
			<th>立项号</th>
			<th>科研项目题目</th>
			<th>创建人</th>
			<th>创建时间</th>
			<th>当前状态</th>
			<th>经费操作</th>
			<th>中期考核</th>
			<th>结题</th>
		</tr></thead>
		<tbody>
		<c:forEach items="${page.list}" var="project">
			<c:set var="task" value="${project.task }" />
			<c:set var="pi" value="${project.processInstance }" />
			<c:set var="hpi" value="${project.historicProcessInstance }" />
			<tr>
				<td>${project.projectNo}</td>
				<th>${project.projectName}</th>
				<td>${project.createBy.name}</td>
				<td>${project.createDate}</td>
				<td>${project.status.displayName}</td>
				<td>
				<c:if test="${fns:isKJDept() and project.status ne 'FINISH'}">
					<a class="handle" href="#" data-id="${project.id}">经费编辑</a>
				</c:if>
				<c:if test="${project.status.approval and project.weightBelong==fns:getUser().id and project.status ne 'FINISH'}">
					<c:if test="${not empty project.plan}">
						<a href="${ctx}/oa/expense/form?id=${project.id}">申请经费</a>
					</c:if>
					<c:if test="${empty project.plan}">
						<a onclick="saveExpensePlan(${project.id})">预算配置</a>
					</c:if>
				</c:if>
				</td>
				<td>
				<c:if test="${project.status ne 'FINISH' and fns:isKJDept() and not empty project.midTermFileTemplete}">
					<a href="${ctx}/oa/project/projectMgmt/${project.id}/midTemplete">中期考核模板：${project.midTermFileTemplete}</a>
				</c:if>
				<c:if test="${project.status ne 'FINISH' and fns:isKJDept() and empty project.midTermFileTemplete}">
					<a href="${ctx}/oa/project/projectMgmt/${project.id}/midTemplete">中期考核模板</a>
				</c:if>
				<c:if test="${project.status ne 'FINISH' and project.status.approval and project.weightBelong==fns:getUser().id and not empty project.midTermFileTemplete and not empty project.midTermFile}">
					<a href="${ctx}/oa/project/projectMgmt/${project.id}/mid">中期考核：${project.midTermFile}</a>
				</c:if>
				<c:if test="${project.status ne 'FINISH' and project.status.approval and project.weightBelong==fns:getUser().id and not empty project.midTermFileTemplete  and empty project.midTermFile}">
					<a  href="${ctx}/oa/project/projectMgmt/${project.id}/mid">中期考核</a>
				</c:if>
				</td>
				<td>
				<c:if test="${project.status ne 'FINISH' and fns:isKJDept() and empty project.endFileTemplete}">
					<a href="${ctx}/oa/project/projectMgmt/${project.id}/endTemplete">结题模板</a>
				</c:if>
				<c:if test="${project.status ne 'FINISH' and fns:isKJDept() and not empty project.endFileTemplete}">
					<a href="${ctx}/oa/project/projectMgmt/${project.id}/endTemplete">结题模板：${project.endFileTemplete}</a>
				</c:if>
				<c:if test="${project.status ne 'FINISH' and project.status.approval and project.weightBelong==fns:getUser().id and not empty project.endFileTemplete and empty project.endFile}">
					<a href="${ctx}/oa/project/projectMgmt/${project.id}/end">结题</a>
				</c:if>
				<c:if test="${project.status ne 'FINISH' and project.status.approval and project.weightBelong==fns:getUser().id and not empty project.endFileTemplete and not empty project.endFile}">
					<a href="${ctx}/oa/project/projectMgmt/${project.id}/end">结题：${project.endFile}</a>
				</c:if>
				<c:if test="${project.status ne 'FINISH' and fns:isKJDept()}">
					<a href="${ctx}/oa/expense/close?id=${project.id}">关闭项目</a>
				</c:if>
				</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	</form:form>
	<div class="pagination">${page}</div>
</body>
</html>
