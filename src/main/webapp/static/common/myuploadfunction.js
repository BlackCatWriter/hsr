$(function () {
    $('#fileupload').fileupload({
        dataType: 'json',
        
        done: function (e, data) {
        	//$("tr:has(td)").remove();
        	var fileNames ="";
            $.each(data.result, function (index, file) {
                $("#uploaded-files").append(
                		$('<tr/>')
                		.append($('<td name="fileName"/>').text(file.fileName))
                		.append($('<td/>').text(file.fileSize))
                		.append($('<td/>').text(file.fileType))
						.append("<td><a style='cursor:pointer' onclick='deleteTr(this)'>删除</a></td>")
                		)
                fileNames += file.fileName + ",";
            });
            if(fileNames != ""){
            	if($("#file").val()){
                    $("#file").val($("#file").val()+","+fileNames.substring(0,fileNames.length-1));
				}else{
                    $("#file").val(fileNames.substring(0,fileNames.length-1));
                }
			}
            $("#progress").show();
            $("#uploaded-files").show();
        },
        
        progressall: function (e, data) {
	        var progress = parseInt(data.loaded / data.total * 100, 10);
	        $('#progress .bar').css(
	            'width',
	            progress + '%'
	        );
   		},
   		
		dropZone: $('#dropzone')
    });

});