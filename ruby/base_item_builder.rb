class BaseItemBuilder
  attr_reader :item

  def initialize(item)
    @item = item
  end

  def update
    quality
    sell_in
  end

  private

  def quality; end

  def sell_in; end
end
