require 'rails_helper'

RSpec.describe Transaction, type: :model do
  subject { FactoryBot.create(:transaction) }

  context 'all required fields are present' do
    it 'is valid' do
      expect(subject).to be_valid
    end
  end

  context 'description is missing' do
    it 'is not valid' do
      subject.update(description: '')
      expect(subject.errors).to have_key(:description)
    end
  end

  describe '#set_spending' do
    context 'amount is positive' do
      it 'is false' do
        subject.update(amount: 12.0)
        expect(subject.spending).to be false
      end
    end

    context 'amount is negative' do
      it 'is true' do
        subject.update(amount: -12.0)
        expect(subject.spending).to be true
      end
    end
  end

end
