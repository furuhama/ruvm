require 'spec_helper'
require './ruvm'

describe 'ruvm' do
  describe '#parse' do
    subject { parse program }

    context 'just string' do
      let(:program) { "this
                      is
                      a
                      test
                      program" }

      it { is_expected.to eq ["this", "is", "a", "test", "program"] }
    end

    context 'more than one word in each line' do
      let(:program) { "this is a
                      test program
                      for
                      ruby simple stack machine" }

      it { is_expected.to eq ["this is a", "test program", "for", "ruby simple stack machine"] }
    end
  end
end
