require_relative './base_item_builder.rb'
class ConjuredManaCakeBuilder < BaseItemBuilder
  private

  def quality
    quality = item.quality - 2
    item.quality = quality if quality >= 0
  end

  def sell_in
    item.sell_in -= 1
  end
end
