require 'spec_helper'

describe Spree::Core::Search::Base do
  let(:stock_location) { create(:stock_location) }

  before do
    include ::Spree::Core::ProductFilters
    @product1 = create(:product, :name => "RoR Shirt", :name_fr => "RoR Chemise", :name_es => "RoR Camisa", :price => 9.00, :available_on => 2.days.ago)
    @product2 = create(:product, :name => "Trouser", :name_fr => "Pantalon", :name_es => "Pantalones", :price => 9.00 )
    stock_location.stock_items.update_all(count_on_hand: 1)
  end

  it "returns all products by default" do
    params = { :per_page => "" }
    searcher = Spree::Core::Search::Base.new(params)
    searcher.retrieve_products.count.should == 2
  end

  it 'return all product for default i18n' do
    params = { :per_page => "",
            :keywords => 'Shirt' }
    I18n.locale = :en
    searcher = Spree::Core::Search::Base.new(params)
    searcher.retrieve_products.should == [@product1]
  end

  it 'can return translated product name with correct i18n' do
    params = { :per_page => "",
      :keywords => 'Camisa' }
    I18n.locale = :es
    searcher = Spree::Core::Search::Base.new(params)
    searcher.retrieve_products.should == [@product1]
  end

  it 'should not return with incorrect i18n' do
    params = { :per_page => "",
      :keywords => 'Camisa' }
    I18n.locale = :fr
    searcher = Spree::Core::Search::Base.new(params)
    searcher.retrieve_products.should == []
  end

  it 'should not return product base attribute name' do
    params = { :per_page => "",
      :keywords => 'Shirt' }
    I18n.locale = :fr
    searcher = Spree::Core::Search::Base.new(params)
    searcher.retrieve_products.should == []
  end

  it 'should return product without translation' do
    create(:product, :name => "RoR Shirt", :price => 9.00)
    params = { :per_page => "" }
    I18n.locale = :fr
    searcher = Spree::Core::Search::Base.new(params)
    searcher.retrieve_products.count.should == 3
  end

end