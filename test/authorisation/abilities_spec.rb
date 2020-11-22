# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

describe 'User Role' do
  describe 'abilities' do
    subject(:ability) { Ability.new(user) }
    let(:user) { nil }

    context 'when is an editor' do
      let(:user) { create(:editor) }
      it { is_expected.to be_able_to(:create, Course) }
      it { is_expected.to be_able_to(:read, Course) }
      it { is_expected.to be_able_to(:update, Course) }
      it { is_expected.to be_able_to(:delete, Course) }
    end
    context 'when is a writer' do
      let(:user) { create(:writer) }
      it { is_expected.to be_able_to(:create, Course) }
      it { is_expected.to be_able_to(:read, Course) }
      it { is_expected.to be_able_to(:update, Course) }
      it { is_expected.to be_able_to(:delete, Course) }
    end
    context 'when is a reader' do
      let(:user) { create(:reader) }
      it { is_expected.not_to be_able_to(:create, Course) }
      it { is_expected.to be_able_to(:read, Course) }
      it { is_expected.not_to be_able_to(:update, Course) }
      it { is_expected.not_to be_able_to(:delete, Course) }
    end
    context 'when is qa' do
      let(:user) { create(:qa) }
      it { is_expected.to be_able_to(:create, Course) }
      it { is_expected.to be_able_to(:read, Course) }
      it { is_expected.to be_able_to(:update, Course) }
      it { is_expected.to be_able_to(:delete, Course) }
    end
    context 'when is an admin' do
      let(:user) { create(:admin) }
      it { is_expected.to be_able_to(:manage, Course.new) }
      it { is_expected.to be_able_to(:manage, User.new) }
      it { is_expected.to be_able_to(:manage, Program.new) }
    end
  end
end
