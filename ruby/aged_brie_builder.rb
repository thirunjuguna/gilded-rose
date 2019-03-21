require_relative './base_item_builder.rb'
class AgedBrieBuilder < BaseItemBuilder
  private

  def quality
    quality = if item.sell_in > 0
                item.quality + 1
              else
                item.quality + 2
              end

    item.quality = quality if quality <= 50
  end

  def sell_in
    item.sell_in -= 1
  end
end