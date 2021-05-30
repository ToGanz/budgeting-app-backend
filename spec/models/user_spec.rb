require 'rails_helper'

RSpec.describe User, type: :model do
  subject { FactoryBot.create(:user) }

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

  context 'password is missing' do
    it 'is not valid' do
      subject.update(password_digest: '')
      expect(subject.errors).to have_key(:password_digest)
    end
  end

  context 'email is missing' do
    it 'is not valid' do
      subject.update(email: '')
      expect(subject.errors).to have_key(:email)
    end
  end

  context 'email has the wrong format' do
    it 'is not valid' do
      subject.update(email: 'test.com')
      expect(subject.errors).to have_key(:email)
    end
  end

  context 'email is not unique' do
    before { User.create(name: 'Burger', email: 'test@test.com', password: 'password') } 
    subject { User.create(name: 'Burger 3', email: 'test@test.com', password: 'password') }

    it 'is not valid' do
      expect(subject.errors[:email]).to include('has already been taken')
    end 
  end

  context 'destroy user should destroy linked plans' do
    before { FactoryBot.create(:plan, user: subject) }

    it 'is not valid' do
      expect { subject.destroy }.to change { Plan.count }.by(-1)
    end
  end
end
