# frozen_string_literal: true

class UserStocksController < ApplicationController
  def create
    stock = Stock.check_db(params[:ticker])
    if stock.blank?
      stock = Stock.new_lookup(params[:ticker])
      stock.save
    end
    if current_user.stocks.include?(stock) == false
      @user_stock = UserStock.create(user: current_user, stock: stock)
      flash[:notice] = "Stock #{stock.name} was successfully added to your portfolio"
    else
      flash[:notice] = 'You already have this stock on your portfolio'
    end

    redirect_to my_portfolio_path
  end
end
