require 'rails_helper'

RSpec.describe Category, type: :model do
  subject { FactoryBot.create(:category) }

  context 'all required fields are present' do
    it 'is valid' do
      expect(subject).to be_valid
    end
  end

  context 'name is missing' do
    it 'is not valid' do
      subject.update(name: '')
      expect(subject.errors).to have_key(:name)
    end
  end

	context 'name is not unique' do
    before { Category.create(name: 'Same title') }
    subject { Category.create(name: 'Same title') }

    it 'is not valid' do
      expect(subject.errors[:name]).to include('has already been taken')
    end
  end

  context 'destroy category should destroy linked transactions' do
    before { FactoryBot.create(:transaction, category: subject) }

    it 'is not valid' do
      expect { subject.destroy }.to change { Transaction.count }.by(-1)
    end
  end
end
