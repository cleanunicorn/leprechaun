###
    Moving average
###

MovingAverage = (timespan)->
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

    previousTime = false
    ret = {}

    ret.push = (time, value)->
        if (previousTime)

            # calculate moving average
            previousMa = ma
            ma = (value + (time - 1) * previousMa) / time

            # calculate variance
            # v = v + (value - previousMa) * (value - ma)

        else
            ma = value

        previousTime = true

  # Exponential Moving Average
    ret.movingAverage = ()->
        return ma


  # Variance
    ret.variance = ()->
        return v;

    return ret
###
----------------------------------------------------------------------------------------
###

# Initial data set
data_set = []
for i in [1..30]
    data_set.push Math.random() * 30

### Long moving average ###
moving_average_long_size = 15
moving_average_long = new MovingAverage(moving_average_long_size)

index = 1
for i in [data_set.length - moving_average_long_size..data_set.length - 1]
    moving_average_long.push index++, data_set[i]

data_moving_average_long = moving_average_long.movingAverage()

console.log "Long moving average #{data_moving_average_long}"

### Short moving average ###
moving_average_short_size = 5
moving_average_short = new MovingAverage(moving_average_short_size)

index = 1
for i in [data_set.length - moving_average_short_size..data_set.length - 1]
    moving_average_short.push index++, data_set[i]

data_moving_average_short = moving_average_short.movingAverage()

console.log "Short moving average #{data_moving_average_short}"

### ---- ###

lineChartData =
    labels : [1..data_set.length],
    datasets : [
        {
            fillColor : "rgba(220,220,220,0.5)",
            strokeColor : "rgba(220,220,220,1)",
            pointColor : "rgba(220,220,220,1)",
            pointStrokeColor : "#fff",
            data : data_set
        }
    ]

myLine = new Chart(document.getElementById("canvas").getContext("2d")).Line(lineChartData);