# frozen_string_literal: true

describe SaveBook do
  # Spy
  class BookGatewaySpy
    def save(book)
      @book = book
    end

    attr_reader :book
  end

  # Mock
  class BookGatewayMock
    def initialize(suite)
      @count = 0
      @suite = suite
    end

    def save(book)
      @book = book
      @count += 1
    end

    def received_one_book(title_name, author_name)
      @suite.expect(book[:title]).to @suite.eq(title_name)
      @suite.expect(book[:author]).to @suite.eq(author_name)
      @suite.expect(@count).to @suite.eq(1)
    end

    attr_reader :book, :count
  end

  it 'returns error when no book to save' do
    save_book = SaveBook.new(book_gateway: nil)
    response = save_book.execute({})
    expect(response).to eq(successful: false, errors: :no_book_to_save)
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

  it 'can pass the book to gateway' do
    book_gateway_mock = BookGatewayMock.new(self)
    save_book = SaveBook.new(book_gateway: book_gateway_mock)
    book = {
      title: 'To Kill A Mockingbird',
      author: 'Harper Lee'
    }

    save_book.execute(book)

    book_gateway_mock.received_one_book('To Kill A Mockingbird', 'Harper Lee')
  end
end
