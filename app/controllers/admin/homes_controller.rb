class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!
  
  def top
    # 日別の投稿数を取得するクエリ（Postモデルのスコープを使用）
    @daily_post_chart_data = Post.group_by_day_count

    # 月別の投稿数を取得するクエリ（Postモデルのスコープを使用）
    @monthly_post_chart_data = Post.group_by_month_count

    # 日別の会員登録数を取得するクエリ（Customerモデルのスコープを使用）
    @daily_customer_chart_data = Customer.group_by_day_count

    # 月別の会員登録数を取得するクエリ（Customerモデルのスコープを使用）
    @monthly_customer_chart_data = Customer.group_by_month_count
  end
end
