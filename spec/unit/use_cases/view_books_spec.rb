describe ViewBooks do
  let(:book_gateway) { BookGatewayStub.new }
  
  class BookGatewayStub
    def initialize
      @books = []
    end

    def book_details(book_details)
      @books = book_details
    end

    def all
      @books
    end

  end

  it 'returns error when no books to view' do
    book_gateway.book_details([])
    view_books = ViewBooks.new(book_gateway: book_gateway)
    response = view_books.execute
    expect(response).to eq({ successful: false, errors: :no_books_to_view })
  end
end 