# frozen_string_literal: true

class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  def can_track_stock?(ticker_symbol)
    true if under_stock_limit? && stock_already_tracked?(ticker_symbol) == false
  end

  def under_stock_limit?
    current_user.stocks.count < 5
  end

  def stock_already_tracked?(ticker_symbol)
    stock = Stock.check_db(ticker_symbol)
    false unless current_user.stocks.include?(stock)
  end
end
