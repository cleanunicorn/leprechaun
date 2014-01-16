// Generated by CoffeeScript 1.6.3
(function() {
  var MovingAverage, exports;

  exports = module.exports = MovingAverage = function(timespan) {
    var E, exp, ma, pow, previousTime, ret, v;
    exp = Math.exp;
    pow = Math.pow;
    E = Math.E;
    if (typeof timespan !== 'number') {
      console.log('must provide a timespan to the moving average constructor');
    }
    if (timespan <= 0) {
      console.log('must provide a timespan > 0 to the moving average constructor');
    }
    ma = 0;
    v = 0;
    previousTime = 0;
    ret = {};
    ret.push = function(time, value) {
      var previousMa;
      if (previousTime) {
        previousMa = ma;
        ma = (value + previousTime * previousMa) / time;
      } else {
        ma = value;
      }
      return previousTime = time;
    };
    ret.movingAverage = function() {
      return ma;
    };
    ret.variance = function() {
      return v;
    };
    return ret;
  };

}).call(this);
