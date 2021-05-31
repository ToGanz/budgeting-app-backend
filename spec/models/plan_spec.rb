require 'rails_helper'

RSpec.describe Plan, type: :model do
  subject { FactoryBot.create(:plan) }

  context 'all required fields are present' do
    it 'is valid' do
      expect(subject).to be_valid
    end
  end

  context 'title is missing' do
    it 'is not valid' do
      subject.update(title: '')
      expect(subject.errors).to have_key(:title)
    end
  end

  context 'destroy plan should destroy linked transactions' do
    before { FactoryBot.create(:transaction, plan: subject) }

    it 'is not valid' do
      expect { subject.destroy }.to change { Transaction.count }.by(-1)
    end
  end
end
