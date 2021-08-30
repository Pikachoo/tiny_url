require 'rails_helper'

RSpec.describe Url, type: :model do
  describe '#validations' do
      it 'should raise an error if token already exists' do
        create(:url, token: 'aaa')

        expect{create(:url, token: 'aaa')}.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Token has already been taken')
      end
  end
end
