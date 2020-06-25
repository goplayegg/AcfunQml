.pragma library

function formatTime(second) {
    return [parseInt(second / 60 / 60),
            parseInt(second / 60) % 60,
            second % 60].join(":").replace(/\b(\d)\b/g, "0$1");
}


//使用方法
//var a=new Date();
//fmtTime(a, "yyyy-MM-dd hh:mm:ss")//年月日时分秒
function fmtTime(date, fmt) {
    var o = {
        "M+" : date.getMonth() + 1, //月份
        "d+" : date.getDate(), //日
        "h+" : date.getHours(), //小时
        "m+" : date.getMinutes(), //分
        "s+" : date.getSeconds(), //秒
        "q+" : Math.floor((date.getMonth() + 3) / 3), //季度
        "S" : date.getMilliseconds() //毫秒
    };
    if (/(y+)/.test(fmt))
        fmt = fmt.replace(RegExp.$1, (date.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
        if (new RegExp("(" + k + ")").test(fmt))
            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
}

//make key=value&key2=value2
function fmtQueryBody(keyVal){
    var ret = "";
    for(var key in keyVal){
        if(ret !== ""){
            ret+="&";
        }
        ret +=(key+'='+keyVal[key]);
    }
    return ret;
}

function insertStr(soure, start, newStr){
   return soure.slice(0, start) + newStr + soure.slice(start);
}

function makeTransparent(rgb, a){
    return insertStr(String(rgb), 1, a)
}
