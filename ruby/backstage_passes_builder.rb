require_relative './base_item_builder.rb'
class BackstagePassesBuilder < BaseItemBuilder
  private

  def quality
    quality = if item.sell_in > 10
                item.quality + 1
              elsif item.sell_in > 5
                item.quality + 2
              elsif item.sell_in > 0
                item.quality + 3
              else
                0
              end

    item.quality = quality if quality <= 50
    item.quality = 50 if quality > 50
  end

  def sell_in
    item.sell_in -= 1
  end
end
