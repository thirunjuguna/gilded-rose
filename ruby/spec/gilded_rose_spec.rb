require 'spec_helper'

RSpec.describe GildedRose do
  let(:items) do
    [
      Item.new('+5 Dexterity Vest', 10, 20),
      Item.new('Aged Brie', 2, 0),
      Item.new('Elixir of the Mongoose', 5, 7),
      Item.new('Sulfuras, Hand of Ragnaros', 0, 80),
      Item.new('Sulfuras, Hand of Ragnaros', -1, 80),
      Item.new('Backstage passes to a TAFKAL80ETC concert', 15, 20),
      Item.new('Backstage passes to a TAFKAL80ETC concert', 10, 49),
      Item.new('Backstage passes to a TAFKAL80ETC concert', 5, 49),
      Item.new('Conjured Mana Cake', 3, 6) # <-- :O
    ]
  end

  describe '#update_quality' do
    subject { described_class }

    it 'does not change the name' do
      subject.new(items).update_quality
      expect(items[0].name).to eq '+5 Dexterity Vest'
    end

    it 'At the end of each day our system lowers sellIn for every item' do
      subject.new(items).update_quality
      expect(items[0].sell_in).to be < 10
    end

    it 'At the end of each day our system lowers quality for every item' do
      subject.new(items).update_quality
      expect(items[0].quality).to be < 20
    end

    it 'The Quality of an item is never negative' do
      item = Item.new('Item Test', 0, 0)
      described_class.new([item]).update_quality
      expect(item.quality).to eq(0)
    end

    it 'Once the sell by date has passed, Quality degrades twice as fast' do
      item = Item.new('foo', 0, 4)
      described_class.new([item]).update_quality
      expect(item.quality).to eq(2)
    end

    it '"Aged Brie" actually increases in Quality the older it gets' do
      n = 5
      item = Item.new('Aged Brie', n, 0)
      gilded_rose = described_class.new([item])
      n.times do |i|
        gilded_rose.update_quality
        expect(item.quality).to eq(i + 1)
      end
      expect(item.quality).to eq(n)
    end

    it 'The Quality of an item is never more than 5' do
      n = 2
      item = Item.new('Aged Brie', n, 49)
      gilded_rose = described_class.new([item])
      n.times do
        gilded_rose.update_quality
      end
      expect(item.quality).to eq(50)
    end

    context '"Sulfuras", being a legendary item' do
      it 'never has to be sold' do
        item = Item.new('Sulfuras, Hand of Ragnaros', 0, 0)
        gilded_rose = described_class.new([item])
        gilded_rose.update_quality
        expect(item.sell_in).to eq(0)
      end

      it 'never decreases in Quality' do
        item = Item.new('Sulfuras, Hand of Ragnaros', 0, 0)
        gilded_rose = described_class.new([item])
        gilded_rose.update_quality
        expect(item.quality).to eq(0)
      end
    end

    it 'Aged brie, increases in Quality as its SellIn value approaches;' do
      n = 5
      item = Item.new('Aged Brie', n, 0)
      gilded_rose = described_class.new([item])
      n.times do |i|
        gilded_rose.update_quality
        expect(item.quality).to eq(i + 1)
      end
      expect(item.quality).to eq(n)
    end

    context 'when there are 10 days or less' do
      it 'Backstage passes increases by 2 the older it gets ' do
        n = 5
        quality = 1
        item = Item.new('Backstage passes to a TAFKAL80ETC concert', 10, quality)
        gilded_rose = described_class.new([item])
        n.times do |i|
          gilded_rose.update_quality
          expect(item.quality).to eq(quality + 2 * (i + 1))
        end
        expect(item.quality).to eq(quality + (2 * n))
      end
    end

    it 'Backstage passes increases by 3 the older it gets' do
      n = 5
      quality = 1
      item = Item.new('Backstage passes to a TAFKAL80ETC concert', 5, quality)
      gilded_rose = described_class.new([item])
      n.times do |i|
        gilded_rose.update_quality
        expect(item.quality).to eq(quality + 3 * (i + 1))
      end
      expect(item.quality).to eq(quality + (3 * n))
    end

    it 'Backstage passes drops to 0 after the concert' do
      item = Item.new('Backstage passes to a TAFKAL80ETC concert', 0, 5)
      described_class.new([item]).update_quality
      expect(item.quality).to eq(0)
    end
    it '"Conjured" items degrade in Quality twice as fast as normal items' do
      item = Item.new('Conjured Mana Cake', 1, 2)
      described_class.new([item]).update_quality

      expect(item.quality).to eq(0)
    end
  end
end

RSpec.describe Item do
  subject { described_class }

  describe '#initialize' do
    it 'it an instance of class Item' do
      new_item = subject.new('name', 'sell_in', 'quality')
      expect(new_item).to be_an_instance_of Item
    end
  end

  describe '#to_s' do
    it 'returns name sell_in and quality as string' do
      new_item = subject.new('name', 'sell_in', 'quality')
      expect(new_item.to_s).to eq('name, sell_in, quality')
    end
  end
end
