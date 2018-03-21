require 'spec_helper'
require './ruvm'

describe 'ruvm' do
  describe 'Evaluator' do
    let(:evaluator) { Evaluator.new }

    describe '#dispatch' do
      before { evaluator.dispatch instructions }
      subject { evaluator.stack }

      context ':nop' do
        let(:instructions) { [:nop] }

        it { is_expected.to eq [] }
      end

      context ':add' do
        let(:instructions) { [:add, 1, 2] }

        it { is_expected.to eq [3] }
      end
    end
  end

  describe 'Parser' do
    describe '#parse' do
      subject { Parser.parse program }

      let(:program) { "this is a 723
                      test program 100
                      5.51 versions" }
      it { is_expected.to eq [[:this, :is, :a, 723], [:test, :program, 100], [5, :versions]] }
    end

    describe '#tokenize' do
      subject { Parser.tokenize program }

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

    describe '#convert' do
      subject { Parser.convert token }

      context 'String' do
        let (:token) { 'hogehoge' }

        it { is_expected.to eq :hogehoge }
      end

      context 'Integer' do
        let (:token) { '27362' }

        it { is_expected.to eq 27362 }
      end

      context 'Float' do
        let (:token) { '3.14' }

        it { is_expected.to eq 3 }
      end
    end

    describe '#read_lines' do
      subject { Parser.read_lines lines }

      context '1 word in each line' do
        let(:lines) { ["hoge", "10", "5.5"] }

        it { is_expected.to eq [[:hoge], [10], [5]] }
      end

      context 'more than 1 word in each line' do
        let(:lines) { ["hoge 10 5.5", "piyo 15 3.3"] }

        it { is_expected.to eq [[:hoge, 10, 5], [:piyo, 15, 3]] }
      end
    end
  end
end
