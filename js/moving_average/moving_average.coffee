
exports = module.exports = MovingAverage = (timespan)->
    exp = Math.exp
    pow = Math.pow
    E = Math.E

    if typeof timespan isnt 'number'
        console.log 'must provide a timespan to the moving average constructor'

    if timespan <= 0
        console.log 'must provide a timespan > 0 to the moving average constructor';

    # Moving average
    ma = 0
    # Variance
    v = 0

    previousTime = 0
    ret = {}

    ret.push = (time, value)->
        if (previousTime)

            # calculate moving average
            previousMa = ma

            k = 2 / (time + 1)

            ma = (value * k + previousMa) * (1 - k)

            # calculate variance
            # v = v + (value - previousMa) * (value - ma)

        else
            ma = value

        previousTime = time

    # Exponential Moving Average
    ret.movingAverage = ()->
        return ma


    # Variance
    ret.variance = ()->
        return v;

    return ret