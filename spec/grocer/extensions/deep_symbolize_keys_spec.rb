require 'grocer/extensions/deep_symbolize_keys'

describe Grocer::Extensions::DeepSymbolizeKeys do
  let(:nested_strings) { { 'a' => { 'b' => { 'c' => 3 } } } }
  let(:nested_symbols) { { :a => { :b => { :c => 3 } } } }
  let(:nested_mixed) { { 'a' => { :b => { 'c' => 3 } } } }
  let(:nested_fixnums) { {  0  => { 1  => { 2 => 3} } } }
  let(:nested_illegal_symbols) { { [] => { [] => 3} } }
  before do
    nested_symbols.extend described_class
    nested_strings.extend described_class
    nested_mixed.extend described_class
    nested_fixnums.extend described_class
    nested_illegal_symbols.extend described_class
  end

  it 'does not change nested symbols' do
    expect(nested_symbols.deep_symbolize_keys).to eq(nested_symbols)
  end

  it 'symbolizes nested strings' do
    expect(nested_strings.deep_symbolize_keys).to eq(nested_symbols)
  end

  it 'symbolizes a mix of nested strings and symbols' do
    expect(nested_mixed.deep_symbolize_keys).to eq(nested_symbols)
  end

  it 'preserves fixnum keys' do
    expect(nested_fixnums.deep_symbolize_keys).to eq(nested_fixnums)
  end

  it 'preserves keys that cannot be symbolized' do
    expect(nested_illegal_symbols.deep_symbolize_keys).to eq(nested_illegal_symbols)
  end
end
