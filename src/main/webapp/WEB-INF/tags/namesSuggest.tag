<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ attribute name="id" type="java.lang.String" required="true" description="编号"%>
<%@ attribute name="name" type="java.lang.String" required="true" description="标签名"%>
<%@ attribute name="value" type="java.lang.String" required="true" description="隐藏域值（ID）"%>
<%@ attribute name="url" type="java.lang.String" required="true" description="数据地址"%>
<%@ attribute name="cssClass" type="java.lang.String" required="false" description="css样式"%>
<%@ attribute name="labelValue" type="java.lang.String" required="false" description="输入框值（Name）"%>
<style type="text/css">  
.s_ipt {  
    width: 200px;  
    height: 30px;  
    font: 16px/ 22px arial;  
    background: #fff;  
    outline: 0;  
    -webkit-appearance: none;  
}
.s_wds {  
    height: 50px;
    font-size: 13px;
    background: #fff;  
    display: none;  
    z-index:1000;
    position:absolute;
}  

.itemLabel {
	border: #000000 1px dotted;
	margin-right: 10px;
	padding-left: 5px;
	padding-right: 5px;
}
.customerTag{

}

a.del_link:link  { 
	text-decoration: none;
}

a.del_link:visited {
	text-decoration: none;
}

a.del_link:hover {
	text-decoration: none;
}

a.del_link:active {
	text-decoration: none;
}
</style> 
<div class="customerTag">
<input id="${id}Id" type="hidden" name="${name}" class="${cssClass}" value="${value}"/>
<label id="${id}select">
<%
	if(labelValue!=null&&labelValue!=""){
	String[] itemNameArray = labelValue.split(",");
	String[] itemValueArray = value.split(",");
	for (int i = 0; i < itemNameArray.length; i++) {
		String itemName = itemNameArray[i];
		String itemValue = itemValueArray[i];
		if (itemName == null || itemName.trim().length() == 0
				|| itemValue == null || itemValue.trim().length() == 0) {
			continue;
		}
%>
		<label class="itemLabel"><%=itemName %><a href="#" class="del_link" onclick="removeItem${id}(this, '<%=itemValue %>');">&nbsp;X</a></label>
<%
	}
	}
%>
</label>
<input type="text" id="${id}keyword" class="s_ipt" /><span style="color:#aaa">输入姓名首字母</span>
<div> 
	<select id="${id}words" multiple="multiple" size="5" class="s_wds"></select>
</div>
</div>
<script type="text/javascript">
$("#${id}words").empty().hide();
$("#${id}keyword").keyup(function(event){
    var keyVal = $(this).val();
    var keyVal1 =  $(this).val()
    if ("" == keyVal) {  
        $("#${id}words").empty().hide();
        $("#${id}keyword").val(""); 
        return;
    }  
    keyVal=keyVal+"@"+$("#${id}Id").val();
    $.post('${url}',{  
		keys: '',
		values: keyVal,
		types: ''
    },function(data) {
        $("#${id}words").empty();
        var offset = $("#${id}keyword").offset();
        $("#${id}words").css({
			width: $("#${id}keyword").width() + 15,
			top: offset.top + $("#${id}keyword").offsetHeight,
			left: offset.left
		})
        var jsonusers = data;  
        for (var i = 0; i < jsonusers.length; i++) {  
           var jsonuser = jsonusers[i];
           var $optu = $("<option></option>");  
           var value=jsonuser.name+"("+jsonuser.no+")--"+jsonuser.officeName;
           $optu.text(value);  
           $optu.val(jsonuser.id);
           $("#${id}words").append($optu).show();  
        }
        if(data.length == 0){
            var $optu = $("<option></option>");
            $optu.text(keyVal1);
            $optu.val(keyVal1);
            $("#${id}words").append($optu).show();
        }
     }, "json");
});
$("#${id}words").bind("dblclick", function() {  
	var oldIds=$("#${id}Id").val();
	var newId=$(this).val();
	if(oldIds){
		$("#${id}Id").val(oldIds+','+newId);
	}else{
		$("#${id}Id").val(newId);
	}
	var oldValue=$("#${id}select").html();
	var item = $(this).find("option:selected").text();
	var itemHtml = "<label class='itemLabel'>" + item + "<a href='#' class='del_link' onclick='removeItem${id}(this, " + newId + ");'>&nbsp;X</a></label>"
	var newValue=oldValue+itemHtml;
    $("#${id}select").html(newValue); 
    $("#${id}keyword").val(''); 
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
    	var oldIds=$("#${id}Id").val();
    	var newId=$(this).val();
    	if(oldIds){
    		$("#${id}Id").val(oldIds+','+newId);
    	}else{
    		$("#${id}Id").val(newId);
    	}
    	var oldValue=$("#${id}select").html();
    	var item = $(this).find("option:selected").text();
    	var itemHtml = "<label class='itemLabel'>" + item + "<a href='#' class='del_link' onclick='removeItem${id}(this, " + newId + ");'>&nbsp;X</a></label>"
    	var newValue=oldValue+itemHtml;
        $("#${id}select").html(newValue); 
        $("#${id}keyword").val(''); 
        $("#${id}words").empty().hide();  
	}  
});

function removeItem${id}(elem, id) {
	$(elem).parent().remove();
	var ids = $('#${id}Id').val();
	var idArray = ids.split(",");
	var newIds = "";
	var isRemoved = false;
	for (var i = 0; i < idArray.length; i++) {
		if (!isRemoved && id == idArray[i]) {
			isRemoved = true;
			continue;
		}
		if(newIds == ""){
			newIds += idArray[i];
		}else{
			newIds += "," + idArray[i];
		}
	}
	$("#${id}Id").val(newIds);
}
</script>