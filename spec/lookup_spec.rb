#!/usr/bin/env ruby
=begin
ex_isbn = 9780671746063
ex_title = "The Hitchhiker's Guide to the Galaxy"

describe BI::GoogleLookup do
  desribe '.by_upc' do
    context 'with a valid isbn13' do
      it 'returns a valid record' do
        expect(Lookup.by_isbn(ex_isbn)[:title]).to be(ex_title)
      end
    end
    
    context 'with an invalid isbn' do
      it 'raises an error' do
        expect{Lookup.by_isbn(123)}.to raise_error(InvalidISBN)
      end
    end
  end
end
=end
