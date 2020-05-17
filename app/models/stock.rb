# frozen_string_literal: true

require 'json'
class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks
  validates :name, :ticker, presence: true
  def self.new_lookup(ticker_symbol)
    url = URI('https://apidojo-yahoo-finance-v1.p.rapidapi.com/stock/v2/get-summary?region=US&symbol=' + ticker_symbol)

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request['x-rapidapi-host'] = 'apidojo-yahoo-finance-v1.p.rapidapi.com'
    request['x-rapidapi-key'] = '3e6cc47ca5msh44e4a824e0c9feap1f89d8jsnf8d84bdce844'

    response = http.request(request)
    begin
      test = JSON.parse(response.body)
      name = test['price']['shortName']
      price = test['price']['regularMarketPrice']['raw']
      new(ticker: ticker_symbol, name: name,
          price: price)
    rescue StandardError => e
      nil
    end
  end

  def self.check_db(ticker_symbol)
    where(ticker: ticker_symbol).first
  end
end
