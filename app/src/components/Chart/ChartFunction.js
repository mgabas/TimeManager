import moment from 'moment';

export function transformdate(date){

    var time = new Object;
    let startDate = new Date(date.start);
    let endDate = new Date(date.end);
    var difference= Math.abs(startDate-endDate);
    var hours = difference/1000/3600;
    // var day = findDate(startDate);
    var day = moment(startDate).format('D MMMM YYYY');

    time.date = day;
    time.time = hours.toFixed(1);

    return time

    };

export function findListDay(data){
    let startDate = new Date(data.start);
    var day = moment(startDate).format('D MMMM YYYY');

    return day
};

export function findBreak(arr) {
    var a = [], b = [], prev;
    var c = new Object;
    arr.sort();
    for ( var i = 0; i < arr.length; i++ ) {
        if ( arr[i] !== prev ) {
            a.push(arr[i]);
            b.push(0);
        } else {
            b[b.length-1]++;
        }
        prev = arr[i];
    }
    c.day=a;
    c.break=b;

    return c;
}

export function findHours(data){
    var time = 0
    for (var i = 0; i < data.length; i++){
        let startDate = new Date(data[i].start);
        let endDate = new Date(data[i].end);
        var difference= Math.abs(startDate-endDate);
        var hours = difference/1000/3600;
        time += hours
    }
    time=time.toFixed(1)
    return time;

    };