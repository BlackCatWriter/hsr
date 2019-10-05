<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<meta charset="utf-8">
	<title>ECharts</title>
	<!-- 引入 echarts.js -->
	<script src="${ctxStatic}/jquery-jbox/2.3/jquery-1.4.2.min.js" type="text/javascript"></script>
	<%@include file="/WEB-INF/views/include/dialog.jsp"%>
	<script src="${ctxStatic}/echarts/echarts.min.js" type="text/javascript"></script>
</head>
<body>
<!-- 为ECharts准备一个具备大小（宽高）的Dom -->
<div id="contain" style="width: 100%;height: auto;background-color: #2c343c;">
	<div id="contain-up" style="width:100%;height: 300px;display: flex;">
		<div id="contain-up-left" style="width:34%;height:100%;">
		</div>
		<div id="contain-up-center" style="width:34%;height:100%;">
		</div>
		<div id="contain-up-right" style="width:34%;height:100%;">
		</div>
	</div>
	<div id="contain-down" style="width:99%;height: 300px;">
	</div>
</div>

</body>
<script type="text/javascript">
    // 基于准备好的dom，初始化echarts实例
    var levelChart = echarts.init(document.getElementById('contain-up-left'));
    var bookChart = echarts.init(document.getElementById('contain-up-center'));
    var officeChart = echarts.init(document.getElementById('contain-up-right'));
    var expenseChart = echarts.init(document.getElementById('contain-down'));
    // 指定图表的配置项和数据
    var levelOption = {
        title: {
            text: '科研项目等级分布',
            left: 'center',
            top: 20,
            textStyle: {
                color: '#ccc'
            }
        },
        tooltip : {
            trigger: 'item',
            formatter: "{a} <br/>{b} : {c} ({d}%)"
        },

        series : [
            {
                name:'项目等级',
                type:'pie',
                radius : '55%',
                center: ['50%', '50%'],
                data:[].sort(function (a, b) { return a.value - b.value; }),
                roseType: 'radius',
                label: {
                    normal: {
                        textStyle: {
                            color: 'rgba(255, 255, 255, 0.3)'
                        }
                    }
                },
                labelLine: {
                    normal: {
                        lineStyle: {
                            color: 'rgba(255, 255, 255, 0.3)'
                        },
                        smooth: 0.2,
                        length: 10,
                        length2: 20
                    }
                },
                itemStyle: {
                    normal: {
                        color: '#c23531',
                        shadowBlur: 200,
                        shadowColor: 'rgba(0, 0, 0, 0.5)'
                    }
                },

                animationType: 'scale',
                animationEasing: 'elasticOut',
                animationDelay: function (idx) {
                    return Math.random() * 200;
                }
            }
        ]
    };

    /*全院发表著作比例*/
    var bookOption = {
        title: {
            text: '科研项目关联分布',
            left: 'center',
            top: 20,
            textStyle: {
                color: '#ccc'
            }
        },
        tooltip : {
            trigger: 'item',
            formatter: "{a} <br/>{b} : {c} ({d}%)"
        },
        series : [
            {
                name:'关联科目',
                type:'pie',
                radius : '55%',
                center: ['50%', '50%'],
                data:[].sort(function (a, b) { return a.value - b.value; }),
                roseType: 'radius',
                label: {
                    normal: {
                        textStyle: {
                            color: 'rgba(255, 255, 255, 0.3)'
                        }
                    }
                },
                labelLine: {
                    normal: {
                        lineStyle: {
                            color: 'rgba(255, 255, 255, 0.3)'
                        },
                        smooth: 0.2,
                        length: 10,
                        length2: 20
                    }
                },
                itemStyle: {
                    normal: {
                        color: '#c23531',
                        shadowBlur: 200,
                        shadowColor: 'rgba(0, 0, 0, 0.5)'
                    }
                },

                animationType: 'scale',
                animationEasing: 'elasticOut',
                animationDelay: function (idx) {
                    return Math.random() * 200;
                }
            }
        ]
    };

    /*全院科室项目比例*/
    var officeOption = {
        title: {
            text: '科研项目归属科室分布',
            left: 'center',
            top: 20,
            textStyle: {
                color: '#ccc'
            }
        },
        tooltip : {
            trigger: 'item',
            formatter: "{a} <br/>{b} : {c} ({d}%)"
        },
        /*visualMap: {
            show: false,
            min: 80,
            max: 600,
            inRange: {
                colorLightness: [0, 1]
            }
        },*/
        series : [
            {
                name:'所属科室',
                type:'pie',
                radius : '55%',
                center: ['50%', '50%'],
                data:[].sort(function (a, b) { return a.value - b.value; }),
                roseType: 'radius',
                label: {
                    normal: {
                        textStyle: {
                            color: 'rgba(255, 255, 255, 0.3)'
                        }
                    }
                },
                labelLine: {
                    normal: {
                        lineStyle: {
                            color: 'rgba(255, 255, 255, 0.3)'
                        },
                        smooth: 0.2,
                        length: 10,
                        length2: 20
                    }
                },
                itemStyle: {
                    normal: {
                        color: '#c23531',
                        shadowBlur: 200,
                        shadowColor: 'rgba(0, 0, 0, 0.5)'
                    }
                },

                animationType: 'scale',
                animationEasing: 'elasticOut',
                animationDelay: function (idx) {
                    return Math.random() * 200;
                }
            }
        ]
    };

    /*全院科研项目经费柱状*/
    var expenseOption = {
        title: {
            text: '科研项目经费使用情况',
            left: 40,
            textStyle: {
                color: '#ccc'
            }
        },
        tooltip : {
            trigger: 'axis',
            axisPointer : {            // 坐标轴指示器，坐标轴触发有效
                type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
            }
        },
        legend: {
            data:['项目总经费','项目已用经费','项目剩余经费'],
            textStyle:{
                fontSize:15,
                color:'#fff'
            }
        },
        grid: {
            left: '3%',
            right: '4%',
            bottom: '3%',
            containLabel: true
        },
        xAxis : [
            {
                type : 'category',
                data : ['周一','周二','周三','周四','周五','周六','周日'],
                axisLine: {
                    lineStyle: {
                        type: 'solid',
                        color: '#fff'
                    }
                },
                axisLabel: {
                    textStyle: {
                        color: '#fff'//坐标值得具体的颜色

                    }
                }
            }
        ],
        yAxis : [
            {
                type : 'value',
                axisLine: {
                    lineStyle: {
                        color:'#fff'
                    }
                },
                axisLabel: {
                    textStyle: {
                        color: '#fff'
                    }
                }
            }
        ],
        series : [
            {
                name:'项目总经费',
                type:'bar',
                data:[]
            },
            {
                name:'项目已用经费',
                type:'bar',
                data:[]
            },
            {
                name:'项目剩余经费',
                type:'bar',
                data:[]
            }
        ]
    };
    $(document).ready(function() {
        $.ajax({
            type : "post",
            url : "${ctx}/cms/project/drawEcharts",
            dataType : "json",
            success : function(json) {
                levelOption.series[0].data = json.levelArray;
                levelChart.setOption(levelOption,true);

                bookOption.series[0].data = json.bookArray;
                bookChart.setOption(bookOption,true);

                officeOption.series[0].data = json.officeArray;
                officeChart.setOption(officeOption,true);

                expenseOption.xAxis[0].data = json.projectNoArray;
                expenseOption.series[0].data = json.totleFeeArray;
                expenseOption.series[1].data = json.syFeeArray;
                expenseOption.series[2].data = json.reFeeArray;
                expenseChart.setOption(expenseOption,true);
            },
            error : function(errorMsg) {
                //请求失败时执行该函数
                $.jBox.tip("图表请求数据失败!");
            }
        });
    });
    // 使用刚指定的配置项和数据显示图表。
    if (levelOption && typeof levelOption === "object") {
        levelChart.setOption(levelOption, true);
    }
    if (bookOption && typeof bookOption === "object") {
        bookChart.setOption(bookOption, true);
    }
    if (officeOption && typeof officeOption === "object") {
        officeChart.setOption(officeOption, true);
    }
    if (expenseOption && typeof expenseOption === "object") {
        expenseChart.setOption(expenseOption, true);
    }
    window.addEventListener("resize",function (){
        expenseChart.resize();
        levelChart.resize();
        bookChart.resize();
        officeChart.resize();
    });

</script>
</html>