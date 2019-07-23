<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>授权认证</title>
	<meta name="decorator" content="default"/>
	<style type="text/css">
      html,body,table{background-color:#f5f5f5;width:100%;height:500px;text-align:center;}.form-signin-heading{font-size:36px;margin-bottom:20px;color:#0663a2;}
      .form-signin{position:relative;text-align:left;width:400px;padding:25px 29px 29px;margin:0 auto 20px;background-color:#fff;border:1px solid #e5e5e5;
        	-webkit-border-radius:5px;-moz-border-radius:5px;border-radius:5px;-webkit-box-shadow:0 1px 2px rgba(0,0,0,.05);-moz-box-shadow:0 1px 2px rgba(0,0,0,.05);box-shadow:0 1px 2px rgba(0,0,0,.05);}
      .form-signin .checkbox{margin-bottom:10px;color:#0663a2;} .form-signin .input-label{font-size:16px;line-height:23px;color:#999;}
      .form-signin .input-block-level{font-size:16px;height:auto;margin-bottom:15px;padding:7px;*width:283px;*padding-bottom:0;_padding:7px 7px 9px 7px;}
      .form-signin .btn.btn-large{font-size:16px;} .form-signin #themeSwitch{position:absolute;right:15px;bottom:10px;}
      .form-signin div.validateCode {padding-bottom:15px;} .mid{vertical-align:middle;}
      .header{height:60px;padding-top:30px;} .alert{position:relative;width:300px;margin:0 auto;*padding-bottom:0px;}
      label.error{background:none;padding:2px;font-weight:normal;color:inherit;margin:0;}
    </style>
    <link href="${ctxStatic}/common/hsr.index.css" rel="stylesheet" type="text/css">
	<script type="text/javascript">
		$(document).ready(function() {
			$("#licenseForm").validate({
				messages: {
                    basecode: {required: "请填写申请码."},licensecode: {required: "请填写授权码."}
				},
				errorLabelContainer: "#messageBox",
				errorPlacement: function(error, element) {
					error.appendTo($("#licenseError").parent());
				} 
			});
		});
		// 如果在框架中，则跳转刷新上级页面
		if(self.frameElement && self.frameElement.tagName=="IFRAME"){
			parent.location.reload();
		}
	</script>
</head>
<body>
	<!--[if lte IE 6]><br/><div class='alert alert-block' style="text-align:left;padding-bottom:10px;"><a class="close" data-dismiss="alert">x</a><h4>温馨提示：</h4><p>你使用的浏览器版本过低。为了获得更好的浏览体验，我们强烈建议您 <a href="http://browsehappy.com" target="_blank">升级</a> 到最新版本的IE浏览器，或者使用较新版本的 Chrome、Firefox、Safari 等。</p></div><![endif]-->
	<div class="header">
		<div id="messageBox" class="alert alert-error"><button data-dismiss="alert" class="close">×</button>
			<label id="licenseError" class="error">${message}</label>
		</div>
	</div>
	<h1 class="form-signin-heading">--</h1>
	<form id="licenseForm" class="form-signin" action="${ctx}/license" method="post">
		<label class="input-label" for="basecode" >申请码</label></br>
		<textarea rows="4" id="basecode" name="basecode" class="required" >${basecode}</textarea>

		<label class="input-label" for="licensecode">授权码</label></br>
		<textarea rows="4" id="licensecode" name="licensecode" class="required" placeholder="请输入授权码">
		</textarea>

		<input class="btn btn-large btn-primary" type="submit" value="授权"/>&nbsp;&nbsp;

	</form>
	Copyright ${fns:getConfig('copyrightYear')} ${fns:getConfig('productName')} - ${fns:getConfig('version')}
</body>
</html>