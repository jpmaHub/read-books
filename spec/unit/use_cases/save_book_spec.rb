describe SaveBook do
  class BookGatewaySpy
    def save(book)
      @book = book
    end

    attr_reader :book
  end


  it 'returns empty array when no book to save' do
    save_book = SaveBook.new(book_gateway: nil)
    response = save_book.execute({})
    expect(response).to eq(false)
  end

  it 'uses the book gateway to save the book' do
    book_gateway_spy = BookGatewaySpy.new
    save_book = SaveBook.new(book_gateway: book_gateway_spy)
    book_details = {
      title: 'To Kill A Mockingbird',
      author: 'Harper Lee'
    }
    save_book.execute(book_details)
    expect(book_gateway_spy.book[:title]).to eq('To Kill A Mockingbird')
    expect(book_gateway_spy.book[:author]).to eq('Harper Lee')
  end
end