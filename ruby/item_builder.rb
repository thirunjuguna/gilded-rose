require_relative './aged_brie_builder.rb'
require_relative './sulfuras_builder.rb'
require_relative './backstage_passes_builder.rb'
require_relative './conjured_mana_cake_builder.rb'
require_relative './default_item_builder.rb'
class ItemBuilder
  attr_reader :item

  ITEMS = {
    'Aged Brie' => AgedBrieBuilder,
    'Sulfuras, Hand of Ragnaros' => SulfurasBuilder,
    'Backstage passes to a TAFKAL80ETC concert' => BackstagePassesBuilder,
    'Conjured Mana Cake' => ConjuredManaCakeBuilder
  }.freeze

  def initialize(item)
    @item = item
  end

  def update
    item_builder.new(item).update
  end

  def self.update(item)
    new(item).update
  end

  private

  def item_builder
    @item_builder ||= ITEMS[item.name] || DefaultItemBuilder
  end
end
