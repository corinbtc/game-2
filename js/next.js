const Debounce = (fn, t) => {
    let delay = t || 500;
    let timer;
    // console.log(fn)
    // console.log(typeof fn)
    return function () {
        let args = arguments;
        if(timer){
            clearTimeout(timer);
        }
        timer = setTimeout(() => {
            timer = null;
            fn.apply(this, args);
        }, delay);
    }
};
