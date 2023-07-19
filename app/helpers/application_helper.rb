module ApplicationHelper
    # 渡されたurlのソート部分のクエリパラメータを渡した文字に置き換える独自メソッド
  def sort_by_sort_url(url, order)
    url.gsub(/%5Bs%5D=\w+\+\w+/, "%5Bs%5D=#{order}")
  end
end
