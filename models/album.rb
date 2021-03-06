require( 'pg' )
require_relative('../db/sql_runner.rb')
require_relative('./artist.rb')

class Album

  attr_reader :id, :title, :artist_id, :stock_level, :buy_price, :sell_price

  def initialize( params )
    @id = params['id']
    @title = params['title']
    @artist_id = params['artist_id']
    @stock_level = params['stock_level'].to_i
    @buy_price = params['buy_price'].to_i
    @sell_price = params['sell_price'].to_i
  end

  def save()
    sql = "INSERT INTO Albums (title, artist_id, stock_level, buy_price, sell_price) VALUES ('#{@title}', '#{@artist_id}', #{@stock_level}, #{@buy_price}, #{@sell_price})"
    SqlRunner.run_sql(sql)
    return last_entry
  end

  def check_stock()
    if @stock_level >= 10 
      return "High Stock"
    elsif @stock_level >= 5 && @stock_level < 10
      return "Medium Stock"
    else
      return "Low Stock"
    end
  end

  def markup_value
    result = @sell_price - @buy_price
    return result
  end

  def profit_loss
    if markup_value > 0
      return "Profit"
    elsif markup_value < 0
      return "Loss"
    else
      return "Even"
    end
  end

  def last_entry()
    sql = "SELECT * FROM Albums ORDER BY id DESC limit 1"
    return Album.map_item(sql)
  end

  def self.update(params)
    sql = "UPDATE Albums SET title = '#{params['title']}', artist_id = #{params['artist_id']}, stock_level = #{params['stock_level']}, buy_price = #{params['buy_price']}, sell_price = #{params['sell_price']} WHERE id = #{params['id']}"
    SqlRunner.run_sql(sql)
  end

  def self.find(id)
    sql = "SELECT * FROM Albums WHERE id = #{id}"
    result = Album.map_item(sql)
    return result
  end

  def self.delete(id)
    sql = "DELETE FROM Albums WHERE id = #{id}"
    SqlRunner.run_sql(sql)
  end

  def self.delete_all
    sql = "DELETE FROM Albums"
    SqlRunner.run_sql(sql)
  end

  def self.all()
    sql = "SELECT * FROM Albums"
    return Album.map_items(sql)
  end

  def self.map_item(sql)
    result = Album.map_items(sql)
    return result.first    
  end

  def self.map_items(sql)
    album = SqlRunner.run_sql(sql)
    result = album.map { |al| Album.new(al)}
    return result     
  end

end