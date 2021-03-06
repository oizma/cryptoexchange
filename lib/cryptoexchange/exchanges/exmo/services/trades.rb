module Cryptoexchange::Exchanges
  module Exmo
    module Services
      class Trades < Cryptoexchange::Services::Market
        def fetch(market_pair)
          output = super(ticker_url(market_pair))
          adapt(output, market_pair)
        end

        def ticker_url(market_pair)
          "#{Cryptoexchange::Exchanges::Exmo::Market::API_URL}/trades/?pair=#{market_pair.base}_#{market_pair.target}"
        end

        def adapt(output, market_pair)
          output.values.first.collect do |trade|
            tr = Cryptoexchange::Models::Trade.new
            tr.trade_id  = trade['trade_id']
            tr.base      = market_pair.base
            tr.target    = market_pair.target
            tr.type      = trade['type']
            tr.price     = trade['price']
            tr.amount    = trade['amount']
            tr.timestamp = trade['date']
            tr.payload   = trade
            tr.market    = Exmo::Market::NAME
            tr
          end
        end
      end
    end
  end
end
