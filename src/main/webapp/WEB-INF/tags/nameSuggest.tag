<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ attribute name="id" type="java.lang.String" required="true" description="编号"%>
<%@ attribute name="name" type="java.lang.String" required="true"  description="标签名"%>
<%@ attribute name="value" type="java.lang.String" required="true" description="隐藏域值（ID）"%>
<%@ attribute name="url" type="java.lang.String" required="true" description="数据地址"%>
<%@ attribute name="cssClass" type="java.lang.String" required="false" description="css样式"%>
<%@ attribute name="labelValue" type="java.lang.String" required="false" description="输入框值（Name）"%>
<%@ attribute name="bindId" type="java.lang.String" required="false" description="绑定标签ID"%>
<%@ attribute name="bindValueId" type="java.lang.String" required="false" description="绑定标签值"%>
<style type="text/css">  
.s_ipt_ns {  
    width: 200px;  
    height: 30px;  
    font: 16px/ 22px arial;  
    background: #fff;  
    outline: 0;  
    -webkit-appearance: none;  
}
.s_wds_ns {  
    width: 200px;  
    height: 50px;
    font-size: 13px;
    background: #fff;  
    display: none;  
    z-index:1000;
    position:absolute;
}  
</style>
<input id="${id}Id" type="hidden" name="${name}" class="${cssClass}" value="${value}"/>
<input type="text" id="${id}keyword" autocomplete="off" class="${cssClass} s_ipt_ns"  value="${labelValue}" name="label.${name}"/><span style="color:#aaa">输入姓名首字母</span>
<div> 
	<select id="${id}words" multiple="multiple" size="5" class="s_wds_ns"></select>
</div>
<script type="text/javascript">
$("#${id}words").empty().hide();
$("#${id}keyword").keyup(function(event){
    var keyVal = $(this).val();  
    if ("" == keyVal) {  
        $("#${id}words").empty().hide();
        $("#${id}keyword").val(""); 
        return;
    }  
    $.post('${url}',{  
		keys: '',
		values: keyVal,
		types: ''
    },function(data) {
        $("#${id}words").empty();
        var jsonusers = data;  
        for (var i = 0; i < jsonusers.length; i++) {  
           var jsonuser = jsonusers[i];
           var $optu = $("<option></option>");  
           var value=jsonuser.name+"("+jsonuser.no+")--"+jsonuser.officeName;
           $optu.text(value);  
           $optu.val(jsonuser.id);
           if("${id}" == "author1"){
              $("#firstAge").val(jsonuser.age);
           }

           $("#${id}words").append($optu).show();  
        }
        if(data.length == 0){
            $("#${id}words").empty().hide();
            $("#${id}Id").val(keyVal);
            $("#${id}keyword").val(keyVal);
            //$("#firstAge").val("");
        }
     }, "json");
});
$("#${id}words").bind("dblclick", function() {  
	$("#${id}Id").val($(this).val());
	var item = $(this).find("option:selected").text();
    $("#${id}keyword").val(item); 
    if("${bindId}"!=""){
    	 $("#${bindId}").val(item); 
    	 $("#${bindValueId}").val($(this).val());
    }
    $("#${id}words").empty().hide();  
});

$("#${id}keyword").focus(function() {  
	$(this).select();
});

$("#${id}keyword").mouseover(function() {  
	$(this).select();
});

$("#${id}words").bind("keyup", function(event) {  
    var key = event.which;  
    if (key == 13) {
    	$("#${id}Id").val($(this).val());
    	var item = $(this).find("option:selected").text();
        $("#${id}keyword").val(item); 
        if("${bindId}"!=""){
       	 $("#${bindId}").val(item); 
    	 $("#${bindValueId}").val($(this).val()); 
       }
        $("#${id}words").empty().hide();  
	}  
});
</script>