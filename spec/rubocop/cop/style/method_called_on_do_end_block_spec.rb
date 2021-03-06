# encoding: utf-8

require 'spec_helper'

describe Rubocop::Cop::Style::MethodCalledOnDoEndBlock do
  subject(:cop) { described_class.new }

  context 'with a multi-line do..end block' do
    it 'registers an offence for a chained call' do
      inspect_source(cop, ['a do',
                           '  b',
                           'end.c'])
      expect(cop.offences).to have(1).item
      expect(cop.highlights).to eq(['end.c'])
    end

    it 'accepts it if there is no chained call' do
      inspect_source(cop, ['a do',
                           '  b',
                           'end'])
      expect(cop.offences).to be_empty
    end

    it 'accepts a chained block' do
      inspect_source(cop, ['a do',
                           '  b',
                           'end.c do',
                           '  d',
                           'end'])
      expect(cop.offences).to be_empty
    end
  end

  context 'with a single-line do..end block' do
    it 'registers an offence for a chained call' do
      inspect_source(cop, ['a do b end.c'])
      expect(cop.offences).to have(1).item
      expect(cop.highlights).to eq(['end.c'])
    end

    it 'accepts a single-line do..end block with a chained block' do
      inspect_source(cop, ['a do b end.c do d end'])
      expect(cop.offences).to be_empty
    end
  end

  context 'with a {} block' do
    it 'accepts a multi-line block with a chained call' do
      inspect_source(cop, ['a {',
                           '  b',
                           '}.c'])
      expect(cop.offences).to be_empty
    end

    it 'accepts a single-line block with a chained call' do
      inspect_source(cop, ['a { b }.c'])
      expect(cop.offences).to be_empty
    end
  end
end
