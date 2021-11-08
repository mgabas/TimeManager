export function dateDiff(date1, date2){
    var diff = {};
    var result = {};
    var tmp = date1 - date2;
 
    tmp = Math.floor(tmp/1000);
    diff.sec = tmp % 60;
 
    tmp = Math.floor((tmp-diff.sec)/60);
    diff.min = tmp % 60;
 
    tmp = Math.floor((tmp-diff.min)/60);
    diff.hour = tmp % 24;
     
    tmp = Math.floor((tmp-diff.hour)/24);
    diff.day = tmp;

    result.sec=checkNumber(diff.sec);
    result.min=checkNumber(diff.min);
    result.hour=checkNumber(diff.hour);
    result.day=checkNumber(diff.day);
     
    return result;
};
function checkNumber(n){
    var m;
    if((n/10)>=1){
        m=n;
    }else{
        m="0"+n.toString();
    };
    return m;
}
