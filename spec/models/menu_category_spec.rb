# frozen_string_literal: true

require 'rails_helper'
RSpec.describe MenuCategory, type: :model do
  # Association test
  it { should have_many(:menu_items).dependent(:destroy) }
  it { should validate_presence_of(:name) }
  it { should belong_to(:restaurant) }
end
