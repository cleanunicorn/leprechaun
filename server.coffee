KrakenClient = require 'kraken-api'

# Config
kraken_config = require './kraken-config'
kraken_api_key = kraken_config.api_key
kraken_api_secret = kraken_config.api_secret

kraken = new KrakenClient \
    kraken_api_key
    , kraken_api_secret

# Set up moving average
MA = require './js/moving_average/moving_average'

invested = true

# Get balance
kraken.api \
    'Balance'
    , null
    , (error, data)->

        console.log "Balance"

        if error
            console.log error
        else
            console.log data

get_market_price = (callback)->

    console.log "Getting market prices"

    kraken.api \
        'Ticker'
        , {
            'pair': 'XXBTZEUR'
        }
        , (error, data) ->
            prices = {}

            if error
                console.log error
            else
                prices =
                    'market_buy': data.result['XXBTZEUR']['a'][0]
                    'market_sell': data.result['XXBTZEUR']['b'][0]

            if callback
                callback(error, prices)

# Sell
sell = ()->
    get_market_price \
        (error, prices)->
            console.log "TRANSACTION Selling at #{prices.market_sell}"
            invested = false

# Sell
buy = ()->
    get_market_price \
        (error, prices)->
            console.log "TRANSACTION Buying at #{prices.market_buy}"
            invested = true


check_moving_average = ()->
    console.log "-----------------------------------"
    kraken.api \
        'Trades'
        ,{
            'pair' : 'XXBTZEUR'
        }
        , (error, data)->
            if error
                console.log error
            else
                #BTZEUR
                data_set = data.result['XXBTZEUR']
                console.log "Data set length #{data_set.length}"

                # Moving average
                ma_long_size = 500
                ma_short_size = 50

                # Moving average long
                ma_long = new MA(ma_long_size)
                for i in [data_set.length - ma_long_size..data_set.length - 1]
                    # console.log "#{data_set[i]}"
                    ma_long.push i, parseInt(data_set[i][0], 10)

                ma_long_value = ma_long.movingAverage()
                console.log "Moving average for last #{ma_long_size} = #{ma_long_value}"

                # Moving average short
                ma_short = new MA(ma_short_size)
                for i in [data_set.length - ma_short_size..data_set.length - 1]
                    # console.log "#{data_set[i]}"
                    ma_short.push i, parseInt(data_set[i][0], 10)

                ma_short_value = ma_short.movingAverage()
                console.log "Moving average for last #{ma_short_size} = #{ma_short_value}"

                # Check if we should and can buy
                least_difference = 4

                if (ma_short_value + least_difference < ma_long_value) and invested
                    console.log "Going down let's sell"

                    # Sell all
                    sell()

                    invested = true
                else if (ma_short_value - least_difference > ma_long_value) and not invested
                    console.log "Going up let's buy"

                    # Buy as much as you can
                    buy()

                    invested = false
                else
                    console.log "Least difference is #{least_difference}"
                    console.log "Difference is #{Math.abs(ma_short_value - ma_long_value)}"
                    console.log "Invested = #{invested}"

                # Sleep for a while
                setTimeout check_moving_average, 10000



check_moving_average()

